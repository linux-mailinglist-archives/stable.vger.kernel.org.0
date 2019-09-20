Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89298B92AE
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391485AbfITOet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:34:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36232 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388188AbfITOZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:06 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqJ-0004y2-TZ; Fri, 20 Sep 2019 15:25:03 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqG-0007x8-NO; Fri, 20 Sep 2019 15:25:00 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Bob Peterson" <rpeterso@redhat.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.69803285@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 103/132] GFS2: don't set rgrp gl_object until it's
 inserted into rgrp tree
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Peterson <rpeterso@redhat.com>

commit 36e4ad0316c017d5b271378ed9a1c9a4b77fab5f upstream.

Before this patch, function read_rindex_entry would set a rgrp
glock's gl_object pointer to itself before inserting the rgrp into
the rgrp rbtree. The problem is: if another process was also reading
the rgrp in, and had already inserted its newly created rgrp, then
the second call to read_rindex_entry would overwrite that value,
then return a bad return code to the caller. Later, other functions
would reference the now-freed rgrp memory by way of gl_object.
In some cases, that could result in gfs2_rgrp_brelse being called
twice for the same rgrp: once for the failed attempt and once for
the "real" rgrp release. Eventually the kernel would panic.
There are also a number of other things that could go wrong when
a kernel module is accessing freed storage. For example, this could
result in rgrp corruption because the fake rgrp would point to a
fake bitmap in memory too, causing gfs2_inplace_reserve to search
some random memory for free blocks, and find some, since we were
never setting rgd->rd_bits to NULL before freeing it.

This patch fixes the problem by not setting gl_object until we
have successfully inserted the rgrp into the rbtree. Also, it sets
rd_bits to NULL as it frees them, which will ensure any accidental
access to the wrong rgrp will result in a kernel panic rather than
file system corruption, which is preferred.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -731,6 +731,7 @@ void gfs2_clear_rgrpd(struct gfs2_sbd *s
 
 		gfs2_free_clones(rgd);
 		kfree(rgd->rd_bits);
+		rgd->rd_bits = NULL;
 		return_all_reservations(rgd);
 		kmem_cache_free(gfs2_rgrpd_cachep, rgd);
 	}
@@ -925,10 +926,6 @@ static int read_rindex_entry(struct gfs2
 	if (error)
 		goto fail;
 
-	rgd->rd_gl->gl_object = rgd;
-	rgd->rd_gl->gl_vm.start = (rgd->rd_addr * bsize) & PAGE_CACHE_MASK;
-	rgd->rd_gl->gl_vm.end = PAGE_CACHE_ALIGN((rgd->rd_addr +
-						  rgd->rd_length) * bsize) - 1;
 	rgd->rd_rgl = (struct gfs2_rgrp_lvb *)rgd->rd_gl->gl_lksb.sb_lvbptr;
 	rgd->rd_flags &= ~GFS2_RDF_UPTODATE;
 	if (rgd->rd_data > sdp->sd_max_rg_data)
@@ -936,14 +933,20 @@ static int read_rindex_entry(struct gfs2
 	spin_lock(&sdp->sd_rindex_spin);
 	error = rgd_insert(rgd);
 	spin_unlock(&sdp->sd_rindex_spin);
-	if (!error)
+	if (!error) {
+		rgd->rd_gl->gl_object = rgd;
+		rgd->rd_gl->gl_vm.start = (rgd->rd_addr * bsize) & PAGE_MASK;
+		rgd->rd_gl->gl_vm.end = PAGE_ALIGN((rgd->rd_addr +
+						    rgd->rd_length) * bsize) - 1;
 		return 0;
+	}
 
 	error = 0; /* someone else read in the rgrp; free it and ignore it */
 	gfs2_glock_put(rgd->rd_gl);
 
 fail:
 	kfree(rgd->rd_bits);
+	rgd->rd_bits = NULL;
 	kmem_cache_free(gfs2_rgrpd_cachep, rgd);
 	return error;
 }


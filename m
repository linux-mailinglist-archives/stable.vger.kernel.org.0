Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8979F691
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 01:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfH0XJR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 27 Aug 2019 19:09:17 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:58903 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfH0XJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 19:09:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone.i.decadent.org.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1i2kaP-0000fp-F9; Wed, 28 Aug 2019 00:09:13 +0100
Date:   Wed, 28 Aug 2019 00:09:06 +0100
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>
Subject: [PATCH 4.4 01/13] GFS2: don't set rgrp gl_object until it's inserted
 into rgrp tree
Message-ID: <20190827230906.GA11046@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
---
 fs/gfs2/rgrp.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index ef24894edecc..9c159e6ad116 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -739,6 +739,7 @@ void gfs2_clear_rgrpd(struct gfs2_sbd *sdp)
 
 		gfs2_free_clones(rgd);
 		kfree(rgd->rd_bits);
+		rgd->rd_bits = NULL;
 		return_all_reservations(rgd);
 		kmem_cache_free(gfs2_rgrpd_cachep, rgd);
 	}
@@ -933,10 +934,6 @@ static int read_rindex_entry(struct gfs2_inode *ip)
 	if (error)
 		goto fail;
 
-	rgd->rd_gl->gl_object = rgd;
-	rgd->rd_gl->gl_vm.start = (rgd->rd_addr * bsize) & PAGE_CACHE_MASK;
-	rgd->rd_gl->gl_vm.end = PAGE_CACHE_ALIGN((rgd->rd_addr +
-						  rgd->rd_length) * bsize) - 1;
 	rgd->rd_rgl = (struct gfs2_rgrp_lvb *)rgd->rd_gl->gl_lksb.sb_lvbptr;
 	rgd->rd_flags &= ~(GFS2_RDF_UPTODATE | GFS2_RDF_PREFERRED);
 	if (rgd->rd_data > sdp->sd_max_rg_data)
@@ -944,14 +941,20 @@ static int read_rindex_entry(struct gfs2_inode *ip)
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
-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom



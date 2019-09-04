Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD28A8E2B
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387488AbfIDR4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387477AbfIDR43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:56:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC6BC22CF7;
        Wed,  4 Sep 2019 17:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619788;
        bh=Qr7LEXzDG8/H/wTonemu3EaLdSl94xNVpcak20MFaLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObG7IIjmJH5m+fa8xd/Hco9qefLx6Q0Iqr4U+6n4SzfV+42Hm//Fd7vRTEiMdf2DK
         15f50WyFljIOQYu2Ymj/0WmvRzGbev3darjeVslNtWzaC5kbYiK+DmowGGt7k2sXc5
         QCCLiUmyUDkmPiCnxDt9NIC5MS2u2utF7KA/GE4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 34/77] GFS2: dont set rgrp gl_object until its inserted into rgrp tree
Date:   Wed,  4 Sep 2019 19:53:21 +0200
Message-Id: <20190904175306.735598786@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/rgrp.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index ef24894edecc1..9c159e6ad1164 100644
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
2.20.1




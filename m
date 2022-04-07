Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930D14F6FDD
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236526AbiDGBPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236079AbiDGBPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:15:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E1518BCF7;
        Wed,  6 Apr 2022 18:11:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2252161DAE;
        Thu,  7 Apr 2022 01:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AD6C385A8;
        Thu,  7 Apr 2022 01:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293905;
        bh=wG7g1wXAwxjxIoONuKJIf9AWVdYvw9kwTURwbFlNKlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdJs4PSYiOexpPUQypLPYMLfVs07Rod6hZkoXnOMWQ+IwkfrMS/pi8aQ9+9Kms8pS
         kP5X9615MVcPFFwEptF+TZU71ynXqvsWGt1Y67JneQCHvkOyzwQ3ZawTl365NM9Wxd
         TxD/hCJOg8XhosvqXOT1MSh3wNFBzoOsy7OEaNcA2hMuzhlnfO/Saks0QErbCJPVom
         wPz2/xHigCSmkllFLWmOP/ly2HxRsL+pU8L4Nj+MyZySmdRxblIdzIILUsN4aYkQ1z
         +/TErlhVuNXJIfu0GnLoXR4x1xyqwtYVzeHeZAtz8TyzNDJ6LV8PhLvJpizj+MnQ/Y
         qsUERRRVNSqOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.16 03/30] gfs2: Switch lock order of inode and iopen glock
Date:   Wed,  6 Apr 2022 21:11:13 -0400
Message-Id: <20220407011140.113856-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011140.113856-1-sashal@kernel.org>
References: <20220407011140.113856-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 29464ee36bcaaee2691249f49b9592b8d5c97ece ]

This patch tries to fix the continual ABBA deadlocks we keep having
between the iopen and inode glocks. This switches the lock order in
gfs2_inode_lookup and gfs2_create_inode so the iopen glock is always
locked first.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 49 +++++++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 89905f4f29bb..b30ff50d17f3 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -131,7 +131,21 @@ struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned int type,
 		struct gfs2_sbd *sdp = GFS2_SB(inode);
 		struct gfs2_glock *io_gl;
 
-		error = gfs2_glock_get(sdp, no_addr, &gfs2_inode_glops, CREATE, &ip->i_gl);
+		error = gfs2_glock_get(sdp, no_addr, &gfs2_inode_glops, CREATE,
+				       &ip->i_gl);
+		if (unlikely(error))
+			goto fail;
+
+		error = gfs2_glock_get(sdp, no_addr, &gfs2_iopen_glops, CREATE,
+				       &io_gl);
+		if (unlikely(error))
+			goto fail;
+
+		if (blktype != GFS2_BLKST_UNLINKED)
+			gfs2_cancel_delete_work(io_gl);
+		error = gfs2_glock_nq_init(io_gl, LM_ST_SHARED, GL_EXACT,
+					   &ip->i_iopen_gh);
+		gfs2_glock_put(io_gl);
 		if (unlikely(error))
 			goto fail;
 
@@ -161,16 +175,6 @@ struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned int type,
 
 		set_bit(GLF_INSTANTIATE_NEEDED, &ip->i_gl->gl_flags);
 
-		error = gfs2_glock_get(sdp, no_addr, &gfs2_iopen_glops, CREATE, &io_gl);
-		if (unlikely(error))
-			goto fail;
-		if (blktype != GFS2_BLKST_UNLINKED)
-			gfs2_cancel_delete_work(io_gl);
-		error = gfs2_glock_nq_init(io_gl, LM_ST_SHARED, GL_EXACT, &ip->i_iopen_gh);
-		gfs2_glock_put(io_gl);
-		if (unlikely(error))
-			goto fail;
-
 		/* Lowest possible timestamp; will be overwritten in gfs2_dinode_in. */
 		inode->i_atime.tv_sec = 1LL << (8 * sizeof(inode->i_atime.tv_sec) - 1);
 		inode->i_atime.tv_nsec = 0;
@@ -716,13 +720,17 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	error = insert_inode_locked4(inode, ip->i_no_addr, iget_test, &ip->i_no_addr);
 	BUG_ON(error);
 
-	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, GL_SKIP, ghs + 1);
+	error = gfs2_glock_nq_init(io_gl, LM_ST_SHARED, GL_EXACT, &ip->i_iopen_gh);
 	if (error)
 		goto fail_gunlock2;
 
+	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, GL_SKIP, ghs + 1);
+	if (error)
+		goto fail_gunlock3;
+
 	error = gfs2_trans_begin(sdp, blocks, 0);
 	if (error)
-		goto fail_gunlock2;
+		goto fail_gunlock3;
 
 	if (blocks > 1) {
 		ip->i_eattr = ip->i_no_addr + 1;
@@ -731,10 +739,6 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	init_dinode(dip, ip, symname);
 	gfs2_trans_end(sdp);
 
-	error = gfs2_glock_nq_init(io_gl, LM_ST_SHARED, GL_EXACT, &ip->i_iopen_gh);
-	if (error)
-		goto fail_gunlock2;
-
 	glock_set_object(ip->i_gl, ip);
 	glock_set_object(io_gl, ip);
 	gfs2_set_iop(inode);
@@ -745,14 +749,14 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (default_acl) {
 		error = __gfs2_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
 		if (error)
-			goto fail_gunlock3;
+			goto fail_gunlock4;
 		posix_acl_release(default_acl);
 		default_acl = NULL;
 	}
 	if (acl) {
 		error = __gfs2_set_acl(inode, acl, ACL_TYPE_ACCESS);
 		if (error)
-			goto fail_gunlock3;
+			goto fail_gunlock4;
 		posix_acl_release(acl);
 		acl = NULL;
 	}
@@ -760,11 +764,11 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	error = security_inode_init_security(&ip->i_inode, &dip->i_inode, name,
 					     &gfs2_initxattrs, NULL);
 	if (error)
-		goto fail_gunlock3;
+		goto fail_gunlock4;
 
 	error = link_dinode(dip, name, ip, &da);
 	if (error)
-		goto fail_gunlock3;
+		goto fail_gunlock4;
 
 	mark_inode_dirty(inode);
 	d_instantiate(dentry, inode);
@@ -782,9 +786,10 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	unlock_new_inode(inode);
 	return error;
 
-fail_gunlock3:
+fail_gunlock4:
 	glock_clear_object(ip->i_gl, ip);
 	glock_clear_object(io_gl, ip);
+fail_gunlock3:
 	gfs2_glock_dq_uninit(&ip->i_iopen_gh);
 fail_gunlock2:
 	gfs2_glock_put(io_gl);
-- 
2.35.1


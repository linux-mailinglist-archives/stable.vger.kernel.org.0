Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1796531C0D
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241073AbiEWR3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242735AbiEWR16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B278216F;
        Mon, 23 May 2022 10:24:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C7C860B35;
        Mon, 23 May 2022 17:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1F5C385A9;
        Mon, 23 May 2022 17:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326654;
        bh=L//3dBna+EcdB3M94tHttcQc5Adhnn/g/2/48n2Md/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gl9LdG7ppciOGyvxbipiEYN0JOq2nTzZ0aVGIdIClK/E0Iqiffefu5MreGhMTkXrc
         lCXuEpdlR4hdm0CkXWIy7LqffI93ywwU+9q+U/tv1aQ7Bwu7QFrE26hJ3DLNDzGrBO
         sywgfZT4RuGblQ3yoY5lriNWLbNHwJBUpDjG5PLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 018/158] gfs2: Switch lock order of inode and iopen glock
Date:   Mon, 23 May 2022 19:02:55 +0200
Message-Id: <20220523165833.645164821@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 66a123306aec..c8ec876f33ea 100644
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




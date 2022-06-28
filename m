Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80CA55DFB6
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345273AbiF1MQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 08:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345464AbiF1MQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 08:16:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F0C25C76
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 05:16:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9E02B81D2C
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 12:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973B2C3411D;
        Tue, 28 Jun 2022 12:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656418600;
        bh=UzlmAj6GDClPJ9cIrnf34ymCb/yfnHnwx/x3d/Lx0p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VzO5Jrk9hAWN+8y/m3X8CFKZwKdg2UMh3xzNbcXgls9uQnGKtylJyy6h/y2sCALji
         Yd61tj0d56c1aEh6SyiwOz2oSrTIO/earrYdAa1qH0joEOfqPpIUbDvu1yK1loHOOE
         ghT5j7cLFkhN4ZIOuRBW8HFo7WQ+78TwwAXZlzRYx/kgn6x64QCXTunMQ8llzHHAlI
         GEiamIUlQMS+u6CE8/sOJ51IMiJYLnYaFnqZTxIhBdtYhQXdnoIHiK5XVXs1syn4FQ
         kv+VU/VmBvM1J7Nl9cVeA6KJK8InsZnTX4gZVFSHJdwm2v0k3TM/2Y8dMkRhnu9HXz
         UlApnr48Mj3/A==
From:   Christian Brauner <brauner@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        stable@vger.kernel.org
Subject: [PATCH 08/12] fs: port higher-level mapping helpers
Date:   Tue, 28 Jun 2022 14:16:16 +0200
Message-Id: <20220628121620.188722-9-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220628102244.wymkrob3cfys2h7i@wittgenstein>
References: <20220628121620.188722-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6177; i=brauner@kernel.org; h=from:subject; bh=go57pErlIITORyYSiuLwgKPvMGD5gWUr3BXLYRCx1RU=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSTt+ijQaTgt+NmGDXlZ26RN3//8NG1+2ZZZS3LXN1/ct3K6 pWi2Y0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEFsYz/JVn/7b5+VzzLblscQ37Li dwfLnx7YaxYlfwqWler1O5v/QzMnyNsza7qsY+7+8t9qqQDee2zDAz+JbcyqYgnrnb0265Hj8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit 209188ce75d0d357c292f6bb81d712acdd4e7db7 upstream.

Enable the mapped_fs{g,u}id() helpers to support filesystems mounted
with an idmapping. Apart from core mapping helpers that use
mapped_fs{g,u}id() to initialize struct inode's i_{g,u}id fields xfs is
the only place that uses these low-level helpers directly.

The patch only extends the helpers to be able to take the filesystem
idmapping into account. Since we don't actually yet pass the
filesystem's idmapping in no functional changes happen. This will happen
in a final patch.

Link: https://lore.kernel.org/r/20211123114227.3124056-9-brauner@kernel.org (v1)
Link: https://lore.kernel.org/r/20211130121032.3753852-9-brauner@kernel.org (v2)
Link: https://lore.kernel.org/r/20211203111707.3901969-9-brauner@kernel.org
Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Seth Forshee <sforshee@digitalocean.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/xfs/xfs_inode.c            |  8 ++++----
 fs/xfs/xfs_symlink.c          |  4 ++--
 include/linux/fs.h            |  8 ++++----
 include/linux/mnt_idmapping.h | 12 ++++++++----
 4 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a4f6f034fb81..2477e301fa82 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -994,8 +994,8 @@ xfs_create(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns),
-			mapped_fsgid(mnt_userns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns, &init_user_ns),
+			mapped_fsgid(mnt_userns, &init_user_ns), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1148,8 +1148,8 @@ xfs_create_tmpfile(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns),
-			mapped_fsgid(mnt_userns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns, &init_user_ns),
+			mapped_fsgid(mnt_userns, &init_user_ns), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index fc2c6a404647..a31d2e5d0321 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -184,8 +184,8 @@ xfs_symlink(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns),
-			mapped_fsgid(mnt_userns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns, &init_user_ns),
+			mapped_fsgid(mnt_userns, &init_user_ns), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 889f2e9be028..f62c1b9cd7cd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1666,7 +1666,7 @@ static inline kgid_t i_gid_into_mnt(struct user_namespace *mnt_userns,
 static inline void inode_fsuid_set(struct inode *inode,
 				   struct user_namespace *mnt_userns)
 {
-	inode->i_uid = mapped_fsuid(mnt_userns);
+	inode->i_uid = mapped_fsuid(mnt_userns, &init_user_ns);
 }
 
 /**
@@ -1680,7 +1680,7 @@ static inline void inode_fsuid_set(struct inode *inode,
 static inline void inode_fsgid_set(struct inode *inode,
 				   struct user_namespace *mnt_userns)
 {
-	inode->i_gid = mapped_fsgid(mnt_userns);
+	inode->i_gid = mapped_fsgid(mnt_userns, &init_user_ns);
 }
 
 /**
@@ -1701,10 +1701,10 @@ static inline bool fsuidgid_has_mapping(struct super_block *sb,
 	kuid_t kuid;
 	kgid_t kgid;
 
-	kuid = mapped_fsuid(mnt_userns);
+	kuid = mapped_fsuid(mnt_userns, &init_user_ns);
 	if (!uid_valid(kuid))
 		return false;
-	kgid = mapped_fsgid(mnt_userns);
+	kgid = mapped_fsgid(mnt_userns, &init_user_ns);
 	if (!gid_valid(kgid))
 		return false;
 	return kuid_has_mapping(fs_userns, kuid) &&
diff --git a/include/linux/mnt_idmapping.h b/include/linux/mnt_idmapping.h
index 0c6ab3f4c952..ee5a217de2a8 100644
--- a/include/linux/mnt_idmapping.h
+++ b/include/linux/mnt_idmapping.h
@@ -196,6 +196,7 @@ static inline kgid_t mapped_kgid_user(struct user_namespace *mnt_userns,
 /**
  * mapped_fsuid - return caller's fsuid mapped up into a mnt_userns
  * @mnt_userns: the mount's idmapping
+ * @fs_userns: the filesystem's idmapping
  *
  * Use this helper to initialize a new vfs or filesystem object based on
  * the caller's fsuid. A common example is initializing the i_uid field of
@@ -205,14 +206,16 @@ static inline kgid_t mapped_kgid_user(struct user_namespace *mnt_userns,
  *
  * Return: the caller's current fsuid mapped up according to @mnt_userns.
  */
-static inline kuid_t mapped_fsuid(struct user_namespace *mnt_userns)
+static inline kuid_t mapped_fsuid(struct user_namespace *mnt_userns,
+				  struct user_namespace *fs_userns)
 {
-	return mapped_kuid_user(mnt_userns, &init_user_ns, current_fsuid());
+	return mapped_kuid_user(mnt_userns, fs_userns, current_fsuid());
 }
 
 /**
  * mapped_fsgid - return caller's fsgid mapped up into a mnt_userns
  * @mnt_userns: the mount's idmapping
+ * @fs_userns: the filesystem's idmapping
  *
  * Use this helper to initialize a new vfs or filesystem object based on
  * the caller's fsgid. A common example is initializing the i_gid field of
@@ -222,9 +225,10 @@ static inline kuid_t mapped_fsuid(struct user_namespace *mnt_userns)
  *
  * Return: the caller's current fsgid mapped up according to @mnt_userns.
  */
-static inline kgid_t mapped_fsgid(struct user_namespace *mnt_userns)
+static inline kgid_t mapped_fsgid(struct user_namespace *mnt_userns,
+				  struct user_namespace *fs_userns)
 {
-	return mapped_kgid_user(mnt_userns, &init_user_ns, current_fsgid());
+	return mapped_kgid_user(mnt_userns, fs_userns, current_fsgid());
 }
 
 #endif /* _LINUX_MNT_IDMAPPING_H */
-- 
2.34.1


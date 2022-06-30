Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81C7561CF9
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbiF3OK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236407AbiF3OK0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:10:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF0E7B36D;
        Thu, 30 Jun 2022 06:55:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EBB86204B;
        Thu, 30 Jun 2022 13:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFC1C34115;
        Thu, 30 Jun 2022 13:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597334;
        bh=xZaMOLIUAyQhvt0htMhHL9IVnbXEGjmGLwcZx/QPWwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ezA/JTK0WdgEEi90d0SmpU7yknz6cjVHJ2JP+LoVjSqOhvE/YbUcxmNuoPGVe1pd4
         fbyAT4gtyCsTGISQCkMd7m+K/LG1mlUUMIctmJ8sgim1FDl6aaAz7xfqeL7IKJ6ZR/
         ta5bF6uhPew2DkI6RAL6VKQO+YFrQFTUU6nYvTgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seth Forshee <sforshee@digitalocean.com>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 5.15 20/28] fs: port higher-level mapping helpers
Date:   Thu, 30 Jun 2022 15:47:16 +0200
Message-Id: <20220630133233.523384488@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
References: <20220630133232.926711493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c            |    8 ++++----
 fs/xfs/xfs_symlink.c          |    4 ++--
 include/linux/fs.h            |    8 ++++----
 include/linux/mnt_idmapping.h |   12 ++++++++----
 4 files changed, 18 insertions(+), 14 deletions(-)

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
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1666,7 +1666,7 @@ static inline kgid_t i_gid_into_mnt(stru
 static inline void inode_fsuid_set(struct inode *inode,
 				   struct user_namespace *mnt_userns)
 {
-	inode->i_uid = mapped_fsuid(mnt_userns);
+	inode->i_uid = mapped_fsuid(mnt_userns, &init_user_ns);
 }
 
 /**
@@ -1680,7 +1680,7 @@ static inline void inode_fsuid_set(struc
 static inline void inode_fsgid_set(struct inode *inode,
 				   struct user_namespace *mnt_userns)
 {
-	inode->i_gid = mapped_fsgid(mnt_userns);
+	inode->i_gid = mapped_fsgid(mnt_userns, &init_user_ns);
 }
 
 /**
@@ -1701,10 +1701,10 @@ static inline bool fsuidgid_has_mapping(
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
--- a/include/linux/mnt_idmapping.h
+++ b/include/linux/mnt_idmapping.h
@@ -196,6 +196,7 @@ static inline kgid_t mapped_kgid_user(st
 /**
  * mapped_fsuid - return caller's fsuid mapped up into a mnt_userns
  * @mnt_userns: the mount's idmapping
+ * @fs_userns: the filesystem's idmapping
  *
  * Use this helper to initialize a new vfs or filesystem object based on
  * the caller's fsuid. A common example is initializing the i_uid field of
@@ -205,14 +206,16 @@ static inline kgid_t mapped_kgid_user(st
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
@@ -222,9 +225,10 @@ static inline kuid_t mapped_fsuid(struct
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



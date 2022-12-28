Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31550657B60
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbiL1PUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbiL1PUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:20:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E283C1090
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:20:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C54C61544
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C579C433D2;
        Wed, 28 Dec 2022 15:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240849;
        bh=JIS9Qvi3RBc2Iq0v21C+ECz28uh8UNXi5ppKNyKm+U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amzi4tw5mBC2cSgoj0hQqbAzwSWOP0H6TzfjKjNlanGsnK4ATpnALDRmp2TGXQNEr
         gpfXDzS6Ecz09VlT0ZicAucRTd1bPMXlGGlgqhGd8j3Imo4wj4tDzB6Spw0YqBL/kS
         W+w8Fxlfi3wWzeMMNxlQ6dxcRsOH9wyIPZmCc13U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jia Zhu <zhujia.zj@bytedance.com>,
        Jingbo Xu <jefflexu@linux.alibaba.com>,
        Chao Yu <chao@kernel.org>, Hou Tao <houtao1@huawei.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0174/1146] erofs: check the uniqueness of fsid in shared domain in advance
Date:   Wed, 28 Dec 2022 15:28:33 +0100
Message-Id: <20221228144334.882663183@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 27f2a2dcc6261406b509b5022a1e5c23bf622830 ]

When shared domain is enabled, doing mount twice with the same fsid and
domain_id will trigger sysfs warning as shown below:

 sysfs: cannot create duplicate filename '/fs/erofs/d0,meta.bin'
 CPU: 15 PID: 1051 Comm: mount Not tainted 6.1.0-rc6+ #1
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
 Call Trace:
  <TASK>
  dump_stack_lvl+0x38/0x49
  dump_stack+0x10/0x12
  sysfs_warn_dup.cold+0x17/0x27
  sysfs_create_dir_ns+0xb8/0xd0
  kobject_add_internal+0xb1/0x240
  kobject_init_and_add+0x71/0xa0
  erofs_register_sysfs+0x89/0x110
  erofs_fc_fill_super+0x98c/0xaf0
  vfs_get_super+0x7d/0x100
  get_tree_nodev+0x16/0x20
  erofs_fc_get_tree+0x20/0x30
  vfs_get_tree+0x24/0xb0
  path_mount+0x2fa/0xa90
  do_mount+0x7c/0xa0
  __x64_sys_mount+0x8b/0xe0
  do_syscall_64+0x30/0x60
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

The reason is erofs_fscache_register_cookie() doesn't guarantee the primary
data blob (aka fsid) is unique in the shared domain and
erofs_register_sysfs() invoked by the second mount will fail due to the
duplicated fsid in the shared domain and report warning.

It would be better to check the uniqueness of fsid before doing
erofs_register_sysfs(), so adding a new flags parameter for
erofs_fscache_register_cookie() and doing the uniqueness check if
EROFS_REG_COOKIE_NEED_NOEXIST is enabled.

After the patch, the error in dmesg for the duplicated mount would be:

 erofs: ...: erofs_domain_register_cookie: XX already exists in domain YY

Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20221125110822.3812942-1-houtao@huaweicloud.com
Fixes: 7d41963759fe ("erofs: Support sharing cookies in the same domain")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/fscache.c  | 47 +++++++++++++++++++++++++++++++++------------
 fs/erofs/internal.h | 10 ++++++++--
 fs/erofs/super.c    |  2 +-
 3 files changed, 44 insertions(+), 15 deletions(-)

diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index af5ed6b9c54d..6a792a513d6b 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -494,7 +494,8 @@ static int erofs_fscache_register_domain(struct super_block *sb)
 
 static
 struct erofs_fscache *erofs_fscache_acquire_cookie(struct super_block *sb,
-						    char *name, bool need_inode)
+						   char *name,
+						   unsigned int flags)
 {
 	struct fscache_volume *volume = EROFS_SB(sb)->volume;
 	struct erofs_fscache *ctx;
@@ -516,7 +517,7 @@ struct erofs_fscache *erofs_fscache_acquire_cookie(struct super_block *sb,
 	fscache_use_cookie(cookie, false);
 	ctx->cookie = cookie;
 
-	if (need_inode) {
+	if (flags & EROFS_REG_COOKIE_NEED_INODE) {
 		struct inode *const inode = new_inode(sb);
 
 		if (!inode) {
@@ -554,14 +555,15 @@ static void erofs_fscache_relinquish_cookie(struct erofs_fscache *ctx)
 
 static
 struct erofs_fscache *erofs_fscache_domain_init_cookie(struct super_block *sb,
-		char *name, bool need_inode)
+						       char *name,
+						       unsigned int flags)
 {
 	int err;
 	struct inode *inode;
 	struct erofs_fscache *ctx;
 	struct erofs_domain *domain = EROFS_SB(sb)->domain;
 
-	ctx = erofs_fscache_acquire_cookie(sb, name, need_inode);
+	ctx = erofs_fscache_acquire_cookie(sb, name, flags);
 	if (IS_ERR(ctx))
 		return ctx;
 
@@ -589,7 +591,8 @@ struct erofs_fscache *erofs_fscache_domain_init_cookie(struct super_block *sb,
 
 static
 struct erofs_fscache *erofs_domain_register_cookie(struct super_block *sb,
-						   char *name, bool need_inode)
+						   char *name,
+						   unsigned int flags)
 {
 	struct inode *inode;
 	struct erofs_fscache *ctx;
@@ -602,23 +605,30 @@ struct erofs_fscache *erofs_domain_register_cookie(struct super_block *sb,
 		ctx = inode->i_private;
 		if (!ctx || ctx->domain != domain || strcmp(ctx->name, name))
 			continue;
-		igrab(inode);
+		if (!(flags & EROFS_REG_COOKIE_NEED_NOEXIST)) {
+			igrab(inode);
+		} else {
+			erofs_err(sb, "%s already exists in domain %s", name,
+				  domain->domain_id);
+			ctx = ERR_PTR(-EEXIST);
+		}
 		spin_unlock(&psb->s_inode_list_lock);
 		mutex_unlock(&erofs_domain_cookies_lock);
 		return ctx;
 	}
 	spin_unlock(&psb->s_inode_list_lock);
-	ctx = erofs_fscache_domain_init_cookie(sb, name, need_inode);
+	ctx = erofs_fscache_domain_init_cookie(sb, name, flags);
 	mutex_unlock(&erofs_domain_cookies_lock);
 	return ctx;
 }
 
 struct erofs_fscache *erofs_fscache_register_cookie(struct super_block *sb,
-						    char *name, bool need_inode)
+						    char *name,
+						    unsigned int flags)
 {
 	if (EROFS_SB(sb)->domain_id)
-		return erofs_domain_register_cookie(sb, name, need_inode);
-	return erofs_fscache_acquire_cookie(sb, name, need_inode);
+		return erofs_domain_register_cookie(sb, name, flags);
+	return erofs_fscache_acquire_cookie(sb, name, flags);
 }
 
 void erofs_fscache_unregister_cookie(struct erofs_fscache *ctx)
@@ -647,6 +657,7 @@ int erofs_fscache_register_fs(struct super_block *sb)
 	int ret;
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
 	struct erofs_fscache *fscache;
+	unsigned int flags;
 
 	if (sbi->domain_id)
 		ret = erofs_fscache_register_domain(sb);
@@ -655,8 +666,20 @@ int erofs_fscache_register_fs(struct super_block *sb)
 	if (ret)
 		return ret;
 
-	/* acquired domain/volume will be relinquished in kill_sb() on error */
-	fscache = erofs_fscache_register_cookie(sb, sbi->fsid, true);
+	/*
+	 * When shared domain is enabled, using NEED_NOEXIST to guarantee
+	 * the primary data blob (aka fsid) is unique in the shared domain.
+	 *
+	 * For non-shared-domain case, fscache_acquire_volume() invoked by
+	 * erofs_fscache_register_volume() has already guaranteed
+	 * the uniqueness of primary data blob.
+	 *
+	 * Acquired domain/volume will be relinquished in kill_sb() on error.
+	 */
+	flags = EROFS_REG_COOKIE_NEED_INODE;
+	if (sbi->domain_id)
+		flags |= EROFS_REG_COOKIE_NEED_NOEXIST;
+	fscache = erofs_fscache_register_cookie(sb, sbi->fsid, flags);
 	if (IS_ERR(fscache))
 		return PTR_ERR(fscache);
 
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 05dc68627722..e51f27b6bde1 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -604,13 +604,18 @@ static inline int z_erofs_load_lzma_config(struct super_block *sb,
 }
 #endif	/* !CONFIG_EROFS_FS_ZIP */
 
+/* flags for erofs_fscache_register_cookie() */
+#define EROFS_REG_COOKIE_NEED_INODE	1
+#define EROFS_REG_COOKIE_NEED_NOEXIST	2
+
 /* fscache.c */
 #ifdef CONFIG_EROFS_FS_ONDEMAND
 int erofs_fscache_register_fs(struct super_block *sb);
 void erofs_fscache_unregister_fs(struct super_block *sb);
 
 struct erofs_fscache *erofs_fscache_register_cookie(struct super_block *sb,
-						     char *name, bool need_inode);
+						    char *name,
+						    unsigned int flags);
 void erofs_fscache_unregister_cookie(struct erofs_fscache *fscache);
 
 extern const struct address_space_operations erofs_fscache_access_aops;
@@ -623,7 +628,8 @@ static inline void erofs_fscache_unregister_fs(struct super_block *sb) {}
 
 static inline
 struct erofs_fscache *erofs_fscache_register_cookie(struct super_block *sb,
-						     char *name, bool need_inode)
+						     char *name,
+						     unsigned int flags)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 1c7dcca702b3..481788c24a68 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -245,7 +245,7 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 	}
 
 	if (erofs_is_fscache_mode(sb)) {
-		fscache = erofs_fscache_register_cookie(sb, dif->path, false);
+		fscache = erofs_fscache_register_cookie(sb, dif->path, 0);
 		if (IS_ERR(fscache))
 			return PTR_ERR(fscache);
 		dif->fscache = fscache;
-- 
2.35.1




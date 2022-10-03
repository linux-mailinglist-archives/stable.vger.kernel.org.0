Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26865F2A7B
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbiJCHhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbiJCHfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:35:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB61C49B40;
        Mon,  3 Oct 2022 00:22:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CF9760FC6;
        Mon,  3 Oct 2022 07:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D529C433C1;
        Mon,  3 Oct 2022 07:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781631;
        bh=7Jn0dhn1JoLUX5Vmcge7lUk1T51dy732xLlwJZxSwdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neAs0Jx+k3vuAW6DRb/BXUATIjxfo7sXK3zZy/gIS5GFG2v2uMjizZ4x25SNSUjuV
         ftouWHSXJEh/Rx2z58k9uXDaYy6NPoo2Py24qLevHP9K+gO6fZ/oiBd4i7HkNvxc6m
         tj0ou6HWTM5nOv5Ngow5sc2ep5RyLXKtX1Y8Uumg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Roesch <shr@fb.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 66/83] fs: split off setxattr_copy and do_setxattr function from setxattr
Date:   Mon,  3 Oct 2022 09:11:31 +0200
Message-Id: <20221003070723.651284725@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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

From: Stefan Roesch <shr@fb.com>

[ Upstream commit 1a91794ce8481a293c5ef432feb440aee1455619 ]

This splits of the setup part of the function setxattr in its own
dedicated function called setxattr_copy. In addition it also exposes a new
function called do_setxattr for making the setxattr call.

This makes it possible to call these two functions from io_uring in the
processing of an xattr request.

Signed-off-by: Stefan Roesch <shr@fb.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/r/20220323154420.3301504-2-shr@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 06bbaa6dc53c ("[coredump] don't use __kernel_write() on kmap_local_page()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/internal.h | 24 +++++++++++++++
 fs/xattr.c    | 84 ++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 83 insertions(+), 25 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index cdd83d4899bb..4f1fe6d08866 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -195,3 +195,27 @@ long splice_file_to_pipe(struct file *in,
 			 struct pipe_inode_info *opipe,
 			 loff_t *offset,
 			 size_t len, unsigned int flags);
+
+/*
+ * fs/xattr.c:
+ */
+struct xattr_name {
+	char name[XATTR_NAME_MAX + 1];
+};
+
+struct xattr_ctx {
+	/* Value of attribute */
+	union {
+		const void __user *cvalue;
+		void __user *value;
+	};
+	void *kvalue;
+	size_t size;
+	/* Attribute name */
+	struct xattr_name *kname;
+	unsigned int flags;
+};
+
+int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
+int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
+		struct xattr_ctx *ctx);
diff --git a/fs/xattr.c b/fs/xattr.c
index 998045165916..7117cb253864 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -25,6 +25,8 @@
 
 #include <linux/uaccess.h>
 
+#include "internal.h"
+
 static const char *
 strcmp_prefix(const char *a, const char *a_prefix)
 {
@@ -539,44 +541,76 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
 /*
  * Extended attribute SET operations
  */
-static long
-setxattr(struct user_namespace *mnt_userns, struct dentry *d,
-	 const char __user *name, const void __user *value, size_t size,
-	 int flags)
+
+int setxattr_copy(const char __user *name, struct xattr_ctx *ctx)
 {
 	int error;
-	void *kvalue = NULL;
-	char kname[XATTR_NAME_MAX + 1];
 
-	if (flags & ~(XATTR_CREATE|XATTR_REPLACE))
+	if (ctx->flags & ~(XATTR_CREATE|XATTR_REPLACE))
 		return -EINVAL;
 
-	error = strncpy_from_user(kname, name, sizeof(kname));
-	if (error == 0 || error == sizeof(kname))
-		error = -ERANGE;
+	error = strncpy_from_user(ctx->kname->name, name,
+				sizeof(ctx->kname->name));
+	if (error == 0 || error == sizeof(ctx->kname->name))
+		return  -ERANGE;
 	if (error < 0)
 		return error;
 
-	if (size) {
-		if (size > XATTR_SIZE_MAX)
+	error = 0;
+	if (ctx->size) {
+		if (ctx->size > XATTR_SIZE_MAX)
 			return -E2BIG;
-		kvalue = kvmalloc(size, GFP_KERNEL);
-		if (!kvalue)
-			return -ENOMEM;
-		if (copy_from_user(kvalue, value, size)) {
-			error = -EFAULT;
-			goto out;
+
+		ctx->kvalue = vmemdup_user(ctx->cvalue, ctx->size);
+		if (IS_ERR(ctx->kvalue)) {
+			error = PTR_ERR(ctx->kvalue);
+			ctx->kvalue = NULL;
 		}
-		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
-		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_from_user(mnt_userns, d_inode(d),
-						      kvalue, size);
 	}
 
-	error = vfs_setxattr(mnt_userns, d, kname, kvalue, size, flags);
-out:
-	kvfree(kvalue);
+	return error;
+}
+
+static void setxattr_convert(struct user_namespace *mnt_userns,
+			     struct dentry *d, struct xattr_ctx *ctx)
+{
+	if (ctx->size &&
+		((strcmp(ctx->kname->name, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
+		(strcmp(ctx->kname->name, XATTR_NAME_POSIX_ACL_DEFAULT) == 0)))
+		posix_acl_fix_xattr_from_user(mnt_userns, d_inode(d),
+						ctx->kvalue, ctx->size);
+}
+
+int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
+		struct xattr_ctx *ctx)
+{
+	setxattr_convert(mnt_userns, dentry, ctx);
+	return vfs_setxattr(mnt_userns, dentry, ctx->kname->name,
+			ctx->kvalue, ctx->size, ctx->flags);
+}
+
+static long
+setxattr(struct user_namespace *mnt_userns, struct dentry *d,
+	const char __user *name, const void __user *value, size_t size,
+	int flags)
+{
+	struct xattr_name kname;
+	struct xattr_ctx ctx = {
+		.cvalue   = value,
+		.kvalue   = NULL,
+		.size     = size,
+		.kname    = &kname,
+		.flags    = flags,
+	};
+	int error;
+
+	error = setxattr_copy(name, &ctx);
+	if (error)
+		return error;
+
+	error = do_setxattr(mnt_userns, d, &ctx);
 
+	kvfree(ctx.kvalue);
 	return error;
 }
 
-- 
2.35.1




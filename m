Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55906C17C8
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbjCTPRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbjCTPQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:16:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D54F30EB7
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:11:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EBE5B80EDA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B43C433A0;
        Mon, 20 Mar 2023 15:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325111;
        bh=7/l21qbPvL/uLOnO4QYZxpja9Gy/MCZCG6dCrpk+nFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RO8d4oLS6Zb+ygVXQxchyRlAht2PECyQWgQWPZDvBFH2auXMk/8hmUoX+nDirpySV
         at0GkQoStmfyfQjkg8whLcYrWoWkAsbQodSe4tYgENbxYBVVA709WPEruNTxSSo09H
         MNLl+iWCsTc0ZDveF56vDAgZ/CwteuyK/XhAqxcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Amir Goldstein <amir73il@gmail.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 5.10 92/99] attr: add in_group_or_capable()
Date:   Mon, 20 Mar 2023 15:55:10 +0100
Message-Id: <20230320145447.267143971@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

commit 11c2a8700cdcabf9b639b7204a1e38e2a0b6798e upstream.

[backported to 5.10.y, prior to idmapped mounts]

In setattr_{copy,prepare}() we need to perform the same permission
checks to determine whether we need to drop the setgid bit or not.
Instead of open-coding it twice add a simple helper the encapsulates the
logic. We will reuse this helpers to make dropping the setgid bit during
write operations more consistent in a follow up patch.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/attr.c     |   11 +++++------
 fs/inode.c    |   25 +++++++++++++++++++++----
 fs/internal.h |    1 +
 3 files changed, 27 insertions(+), 10 deletions(-)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -18,6 +18,8 @@
 #include <linux/evm.h>
 #include <linux/ima.h>
 
+#include "internal.h"
+
 static bool chown_ok(const struct inode *inode, kuid_t uid)
 {
 	if (uid_eq(current_fsuid(), inode->i_uid) &&
@@ -90,9 +92,8 @@ int setattr_prepare(struct dentry *dentr
 		if (!inode_owner_or_capable(inode))
 			return -EPERM;
 		/* Also check the setgid bit! */
-		if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
-				inode->i_gid) &&
-		    !capable_wrt_inode_uidgid(inode, CAP_FSETID))
+		if (!in_group_or_capable(inode, (ia_valid & ATTR_GID) ?
+						attr->ia_gid : inode->i_gid))
 			attr->ia_mode &= ~S_ISGID;
 	}
 
@@ -193,9 +194,7 @@ void setattr_copy(struct inode *inode, c
 		inode->i_ctime = attr->ia_ctime;
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
-
-		if (!in_group_p(inode->i_gid) &&
-		    !capable_wrt_inode_uidgid(inode, CAP_FSETID))
+		if (!in_group_or_capable(inode, inode->i_gid))
 			mode &= ~S_ISGID;
 		inode->i_mode = mode;
 	}
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2380,6 +2380,26 @@ int vfs_ioc_fssetxattr_check(struct inod
 EXPORT_SYMBOL(vfs_ioc_fssetxattr_check);
 
 /**
+ * in_group_or_capable - check whether caller is CAP_FSETID privileged
+ * @inode:	inode to check
+ * @gid:	the new/current gid of @inode
+ *
+ * Check wether @gid is in the caller's group list or if the caller is
+ * privileged with CAP_FSETID over @inode. This can be used to determine
+ * whether the setgid bit can be kept or must be dropped.
+ *
+ * Return: true if the caller is sufficiently privileged, false if not.
+ */
+bool in_group_or_capable(const struct inode *inode, kgid_t gid)
+{
+	if (in_group_p(gid))
+		return true;
+	if (capable_wrt_inode_uidgid(inode, CAP_FSETID))
+		return true;
+	return false;
+}
+
+/**
  * mode_strip_sgid - handle the sgid bit for non-directories
  * @dir: parent directory inode
  * @mode: mode of the file to be created in @dir
@@ -2398,11 +2418,8 @@ umode_t mode_strip_sgid(const struct ino
 		return mode;
 	if (S_ISDIR(mode) || !dir || !(dir->i_mode & S_ISGID))
 		return mode;
-	if (in_group_p(dir->i_gid))
+	if (in_group_or_capable(dir, dir->i_gid))
 		return mode;
-	if (capable_wrt_inode_uidgid(dir, CAP_FSETID))
-		return mode;
-
 	return mode & ~S_ISGID;
 }
 EXPORT_SYMBOL(mode_strip_sgid);
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -149,6 +149,7 @@ extern int vfs_open(const struct path *,
 extern long prune_icache_sb(struct super_block *sb, struct shrink_control *sc);
 extern void inode_add_lru(struct inode *inode);
 extern int dentry_needs_remove_privs(struct dentry *dentry);
+bool in_group_or_capable(const struct inode *inode, kgid_t gid);
 
 /*
  * fs-writeback.c



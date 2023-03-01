Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7156A731C
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjCASMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjCASMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:12:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61884BE8A
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:12:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6214761466
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70776C4339C;
        Wed,  1 Mar 2023 18:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694360;
        bh=OiZPvwZVrucXWalxQzzGbavRpgeH7WYhAYki02rIth0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJgN0kyTJcvY2t+KIBbE846oV9aADjpvoDd1hWWdzMlVmJh1bbh62mr+wBieJYTKJ
         MYvQDwkgKOk6XdhqAo7h6Lu534Xuudru7Zs5WHlKspX/c1RF8+bhekfKbu6T1AVh0D
         7aZ07O84BqUA8q466f6xJ5AM2mJLfyReNUpNP6uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Amir Goldstein <amir73il@gmail.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 6.1 36/42] attr: add in_group_or_capable()
Date:   Wed,  1 Mar 2023 19:08:57 +0100
Message-Id: <20230301180658.658059985@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit 11c2a8700cdcabf9b639b7204a1e38e2a0b6798e upstream.

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
 fs/attr.c     |   10 +++++-----
 fs/inode.c    |   28 ++++++++++++++++++++++++----
 fs/internal.h |    2 ++
 3 files changed, 31 insertions(+), 9 deletions(-)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -18,6 +18,8 @@
 #include <linux/evm.h>
 #include <linux/ima.h>
 
+#include "internal.h"
+
 /**
  * chown_ok - verify permissions to chown inode
  * @mnt_userns:	user namespace of the mount @inode was found from
@@ -140,8 +142,7 @@ int setattr_prepare(struct user_namespac
 			vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
 
 		/* Also check the setgid bit! */
-		if (!vfsgid_in_group_p(vfsgid) &&
-		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		if (!in_group_or_capable(mnt_userns, inode, vfsgid))
 			attr->ia_mode &= ~S_ISGID;
 	}
 
@@ -251,9 +252,8 @@ void setattr_copy(struct user_namespace
 		inode->i_ctime = attr->ia_ctime;
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
-		vfsgid_t vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
-		if (!vfsgid_in_group_p(vfsgid) &&
-		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		if (!in_group_or_capable(mnt_userns, inode,
+					 i_gid_into_vfsgid(mnt_userns, inode)))
 			mode &= ~S_ISGID;
 		inode->i_mode = mode;
 	}
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2488,6 +2488,28 @@ struct timespec64 current_time(struct in
 EXPORT_SYMBOL(current_time);
 
 /**
+ * in_group_or_capable - check whether caller is CAP_FSETID privileged
+ * @mnt_userns: user namespace of the mount @inode was found from
+ * @inode:	inode to check
+ * @vfsgid:	the new/current vfsgid of @inode
+ *
+ * Check wether @vfsgid is in the caller's group list or if the caller is
+ * privileged with CAP_FSETID over @inode. This can be used to determine
+ * whether the setgid bit can be kept or must be dropped.
+ *
+ * Return: true if the caller is sufficiently privileged, false if not.
+ */
+bool in_group_or_capable(struct user_namespace *mnt_userns,
+			 const struct inode *inode, vfsgid_t vfsgid)
+{
+	if (vfsgid_in_group_p(vfsgid))
+		return true;
+	if (capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		return true;
+	return false;
+}
+
+/**
  * mode_strip_sgid - handle the sgid bit for non-directories
  * @mnt_userns: User namespace of the mount the inode was created from
  * @dir: parent directory inode
@@ -2508,11 +2530,9 @@ umode_t mode_strip_sgid(struct user_name
 		return mode;
 	if (S_ISDIR(mode) || !dir || !(dir->i_mode & S_ISGID))
 		return mode;
-	if (in_group_p(i_gid_into_mnt(mnt_userns, dir)))
+	if (in_group_or_capable(mnt_userns, dir,
+				i_gid_into_vfsgid(mnt_userns, dir)))
 		return mode;
-	if (capable_wrt_inode_uidgid(mnt_userns, dir, CAP_FSETID))
-		return mode;
-
 	return mode & ~S_ISGID;
 }
 EXPORT_SYMBOL(mode_strip_sgid);
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -151,6 +151,8 @@ extern int vfs_open(const struct path *,
  */
 extern long prune_icache_sb(struct super_block *sb, struct shrink_control *sc);
 extern int dentry_needs_remove_privs(struct dentry *dentry);
+bool in_group_or_capable(struct user_namespace *mnt_userns,
+			 const struct inode *inode, vfsgid_t vfsgid);
 
 /*
  * fs-writeback.c



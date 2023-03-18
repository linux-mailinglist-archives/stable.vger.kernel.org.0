Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A97C6BF968
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 11:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjCRKQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 06:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjCRKP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 06:15:58 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C028F25979;
        Sat, 18 Mar 2023 03:15:53 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id ay8so4684204wmb.1;
        Sat, 18 Mar 2023 03:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679134552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eatdB0z21nbZqAoMxbWVck3KnIwW4SpkowjlzDGzwpw=;
        b=cw/GL07s5GJ7LGkZwE5KnszWaWwlfGC5OQ4vWbU0UNdAN3QGMf9VZ1CPqfrJhXmjYh
         VXZSYAtSbtPxeUu7p8yLW4MHAZHwSyvn/QOvzAde7eO/+ajdYzDkPBXXlrfl1uy/tMeI
         FIkU5qrtHwtKXk1BAiZllGxAwIWD8oVNtqSh8BnMmQKzb/vqVht0orBBbfg8J/IlpKMn
         i35be5oEb/vXfi3Cvcrzp9kA/2qDj7eJeyCsxg3F18p/IJVqwHvjtCbQ2RddKcJVioPA
         CYFaqsmwWo8wgnQOMC07utcAWWvbMO8eIipAAhM1hANIwh05VS5H9ygV4lAGRa0Gxsz0
         xFmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679134552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eatdB0z21nbZqAoMxbWVck3KnIwW4SpkowjlzDGzwpw=;
        b=msUhMErN4kZv5u2vfQ9maPhofhjFM/XchCfORjMtIoUyKr3nx0pfCCljUc802+Bu6N
         ihMa2wJjCj+MVqTFr+/aybk/Bb7d91m27C/O38JCBjOTbaBiMBAKu5qm9VpTDOiw9KMh
         cF9FPoF1nVo98Bc7L2E5fsbrnwdkKFRBiovVxIbu+/YQ9RQOkCYzK6hZ1z+D8e6u6M7U
         ra2poxlpCzS1TW283PJBYHxbQ4t7Cc+b84SpCgOeH9E/Etuc48mPPHfXOyvfSfvxt+QD
         issDBhtL+SwbtLmZgeEHROABSbB/CUS3NGuDU/hGmfNv3jR6DixAuOsa5Ucb+VoGxgGk
         VDlA==
X-Gm-Message-State: AO0yUKXQO1BTex2z3sn9SWqgw5ySnQgLQihbk7eKETtwFEi/pU8AS3Bu
        amSxv4Om7Z6p8RK5p5sFURE=
X-Google-Smtp-Source: AK7set+nDV4tJfhxDK+u/YypvydP13hNKDyvgfWE7uzwncRytdDK4nvoGnNow6eSvdvT3ckEk2oDFA==
X-Received: by 2002:a05:600c:3b14:b0:3ed:29f8:3ff2 with SMTP id m20-20020a05600c3b1400b003ed29f83ff2mr4511089wms.6.1679134552376;
        Sat, 18 Mar 2023 03:15:52 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003eafc47eb09sm4333965wml.43.2023.03.18.03.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 03:15:52 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 5.10 10/15] attr: add in_group_or_capable()
Date:   Sat, 18 Mar 2023 12:15:24 +0200
Message-Id: <20230318101529.1361673-11-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230318101529.1361673-1-amir73il@gmail.com>
References: <20230318101529.1361673-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/attr.c     | 11 +++++------
 fs/inode.c    | 25 +++++++++++++++++++++----
 fs/internal.h |  1 +
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 848ffe6e3c24..300ba5153868 100644
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
@@ -90,9 +92,8 @@ int setattr_prepare(struct dentry *dentry, struct iattr *attr)
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
 
@@ -193,9 +194,7 @@ void setattr_copy(struct inode *inode, const struct iattr *attr)
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
diff --git a/fs/inode.c b/fs/inode.c
index 52f834b6a3ad..63f86aeda7fd 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2379,6 +2379,26 @@ int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
 }
 EXPORT_SYMBOL(vfs_ioc_fssetxattr_check);
 
+/**
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
 /**
  * mode_strip_sgid - handle the sgid bit for non-directories
  * @dir: parent directory inode
@@ -2398,11 +2418,8 @@ umode_t mode_strip_sgid(const struct inode *dir, umode_t mode)
 		return mode;
 	if (S_ISDIR(mode) || !dir || !(dir->i_mode & S_ISGID))
 		return mode;
-	if (in_group_p(dir->i_gid))
-		return mode;
-	if (capable_wrt_inode_uidgid(dir, CAP_FSETID))
+	if (in_group_or_capable(dir, dir->i_gid))
 		return mode;
-
 	return mode & ~S_ISGID;
 }
 EXPORT_SYMBOL(mode_strip_sgid);
diff --git a/fs/internal.h b/fs/internal.h
index 06d313b9beec..0fe920d9f393 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -149,6 +149,7 @@ extern int vfs_open(const struct path *, struct file *);
 extern long prune_icache_sb(struct super_block *sb, struct shrink_control *sc);
 extern void inode_add_lru(struct inode *inode);
 extern int dentry_needs_remove_privs(struct dentry *dentry);
+bool in_group_or_capable(const struct inode *inode, kgid_t gid);
 
 /*
  * fs-writeback.c
-- 
2.34.1


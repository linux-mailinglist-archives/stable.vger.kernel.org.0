Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837766BB1BA
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbjCOMaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232613AbjCOM3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:29:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C433A82
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:28:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E13A761CC2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00055C433EF;
        Wed, 15 Mar 2023 12:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883332;
        bh=0qL1Nqd8CyYvzBPMPyRNZWQF6wsCec1a1G03OobWWRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYFoRuxVwfEsvWLFoiB4cCZqQfkoHLlQMq7Ygol8ByJDanEm/OhJVyiCzPFwj2IGx
         nYs0FrlR2CUUENpUBn6kxQVJrlOtdtSs3zVRNMI9ZE24RlIQN+ZkLkKpFzGrFVAKUt
         7o/pJ7eJNH1R8qcj2MKZkumAxuhsZGuBrJC1m6AY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Amir Goldstein <amir73il@gmail.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/145] attr: add setattr_should_drop_sgid()
Date:   Wed, 15 Mar 2023 13:12:48 +0100
Message-Id: <20230315115742.334949541@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit 72ae017c5451860443a16fb2a8c243bff3e396b8 upstream.

[backport to 5.15.y, prior to vfsgid_t]

The current setgid stripping logic during write and ownership change
operations is inconsistent and strewn over multiple places. In order to
consolidate it and make more consistent we'll add a new helper
setattr_should_drop_sgid(). The function retains the old behavior where
we remove the S_ISGID bit unconditionally when S_IXGRP is set but also
when it isn't set and the caller is neither in the group of the inode
nor privileged over the inode.

We will use this helper both in write operation permission removal such
as file_remove_privs() as well as in ownership change operations.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/attr.c     | 28 ++++++++++++++++++++++++++++
 fs/internal.h |  6 ++++++
 2 files changed, 34 insertions(+)

diff --git a/fs/attr.c b/fs/attr.c
index f045431bab1ad..965be68ed8fa0 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -20,6 +20,34 @@
 
 #include "internal.h"
 
+/**
+ * setattr_should_drop_sgid - determine whether the setgid bit needs to be
+ *                            removed
+ * @mnt_userns:	user namespace of the mount @inode was found from
+ * @inode:	inode to check
+ *
+ * This function determines whether the setgid bit needs to be removed.
+ * We retain backwards compatibility and require setgid bit to be removed
+ * unconditionally if S_IXGRP is set. Otherwise we have the exact same
+ * requirements as setattr_prepare() and setattr_copy().
+ *
+ * Return: ATTR_KILL_SGID if setgid bit needs to be removed, 0 otherwise.
+ */
+int setattr_should_drop_sgid(struct user_namespace *mnt_userns,
+			     const struct inode *inode)
+{
+	umode_t mode = inode->i_mode;
+
+	if (!(mode & S_ISGID))
+		return 0;
+	if (mode & S_IXGRP)
+		return ATTR_KILL_SGID;
+	if (!in_group_or_capable(mnt_userns, inode,
+				 i_gid_into_mnt(mnt_userns, inode)))
+		return ATTR_KILL_SGID;
+	return 0;
+}
+
 /*
  * The logic we want is
  *
diff --git a/fs/internal.h b/fs/internal.h
index c898147272817..45cf31d7380b8 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -231,3 +231,9 @@ struct xattr_ctx {
 int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
 int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 		struct xattr_ctx *ctx);
+
+/*
+ * fs/attr.c
+ */
+int setattr_should_drop_sgid(struct user_namespace *mnt_userns,
+			     const struct inode *inode);
-- 
2.39.2




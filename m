Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9EE6AF469
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjCGTQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233765AbjCGTQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:12 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CB1AE132;
        Tue,  7 Mar 2023 10:59:38 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id l1so14212941pjt.2;
        Tue, 07 Mar 2023 10:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678215578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dOUS+CQtG3TM0vD3uA+erwsWRYHnMgU+Sry1iPaPKJM=;
        b=Bsk7zWfcJuyoR+pHaPUYsAMzbWiR19jV58vatP/3VdzKRT9V7KTCLdlNREOzh3qi6E
         8h9s/uoPl/5WTILmSCMxUd3Hj5QsZLjm4I6Ktn2sz3sdk4R8NyFhvbb9G2GRHFxT4cfK
         EiDOdXXhke4p7nV9UepwUaP94NwAFLi4NF43u9SxmEgxY4ddE4w9hq6HtxFtmEmcpLDI
         RBZ9clY1UDTifavmBOp+6qVVMHylA3MICA/ddbhb1JcLGYUq0OwvtTXmCAQl1mgXFZC3
         qeX3ye7sfC4YGcMKgieiABzZBcFTB7LZ0PvX82tpKUAXaQ3YTQR54txeWiyDgsQglWwQ
         YovQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678215578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dOUS+CQtG3TM0vD3uA+erwsWRYHnMgU+Sry1iPaPKJM=;
        b=PixyZUIHCv1AkxNecf4o0dJu55vxw5euh9oQcbmCoNiHY7GEAAmgsBg2KJkC3HMC1a
         vJh9dgDBlB3sQCUNa4/LYw+EmIAx14uNtw958Tq7qApq6G818u9HVhs9w+lefJBehNst
         aWFOzu1JOiXH4qZ6778ojKR5xcMyjsvwpd9hUKS/EZ1BhuejKsBxyyQ06qBmWdBvxpLs
         uel5K0EwKnSJXiKig9qaa5i0RhAk9Gquipgy/Wr6G9BFImiUpo/0Cig7f9+CZWrYJyXt
         WXJZu2yjRmW1Sh/imri9+agDMsK3Zju5CgXLc73vaRV+ykDdZj5w39ARAXxlGXL8gHrR
         PZHg==
X-Gm-Message-State: AO0yUKUoAZgcOwIMeI8NPgeQKz2hsBSS4e0biix1ht27kSNS6N9mYTal
        rirgbUZykT3TVkY5eUKfWsVdwQQX82h1Dg==
X-Google-Smtp-Source: AK7set/VOPjmKo1r1z5N7ZxiiYV++JoiYfetkLq3agDHBAcmySJ46CAmgkypA4yiciu0+zkjp6+OYQ==
X-Received: by 2002:a17:902:eccb:b0:19a:b754:4053 with SMTP id a11-20020a170902eccb00b0019ab7544053mr18316471plh.26.1678215577800;
        Tue, 07 Mar 2023 10:59:37 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:6f2b:1857:847c:366c])
        by smtp.gmail.com with ESMTPSA id ku4-20020a170903288400b001943d58268csm8745658plb.55.2023.03.07.10.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 10:59:37 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Christian Brauner <brauner@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 5.15 09/11] attr: add setattr_should_drop_sgid()
Date:   Tue,  7 Mar 2023 10:59:20 -0800
Message-Id: <20230307185922.125907-10-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230307185922.125907-1-leah.rumancik@gmail.com>
References: <20230307185922.125907-1-leah.rumancik@gmail.com>
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
---
 fs/attr.c     | 28 ++++++++++++++++++++++++++++
 fs/internal.h |  6 ++++++
 2 files changed, 34 insertions(+)

diff --git a/fs/attr.c b/fs/attr.c
index f045431bab1a..965be68ed8fa 100644
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
index c89814727281..45cf31d7380b 100644
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
2.40.0.rc0.216.gc4246ad0f0-goog


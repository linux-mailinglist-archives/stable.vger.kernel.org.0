Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AA06A0CC4
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 16:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbjBWPVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 10:21:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbjBWPVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 10:21:00 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFADF59409;
        Thu, 23 Feb 2023 07:20:59 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id p8so11092540wrt.12;
        Thu, 23 Feb 2023 07:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kohP7Bbi0tnLRVgKhBxBMp2Mw6mRjO4+z5U2OG0mt5c=;
        b=Youq8Cik8UbiWcNTQKjyCtB6wVSUvliZAICMqWmgehUSRVSRot1ccWVerQoXnWUwDO
         hbWazMJwrzhbcxXhkj45eJqZEs4S8rj+iPQ3d2LKJ8xYycFKJSKx6+TuFfd7VmwNxj5S
         2CdZziNe36j+VkLT4v5qxH6J36g+kF6gY1eZrgTLGSqTtvEBRw/uIPL0uBQR1y0Q1ygf
         I+ergbt6ZYUrbJu2shBepoRYpj48k7fdsQA+V8uVfyKwFIXXYe0JrvozPHE/dn39nJQ2
         4YY+vgLOVHSKQix7E+ZFhFwwIJ7xQ+8gsCG+DG/CyGW5vBvCEAzzqUWYzGe/T740+eVO
         2eXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kohP7Bbi0tnLRVgKhBxBMp2Mw6mRjO4+z5U2OG0mt5c=;
        b=xW/ip7L/EQ44eQv1DCoQyEpKTwLtScVrY2FKq4OJ4fd0TJR7hwb/v4zPYubAl0ay3q
         AsiTlPvu2KCUVsC9kKiDhjO6jrfVU1Q/gnabJkbIv1/0omEgyn5uedRSb7femqSGCjdx
         efN/RHV4j8POnZFu18XqpUTeAo4kboMUfQUtYlN8gr/4Uc3zc+LlQg/AKaFUG8Deek0I
         5fPElX/BZiMbOXu1cBgvZs41QVbwWEHJkAj7F6eCCt8oKcb54o5h3aKCivfVQiZK7hBR
         QPI8xvsPKVyjzEjfxRJAv6nAZ5iYqN+7tSRFW/TBhnsVLHmeHV8CBODoxxwGtfcqDpsY
         VIkw==
X-Gm-Message-State: AO0yUKUPigFJTH84sA7sMv7e90/uUxT5f/Jg284HcwiNETUcbNMIY/ij
        XrqBrstkS5uc6YvvWz8zS3zXhvbDJ9Q=
X-Google-Smtp-Source: AK7set/SIqYVUBhYh2+zvzKgs8MoCyZEb9maVC2s5InqPa+sGDBWLlGZnRK/CRiKoIfc/3MyZ1FhZQ==
X-Received: by 2002:adf:ea88:0:b0:2c5:5a65:79a0 with SMTP id s8-20020adfea88000000b002c55a6579a0mr8263157wrm.53.1677165658203;
        Thu, 23 Feb 2023 07:20:58 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k9-20020a5d6289000000b002c56af32e8csm9372590wru.35.2023.02.23.07.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 07:20:57 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 6.1 3/5] attr: add setattr_should_drop_sgid()
Date:   Thu, 23 Feb 2023 17:20:42 +0200
Message-Id: <20230223152044.1064909-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230223152044.1064909-1-amir73il@gmail.com>
References: <20230223152044.1064909-1-amir73il@gmail.com>
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
---
 fs/attr.c     | 28 ++++++++++++++++++++++++++++
 fs/internal.h |  6 ++++++
 2 files changed, 34 insertions(+)

diff --git a/fs/attr.c b/fs/attr.c
index e508b3caae76..085322536127 100644
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
+				 i_gid_into_vfsgid(mnt_userns, inode)))
+		return ATTR_KILL_SGID;
+	return 0;
+}
+
 /*
  * The logic we want is
  *
diff --git a/fs/internal.h b/fs/internal.h
index 1de39bbc9ddd..771b0468d70c 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -236,3 +236,9 @@ int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 		struct xattr_ctx *ctx);
 
 ssize_t __kernel_write_iter(struct file *file, struct iov_iter *from, loff_t *pos);
+
+/*
+ * fs/attr.c
+ */
+int setattr_should_drop_sgid(struct user_namespace *mnt_userns,
+			     const struct inode *inode);
-- 
2.34.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597746BF96C
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 11:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjCRKQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 06:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjCRKQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 06:16:00 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40F828233;
        Sat, 18 Mar 2023 03:15:55 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id p13-20020a05600c358d00b003ed346d4522so4726867wmq.2;
        Sat, 18 Mar 2023 03:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679134555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zs1zoKvdKc411P0VlWS94lq85UVPmglODGE22wnBLL0=;
        b=KtnFG4veDCHg3Voz4u1iXxnj+pdvMXjIOaIy8bBbOw8vrHe0trW/RziV4WsqcO+4f2
         OTY8AQq3unLJ5JLieWF4N+kM9VfsYUPGHrX+QhUZzWak7QRVjTct+PiJwynnLdrfvXaq
         fhwYiabRq0yLH15yi9yieJUJTehEPxPYj3q2vSOBS5Q13jTG8q25YzOHuWevlLvDrEZk
         x7xe6o0mf/ijTn4Z0clckC7qvsoZoIaAhtpBpIAbeTpsoaRNg5XGaSo5HvL4+L63oAFw
         1O7PxBiDk+NbBhsuvpVS3/4fDfuir5y4JwrqK/XRVdSnft7fNEP7VG8qyAulG7THj4Lt
         vIcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679134555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zs1zoKvdKc411P0VlWS94lq85UVPmglODGE22wnBLL0=;
        b=ICI/scQcTxCQSk1PlDuPAnL9zbjtAtvs96orkR0chDmNfFSoIEw5hj0V4eGB647qvs
         ocIsoVcMuF7OuYBQX8jByhdJt1vW5J9/RZC3q+qKQnPsz0QeKPOgCe4ybSrKP1If/KEH
         rBT57uF2NOU12KKaQ46P3n+NzPo2b4czS4+S5BJ/aYrrrs/Ki6GJzOl8ZcrQ7SMcKPXC
         ZY1zs2VS6yHnz7lxoEUZDbH5o986kWVayxDVB6NQEgySQcy+nq9a0EBUK9XM892h1SbR
         LhgPRusz2c1aawNvfd8hq2ofbNHeB+nUHcC2Zf8IDGFfO1suu9U1AJvTBS0hegqbhxEy
         fALg==
X-Gm-Message-State: AO0yUKV1mTEZ3GMa+PjPzaNKBn+IjjlELiCNpCHhxoDLmvqFiBhPfBke
        9gAGs/8MXxb2vNYp3YgRIZc=
X-Google-Smtp-Source: AK7set8dNJLI8k5rlP0DqIkQFV5x8exo3w8ajCaQVWtYzDUNTDw9Cc5hS7ZuuSze3NukIP4Q0OwDwg==
X-Received: by 2002:a05:600c:548b:b0:3e2:6ec:61ea with SMTP id iv11-20020a05600c548b00b003e206ec61eamr27912401wmb.28.1679134555474;
        Sat, 18 Mar 2023 03:15:55 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003eafc47eb09sm4333965wml.43.2023.03.18.03.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 03:15:55 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 5.10 12/15] attr: add setattr_should_drop_sgid()
Date:   Sat, 18 Mar 2023 12:15:26 +0200
Message-Id: <20230318101529.1361673-13-amir73il@gmail.com>
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

commit 72ae017c5451860443a16fb2a8c243bff3e396b8 upstream.

[backported to 5.10.y, prior to idmapped mounts]

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
 fs/attr.c     | 25 +++++++++++++++++++++++++
 fs/internal.h |  5 +++++
 2 files changed, 30 insertions(+)

diff --git a/fs/attr.c b/fs/attr.c
index 666489157978..c8049ae34a2e 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -20,6 +20,31 @@
 
 #include "internal.h"
 
+/**
+ * setattr_should_drop_sgid - determine whether the setgid bit needs to be
+ *                            removed
+ * @inode:	inode to check
+ *
+ * This function determines whether the setgid bit needs to be removed.
+ * We retain backwards compatibility and require setgid bit to be removed
+ * unconditionally if S_IXGRP is set. Otherwise we have the exact same
+ * requirements as setattr_prepare() and setattr_copy().
+ *
+ * Return: ATTR_KILL_SGID if setgid bit needs to be removed, 0 otherwise.
+ */
+int setattr_should_drop_sgid(const struct inode *inode)
+{
+	umode_t mode = inode->i_mode;
+
+	if (!(mode & S_ISGID))
+		return 0;
+	if (mode & S_IXGRP)
+		return ATTR_KILL_SGID;
+	if (!in_group_or_capable(inode, inode->i_gid))
+		return ATTR_KILL_SGID;
+	return 0;
+}
+
 /*
  * The logic we want is
  *
diff --git a/fs/internal.h b/fs/internal.h
index 0fe920d9f393..d5d9fcdae10c 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -197,3 +197,8 @@ int sb_init_dio_done_wq(struct super_block *sb);
  */
 int do_statx(int dfd, const char __user *filename, unsigned flags,
 	     unsigned int mask, struct statx __user *buffer);
+
+/*
+ * fs/attr.c
+ */
+int setattr_should_drop_sgid(const struct inode *inode);
-- 
2.34.1


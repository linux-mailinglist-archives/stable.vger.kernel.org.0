Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6474857D624
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 23:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbiGUVhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 17:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233433AbiGUVhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 17:37:34 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35ED9363B;
        Thu, 21 Jul 2022 14:37:33 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gq7so2764888pjb.1;
        Thu, 21 Jul 2022 14:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Xz8kxfjcinAOHof+XkvkW4NneSM70XSRVO1kIVlm1c=;
        b=XwB16NwOLMbxdtg3LDRpaMeRJFyDMvuW5lxGmYnONfZZz/xcULWwQqsWxtgbkgI30b
         2iAVEiwdTWUuQPcM197mn3Ng+s0KxQoeMGPRc6PaKCHVmHCEOMKs/BKdHETSLX5TflhS
         b0fjLSeAHvhpENiZp/SBI7dzlRD+vX9TAD3NaozSQ12FXDH55KzdNI72swpQMd2HIzTs
         mFuj/zLV/PaNhTmkkXdl7wezCdyatgpkNa73GYnnNYKyILyrH6hp/U2vmQSVkiJJXxq1
         pc+znoiBHzygQdG5lvuCGP7Nksuby7FI6huckkj3dBxCbiEextc/3DoKhqxWRxjs6h42
         QToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Xz8kxfjcinAOHof+XkvkW4NneSM70XSRVO1kIVlm1c=;
        b=T+LaPQP07URceYa16jIvcemNw6H4D5ZSbCH52YnqIsfO46aULLr3+SWmY3o9VIwUyF
         pTn5e400ouOtdstzHdDSYrkNaYElTAx8b+LGl676hrKwRQm+gvBa5BQ4a9I0POlNFqvm
         airnmBLxp5o5QUpg4Yo8X6EpRTf7gspy+OJRgVLUkB5v2PDLpPoY29826imJbQZ2fJX9
         GJbGLER9Cu3vGh/GhF/emLB37wQOvs86P2fDCPQghehG4ccKTc2IMEraVylFSJV+Em6i
         XrJy9gvXoO9XwX3SxOsqLHTsNCXVviROP8Is/nYRqPQhoRjwOQ8FdHSZ0Q1Og7aPjdcu
         sPZw==
X-Gm-Message-State: AJIora8N8koHqiacufygC7u0w7WXdTX/ii3hnxRFbcgYSvIV0PNNQQKh
        9J73qi9EGmTocrgXw89nsMFyh9+pUfxKrA==
X-Google-Smtp-Source: AGRyM1vB+kNmLenEFS1tz2/tw/gLkMpdcmMImrjBh3FOuRP5DsZ3D2rd2TAvOiM6499jz3L9rrrdYA==
X-Received: by 2002:a17:902:8f91:b0:16c:151d:3e1b with SMTP id z17-20020a1709028f9100b0016c151d3e1bmr288383plo.37.1658439452253;
        Thu, 21 Jul 2022 14:37:32 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:ea45:e7f2:4e46:fc7a])
        by smtp.gmail.com with ESMTPSA id c26-20020a634e1a000000b004114cc062f0sm1919502pgb.65.2022.07.21.14.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 14:37:31 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, Dan Carpenter <dan.carpenter@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 v2 6/6] xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()
Date:   Thu, 21 Jul 2022 14:36:10 -0700
Message-Id: <20220721213610.2794134-7-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
In-Reply-To: <20220721213610.2794134-1-leah.rumancik@gmail.com>
References: <20220721213610.2794134-1-leah.rumancik@gmail.com>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 6ed6356b07714e0198be3bc3ecccc8b40a212de4 ]

The "bufsize" comes from the root user.  If "bufsize" is negative then,
because of type promotion, neither of the validation checks at the start
of the function are able to catch it:

	if (bufsize < sizeof(struct xfs_attrlist) ||
	    bufsize > XFS_XATTR_LIST_MAX)
		return -EINVAL;

This means "bufsize" will trigger (WARN_ON_ONCE(size > INT_MAX)) in
kvmalloc_node().  Fix this by changing the type from int to size_t.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 fs/xfs/xfs_ioctl.h | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 09269f478df9..fba52e75e98b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -372,7 +372,7 @@ int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
 	void __user			*ubuf,
-	int				bufsize,
+	size_t				bufsize,
 	int				flags,
 	struct xfs_attrlist_cursor __user *ucursor)
 {
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index 28453a6d4461..845d3bcab74b 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -38,8 +38,9 @@ xfs_readlink_by_handle(
 int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 		uint32_t opcode, void __user *uname, void __user *value,
 		uint32_t *len, uint32_t flags);
-int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf, int bufsize,
-	int flags, struct xfs_attrlist_cursor __user *ucursor);
+int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
+		      size_t bufsize, int flags,
+		      struct xfs_attrlist_cursor __user *ucursor);
 
 extern struct dentry *
 xfs_handle_to_dentry(
-- 
2.37.1.359.gd136c6c3e2-goog


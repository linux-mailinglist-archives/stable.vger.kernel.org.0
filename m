Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEABC7285E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 08:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfGXGfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 02:35:06 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33979 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGXGfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 02:35:06 -0400
Received: by mail-pf1-f196.google.com with SMTP id b13so20404394pfo.1;
        Tue, 23 Jul 2019 23:35:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dEi8RiiixG/3RW/0nxRece8Ed2TRWYTondXKCVJpI+0=;
        b=IvRnBmZuLGcVPgXAMjYCnDgjS0SXpYEINeXpdcXNPdyZyeD0FKnAcWSsIV0Ayic+w0
         6jFahp4p98SNB/4G/gR28jUbZK54es4MLi6xt8361TMl4EEL/FN+II/TxbWR7OodhIx4
         DUyIUbVAR04gUGGei/NTF7J530yNKYJNmK+HWnH0GIoWHLwWQ0oUMBx6ojPQX7/0kzZT
         KiH69Z/IMV2KqyFt9hnayHYTAlnQf3HF1SZLbd5etJGPgcX0kY7+TCzvQkb8IdahMMAF
         D/qSFJYOjaYZSnFIjN/ulSoM6QlF5neqggLHFp4LIQgOaUgCvBtci9L1KuYKVHF66ghw
         BQJg==
X-Gm-Message-State: APjAAAVYOgnWV9z+k/N5Xey9YF90NK+MeR0jh0655TADYD4klYw/R+gU
        I3/PTM7PeyN5VlTkgDvKokc=
X-Google-Smtp-Source: APXvYqwvhJFz1925E+lovoJdfQumAv09RF6t6UdvJ78UBPPTsj9XK0MsqaVxYYOJGWOIjXcHZh/h3w==
X-Received: by 2002:a17:90a:24ac:: with SMTP id i41mr85110674pje.124.1563950105442;
        Tue, 23 Jul 2019 23:35:05 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id i14sm72647173pfk.0.2019.07.23.23.35.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 23:35:04 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id AE25040619; Wed, 24 Jul 2019 06:34:58 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, Alexander.Levin@microsoft.com
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        amir73il@gmail.com,
        Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 5/6] xfs: Add attibute remove and helper functions
Date:   Wed, 24 Jul 2019 06:34:50 +0000
Message-Id: <20190724063451.26190-6-mcgrof@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190724063451.26190-1-mcgrof@kernel.org>
References: <20190724063451.26190-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

commit 068f985a9e5ec70fde58d8f679994fdbbd093a36 upstream.

This patch adds xfs_attr_remove_args. These sub-routines remove
the attributes specified in @args. We will use this later for setting
parent pointers as a deferred attribute operation.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 36 +++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_attr.h |  1 +
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 25431ddba1fa..844ed87b1900 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -289,6 +289,30 @@ xfs_attr_set_args(
 	return error;
 }
 
+/*
+ * Remove the attribute specified in @args.
+ */
+int
+xfs_attr_remove_args(
+	struct xfs_da_args      *args)
+{
+	struct xfs_inode	*dp = args->dp;
+	int			error;
+
+	if (!xfs_inode_hasattr(dp)) {
+		error = -ENOATTR;
+	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
+		error = xfs_attr_shortform_remove(args);
+	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+		error = xfs_attr_leaf_removename(args);
+	} else {
+		error = xfs_attr_node_removename(args);
+	}
+
+	return error;
+}
+
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
@@ -445,17 +469,7 @@ xfs_attr_remove(
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
 
-	if (!xfs_inode_hasattr(dp)) {
-		error = -ENOATTR;
-	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
-		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
-		error = xfs_attr_shortform_remove(&args);
-	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_removename(&args);
-	} else {
-		error = xfs_attr_node_removename(&args);
-	}
-
+	error = xfs_attr_remove_args(&args);
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index f608ac8f306f..bdf52a333f3f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -142,6 +142,7 @@ int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
+int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 
-- 
2.18.0


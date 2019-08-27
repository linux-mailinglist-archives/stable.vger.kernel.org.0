Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 130FD9DFF3
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbfH0H64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730693AbfH0H64 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:58:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B42902173E;
        Tue, 27 Aug 2019 07:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892735;
        bh=RCGcL3syXuqW9tunJiDf3A+aiBXAcoeZBk72xj7tLlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/YTDTZLm7uT42UIh/wR8hvwXoHdXn4YxwK5IvR5gJDE+T1PQ/r5BeIaE4aB5Tzov
         FlWneMMZ5zxTA4+dy2p2D1wLZu4itXTOaZGBqODRXJ2YLRIvCph4VzrFXzJ/w1Ljo2
         QkGRPIcj2zebWOH5otKkDTZ1fIhMXqcPGaeIlGPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 93/98] xfs: Add attibute remove and helper functions
Date:   Tue, 27 Aug 2019 09:51:12 +0200
Message-Id: <20190827072723.263458661@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 068f985a9e5ec70fde58d8f679994fdbbd093a36 upstream.

This patch adds xfs_attr_remove_args. These sub-routines remove
the attributes specified in @args. We will use this later for setting
parent pointers as a deferred attribute operation.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 36 +++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_attr.h |  1 +
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 25431ddba1fab..844ed87b19007 100644
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
index f608ac8f306f9..bdf52a333f3f9 100644
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
2.20.1




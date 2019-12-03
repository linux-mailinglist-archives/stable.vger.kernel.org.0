Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 930A2111ECB
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbfLCWvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:51:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:43806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729904AbfLCWvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:51:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B5C120848;
        Tue,  3 Dec 2019 22:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413491;
        bh=CoEzIdgrHZSh/Pmxs+UK47acLtXWnbBfztsrTy8FYMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFXr5HWg7LCu7M3MrX/s96rEM0UZSGlCtpP/o4pboDJqKT06IBH/zo2S2dLZriNsG
         0sanLWMcMZvXYD5dSfr1tGXjFJ0BeJJ2peLeKdTeR5UoYwIWJRzPrUBGfNVG12Kdmn
         qHtvlLazJXe5UA94gOfw0TkOXAWAuYTBo64bgMR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Bowler <nbowler@draconx.ca>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 148/321] xfs: Fix bulkstat compat ioctls on x32 userspace.
Date:   Tue,  3 Dec 2019 23:33:34 +0100
Message-Id: <20191203223434.852090814@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Bowler <nbowler@draconx.ca>

[ Upstream commit 7ca860e3c1a74ad6bd8949364073ef1044cad758 ]

The bulkstat family of ioctls are problematic on x32, because there is
a mixup of native 32-bit and 64-bit conventions.  The xfs_fsop_bulkreq
struct contains pointers and 32-bit integers so that matches the native
32-bit layout, and that means the ioctl implementation goes into the
regular compat path on x32.

However, the 'ubuffer' member of that struct in turn refers to either
struct xfs_inogrp or xfs_bstat (or an array of these).  On x32, those
structures match the native 64-bit layout.  The compat implementation
writes out the 32-bit version of these structures.  This is not the
expected format for x32 userspace, causing problems.

Fortunately the functions which actually output these xfs_inogrp and
xfs_bstat structures have an easy way to select which output format
is required, so we just need a little tweak to select the right format
on x32.

Signed-off-by: Nick Bowler <nbowler@draconx.ca>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_ioctl32.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 4c34efcbf7e80..b044f7d36782c 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -241,6 +241,32 @@ xfs_compat_ioc_bulkstat(
 	int			done;
 	int			error;
 
+	/*
+	 * Output structure handling functions.  Depending on the command,
+	 * either the xfs_bstat and xfs_inogrp structures are written out
+	 * to userpace memory via bulkreq.ubuffer.  Normally the compat
+	 * functions and structure size are the correct ones to use ...
+	 */
+	inumbers_fmt_pf inumbers_func = xfs_inumbers_fmt_compat;
+	bulkstat_one_pf	bs_one_func = xfs_bulkstat_one_compat;
+	size_t bs_one_size = sizeof(struct compat_xfs_bstat);
+
+#ifdef CONFIG_X86_X32
+	if (in_x32_syscall()) {
+		/*
+		 * ... but on x32 the input xfs_fsop_bulkreq has pointers
+		 * which must be handled in the "compat" (32-bit) way, while
+		 * the xfs_bstat and xfs_inogrp structures follow native 64-
+		 * bit layout convention.  So adjust accordingly, otherwise
+		 * the data written out in compat layout will not match what
+		 * x32 userspace expects.
+		 */
+		inumbers_func = xfs_inumbers_fmt;
+		bs_one_func = xfs_bulkstat_one;
+		bs_one_size = sizeof(struct xfs_bstat);
+	}
+#endif
+
 	/* done = 1 if there are more stats to get and if bulkstat */
 	/* should be called again (unused here, but used in dmapi) */
 
@@ -272,15 +298,15 @@ xfs_compat_ioc_bulkstat(
 
 	if (cmd == XFS_IOC_FSINUMBERS_32) {
 		error = xfs_inumbers(mp, &inlast, &count,
-				bulkreq.ubuffer, xfs_inumbers_fmt_compat);
+				bulkreq.ubuffer, inumbers_func);
 	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE_32) {
 		int res;
 
-		error = xfs_bulkstat_one_compat(mp, inlast, bulkreq.ubuffer,
-				sizeof(compat_xfs_bstat_t), NULL, &res);
+		error = bs_one_func(mp, inlast, bulkreq.ubuffer,
+				bs_one_size, NULL, &res);
 	} else if (cmd == XFS_IOC_FSBULKSTAT_32) {
 		error = xfs_bulkstat(mp, &inlast, &count,
-			xfs_bulkstat_one_compat, sizeof(compat_xfs_bstat_t),
+			bs_one_func, bs_one_size,
 			bulkreq.ubuffer, &done);
 	} else
 		error = -EINVAL;
-- 
2.20.1




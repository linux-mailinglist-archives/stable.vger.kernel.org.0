Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49537106385
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbfKVGKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:10:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729223AbfKVF4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:56:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9814A20717;
        Fri, 22 Nov 2019 05:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402200;
        bh=JgZyYSBf2SW/EqWNhdaCW9RzKKTKsfeBvai0anq+xy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rsXOYk9YXfgJTmz/JDEOeAbR0M7DGsH3r53IdtoYjiJ0ofSKDH3XoRoI3kdlqQJVj
         tvOlDnRpW9i8yBWyrbr54//9fu56x4lXe/l5nx6M+NBKRt/Aai/XciQm2x9PB90FEK
         2GOsCfbJSH7miAh8McXe5JNtS2Dl/ydCgZ22jAw0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Bowler <nbowler@draconx.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 049/127] xfs: Fix bulkstat compat ioctls on x32 userspace.
Date:   Fri, 22 Nov 2019 00:54:27 -0500
Message-Id: <20191122055544.3299-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d3c0e4b8bf421..5f616a6a5358d 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -252,6 +252,32 @@ xfs_compat_ioc_bulkstat(
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
 
@@ -283,15 +309,15 @@ xfs_compat_ioc_bulkstat(
 
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


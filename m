Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4A9299FC1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410160AbgJZXxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410156AbgJZXxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C1C421D41;
        Mon, 26 Oct 2020 23:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756420;
        bh=2t8kO8WFsyV07ciYJ/d+3KZs6NqB/0TRoF4jvh+bFco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5S5/mni4X15cQes6XEtABCBcAdHm/xLR5ylPARM1LA2/T3s/i0M2PwXhSRiAhjqn
         r7eiaG098Oeehq5FK075mVaywNd5c1ezqQ/1p5bKdu/akdsld4/8lI45nn8Xl0h8fz
         jbVZ+l+a7/12GkOMD+INGj81hqWWfvBJMNW1qlro=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 077/132] xfs: avoid LR buffer overrun due to crafted h_len
Date:   Mon, 26 Oct 2020 19:51:09 -0400
Message-Id: <20201026235205.1023962-77-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

[ Upstream commit f692d09e9c8fd0f5557c2e87f796a16dd95222b8 ]

Currently, crafted h_len has been blocked for the log
header of the tail block in commit a70f9fe52daa ("xfs:
detect and handle invalid iclog size set by mkfs").

However, each log record could still have crafted h_len
and cause log record buffer overrun. So let's check
h_len vs buffer size for each log record as well.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ec015df55b77a..e862f9137bf6e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2905,7 +2905,8 @@ STATIC int
 xlog_valid_rec_header(
 	struct xlog		*log,
 	struct xlog_rec_header	*rhead,
-	xfs_daddr_t		blkno)
+	xfs_daddr_t		blkno,
+	int			bufsize)
 {
 	int			hlen;
 
@@ -2921,10 +2922,14 @@ xlog_valid_rec_header(
 		return -EFSCORRUPTED;
 	}
 
-	/* LR body must have data or it wouldn't have been written */
+	/*
+	 * LR body must have data (or it wouldn't have been written)
+	 * and h_len must not be greater than LR buffer size.
+	 */
 	hlen = be32_to_cpu(rhead->h_len);
-	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > INT_MAX))
+	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > bufsize))
 		return -EFSCORRUPTED;
+
 	if (XFS_IS_CORRUPT(log->l_mp,
 			   blkno > log->l_logBBsize || blkno > INT_MAX))
 		return -EFSCORRUPTED;
@@ -2985,9 +2990,6 @@ xlog_do_recovery_pass(
 			goto bread_err1;
 
 		rhead = (xlog_rec_header_t *)offset;
-		error = xlog_valid_rec_header(log, rhead, tail_blk);
-		if (error)
-			goto bread_err1;
 
 		/*
 		 * xfsprogs has a bug where record length is based on lsunit but
@@ -3002,21 +3004,18 @@ xlog_do_recovery_pass(
 		 */
 		h_size = be32_to_cpu(rhead->h_size);
 		h_len = be32_to_cpu(rhead->h_len);
-		if (h_len > h_size) {
-			if (h_len <= log->l_mp->m_logbsize &&
-			    be32_to_cpu(rhead->h_num_logops) == 1) {
-				xfs_warn(log->l_mp,
+		if (h_len > h_size && h_len <= log->l_mp->m_logbsize &&
+		    rhead->h_num_logops == cpu_to_be32(1)) {
+			xfs_warn(log->l_mp,
 		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
-					 h_size, log->l_mp->m_logbsize);
-				h_size = log->l_mp->m_logbsize;
-			} else {
-				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-						log->l_mp);
-				error = -EFSCORRUPTED;
-				goto bread_err1;
-			}
+				 h_size, log->l_mp->m_logbsize);
+			h_size = log->l_mp->m_logbsize;
 		}
 
+		error = xlog_valid_rec_header(log, rhead, tail_blk, h_size);
+		if (error)
+			goto bread_err1;
+
 		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
 		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
 			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
@@ -3097,7 +3096,7 @@ xlog_do_recovery_pass(
 			}
 			rhead = (xlog_rec_header_t *)offset;
 			error = xlog_valid_rec_header(log, rhead,
-						split_hblks ? blk_no : 0);
+					split_hblks ? blk_no : 0, h_size);
 			if (error)
 				goto bread_err2;
 
@@ -3178,7 +3177,7 @@ xlog_do_recovery_pass(
 			goto bread_err2;
 
 		rhead = (xlog_rec_header_t *)offset;
-		error = xlog_valid_rec_header(log, rhead, blk_no);
+		error = xlog_valid_rec_header(log, rhead, blk_no, h_size);
 		if (error)
 			goto bread_err2;
 
-- 
2.25.1


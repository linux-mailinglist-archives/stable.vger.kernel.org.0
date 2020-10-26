Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8F029A1C4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502397AbgJ0Anz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409216AbgJZXuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:50:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B53C21707;
        Mon, 26 Oct 2020 23:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756250;
        bh=Pw7O8ZblEt7Bo8anqNCP7K7/gDR57mWfMojXgBHS0NI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXgXQFBW6IX6x/i2w0oHPLlEUWtlmJo+lXjtN5dJlvPITe4pmZpu8Euqo77Aj+yz9
         MBlf0rAae8DED4VmM3py1uF6sozyc7c3t+u/UNBd37QdJvXzmVKJ3oTsWrn3KRaJBw
         2SRBS+hrWvt/NX965GNM7cObb9D20X9+SY4FWWrc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 085/147] xfs: avoid LR buffer overrun due to crafted h_len
Date:   Mon, 26 Oct 2020 19:48:03 -0400
Message-Id: <20201026234905.1022767-85-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
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
index e2ec91b2d0f46..9ceb67d0f2565 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2904,7 +2904,8 @@ STATIC int
 xlog_valid_rec_header(
 	struct xlog		*log,
 	struct xlog_rec_header	*rhead,
-	xfs_daddr_t		blkno)
+	xfs_daddr_t		blkno,
+	int			bufsize)
 {
 	int			hlen;
 
@@ -2920,10 +2921,14 @@ xlog_valid_rec_header(
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
@@ -2984,9 +2989,6 @@ xlog_do_recovery_pass(
 			goto bread_err1;
 
 		rhead = (xlog_rec_header_t *)offset;
-		error = xlog_valid_rec_header(log, rhead, tail_blk);
-		if (error)
-			goto bread_err1;
 
 		/*
 		 * xfsprogs has a bug where record length is based on lsunit but
@@ -3001,21 +3003,18 @@ xlog_do_recovery_pass(
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
@@ -3096,7 +3095,7 @@ xlog_do_recovery_pass(
 			}
 			rhead = (xlog_rec_header_t *)offset;
 			error = xlog_valid_rec_header(log, rhead,
-						split_hblks ? blk_no : 0);
+					split_hblks ? blk_no : 0, h_size);
 			if (error)
 				goto bread_err2;
 
@@ -3177,7 +3176,7 @@ xlog_do_recovery_pass(
 			goto bread_err2;
 
 		rhead = (xlog_rec_header_t *)offset;
-		error = xlog_valid_rec_header(log, rhead, blk_no);
+		error = xlog_valid_rec_header(log, rhead, blk_no, h_size);
 		if (error)
 			goto bread_err2;
 
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCEA2A5922
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbgKCUmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:42:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:54950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730541AbgKCUmd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:42:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6ECF223BF;
        Tue,  3 Nov 2020 20:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436152;
        bh=KTm/RfNC7dQVflQT7/1LPU8QMPTmOOjakj/OpihlEFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcQkQZgnu2rXl2eMY3a9DPdYB57GePPq98oJrSW14MQRGAbKiXafvFkmgzrZ7nxDh
         OE1uuv5EekYx04OwYySE8fIiiZdSNmrQM+oFmXf4dx4ALEQT3MMtnsKJhAwStWuAL/
         OqF/hVz5ASZP9V3ONXWHhoxZkzi3gnYgeLEF25rg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 125/391] xfs: avoid LR buffer overrun due to crafted h_len
Date:   Tue,  3 Nov 2020 21:32:56 +0100
Message-Id: <20201103203355.260789803@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.27.0




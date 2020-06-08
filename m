Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79401F28AD
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731568AbgFHXYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731561AbgFHXYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:24:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7688B20899;
        Mon,  8 Jun 2020 23:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658641;
        bh=nPdV4t7L8LJ5km4yZ5iFxKLzj/Qptp1g8r/Ljh9YXK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mI3uLrNCNjhI5VmDL/YzRe4pbikQVQIF3xblUEacY/W7sWW3NDkNxx9aIETk8Gdbr
         Xz62ZQ+evBdR7t2SqmhFVPRZVUCF4N0C7wxKIqJRwFHm28O9vlYrGP9X0ztUmzpf3n
         OwMnMquqFOry5B+5T5dCOze/fMQvfNsNRLTB+ZEU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 062/106] xfs: fix duplicate verification from xfs_qm_dqflush()
Date:   Mon,  8 Jun 2020 19:21:54 -0400
Message-Id: <20200608232238.3368589-62-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232238.3368589-1-sashal@kernel.org>
References: <20200608232238.3368589-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 629dcb38dc351947ed6a26a997d4b587f3bd5c7e ]

The pre-flush dquot verification in xfs_qm_dqflush() duplicates the
read verifier by checking the dquot in the on-disk buffer. Instead,
verify the in-core variant before it is flushed to the buffer.

Fixes: 7224fa482a6d ("xfs: add full xfs_dqblk verifier")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_dquot.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a1af984e4913..59b2b29542f4 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1120,13 +1120,12 @@ xfs_qm_dqflush(
 	dqb = bp->b_addr + dqp->q_bufoffset;
 	ddqp = &dqb->dd_diskdq;
 
-	/*
-	 * A simple sanity check in case we got a corrupted dquot.
-	 */
-	fa = xfs_dqblk_verify(mp, dqb, be32_to_cpu(ddqp->d_id), 0);
+	/* sanity check the in-core structure before we flush */
+	fa = xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(dqp->q_core.d_id),
+			      0);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
-				be32_to_cpu(ddqp->d_id), fa);
+				be32_to_cpu(dqp->q_core.d_id), fa);
 		xfs_buf_relse(bp);
 		xfs_dqfunlock(dqp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-- 
2.25.1


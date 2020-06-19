Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8463D20125C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405284AbgFSPwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393178AbgFSPX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:23:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7460D21548;
        Fri, 19 Jun 2020 15:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580206;
        bh=5TvpbYkiQw9NZ9edJDaOVOmu8yyAmlourZTRXxSr9R0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PcakEWAuD9eCBECSjmFBW4CvgANHBsHRpUpcmPJHLr5aRmxFLsr3ElTVBC/9AjLpw
         P2M4IrrdKUNhAQg7JYyiM6fd+8YBWdJQgbd0J6F68nsylOZCkOcX+FtmSzC9du6Zyu
         ddsLZIh3hi6X4/mipbqa0ihMB4JCUbYz7MPNS9CM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 163/376] xfs: fix duplicate verification from xfs_qm_dqflush()
Date:   Fri, 19 Jun 2020 16:31:21 +0200
Message-Id: <20200619141718.038795724@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index af2c8e5ceea0..265feb62290d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1116,13 +1116,12 @@ xfs_qm_dqflush(
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




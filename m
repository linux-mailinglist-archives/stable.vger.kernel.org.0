Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25D624B7FE
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730914AbgHTKKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728922AbgHTKKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:10:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BA7720738;
        Thu, 20 Aug 2020 10:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918233;
        bh=ByK/kJ7jWro0SZOd6KIbhzj/ZVF+eektKAT83EY8AXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zM/GMNVcw+T+7Chs+yjj/WhniY+7JF+RZiBjxHbsAqrZcKfAtjNkL1MASmGuZ+evj
         qUzXg/J+nZoFDOBDpiU0I/auN1Dc1Jzr5fFZxWHPZemUbLxlwPgvSQObF7MWolO8YP
         8OULjw4XZfoNN6PJVGo+Kb/QByDoG6TqFU/JfCk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 099/228] xfs: fix reflink quota reservation accounting error
Date:   Thu, 20 Aug 2020 11:21:14 +0200
Message-Id: <20200820091612.571236307@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 83895227aba1ade33e81f586aa7b6b1e143096a5 ]

Quota reservations are supposed to account for the blocks that might be
allocated due to a bmap btree split.  Reflink doesn't do this, so fix
this to make the quota accounting more accurate before we start
rearranging things.

Fixes: 862bb360ef56 ("xfs: reflink extents from one file to another")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_reflink.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index db7f9fdd20a30..4d37f1b59436c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1076,6 +1076,7 @@ xfs_reflink_remap_extent(
 	xfs_filblks_t		rlen;
 	xfs_filblks_t		unmap_len;
 	xfs_off_t		newlen;
+	int64_t			qres;
 	int			error;
 
 	unmap_len = irec->br_startoff + irec->br_blockcount - destoff;
@@ -1098,13 +1099,19 @@ xfs_reflink_remap_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	/* If we're not just clearing space, then do we have enough quota? */
-	if (real_extent) {
-		error = xfs_trans_reserve_quota_nblks(tp, ip,
-				irec->br_blockcount, 0, XFS_QMOPT_RES_REGBLKS);
-		if (error)
-			goto out_cancel;
-	}
+	/*
+	 * Reserve quota for this operation.  We don't know if the first unmap
+	 * in the dest file will cause a bmap btree split, so we always reserve
+	 * at least enough blocks for that split.  If the extent being mapped
+	 * in is written, we need to reserve quota for that too.
+	 */
+	qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	if (real_extent)
+		qres += irec->br_blockcount;
+	error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
+			XFS_QMOPT_RES_REGBLKS);
+	if (error)
+		goto out_cancel;
 
 	trace_xfs_reflink_remap(ip, irec->br_startoff,
 				irec->br_blockcount, irec->br_startblock);
-- 
2.25.1




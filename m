Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA79324B45C
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbgHTKER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:04:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730369AbgHTKBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:01:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 291372075E;
        Thu, 20 Aug 2020 10:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917691;
        bh=uD8BoJVFMMTmXhc0uvkBTZwrcwMK5/4DLUXVP/JoR4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWX7YMitLFFvfdEQYgZYIF2Zr/zGmyC+05QdYwdgPqDFPNfRwMFNhja3Jtd1V///0
         Eg1TShwW7v+IZjLfNenCXbiv6C0oNLVxutjDPiOOOCQ5AlRtKKbvPb9DqiJYRitf/0
         X3Lb9sov7YZJkgObGT7XJkfYoQ+PwkB2kNrqAgDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 122/212] xfs: fix reflink quota reservation accounting error
Date:   Thu, 20 Aug 2020 11:21:35 +0200
Message-Id: <20200820091608.517390750@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
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
index 6b753b969f7b8..aa99711a8ff96 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1108,6 +1108,7 @@ xfs_reflink_remap_extent(
 	xfs_filblks_t		rlen;
 	xfs_filblks_t		unmap_len;
 	xfs_off_t		newlen;
+	int64_t			qres;
 	int			error;
 
 	unmap_len = irec->br_startoff + irec->br_blockcount - destoff;
@@ -1135,13 +1136,19 @@ xfs_reflink_remap_extent(
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




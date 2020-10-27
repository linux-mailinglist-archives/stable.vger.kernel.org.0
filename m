Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D10029B4F8
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793625AbgJ0PHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790961AbgJ0PFQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:05:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3F4B21707;
        Tue, 27 Oct 2020 15:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811115;
        bh=opJhYzczalZgxz25Yh5YN0jd36bZZQa/kG2ghGxf8qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y9yQ+rbI+vKW8eZftl8qhfv55cGgdX/spji68QYd2oCgRO6dtUAN6/z5YSvI84QRg
         as60Dp9RoD1kFoezMSwegbvYHuOq9yUEk1oB+jc1oH/GQ7okzAoSEIPu4Ci3D0aig8
         77uubYBg72qSlT4nf14GYiRIhd4F6StJ32egU+II=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 348/633] xfs: fix high key handling in the rt allocators query_range function
Date:   Tue, 27 Oct 2020 14:51:31 +0100
Message-Id: <20201027135539.008261782@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit d88850bd5516a77c6f727e8b6cefb64e0cc929c7 ]

Fix some off-by-one errors in xfs_rtalloc_query_range.  The highest key
in the realtime bitmap is always one less than the number of rt extents,
which means that the key clamp at the start of the function is wrong.
The 4th argument to xfs_rtfind_forw is the highest rt extent that we
want to probe, which means that passing 1 less than the high key is
wrong.  Finally, drop the rem variable that controls the loop because we
can compare the iteration point (rtstart) against the high key directly.

The sordid history of this function is that the original commit (fb3c3)
incorrectly passed (high_rec->ar_startblock - 1) as the 'limit' parameter
to xfs_rtfind_forw.  This was wrong because the "high key" is supposed
to be the largest key for which the caller wants result rows, not the
key for the first row that could possibly be outside the range that the
caller wants to see.

A subsequent attempt (8ad56) to strengthen the parameter checking added
incorrect clamping of the parameters to the number of rt blocks in the
system (despite the bitmap functions all taking units of rt extents) to
avoid querying ranges past the end of rt bitmap file but failed to fix
the incorrect _rtfind_forw parameter.  The original _rtfind_forw
parameter error then survived the conversion of the startblock and
blockcount fields to rt extents (a0e5c), and the most recent off-by-one
fix (a3a37) thought it was patching a problem when the end of the rt
volume is not in use, but none of these fixes actually solved the
original problem that the author was confused about the "limit" argument
to xfs_rtfind_forw.

Sadly, all four of these patches were written by this author and even
his own usage of this function and rt testing were inadequate to get
this fixed quickly.

Original-problem: fb3c3de2f65c ("xfs: add a couple of queries to iterate free extents in the rtbitmap")
Not-fixed-by: 8ad560d2565e ("xfs: strengthen rtalloc query range checks")
Not-fixed-by: a0e5c435babd ("xfs: fix xfs_rtalloc_rec units")
Fixes: a3a374bf1889 ("xfs: fix off-by-one error in xfs_rtalloc_query_range")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 9498ced947be9..2a38576189307 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1018,7 +1018,6 @@ xfs_rtalloc_query_range(
 	struct xfs_mount		*mp = tp->t_mountp;
 	xfs_rtblock_t			rtstart;
 	xfs_rtblock_t			rtend;
-	xfs_rtblock_t			rem;
 	int				is_free;
 	int				error = 0;
 
@@ -1027,13 +1026,12 @@ xfs_rtalloc_query_range(
 	if (low_rec->ar_startext >= mp->m_sb.sb_rextents ||
 	    low_rec->ar_startext == high_rec->ar_startext)
 		return 0;
-	if (high_rec->ar_startext > mp->m_sb.sb_rextents)
-		high_rec->ar_startext = mp->m_sb.sb_rextents;
+	high_rec->ar_startext = min(high_rec->ar_startext,
+			mp->m_sb.sb_rextents - 1);
 
 	/* Iterate the bitmap, looking for discrepancies. */
 	rtstart = low_rec->ar_startext;
-	rem = high_rec->ar_startext - rtstart;
-	while (rem) {
+	while (rtstart <= high_rec->ar_startext) {
 		/* Is the first block free? */
 		error = xfs_rtcheck_range(mp, tp, rtstart, 1, 1, &rtend,
 				&is_free);
@@ -1042,7 +1040,7 @@ xfs_rtalloc_query_range(
 
 		/* How long does the extent go for? */
 		error = xfs_rtfind_forw(mp, tp, rtstart,
-				high_rec->ar_startext - 1, &rtend);
+				high_rec->ar_startext, &rtend);
 		if (error)
 			break;
 
@@ -1055,7 +1053,6 @@ xfs_rtalloc_query_range(
 				break;
 		}
 
-		rem -= rtend - rtstart + 1;
 		rtstart = rtend + 1;
 	}
 
-- 
2.25.1




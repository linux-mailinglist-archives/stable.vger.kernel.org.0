Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF1829BA23
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783588AbgJ0P5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802817AbgJ0Pvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:51:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CB78207C3;
        Tue, 27 Oct 2020 15:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813897;
        bh=DQjGKbpQTULMZhHuUu2Ys3nYEbPtZNpbo/JbdCotYps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ud85NeXij8+7fecF6/XV9Y7XMLUeWcBE263c+xRaAySYuBovADPMEtt7vXGnAVHKM
         wE+RGx+83kAUNXKYY/6XWE5tHOAF4xPh99nakugTAsUP1DPfoePSkt8gTuRDHzFF7O
         XeNO03clqBVBu99sjEL9d9V4uu+cq+3Q9FN7gbWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 706/757] xfs: make sure the rt allocator doesnt run off the end
Date:   Tue, 27 Oct 2020 14:55:56 +0100
Message-Id: <20201027135523.621223082@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 2a6ca4baed620303d414934aa1b7b0a8e7bab05f ]

There's an overflow bug in the realtime allocator.  If the rt volume is
large enough to handle a single allocation request that is larger than
the maximum bmap extent length and the rt bitmap ends exactly on a
bitmap block boundary, it's possible that the near allocator will try to
check the freeness of a range that extends past the end of the bitmap.
This fails with a corruption error and shuts down the fs.

Therefore, constrain maxlen so that the range scan cannot run off the
end of the rt bitmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6209e7b6b895b..86994d7f7cba3 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -247,6 +247,9 @@ xfs_rtallocate_extent_block(
 		end = XFS_BLOCKTOBIT(mp, bbno + 1) - 1;
 	     i <= end;
 	     i++) {
+		/* Make sure we don't scan off the end of the rt volume. */
+		maxlen = min(mp->m_sb.sb_rextents, i + maxlen) - i;
+
 		/*
 		 * See if there's a free extent of maxlen starting at i.
 		 * If it's not so then next will contain the first non-free.
@@ -442,6 +445,14 @@ xfs_rtallocate_extent_near(
 	 */
 	if (bno >= mp->m_sb.sb_rextents)
 		bno = mp->m_sb.sb_rextents - 1;
+
+	/* Make sure we don't run off the end of the rt volume. */
+	maxlen = min(mp->m_sb.sb_rextents, bno + maxlen) - bno;
+	if (maxlen < minlen) {
+		*rtblock = NULLRTBLOCK;
+		return 0;
+	}
+
 	/*
 	 * Try the exact allocation first.
 	 */
-- 
2.25.1




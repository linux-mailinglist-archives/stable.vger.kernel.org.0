Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016B6291B7B
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730960AbgJRTbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:31:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731949AbgJRT1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:27:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C0CA2137B;
        Sun, 18 Oct 2020 19:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049231;
        bh=33y6CAiMHrSEHGXU39bA0CzSEghh64lkJPtXonBCShA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZGIXCHtDZFeLunM7R6FJfVTPMTYUmTD6I4aoCwMzwU8YpKErzXrsSEwhd9dJ56dG
         zaO+u0Gu3lKJKGJ3W+f5q6AzY8TfsoFDxDZDrC+m/QFK/xAz7Xuq1BD1ZiZvtAqIKs
         zpLe16jWvajkjNd6mq8K96MFm5UglH5ipwwbsS6M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 29/41] xfs: make sure the rt allocator doesn't run off the end
Date:   Sun, 18 Oct 2020 15:26:23 -0400
Message-Id: <20201018192635.4056198-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192635.4056198-1-sashal@kernel.org>
References: <20201018192635.4056198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

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
index 0d93d3c10fcc4..d812f84252d5b 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -257,6 +257,9 @@ xfs_rtallocate_extent_block(
 		end = XFS_BLOCKTOBIT(mp, bbno + 1) - 1;
 	     i <= end;
 	     i++) {
+		/* Make sure we don't scan off the end of the rt volume. */
+		maxlen = min(mp->m_sb.sb_rextents, i + maxlen) - i;
+
 		/*
 		 * See if there's a free extent of maxlen starting at i.
 		 * If it's not so then next will contain the first non-free.
@@ -448,6 +451,14 @@ xfs_rtallocate_extent_near(
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E809C26F400
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgIRDLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbgIRCCc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D7B521D40;
        Fri, 18 Sep 2020 02:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394551;
        bh=onzG93fM8CPUkxFDlf1NO/fsBXCLyex+W2lTCSzpUa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U92U02ng+c6NlZ2F9QKSLlqSQw8M3DPwcq1qz1qTYRxP9EeztvuwECTdG39BOcS9w
         pBAQSdfK4kIDJWg/8OJlqCzvP6puwuS8On0T1IZgttVMTelJhcZsao9Pra1kNntKbK
         KCnrmjrsbjGQex55cly2QglIIJJYuB0JRrhY/c/8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, xfs@oss.sgi.com
Subject: [PATCH AUTOSEL 5.4 068/330] xfs: fix realtime file data space leak
Date:   Thu, 17 Sep 2020 21:56:48 -0400
Message-Id: <20200918020110.2063155-68-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit 0c4da70c83d41a8461fdf50a3f7b292ecb04e378 ]

Realtime files in XFS allocate extents in rextsize units. However, the
written/unwritten state of those extents is still tracked in blocksize
units. Therefore, a realtime file can be split up into written and
unwritten extents that are not necessarily aligned to the realtime
extent size. __xfs_bunmapi() has some logic to handle these various
corner cases. Consider how it handles the following case:

1. The last extent is unwritten.
2. The last extent is smaller than the realtime extent size.
3. startblock of the last extent is not aligned to the realtime extent
   size, but startblock + blockcount is.

In this case, __xfs_bunmapi() calls xfs_bmap_add_extent_unwritten_real()
to set the second-to-last extent to unwritten. This should merge the
last and second-to-last extents, so __xfs_bunmapi() moves on to the
second-to-last extent.

However, if the size of the last and second-to-last extents combined is
greater than MAXEXTLEN, xfs_bmap_add_extent_unwritten_real() does not
merge the two extents. When that happens, __xfs_bunmapi() skips past the
last extent without unmapping it, thus leaking the space.

Fix it by only unwriting the minimum amount needed to align the last
extent to the realtime extent size, which is guaranteed to merge with
the last extent.

Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 19a600443b9ee..f8db3fe616df9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5376,16 +5376,17 @@ __xfs_bunmapi(
 		}
 		div_u64_rem(del.br_startblock, mp->m_sb.sb_rextsize, &mod);
 		if (mod) {
+			xfs_extlen_t off = mp->m_sb.sb_rextsize - mod;
+
 			/*
 			 * Realtime extent is lined up at the end but not
 			 * at the front.  We'll get rid of full extents if
 			 * we can.
 			 */
-			mod = mp->m_sb.sb_rextsize - mod;
-			if (del.br_blockcount > mod) {
-				del.br_blockcount -= mod;
-				del.br_startoff += mod;
-				del.br_startblock += mod;
+			if (del.br_blockcount > off) {
+				del.br_blockcount -= off;
+				del.br_startoff += off;
+				del.br_startblock += off;
 			} else if (del.br_startoff == start &&
 				   (del.br_state == XFS_EXT_UNWRITTEN ||
 				    tp->t_blk_res == 0)) {
@@ -5403,6 +5404,7 @@ __xfs_bunmapi(
 				continue;
 			} else if (del.br_state == XFS_EXT_UNWRITTEN) {
 				struct xfs_bmbt_irec	prev;
+				xfs_fileoff_t		unwrite_start;
 
 				/*
 				 * This one is already unwritten.
@@ -5416,12 +5418,13 @@ __xfs_bunmapi(
 				ASSERT(!isnullstartblock(prev.br_startblock));
 				ASSERT(del.br_startblock ==
 				       prev.br_startblock + prev.br_blockcount);
-				if (prev.br_startoff < start) {
-					mod = start - prev.br_startoff;
-					prev.br_blockcount -= mod;
-					prev.br_startblock += mod;
-					prev.br_startoff = start;
-				}
+				unwrite_start = max3(start,
+						     del.br_startoff - mod,
+						     prev.br_startoff);
+				mod = unwrite_start - prev.br_startoff;
+				prev.br_startoff = unwrite_start;
+				prev.br_startblock += mod;
+				prev.br_blockcount -= mod;
 				prev.br_state = XFS_EXT_UNWRITTEN;
 				error = xfs_bmap_add_extent_unwritten_real(tp,
 						ip, whichfork, &icur, &cur,
-- 
2.25.1


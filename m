Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526D427C9E2
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgI2MOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730100AbgI2Lh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF37923B19;
        Tue, 29 Sep 2020 11:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379217;
        bh=onzG93fM8CPUkxFDlf1NO/fsBXCLyex+W2lTCSzpUa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EOLxrvuAnKAXUe7gsP45eBot/vpL2MZGKdkt3p+NMLIpxqONnVLVugn09fGzOz3rS
         GvLoins5gxLmNppRzqgiz71ddugf3tx40KVpsl0uRghfHf/0vFvRwuWq3LHidHSF6q
         fWZsOjAAq//2okFaMdUqnkvSvvCIkPW4Nky/ZSNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/388] xfs: fix realtime file data space leak
Date:   Tue, 29 Sep 2020 12:56:36 +0200
Message-Id: <20200929110013.642875344@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




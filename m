Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7860329A175
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441369AbgJ0AmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408752AbgJZXtf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:49:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B6F120882;
        Mon, 26 Oct 2020 23:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756175;
        bh=mPBuKbaS/hmJtHA4/4Z3Ltibrw3uuXcBuYlOE2nTEe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VM9+rlURgFwxCtUg+pOOjqNmTIzdsK38a1kacqlQ3JDgYSpJnRy6JL2PXeLmESWmA
         imbgfETH2EAJ0CZpiU9espOZ33pqOn8HZRIt8YeFQM4AeDon0nhcdTz9DPoLABGfol
         B20SBLUCdAUW6cDV9xA0/9qlzyS6UjjK3oqKiNuw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 023/147] xfs: Set xfs_buf type flag when growing summary/bitmap files
Date:   Mon, 26 Oct 2020 19:47:01 -0400
Message-Id: <20201026234905.1022767-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

[ Upstream commit 72cc95132a93293dcd0b6f68353f4741591c9aeb ]

The following sequence of commands,

  mkfs.xfs -f -m reflink=0 -r rtdev=/dev/loop1,size=10M /dev/loop0
  mount -o rtdev=/dev/loop1 /dev/loop0 /mnt
  xfs_growfs  /mnt

... causes the following call trace to be printed on the console,

XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 331
Call Trace:
 xfs_buf_item_format+0x632/0x680
 ? kmem_alloc_large+0x29/0x90
 ? kmem_alloc+0x70/0x120
 ? xfs_log_commit_cil+0x132/0x940
 xfs_log_commit_cil+0x26f/0x940
 ? xfs_buf_item_init+0x1ad/0x240
 ? xfs_growfs_rt_alloc+0x1fc/0x280
 __xfs_trans_commit+0xac/0x370
 xfs_growfs_rt_alloc+0x1fc/0x280
 xfs_growfs_rt+0x1a0/0x5e0
 xfs_file_ioctl+0x3fd/0xc70
 ? selinux_file_ioctl+0x174/0x220
 ksys_ioctl+0x87/0xc0
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x3e/0x70
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

This occurs because the buffer being formatted has the value of
XFS_BLFT_UNKNOWN_BUF assigned to the 'type' subfield of
bip->bli_formats->blf_flags.

This commit fixes the issue by assigning one of XFS_BLFT_RTSUMMARY_BUF
and XFS_BLFT_RTBITMAP_BUF to the 'type' subfield of
bip->bli_formats->blf_flags before committing the corresponding
transaction.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6209e7b6b895b..04b953c3ffa75 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -767,8 +767,14 @@ xfs_growfs_rt_alloc(
 	struct xfs_bmbt_irec	map;		/* block map output */
 	int			nmap;		/* number of block maps */
 	int			resblks;	/* space reservation */
+	enum xfs_blft		buf_type;
 	struct xfs_trans	*tp;
 
+	if (ip == mp->m_rsumip)
+		buf_type = XFS_BLFT_RTSUMMARY_BUF;
+	else
+		buf_type = XFS_BLFT_RTBITMAP_BUF;
+
 	/*
 	 * Allocate space to the file, as necessary.
 	 */
@@ -830,6 +836,8 @@ xfs_growfs_rt_alloc(
 					mp->m_bsize, 0, &bp);
 			if (error)
 				goto out_trans_cancel;
+
+			xfs_trans_buf_set_type(tp, bp, buf_type);
 			memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
 			xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 			/*
-- 
2.25.1


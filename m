Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB33E9E186
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731059AbfH0H6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730706AbfH0H6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:58:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 025E4206BF;
        Tue, 27 Aug 2019 07:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892720;
        bh=x2yaFsxyNtdZbvKQzpaUTp9W7h6k1yHSMcCMiTZWb6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HatZyc0wqFWWcIFOPt6gdm+UzdiqIAkj/0Pxk+uaVgxg+qfmsU7VWk/t7mW+dfdE0
         khQ86GyI5jVgrvEliP74JSH9VxwQb9vKkmNu2tDNDV3W5Ggcd27MSp+DYiiHPG9Z1h
         tVbRKtR5V5GcyKyeB0FJbstgA07bHFMglxxg49po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 89/98] xfs: dont trip over uninitialized buffer on extent read of corrupted inode
Date:   Tue, 27 Aug 2019 09:51:08 +0200
Message-Id: <20190827072722.722033898@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6958d11f77d45db80f7e22a21a74d4d5f44dc667 upstream.

We've had rather rare reports of bmap btree block corruption where
the bmap root block has a level count of zero. The root cause of the
corruption is so far unknown. We do have verifier checks to detect
this form of on-disk corruption, but this doesn't cover a memory
corruption variant of the problem. The latter is a reasonable
possibility because the root block is part of the inode fork and can
reside in-core for some time before inode extents are read.

If this occurs, it leads to a system crash such as the following:

 BUG: unable to handle kernel paging request at ffffffff00000221
 PF error: [normal kernel read fault]
 ...
 RIP: 0010:xfs_trans_brelse+0xf/0x200 [xfs]
 ...
 Call Trace:
  xfs_iread_extents+0x379/0x540 [xfs]
  xfs_file_iomap_begin_delay+0x11a/0xb40 [xfs]
  ? xfs_attr_get+0xd1/0x120 [xfs]
  ? iomap_write_begin.constprop.40+0x2d0/0x2d0
  xfs_file_iomap_begin+0x4c4/0x6d0 [xfs]
  ? __vfs_getxattr+0x53/0x70
  ? iomap_write_begin.constprop.40+0x2d0/0x2d0
  iomap_apply+0x63/0x130
  ? iomap_write_begin.constprop.40+0x2d0/0x2d0
  iomap_file_buffered_write+0x62/0x90
  ? iomap_write_begin.constprop.40+0x2d0/0x2d0
  xfs_file_buffered_aio_write+0xe4/0x3b0 [xfs]
  __vfs_write+0x150/0x1b0
  vfs_write+0xba/0x1c0
  ksys_pwrite64+0x64/0xa0
  do_syscall_64+0x5a/0x1d0
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The crash occurs because xfs_iread_extents() attempts to release an
uninitialized buffer pointer as the level == 0 value prevented the
buffer from ever being allocated or read. Change the level > 0
assert to an explicit error check in xfs_iread_extents() to avoid
crashing the kernel in the event of localized, in-core inode
corruption.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3a496ffe6551c..ab2465bc413af 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1178,7 +1178,10 @@ xfs_iread_extents(
 	 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
 	 */
 	level = be16_to_cpu(block->bb_level);
-	ASSERT(level > 0);
+	if (unlikely(level == 0)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
 	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
 	bno = be64_to_cpu(*pp);
 
-- 
2.20.1




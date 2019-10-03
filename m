Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C70CA2A2
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732966AbfJCQHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731177AbfJCQHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:07:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79BC721D81;
        Thu,  3 Oct 2019 16:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118850;
        bh=baVhcnQMCbx8lsqrw3LcxRVkXg9qpZ+INcg1H4uKdQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eO0VafOFsFQxB6WpUbZ/geGs4CN7Mem5wiu07BfLQMNGyMzP68LLmi9vr7QX93OG3
         2Ms/fU8wYIWBrFy3MNg+N0Y8SI1sXBavXi8crgGNh/ZcizpnQ1Lwk/WjH+63tpq55p
         +LY2MVr9Adj368TZIwKnKf/7RI2ydKzdM7U3s27c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zorro Lang <zlang@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Bill ODonnell <billodo@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 031/185] xfs: dont crash on null attr fork xfs_bmapi_read
Date:   Thu,  3 Oct 2019 17:51:49 +0200
Message-Id: <20191003154444.745252083@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 8612de3f7ba6e900465e340516b8313806d27b2d ]

Zorro Lang reported a crash in generic/475 if we try to inactivate a
corrupt inode with a NULL attr fork (stack trace shortened somewhat):

RIP: 0010:xfs_bmapi_read+0x311/0xb00 [xfs]
RSP: 0018:ffff888047f9ed68 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888047f9f038 RCX: 1ffffffff5f99f51
RDX: 0000000000000002 RSI: 0000000000000008 RDI: 0000000000000012
RBP: ffff888002a41f00 R08: ffffed10005483f0 R09: ffffed10005483ef
R10: ffffed10005483ef R11: ffff888002a41f7f R12: 0000000000000004
R13: ffffe8fff53b5768 R14: 0000000000000005 R15: 0000000000000001
FS:  00007f11d44b5b80(0000) GS:ffff888114200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000ef6000 CR3: 000000002e176003 CR4: 00000000001606e0
Call Trace:
 xfs_dabuf_map.constprop.18+0x696/0xe50 [xfs]
 xfs_da_read_buf+0xf5/0x2c0 [xfs]
 xfs_da3_node_read+0x1d/0x230 [xfs]
 xfs_attr_inactive+0x3cc/0x5e0 [xfs]
 xfs_inactive+0x4c8/0x5b0 [xfs]
 xfs_fs_destroy_inode+0x31b/0x8e0 [xfs]
 destroy_inode+0xbc/0x190
 xfs_bulkstat_one_int+0xa8c/0x1200 [xfs]
 xfs_bulkstat_one+0x16/0x20 [xfs]
 xfs_bulkstat+0x6fa/0xf20 [xfs]
 xfs_ioc_bulkstat+0x182/0x2b0 [xfs]
 xfs_file_ioctl+0xee0/0x12a0 [xfs]
 do_vfs_ioctl+0x193/0x1000
 ksys_ioctl+0x60/0x90
 __x64_sys_ioctl+0x6f/0xb0
 do_syscall_64+0x9f/0x4d0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f11d39a3e5b

The "obvious" cause is that the attr ifork is null despite the inode
claiming an attr fork having at least one extent, but it's not so
obvious why we ended up with an inode in that state.

Reported-by: Zorro Lang <zlang@redhat.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204031
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Bill O'Donnell <billodo@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a3cc8afed367c..7b25a88569c96 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4006,15 +4006,28 @@ xfs_bmapi_read(
 	XFS_STATS_INC(mp, xs_blk_mapr);
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
+	if (!ifp) {
+		/* No CoW fork?  Return a hole. */
+		if (whichfork == XFS_COW_FORK) {
+			mval->br_startoff = bno;
+			mval->br_startblock = HOLESTARTBLOCK;
+			mval->br_blockcount = len;
+			mval->br_state = XFS_EXT_NORM;
+			*nmap = 1;
+			return 0;
+		}
 
-	/* No CoW fork?  Return a hole. */
-	if (whichfork == XFS_COW_FORK && !ifp) {
-		mval->br_startoff = bno;
-		mval->br_startblock = HOLESTARTBLOCK;
-		mval->br_blockcount = len;
-		mval->br_state = XFS_EXT_NORM;
-		*nmap = 1;
-		return 0;
+		/*
+		 * A missing attr ifork implies that the inode says we're in
+		 * extents or btree format but failed to pass the inode fork
+		 * verifier while trying to load it.  Treat that as a file
+		 * corruption too.
+		 */
+#ifdef DEBUG
+		xfs_alert(mp, "%s: inode %llu missing fork %d",
+				__func__, ip->i_ino, whichfork);
+#endif /* DEBUG */
+		return -EFSCORRUPTED;
 	}
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C962C433B
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbgKYPgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:36:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730701AbgKYPgi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:36:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE6FA221F9;
        Wed, 25 Nov 2020 15:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318596;
        bh=NDcEDa7zMJHoJhngNIzVs4CtSZ0myW4XCIPezEkyP30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0DXnNtqOKxU/OU2f7RZuumbVj3elw4bEg7L1AmDQMJMgLmSDfyGKT9r1sqrL6CvEr
         2sZo7GLliDgy495iw6UA3B09mAG/tgduz/yg/NCLsy1exZcv0/72qGdILXknV6pEsh
         KutrvhCpRfF4euTXbCaNpeF1jx17IpFjNdJKOUZM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 33/33] xfs: don't allow NOWAIT DIO across extent boundaries
Date:   Wed, 25 Nov 2020 10:35:50 -0500
Message-Id: <20201125153550.810101-33-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153550.810101-1-sashal@kernel.org>
References: <20201125153550.810101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 883a790a84401f6f55992887fd7263d808d4d05d ]

Jens has reported a situation where partial direct IOs can be issued
and completed yet still return -EAGAIN. We don't want this to report
a short IO as we want XFS to complete user DIO entirely or not at
all.

This partial IO situation can occur on a write IO that is split
across an allocated extent and a hole, and the second mapping is
returning EAGAIN because allocation would be required.

The trivial reproducer:

$ sudo xfs_io -fdt -c "pwrite 0 4k" -c "pwrite -V 1 -b 8k -N 0 8k" /mnt/scr/foo
wrote 4096/4096 bytes at offset 0
4 KiB, 1 ops; 0.0001 sec (27.509 MiB/sec and 7042.2535 ops/sec)
pwrite: Resource temporarily unavailable
$

The pwritev2(0, 8kB, RWF_NOWAIT) call returns EAGAIN having done
the first 4kB write:

 xfs_file_direct_write: dev 259:1 ino 0x83 size 0x1000 offset 0x0 count 0x2000
 iomap_apply:          dev 259:1 ino 0x83 pos 0 length 8192 flags WRITE|DIRECT|NOWAIT (0x31) ops xfs_direct_write_iomap_ops caller iomap_dio_rw actor iomap_dio_actor
 xfs_ilock_nowait:     dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_ilock_for_iomap
 xfs_iunlock:          dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_direct_write_iomap_begin
 xfs_iomap_found:      dev 259:1 ino 0x83 size 0x1000 offset 0x0 count 8192 fork data startoff 0x0 startblock 24 blockcount 0x1
 iomap_apply_dstmap:   dev 259:1 ino 0x83 bdev 259:1 addr 102400 offset 0 length 4096 type MAPPED flags DIRTY

Here the first iomap loop has mapped the first 4kB of the file and
issued the IO, and we enter the second iomap_apply loop:

 iomap_apply: dev 259:1 ino 0x83 pos 4096 length 4096 flags WRITE|DIRECT|NOWAIT (0x31) ops xfs_direct_write_iomap_ops caller iomap_dio_rw actor iomap_dio_actor
 xfs_ilock_nowait:     dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_ilock_for_iomap
 xfs_iunlock:          dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_direct_write_iomap_begin

And we exit with -EAGAIN out because we hit the allocate case trying
to make the second 4kB block.

Then IO completes on the first 4kB and the original IO context
completes and unlocks the inode, returning -EAGAIN to userspace:

 xfs_end_io_direct_write: dev 259:1 ino 0x83 isize 0x1000 disize 0x1000 offset 0x0 count 4096
 xfs_iunlock:          dev 259:1 ino 0x83 flags IOLOCK_SHARED caller xfs_file_dio_aio_write

There are other vectors to the same problem when we re-enter the
mapping code if we have to make multiple mappinfs under NOWAIT
conditions. e.g. failing trylocks, COW extents being found,
allocation being required, and so on.

Avoid all these potential problems by only allowing IOMAP_NOWAIT IO
to go ahead if the mapping we retrieve for the IO spans an entire
allocated extent. This avoids the possibility of subsequent mappings
to complete the IO from triggering NOWAIT semantics by any means as
NOWAIT IO will now only enter the mapping code once per NOWAIT IO.

Reported-and-tested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_iomap.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 3abb8b9d6f4c6..7b9ff824e82d4 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -706,6 +706,23 @@ xfs_ilock_for_iomap(
 	return 0;
 }
 
+/*
+ * Check that the imap we are going to return to the caller spans the entire
+ * range that the caller requested for the IO.
+ */
+static bool
+imap_spans_range(
+	struct xfs_bmbt_irec	*imap,
+	xfs_fileoff_t		offset_fsb,
+	xfs_fileoff_t		end_fsb)
+{
+	if (imap->br_startoff > offset_fsb)
+		return false;
+	if (imap->br_startoff + imap->br_blockcount < end_fsb)
+		return false;
+	return true;
+}
+
 static int
 xfs_direct_write_iomap_begin(
 	struct inode		*inode,
@@ -766,6 +783,18 @@ xfs_direct_write_iomap_begin(
 	if (imap_needs_alloc(inode, flags, &imap, nimaps))
 		goto allocate_blocks;
 
+	/*
+	 * NOWAIT IO needs to span the entire requested IO with a single map so
+	 * that we avoid partial IO failures due to the rest of the IO range not
+	 * covered by this map triggering an EAGAIN condition when it is
+	 * subsequently mapped and aborting the IO.
+	 */
+	if ((flags & IOMAP_NOWAIT) &&
+	    !imap_spans_range(&imap, offset_fsb, end_fsb)) {
+		error = -EAGAIN;
+		goto out_unlock;
+	}
+
 	xfs_iunlock(ip, lockmode);
 	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, iomap_flags);
-- 
2.27.0


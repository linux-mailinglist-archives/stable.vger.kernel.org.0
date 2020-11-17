Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279252B6150
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730637AbgKQNSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:18:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729863AbgKQNSE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:18:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D50DD21734;
        Tue, 17 Nov 2020 13:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619083;
        bh=73v0EOQjcde8hJakrc5xSwi/UdtVZt5BJHRBGRCCFBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOXs3rOxAjr5juxR59OsQFDkooSFHIg29LpVMzKbMGuf6U8Z4qdBB6eWMh2RNXX5F
         D2ZqvuYn3Pw++yrT5DGJmyKpLJOh1A/pP9Yokm5Yrcqvu7ZlBMYBixgOgtjarD51CJ
         22kodK819ULZCe009prTMw4ivIFUrUfXw8a3XcMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 023/101] xfs: flush new eof page on truncate to avoid post-eof corruption
Date:   Tue, 17 Nov 2020 14:04:50 +0100
Message-Id: <20201117122114.217521144@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 869ae85dae64b5540e4362d7fe4cd520e10ec05c ]

It is possible to expose non-zeroed post-EOF data in XFS if the new
EOF page is dirty, backed by an unwritten block and the truncate
happens to race with writeback. iomap_truncate_page() will not zero
the post-EOF portion of the page if the underlying block is
unwritten. The subsequent call to truncate_setsize() will, but
doesn't dirty the page. Therefore, if writeback happens to complete
after iomap_truncate_page() (so it still sees the unwritten block)
but before truncate_setsize(), the cached page becomes inconsistent
with the on-disk block. A mapped read after the associated page is
reclaimed or invalidated exposes non-zero post-EOF data.

For example, consider the following sequence when run on a kernel
modified to explicitly flush the new EOF page within the race
window:

$ xfs_io -fc "falloc 0 4k" -c fsync /mnt/file
$ xfs_io -c "pwrite 0 4k" -c "truncate 1k" /mnt/file
  ...
$ xfs_io -c "mmap 0 4k" -c "mread -v 1k 8" /mnt/file
00000400:  00 00 00 00 00 00 00 00  ........
$ umount /mnt/; mount <dev> /mnt/
$ xfs_io -c "mmap 0 4k" -c "mread -v 1k 8" /mnt/file
00000400:  cd cd cd cd cd cd cd cd  ........

Update xfs_setattr_size() to explicitly flush the new EOF page prior
to the page truncate to ensure iomap has the latest state of the
underlying block.

Fixes: 68a9f5e7007c ("xfs: implement iomap based buffered write path")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_iops.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e427ad097e2ee..948ac1290121b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -895,6 +895,16 @@ xfs_setattr_size(
 		error = iomap_zero_range(inode, oldsize, newsize - oldsize,
 				&did_zeroing, &xfs_iomap_ops);
 	} else {
+		/*
+		 * iomap won't detect a dirty page over an unwritten block (or a
+		 * cow block over a hole) and subsequently skips zeroing the
+		 * newly post-EOF portion of the page. Flush the new EOF to
+		 * convert the block before the pagecache truncate.
+		 */
+		error = filemap_write_and_wait_range(inode->i_mapping, newsize,
+						     newsize);
+		if (error)
+			return error;
 		error = iomap_truncate_page(inode, newsize, &did_zeroing,
 				&xfs_iomap_ops);
 	}
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5BB81C34
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbfHENVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730464AbfHENVK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:21:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4A772067D;
        Mon,  5 Aug 2019 13:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011269;
        bh=cHYcYpRX38VyjXDP1Qyh/hdD+iEaZNZ/xlqBy1Xp3vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgSOpiWX8mWnIZN0iwZMTafGMKa6SxdpeuX/l0MCiUDH+JJmYN3+vxtxwTpN8cHN7
         HyqT8wzgWMz6FFdS2QNDrItKYoh66GYC2xiwvbb/iq49tJTHe/iRt5bZzhLnbG5DCE
         ikL/WSSkQDoYbBXb5EgXEY+MPRdmPE2hE2cQW/cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 028/131] btrfs: Flush before reflinking any extent to prevent NOCOW write falling back to COW without data reservation
Date:   Mon,  5 Aug 2019 15:01:55 +0200
Message-Id: <20190805124953.324574894@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a94d1d0cb3bf1983fcdf05b59d914dbff4f1f52c ]

[BUG]
The following script can cause unexpected fsync failure:

  #!/bin/bash

  dev=/dev/test/test
  mnt=/mnt/btrfs

  mkfs.btrfs -f $dev -b 512M > /dev/null
  mount $dev $mnt -o nospace_cache

  # Prealloc one extent
  xfs_io -f -c "falloc 8k 64m" $mnt/file1
  # Fill the remaining data space
  xfs_io -f -c "pwrite 0 -b 4k 512M" $mnt/padding
  sync

  # Write into the prealloc extent
  xfs_io -c "pwrite 1m 16m" $mnt/file1

  # Reflink then fsync, fsync would fail due to ENOSPC
  xfs_io -c "reflink $mnt/file1 8k 0 4k" -c "fsync" $mnt/file1
  umount $dev

The fsync fails with ENOSPC, and the last page of the buffered write is
lost.

[CAUSE]
This is caused by:
- Btrfs' back reference only has extent level granularity
  So write into shared extent must be COWed even only part of the extent
  is shared.

So for above script we have:
- fallocate
  Create a preallocated extent where we can do NOCOW write.

- fill all the remaining data and unallocated space

- buffered write into preallocated space
  As we have not enough space available for data and the extent is not
  shared (yet) we fall into NOCOW mode.

- reflink
  Now part of the large preallocated extent is shared, later write
  into that extent must be COWed.

- fsync triggers writeback
  But now the extent is shared and therefore we must fallback into COW
  mode, which fails with ENOSPC since there's not enough space to
  allocate data extents.

[WORKAROUND]
The workaround is to ensure any buffered write in the related extents
(not just the reflink source range) get flushed before reflink/dedupe,
so that NOCOW writes succeed that happened before reflinking succeed.

The workaround is expensive, we could do it better by only flushing
NOCOW range, but that needs extra accounting for NOCOW range.
For now, fix the possible data loss first.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2a1be0d1a6986..5b4beebf138ce 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3999,6 +3999,27 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	if (!same_inode)
 		inode_dio_wait(inode_out);
 
+	/*
+	 * Workaround to make sure NOCOW buffered write reach disk as NOCOW.
+	 *
+	 * Btrfs' back references do not have a block level granularity, they
+	 * work at the whole extent level.
+	 * NOCOW buffered write without data space reserved may not be able
+	 * to fall back to CoW due to lack of data space, thus could cause
+	 * data loss.
+	 *
+	 * Here we take a shortcut by flushing the whole inode, so that all
+	 * nocow write should reach disk as nocow before we increase the
+	 * reference of the extent. We could do better by only flushing NOCOW
+	 * data, but that needs extra accounting.
+	 *
+	 * Also we don't need to check ASYNC_EXTENT, as async extent will be
+	 * CoWed anyway, not affecting nocow part.
+	 */
+	ret = filemap_flush(inode_in->i_mapping);
+	if (ret < 0)
+		return ret;
+
 	ret = btrfs_wait_ordered_range(inode_in, ALIGN_DOWN(pos_in, bs),
 				       wb_len);
 	if (ret < 0)
-- 
2.20.1




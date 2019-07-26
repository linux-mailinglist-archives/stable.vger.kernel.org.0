Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8627A76A90
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387460AbfGZNk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387451AbfGZNk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:40:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 796D622CBF;
        Fri, 26 Jul 2019 13:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148425;
        bh=dyzX37OIZYCFr2Y7qa+NiiW8n2qepCp8LuDQKdwJyfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BpJ9+SzBGqk5mr539sMCbpy5Th/0rezfIqCWMqCzSD86jZHW+fAtAgHGHsTCszvtD
         1qi1fO17TPpYgmQ/MvcMS1+NVKoeI4/PBXhmVqtBMxrYtceB2/7EoL8ipaXdgSFV6K
         y5cwEWhG+E09OM9MqKOQQqI0miFL/Lp+Oe42Q6wc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 28/85] btrfs: Flush before reflinking any extent to prevent NOCOW write falling back to COW without data reservation
Date:   Fri, 26 Jul 2019 09:38:38 -0400
Message-Id: <20190726133936.11177-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

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
index 2a1be0d1a698..5b4beebf138c 100644
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


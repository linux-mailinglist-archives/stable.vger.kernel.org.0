Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D95D15775C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbgBJMlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729875AbgBJMlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:04 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F90E20733;
        Mon, 10 Feb 2020 12:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338463;
        bh=5VBNO7uN+Q4G/hl5H5RGFpvPVmhb/ewkZwU4E/lR4V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nr7Pi4rwyhm7mAjRhOhlZy1UDAW3V32odYEUH45sjcufj/DMEs5MzmqHrtrs3ezzY
         dkiKDxc7LA9oqVPnJ2mI3+HxnW2uF5gYs1uGbZt2kVcngZpUUUsg7+BZoWXUUwS348
         dN7acmbhj7R0zuABVEeKUdJgfLMNpGB1tdORJu5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.5 204/367] Btrfs: send, fix emission of invalid clone operations within the same file
Date:   Mon, 10 Feb 2020 04:31:57 -0800
Message-Id: <20200210122443.316363673@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 9722b10148504c4153a74a9c89725af271e490fc upstream.

When doing an incremental send and a file has extents shared with itself
at different file offsets, it's possible for send to emit clone operations
that will fail at the destination because the source range goes beyond the
file's current size. This happens when the file size has increased in the
send snapshot, there is a hole between the shared extents and both shared
extents are at file offsets which are greater the file's size in the
parent snapshot.

Example:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt/sdb

  $ xfs_io -f -c "pwrite -S 0xf1 0 64K" /mnt/sdb/foobar
  $ btrfs subvolume snapshot -r /mnt/sdb /mnt/sdb/base
  $ btrfs send -f /tmp/1.snap /mnt/sdb/base

  # Create a 320K extent at file offset 512K.
  $ xfs_io -c "pwrite -S 0xab 512K 64K" /mnt/sdb/foobar
  $ xfs_io -c "pwrite -S 0xcd 576K 64K" /mnt/sdb/foobar
  $ xfs_io -c "pwrite -S 0xef 640K 64K" /mnt/sdb/foobar
  $ xfs_io -c "pwrite -S 0x64 704K 64K" /mnt/sdb/foobar
  $ xfs_io -c "pwrite -S 0x73 768K 64K" /mnt/sdb/foobar

  # Clone part of that 320K extent into a lower file offset (192K).
  # This file offset is greater than the file's size in the parent
  # snapshot (64K). Also the clone range is a bit behind the offset of
  # the 320K extent so that we leave a hole between the shared extents.
  $ xfs_io -c "reflink /mnt/sdb/foobar 448K 192K 192K" /mnt/sdb/foobar

  $ btrfs subvolume snapshot -r /mnt/sdb /mnt/sdb/incr
  $ btrfs send -p /mnt/sdb/base -f /tmp/2.snap /mnt/sdb/incr

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt/sdc

  $ btrfs receive -f /tmp/1.snap /mnt/sdc
  $ btrfs receive -f /tmp/2.snap /mnt/sdc
  ERROR: failed to clone extents to foobar: Invalid argument

The problem is that after processing the extent at file offset 256K, which
refers to the first 128K of the 320K extent created by the buffered write
operations, we have 'cur_inode_next_write_offset' set to 384K, which
corresponds to the end offset of the partially shared extent (256K + 128K)
and to the current file size in the receiver. Then when we process the
extent at offset 512K, we do extent backreference iteration to figure out
if we can clone the extent from some other inode or from the same inode,
and we consider the extent at offset 256K of the same inode as a valid
source for a clone operation, which is not correct because at that point
the current file size in the receiver is 384K, which corresponds to the
end of last processed extent (at file offset 256K), so using a clone
source range from 256K to 256K + 320K is invalid because that goes past
the current size of the file (384K) - this makes the receiver get an
-EINVAL error when attempting the clone operation.

So fix this by excluding clone sources that have a range that goes beyond
the current file size in the receiver when iterating extent backreferences.

A test case for fstests follows soon.

Fixes: 11f2069c113e02 ("Btrfs: send, allow clone operations within the same file")
CC: stable@vger.kernel.org # 5.5+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1269,7 +1269,8 @@ static int __iterate_backrefs(u64 ino, u
 		 * destination of the stream.
 		 */
 		if (ino == bctx->cur_objectid &&
-		    offset >= bctx->sctx->cur_inode_next_write_offset)
+		    offset + bctx->extent_len >
+		    bctx->sctx->cur_inode_next_write_offset)
 			return 0;
 	}
 



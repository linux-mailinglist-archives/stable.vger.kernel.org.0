Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5104428B73D
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731143AbgJLNlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730935AbgJLNlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:41:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6D222074F;
        Mon, 12 Oct 2020 13:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510068;
        bh=b/2IR38nm6lRVpvPTsy+ng0C1Ow0lnQ250QHF6yuCkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oi49tRXkWdED1nucVFt0EjYbZ6s6sGnl08QSjw47SEbjqzJIz25W21rQZiF1luIIV
         xjqyoOg9qdG/39E7+TBZg5KyhLsCPKnxY2Xthh28ldKNq23NKmbyXw8ukyoQIfGr3h
         fjF9e4spIpHpRZkcQzS6IpgHhyE1bbEzwZIefof0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.4 27/85] Btrfs: send, fix emission of invalid clone operations within the same file
Date:   Mon, 12 Oct 2020 15:26:50 +0200
Message-Id: <20201012132634.157773036@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1270,7 +1270,8 @@ static int __iterate_backrefs(u64 ino, u
 		 * destination of the stream.
 		 */
 		if (ino == bctx->cur_objectid &&
-		    offset >= bctx->sctx->cur_inode_next_write_offset)
+		    offset + bctx->extent_len >
+		    bctx->sctx->cur_inode_next_write_offset)
 			return 0;
 	}
 



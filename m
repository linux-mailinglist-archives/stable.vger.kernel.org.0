Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B9C20DCA8
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732659AbgF2TZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732609AbgF2TZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87B8C2532E;
        Mon, 29 Jun 2020 15:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445164;
        bh=OcH8GRCKOWgmoViLI3P0qqQ0oMYWYwFKp35jGfML/54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eToR/UcnGfZTlaKHiv1Qex5zjy30pnl9goG5ndi3F0lt3MTWXyZrP9EaKFtPLuBfU
         voSRzXJx6JLWt4b55CBSdwGRAFYQVl/NmXVXSn6Oo3+T3q/6QGnWDwFBPK6U4B7Fz3
         avHHik79vFTdmmU9LGU1Ku/2dnN2AqW1sQ8yQXg8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 63/78] btrfs: fix failure of RWF_NOWAIT write into prealloc extent beyond eof
Date:   Mon, 29 Jun 2020 11:37:51 -0400
Message-Id: <20200629153806.2494953-64-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 4b1946284dd6641afdb9457101056d9e6ee6204c upstream.

If we attempt to write to prealloc extent located after eof using a
RWF_NOWAIT write, we always fail with -EAGAIN.

We do actually check if we have an allocated extent for the write at
the start of btrfs_file_write_iter() through a call to check_can_nocow(),
but later when we go into the actual direct IO write path we simply
return -EAGAIN if the write starts at or beyond EOF.

Trivial to reproduce:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ touch /mnt/foo
  $ chattr +C /mnt/foo

  $ xfs_io -d -c "pwrite -S 0xab 0 64K" /mnt/foo
  wrote 65536/65536 bytes at offset 0
  64 KiB, 16 ops; 0.0004 sec (135.575 MiB/sec and 34707.1584 ops/sec)

  $ xfs_io -c "falloc -k 64K 1M" /mnt/foo

  $ xfs_io -d -c "pwrite -N -V 1 -S 0xfe -b 64K 64K 64K" /mnt/foo
  pwrite: Resource temporarily unavailable

On xfs and ext4 the write succeeds, as expected.

Fix this by removing the wrong check at btrfs_direct_IO().

Fixes: edf064e7c6fec3 ("btrfs: nowait aio support")
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ad138f0b0ce12..39ad582d72c4b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8947,9 +8947,6 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			dio_data.overwrite = 1;
 			inode_unlock(inode);
 			relock = true;
-		} else if (iocb->ki_flags & IOCB_NOWAIT) {
-			ret = -EAGAIN;
-			goto out;
 		}
 		ret = btrfs_delalloc_reserve_space(inode, &data_reserved,
 						   offset, count);
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A1420E701
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbgF2Vwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbgF2Sfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D928247B1;
        Mon, 29 Jun 2020 15:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444114;
        bh=Yn0VfqWS4xDvXpPauWQ/AwR0jBqLHAG+sbhriLI01aE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsDVryGM5wt0lfyjuKnrDTZ8kiHIjxe+nT2D5ZV4nF5yXjQ22GFIzBxKH+vaepsse
         3KcMThkvxXtiVHKpqOD0N6oxVFzY7aHFGdeR5ovw6G7TY67QppsyUGL9ogwRss7XvE
         pMj6yhDpkw7OGakCzL74bZanLka894NnUuKiZY4c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 226/265] btrfs: fix failure of RWF_NOWAIT write into prealloc extent beyond eof
Date:   Mon, 29 Jun 2020 11:17:39 -0400
Message-Id: <20200629151818.2493727-227-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
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
index 18111b0263d71..6aa200e373c8f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8262,9 +8262,6 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
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


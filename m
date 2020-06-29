Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACD120DA59
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbgF2T4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387648AbgF2TkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2559B2491B;
        Mon, 29 Jun 2020 15:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444472;
        bh=X6PyK9vQHq019m+5vte1gbSKyERkXScBvVNW3TjqUCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xIFKLgLC/vEmowtyN3B5xnNG55ytXIGwzxB5+z+mMPutqd8zE+VO4PGx25Nqxh0+L
         3w6KbAEdMQLgapndIPu/2K2hnbMERjHshh7p60TW9h2LTIRs2yfwnv+npkvyhHbgL0
         PWA2Q5c+b3raNaX6qstRBEQY0zMNN95adk99Z1/8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 153/178] btrfs: fix failure of RWF_NOWAIT write into prealloc extent beyond eof
Date:   Mon, 29 Jun 2020 11:24:58 -0400
Message-Id: <20200629152523.2494198-154-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
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
index 0984601418e50..280c45c91ddc4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8857,9 +8857,6 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
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


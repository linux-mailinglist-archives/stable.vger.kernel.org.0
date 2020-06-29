Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C37920DC59
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgF2UOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:14:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732837AbgF2TaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD2AF252A2;
        Mon, 29 Jun 2020 15:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445011;
        bh=yaxxQRVddgLLU1mEzBS9LCPeKyakKlY+qyYxcS2VEjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgVdsMkUWFgR7Y6fCFsoYAcAF5yiyUKg//o7/N1MHWlf3VTGWQXFyesvQzlWiw3XE
         phzqjn4umUbBgp+/5U+7TIObqpe9IxdctWd6hs6on4ACDOAjb18Uh2OeSIb2HFFMPC
         pjg6kVG/pnX9oJ/lAG0OzWg0wIH2nPLUlgepFGzQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 112/131] btrfs: fix failure of RWF_NOWAIT write into prealloc extent beyond eof
Date:   Mon, 29 Jun 2020 11:34:43 -0400
Message-Id: <20200629153502.2494656-113-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
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
index 7ffb15b473a72..8dd2702ce859e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8656,9 +8656,6 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
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


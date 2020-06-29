Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E47620E758
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391603AbgF2V4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgF2Sfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EEF0247AF;
        Mon, 29 Jun 2020 15:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444114;
        bh=ENgkJVTolnCjsYCFo4x7kLx6RHWaOF/1KVZMARmqOnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0U0fsl1q1b6UvByWqAqwnu3EsnYaiPmSNUrD3GyXN7j48EuSbPDLDgPsPc2A56i2I
         xUYUh9gJIy0E/I7V3ci806ZuPStCTOW0u+6LO78p5rL0+RoPkROLRrvb6CrCGxw8wh
         yFQqy/9sIigjxQwq2xGugXSLPOVop8lXZ3lwtn+M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 225/265] btrfs: fix hang on snapshot creation after RWF_NOWAIT write
Date:   Mon, 29 Jun 2020 11:17:38 -0400
Message-Id: <20200629151818.2493727-226-sashal@kernel.org>
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

commit f2cb2f39ccc30fa13d3ac078d461031a63960e5b upstream.

If we do a successful RWF_NOWAIT write we end up locking the snapshot lock
of the inode, through a call to check_can_nocow(), but we never unlock it.

This means the next attempt to create a snapshot on the subvolume will
hang forever.

Trivial reproducer:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ touch /mnt/foobar
  $ chattr +C /mnt/foobar
  $ xfs_io -d -c "pwrite -S 0xab 0 64K" /mnt/foobar
  $ xfs_io -d -c "pwrite -N -V 1 -S 0xfe 0 64K" /mnt/foobar

  $ btrfs subvolume snapshot -r /mnt /mnt/snap
    --> hangs

Fix this by unlocking the snapshot lock if check_can_nocow() returned
success.

Fixes: edf064e7c6fec3 ("btrfs: nowait aio support")
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 719e68ab552c5..484803f8b2290 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1922,6 +1922,8 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 			inode_unlock(inode);
 			return -EAGAIN;
 		}
+		/* check_can_nocow() locks the snapshot lock on success */
+		btrfs_drew_write_unlock(&root->snapshot_lock);
 	}
 
 	current->backing_dev_info = inode_to_bdi(inode);
-- 
2.25.1


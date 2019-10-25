Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57978E4D51
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 15:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632989AbfJYN7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 09:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2632915AbfJYN7J (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:59:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FA402245D;
        Fri, 25 Oct 2019 13:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011948;
        bh=Rra1HkeYZZAUy6HVOskcmRZCJVCSWBkK8qI8nsO/Jh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gh1fPIRCbonn6y/RlVu8pX47+v+n584h6WOYaqQjlH2zBNeL1Jgzm9yiIZuxivOp9
         UojotZ83zRqphbFIwMXgeO+2fRfVZ2UPhhsnjZnaN7Mj4VR+i62ADoSDBOaEJ5FLDx
         lmXb8DrZwtoFddnVRLAbVBtqcHnUUNPe5kyNCGp4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 13/16] Btrfs: fix hang when loading existing inode cache off disk
Date:   Fri, 25 Oct 2019 09:58:37 -0400
Message-Id: <20191025135842.25977-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135842.25977-1-sashal@kernel.org>
References: <20191025135842.25977-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 7764d56baa844d7f6206394f21a0e8c1f303c476 ]

If we are able to load an existing inode cache off disk, we set the state
of the cache to BTRFS_CACHE_FINISHED, but we don't wake up any one waiting
for the cache to be available. This means that anyone waiting for the
cache to be available, waiting on the condition that either its state is
BTRFS_CACHE_FINISHED or its available free space is greather than zero,
can hang forever.

This could be observed running fstests with MOUNT_OPTIONS="-o inode_cache",
in particular test case generic/161 triggered it very frequently for me,
producing a trace like the following:

  [63795.739712] BTRFS info (device sdc): enabling inode map caching
  [63795.739714] BTRFS info (device sdc): disk space caching is enabled
  [63795.739716] BTRFS info (device sdc): has skinny extents
  [64036.653886] INFO: task btrfs-transacti:3917 blocked for more than 120 seconds.
  [64036.654079]       Not tainted 5.2.0-rc4-btrfs-next-50 #1
  [64036.654143] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [64036.654232] btrfs-transacti D    0  3917      2 0x80004000
  [64036.654239] Call Trace:
  [64036.654258]  ? __schedule+0x3ae/0x7b0
  [64036.654271]  schedule+0x3a/0xb0
  [64036.654325]  btrfs_commit_transaction+0x978/0xae0 [btrfs]
  [64036.654339]  ? remove_wait_queue+0x60/0x60
  [64036.654395]  transaction_kthread+0x146/0x180 [btrfs]
  [64036.654450]  ? btrfs_cleanup_transaction+0x620/0x620 [btrfs]
  [64036.654456]  kthread+0x103/0x140
  [64036.654464]  ? kthread_create_worker_on_cpu+0x70/0x70
  [64036.654476]  ret_from_fork+0x3a/0x50
  [64036.654504] INFO: task xfs_io:3919 blocked for more than 120 seconds.
  [64036.654568]       Not tainted 5.2.0-rc4-btrfs-next-50 #1
  [64036.654617] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [64036.654685] xfs_io          D    0  3919   3633 0x00000000
  [64036.654691] Call Trace:
  [64036.654703]  ? __schedule+0x3ae/0x7b0
  [64036.654716]  schedule+0x3a/0xb0
  [64036.654756]  btrfs_find_free_ino+0xa9/0x120 [btrfs]
  [64036.654764]  ? remove_wait_queue+0x60/0x60
  [64036.654809]  btrfs_create+0x72/0x1f0 [btrfs]
  [64036.654822]  lookup_open+0x6bc/0x790
  [64036.654849]  path_openat+0x3bc/0xc00
  [64036.654854]  ? __lock_acquire+0x331/0x1cb0
  [64036.654869]  do_filp_open+0x99/0x110
  [64036.654884]  ? __alloc_fd+0xee/0x200
  [64036.654895]  ? do_raw_spin_unlock+0x49/0xc0
  [64036.654909]  ? do_sys_open+0x132/0x220
  [64036.654913]  do_sys_open+0x132/0x220
  [64036.654926]  do_syscall_64+0x60/0x1d0
  [64036.654933]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fix this by adding a wake_up() call right after setting the cache state to
BTRFS_CACHE_FINISHED, at start_caching(), when we are able to load the
cache from disk.

Fixes: 82d5902d9c681b ("Btrfs: Support reading/writing on disk free ino cache")
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode-map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 07573dc1614ab..3469c7ce7cb6d 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -158,6 +158,7 @@ static void start_caching(struct btrfs_root *root)
 		spin_lock(&root->ino_cache_lock);
 		root->ino_cache_state = BTRFS_CACHE_FINISHED;
 		spin_unlock(&root->ino_cache_lock);
+		wake_up(&root->ino_cache_wait);
 		return;
 	}
 
-- 
2.20.1


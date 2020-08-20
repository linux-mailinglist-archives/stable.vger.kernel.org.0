Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB9E24B3DC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgHTJxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729902AbgHTJwT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:52:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 918AC2075E;
        Thu, 20 Aug 2020 09:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917139;
        bh=jJZQ2Q5plHGfXu41EuKebQ1bTsoUq7FzMItxBUilFGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ccOdvE/lTABzNprIxsRXuPIDyT+hxwEpNV1a4XLsZchKY5saibcetcnqd3Pgm2LSl
         6wgUkZcc5GQGQSa9iVG+gzEM2PWIgUDcvuaPm+XM0gZDswqtS6Bf6T6PT2VFVZhDW6
         XcIs/fNgBbESrxbDhoWK+TjDeufYAaYwT4/bRqXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greed Rong <greedrong@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 09/92] btrfs: free anon block device right after subvolume deletion
Date:   Thu, 20 Aug 2020 11:20:54 +0200
Message-Id: <20200820091537.984571719@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 082b6c970f02fefd278c7833880cda29691a5f34 upstream.

[BUG]
When a lot of subvolumes are created, there is a user report about
transaction aborted caused by slow anonymous block device reclaim:

  BTRFS: Transaction aborted (error -24)
  WARNING: CPU: 17 PID: 17041 at fs/btrfs/transaction.c:1576 create_pending_snapshot+0xbc4/0xd10 [btrfs]
  RIP: 0010:create_pending_snapshot+0xbc4/0xd10 [btrfs]
  Call Trace:
   create_pending_snapshots+0x82/0xa0 [btrfs]
   btrfs_commit_transaction+0x275/0x8c0 [btrfs]
   btrfs_mksubvol+0x4b9/0x500 [btrfs]
   btrfs_ioctl_snap_create_transid+0x174/0x180 [btrfs]
   btrfs_ioctl_snap_create_v2+0x11c/0x180 [btrfs]
   btrfs_ioctl+0x11a4/0x2da0 [btrfs]
   do_vfs_ioctl+0xa9/0x640
   ksys_ioctl+0x67/0x90
   __x64_sys_ioctl+0x1a/0x20
   do_syscall_64+0x5a/0x110
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  ---[ end trace 33f2f83f3d5250e9 ]---
  BTRFS: error (device sda1) in create_pending_snapshot:1576: errno=-24 unknown
  BTRFS info (device sda1): forced readonly
  BTRFS warning (device sda1): Skipping commit of aborted transaction.
  BTRFS: error (device sda1) in cleanup_transaction:1831: errno=-24 unknown

[CAUSE]
The anonymous device pool is shared and its size is 1M. It's possible to
hit that limit if the subvolume deletion is not fast enough and the
subvolumes to be cleaned keep the ids allocated.

[WORKAROUND]
We can't avoid the anon device pool exhaustion but we can shorten the
time the id is attached to the subvolume root once the subvolume becomes
invisible to the user.

Reported-by: Greed Rong <greedrong@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CA+UqX+NTrZ6boGnWHhSeZmEY5J76CTqmYjO2S+=tHJX7nb9DPw@mail.gmail.com/
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4458,6 +4458,8 @@ int btrfs_delete_subvolume(struct inode
 		}
 	}
 
+	free_anon_bdev(dest->anon_dev);
+	dest->anon_dev = 0;
 out_end_trans:
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;



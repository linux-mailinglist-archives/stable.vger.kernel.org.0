Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E2624B925
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbgHTLj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:39:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730504AbgHTKFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:05:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5817622BF5;
        Thu, 20 Aug 2020 10:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917913;
        bh=US4a1uBbzbI+EnCRU5gop6P4sCc4kVOsBmWBsMilkvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gd360XPL6FN7jT4pw6NCp12SFtARpugIoQ80kU0L3H+FCAfYC8oiGfcmPgSd6PTjj
         /XHmDfj8PlEnrE/u1obCfYZm9xvqUSuBAAAtcSEDQ/Jt+UGBB2yMzsIWPSHn9B81AI
         hMrXDNUUXIJZobbklNqHT9Xl72IUJSpaSokL8mwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greed Rong <greedrong@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 171/212] btrfs: dont allocate anonymous block device for user invisible roots
Date:   Thu, 20 Aug 2020 11:22:24 +0200
Message-Id: <20200820091611.024483645@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 851fd730a743e072badaf67caf39883e32439431 upstream.

[BUG]
When a lot of subvolumes are created, there is a user report about
transaction aborted:

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
The error is EMFILE (Too many files open) and comes from the anonymous
block device allocation. The ids are in a shared pool of size 1<<20.

The ids are assigned to live subvolumes, ie. the root structure exists
in memory (eg. after creation or after the root appears in some path).
The pool could be exhausted if the numbers are not reclaimed fast
enough, after subvolume deletion or if other system component uses the
anon block devices.

[WORKAROUND]
Since it's not possible to completely solve the problem, we can only
minimize the time the id is allocated to a subvolume root.

Firstly, we can reduce the use of anon_dev by trees that are not
subvolume roots, like data reloc tree.

This patch will do extra check on root objectid, to skip roots that
don't need anon_dev.  Currently it's only data reloc tree and orphan
roots.

Reported-by: Greed Rong <greedrong@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CA+UqX+NTrZ6boGnWHhSeZmEY5J76CTqmYjO2S+=tHJX7nb9DPw@mail.gmail.com/
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1527,9 +1527,16 @@ int btrfs_init_fs_root(struct btrfs_root
 	spin_lock_init(&root->ino_cache_lock);
 	init_waitqueue_head(&root->ino_cache_wait);
 
-	ret = get_anon_bdev(&root->anon_dev);
-	if (ret)
-		goto fail;
+	/*
+	 * Don't assign anonymous block device to roots that are not exposed to
+	 * userspace, the id pool is limited to 1M
+	 */
+	if (is_fstree(root->root_key.objectid) &&
+	    btrfs_root_refs(&root->root_item) > 0) {
+		ret = get_anon_bdev(&root->anon_dev);
+		if (ret)
+			goto fail;
+	}
 
 	mutex_lock(&root->objectid_mutex);
 	ret = btrfs_find_highest_objectid(root,



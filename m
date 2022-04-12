Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187FF4FD5EF
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377634AbiDLHu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359382AbiDLHm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AD42C67B;
        Tue, 12 Apr 2022 00:21:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECAD2616B2;
        Tue, 12 Apr 2022 07:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E26C385A1;
        Tue, 12 Apr 2022 07:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748113;
        bh=BLL1ThT14rAdfe7KLHhuxZlKwl3O7IlydZEAE1URQJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2wcWehQgyyspLRmIRcJuf0+cGzWQeYphntSVyllqwUpJuRWWSS7tjOm/WrK6WbMe
         AGISHuTRRuBCybQ6hhi9gehlvmifpF/5CN1BE9K55BSATTschdsLqWEeNfCzMNSNK7
         RbS5umIuwc8peFkcjy4znSXksUcJy9RIHASUHvQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 284/343] btrfs: zoned: traverse devices under chunk_mutex in btrfs_can_activate_zone
Date:   Tue, 12 Apr 2022 08:31:42 +0200
Message-Id: <20220412062959.521602308@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 0b9e66762aa0cda2a9c2d5542d64e04dac528fa6 upstream.

btrfs_can_activate_zone() can be called with the device_list_mutex already
held, which will lead to a deadlock:

insert_dev_extents() // Takes device_list_mutex
`-> insert_dev_extent()
 `-> btrfs_insert_empty_item()
  `-> btrfs_insert_empty_items()
   `-> btrfs_search_slot()
    `-> btrfs_cow_block()
     `-> __btrfs_cow_block()
      `-> btrfs_alloc_tree_block()
       `-> btrfs_reserve_extent()
        `-> find_free_extent()
         `-> find_free_extent_update_loop()
          `-> can_allocate_chunk()
           `-> btrfs_can_activate_zone() // Takes device_list_mutex again

Instead of using the RCU on fs_devices->device_list we
can use fs_devices->alloc_list, protected by the chunk_mutex to traverse
the list of active devices.

We are in the chunk allocation thread. The newer chunk allocation
happens from the devices in the fs_device->alloc_list protected by the
chunk_mutex.

  btrfs_create_chunk()
    lockdep_assert_held(&info->chunk_mutex);
    gather_device_info
      list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list)

Also, a device that reappears after the mount won't join the alloc_list
yet and, it will be in the dev_list, which we don't want to consider in
the context of the chunk alloc.

  [15.166572] WARNING: possible recursive locking detected
  [15.167117] 5.17.0-rc6-dennis #79 Not tainted
  [15.167487] --------------------------------------------
  [15.167733] kworker/u8:3/146 is trying to acquire lock:
  [15.167733] ffff888102962ee0 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: find_free_extent+0x15a/0x14f0 [btrfs]
  [15.167733]
  [15.167733] but task is already holding lock:
  [15.167733] ffff888102962ee0 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: btrfs_create_pending_block_groups+0x20a/0x560 [btrfs]
  [15.167733]
  [15.167733] other info that might help us debug this:
  [15.167733]  Possible unsafe locking scenario:
  [15.167733]
  [15.171834]        CPU0
  [15.171834]        ----
  [15.171834]   lock(&fs_devs->device_list_mutex);
  [15.171834]   lock(&fs_devs->device_list_mutex);
  [15.171834]
  [15.171834]  *** DEADLOCK ***
  [15.171834]
  [15.171834]  May be due to missing lock nesting notation
  [15.171834]
  [15.171834] 5 locks held by kworker/u8:3/146:
  [15.171834]  #0: ffff888100050938 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x1c3/0x5a0
  [15.171834]  #1: ffffc9000067be80 ((work_completion)(&fs_info->async_data_reclaim_work)){+.+.}-{0:0}, at: process_one_work+0x1c3/0x5a0
  [15.176244]  #2: ffff88810521e620 (sb_internal){.+.+}-{0:0}, at: flush_space+0x335/0x600 [btrfs]
  [15.176244]  #3: ffff888102962ee0 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: btrfs_create_pending_block_groups+0x20a/0x560 [btrfs]
  [15.176244]  #4: ffff8881152e4b78 (btrfs-dev-00){++++}-{3:3}, at: __btrfs_tree_lock+0x27/0x130 [btrfs]
  [15.179641]
  [15.179641] stack backtrace:
  [15.179641] CPU: 1 PID: 146 Comm: kworker/u8:3 Not tainted 5.17.0-rc6-dennis #79
  [15.179641] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35 04/01/2014
  [15.179641] Workqueue: events_unbound btrfs_async_reclaim_data_space [btrfs]
  [15.179641] Call Trace:
  [15.179641]  <TASK>
  [15.179641]  dump_stack_lvl+0x45/0x59
  [15.179641]  __lock_acquire.cold+0x217/0x2b2
  [15.179641]  lock_acquire+0xbf/0x2b0
  [15.183838]  ? find_free_extent+0x15a/0x14f0 [btrfs]
  [15.183838]  __mutex_lock+0x8e/0x970
  [15.183838]  ? find_free_extent+0x15a/0x14f0 [btrfs]
  [15.183838]  ? find_free_extent+0x15a/0x14f0 [btrfs]
  [15.183838]  ? lock_is_held_type+0xd7/0x130
  [15.183838]  ? find_free_extent+0x15a/0x14f0 [btrfs]
  [15.183838]  find_free_extent+0x15a/0x14f0 [btrfs]
  [15.183838]  ? _raw_spin_unlock+0x24/0x40
  [15.183838]  ? btrfs_get_alloc_profile+0x106/0x230 [btrfs]
  [15.187601]  btrfs_reserve_extent+0x131/0x260 [btrfs]
  [15.187601]  btrfs_alloc_tree_block+0xb5/0x3b0 [btrfs]
  [15.187601]  __btrfs_cow_block+0x138/0x600 [btrfs]
  [15.187601]  btrfs_cow_block+0x10f/0x230 [btrfs]
  [15.187601]  btrfs_search_slot+0x55f/0xbc0 [btrfs]
  [15.187601]  ? lock_is_held_type+0xd7/0x130
  [15.187601]  btrfs_insert_empty_items+0x2d/0x60 [btrfs]
  [15.187601]  btrfs_create_pending_block_groups+0x2b3/0x560 [btrfs]
  [15.187601]  __btrfs_end_transaction+0x36/0x2a0 [btrfs]
  [15.192037]  flush_space+0x374/0x600 [btrfs]
  [15.192037]  ? find_held_lock+0x2b/0x80
  [15.192037]  ? btrfs_async_reclaim_data_space+0x49/0x180 [btrfs]
  [15.192037]  ? lock_release+0x131/0x2b0
  [15.192037]  btrfs_async_reclaim_data_space+0x70/0x180 [btrfs]
  [15.192037]  process_one_work+0x24c/0x5a0
  [15.192037]  worker_thread+0x4a/0x3d0

Fixes: a85f05e59bc1 ("btrfs: zoned: avoid chunk allocation if active block group has enough space")
CC: stable@vger.kernel.org # 5.16+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1927,18 +1927,19 @@ int btrfs_zone_finish(struct btrfs_block
 
 bool btrfs_can_activate_zone(struct btrfs_fs_devices *fs_devices, u64 flags)
 {
+	struct btrfs_fs_info *fs_info = fs_devices->fs_info;
 	struct btrfs_device *device;
 	bool ret = false;
 
-	if (!btrfs_is_zoned(fs_devices->fs_info))
+	if (!btrfs_is_zoned(fs_info))
 		return true;
 
 	/* Non-single profiles are not supported yet */
 	ASSERT((flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0);
 
 	/* Check if there is a device with active zones left */
-	mutex_lock(&fs_devices->device_list_mutex);
-	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+	mutex_lock(&fs_info->chunk_mutex);
+	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
 		struct btrfs_zoned_device_info *zinfo = device->zone_info;
 
 		if (!device->bdev)
@@ -1950,7 +1951,7 @@ bool btrfs_can_activate_zone(struct btrf
 			break;
 		}
 	}
-	mutex_unlock(&fs_devices->device_list_mutex);
+	mutex_unlock(&fs_info->chunk_mutex);
 
 	return ret;
 }



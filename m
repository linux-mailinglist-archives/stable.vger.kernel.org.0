Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81528664A33
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239092AbjAJSb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239406AbjAJSad (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:30:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CE29B290
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:25:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 407DA617C9
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B95CC433F0;
        Tue, 10 Jan 2023 18:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375113;
        bh=xpsZApEK//ngLHmNtDEVS2ccN2WFRvNyvnxxcKApM3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8uiC/781OaehPL2QrTnxZDzdtjnd57DU3iK+LL7OY9FpVaDFHc5bqE8wBwJBQ1A+
         xaEaj8cJ6H6JqIRqQIy5mHxYxzzzBl1TCco77cuXYgnqenlFt4e549DdyRIPBX0bKG
         g6DTUU2GNrTnFZdYVi3CEjaCbtOlP5+9h3WprMIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.15 082/290] dm thin: Fix ABBA deadlock between shrink_slab and dm_pool_abort_metadata
Date:   Tue, 10 Jan 2023 19:02:54 +0100
Message-Id: <20230110180034.435313824@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,WEIRD_PORT autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 8111964f1b8524c4bb56b02cd9c7a37725ea21fd upstream.

Following concurrent processes:

          P1(drop cache)                P2(kworker)
drop_caches_sysctl_handler
 drop_slab
  shrink_slab
   down_read(&shrinker_rwsem)  - LOCK A
   do_shrink_slab
    super_cache_scan
     prune_icache_sb
      dispose_list
       evict
        ext4_evict_inode
	 ext4_clear_inode
	  ext4_discard_preallocations
	   ext4_mb_load_buddy_gfp
	    ext4_mb_init_cache
	     ext4_read_block_bitmap_nowait
	      ext4_read_bh_nowait
	       submit_bh
	        dm_submit_bio
		                 do_worker
				  process_deferred_bios
				   commit
				    metadata_operation_failed
				     dm_pool_abort_metadata
				      down_write(&pmd->root_lock) - LOCK B
		                      __destroy_persistent_data_objects
				       dm_block_manager_destroy
				        dm_bufio_client_destroy
				         unregister_shrinker
					  down_write(&shrinker_rwsem)
		 thin_map                            |
		  dm_thin_find_block                 ↓
		   down_read(&pmd->root_lock) --> ABBA deadlock

, which triggers hung task:

[   76.974820] INFO: task kworker/u4:3:63 blocked for more than 15 seconds.
[   76.976019]       Not tainted 6.1.0-rc4-00011-g8f17dd350364-dirty #910
[   76.978521] task:kworker/u4:3    state:D stack:0     pid:63    ppid:2
[   76.978534] Workqueue: dm-thin do_worker
[   76.978552] Call Trace:
[   76.978564]  __schedule+0x6ba/0x10f0
[   76.978582]  schedule+0x9d/0x1e0
[   76.978588]  rwsem_down_write_slowpath+0x587/0xdf0
[   76.978600]  down_write+0xec/0x110
[   76.978607]  unregister_shrinker+0x2c/0xf0
[   76.978616]  dm_bufio_client_destroy+0x116/0x3d0
[   76.978625]  dm_block_manager_destroy+0x19/0x40
[   76.978629]  __destroy_persistent_data_objects+0x5e/0x70
[   76.978636]  dm_pool_abort_metadata+0x8e/0x100
[   76.978643]  metadata_operation_failed+0x86/0x110
[   76.978649]  commit+0x6a/0x230
[   76.978655]  do_worker+0xc6e/0xd90
[   76.978702]  process_one_work+0x269/0x630
[   76.978714]  worker_thread+0x266/0x630
[   76.978730]  kthread+0x151/0x1b0
[   76.978772] INFO: task test.sh:2646 blocked for more than 15 seconds.
[   76.979756]       Not tainted 6.1.0-rc4-00011-g8f17dd350364-dirty #910
[   76.982111] task:test.sh         state:D stack:0     pid:2646  ppid:2459
[   76.982128] Call Trace:
[   76.982139]  __schedule+0x6ba/0x10f0
[   76.982155]  schedule+0x9d/0x1e0
[   76.982159]  rwsem_down_read_slowpath+0x4f4/0x910
[   76.982173]  down_read+0x84/0x170
[   76.982177]  dm_thin_find_block+0x4c/0xd0
[   76.982183]  thin_map+0x201/0x3d0
[   76.982188]  __map_bio+0x5b/0x350
[   76.982195]  dm_submit_bio+0x2b6/0x930
[   76.982202]  __submit_bio+0x123/0x2d0
[   76.982209]  submit_bio_noacct_nocheck+0x101/0x3e0
[   76.982222]  submit_bio_noacct+0x389/0x770
[   76.982227]  submit_bio+0x50/0xc0
[   76.982232]  submit_bh_wbc+0x15e/0x230
[   76.982238]  submit_bh+0x14/0x20
[   76.982241]  ext4_read_bh_nowait+0xc5/0x130
[   76.982247]  ext4_read_block_bitmap_nowait+0x340/0xc60
[   76.982254]  ext4_mb_init_cache+0x1ce/0xdc0
[   76.982259]  ext4_mb_load_buddy_gfp+0x987/0xfa0
[   76.982263]  ext4_discard_preallocations+0x45d/0x830
[   76.982274]  ext4_clear_inode+0x48/0xf0
[   76.982280]  ext4_evict_inode+0xcf/0xc70
[   76.982285]  evict+0x119/0x2b0
[   76.982290]  dispose_list+0x43/0xa0
[   76.982294]  prune_icache_sb+0x64/0x90
[   76.982298]  super_cache_scan+0x155/0x210
[   76.982303]  do_shrink_slab+0x19e/0x4e0
[   76.982310]  shrink_slab+0x2bd/0x450
[   76.982317]  drop_slab+0xcc/0x1a0
[   76.982323]  drop_caches_sysctl_handler+0xb7/0xe0
[   76.982327]  proc_sys_call_handler+0x1bc/0x300
[   76.982331]  proc_sys_write+0x17/0x20
[   76.982334]  vfs_write+0x3d3/0x570
[   76.982342]  ksys_write+0x73/0x160
[   76.982347]  __x64_sys_write+0x1e/0x30
[   76.982352]  do_syscall_64+0x35/0x80
[   76.982357]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Function metadata_operation_failed() is called when operations failed
on dm pool metadata, dm pool will destroy and recreate metadata. So,
shrinker will be unregistered and registered, which could down write
shrinker_rwsem under pmd_write_lock.

Fix it by allocating dm_block_manager before locking pmd->root_lock
and destroying old dm_block_manager after unlocking pmd->root_lock,
then old dm_block_manager is replaced with new dm_block_manager under
pmd->root_lock. So, shrinker register/unregister could be done without
holding pmd->root_lock.

Fetch a reproducer in [Link].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216676
Cc: stable@vger.kernel.org #v5.2+
Fixes: e49e582965b3 ("dm thin: add read only and fail io modes")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin-metadata.c |   51 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 8 deletions(-)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -776,13 +776,15 @@ static int __create_persistent_data_obje
 	return r;
 }
 
-static void __destroy_persistent_data_objects(struct dm_pool_metadata *pmd)
+static void __destroy_persistent_data_objects(struct dm_pool_metadata *pmd,
+					      bool destroy_bm)
 {
 	dm_sm_destroy(pmd->data_sm);
 	dm_sm_destroy(pmd->metadata_sm);
 	dm_tm_destroy(pmd->nb_tm);
 	dm_tm_destroy(pmd->tm);
-	dm_block_manager_destroy(pmd->bm);
+	if (destroy_bm)
+		dm_block_manager_destroy(pmd->bm);
 }
 
 static int __begin_transaction(struct dm_pool_metadata *pmd)
@@ -989,7 +991,7 @@ int dm_pool_metadata_close(struct dm_poo
 	}
 	pmd_write_unlock(pmd);
 	if (!pmd->fail_io)
-		__destroy_persistent_data_objects(pmd);
+		__destroy_persistent_data_objects(pmd, true);
 
 	kfree(pmd);
 	return 0;
@@ -1888,19 +1890,52 @@ static void __set_abort_with_changes_fla
 int dm_pool_abort_metadata(struct dm_pool_metadata *pmd)
 {
 	int r = -EINVAL;
+	struct dm_block_manager *old_bm = NULL, *new_bm = NULL;
+
+	/* fail_io is double-checked with pmd->root_lock held below */
+	if (unlikely(pmd->fail_io))
+		return r;
+
+	/*
+	 * Replacement block manager (new_bm) is created and old_bm destroyed outside of
+	 * pmd root_lock to avoid ABBA deadlock that would result (due to life-cycle of
+	 * shrinker associated with the block manager's bufio client vs pmd root_lock).
+	 * - must take shrinker_rwsem without holding pmd->root_lock
+	 */
+	new_bm = dm_block_manager_create(pmd->bdev, THIN_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
+					 THIN_MAX_CONCURRENT_LOCKS);
 
 	pmd_write_lock(pmd);
-	if (pmd->fail_io)
+	if (pmd->fail_io) {
+		pmd_write_unlock(pmd);
 		goto out;
+	}
 
 	__set_abort_with_changes_flags(pmd);
-	__destroy_persistent_data_objects(pmd);
-	r = __create_persistent_data_objects(pmd, false);
+	__destroy_persistent_data_objects(pmd, false);
+	old_bm = pmd->bm;
+	if (IS_ERR(new_bm)) {
+		DMERR("could not create block manager during abort");
+		pmd->bm = NULL;
+		r = PTR_ERR(new_bm);
+		goto out_unlock;
+	}
+
+	pmd->bm = new_bm;
+	r = __open_or_format_metadata(pmd, false);
+	if (r) {
+		pmd->bm = NULL;
+		goto out_unlock;
+	}
+	new_bm = NULL;
+out_unlock:
 	if (r)
 		pmd->fail_io = true;
-
-out:
 	pmd_write_unlock(pmd);
+	dm_block_manager_destroy(old_bm);
+out:
+	if (new_bm && !IS_ERR(new_bm))
+		dm_block_manager_destroy(new_bm);
 
 	return r;
 }



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF406D49B2
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbjDCOka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233774AbjDCOk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:40:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7851417AC7
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:40:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E31B2B81CDB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1D6C433EF;
        Mon,  3 Apr 2023 14:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532823;
        bh=DCruXDScu+mDYgebroJ5uyYlyfUlj1/bbJvWQ2p38tQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0GWpG6GOvMR3uX3Ca907n9EoZNF58X0wrFvz1D2jGDO3mmhcIqJSqLaGw/pFGPz30
         HM014z00pb+1f9U1MMih1jKS7rS/Hwtq0ULIIQDPCXFTMF/a3GcUcKQElJ7MpfEWjw
         6x3yIeMBZPa3XK7fa4gEyxjPETrQkUockYh6injY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 131/181] btrfs: fix race between quota disable and quota assign ioctls
Date:   Mon,  3 Apr 2023 16:09:26 +0200
Message-Id: <20230403140419.336135986@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 2f1a6be12ab6c8470d5776e68644726c94257c54 upstream.

The quota assign ioctl can currently run in parallel with a quota disable
ioctl call. The assign ioctl uses the quota root, while the disable ioctl
frees that root, and therefore we can have a use-after-free triggered in
the assign ioctl, leading to a trace like the following when KASAN is
enabled:

  [672.723][T736] BUG: KASAN: slab-use-after-free in btrfs_search_slot+0x2962/0x2db0
  [672.723][T736] Read of size 8 at addr ffff888022ec0208 by task btrfs_search_sl/27736
  [672.724][T736]
  [672.725][T736] CPU: 1 PID: 27736 Comm: btrfs_search_sl Not tainted 6.3.0-rc3 #37
  [672.723][T736] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
  [672.727][T736] Call Trace:
  [672.728][T736]  <TASK>
  [672.728][T736]  dump_stack_lvl+0xd9/0x150
  [672.725][T736]  print_report+0xc1/0x5e0
  [672.720][T736]  ? __virt_addr_valid+0x61/0x2e0
  [672.727][T736]  ? __phys_addr+0xc9/0x150
  [672.725][T736]  ? btrfs_search_slot+0x2962/0x2db0
  [672.722][T736]  kasan_report+0xc0/0xf0
  [672.729][T736]  ? btrfs_search_slot+0x2962/0x2db0
  [672.724][T736]  btrfs_search_slot+0x2962/0x2db0
  [672.723][T736]  ? fs_reclaim_acquire+0xba/0x160
  [672.722][T736]  ? split_leaf+0x13d0/0x13d0
  [672.726][T736]  ? rcu_is_watching+0x12/0xb0
  [672.723][T736]  ? kmem_cache_alloc+0x338/0x3c0
  [672.722][T736]  update_qgroup_status_item+0xf7/0x320
  [672.724][T736]  ? add_qgroup_rb+0x3d0/0x3d0
  [672.739][T736]  ? do_raw_spin_lock+0x12d/0x2b0
  [672.730][T736]  ? spin_bug+0x1d0/0x1d0
  [672.737][T736]  btrfs_run_qgroups+0x5de/0x840
  [672.730][T736]  ? btrfs_qgroup_rescan_worker+0xa70/0xa70
  [672.738][T736]  ? __del_qgroup_relation+0x4ba/0xe00
  [672.738][T736]  btrfs_ioctl+0x3d58/0x5d80
  [672.735][T736]  ? tomoyo_path_number_perm+0x16a/0x550
  [672.737][T736]  ? tomoyo_execute_permission+0x4a0/0x4a0
  [672.731][T736]  ? btrfs_ioctl_get_supported_features+0x50/0x50
  [672.737][T736]  ? __sanitizer_cov_trace_switch+0x54/0x90
  [672.734][T736]  ? do_vfs_ioctl+0x132/0x1660
  [672.730][T736]  ? vfs_fileattr_set+0xc40/0xc40
  [672.730][T736]  ? _raw_spin_unlock_irq+0x2e/0x50
  [672.732][T736]  ? sigprocmask+0xf2/0x340
  [672.737][T736]  ? __fget_files+0x26a/0x480
  [672.732][T736]  ? bpf_lsm_file_ioctl+0x9/0x10
  [672.738][T736]  ? btrfs_ioctl_get_supported_features+0x50/0x50
  [672.736][T736]  __x64_sys_ioctl+0x198/0x210
  [672.736][T736]  do_syscall_64+0x39/0xb0
  [672.731][T736]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
  [672.739][T736] RIP: 0033:0x4556ad
  [672.742][T736]  </TASK>
  [672.743][T736]
  [672.748][T736] Allocated by task 27677:
  [672.743][T736]  kasan_save_stack+0x22/0x40
  [672.741][T736]  kasan_set_track+0x25/0x30
  [672.741][T736]  __kasan_kmalloc+0xa4/0xb0
  [672.749][T736]  btrfs_alloc_root+0x48/0x90
  [672.746][T736]  btrfs_create_tree+0x146/0xa20
  [672.744][T736]  btrfs_quota_enable+0x461/0x1d20
  [672.743][T736]  btrfs_ioctl+0x4a1c/0x5d80
  [672.747][T736]  __x64_sys_ioctl+0x198/0x210
  [672.749][T736]  do_syscall_64+0x39/0xb0
  [672.744][T736]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
  [672.756][T736]
  [672.757][T736] Freed by task 27677:
  [672.759][T736]  kasan_save_stack+0x22/0x40
  [672.759][T736]  kasan_set_track+0x25/0x30
  [672.756][T736]  kasan_save_free_info+0x2e/0x50
  [672.751][T736]  ____kasan_slab_free+0x162/0x1c0
  [672.758][T736]  slab_free_freelist_hook+0x89/0x1c0
  [672.752][T736]  __kmem_cache_free+0xaf/0x2e0
  [672.752][T736]  btrfs_put_root+0x1ff/0x2b0
  [672.759][T736]  btrfs_quota_disable+0x80a/0xbc0
  [672.752][T736]  btrfs_ioctl+0x3e5f/0x5d80
  [672.756][T736]  __x64_sys_ioctl+0x198/0x210
  [672.753][T736]  do_syscall_64+0x39/0xb0
  [672.765][T736]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
  [672.769][T736]
  [672.768][T736] The buggy address belongs to the object at ffff888022ec0000
  [672.768][T736]  which belongs to the cache kmalloc-4k of size 4096
  [672.769][T736] The buggy address is located 520 bytes inside of
  [672.769][T736]  freed 4096-byte region [ffff888022ec0000, ffff888022ec1000)
  [672.760][T736]
  [672.764][T736] The buggy address belongs to the physical page:
  [672.761][T736] page:ffffea00008bb000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x22ec0
  [672.766][T736] head:ffffea00008bb000 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
  [672.779][T736] flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
  [672.770][T736] raw: 00fff00000010200 ffff888012842140 ffffea000054ba00 dead000000000002
  [672.770][T736] raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
  [672.771][T736] page dumped because: kasan: bad access detected
  [672.778][T736] page_owner tracks the page as allocated
  [672.777][T736] page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 88
  [672.779][T736]  get_page_from_freelist+0x119c/0x2d50
  [672.779][T736]  __alloc_pages+0x1cb/0x4a0
  [672.776][T736]  alloc_pages+0x1aa/0x270
  [672.773][T736]  allocate_slab+0x260/0x390
  [672.771][T736]  ___slab_alloc+0xa9a/0x13e0
  [672.778][T736]  __slab_alloc.constprop.0+0x56/0xb0
  [672.771][T736]  __kmem_cache_alloc_node+0x136/0x320
  [672.789][T736]  __kmalloc+0x4e/0x1a0
  [672.783][T736]  tomoyo_realpath_from_path+0xc3/0x600
  [672.781][T736]  tomoyo_path_perm+0x22f/0x420
  [672.782][T736]  tomoyo_path_unlink+0x92/0xd0
  [672.780][T736]  security_path_unlink+0xdb/0x150
  [672.788][T736]  do_unlinkat+0x377/0x680
  [672.788][T736]  __x64_sys_unlink+0xca/0x110
  [672.789][T736]  do_syscall_64+0x39/0xb0
  [672.783][T736]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
  [672.784][T736] page last free stack trace:
  [672.787][T736]  free_pcp_prepare+0x4e5/0x920
  [672.787][T736]  free_unref_page+0x1d/0x4e0
  [672.784][T736]  __unfreeze_partials+0x17c/0x1a0
  [672.797][T736]  qlist_free_all+0x6a/0x180
  [672.796][T736]  kasan_quarantine_reduce+0x189/0x1d0
  [672.797][T736]  __kasan_slab_alloc+0x64/0x90
  [672.793][T736]  kmem_cache_alloc+0x17c/0x3c0
  [672.799][T736]  getname_flags.part.0+0x50/0x4e0
  [672.799][T736]  getname_flags+0x9e/0xe0
  [672.792][T736]  vfs_fstatat+0x77/0xb0
  [672.791][T736]  __do_sys_newlstat+0x84/0x100
  [672.798][T736]  do_syscall_64+0x39/0xb0
  [672.796][T736]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
  [672.790][T736]
  [672.791][T736] Memory state around the buggy address:
  [672.799][T736]  ffff888022ec0100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  [672.805][T736]  ffff888022ec0180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  [672.802][T736] >ffff888022ec0200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  [672.809][T736]                       ^
  [672.809][T736]  ffff888022ec0280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  [672.809][T736]  ffff888022ec0300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fix this by having the qgroup assign ioctl take the qgroup ioctl mutex
before calling btrfs_run_qgroups(), which is what all qgroup ioctls should
call.

Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAFcO6XN3VD8ogmHwqRk4kbiwtpUSNySu2VAxN8waEPciCHJvMA@mail.gmail.com/
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c  |    2 ++
 fs/btrfs/qgroup.c |   11 ++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4621,7 +4621,9 @@ static long btrfs_ioctl_qgroup_assign(st
 	}
 
 	/* update qgroup status and info */
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	err = btrfs_run_qgroups(trans);
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	if (err < 0)
 		btrfs_handle_fs_error(fs_info, err,
 				      "failed to update qgroup status and info");
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2812,13 +2812,22 @@ cleanup:
 }
 
 /*
- * called from commit_transaction. Writes all changed qgroups to disk.
+ * Writes all changed qgroups to disk.
+ * Called by the transaction commit path and the qgroup assign ioctl.
  */
 int btrfs_run_qgroups(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret = 0;
 
+	/*
+	 * In case we are called from the qgroup assign ioctl, assert that we
+	 * are holding the qgroup_ioctl_lock, otherwise we can race with a quota
+	 * disable operation (ioctl) and access a freed quota root.
+	 */
+	if (trans->transaction->state != TRANS_STATE_COMMIT_DOING)
+		lockdep_assert_held(&fs_info->qgroup_ioctl_lock);
+
 	if (!fs_info->quota_root)
 		return ret;
 



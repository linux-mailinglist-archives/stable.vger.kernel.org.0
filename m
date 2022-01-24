Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F169D49A24A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 02:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365673AbiAXXv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356615AbiAXWjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71973C05487E;
        Mon, 24 Jan 2022 13:02:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39B3FB8123D;
        Mon, 24 Jan 2022 21:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0C4C340E5;
        Mon, 24 Jan 2022 21:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058174;
        bh=YIVcffIQyq2XLA6aoqQ7+F5OrkIe5KlOSYgHLVyqGi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgSjUiBI4umC08n9iC9OgAtG/rap2RaSmG92rVgfVVP02nIlGUK0FZTrEKjxLsVJe
         Nngjbg1iP2NwH5n9fdJjSEqS+C/B7w/ic5ZTTsLucsZKYE/emd574TluZ0F2CwCBvJ
         7VJ4wjqFz4ipP9SNBUekWl+16TpcRYh8l6bNLSNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianwei Hu <jianwei.hu@windriver.com>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        Marco Elver <elver@google.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Jun Miao <jun.miao@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0204/1039] rcu: Avoid alloc_pages() when recording stack
Date:   Mon, 24 Jan 2022 19:33:13 +0100
Message-Id: <20220124184132.181097293@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jun Miao <jun.miao@intel.com>

[ Upstream commit 300c0c5e721834f484b03fa3062602dd8ff48413 ]

The default kasan_record_aux_stack() calls stack_depot_save() with GFP_NOWAIT,
which in turn can then call alloc_pages(GFP_NOWAIT, ...).  In general, however,
it is not even possible to use either GFP_ATOMIC nor GFP_NOWAIT in certain
non-preemptive contexts/RT kernel including raw_spin_locks (see gfp.h and ab00db216c9c7).
Fix it by instructing stackdepot to not expand stack storage via alloc_pages()
in case it runs out by using kasan_record_aux_stack_noalloc().

Jianwei Hu reported:
BUG: sleeping function called from invalid context at kernel/locking/rtmutex.c:969
in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 15319, name: python3
INFO: lockdep is turned off.
irq event stamp: 0
  hardirqs last  enabled at (0): [<0000000000000000>] 0x0
  hardirqs last disabled at (0): [<ffffffff856c8b13>] copy_process+0xaf3/0x2590
  softirqs last  enabled at (0): [<ffffffff856c8b13>] copy_process+0xaf3/0x2590
  softirqs last disabled at (0): [<0000000000000000>] 0x0
  CPU: 6 PID: 15319 Comm: python3 Tainted: G        W  O 5.15-rc7-preempt-rt #1
  Hardware name: Supermicro SYS-E300-9A-8C/A2SDi-8C-HLN4F, BIOS 1.1b 12/17/2018
  Call Trace:
    show_stack+0x52/0x58
    dump_stack+0xa1/0xd6
    ___might_sleep.cold+0x11c/0x12d
    rt_spin_lock+0x3f/0xc0
    rmqueue+0x100/0x1460
    rmqueue+0x100/0x1460
    mark_usage+0x1a0/0x1a0
    ftrace_graph_ret_addr+0x2a/0xb0
    rmqueue_pcplist.constprop.0+0x6a0/0x6a0
     __kasan_check_read+0x11/0x20
     __zone_watermark_ok+0x114/0x270
     get_page_from_freelist+0x148/0x630
     is_module_text_address+0x32/0xa0
     __alloc_pages_nodemask+0x2f6/0x790
     __alloc_pages_slowpath.constprop.0+0x12d0/0x12d0
     create_prof_cpu_mask+0x30/0x30
     alloc_pages_current+0xb1/0x150
     stack_depot_save+0x39f/0x490
     kasan_save_stack+0x42/0x50
     kasan_save_stack+0x23/0x50
     kasan_record_aux_stack+0xa9/0xc0
     __call_rcu+0xff/0x9c0
     call_rcu+0xe/0x10
     put_object+0x53/0x70
     __delete_object+0x7b/0x90
     kmemleak_free+0x46/0x70
     slab_free_freelist_hook+0xb4/0x160
     kfree+0xe5/0x420
     kfree_const+0x17/0x30
     kobject_cleanup+0xaa/0x230
     kobject_put+0x76/0x90
     netdev_queue_update_kobjects+0x17d/0x1f0
     ... ...
     ksys_write+0xd9/0x180
     __x64_sys_write+0x42/0x50
     do_syscall_64+0x38/0x50
     entry_SYSCALL_64_after_hwframe+0x44/0xa9

Links: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/include/linux/kasan.h?id=7cb3007ce2da27ec02a1a3211941e7fe6875b642
Fixes: 84109ab58590 ("rcu: Record kvfree_call_rcu() call stack for KASAN")
Fixes: 26e760c9a7c8 ("rcu: kasan: record and print call_rcu() call stack")
Reported-by: Jianwei Hu <jianwei.hu@windriver.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Marco Elver <elver@google.com>
Tested-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Jun Miao <jun.miao@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index ef8d36f580fc3..906b6887622d3 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2982,7 +2982,7 @@ __call_rcu(struct rcu_head *head, rcu_callback_t func)
 	head->func = func;
 	head->next = NULL;
 	local_irq_save(flags);
-	kasan_record_aux_stack(head);
+	kasan_record_aux_stack_noalloc(head);
 	rdp = this_cpu_ptr(&rcu_data);
 
 	/* Add the callback to our list. */
@@ -3547,7 +3547,7 @@ void kvfree_call_rcu(struct rcu_head *head, rcu_callback_t func)
 		return;
 	}
 
-	kasan_record_aux_stack(ptr);
+	kasan_record_aux_stack_noalloc(ptr);
 	success = add_ptr_to_bulk_krc_lock(&krcp, &flags, ptr, !head);
 	if (!success) {
 		run_page_cache_worker(krcp);
-- 
2.34.1




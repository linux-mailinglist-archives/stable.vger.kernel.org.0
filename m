Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E7A6AC148
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 14:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjCFNeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 08:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjCFNeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 08:34:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6526921A34
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 05:33:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 770A5CE1272
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 13:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97080C433EF;
        Mon,  6 Mar 2023 13:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678109586;
        bh=50u88vsO6fMOGa4+pHYNr9KSDtZz8pAj/YHZusHEc4I=;
        h=Subject:To:Cc:From:Date:From;
        b=xXdrs2oU+JwtcTWtujwgIYkkDJuVYDVOfJa4HGHhWb+VBnJkBwiFlrqnqIqJKzRjS
         F9EYqgfUIhgmyI7JjB9w90WEelcAcMwUFhorbN0lnglVOtS4NiVnFr5wsBAj7mjx3W
         DsPCfQwvIlSlIgIrdUE+wXX2IlMX9V+bnpqMSJeM=
Subject: FAILED: patch "[PATCH] fs: dlm: fix use after free in midcomms commit" failed to apply to 5.15-stable tree
To:     aahringo@redhat.com, teigland@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 14:33:03 +0100
Message-ID: <16781095834451@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 724b6bab0d75f1dc01fdfbf7fe8d4217a5cb90ba
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16781095834451@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

724b6bab0d75 ("fs: dlm: fix use after free in midcomms commit")
e01c4b7bd415 ("fd: dlm: trace send/recv of dlm message and rcom")
00e99ccde757 ("dlm: use __le types for dlm messages")
2f9dbeda8dc0 ("dlm: use __le types for rcom messages")
3428785a65da ("dlm: use __le types for dlm header")
a8449f232ee3 ("dlm: add __CHECKER__ for false positives")
6c2e3bf68f3e ("fs: dlm: filter user dlm messages for kernel locks")
9af5b8f0ead7 ("fs: dlm: add debugfs rawmsg send functionality")
92732376fd29 ("fs: dlm: trace socket handling")
f1d3b8f91d96 ("fs: dlm: initial support for tracepoints")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 724b6bab0d75f1dc01fdfbf7fe8d4217a5cb90ba Mon Sep 17 00:00:00 2001
From: Alexander Aring <aahringo@redhat.com>
Date: Thu, 12 Jan 2023 17:10:32 -0500
Subject: [PATCH] fs: dlm: fix use after free in midcomms commit

While working on processing dlm message in softirq context I experienced
the following KASAN use-after-free warning:

[  151.760477] ==================================================================
[  151.761803] BUG: KASAN: use-after-free in dlm_midcomms_commit_mhandle+0x19d/0x4b0
[  151.763414] Read of size 4 at addr ffff88811a980c60 by task lock_torture/1347

[  151.765284] CPU: 7 PID: 1347 Comm: lock_torture Not tainted 6.1.0-rc4+ #2828
[  151.766778] Hardware name: Red Hat KVM/RHEL-AV, BIOS 1.16.0-3.module+el8.7.0+16134+e5908aa2 04/01/2014
[  151.768726] Call Trace:
[  151.769277]  <TASK>
[  151.769748]  dump_stack_lvl+0x5b/0x86
[  151.770556]  print_report+0x180/0x4c8
[  151.771378]  ? kasan_complete_mode_report_info+0x7c/0x1e0
[  151.772241]  ? dlm_midcomms_commit_mhandle+0x19d/0x4b0
[  151.773069]  kasan_report+0x93/0x1a0
[  151.773668]  ? dlm_midcomms_commit_mhandle+0x19d/0x4b0
[  151.774514]  __asan_load4+0x7e/0xa0
[  151.775089]  dlm_midcomms_commit_mhandle+0x19d/0x4b0
[  151.775890]  ? create_message.isra.29.constprop.64+0x57/0xc0
[  151.776770]  send_common+0x19f/0x1b0
[  151.777342]  ? remove_from_waiters+0x60/0x60
[  151.778017]  ? lock_downgrade+0x410/0x410
[  151.778648]  ? __this_cpu_preempt_check+0x13/0x20
[  151.779421]  ? rcu_lockdep_current_cpu_online+0x88/0xc0
[  151.780292]  _convert_lock+0x46/0x150
[  151.780893]  convert_lock+0x7b/0xc0
[  151.781459]  dlm_lock+0x3ac/0x580
[  151.781993]  ? 0xffffffffc0540000
[  151.782522]  ? torture_stop+0x120/0x120 [dlm_locktorture]
[  151.783379]  ? dlm_scan_rsbs+0xa70/0xa70
[  151.784003]  ? preempt_count_sub+0xd6/0x130
[  151.784661]  ? is_module_address+0x47/0x70
[  151.785309]  ? torture_stop+0x120/0x120 [dlm_locktorture]
[  151.786166]  ? 0xffffffffc0540000
[  151.786693]  ? lockdep_init_map_type+0xc3/0x360
[  151.787414]  ? 0xffffffffc0540000
[  151.787947]  torture_dlm_lock_sync.isra.3+0xe9/0x150 [dlm_locktorture]
[  151.789004]  ? torture_stop+0x120/0x120 [dlm_locktorture]
[  151.789858]  ? 0xffffffffc0540000
[  151.790392]  ? lock_torture_cleanup+0x20/0x20 [dlm_locktorture]
[  151.791347]  ? delay_tsc+0x94/0xc0
[  151.791898]  torture_ex_iter+0xc3/0xea [dlm_locktorture]
[  151.792735]  ? torture_start+0x30/0x30 [dlm_locktorture]
[  151.793606]  lock_torture+0x177/0x270 [dlm_locktorture]
[  151.794448]  ? torture_dlm_lock_sync.isra.3+0x150/0x150 [dlm_locktorture]
[  151.795539]  ? lock_torture_stats+0x80/0x80 [dlm_locktorture]
[  151.796476]  ? do_raw_spin_lock+0x11e/0x1e0
[  151.797152]  ? mark_held_locks+0x34/0xb0
[  151.797784]  ? _raw_spin_unlock_irqrestore+0x30/0x70
[  151.798581]  ? __kthread_parkme+0x79/0x110
[  151.799246]  ? trace_preempt_on+0x2a/0xf0
[  151.799902]  ? __kthread_parkme+0x79/0x110
[  151.800579]  ? preempt_count_sub+0xd6/0x130
[  151.801271]  ? __kasan_check_read+0x11/0x20
[  151.801963]  ? __kthread_parkme+0xec/0x110
[  151.802630]  ? lock_torture_stats+0x80/0x80 [dlm_locktorture]
[  151.803569]  kthread+0x192/0x1d0
[  151.804104]  ? kthread_complete_and_exit+0x30/0x30
[  151.804881]  ret_from_fork+0x1f/0x30
[  151.805480]  </TASK>

[  151.806111] Allocated by task 1347:
[  151.806681]  kasan_save_stack+0x26/0x50
[  151.807308]  kasan_set_track+0x25/0x30
[  151.807920]  kasan_save_alloc_info+0x1e/0x30
[  151.808609]  __kasan_slab_alloc+0x63/0x80
[  151.809263]  kmem_cache_alloc+0x1ad/0x830
[  151.809916]  dlm_allocate_mhandle+0x17/0x20
[  151.810590]  dlm_midcomms_get_mhandle+0x96/0x260
[  151.811344]  _create_message+0x95/0x180
[  151.811994]  create_message.isra.29.constprop.64+0x57/0xc0
[  151.812880]  send_common+0x129/0x1b0
[  151.813467]  _convert_lock+0x46/0x150
[  151.814074]  convert_lock+0x7b/0xc0
[  151.814648]  dlm_lock+0x3ac/0x580
[  151.815199]  torture_dlm_lock_sync.isra.3+0xe9/0x150 [dlm_locktorture]
[  151.816258]  torture_ex_iter+0xc3/0xea [dlm_locktorture]
[  151.817129]  lock_torture+0x177/0x270 [dlm_locktorture]
[  151.817986]  kthread+0x192/0x1d0
[  151.818518]  ret_from_fork+0x1f/0x30

[  151.819369] Freed by task 1336:
[  151.819890]  kasan_save_stack+0x26/0x50
[  151.820514]  kasan_set_track+0x25/0x30
[  151.821128]  kasan_save_free_info+0x2e/0x50
[  151.821812]  __kasan_slab_free+0x107/0x1a0
[  151.822483]  kmem_cache_free+0x204/0x5e0
[  151.823152]  dlm_free_mhandle+0x18/0x20
[  151.823781]  dlm_mhandle_release+0x2e/0x40
[  151.824454]  rcu_core+0x583/0x1330
[  151.825047]  rcu_core_si+0xe/0x20
[  151.825594]  __do_softirq+0xf4/0x5c2

[  151.826450] Last potentially related work creation:
[  151.827238]  kasan_save_stack+0x26/0x50
[  151.827870]  __kasan_record_aux_stack+0xa2/0xc0
[  151.828609]  kasan_record_aux_stack_noalloc+0xb/0x20
[  151.829415]  call_rcu+0x4c/0x760
[  151.829954]  dlm_mhandle_delete+0x97/0xb0
[  151.830718]  dlm_process_incoming_buffer+0x2fc/0xb30
[  151.831524]  process_dlm_messages+0x16e/0x470
[  151.832245]  process_one_work+0x505/0xa10
[  151.832905]  worker_thread+0x67/0x650
[  151.833507]  kthread+0x192/0x1d0
[  151.834046]  ret_from_fork+0x1f/0x30

[  151.834900] The buggy address belongs to the object at ffff88811a980c30
                which belongs to the cache dlm_mhandle of size 88
[  151.836894] The buggy address is located 48 bytes inside of
                88-byte region [ffff88811a980c30, ffff88811a980c88)

[  151.839007] The buggy address belongs to the physical page:
[  151.839904] page:0000000076cf5d62 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11a980
[  151.841378] flags: 0x8000000000000200(slab|zone=2)
[  151.842141] raw: 8000000000000200 0000000000000000 dead000000000122 ffff8881089b43c0
[  151.843401] raw: 0000000000000000 0000000000220022 00000001ffffffff 0000000000000000
[  151.844640] page dumped because: kasan: bad access detected

[  151.845822] Memory state around the buggy address:
[  151.846602]  ffff88811a980b00: fb fb fb fb fc fc fc fc fa fb fb fb fb fb fb fb
[  151.847761]  ffff88811a980b80: fb fb fb fc fc fc fc fa fb fb fb fb fb fb fb fb
[  151.848921] >ffff88811a980c00: fb fb fc fc fc fc fa fb fb fb fb fb fb fb fb fb
[  151.850076]                                                        ^
[  151.851085]  ffff88811a980c80: fb fc fc fc fc fa fb fb fb fb fb fb fb fb fb fb
[  151.852269]  ffff88811a980d00: fc fc fc fc fa fb fb fb fb fb fb fb fb fb fb fc
[  151.853428] ==================================================================
[  151.855618] Disabling lock debugging due to kernel taint

It is accessing a mhandle in dlm_midcomms_commit_mhandle() and the mhandle
was freed by a call_rcu() call in dlm_process_incoming_buffer(),
dlm_mhandle_delete(). It looks like it was freed because an ack of
this message was received. There is a short race between committing the
dlm message to be transmitted and getting an ack back. If the ack is
faster than returning from dlm_midcomms_commit_msg_3_2(), then we run
into a use-after free because we still need to reference the mhandle when
calling srcu_read_unlock().

To avoid that, we don't allow that mhandle to be freed between
dlm_midcomms_commit_msg_3_2() and srcu_read_unlock() by using rcu read
lock. We can do that because mhandle is protected by rcu handling.

Cc: stable@vger.kernel.org
Fixes: 489d8e559c65 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index fc015a6abe17..2e60d9a2c883 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -1214,8 +1214,15 @@ void dlm_midcomms_commit_mhandle(struct dlm_mhandle *mh,
 		dlm_free_mhandle(mh);
 		break;
 	case DLM_VERSION_3_2:
+		/* held rcu read lock here, because we sending the
+		 * dlm message out, when we do that we could receive
+		 * an ack back which releases the mhandle and we
+		 * get a use after free.
+		 */
+		rcu_read_lock();
 		dlm_midcomms_commit_msg_3_2(mh, name, namelen);
 		srcu_read_unlock(&nodes_srcu, mh->idx);
+		rcu_read_unlock();
 		break;
 	default:
 		srcu_read_unlock(&nodes_srcu, mh->idx);


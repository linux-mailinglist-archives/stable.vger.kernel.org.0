Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1F868738B
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 04:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjBBDBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 22:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbjBBDBc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 22:01:32 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8522179CA3;
        Wed,  1 Feb 2023 19:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675306878; x=1706842878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q05uX48M20nMrd/E/JzYkhFE8vi24nWdzw3LRUurN1U=;
  b=HcX5rpOtFb98NVhPN9jx9aTIl4HH2p3sZo/+yHAtAeX7rjPglZrGXsHG
   uEOinYadteFZAD2tNtbTxstkviR2OE7IJDfFc85bfyK9FAGe1DYH501Q3
   KhLovxwG3N/PsgTywlvcZMRcltXCrjOGkAMYh5G8kJoXkq5ousMfiAXZH
   w=;
X-IronPort-AV: E=Sophos;i="5.97,266,1669075200"; 
   d="scan'208";a="177554059"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 03:01:17 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com (Postfix) with ESMTPS id 650DA61AE4;
        Thu,  2 Feb 2023 03:01:16 +0000 (UTC)
Received: from EX19D010UWA004.ant.amazon.com (10.13.138.204) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Thu, 2 Feb 2023 03:01:15 +0000
Received: from u9aa42af9e4c55a.ant.amazon.com (10.43.161.198) by
 EX19D010UWA004.ant.amazon.com (10.13.138.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.24; Thu, 2 Feb 2023 03:01:15 +0000
From:   Munehisa Kamata <kamatam@amazon.com>
To:     <surenb@google.com>
CC:     <ebiggers@kernel.org>, <hannes@cmpxchg.org>, <hdanton@sina.com>,
        <kamatam@amazon.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <mengcc@amazon.com>, <stable@vger.kernel.org>
Subject: [PATCH] sched/psi: fix use-after-free in ep_remove_wait_queue()
Date:   Wed, 1 Feb 2023 19:00:23 -0800
Message-ID: <20230202030023.1847084-1-kamatam@amazon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAJuCfpFZ3B4530TgsSHqp5F_gwfrDujwRYewKReJru==MdEHQg@mail.gmail.com>
References: <CAJuCfpFZ3B4530TgsSHqp5F_gwfrDujwRYewKReJru==MdEHQg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.198]
X-ClientProxiedBy: EX13P01UWB003.ant.amazon.com (10.43.161.209) To
 EX19D010UWA004.ant.amazon.com (10.13.138.204)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a non-root cgroup gets removed when there is a thread that registered
trigger and is polling on a pressure file within the cgroup, the polling
waitqueue gets freed without clearing the queue and reference, then it can
result in use-after-free as below. Use wake_up_pollfree() instead to
ensure that the queue and reference are cleared before freeing.

 BUG: KASAN: use-after-free in _raw_spin_lock_irqsave+0x60/0xc0
 Write of size 4 at addr ffff88810e625328 by task a.out/4404

 CPU: 19 PID: 4404 Comm: a.out Not tainted 6.2.0-rc6 #38
 Hardware name: Amazon EC2 c5a.8xlarge/, BIOS 1.0 10/16/2017
 Call Trace:
 <TASK>
 dump_stack_lvl+0x73/0xa0
 print_report+0x16c/0x4e0
 ? _printk+0x59/0x80
 ? __virt_addr_valid+0xb8/0x130
 ? _raw_spin_lock_irqsave+0x60/0xc0
 kasan_report+0xc3/0xf0
 ? _raw_spin_lock_irqsave+0x60/0xc0
 kasan_check_range+0x2d2/0x310
 _raw_spin_lock_irqsave+0x60/0xc0
 remove_wait_queue+0x1a/0xa0
 ep_free+0x12c/0x170
 ep_eventpoll_release+0x26/0x30
 __fput+0x202/0x400
 task_work_run+0x11d/0x170
 do_exit+0x495/0x1130
 ? update_cfs_rq_load_avg+0x2c2/0x2e0
 do_group_exit+0x100/0x100
 get_signal+0xd67/0xde0
 ? finish_task_switch+0x15f/0x3a0
 arch_do_signal_or_restart+0x2a/0x2b0
 exit_to_user_mode_prepare+0x94/0x100
 syscall_exit_to_user_mode+0x20/0x40
 do_syscall_64+0x52/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 RIP: 0033:0x7f8e392bfb91
 Code: Unable to access opcode bytes at 0x7f8e392bfb67.
 RSP: 002b:00007fff261e08d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000022
 RAX: fffffffffffffdfe RBX: 0000000000000000 RCX: 00007f8e392bfb91
 RDX: 0000000000000001 RSI: 00007fff261e08e8 RDI: 0000000000000004
 RBP: 00007fff261e0920 R08: 0000000000400780 R09: 00007f8e3960f240
 R10: 00000000000003df R11: 0000000000000246 R12: 00000000004005a0
 R13: 00007fff261e0a00 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

 Allocated by task 4404:
 kasan_set_track+0x3d/0x60
 __kasan_kmalloc+0x85/0x90
 psi_trigger_create+0x113/0x3e0
 pressure_write+0x146/0x2e0
 cgroup_file_write+0x11c/0x250
 kernfs_fop_write_iter+0x186/0x220
 vfs_write+0x3d8/0x5c0
 ksys_write+0x90/0x110
 do_syscall_64+0x43/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

 Freed by task 4407:
 kasan_set_track+0x3d/0x60
 kasan_save_free_info+0x27/0x40
 ____kasan_slab_free+0x11d/0x170
 slab_free_freelist_hook+0x87/0x150
 __kmem_cache_free+0xcb/0x180
 psi_trigger_destroy+0x2e8/0x310
 cgroup_file_release+0x4f/0xb0
 kernfs_drain_open_files+0x165/0x1f0
 kernfs_drain+0x162/0x1a0
 __kernfs_remove+0x1fb/0x310
 kernfs_remove_by_name_ns+0x95/0xe0
 cgroup_addrm_files+0x67f/0x700
 cgroup_destroy_locked+0x283/0x3c0
 cgroup_rmdir+0x29/0x100
 kernfs_iop_rmdir+0xd1/0x140
 vfs_rmdir+0xfe/0x240
 do_rmdir+0x13d/0x280
 __x64_sys_rmdir+0x2c/0x30
 do_syscall_64+0x43/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Link: https://lore.kernel.org/lkml/20230106224859.4123476-1-kamatam@amazon.com/
Fixes: 0e94682b73bf ("psi: introduce psi monitor")
Cc: stable@vger.kernel.org
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
Signed-off-by: Mengchi Cheng <mengcc@amazon.com>
---
 kernel/sched/psi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 8ac8b81bfee6..6e66c15f6450 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1343,10 +1343,11 @@ void psi_trigger_destroy(struct psi_trigger *t)
 
 	group = t->group;
 	/*
-	 * Wakeup waiters to stop polling. Can happen if cgroup is deleted
-	 * from under a polling process.
+	 * Wakeup waiters to stop polling and clear the queue to prevent it from
+	 * being accessed later. Can happen if cgroup is deleted from under a
+	 * polling process otherwise.
 	 */
-	wake_up_interruptible(&t->event_wait);
+	wake_up_pollfree(&t->event_wait);
 
 	mutex_lock(&group->trigger_lock);
 
-- 
2.38.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1C72EFC1
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731647AbfE3DSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731638AbfE3DSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:42 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AF4824773;
        Thu, 30 May 2019 03:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186321;
        bh=oryTupGbrP0Ae2JeDZUHDiT2EeTkD1fZgp3YcnMdvt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dP0D1tD9KfmL5MmhsCCwkeCOeSdFKUQz769f+IJuPSS2/xEEsVlO28Cw2RY+Ova/W
         Vrw8go8zGnPjP1dz8hn4CGfIpwkEi0bQGXjJIUOW1Nxv9hWBxp/nrMdsyYm1lz1Ulk
         Q5N8AaHjJQusYwFMIOylEQjDv52KYr+Mw/2psJQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot+457d3e2ffbcf31aee5c0@syzkaller.appspotmail.com,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.14 031/193] bpf: devmap: fix use-after-free Read in __dev_map_entry_free
Date:   Wed, 29 May 2019 20:04:45 -0700
Message-Id: <20190530030453.606316270@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 2baae3545327632167c0180e9ca1d467416f1919 upstream.

synchronize_rcu() is fine when the rcu callbacks only need
to free memory (kfree_rcu() or direct kfree() call rcu call backs)

__dev_map_entry_free() is a bit more complex, so we need to make
sure that call queued __dev_map_entry_free() callbacks have completed.

sysbot report:

BUG: KASAN: use-after-free in dev_map_flush_old kernel/bpf/devmap.c:365
[inline]
BUG: KASAN: use-after-free in __dev_map_entry_free+0x2a8/0x300
kernel/bpf/devmap.c:379
Read of size 8 at addr ffff8801b8da38c8 by task ksoftirqd/1/18

CPU: 1 PID: 18 Comm: ksoftirqd/1 Not tainted 4.17.0+ #39
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
  dev_map_flush_old kernel/bpf/devmap.c:365 [inline]
  __dev_map_entry_free+0x2a8/0x300 kernel/bpf/devmap.c:379
  __rcu_reclaim kernel/rcu/rcu.h:178 [inline]
  rcu_do_batch kernel/rcu/tree.c:2558 [inline]
  invoke_rcu_callbacks kernel/rcu/tree.c:2818 [inline]
  __rcu_process_callbacks kernel/rcu/tree.c:2785 [inline]
  rcu_process_callbacks+0xe9d/0x1760 kernel/rcu/tree.c:2802
  __do_softirq+0x2e0/0xaf5 kernel/softirq.c:284
  run_ksoftirqd+0x86/0x100 kernel/softirq.c:645
  smpboot_thread_fn+0x417/0x870 kernel/smpboot.c:164
  kthread+0x345/0x410 kernel/kthread.c:240
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412

Allocated by task 6675:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  kmem_cache_alloc_trace+0x152/0x780 mm/slab.c:3620
  kmalloc include/linux/slab.h:513 [inline]
  kzalloc include/linux/slab.h:706 [inline]
  dev_map_alloc+0x208/0x7f0 kernel/bpf/devmap.c:102
  find_and_alloc_map kernel/bpf/syscall.c:129 [inline]
  map_create+0x393/0x1010 kernel/bpf/syscall.c:453
  __do_sys_bpf kernel/bpf/syscall.c:2351 [inline]
  __se_sys_bpf kernel/bpf/syscall.c:2328 [inline]
  __x64_sys_bpf+0x303/0x510 kernel/bpf/syscall.c:2328
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 26:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xd9/0x260 mm/slab.c:3813
  dev_map_free+0x4fa/0x670 kernel/bpf/devmap.c:191
  bpf_map_free_deferred+0xba/0xf0 kernel/bpf/syscall.c:262
  process_one_work+0xc64/0x1b70 kernel/workqueue.c:2153
  worker_thread+0x181/0x13a0 kernel/workqueue.c:2296
  kthread+0x345/0x410 kernel/kthread.c:240
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412

The buggy address belongs to the object at ffff8801b8da37c0
  which belongs to the cache kmalloc-512 of size 512
The buggy address is located 264 bytes inside of
  512-byte region [ffff8801b8da37c0, ffff8801b8da39c0)
The buggy address belongs to the page:
page:ffffea0006e368c0 count:1 mapcount:0 mapping:ffff8801da800940
index:0xffff8801b8da3540
flags: 0x2fffc0000000100(slab)
raw: 02fffc0000000100 ffffea0007217b88 ffffea0006e30cc8 ffff8801da800940
raw: ffff8801b8da3540 ffff8801b8da3040 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801b8da3780: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
  ffff8801b8da3800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8801b8da3880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                               ^
  ffff8801b8da3900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8801b8da3980: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc

Fixes: 546ac1ffb70d ("bpf: add devmap, a map for storing net device references")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+457d3e2ffbcf31aee5c0@syzkaller.appspotmail.com
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/devmap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -156,6 +156,9 @@ static void dev_map_free(struct bpf_map
 
 	synchronize_rcu();
 
+	/* Make sure prior __dev_map_entry_free() have completed. */
+	rcu_barrier();
+
 	/* To ensure all pending flush operations have completed wait for flush
 	 * bitmap to indicate all flush_needed bits to be zero on _all_ cpus.
 	 * Because the above synchronize_rcu() ensures the map is disconnected



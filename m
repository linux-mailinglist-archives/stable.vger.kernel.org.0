Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3403C371AFB
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbhECQnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231777AbhECQkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:40:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F6BA613D1;
        Mon,  3 May 2021 16:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059853;
        bh=7i+HRRY9j5t2M/4p9mdKK4BYL/VSeSIoB2Vo5p7Fw0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kpf/0+C2PhhqsCeUz6RTUdL2NHaODXdBadxmlzriYx+1v/vEPer2FsLOO//HWGzu/
         93QI0j00ontgeXpJgY10C+R90IdYXnadZfm5HwwG8n4rPPS2PNpahLTRmMcKl5k/yE
         5X1mMMIuoTlIaVT1/B7cLQ/GYzM71+1SJ+xiCX/6TvF4w2wUGEUW1INO+MSx1+qTL8
         S7oy72BpLsFY2gZHbWwrq7i5VefiIVJ9Ty43ghBcgoazdRxaAGsVBe+5HwWBRwkgui
         PXvq4ZkwBaIU7mmAi1sX3laEX65ztmpP3t5pKRR2r1TbItS1LABw9IBGlCLy5dmCWO
         FUnRzFC/S1N8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 021/115] kvfree_rcu: Use same set of GFP flags as does single-argument
Date:   Mon,  3 May 2021 12:35:25 -0400
Message-Id: <20210503163700.2852194-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>

[ Upstream commit ee6ddf58475cce8a3d3697614679cd8cb4a6f583 ]

Running an rcuscale stress-suite can lead to "Out of memory" of a
system. This can happen under high memory pressure with a small amount
of physical memory.

For example, a KVM test configuration with 64 CPUs and 512 megabytes
can result in OOM when running rcuscale with below parameters:

../kvm.sh --torture rcuscale --allcpus --duration 10 --kconfig CONFIG_NR_CPUS=64 \
--bootargs "rcuscale.kfree_rcu_test=1 rcuscale.kfree_nthreads=16 rcuscale.holdoff=20 \
  rcuscale.kfree_loops=10000 torture.disable_onoff_at_boot" --trust-make

<snip>
[   12.054448] kworker/1:1H invoked oom-killer: gfp_mask=0x2cc0(GFP_KERNEL|__GFP_NOWARN), order=0, oom_score_adj=0
[   12.055303] CPU: 1 PID: 377 Comm: kworker/1:1H Not tainted 5.11.0-rc3+ #510
[   12.055416] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.12.0-1 04/01/2014
[   12.056485] Workqueue: events_highpri fill_page_cache_func
[   12.056485] Call Trace:
[   12.056485]  dump_stack+0x57/0x6a
[   12.056485]  dump_header+0x4c/0x30a
[   12.056485]  ? del_timer_sync+0x20/0x30
[   12.056485]  out_of_memory.cold.47+0xa/0x7e
[   12.056485]  __alloc_pages_slowpath.constprop.123+0x82f/0xc00
[   12.056485]  __alloc_pages_nodemask+0x289/0x2c0
[   12.056485]  __get_free_pages+0x8/0x30
[   12.056485]  fill_page_cache_func+0x39/0xb0
[   12.056485]  process_one_work+0x1ed/0x3b0
[   12.056485]  ? process_one_work+0x3b0/0x3b0
[   12.060485]  worker_thread+0x28/0x3c0
[   12.060485]  ? process_one_work+0x3b0/0x3b0
[   12.060485]  kthread+0x138/0x160
[   12.060485]  ? kthread_park+0x80/0x80
[   12.060485]  ret_from_fork+0x22/0x30
[   12.062156] Mem-Info:
[   12.062350] active_anon:0 inactive_anon:0 isolated_anon:0
[   12.062350]  active_file:0 inactive_file:0 isolated_file:0
[   12.062350]  unevictable:0 dirty:0 writeback:0
[   12.062350]  slab_reclaimable:2797 slab_unreclaimable:80920
[   12.062350]  mapped:1 shmem:2 pagetables:8 bounce:0
[   12.062350]  free:10488 free_pcp:1227 free_cma:0
...
[   12.101610] Out of memory and no killable processes...
[   12.102042] Kernel panic - not syncing: System is deadlocked on memory
[   12.102583] CPU: 1 PID: 377 Comm: kworker/1:1H Not tainted 5.11.0-rc3+ #510
[   12.102600] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.12.0-1 04/01/2014
<snip>

Because kvfree_rcu() has a fallback path, memory allocation failure is
not the end of the world.  Furthermore, the added overhead of aggressive
GFP settings must be balanced against the overhead of the fallback path,
which is a cache miss for double-argument kvfree_rcu() and a call to
synchronize_rcu() for single-argument kvfree_rcu().  The current choice
of GFP_KERNEL|__GFP_NOWARN can result in longer latencies than a call
to synchronize_rcu(), so less-tenacious GFP flags would be helpful.

Here is the tradeoff that must be balanced:
    a) Minimize use of the fallback path,
    b) Avoid pushing the system into OOM,
    c) Bound allocation latency to that of synchronize_rcu(), and
    d) Leave the emergency reserves to use cases lacking fallbacks.

This commit therefore changes GFP flags from GFP_KERNEL|__GFP_NOWARN to
GFP_KERNEL|__GFP_NORETRY|__GFP_NOMEMALLOC|__GFP_NOWARN.  This combination
leaves the emergency reserves alone and can initiate reclaim, but will
not invoke the OOM killer.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index ce17b8477442..84a3fe09630b 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3439,7 +3439,7 @@ static void fill_page_cache_func(struct work_struct *work)
 
 	for (i = 0; i < rcu_min_cached_objs; i++) {
 		bnode = (struct kvfree_rcu_bulk_data *)
-			__get_free_page(GFP_KERNEL | __GFP_NOWARN);
+			__get_free_page(GFP_KERNEL | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
 
 		if (bnode) {
 			raw_spin_lock_irqsave(&krcp->lock, flags);
-- 
2.30.2


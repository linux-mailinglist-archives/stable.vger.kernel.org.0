Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092771B9FEC
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 11:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgD0Ja4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 05:30:56 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:50925 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726855AbgD0Jaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 05:30:55 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21032780-1500050 
        for multiple; Mon, 27 Apr 2020 10:30:39 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Check cacheline is valid before acquiring
Date:   Mon, 27 Apr 2020 10:30:38 +0100
Message-Id: <20200427093038.29219-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200427092931.29097-1-chris@chris-wilson.co.uk>
References: <20200427092931.29097-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The hwsp_cacheline pointer from i915_request is very, very flimsy. The
i915_request.timeline (and the hwsp_cacheline) are lost upon retiring
(after an RCU grace). Therefore we need to confirm that once we have the
right pointer for the cacheline, it is not in the process of being
retired and disposed of before we attempt to acquire a reference to the
cacheline.

<3>[  547.208237] BUG: KASAN: use-after-free in active_debug_hint+0x6a/0x70 [i915]
<3>[  547.208366] Read of size 8 at addr ffff88822a0d2710 by task gem_exec_parall/2536

<4>[  547.208547] CPU: 3 PID: 2536 Comm: gem_exec_parall Tainted: G     U            5.7.0-rc2-ged7a286b5d02d-kasan_117+ #1
<4>[  547.208556] Hardware name: Dell Inc. XPS 13 9350/, BIOS 1.4.12 11/30/2016
<4>[  547.208564] Call Trace:
<4>[  547.208579]  dump_stack+0x96/0xdb
<4>[  547.208707]  ? active_debug_hint+0x6a/0x70 [i915]
<4>[  547.208719]  print_address_description.constprop.6+0x16/0x310
<4>[  547.208841]  ? active_debug_hint+0x6a/0x70 [i915]
<4>[  547.208963]  ? active_debug_hint+0x6a/0x70 [i915]
<4>[  547.208975]  __kasan_report+0x137/0x190
<4>[  547.209106]  ? active_debug_hint+0x6a/0x70 [i915]
<4>[  547.209127]  kasan_report+0x32/0x50
<4>[  547.209257]  ? i915_gemfs_fini+0x40/0x40 [i915]
<4>[  547.209376]  active_debug_hint+0x6a/0x70 [i915]
<4>[  547.209389]  debug_print_object+0xa7/0x220
<4>[  547.209405]  ? lockdep_hardirqs_on+0x348/0x5f0
<4>[  547.209426]  debug_object_assert_init+0x297/0x430
<4>[  547.209449]  ? debug_object_free+0x360/0x360
<4>[  547.209472]  ? lock_acquire+0x1ac/0x8a0
<4>[  547.209592]  ? intel_timeline_read_hwsp+0x4f/0x840 [i915]
<4>[  547.209737]  ? i915_active_acquire_if_busy+0x66/0x120 [i915]
<4>[  547.209861]  i915_active_acquire_if_busy+0x66/0x120 [i915]
<4>[  547.209990]  ? __live_alloc.isra.15+0xc0/0xc0 [i915]
<4>[  547.210005]  ? rcu_read_lock_sched_held+0xd0/0xd0
<4>[  547.210017]  ? print_usage_bug+0x580/0x580
<4>[  547.210153]  intel_timeline_read_hwsp+0xbc/0x840 [i915]
<4>[  547.210284]  __emit_semaphore_wait+0xd5/0x480 [i915]
<4>[  547.210415]  ? i915_fence_get_timeline_name+0x110/0x110 [i915]
<4>[  547.210428]  ? lockdep_hardirqs_on+0x348/0x5f0
<4>[  547.210442]  ? _raw_spin_unlock_irq+0x2a/0x40
<4>[  547.210567]  ? __await_execution.constprop.51+0x2e0/0x570 [i915]
<4>[  547.210706]  i915_request_await_dma_fence+0x8f7/0xc70 [i915]

Fixes: 85bedbf191e8 ("drm/i915/gt: Eliminate the trylock for reading a timeline's hwsp")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.6+
---
 drivers/gpu/drm/i915/gt/intel_timeline.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_timeline.c b/drivers/gpu/drm/i915/gt/intel_timeline.c
index 29a39e44fa36..e1fac1b38f27 100644
--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -544,6 +544,8 @@ int intel_timeline_read_hwsp(struct i915_request *from,
 
 	rcu_read_lock();
 	cl = rcu_dereference(from->hwsp_cacheline);
+	if (i915_request_completed(from)) /* confirm cacheline is valid */
+		goto unlock;
 	if (unlikely(!i915_active_acquire_if_busy(&cl->active)))
 		goto unlock; /* seqno wrapped and completed! */
 	if (unlikely(i915_request_completed(from)))
-- 
2.20.1


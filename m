Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D54217F557
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 11:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgCJKs3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 10 Mar 2020 06:48:29 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:53172 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725937AbgCJKs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 06:48:28 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20506715-1500050 
        for multiple; Tue, 10 Mar 2020 10:48:23 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200310101720.9944-1-chris@chris-wilson.co.uk>
References: <20200310101720.9944-1-chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: Defer semaphore priority bumping to a workqueue
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Tvrtko Ursulin <tvrtko.ursulin@intel.com>, stable@vger.kernel.org
Message-ID: <158383730254.16414.15062160607111788867@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Tue, 10 Mar 2020 10:48:22 +0000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Chris Wilson (2020-03-10 10:17:20)
> Since the semaphore fence may be signaled from inside an interrupt
> handler from inside a request holding its request->lock, we cannot then
> enter into the engine->active.lock for processing the semaphore priority
> bump as we may traverse our call tree and end up on another held
> request.
> 
> CPU 0:
> [ 2243.218864]  _raw_spin_lock_irqsave+0x9a/0xb0
> [ 2243.218867]  i915_schedule_bump_priority+0x49/0x80 [i915]
> [ 2243.218869]  semaphore_notify+0x6d/0x98 [i915]
> [ 2243.218871]  __i915_sw_fence_complete+0x61/0x420 [i915]
> [ 2243.218874]  ? kmem_cache_free+0x211/0x290
> [ 2243.218876]  i915_sw_fence_complete+0x58/0x80 [i915]
> [ 2243.218879]  dma_i915_sw_fence_wake+0x3e/0x80 [i915]
> [ 2243.218881]  signal_irq_work+0x571/0x690 [i915]
> [ 2243.218883]  irq_work_run_list+0xd7/0x120
> [ 2243.218885]  irq_work_run+0x1d/0x50
> [ 2243.218887]  smp_irq_work_interrupt+0x21/0x30
> [ 2243.218889]  irq_work_interrupt+0xf/0x20
> 
> CPU 1:
> [ 2242.173107]  _raw_spin_lock+0x8f/0xa0
> [ 2242.173110]  __i915_request_submit+0x64/0x4a0 [i915]
> [ 2242.173112]  __execlists_submission_tasklet+0x8ee/0x2120 [i915]
> [ 2242.173114]  ? i915_sched_lookup_priolist+0x1e3/0x2b0 [i915]
> [ 2242.173117]  execlists_submit_request+0x2e8/0x2f0 [i915]
> [ 2242.173119]  submit_notify+0x8f/0xc0 [i915]
> [ 2242.173121]  __i915_sw_fence_complete+0x61/0x420 [i915]
> [ 2242.173124]  ? _raw_spin_unlock_irqrestore+0x39/0x40
> [ 2242.173137]  i915_sw_fence_complete+0x58/0x80 [i915]
> [ 2242.173140]  i915_sw_fence_commit+0x16/0x20 [i915]
> 
> CPU 2:
> [ 2242.173107]  _raw_spin_lock+0x8f/0xa0
> [ 2242.173110]  __i915_request_submit+0x64/0x4a0 [i915]
> [ 2242.173112]  __execlists_submission_tasklet+0x8ee/0x2120 [i915]
> [ 2242.173114]  ? i915_sched_lookup_priolist+0x1e3/0x2b0 [i915]
> [ 2242.173117]  execlists_submit_request+0x2e8/0x2f0 [i915]
> [ 2242.173119]  submit_notify+0x8f/0xc0 [i915]

Ignore this, I thought this was a third interesting chunk, but I copied
the same one twice.
-Chris

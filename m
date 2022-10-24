Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D0460AC68
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbiJXOGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237289AbiJXOFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:05:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28D24315D;
        Mon, 24 Oct 2022 05:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25D9761278;
        Mon, 24 Oct 2022 12:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCC3C433C1;
        Mon, 24 Oct 2022 12:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614029;
        bh=S+wL1Br80nM3uFX/YVg4sGngKat8IEBMLav3+KJKpow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyLUN2ycmGBUW/r91Z6eBi0+obxHQ6lG22M888ZcExpzXrC5cNIc0A2mjklgy0JlY
         N0KY9Sg/SmRR1abCMcJPdXGrzflJvSvvn5AQVmXNg55M4sH5ryZBcs/tk8eUlnL1DO
         6iN6liTPNZeggxiFIYrFcqgm3WtuyyEVLo9Xtaqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kohei Tarumizu <tarumizu.kohei@fujitsu.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/390] x86/resctrl: Fix to restore to original value when re-enabling hardware prefetch register
Date:   Mon, 24 Oct 2022 13:28:22 +0200
Message-Id: <20221024113027.151193203@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kohei Tarumizu <tarumizu.kohei@fujitsu.com>

[ Upstream commit 499c8bb4693d1c8d8f3d6dd38e5bdde3ff5bd906 ]

The current pseudo_lock.c code overwrites the value of the
MSR_MISC_FEATURE_CONTROL to 0 even if the original value is not 0.
Therefore, modify it to save and restore the original values.

Fixes: 018961ae5579 ("x86/intel_rdt: Pseudo-lock region creation/removal core")
Fixes: 443810fe6160 ("x86/intel_rdt: Create debugfs files for pseudo-locking testing")
Fixes: 8a2fc0e1bc0c ("x86/intel_rdt: More precise L2 hit/miss measurements")
Signed-off-by: Kohei Tarumizu <tarumizu.kohei@fujitsu.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://lkml.kernel.org/r/eb660f3c2010b79a792c573c02d01e8e841206ad.1661358182.git.reinette.chatre@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index 0daf2f1cf7a8..465dce141bfc 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -416,6 +416,7 @@ static int pseudo_lock_fn(void *_rdtgrp)
 	struct pseudo_lock_region *plr = rdtgrp->plr;
 	u32 rmid_p, closid_p;
 	unsigned long i;
+	u64 saved_msr;
 #ifdef CONFIG_KASAN
 	/*
 	 * The registers used for local register variables are also used
@@ -459,6 +460,7 @@ static int pseudo_lock_fn(void *_rdtgrp)
 	 * the buffer and evict pseudo-locked memory read earlier from the
 	 * cache.
 	 */
+	saved_msr = __rdmsr(MSR_MISC_FEATURE_CONTROL);
 	__wrmsr(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits, 0x0);
 	closid_p = this_cpu_read(pqr_state.cur_closid);
 	rmid_p = this_cpu_read(pqr_state.cur_rmid);
@@ -510,7 +512,7 @@ static int pseudo_lock_fn(void *_rdtgrp)
 	__wrmsr(IA32_PQR_ASSOC, rmid_p, closid_p);
 
 	/* Re-enable the hardware prefetcher(s) */
-	wrmsr(MSR_MISC_FEATURE_CONTROL, 0x0, 0x0);
+	wrmsrl(MSR_MISC_FEATURE_CONTROL, saved_msr);
 	local_irq_enable();
 
 	plr->thread_done = 1;
@@ -867,6 +869,7 @@ bool rdtgroup_pseudo_locked_in_hierarchy(struct rdt_domain *d)
 static int measure_cycles_lat_fn(void *_plr)
 {
 	struct pseudo_lock_region *plr = _plr;
+	u32 saved_low, saved_high;
 	unsigned long i;
 	u64 start, end;
 	void *mem_r;
@@ -875,6 +878,7 @@ static int measure_cycles_lat_fn(void *_plr)
 	/*
 	 * Disable hardware prefetchers.
 	 */
+	rdmsr(MSR_MISC_FEATURE_CONTROL, saved_low, saved_high);
 	wrmsr(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits, 0x0);
 	mem_r = READ_ONCE(plr->kmem);
 	/*
@@ -891,7 +895,7 @@ static int measure_cycles_lat_fn(void *_plr)
 		end = rdtsc_ordered();
 		trace_pseudo_lock_mem_latency((u32)(end - start));
 	}
-	wrmsr(MSR_MISC_FEATURE_CONTROL, 0x0, 0x0);
+	wrmsr(MSR_MISC_FEATURE_CONTROL, saved_low, saved_high);
 	local_irq_enable();
 	plr->thread_done = 1;
 	wake_up_interruptible(&plr->lock_thread_wq);
@@ -936,6 +940,7 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	u64 hits_before = 0, hits_after = 0, miss_before = 0, miss_after = 0;
 	struct perf_event *miss_event, *hit_event;
 	int hit_pmcnum, miss_pmcnum;
+	u32 saved_low, saved_high;
 	unsigned int line_size;
 	unsigned int size;
 	unsigned long i;
@@ -969,6 +974,7 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	/*
 	 * Disable hardware prefetchers.
 	 */
+	rdmsr(MSR_MISC_FEATURE_CONTROL, saved_low, saved_high);
 	wrmsr(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits, 0x0);
 
 	/* Initialize rest of local variables */
@@ -1027,7 +1033,7 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	 */
 	rmb();
 	/* Re-enable hardware prefetchers */
-	wrmsr(MSR_MISC_FEATURE_CONTROL, 0x0, 0x0);
+	wrmsr(MSR_MISC_FEATURE_CONTROL, saved_low, saved_high);
 	local_irq_enable();
 out_hit:
 	perf_event_release_kernel(hit_event);
-- 
2.35.1




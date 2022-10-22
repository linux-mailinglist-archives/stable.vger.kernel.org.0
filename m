Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CE060874E
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbiJVIAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbiJVH5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:57:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5F013A5B7;
        Sat, 22 Oct 2022 00:48:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65E5560B9F;
        Sat, 22 Oct 2022 07:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72242C433C1;
        Sat, 22 Oct 2022 07:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424624;
        bh=p6ayDb24pUcC13Ada1bVfO09ocE5wIRtINfIU329Dbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ez768vD5i4czE2TjuBiZQsx9mkKTzcePYn2Dy60hcEx7rwzrgHOAkVQvluzDqRtoe
         A3MTTVKV3cK0pWwPUwiQAANOQ+vQ7xGWvWTIhq9/0QUS5jpTcgVTxRCa9TO4a7TETB
         HAG2Zm3snOkJkxHyk8U/3uGFTWTvF9SNXPcPdA9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kohei Tarumizu <tarumizu.kohei@fujitsu.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 215/717] x86/resctrl: Fix to restore to original value when re-enabling hardware prefetch register
Date:   Sat, 22 Oct 2022 09:21:34 +0200
Message-Id: <20221022072453.281763425@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index db813f819ad6..4d8398986f78 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -420,6 +420,7 @@ static int pseudo_lock_fn(void *_rdtgrp)
 	struct pseudo_lock_region *plr = rdtgrp->plr;
 	u32 rmid_p, closid_p;
 	unsigned long i;
+	u64 saved_msr;
 #ifdef CONFIG_KASAN
 	/*
 	 * The registers used for local register variables are also used
@@ -463,6 +464,7 @@ static int pseudo_lock_fn(void *_rdtgrp)
 	 * the buffer and evict pseudo-locked memory read earlier from the
 	 * cache.
 	 */
+	saved_msr = __rdmsr(MSR_MISC_FEATURE_CONTROL);
 	__wrmsr(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits, 0x0);
 	closid_p = this_cpu_read(pqr_state.cur_closid);
 	rmid_p = this_cpu_read(pqr_state.cur_rmid);
@@ -514,7 +516,7 @@ static int pseudo_lock_fn(void *_rdtgrp)
 	__wrmsr(IA32_PQR_ASSOC, rmid_p, closid_p);
 
 	/* Re-enable the hardware prefetcher(s) */
-	wrmsr(MSR_MISC_FEATURE_CONTROL, 0x0, 0x0);
+	wrmsrl(MSR_MISC_FEATURE_CONTROL, saved_msr);
 	local_irq_enable();
 
 	plr->thread_done = 1;
@@ -871,6 +873,7 @@ bool rdtgroup_pseudo_locked_in_hierarchy(struct rdt_domain *d)
 static int measure_cycles_lat_fn(void *_plr)
 {
 	struct pseudo_lock_region *plr = _plr;
+	u32 saved_low, saved_high;
 	unsigned long i;
 	u64 start, end;
 	void *mem_r;
@@ -879,6 +882,7 @@ static int measure_cycles_lat_fn(void *_plr)
 	/*
 	 * Disable hardware prefetchers.
 	 */
+	rdmsr(MSR_MISC_FEATURE_CONTROL, saved_low, saved_high);
 	wrmsr(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits, 0x0);
 	mem_r = READ_ONCE(plr->kmem);
 	/*
@@ -895,7 +899,7 @@ static int measure_cycles_lat_fn(void *_plr)
 		end = rdtsc_ordered();
 		trace_pseudo_lock_mem_latency((u32)(end - start));
 	}
-	wrmsr(MSR_MISC_FEATURE_CONTROL, 0x0, 0x0);
+	wrmsr(MSR_MISC_FEATURE_CONTROL, saved_low, saved_high);
 	local_irq_enable();
 	plr->thread_done = 1;
 	wake_up_interruptible(&plr->lock_thread_wq);
@@ -940,6 +944,7 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	u64 hits_before = 0, hits_after = 0, miss_before = 0, miss_after = 0;
 	struct perf_event *miss_event, *hit_event;
 	int hit_pmcnum, miss_pmcnum;
+	u32 saved_low, saved_high;
 	unsigned int line_size;
 	unsigned int size;
 	unsigned long i;
@@ -973,6 +978,7 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	/*
 	 * Disable hardware prefetchers.
 	 */
+	rdmsr(MSR_MISC_FEATURE_CONTROL, saved_low, saved_high);
 	wrmsr(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits, 0x0);
 
 	/* Initialize rest of local variables */
@@ -1031,7 +1037,7 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
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




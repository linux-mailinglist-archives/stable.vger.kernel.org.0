Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0296063591B
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236339AbiKWKHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236414AbiKWKGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:06:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DDC25A
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:56:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3F8861B56
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074D3C433D7;
        Wed, 23 Nov 2022 09:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197411;
        bh=lPKHhzfzRA4VfQr5c8y5RM97W9VQYAEaAnU2/u+v8LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jcm4mkj6ZTjD/xui8Z+MPaG/leM0fJ+R7WM/N9m7uspewxLg75jYbXP7ixucYLaLM
         Yquwc3nr/Th9d1isJ718yZvKSTkwe+Jp5RMxOgoFbn6LSFG3ZwLAPklG5cokrvzEVq
         3gDD4ce3ZKgW6a2a4mo/x0EMO3BkAzApuQ5to7MQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Ravi Bangoria <ravi.bangoria@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 287/314] perf/x86/amd: Fix crash due to race between amd_pmu_enable_all, perf NMI and throttling
Date:   Wed, 23 Nov 2022 09:52:12 +0100
Message-Id: <20221123084638.533510476@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@amd.com>

[ Upstream commit baa014b9543c8e5e94f5d15b66abfe60750b8284 ]

amd_pmu_enable_all() does:

      if (!test_bit(idx, cpuc->active_mask))
              continue;

      amd_pmu_enable_event(cpuc->events[idx]);

A perf NMI of another event can come between these two steps. Perf NMI
handler internally disables and enables _all_ events, including the one
which nmi-intercepted amd_pmu_enable_all() was in process of enabling.
If that unintentionally enabled event has very low sampling period and
causes immediate successive NMI, causing the event to be throttled,
cpuc->events[idx] and cpuc->active_mask gets cleared by x86_pmu_stop().
This will result in amd_pmu_enable_event() getting called with event=NULL
when amd_pmu_enable_all() resumes after handling the NMIs. This causes a
kernel crash:

  BUG: kernel NULL pointer dereference, address: 0000000000000198
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  [...]
  Call Trace:
   <TASK>
   amd_pmu_enable_all+0x68/0xb0
   ctx_resched+0xd9/0x150
   event_function+0xb8/0x130
   ? hrtimer_start_range_ns+0x141/0x4a0
   ? perf_duration_warn+0x30/0x30
   remote_function+0x4d/0x60
   __flush_smp_call_function_queue+0xc4/0x500
   flush_smp_call_function_queue+0x11d/0x1b0
   do_idle+0x18f/0x2d0
   cpu_startup_entry+0x19/0x20
   start_secondary+0x121/0x160
   secondary_startup_64_no_verify+0xe5/0xeb
   </TASK>

amd_pmu_disable_all()/amd_pmu_enable_all() calls inside perf NMI handler
were recently added as part of BRS enablement but I'm not sure whether
we really need them. We can just disable BRS in the beginning and enable
it back while returning from NMI. This will solve the issue by not
enabling those events whose active_masks are set but are not yet enabled
in hw pmu.

Fixes: ada543459cab ("perf/x86/amd: Add AMD Fam19h Branch Sampling support")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20221114044029.373-1-ravi.bangoria@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 9ac3718410ce..7e39c47d7759 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -896,8 +896,7 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 	pmu_enabled = cpuc->enabled;
 	cpuc->enabled = 0;
 
-	/* stop everything (includes BRS) */
-	amd_pmu_disable_all();
+	amd_brs_disable_all();
 
 	/* Drain BRS is in use (could be inactive) */
 	if (cpuc->lbr_users)
@@ -908,7 +907,7 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc->enabled = pmu_enabled;
 	if (pmu_enabled)
-		amd_pmu_enable_all(0);
+		amd_brs_enable_all();
 
 	return amd_pmu_adjust_nmi_window(handled);
 }
-- 
2.35.1




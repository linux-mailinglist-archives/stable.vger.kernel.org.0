Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2146AEBD4
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjCGRt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbjCGRsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:48:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAE498EA3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:43:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4070614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCBDC433D2;
        Tue,  7 Mar 2023 17:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210721;
        bh=UWfoVHCIMcXXZEC4WkYEzU9xMqbxy+hmF9ARRDEdT9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9swFMedz+/hPsexdfMzvafTFqL8LkUoiyKXCkO0bRvgF8IW332LYiBNxGLYW8UVu
         Zzqiq74d8+PRi6itiIZo3LdcOFerr/LuWNBufmn+NDT0HUekoYYiXp2hMnu7kkpDNk
         R7YGsTSlC7tFnghp7socyvPg8P/Cc9xJSIquIoes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0633/1001] cpuidle: drivers: firmware: psci: Dont instrument suspend code
Date:   Tue,  7 Mar 2023 17:56:45 +0100
Message-Id: <20230307170049.049972903@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 393e2ea30aec634b37004d401863428e120d5e1b ]

The PSCI suspend code is currently instrumentable, which is not safe as
instrumentation (e.g. ftrace) may try to make use of RCU during idle
periods when RCU is not watching.

To fix this we need to ensure that psci_suspend_finisher() and anything
it calls are not instrumented. We can do this fairly simply by marking
psci_suspend_finisher() and the psci*_cpu_suspend() functions as
noinstr, and the underlying helper functions as __always_inline.

When CONFIG_DEBUG_VIRTUAL=y, __pa_symbol() can expand to an out-of-line
instrumented function, so we must use __pa_symbol_nodebug() within
psci_suspend_finisher().

The raw SMCCC invocation functions are written in assembly, and are not
subject to compiler instrumentation.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230126151323.349423061@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/psci/psci.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index 447ee4ea5c903..f78249fe2512a 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -108,9 +108,10 @@ bool psci_power_state_is_valid(u32 state)
 	return !(state & ~valid_mask);
 }
 
-static unsigned long __invoke_psci_fn_hvc(unsigned long function_id,
-			unsigned long arg0, unsigned long arg1,
-			unsigned long arg2)
+static __always_inline unsigned long
+__invoke_psci_fn_hvc(unsigned long function_id,
+		     unsigned long arg0, unsigned long arg1,
+		     unsigned long arg2)
 {
 	struct arm_smccc_res res;
 
@@ -118,9 +119,10 @@ static unsigned long __invoke_psci_fn_hvc(unsigned long function_id,
 	return res.a0;
 }
 
-static unsigned long __invoke_psci_fn_smc(unsigned long function_id,
-			unsigned long arg0, unsigned long arg1,
-			unsigned long arg2)
+static __always_inline unsigned long
+__invoke_psci_fn_smc(unsigned long function_id,
+		     unsigned long arg0, unsigned long arg1,
+		     unsigned long arg2)
 {
 	struct arm_smccc_res res;
 
@@ -128,7 +130,7 @@ static unsigned long __invoke_psci_fn_smc(unsigned long function_id,
 	return res.a0;
 }
 
-static int psci_to_linux_errno(int errno)
+static __always_inline int psci_to_linux_errno(int errno)
 {
 	switch (errno) {
 	case PSCI_RET_SUCCESS:
@@ -169,7 +171,8 @@ int psci_set_osi_mode(bool enable)
 	return psci_to_linux_errno(err);
 }
 
-static int __psci_cpu_suspend(u32 fn, u32 state, unsigned long entry_point)
+static __always_inline int
+__psci_cpu_suspend(u32 fn, u32 state, unsigned long entry_point)
 {
 	int err;
 
@@ -177,13 +180,15 @@ static int __psci_cpu_suspend(u32 fn, u32 state, unsigned long entry_point)
 	return psci_to_linux_errno(err);
 }
 
-static int psci_0_1_cpu_suspend(u32 state, unsigned long entry_point)
+static __always_inline int
+psci_0_1_cpu_suspend(u32 state, unsigned long entry_point)
 {
 	return __psci_cpu_suspend(psci_0_1_function_ids.cpu_suspend,
 				  state, entry_point);
 }
 
-static int psci_0_2_cpu_suspend(u32 state, unsigned long entry_point)
+static __always_inline int
+psci_0_2_cpu_suspend(u32 state, unsigned long entry_point)
 {
 	return __psci_cpu_suspend(PSCI_FN_NATIVE(0_2, CPU_SUSPEND),
 				  state, entry_point);
@@ -450,10 +455,12 @@ late_initcall(psci_debugfs_init)
 #endif
 
 #ifdef CONFIG_CPU_IDLE
-static int psci_suspend_finisher(unsigned long state)
+static noinstr int psci_suspend_finisher(unsigned long state)
 {
 	u32 power_state = state;
-	phys_addr_t pa_cpu_resume = __pa_symbol(cpu_resume);
+	phys_addr_t pa_cpu_resume;
+
+	pa_cpu_resume = __pa_symbol_nodebug((unsigned long)cpu_resume);
 
 	return psci_ops.cpu_suspend(power_state, pa_cpu_resume);
 }
-- 
2.39.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6675292AA
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 23:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346473AbiEPVNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 17:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350356AbiEPVMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 17:12:25 -0400
X-Greylist: delayed 537 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 May 2022 14:04:08 PDT
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050:0:465::103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324A940907
        for <stable@vger.kernel.org>; Mon, 16 May 2022 14:04:07 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4L2BN46f6pz9sTG;
        Mon, 16 May 2022 22:55:16 +0200 (CEST)
From:   Markus Boehme <markubo@amazon.com>
To:     stable@vger.kernel.org
Cc:     Miroslav Benes <mbenes@suse.cz>, Juergen Gross <jgross@suse.com>,
        Markus Boehme <markubo@amazon.com>
Subject: [PATCH 2/2] x86/xen: Make the secondary CPU idle tasks reliable
Date:   Mon, 16 May 2022 22:54:39 +0200
Message-Id: <20220516205439.255114-3-markubo@amazon.com>
In-Reply-To: <20220516205439.255114-1-markubo@amazon.com>
References: <20220516205439.255114-1-markubo@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: 23f38b479fca7b33fcd
X-MBO-RS-META: nf5zz7s37ag36mczewkj1fsq5kjx9s8k
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_ADSP_ALL,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Benes <mbenes@suse.cz>

upstream commit c3881eb58d56116c79ac4ee4f40fd15ead124c4b

The unwinder reports the secondary CPU idle tasks' stack on XEN PV as
unreliable, which affects at least live patching.
cpu_initialize_context() sets up the context of the CPU through
VCPUOP_initialise hypercall. After it is woken up, the idle task starts
in cpu_bringup_and_idle() function and its stack starts at the offset
right below pt_regs. The unwinder correctly detects the end of stack
there but it is confused by NULL return address in the last frame.

Introduce a wrapper in assembly, which just calls
cpu_bringup_and_idle(). The return address is thus pushed on the stack
and the wrapper contains the annotation hint for the unwinder regarding
the stack state.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Markus Boehme <markubo@amazon.com>
---
 arch/x86/xen/smp_pv.c   |  3 ++-
 arch/x86/xen/xen-head.S | 10 ++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
index 64e6ec2c32a7..9d9777ded5f7 100644
--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -53,6 +53,7 @@ static DEFINE_PER_CPU(struct xen_common_irq, xen_irq_work) = { .irq = -1 };
 static DEFINE_PER_CPU(struct xen_common_irq, xen_pmu_irq) = { .irq = -1 };
 
 static irqreturn_t xen_irq_work_interrupt(int irq, void *dev_id);
+void asm_cpu_bringup_and_idle(void);
 
 static void cpu_bringup(void)
 {
@@ -310,7 +311,7 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	 * pointing just below where pt_regs would be if it were a normal
 	 * kernel entry.
 	 */
-	ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
+	ctxt->user_regs.eip = (unsigned long)asm_cpu_bringup_and_idle;
 	ctxt->flags = VGCF_IN_KERNEL;
 	ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
 	ctxt->user_regs.ds = __USER_DS;
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index deb6abe5d346..591544b4b85a 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -58,6 +58,16 @@ ENTRY(startup_xen)
 	call xen_start_kernel
 END(startup_xen)
 	__FINIT
+
+#ifdef CONFIG_XEN_PV_SMP
+.pushsection .text
+SYM_CODE_START(asm_cpu_bringup_and_idle)
+	UNWIND_HINT_EMPTY
+
+	call cpu_bringup_and_idle
+SYM_CODE_END(asm_cpu_bringup_and_idle)
+.popsection
+#endif
 #endif
 
 .pushsection .text
-- 
2.25.1


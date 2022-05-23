Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F16531785
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239918AbiEWRRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240969AbiEWRQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:16:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50B86B665;
        Mon, 23 May 2022 10:16:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99935B81205;
        Mon, 23 May 2022 17:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB92AC385A9;
        Mon, 23 May 2022 17:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325979;
        bh=XmBQV3f1U39XKjofWdJcehcZCPUMgpflEGSWZaI+XD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mK8mRP/92OrUtkg98ZJji2VdOdNTS5aqWNnB+PTdtyoSmLqho80UkrW/ubU8ORXrU
         ckcq6DTv0rKhcmaAdEg2U78palmkPPLnxJv9AL1dtl9Swhp+XUiYCkpctownGJIOcd
         ur7BWP+4EBE55P/2hiqVDxrXTogrsACeoBDjC/sM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Juergen Gross <jgross@suse.com>,
        Markus Boehme <markubo@amazon.com>
Subject: [PATCH 5.4 03/68] x86/xen: Make the secondary CPU idle tasks reliable
Date:   Mon, 23 May 2022 19:04:30 +0200
Message-Id: <20220523165803.141513758@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Benes <mbenes@suse.cz>

commit c3881eb58d56116c79ac4ee4f40fd15ead124c4b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/xen/smp_pv.c   |    3 ++-
 arch/x86/xen/xen-head.S |   10 ++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -53,6 +53,7 @@ static DEFINE_PER_CPU(struct xen_common_
 static DEFINE_PER_CPU(struct xen_common_irq, xen_pmu_irq) = { .irq = -1 };
 
 static irqreturn_t xen_irq_work_interrupt(int irq, void *dev_id);
+void asm_cpu_bringup_and_idle(void);
 
 static void cpu_bringup(void)
 {
@@ -310,7 +311,7 @@ cpu_initialize_context(unsigned int cpu,
 	 * pointing just below where pt_regs would be if it were a normal
 	 * kernel entry.
 	 */
-	ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
+	ctxt->user_regs.eip = (unsigned long)asm_cpu_bringup_and_idle;
 	ctxt->flags = VGCF_IN_KERNEL;
 	ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
 	ctxt->user_regs.ds = __USER_DS;
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



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE5E4F9B90
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 19:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbiDHRYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 13:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238130AbiDHRYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 13:24:31 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C639393DB
        for <stable@vger.kernel.org>; Fri,  8 Apr 2022 10:22:26 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED3631042;
        Fri,  8 Apr 2022 10:22:25 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B2CD3F5A1;
        Fri,  8 Apr 2022 10:22:25 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>, Will Deacon <will@kernel.org>
Subject: [stable:PATCH v5.4.188] KVM: arm64: Check arm64_get_bp_hardening_data() didn't return NULL
Date:   Fri,  8 Apr 2022 18:22:19 +0100
Message-Id: <20220408172219.4152131-1-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Will reports that with CONFIG_EXPERT=y and CONFIG_HARDEN_BRANCH_PREDICTOR=n,
the kernel dereferences a NULL pointer during boot:

[    2.384444] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[    2.384461] pstate: 20400085 (nzCv daIf +PAN -UAO)
[    2.384472] pc : cpu_hyp_reinit+0x114/0x30c
[    2.384476] lr : cpu_hyp_reinit+0x80/0x30c

[    2.384529] Call trace:
[    2.384533]  cpu_hyp_reinit+0x114/0x30c
[    2.384537]  _kvm_arch_hardware_enable+0x30/0x54
[    2.384541]  flush_smp_call_function_queue+0xe4/0x154
[    2.384544]  generic_smp_call_function_single_interrupt+0x10/0x18
[    2.384549]  ipi_handler+0x170/0x2b0
[    2.384555]  handle_percpu_devid_fasteoi_ipi+0x120/0x1cc
[    2.384560]  __handle_domain_irq+0x9c/0xf4
[    2.384563]  gic_handle_irq+0x6c/0xe4
[    2.384566]  el1_irq+0xf0/0x1c0
[    2.384570]  arch_cpu_idle+0x28/0x44
[    2.384574]  do_idle+0x100/0x2a8
[    2.384577]  cpu_startup_entry+0x20/0x24
[    2.384581]  secondary_start_kernel+0x1b0/0x1cc
[    2.384589] Code: b9469d08 7100011f 540003ad 52800208 (f9400108)
[    2.384600] ---[ end trace 266d08dbf96ff143 ]---
[    2.385171] Kernel panic - not syncing: Fatal exception in interrupt

In this configuration arm64_get_bp_hardening_data() returns NULL.
Add a check in kvm_get_hyp_vector().

Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/linux-arm-kernel/20220408120041.GB27685@willie-the-truck/
Fixes: 26129ea2953b ("KVM: arm64: Add templates for BHB mitigation sequences")
Cc: stable@vger.kernel.org # 5.4.x
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 78d110667c0c..ffe0aad96b17 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -479,7 +479,8 @@ static inline void *kvm_get_hyp_vector(void)
 	int slot = -1;
 
 	if ((cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) ||
-	     cpus_have_const_cap(ARM64_SPECTRE_BHB)) && data->template_start) {
+	     cpus_have_const_cap(ARM64_SPECTRE_BHB)) &&
+	    data && data->template_start) {
 		vect = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs_start));
 		slot = data->hyp_vectors_slot;
 	}
-- 
2.30.2


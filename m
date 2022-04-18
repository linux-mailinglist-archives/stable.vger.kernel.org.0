Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE4150514E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238893AbiDRMcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239001AbiDRMb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:31:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C862625288;
        Mon, 18 Apr 2022 05:24:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0F8C3CE10A0;
        Mon, 18 Apr 2022 12:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2A7C385A9;
        Mon, 18 Apr 2022 12:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284637;
        bh=uS/GY6ExnjhPYx2j4Wl+qD9StA6nkkAyHB9DsmGkl2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FqXqpi6cB/dVrA1tOVba0YrH5VI2VaqugJ7oUzbSAWlVPHV9lZKFkZ6eZnFmUekNC
         VBrSI3qBvv4QiTh3I7tDiEylyXyXaMIQjZMSBHJPQs0dfEVnyXGLDfnOT4asKHh1ib
         rLmRFeOU/OTY/XOKGCaZQeBMBaoomVk/Iga3WwEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 129/219] KVM: PPC: Book3S HV P9: Fix "lost kick" race
Date:   Mon, 18 Apr 2022 14:11:38 +0200
Message-Id: <20220418121210.507201101@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit c7fa848ff01dad9ed3146a6b1a7d3622131bcedd ]

When new work is created that requires attention from the hypervisor
(e.g., to inject an interrupt into the guest), fast_vcpu_kick is used to
pull the target vcpu out of the guest if it may have been running.

Therefore the work creation side looks like this:

  vcpu->arch.doorbell_request = 1;
  kvmppc_fast_vcpu_kick_hv(vcpu) {
    smp_mb();
    cpu = vcpu->cpu;
    if (cpu != -1)
        send_ipi(cpu);
  }

And the guest entry side *should* look like this:

  vcpu->cpu = smp_processor_id();
  smp_mb();
  if (vcpu->arch.doorbell_request) {
    // do something (abort entry or inject doorbell etc)
  }

But currently the store and load are flipped, so it is possible for the
entry to see no doorbell pending, and the doorbell creation misses the
store to set cpu, resulting lost work (or at least delayed until the
next guest exit).

Fix this by reordering the entry operations and adding a smp_mb
between them. The P8 path appears to have a similar race which is
commented but not addressed yet.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220303053315.1056880-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 41 +++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 791db769080d..316f61a4cb59 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -225,6 +225,13 @@ static void kvmppc_fast_vcpu_kick_hv(struct kvm_vcpu *vcpu)
 	int cpu;
 	struct rcuwait *waitp;
 
+	/*
+	 * rcuwait_wake_up contains smp_mb() which orders prior stores that
+	 * create pending work vs below loads of cpu fields. The other side
+	 * is the barrier in vcpu run that orders setting the cpu fields vs
+	 * testing for pending work.
+	 */
+
 	waitp = kvm_arch_vcpu_get_wait(vcpu);
 	if (rcuwait_wake_up(waitp))
 		++vcpu->stat.generic.halt_wakeup;
@@ -1089,7 +1096,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 			break;
 		}
 		tvcpu->arch.prodded = 1;
-		smp_mb();
+		smp_mb(); /* This orders prodded store vs ceded load */
 		if (tvcpu->arch.ceded)
 			kvmppc_fast_vcpu_kick_hv(tvcpu);
 		break;
@@ -3771,6 +3778,14 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 		pvc = core_info.vc[sub];
 		pvc->pcpu = pcpu + thr;
 		for_each_runnable_thread(i, vcpu, pvc) {
+			/*
+			 * XXX: is kvmppc_start_thread called too late here?
+			 * It updates vcpu->cpu and vcpu->arch.thread_cpu
+			 * which are used by kvmppc_fast_vcpu_kick_hv(), but
+			 * kick is called after new exceptions become available
+			 * and exceptions are checked earlier than here, by
+			 * kvmppc_core_prepare_to_enter.
+			 */
 			kvmppc_start_thread(vcpu, pvc);
 			kvmppc_create_dtl_entry(vcpu, pvc);
 			trace_kvm_guest_enter(vcpu);
@@ -4492,6 +4507,21 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (need_resched() || !kvm->arch.mmu_ready)
 		goto out;
 
+	vcpu->cpu = pcpu;
+	vcpu->arch.thread_cpu = pcpu;
+	vc->pcpu = pcpu;
+	local_paca->kvm_hstate.kvm_vcpu = vcpu;
+	local_paca->kvm_hstate.ptid = 0;
+	local_paca->kvm_hstate.fake_suspend = 0;
+
+	/*
+	 * Orders set cpu/thread_cpu vs testing for pending interrupts and
+	 * doorbells below. The other side is when these fields are set vs
+	 * kvmppc_fast_vcpu_kick_hv reading the cpu/thread_cpu fields to
+	 * kick a vCPU to notice the pending interrupt.
+	 */
+	smp_mb();
+
 	if (!nested) {
 		kvmppc_core_prepare_to_enter(vcpu);
 		if (test_bit(BOOK3S_IRQPRIO_EXTERNAL,
@@ -4511,13 +4541,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	tb = mftb();
 
-	vcpu->cpu = pcpu;
-	vcpu->arch.thread_cpu = pcpu;
-	vc->pcpu = pcpu;
-	local_paca->kvm_hstate.kvm_vcpu = vcpu;
-	local_paca->kvm_hstate.ptid = 0;
-	local_paca->kvm_hstate.fake_suspend = 0;
-
 	__kvmppc_create_dtl_entry(vcpu, pcpu, tb + vc->tb_offset, 0);
 
 	trace_kvm_guest_enter(vcpu);
@@ -4619,6 +4642,8 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	run->exit_reason = KVM_EXIT_INTR;
 	vcpu->arch.ret = -EINTR;
  out:
+	vcpu->cpu = -1;
+	vcpu->arch.thread_cpu = -1;
 	powerpc_local_irq_pmu_restore(flags);
 	preempt_enable();
 	goto done;
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E841615863
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiKBCvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiKBCvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:51:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD26F21E05
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:51:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67CFFB82077
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4054DC433D6;
        Wed,  2 Nov 2022 02:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357461;
        bh=N4ahiQRFXxVftQoDrX2puPRcqc1lykzJo2dePMMxvv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N25XM4GOEHgywuzD2xUBc+RVTXl4+/zgOa/blx/4FDgmPb5gn9vdWpZFwnFtrKSZD
         WLzHY7tL/19mTomoRxqaNAqp3uCXh9HODwo5wOkPG+UdSBLGWHr/Ag/RnEL1gU1x3/
         96xLMqNqyhYUkyYPYiHYafv6DcfjnuewBdjojczo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anup Patel <apatel@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 173/240] RISC-V: KVM: Fix kvm_riscv_vcpu_timer_pending() for Sstc
Date:   Wed,  2 Nov 2022 03:32:28 +0100
Message-Id: <20221102022115.298920791@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit cea8896bd936135559253e9b23340cfa1cdf0caf ]

The kvm_riscv_vcpu_timer_pending() checks per-VCPU next_cycles
and per-VCPU software injected VS timer interrupt. This function
returns incorrect value when Sstc is available because the per-VCPU
next_cycles are only updated by kvm_riscv_vcpu_timer_save() called
from kvm_arch_vcpu_put(). As a result, when Sstc is available the
VCPU does not block properly upon WFI traps.

To fix the above issue, we introduce kvm_riscv_vcpu_timer_sync()
which will update per-VCPU next_cycles upon every VM exit instead
of kvm_riscv_vcpu_timer_save().

Fixes: 8f5cb44b1bae ("RISC-V: KVM: Support sstc extension")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/kvm_vcpu_timer.h |  1 +
 arch/riscv/kvm/vcpu.c                   |  3 +++
 arch/riscv/kvm/vcpu_timer.c             | 17 +++++++++++++++--
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/arch/riscv/include/asm/kvm_vcpu_timer.h
index 0d8fdb8ec63a..82f7260301da 100644
--- a/arch/riscv/include/asm/kvm_vcpu_timer.h
+++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
@@ -45,6 +45,7 @@ int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu);
 int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu);
 void kvm_riscv_guest_timer_init(struct kvm *kvm);
+void kvm_riscv_vcpu_timer_sync(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu);
 bool kvm_riscv_vcpu_timer_pending(struct kvm_vcpu *vcpu);
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 2ef33d5d94d1..f692c0716aa7 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -698,6 +698,9 @@ void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
 				clear_bit(IRQ_VS_SOFT, &v->irqs_pending);
 		}
 	}
+
+	/* Sync-up timer CSRs */
+	kvm_riscv_vcpu_timer_sync(vcpu);
 }
 
 int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
index 185f2386a747..ad34519c8a13 100644
--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -320,20 +320,33 @@ void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
 	kvm_riscv_vcpu_timer_unblocking(vcpu);
 }
 
-void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu)
+void kvm_riscv_vcpu_timer_sync(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
 
 	if (!t->sstc_enabled)
 		return;
 
-	t = &vcpu->arch.timer;
 #if defined(CONFIG_32BIT)
 	t->next_cycles = csr_read(CSR_VSTIMECMP);
 	t->next_cycles |= (u64)csr_read(CSR_VSTIMECMPH) << 32;
 #else
 	t->next_cycles = csr_read(CSR_VSTIMECMP);
 #endif
+}
+
+void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+
+	if (!t->sstc_enabled)
+		return;
+
+	/*
+	 * The vstimecmp CSRs are saved by kvm_riscv_vcpu_timer_sync()
+	 * upon every VM exit so no need to save here.
+	 */
+
 	/* timer should be enabled for the remaining operations */
 	if (unlikely(!t->init_done))
 		return;
-- 
2.35.1




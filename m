Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789246BB14F
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjCOM0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbjCOM0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:26:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DA92B294
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:25:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5433761CC2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B93C433EF;
        Wed, 15 Mar 2023 12:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883108;
        bh=jhSr8Ico+e2s/ufKO8FrT4eYW1o8tfob03bl2PEQbog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lAR0+W/c0EXpaNeaiu7eKb5Z2w1I2iQ7BYrVOfUG1R9e6N+boO0t/DvL6S/Ch9yII
         a93zhyOGyplfg8Q12Nmuu83Mztxgd72q3hNFOLOG7KysLrCSY3Az5GHRSkr+Vz7bg6
         SF2SVkm1ItVJIwi0s1s5tA4lCcij5+6afHGOGfE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/145] KVM: SVM: Dont rewrite guest ICR on AVIC IPI virtualization failure
Date:   Wed, 15 Mar 2023 13:11:25 +0100
Message-Id: <20230315115739.641357455@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit b51818afdc1d3c7cc269e295953685558d3af71c ]

Don't bother rewriting the ICR value into the vAPIC page on an AVIC IPI
virtualization failure, the access is a trap, i.e. the value has already
been written to the vAPIC page.  The one caveat is if hardware left the
BUSY flag set (which appears to happen somewhat arbitrarily), in which
case go through the "nodecode" APIC-write path in order to clear the BUSY
flag.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220204214205.3306634-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 5aede752a839 ("KVM: SVM: Process ICR on AVIC IPI delivery failure due to invalid target")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c    |  1 +
 arch/x86/kvm/svm/avic.c | 22 +++++++++++-----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 25530a908b4cd..8c9e41ff2a24e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1295,6 +1295,7 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 
 	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq, NULL);
 }
+EXPORT_SYMBOL_GPL(kvm_apic_send_ipi);
 
 static u32 apic_get_tmcct(struct kvm_lapic *apic)
 {
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3d3f8dfb80457..52778be77713f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -320,18 +320,18 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	switch (id) {
 	case AVIC_IPI_FAILURE_INVALID_INT_TYPE:
 		/*
-		 * AVIC hardware handles the generation of
-		 * IPIs when the specified Message Type is Fixed
-		 * (also known as fixed delivery mode) and
-		 * the Trigger Mode is edge-triggered. The hardware
-		 * also supports self and broadcast delivery modes
-		 * specified via the Destination Shorthand(DSH)
-		 * field of the ICRL. Logical and physical APIC ID
-		 * formats are supported. All other IPI types cause
-		 * a #VMEXIT, which needs to emulated.
+		 * Emulate IPIs that are not handled by AVIC hardware, which
+		 * only virtualizes Fixed, Edge-Triggered INTRs.  The exit is
+		 * a trap, e.g. ICR holds the correct value and RIP has been
+		 * advanced, KVM is responsible only for emulating the IPI.
+		 * Sadly, hardware may sometimes leave the BUSY flag set, in
+		 * which case KVM needs to emulate the ICR write as well in
+		 * order to clear the BUSY flag.
 		 */
-		kvm_lapic_reg_write(apic, APIC_ICR2, icrh);
-		kvm_lapic_reg_write(apic, APIC_ICR, icrl);
+		if (icrl & APIC_ICR_BUSY)
+			kvm_apic_write_nodecode(vcpu, APIC_ICR);
+		else
+			kvm_apic_send_ipi(apic, icrl, icrh);
 		break;
 	case AVIC_IPI_FAILURE_TARGET_NOT_RUNNING:
 		/*
-- 
2.39.2




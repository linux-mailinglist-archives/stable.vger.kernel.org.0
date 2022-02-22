Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02DB4BFA3A
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 15:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbiBVOF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 09:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbiBVOF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 09:05:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B4C15F350;
        Tue, 22 Feb 2022 06:05:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B163E61469;
        Tue, 22 Feb 2022 14:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0142CC340F3;
        Tue, 22 Feb 2022 14:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645538727;
        bh=gwDtnCB8Q5QpjfMTbGstN8T2rnqahqyM8YAzCgA2Gok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4uB7Hbq9xDAWNRqzdeIJUcrez4mJ+lCITrFP5irvbJqCHGzfNa7vR3dLoxHybSk2
         j0N7m5zkJy1ZSMFRSM5DIunXVWqtQzcokSExkhLRof8W33DNoI7sY0wmQFLJCnsv1+
         BW+QZQWSysnV2yVkkia0Apm7+kPhGhYMe83bML/zP1h5QSWzhx0srWZepLMhVcpzpK
         D4L/008600fGoaIm8CXq4n8fjocFxoYIgoKBpnlJTRFOcdvB9zlvKpvVHtT7MkLA+L
         gKdaesDmiT6+EHQHki4RBMBIv1WZxEKL0uguVJrekxsY9sepxcgUpqugxIPh2jZ0V0
         EuYO7lRQM0x1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.16 2/2] KVM: x86: nSVM: deal with L1 hypervisor that intercepts interrupts but lets L2 control them
Date:   Tue, 22 Feb 2022 09:05:22 -0500
Message-Id: <20220222140522.211548-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220222140522.211548-1-sashal@kernel.org>
References: <20220222140522.211548-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 2b0ecccb55310a4b8ad5d59c703cf8c821be6260 ]

Fix a corner case in which the L1 hypervisor intercepts
interrupts (INTERCEPT_INTR) and either doesn't set
virtual interrupt masking (V_INTR_MASKING) or enters a
nested guest with EFLAGS.IF disabled prior to the entry.

In this case, despite the fact that L1 intercepts the interrupts,
KVM still needs to set up an interrupt window to wait before
injecting the INTR vmexit.

Currently the KVM instead enters an endless loop of 'req_immediate_exit'.

Exactly the same issue also happens for SMIs and NMI.
Fix this as well.

Note that on VMX, this case is impossible as there is only
'vmexit on external interrupts' execution control which either set,
in which case both host and guest's EFLAGS.IF
are ignored, or not set, in which case no VMexits are delivered.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20220207155447.840194-8-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d6a4acaa65742..2503c99cfde3f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3548,11 +3548,13 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	if (svm->nested.nested_run_pending)
 		return -EBUSY;
 
+	if (svm_nmi_blocked(vcpu))
+		return 0;
+
 	/* An NMI must not be injected into L2 if it's supposed to VM-Exit.  */
 	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
 		return -EBUSY;
-
-	return !svm_nmi_blocked(vcpu);
+	return 1;
 }
 
 static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
@@ -3604,9 +3606,13 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+
 	if (svm->nested.nested_run_pending)
 		return -EBUSY;
 
+	if (svm_interrupt_blocked(vcpu))
+		return 0;
+
 	/*
 	 * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
 	 * e.g. if the IRQ arrived asynchronously after checking nested events.
@@ -3614,7 +3620,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_intr(svm))
 		return -EBUSY;
 
-	return !svm_interrupt_blocked(vcpu);
+	return 1;
 }
 
 static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
@@ -4343,11 +4349,14 @@ static int svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	if (svm->nested.nested_run_pending)
 		return -EBUSY;
 
+	if (svm_smi_blocked(vcpu))
+		return 0;
+
 	/* An SMI must not be injected into L2 if it's supposed to VM-Exit.  */
 	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_smi(svm))
 		return -EBUSY;
 
-	return !svm_smi_blocked(vcpu);
+	return 1;
 }
 
 static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
-- 
2.34.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B26541C53
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382349AbiFGV6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383254AbiFGVw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9432431B5;
        Tue,  7 Jun 2022 12:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DF83617D0;
        Tue,  7 Jun 2022 19:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36F4C385A2;
        Tue,  7 Jun 2022 19:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629053;
        bh=AzSQQ4H4Mrme11i7o52lXm5HC7I8+aK7VWVLQ20FzfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDMaADy0RdmvcOlfdXYrGl1D40KMqs2dSampeECN6EyXUp7t4XE/Wr7b40IcZkaE5
         KRx1i3KqInknziX7TDS3q1yVJoLjpikFznVEw1wSB9fe8lCEj7CF9dIB4qxMwE7+iy
         G/FwGny8N3pm0Z+w56GA27lTDk9VxxINsbrkVnTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 553/879] KVM: nVMX: Clear IDT vectoring on nested VM-Exit for double/triple fault
Date:   Tue,  7 Jun 2022 19:01:11 +0200
Message-Id: <20220607165018.918503733@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 9bd1f0efa859b61950d109b32ff8d529cc33a3ad ]

Clear the IDT vectoring field in vmcs12 on next VM-Exit due to a double
or triple fault.  Per the SDM, a VM-Exit isn't considered to occur during
event delivery if the exit is due to an intercepted double fault or a
triple fault.  Opportunistically move the default clearing (no event
"pending") into the helper so that it's more obvious that KVM does indeed
handle this case.

Note, the double fault case is worded rather wierdly in the SDM:

  The original event results in a double-fault exception that causes the
  VM exit directly.

Temporarily ignoring injected events, double faults can _only_ occur if
an exception occurs while attempting to deliver a different exception,
i.e. there's _always_ an original event.  And for injected double fault,
while there's no original event, injected events are never subject to
interception.

Presumably the SDM is calling out that a the vectoring info will be valid
if a different exit occurs after a double fault, e.g. if a #PF occurs and
is intercepted while vectoring #DF, then the vectoring info will show the
double fault.  In other words, the clause can simply be read as:

  The VM exit is caused by a double-fault exception.

Fixes: 4704d0befb07 ("KVM: nVMX: Exiting from L2 to L1")
Cc: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220407002315.78092-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 32 ++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmcs.h   |  5 +++++
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index afaddd43a6c0..ee7df31883cd 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3695,12 +3695,34 @@ vmcs12_guest_cr4(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 }
 
 static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
-				      struct vmcs12 *vmcs12)
+				      struct vmcs12 *vmcs12,
+				      u32 vm_exit_reason, u32 exit_intr_info)
 {
 	u32 idt_vectoring;
 	unsigned int nr;
 
-	if (vcpu->arch.exception.injected) {
+	/*
+	 * Per the SDM, VM-Exits due to double and triple faults are never
+	 * considered to occur during event delivery, even if the double/triple
+	 * fault is the result of an escalating vectoring issue.
+	 *
+	 * Note, the SDM qualifies the double fault behavior with "The original
+	 * event results in a double-fault exception".  It's unclear why the
+	 * qualification exists since exits due to double fault can occur only
+	 * while vectoring a different exception (injected events are never
+	 * subject to interception), i.e. there's _always_ an original event.
+	 *
+	 * The SDM also uses NMI as a confusing example for the "original event
+	 * causes the VM exit directly" clause.  NMI isn't special in any way,
+	 * the same rule applies to all events that cause an exit directly.
+	 * NMI is an odd choice for the example because NMIs can only occur on
+	 * instruction boundaries, i.e. they _can't_ occur during vectoring.
+	 */
+	if ((u16)vm_exit_reason == EXIT_REASON_TRIPLE_FAULT ||
+	    ((u16)vm_exit_reason == EXIT_REASON_EXCEPTION_NMI &&
+	     is_double_fault(exit_intr_info))) {
+		vmcs12->idt_vectoring_info_field = 0;
+	} else if (vcpu->arch.exception.injected) {
 		nr = vcpu->arch.exception.nr;
 		idt_vectoring = nr | VECTORING_INFO_VALID_MASK;
 
@@ -3733,6 +3755,8 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
 			idt_vectoring |= INTR_TYPE_EXT_INTR;
 
 		vmcs12->idt_vectoring_info_field = idt_vectoring;
+	} else {
+		vmcs12->idt_vectoring_info_field = 0;
 	}
 }
 
@@ -4219,8 +4243,8 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		 * Transfer the event that L0 or L1 may wanted to inject into
 		 * L2 to IDT_VECTORING_INFO_FIELD.
 		 */
-		vmcs12->idt_vectoring_info_field = 0;
-		vmcs12_save_pending_event(vcpu, vmcs12);
+		vmcs12_save_pending_event(vcpu, vmcs12,
+					  vm_exit_reason, exit_intr_info);
 
 		vmcs12->vm_exit_intr_info = exit_intr_info;
 		vmcs12->vm_exit_instruction_len = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index e325c290a816..2b9d7a7e83f7 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -104,6 +104,11 @@ static inline bool is_breakpoint(u32 intr_info)
 	return is_exception_n(intr_info, BP_VECTOR);
 }
 
+static inline bool is_double_fault(u32 intr_info)
+{
+	return is_exception_n(intr_info, DF_VECTOR);
+}
+
 static inline bool is_page_fault(u32 intr_info)
 {
 	return is_exception_n(intr_info, PF_VECTOR);
-- 
2.35.1




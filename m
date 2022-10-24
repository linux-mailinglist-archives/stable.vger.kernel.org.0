Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D7B60A6DA
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiJXMko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234249AbiJXMjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:39:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02778A7CB;
        Mon, 24 Oct 2022 05:07:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 826DD61218;
        Mon, 24 Oct 2022 12:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FFCC433D6;
        Mon, 24 Oct 2022 12:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613222;
        bh=eS/afclanA9Sgmy7PVNXgX/5pYFFrMUi897ywUNNzFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLZQNHOuUVTpOg2nXBZalZ8W34oa8VndzFsdlVmmtv0sXK5GBcUJH81NbHoQKrVTo
         rdzSRVgNzfl13N8w/UaiSRORzpGhiBekg34lZlyWiN9adK68lOuSg7UJWmiiZFqbWq
         zQXsyReEDgJk/239fG4Hyl6OWW6buHwz/JsEjGvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 053/255] KVM: nVMX: Unconditionally purge queued/injected events on nested "exit"
Date:   Mon, 24 Oct 2022 13:29:23 +0200
Message-Id: <20221024113004.183945639@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit d953540430c5af57f5de97ea9e36253908204027 upstream.

Drop pending exceptions and events queued for re-injection when leaving
nested guest mode, even if the "exit" is due to VM-Fail, SMI, or forced
by host userspace.  Failure to purge events could result in an event
belonging to L2 being injected into L1.

This _should_ never happen for VM-Fail as all events should be blocked by
nested_run_pending, but it's possible if KVM, not the L1 hypervisor, is
the source of VM-Fail when running vmcs02.

SMI is a nop (barring unknown bugs) as recognition of SMI and thus entry
to SMM is blocked by pending exceptions and re-injected events.

Forced exit is definitely buggy, but has likely gone unnoticed because
userspace probably follows the forced exit with KVM_SET_VCPU_EVENTS (or
some other ioctl() that purges the queue).

Fixes: 4f350c6dbcb9 ("kvm: nVMX: Handle deferred early VMLAUNCH/VMRESUME failure properly")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20220830231614.3580124-2-seanjc@google.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3762,14 +3762,6 @@ static void prepare_vmcs12(struct kvm_vc
 			nested_vmx_abort(vcpu,
 					 VMX_ABORT_SAVE_GUEST_MSR_FAIL);
 	}
-
-	/*
-	 * Drop what we picked up for L2 via vmx_complete_interrupts. It is
-	 * preserved above and would only end up incorrectly in L1.
-	 */
-	vcpu->arch.nmi_injected = false;
-	kvm_clear_exception_queue(vcpu);
-	kvm_clear_interrupt_queue(vcpu);
 }
 
 /*
@@ -4104,6 +4096,17 @@ void nested_vmx_vmexit(struct kvm_vcpu *
 		WARN_ON_ONCE(nested_early_check);
 	}
 
+	/*
+	 * Drop events/exceptions that were queued for re-injection to L2
+	 * (picked up via vmx_complete_interrupts()), as well as exceptions
+	 * that were pending for L2.  Note, this must NOT be hoisted above
+	 * prepare_vmcs12(), events/exceptions queued for re-injection need to
+	 * be captured in vmcs12 (see vmcs12_save_pending_event()).
+	 */
+	vcpu->arch.nmi_injected = false;
+	kvm_clear_exception_queue(vcpu);
+	kvm_clear_interrupt_queue(vcpu);
+
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
 	/* Update any VMCS fields that might have changed while L2 ran */



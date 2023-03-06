Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508626AC9C8
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 18:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjCFRWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 12:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjCFRWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 12:22:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227DD67022
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 09:22:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDDB2B80FE9
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 17:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239C1C433A7;
        Mon,  6 Mar 2023 17:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678123342;
        bh=/bQvRC8srTSFETJJEdnD0FaErCFEAyk0vpDgRWrOEiU=;
        h=Subject:To:Cc:From:Date:From;
        b=fwa0QaD7jc6BwfDIPsSh1wGhmIMAB3xOKcpr+8bj/t8e7gHk/t6Y1zD+Ogb2Q9xng
         OVSPd2UxG1uTsyIzYDS3+qikyqRwDKhF7bR6TuKexOQVz5Y67OlyyfeSTn8pV+gpAx
         x7HlWQI4nKoBRUKODpgXO5QKeEDSSBcNmut+gmwE=
Subject: FAILED: patch "[PATCH] KVM: x86: Purge "highest ISR" cache when updating APICv state" failed to apply to 5.15-stable tree
To:     seanjc@google.com, mlevitsk@redhat.com, pbonzini@redhat.com,
        suravee.suthikulpanit@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 18:22:19 +0100
Message-ID: <167812333979118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 97a71c444a147ae41c7d0ab5b3d855d7f762f3ed
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167812333979118@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

97a71c444a14 ("KVM: x86: Purge "highest ISR" cache when updating APICv state")
ce0a58f4756c ("KVM: x86: Move "apicv_active" into "struct kvm_lapic"")
d39850f57d21 ("KVM: x86: Drop @vcpu parameter from kvm_x86_ops.hwapic_isr_update()")
47e8eec83262 ("Merge tag 'kvmarm-5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 97a71c444a147ae41c7d0ab5b3d855d7f762f3ed Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 6 Jan 2023 01:12:35 +0000
Subject: [PATCH] KVM: x86: Purge "highest ISR" cache when updating APICv state

Purge the "highest ISR" cache when updating APICv state on a vCPU.  The
cache must not be used when APICv is active as hardware may emulate EOIs
(and other operations) without exiting to KVM.

This fixes a bug where KVM will effectively block IRQs in perpetuity due
to the "highest ISR" never getting reset if APICv is activated on a vCPU
while an IRQ is in-service.  Hardware emulates the EOI and KVM never gets
a chance to update its cache.

Fixes: b26a695a1d78 ("kvm: lapic: Introduce APICv update helper function")
Cc: stable@vger.kernel.org
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230106011306.85230-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5c0f93fc073a..33a661d82da7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2424,6 +2424,7 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 		 */
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
 	}
+	apic->highest_isr_cache = -1;
 }
 
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -2479,7 +2480,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
 	}
 	kvm_apic_update_apicv(vcpu);
-	apic->highest_isr_cache = -1;
 	update_divide_count(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
 
@@ -2767,7 +2767,6 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	__start_apic_timer(apic, APIC_TMCCT);
 	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
 	kvm_apic_update_apicv(vcpu);
-	apic->highest_isr_cache = -1;
 	if (apic->apicv_active) {
 		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));


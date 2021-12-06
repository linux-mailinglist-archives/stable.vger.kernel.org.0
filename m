Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651AB469EBC
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356657AbhLFPn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358481AbhLFPiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:38:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525D6C08EB1F;
        Mon,  6 Dec 2021 07:24:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1CF861327;
        Mon,  6 Dec 2021 15:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2406C341C1;
        Mon,  6 Dec 2021 15:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804245;
        bh=5xVY7rZWzkp3xZipLB87bE8evQOSLB5tgxQM19S5LS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oThZshp1Ii4HlZxAF4p9ra4yoQsLfjYATALHS+C0Z+82UHlm6QOA8feoYYcn8D6bx
         0/4oRTvz8o7dC1xhK0AFY5PD54QOlzq1MOamXTvr93/ARdBZckhc4g2oWujikBtPjZ
         8NiiHpDF/RPdp4rr4zUM4SQXFCPCGVlMoWhzPO1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 079/207] KVM: x86: Use a stable condition around all VT-d PI paths
Date:   Mon,  6 Dec 2021 15:55:33 +0100
Message-Id: <20211206145612.977978823@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 53b7ca1a359389276c76fbc9e1009d8626a17e40 upstream.

Currently, checks for whether VT-d PI can be used refer to the current
status of the feature in the current vCPU; or they more or less pick
vCPU 0 in case a specific vCPU is not available.

However, these checks do not attempt to synchronize with changes to
the IRTE.  In particular, there is no path that updates the IRTE when
APICv is re-activated on vCPU 0; and there is no path to wakeup a CPU
that has APICv disabled, if the wakeup occurs because of an IRTE
that points to a posted interrupt.

To fix this, always go through the VT-d PI path as long as there are
assigned devices and APICv is available on both the host and the VM side.
Since the relevant condition was copied over three times, take the hint
and factor it into a separate function.

Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Message-Id: <20211123004311.2954158-5-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/posted_intr.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -5,6 +5,7 @@
 #include <asm/cpu.h>
 
 #include "lapic.h"
+#include "irq.h"
 #include "posted_intr.h"
 #include "trace.h"
 #include "vmx.h"
@@ -77,13 +78,18 @@ after_clear_sn:
 		pi_set_on(pi_desc);
 }
 
+static bool vmx_can_use_vtd_pi(struct kvm *kvm)
+{
+	return irqchip_in_kernel(kvm) && enable_apicv &&
+		kvm_arch_has_assigned_device(kvm) &&
+		irq_remapping_cap(IRQ_POSTING_CAP);
+}
+
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
-		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
-		!kvm_vcpu_apicv_active(vcpu))
+	if (!vmx_can_use_vtd_pi(vcpu->kvm))
 		return;
 
 	/* Set SN when the vCPU is preempted */
@@ -141,9 +147,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	struct pi_desc old, new;
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
-		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
-		!kvm_vcpu_apicv_active(vcpu))
+	if (!vmx_can_use_vtd_pi(vcpu->kvm))
 		return 0;
 
 	WARN_ON(irqs_disabled());
@@ -270,9 +274,7 @@ int pi_update_irte(struct kvm *kvm, unsi
 	struct vcpu_data vcpu_info;
 	int idx, ret = 0;
 
-	if (!kvm_arch_has_assigned_device(kvm) ||
-	    !irq_remapping_cap(IRQ_POSTING_CAP) ||
-	    !kvm_vcpu_apicv_active(kvm->vcpus[0]))
+	if (!vmx_can_use_vtd_pi(kvm))
 		return 0;
 
 	idx = srcu_read_lock(&kvm->irq_srcu);



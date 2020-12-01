Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08E82C9CC9
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388448AbgLAJBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:01:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388451AbgLAJA6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:00:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53AD12222E;
        Tue,  1 Dec 2020 09:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813242;
        bh=L7HzEZ88G6dBsMzFNRYOsUCjKyC8875jRUI8wBcLnb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eq831x8fbClS2QpXOCidD46m5I36CeWAZR9J3va0RkA+fwNXRl6PJTfxL67z6fTyL
         u4dW76Gboirze8VVTJVCv1yTT+kIQKH40M848U25hCaRN91M5YdSs7YQDHiRKRMMPx
         EhPG+FMnqHS9tVEhs95hZv/JywvS6gyu8ZSDyEIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filippo Sironi <sironi@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 07/57] KVM: x86: handle !lapic_in_kernel case in kvm_cpu_*_extint
Date:   Tue,  1 Dec 2020 09:53:12 +0100
Message-Id: <20201201084648.575223209@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
References: <20201201084647.751612010@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 72c3bcdcda494cbd600712a32e67702cdee60c07 upstream.

Centralize handling of interrupts from the userspace APIC
in kvm_cpu_has_extint and kvm_cpu_get_extint, since
userspace APIC interrupts are handled more or less the
same as ExtINTs are with split irqchip.  This removes
duplicated code from kvm_cpu_has_injectable_intr and
kvm_cpu_has_interrupt, and makes the code more similar
between kvm_cpu_has_{extint,interrupt} on one side
and kvm_cpu_get_{extint,interrupt} on the other.

Cc: stable@vger.kernel.org
Reviewed-by: Filippo Sironi <sironi@amazon.de>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Tested-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/irq.c   |   83 ++++++++++++++++++++-------------------------------
 arch/x86/kvm/lapic.c |    2 -
 2 files changed, 34 insertions(+), 51 deletions(-)

--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -54,27 +54,8 @@ static int pending_userspace_extint(stru
  */
 static int kvm_cpu_has_extint(struct kvm_vcpu *v)
 {
-	u8 accept = kvm_apic_accept_pic_intr(v);
-
-	if (accept) {
-		if (irqchip_split(v->kvm))
-			return pending_userspace_extint(v);
-		else
-			return v->kvm->arch.vpic->output;
-	} else
-		return 0;
-}
-
-/*
- * check if there is injectable interrupt:
- * when virtual interrupt delivery enabled,
- * interrupt from apic will handled by hardware,
- * we don't need to check it here.
- */
-int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v)
-{
 	/*
-	 * FIXME: interrupt.injected represents an interrupt that it's
+	 * FIXME: interrupt.injected represents an interrupt whose
 	 * side-effects have already been applied (e.g. bit from IRR
 	 * already moved to ISR). Therefore, it is incorrect to rely
 	 * on interrupt.injected to know if there is a pending
@@ -87,6 +68,23 @@ int kvm_cpu_has_injectable_intr(struct k
 	if (!lapic_in_kernel(v))
 		return v->arch.interrupt.injected;
 
+	if (!kvm_apic_accept_pic_intr(v))
+		return 0;
+
+	if (irqchip_split(v->kvm))
+		return pending_userspace_extint(v);
+	else
+		return v->kvm->arch.vpic->output;
+}
+
+/*
+ * check if there is injectable interrupt:
+ * when virtual interrupt delivery enabled,
+ * interrupt from apic will handled by hardware,
+ * we don't need to check it here.
+ */
+int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v)
+{
 	if (kvm_cpu_has_extint(v))
 		return 1;
 
@@ -102,20 +100,6 @@ int kvm_cpu_has_injectable_intr(struct k
  */
 int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
 {
-	/*
-	 * FIXME: interrupt.injected represents an interrupt that it's
-	 * side-effects have already been applied (e.g. bit from IRR
-	 * already moved to ISR). Therefore, it is incorrect to rely
-	 * on interrupt.injected to know if there is a pending
-	 * interrupt in the user-mode LAPIC.
-	 * This leads to nVMX/nSVM not be able to distinguish
-	 * if it should exit from L2 to L1 on EXTERNAL_INTERRUPT on
-	 * pending interrupt or should re-inject an injected
-	 * interrupt.
-	 */
-	if (!lapic_in_kernel(v))
-		return v->arch.interrupt.injected;
-
 	if (kvm_cpu_has_extint(v))
 		return 1;
 
@@ -129,16 +113,21 @@ EXPORT_SYMBOL_GPL(kvm_cpu_has_interrupt)
  */
 static int kvm_cpu_get_extint(struct kvm_vcpu *v)
 {
-	if (kvm_cpu_has_extint(v)) {
-		if (irqchip_split(v->kvm)) {
-			int vector = v->arch.pending_external_vector;
-
-			v->arch.pending_external_vector = -1;
-			return vector;
-		} else
-			return kvm_pic_read_irq(v->kvm); /* PIC */
-	} else
+	if (!kvm_cpu_has_extint(v)) {
+		WARN_ON(!lapic_in_kernel(v));
 		return -1;
+	}
+
+	if (!lapic_in_kernel(v))
+		return v->arch.interrupt.nr;
+
+	if (irqchip_split(v->kvm)) {
+		int vector = v->arch.pending_external_vector;
+
+		v->arch.pending_external_vector = -1;
+		return vector;
+	} else
+		return kvm_pic_read_irq(v->kvm); /* PIC */
 }
 
 /*
@@ -146,13 +135,7 @@ static int kvm_cpu_get_extint(struct kvm
  */
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v)
 {
-	int vector;
-
-	if (!lapic_in_kernel(v))
-		return v->arch.interrupt.nr;
-
-	vector = kvm_cpu_get_extint(v);
-
+	int vector = kvm_cpu_get_extint(v);
 	if (vector != -1)
 		return vector;			/* PIC */
 
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2284,7 +2284,7 @@ int kvm_apic_has_interrupt(struct kvm_vc
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u32 ppr;
 
-	if (!kvm_apic_hw_enabled(apic))
+	if (!kvm_apic_present(vcpu))
 		return -1;
 
 	__apic_update_ppr(apic, &ppr);



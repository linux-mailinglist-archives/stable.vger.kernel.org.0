Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4572C9AF4
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387942AbgLAJDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:03:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729345AbgLAJDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:03:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BED8722264;
        Tue,  1 Dec 2020 09:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813368;
        bh=73iZqBC7mEvxr4JdJChNmLXTmzi7ExxnNto7nyBy2P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvU0g4HrrxrLvg2X+vu6xRj1iWgjwtqfRhA0drs9MCh4otwAse5rQqzp4Dzzhkw8e
         2m4r/uhLWEsINbHiI8boNMRGHpmo1AzDO/6cEThAHHQgDRCbKssEub4QEIXA1JLByI
         O/W6imJ+3gYKcPGq9FokyDw9Kr6VZ1Kcnd9g7Vhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filippo Sironi <sironi@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 16/98] KVM: x86: handle !lapic_in_kernel case in kvm_cpu_*_extint
Date:   Tue,  1 Dec 2020 09:52:53 +0100
Message-Id: <20201201084654.817193361@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
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
@@ -42,27 +42,8 @@ static int pending_userspace_extint(stru
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
@@ -75,6 +56,23 @@ int kvm_cpu_has_injectable_intr(struct k
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
 
@@ -90,20 +88,6 @@ int kvm_cpu_has_injectable_intr(struct k
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
 
@@ -117,16 +101,21 @@ EXPORT_SYMBOL_GPL(kvm_cpu_has_interrupt)
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
@@ -134,13 +123,7 @@ static int kvm_cpu_get_extint(struct kvm
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
@@ -2330,7 +2330,7 @@ int kvm_apic_has_interrupt(struct kvm_vc
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u32 ppr;
 
-	if (!kvm_apic_hw_enabled(apic))
+	if (!kvm_apic_present(vcpu))
 		return -1;
 
 	__apic_update_ppr(apic, &ppr);



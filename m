Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEEB4E68FC
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbfJ0VML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729412AbfJ0VMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:12:10 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41C1E205C9;
        Sun, 27 Oct 2019 21:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210729;
        bh=JAreu9up1yVNJdhyI5/epM/cklFUlC5i0JLQzb4RhBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2kfKxn7JV8S+nlDlnQjK7Hv6dfKaaLvvNG0smo8oWx3QpvCsVoI6z0cXVrmn1djOO
         aSUeXzQFpB9qgfoFxP9CFErtCzxO8s9QwuRo/Geivcbdow0LQVH5akpnvTmLviLQON
         +LPr44S3pcl08RvwL53xsQahRrvXY2StspumKUE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Jitindar SIngh, Suraj" <surajjs@amazon.com>
Subject: [PATCH 4.14 116/119] kvm: vmx: Introduce lapic_mode enumeration
Date:   Sun, 27 Oct 2019 22:01:33 +0100
Message-Id: <20191027203349.890737687@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

commit 588716494258899389206fa50426e78cc9df89b9 upstream.

The local APIC can be in one of three modes: disabled, xAPIC or
x2APIC. (A fourth mode, "invalid," is included for completeness.)

Using the new enumeration can make some of the APIC mode logic easier
to read. In kvm_set_apic_base, for instance, it is clear that one
cannot transition directly from x2APIC mode to xAPIC mode or directly
from APIC disabled to x2APIC mode.

Signed-off-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
[Check invalid bits even if msr_info->host_initiated.  Reported by
 Wanpeng Li. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Jitindar SIngh, Suraj" <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.h |   14 ++++++++++++++
 arch/x86/kvm/x86.c   |   26 +++++++++++++++-----------
 2 files changed, 29 insertions(+), 11 deletions(-)

--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -16,6 +16,13 @@
 #define APIC_BUS_CYCLE_NS       1
 #define APIC_BUS_FREQUENCY      (1000000000ULL / APIC_BUS_CYCLE_NS)
 
+enum lapic_mode {
+	LAPIC_MODE_DISABLED = 0,
+	LAPIC_MODE_INVALID = X2APIC_ENABLE,
+	LAPIC_MODE_XAPIC = MSR_IA32_APICBASE_ENABLE,
+	LAPIC_MODE_X2APIC = MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE,
+};
+
 struct kvm_timer {
 	struct hrtimer timer;
 	s64 period; 				/* unit: ns */
@@ -89,6 +96,7 @@ u64 kvm_get_apic_base(struct kvm_vcpu *v
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
+enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
@@ -220,4 +228,10 @@ void kvm_lapic_switch_to_hv_timer(struct
 void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
+
+static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
+{
+	return apic_base & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
+}
+
 #endif
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -306,23 +306,27 @@ u64 kvm_get_apic_base(struct kvm_vcpu *v
 }
 EXPORT_SYMBOL_GPL(kvm_get_apic_base);
 
+enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu)
+{
+	return kvm_apic_mode(kvm_get_apic_base(vcpu));
+}
+EXPORT_SYMBOL_GPL(kvm_get_apic_mode);
+
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
-	u64 old_state = vcpu->arch.apic_base &
-		(MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
-	u64 new_state = msr_info->data &
-		(MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
+	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
+	enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);
 	u64 reserved_bits = ((~0ULL) << cpuid_maxphyaddr(vcpu)) | 0x2ff |
 		(guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
 
-	if ((msr_info->data & reserved_bits) || new_state == X2APIC_ENABLE)
-		return 1;
-	if (!msr_info->host_initiated &&
-	    ((new_state == MSR_IA32_APICBASE_ENABLE &&
-	      old_state == (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) ||
-	     (new_state == (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE) &&
-	      old_state == 0)))
+	if ((msr_info->data & reserved_bits) != 0 || new_mode == LAPIC_MODE_INVALID)
 		return 1;
+	if (!msr_info->host_initiated) {
+		if (old_mode == LAPIC_MODE_X2APIC && new_mode == LAPIC_MODE_XAPIC)
+			return 1;
+		if (old_mode == LAPIC_MODE_DISABLED && new_mode == LAPIC_MODE_X2APIC)
+			return 1;
+	}
 
 	kvm_lapic_set_base(vcpu, msr_info->data);
 	return 0;



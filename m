Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D95C14F4E
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfEFOfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbfEFOfS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:35:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8007C2087F;
        Mon,  6 May 2019 14:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153317;
        bh=ZitR5/BoYXuDCm1WW/1vvlUXD4L1iVQmiQjSdIAw3jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBA6h9/PABMkL135D/Ua723+MJ7UJnj++cY2qjV22RXivl8sS7j2dHup8YJfzxwIM
         fnvwF9YjiCZyb6WG3cOUhPT9aIX20xWKIumjKK9qNtB4zZaO31gl69t7hkUSQdMWDo
         ncX0F4p3RtOmKXY1l/ACAnuoifA8syzdD7Ra+sBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.0 022/122] KVM: lapic: Track lapic timer advance per vCPU
Date:   Mon,  6 May 2019 16:31:20 +0200
Message-Id: <20190506143056.742867452@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 39497d7660d9866a47a2dc9055672358da57ad3d upstream.

Automatically adjusting the globally-shared timer advancement could
corrupt the timer, e.g. if multiple vCPUs are concurrently adjusting
the advancement value.  That could be partially fixed by using a local
variable for the arithmetic, but it would still be susceptible to a
race when setting timer_advance_adjust_done.

And because virtual_tsc_khz and tsc_scaling_ratio are per-vCPU, the
correct calibration for a given vCPU may not apply to all vCPUs.

Furthermore, lapic_timer_advance_ns is marked __read_mostly, which is
effectively violated when finding a stable advancement takes an extended
amount of timer.

Opportunistically change the definition of lapic_timer_advance_ns to
a u32 so that it matches the style of struct kvm_timer.  Explicitly
pass the param to kvm_create_lapic() so that it doesn't have to be
exposed to lapic.c, thus reducing the probability of unintentionally
using the global value instead of the per-vCPU value.

Cc: Liran Alon <liran.alon@oracle.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Cc: stable@vger.kernel.org
Fixes: 3b8a5df6c4dc6 ("KVM: LAPIC: Tune lapic_timer_advance_ns automatically")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.c   |   36 +++++++++++++++++++-----------------
 arch/x86/kvm/lapic.h   |    4 +++-
 arch/x86/kvm/vmx/vmx.c |    4 +++-
 arch/x86/kvm/x86.c     |    7 +++----
 arch/x86/kvm/x86.h     |    2 --
 5 files changed, 28 insertions(+), 25 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -70,7 +70,6 @@
 #define APIC_BROADCAST			0xFF
 #define X2APIC_BROADCAST		0xFFFFFFFFul
 
-static bool lapic_timer_advance_adjust_done = false;
 #define LAPIC_TIMER_ADVANCE_ADJUST_DONE 100
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
@@ -1482,6 +1481,7 @@ static bool lapic_timer_int_injected(str
 void wait_lapic_expire(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
+	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
 	u64 guest_tsc, tsc_deadline, ns;
 
 	if (!lapic_in_kernel(vcpu))
@@ -1501,34 +1501,36 @@ void wait_lapic_expire(struct kvm_vcpu *
 	/* __delay is delay_tsc whenever the hardware has TSC, thus always.  */
 	if (guest_tsc < tsc_deadline)
 		__delay(min(tsc_deadline - guest_tsc,
-			nsec_to_cycles(vcpu, lapic_timer_advance_ns)));
+			nsec_to_cycles(vcpu, timer_advance_ns)));
 
-	if (!lapic_timer_advance_adjust_done) {
+	if (!apic->lapic_timer.timer_advance_adjust_done) {
 		/* too early */
 		if (guest_tsc < tsc_deadline) {
 			ns = (tsc_deadline - guest_tsc) * 1000000ULL;
 			do_div(ns, vcpu->arch.virtual_tsc_khz);
-			lapic_timer_advance_ns -= min((unsigned int)ns,
-				lapic_timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+			timer_advance_ns -= min((u32)ns,
+				timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
 		} else {
 		/* too late */
 			ns = (guest_tsc - tsc_deadline) * 1000000ULL;
 			do_div(ns, vcpu->arch.virtual_tsc_khz);
-			lapic_timer_advance_ns += min((unsigned int)ns,
-				lapic_timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+			timer_advance_ns += min((u32)ns,
+				timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
 		}
 		if (abs(guest_tsc - tsc_deadline) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
-			lapic_timer_advance_adjust_done = true;
-		if (unlikely(lapic_timer_advance_ns > 5000)) {
-			lapic_timer_advance_ns = 0;
-			lapic_timer_advance_adjust_done = true;
+			apic->lapic_timer.timer_advance_adjust_done = true;
+		if (unlikely(timer_advance_ns > 5000)) {
+			timer_advance_ns = 0;
+			apic->lapic_timer.timer_advance_adjust_done = true;
 		}
+		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 	}
 }
 
 static void start_sw_tscdeadline(struct kvm_lapic *apic)
 {
-	u64 guest_tsc, tscdeadline = apic->lapic_timer.tscdeadline;
+	struct kvm_timer *ktimer = &apic->lapic_timer;
+	u64 guest_tsc, tscdeadline = ktimer->tscdeadline;
 	u64 ns = 0;
 	ktime_t expire;
 	struct kvm_vcpu *vcpu = apic->vcpu;
@@ -1548,11 +1550,10 @@ static void start_sw_tscdeadline(struct
 	do_div(ns, this_tsc_khz);
 
 	if (likely(tscdeadline > guest_tsc) &&
-	    likely(ns > lapic_timer_advance_ns)) {
+	    likely(ns > apic->lapic_timer.timer_advance_ns)) {
 		expire = ktime_add_ns(now, ns);
-		expire = ktime_sub_ns(expire, lapic_timer_advance_ns);
-		hrtimer_start(&apic->lapic_timer.timer,
-				expire, HRTIMER_MODE_ABS_PINNED);
+		expire = ktime_sub_ns(expire, ktimer->timer_advance_ns);
+		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS_PINNED);
 	} else
 		apic_timer_expired(apic);
 
@@ -2259,7 +2260,7 @@ static enum hrtimer_restart apic_timer_f
 		return HRTIMER_NORESTART;
 }
 
-int kvm_create_lapic(struct kvm_vcpu *vcpu)
+int kvm_create_lapic(struct kvm_vcpu *vcpu, u32 timer_advance_ns)
 {
 	struct kvm_lapic *apic;
 
@@ -2283,6 +2284,7 @@ int kvm_create_lapic(struct kvm_vcpu *vc
 	hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
 		     HRTIMER_MODE_ABS_PINNED);
 	apic->lapic_timer.timer.function = apic_timer_fn;
+	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 
 	/*
 	 * APIC is created enabled. This will prevent kvm_lapic_set_base from
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -31,8 +31,10 @@ struct kvm_timer {
 	u32 timer_mode_mask;
 	u64 tscdeadline;
 	u64 expired_tscdeadline;
+	u32 timer_advance_ns;
 	atomic_t pending;			/* accumulated triggered timers */
 	bool hv_timer_in_use;
+	bool timer_advance_adjust_done;
 };
 
 struct kvm_lapic {
@@ -62,7 +64,7 @@ struct kvm_lapic {
 
 struct dest_map;
 
-int kvm_create_lapic(struct kvm_vcpu *vcpu);
+int kvm_create_lapic(struct kvm_vcpu *vcpu, u32 timer_advance_ns);
 void kvm_free_lapic(struct kvm_vcpu *vcpu);
 
 int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7133,6 +7133,7 @@ static int vmx_set_hv_timer(struct kvm_v
 {
 	struct vcpu_vmx *vmx;
 	u64 tscl, guest_tscl, delta_tsc, lapic_timer_advance_cycles;
+	struct kvm_timer *ktimer = &vcpu->arch.apic->lapic_timer;
 
 	if (kvm_mwait_in_guest(vcpu->kvm))
 		return -EOPNOTSUPP;
@@ -7141,7 +7142,8 @@ static int vmx_set_hv_timer(struct kvm_v
 	tscl = rdtsc();
 	guest_tscl = kvm_read_l1_tsc(vcpu, tscl);
 	delta_tsc = max(guest_deadline_tsc, guest_tscl) - guest_tscl;
-	lapic_timer_advance_cycles = nsec_to_cycles(vcpu, lapic_timer_advance_ns);
+	lapic_timer_advance_cycles = nsec_to_cycles(vcpu,
+						    ktimer->timer_advance_ns);
 
 	if (delta_tsc > lapic_timer_advance_cycles)
 		delta_tsc -= lapic_timer_advance_cycles;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -137,9 +137,8 @@ static u32 __read_mostly tsc_tolerance_p
 module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
 
 /* lapic timer advance (tscdeadline mode only) in nanoseconds */
-unsigned int __read_mostly lapic_timer_advance_ns = 1000;
+static u32 __read_mostly lapic_timer_advance_ns = 1000;
 module_param(lapic_timer_advance_ns, uint, S_IRUGO | S_IWUSR);
-EXPORT_SYMBOL_GPL(lapic_timer_advance_ns);
 
 static bool __read_mostly vector_hashing = true;
 module_param(vector_hashing, bool, S_IRUGO);
@@ -7882,7 +7881,7 @@ static int vcpu_enter_guest(struct kvm_v
 	}
 
 	trace_kvm_entry(vcpu->vcpu_id);
-	if (lapic_timer_advance_ns)
+	if (vcpu->arch.apic->lapic_timer.timer_advance_ns)
 		wait_lapic_expire(vcpu);
 	guest_enter_irqoff();
 
@@ -9070,7 +9069,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *
 		goto fail_free_pio_data;
 
 	if (irqchip_in_kernel(vcpu->kvm)) {
-		r = kvm_create_lapic(vcpu);
+		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
 		if (r < 0)
 			goto fail_mmu_destroy;
 	} else
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -294,8 +294,6 @@ extern u64 kvm_supported_xcr0(void);
 
 extern unsigned int min_timer_period_us;
 
-extern unsigned int lapic_timer_advance_ns;
-
 extern bool enable_vmware_backdoor;
 
 extern struct static_key kvm_no_apic_vcpu;



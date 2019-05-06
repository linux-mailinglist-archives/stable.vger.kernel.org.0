Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08C1014F4D
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfEFPJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbfEFOfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:35:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A46C8214C6;
        Mon,  6 May 2019 14:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153322;
        bh=IhMrdxYw7BZjtqmi2BAZfg1TqFu9OA85yOul+YcPvms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTXK7weI1jQbPYNnIwe4QriaU2uaCoa+fMSGUGavj4yq+Z3k0n2RzeI1tLMU0FmLj
         UKdXO1YVWXw6ObZwX5rZz9SCLhvpXfzy4/FjphEzMrc9MpqhwHNsUK/d0oYzU9FLx6
         o9GvGX6FC5lHrrlrgwh9jtJkhQNT+0M5hCxpl1Cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.0 024/122] KVM: lapic: Convert guest TSC to host time domain if necessary
Date:   Mon,  6 May 2019 16:31:22 +0200
Message-Id: <20190506143056.922875731@linuxfoundation.org>
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

commit b6aa57c69cb26ea0160c51f7cf45f1af23542686 upstream.

To minimize the latency of timer interrupts as observed by the guest,
KVM adjusts the values it programs into the host timers to account for
the host's overhead of programming and handling the timer event.  In
the event that the adjustments are too aggressive, i.e. the timer fires
earlier than the guest expects, KVM busy waits immediately prior to
entering the guest.

Currently, KVM manually converts the delay from nanoseconds to clock
cycles.  But, the conversion is done in the guest's time domain, while
the delay occurs in the host's time domain.  This is perfectly ok when
the guest and host are using the same TSC ratio, but if the guest is
using a different ratio then the delay may not be accurate and could
wait too little or too long.

When the guest is not using the host's ratio, convert the delay from
guest clock cycles to host nanoseconds and use ndelay() instead of
__delay() to provide more accurate timing.  Because converting to
nanoseconds is relatively expensive, e.g. requires division and more
multiplication ops, continue using __delay() directly when guest and
host TSCs are running at the same ratio.

Cc: Liran Alon <liran.alon@oracle.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: stable@vger.kernel.org
Fixes: 3b8a5df6c4dc6 ("KVM: LAPIC: Tune lapic_timer_advance_ns automatically")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1478,6 +1478,26 @@ static bool lapic_timer_int_injected(str
 	return false;
 }
 
+static inline void __wait_lapic_expire(struct kvm_vcpu *vcpu, u64 guest_cycles)
+{
+	u64 timer_advance_ns = vcpu->arch.apic->lapic_timer.timer_advance_ns;
+
+	/*
+	 * If the guest TSC is running at a different ratio than the host, then
+	 * convert the delay to nanoseconds to achieve an accurate delay.  Note
+	 * that __delay() uses delay_tsc whenever the hardware has TSC, thus
+	 * always for VMX enabled hardware.
+	 */
+	if (vcpu->arch.tsc_scaling_ratio == kvm_default_tsc_scaling_ratio) {
+		__delay(min(guest_cycles,
+			nsec_to_cycles(vcpu, timer_advance_ns)));
+	} else {
+		u64 delay_ns = guest_cycles * 1000000ULL;
+		do_div(delay_ns, vcpu->arch.virtual_tsc_khz);
+		ndelay(min_t(u32, delay_ns, timer_advance_ns));
+	}
+}
+
 void wait_lapic_expire(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -1498,10 +1518,8 @@ void wait_lapic_expire(struct kvm_vcpu *
 	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
 	trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_deadline);
 
-	/* __delay is delay_tsc whenever the hardware has TSC, thus always.  */
 	if (guest_tsc < tsc_deadline)
-		__delay(min(tsc_deadline - guest_tsc,
-			nsec_to_cycles(vcpu, timer_advance_ns)));
+		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
 
 	if (!apic->lapic_timer.timer_advance_adjust_done) {
 		/* too early */



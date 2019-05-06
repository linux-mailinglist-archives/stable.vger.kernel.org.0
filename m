Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C750314C02
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfEFOfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbfEFOfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:35:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DF9C21019;
        Mon,  6 May 2019 14:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153319;
        bh=pnmmx/EzFnoIEvx4yU9Paj26Jn+qVnWXJinaZ5xxo4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2P3HPq+2bhN4cPsNByB/3I1v6nhfCBnXd/8XF/HMuM57wOZndL8yn4PXZ9Y6Fw+j1
         +GmwCynsea5Hnh97lul21PyiDRyYOm9SWmMbSRlA9HQh0bRO+xK4WQDmijKuCp/p/u
         jTbTTzdiX+9ybxTHdmmwUxPdMsECPLuIYlKwU5v4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.0 023/122] KVM: lapic: Allow user to disable adaptive tuning of timer advancement
Date:   Mon,  6 May 2019 16:31:21 +0200
Message-Id: <20190506143056.836498988@linuxfoundation.org>
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

commit c3941d9e0ccd48920e4811f133235b3597e5310b upstream.

The introduction of adaptive tuning of lapic timer advancement did not
allow for the scenario where userspace would want to disable adaptive
tuning but still employ timer advancement, e.g. for testing purposes or
to handle a use case where adaptive tuning is unable to settle on a
suitable time.  This is epecially pertinent now that KVM places a hard
threshold on the maximum advancment time.

Rework the timer semantics to accept signed values, with a value of '-1'
being interpreted as "use adaptive tuning with KVM's internal default",
and any other value being used as an explicit advancement time, e.g. a
time of '0' effectively disables advancement.

Note, this does not completely restore the original behavior of
lapic_timer_advance_ns.  Prior to tracking the advancement per vCPU,
which is necessary to support autotuning, userspace could adjust
lapic_timer_advance_ns for *running* vCPU.  With per-vCPU tracking, the
module params are snapshotted at vCPU creation, i.e. applying a new
advancement effectively requires restarting a VM.

Dynamically updating a running vCPU is possible, e.g. a helper could be
added to retrieve the desired delay, choosing between the global module
param and the per-VCPU value depending on whether or not auto-tuning is
(globally) enabled, but introduces a great deal of complexity.  The
wrapper itself is not complex, but understanding and documenting the
effects of dynamically toggling auto-tuning and/or adjusting the timer
advancement is nigh impossible since the behavior would be dependent on
KVM's implementation as well as compiler optimizations.  In other words,
providing stable behavior would require extremely careful consideration
now and in the future.

Given that the expected use of a manually-tuned timer advancement is to
"tune once, run many", use the vastly simpler approach of recognizing
changes to the module params only when creating a new vCPU.

Cc: Liran Alon <liran.alon@oracle.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Cc: stable@vger.kernel.org
Fixes: 3b8a5df6c4dc6 ("KVM: LAPIC: Tune lapic_timer_advance_ns automatically")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.c |   11 +++++++++--
 arch/x86/kvm/lapic.h |    2 +-
 arch/x86/kvm/x86.c   |    9 +++++++--
 3 files changed, 17 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2260,7 +2260,7 @@ static enum hrtimer_restart apic_timer_f
 		return HRTIMER_NORESTART;
 }
 
-int kvm_create_lapic(struct kvm_vcpu *vcpu, u32 timer_advance_ns)
+int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 {
 	struct kvm_lapic *apic;
 
@@ -2284,7 +2284,14 @@ int kvm_create_lapic(struct kvm_vcpu *vc
 	hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
 		     HRTIMER_MODE_ABS_PINNED);
 	apic->lapic_timer.timer.function = apic_timer_fn;
-	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
+	if (timer_advance_ns == -1) {
+		apic->lapic_timer.timer_advance_ns = 1000;
+		apic->lapic_timer.timer_advance_adjust_done = false;
+	} else {
+		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
+		apic->lapic_timer.timer_advance_adjust_done = true;
+	}
+
 
 	/*
 	 * APIC is created enabled. This will prevent kvm_lapic_set_base from
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -64,7 +64,7 @@ struct kvm_lapic {
 
 struct dest_map;
 
-int kvm_create_lapic(struct kvm_vcpu *vcpu, u32 timer_advance_ns);
+int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns);
 void kvm_free_lapic(struct kvm_vcpu *vcpu);
 
 int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -136,8 +136,13 @@ EXPORT_SYMBOL_GPL(kvm_default_tsc_scalin
 static u32 __read_mostly tsc_tolerance_ppm = 250;
 module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
 
-/* lapic timer advance (tscdeadline mode only) in nanoseconds */
-static u32 __read_mostly lapic_timer_advance_ns = 1000;
+/*
+ * lapic timer advance (tscdeadline mode only) in nanoseconds.  '-1' enables
+ * adaptive tuning starting from default advancment of 1000ns.  '0' disables
+ * advancement entirely.  Any other value is used as-is and disables adaptive
+ * tuning, i.e. allows priveleged userspace to set an exact advancement time.
+ */
+static int __read_mostly lapic_timer_advance_ns = -1;
 module_param(lapic_timer_advance_ns, uint, S_IRUGO | S_IWUSR);
 
 static bool __read_mostly vector_hashing = true;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 954C1157724
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgBJM56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:57:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:43130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729973AbgBJMlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:22 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7883720838;
        Mon, 10 Feb 2020 12:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338482;
        bh=nRKd9XL/nW2DITpoKyhzySLH2ADdGCmEwVeXiXLP8bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEya6RCpYktmdcfCHrUA1YVdnsM41F5ruMrbYWOOykpx9Y07n2RAHJZsDEZl/q+PW
         PbBz6TveiRds4zn9K+OAH902NldZGyovdJ6KeG9VR//C5XPtPt7aIlnRiIuIOPa5hW
         rAX1ZdawPdlxkLkYKM/t8qXM2E2iJ7xWWoJezaJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 260/367] KVM: x86: use raw clock values consistently
Date:   Mon, 10 Feb 2020 04:32:53 -0800
Message-Id: <20200210122448.607420692@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 8171cd68806bd2fc28ef688e32fb2a3b3deb04e5 upstream.

Commit 53fafdbb8b21f ("KVM: x86: switch KVMCLOCK base to monotonic raw
clock") changed kvmclock to use tkr_raw instead of tkr_mono.  However,
the default kvmclock_offset for the VM was still based on the monotonic
clock and, if the raw clock drifted enough from the monotonic clock,
this could cause a negative system_time to be written to the guest's
struct pvclock.  RHEL5 does not like it and (if it boots fast enough to
observe a negative time value) it hangs.

There is another thing to be careful about: getboottime64 returns the
host boot time with tkr_mono frequency, and subtracting the tkr_raw-based
kvmclock value will cause the wallclock to be off if tkr_raw drifts
from tkr_mono.  To avoid this, compute the wallclock delta from the
current time instead of being clever and using getboottime64.

Fixes: 53fafdbb8b21f ("KVM: x86: switch KVMCLOCK base to monotonic raw clock")
Cc: stable@vger.kernel.org
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |   38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1625,6 +1625,18 @@ static void update_pvclock_gtod(struct t
 
 	write_seqcount_end(&vdata->seq);
 }
+
+static s64 get_kvmclock_base_ns(void)
+{
+	/* Count up from boot time, but with the frequency of the raw clock.  */
+	return ktime_to_ns(ktime_add(ktime_get_raw(), pvclock_gtod_data.offs_boot));
+}
+#else
+static s64 get_kvmclock_base_ns(void)
+{
+	/* Master clock not used, so we can just use CLOCK_BOOTTIME.  */
+	return ktime_get_boottime_ns();
+}
 #endif
 
 void kvm_set_pending_timer(struct kvm_vcpu *vcpu)
@@ -1638,7 +1650,7 @@ static void kvm_write_wall_clock(struct
 	int version;
 	int r;
 	struct pvclock_wall_clock wc;
-	struct timespec64 boot;
+	u64 wall_nsec;
 
 	if (!wall_clock)
 		return;
@@ -1658,17 +1670,12 @@ static void kvm_write_wall_clock(struct
 	/*
 	 * The guest calculates current wall clock time by adding
 	 * system time (updated by kvm_guest_time_update below) to the
-	 * wall clock specified here.  guest system time equals host
-	 * system time for us, thus we must fill in host boot time here.
+	 * wall clock specified here.  We do the reverse here.
 	 */
-	getboottime64(&boot);
+	wall_nsec = ktime_get_real_ns() - get_kvmclock_ns(kvm);
 
-	if (kvm->arch.kvmclock_offset) {
-		struct timespec64 ts = ns_to_timespec64(kvm->arch.kvmclock_offset);
-		boot = timespec64_sub(boot, ts);
-	}
-	wc.sec = (u32)boot.tv_sec; /* overflow in 2106 guest time */
-	wc.nsec = boot.tv_nsec;
+	wc.nsec = do_div(wall_nsec, 1000000000);
+	wc.sec = (u32)wall_nsec; /* overflow in 2106 guest time */
 	wc.version = version;
 
 	kvm_write_guest(kvm, wall_clock, &wc, sizeof(wc));
@@ -1916,7 +1923,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu
 
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
 	offset = kvm_compute_tsc_offset(vcpu, data);
-	ns = ktime_get_boottime_ns();
+	ns = get_kvmclock_base_ns();
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 
 	if (vcpu->arch.virtual_tsc_khz) {
@@ -2254,7 +2261,7 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 	spin_lock(&ka->pvclock_gtod_sync_lock);
 	if (!ka->use_master_clock) {
 		spin_unlock(&ka->pvclock_gtod_sync_lock);
-		return ktime_get_boottime_ns() + ka->kvmclock_offset;
+		return get_kvmclock_base_ns() + ka->kvmclock_offset;
 	}
 
 	hv_clock.tsc_timestamp = ka->master_cycle_now;
@@ -2270,7 +2277,7 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 				   &hv_clock.tsc_to_system_mul);
 		ret = __pvclock_read_cycles(&hv_clock, rdtsc());
 	} else
-		ret = ktime_get_boottime_ns() + ka->kvmclock_offset;
+		ret = get_kvmclock_base_ns() + ka->kvmclock_offset;
 
 	put_cpu();
 
@@ -2369,7 +2376,7 @@ static int kvm_guest_time_update(struct
 	}
 	if (!use_master_clock) {
 		host_tsc = rdtsc();
-		kernel_ns = ktime_get_boottime_ns();
+		kernel_ns = get_kvmclock_base_ns();
 	}
 
 	tsc_timestamp = kvm_read_l1_tsc(v, host_tsc);
@@ -2409,6 +2416,7 @@ static int kvm_guest_time_update(struct
 	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
 	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
 	vcpu->last_guest_tsc = tsc_timestamp;
+	WARN_ON(vcpu->hv_clock.system_time < 0);
 
 	/* If the host uses TSC clocksource, then it is stable */
 	pvclock_flags = 0;
@@ -9580,7 +9588,7 @@ int kvm_arch_init_vm(struct kvm *kvm, un
 	mutex_init(&kvm->arch.apic_map_lock);
 	spin_lock_init(&kvm->arch.pvclock_gtod_sync_lock);
 
-	kvm->arch.kvmclock_offset = -ktime_get_boottime_ns();
+	kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
 	pvclock_update_vm_gtod_copy(kvm);
 
 	kvm->arch.guest_can_read_msr_platform_info = true;



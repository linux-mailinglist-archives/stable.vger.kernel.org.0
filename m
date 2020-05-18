Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2721D8931
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 22:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgERUbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 16:31:33 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46482 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726595AbgERUbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 16:31:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589833890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=OzWUOF7AI90fjXOzS3G1A0rvBIT6U5j8G2BQ8UOtD+8=;
        b=HaJo2Rh78Pcm7B3cWeMZzAfeDOtFy6VTQH+oE6pQRHfTfh8HtCCiXoMV4yxUiQKaUq70ip
        uTOIepl+dD6hcEOaNlEWTq8x167rHzjD+DikeY0NpZiiHTHdDbGquG4pA5ydHZ4Jny2CQR
        XG1BH5q4hGIDQBJX9MjBu9c6UYOgQbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-b-eqvq72Ooe59yPf1AGzkA-1; Mon, 18 May 2020 16:31:26 -0400
X-MC-Unique: b-eqvq72Ooe59yPf1AGzkA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41D061800D42
        for <stable@vger.kernel.org>; Mon, 18 May 2020 20:31:25 +0000 (UTC)
Received: from fuller.cnet (ovpn-116-130.gru2.redhat.com [10.97.116.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AF875D9DC;
        Mon, 18 May 2020 20:31:19 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id A775E416F5D4; Mon, 18 May 2020 17:30:59 -0300 (-03)
Message-ID: <20200518191759.624834612@fuller.cnet>
User-Agent: quilt/0.66
Date:   Mon, 18 May 2020 16:15:19 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     rhkernel-list@redhat.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, Bandan Das <bsd@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, stable@vger.kernel.org
Subject: [RHEL 8.3 BZ 1768622 PATCH 3/3] KVM: x86: use raw clock values consistently
References: <20200518191516.165550666@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

BZ: 1768622 
Brew: https://brewweb.engineering.redhat.com/brew/taskinfo?taskID=28587593
commit 8171cd68806bd2fc28ef688e32fb2a3b3deb04e5

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

Index: kernel-rhel/arch/x86/kvm/x86.c
===================================================================
--- kernel-rhel.orig/arch/x86/kvm/x86.c
+++ kernel-rhel/arch/x86/kvm/x86.c
@@ -1595,6 +1595,18 @@ static void update_pvclock_gtod(struct t
 
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
@@ -1608,7 +1620,7 @@ static void kvm_write_wall_clock(struct
 	int version;
 	int r;
 	struct pvclock_wall_clock wc;
-	struct timespec64 boot;
+	u64 wall_nsec;
 
 	if (!wall_clock)
 		return;
@@ -1628,17 +1640,12 @@ static void kvm_write_wall_clock(struct
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
@@ -1886,7 +1893,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu
 
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
 	offset = kvm_compute_tsc_offset(vcpu, data);
-	ns = ktime_get_boot_ns();
+	ns = get_kvmclock_base_ns();
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 
 	if (vcpu->arch.virtual_tsc_khz) {
@@ -2224,7 +2231,7 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 	spin_lock(&ka->pvclock_gtod_sync_lock);
 	if (!ka->use_master_clock) {
 		spin_unlock(&ka->pvclock_gtod_sync_lock);
-		return ktime_get_boot_ns() + ka->kvmclock_offset;
+		return get_kvmclock_base_ns() + ka->kvmclock_offset;
 	}
 
 	hv_clock.tsc_timestamp = ka->master_cycle_now;
@@ -2240,7 +2247,7 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 				   &hv_clock.tsc_to_system_mul);
 		ret = __pvclock_read_cycles(&hv_clock, rdtsc());
 	} else
-		ret = ktime_get_boot_ns() + ka->kvmclock_offset;
+		ret = get_kvmclock_base_ns() + ka->kvmclock_offset;
 
 	put_cpu();
 
@@ -2339,7 +2346,7 @@ static int kvm_guest_time_update(struct
 	}
 	if (!use_master_clock) {
 		host_tsc = rdtsc();
-		kernel_ns = ktime_get_boot_ns();
+		kernel_ns = get_kvmclock_base_ns();
 	}
 
 	tsc_timestamp = kvm_read_l1_tsc(v, host_tsc);
@@ -2379,6 +2386,7 @@ static int kvm_guest_time_update(struct
 	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
 	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
 	vcpu->last_guest_tsc = tsc_timestamp;
+	WARN_ON(vcpu->hv_clock.system_time < 0);
 
 	/* If the host uses TSC clocksource, then it is stable */
 	pvclock_flags = 0;
@@ -9486,7 +9494,7 @@ int kvm_arch_init_vm(struct kvm *kvm, un
 	mutex_init(&kvm->arch.apic_map_lock);
 	spin_lock_init(&kvm->arch.pvclock_gtod_sync_lock);
 
-	kvm->arch.kvmclock_offset = -ktime_get_boot_ns();
+	kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
 	pvclock_update_vm_gtod_copy(kvm);
 
 	kvm->arch.guest_can_read_msr_platform_info = true;



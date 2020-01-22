Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06C411457AC
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 15:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgAVOWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 09:22:41 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37110 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgAVOWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 09:22:40 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so7497966wru.4;
        Wed, 22 Jan 2020 06:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D5B46rZepvfhCMrrMr36ldZgrri9BFFr8qCNZvIQpqA=;
        b=iqwV8vsxeNzwCGX7OOX2fVojc/gPAD7PJLTPV7YPvaX8B4dF9Y11pp4Trrg2hDZ/Ob
         zDCOp/ueCsg+14zCzGf0o9jsNE7AeArgAVJuuJ22CrjPFFftJYp0ZTcLPwQMZPGJiH5p
         Nt2rZ0Xjf7aQjzn1g8lS/J+tNjG1hi5ULHF7NocH90YYYHe5rh+/1ZV73jXQa9eRoMCO
         8p+SAU4DV+um1JT5ATbQIqPS6Cl9HnFFqNe0AT7Lr0kVsSP0WtguAcja9/g0slXgbxM+
         Bzzezvm0NmKwH2Dq4vgATni/bTId8GIFgnVpgejw/QUe/Yf+55wwnkrRXLedP3yn2i9z
         QJLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=D5B46rZepvfhCMrrMr36ldZgrri9BFFr8qCNZvIQpqA=;
        b=VNBKOik/ix/Eam/BqP/pFmhXZza5s65yDZKjQFs1rqIrUY2RJfRCiNbX2ozgnuLDUK
         rqOB/p6Q0MuHF1VVegaYOoJ4HfaOZZpxclVCqMm6hu3qOLjvzEOl9iSVAOhvD++666st
         aFJEOCTzlyHFvhy3ocsQkHc3ZRotCupPgPBUUtQT6Ag2ninfBq7BAOFWFJWDINw9kEaH
         vPqHeE3Y4+Yve6oW9PwZEul+APrBpfSotXnCZDgvIQOir+gWeTOSSBUGncI15rTcV2bG
         X9IOLQkvsjwNmQAQYTpuphTO5QCLO5uAaUbtfdA15pRm0+niiOH5NT2J9WZhIrBVWOwJ
         TPTA==
X-Gm-Message-State: APjAAAXkHuTQ1av9lmrjZv3q6xAVQ3pi3ikj1NqpMz8OYxelwGsOn59q
        n3G72gEGsPBm+qwCdJLe88XEeM+j
X-Google-Smtp-Source: APXvYqyNXneQfo1LkZwEKxeux40MUIkj5Kl2DuPRtMcKpilA28SeD40zEziGJOllIoCkMOEkN021Pw==
X-Received: by 2002:adf:ce87:: with SMTP id r7mr11384684wrn.245.1579702958228;
        Wed, 22 Jan 2020 06:22:38 -0800 (PST)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id x11sm4172282wmg.46.2020.01.22.06.22.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jan 2020 06:22:37 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mtosatti@redhat.com, stable@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: use raw clock values consistently
Date:   Wed, 22 Jan 2020 15:22:33 +0100
Message-Id: <1579702953-24184-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579702953-24184-1-git-send-email-pbonzini@redhat.com>
References: <1579702953-24184-1-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 53fafdbb8b21f ("KVM: x86: switch KVMCLOCK base to monotonic raw
clock") changed kvmclock to use tkr_raw instead of tkr_mono.  However,
the default kvmclock_offset for the VM was still based on the monotonic
clock and, if the raw clock drifted enough from the monotonic clock,
this could cause a negative system_time to be written to the guest's
struct pvclock.  RHEL5 does not like it and (if it boots fast enough to
observe a negative time value) it hangs.

There is another thing to be careful about: getboottime64 returns the
host boot time in tkr_mono units, and subtracting tkr_raw units will
cause the wallclock to be off if tkr_raw drifts from tkr_mono.  To
avoid this, compute the wallclock delta from the current time instead
of being clever and using getboottime64.

Fixes: 53fafdbb8b21f ("KVM: x86: switch KVMCLOCK base to monotonic raw clock")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b4273cce63c..b5e0648580e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1577,6 +1577,18 @@ static void update_pvclock_gtod(struct timekeeper *tk)
 
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
@@ -1590,7 +1602,7 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
 	int version;
 	int r;
 	struct pvclock_wall_clock wc;
-	struct timespec64 boot;
+	u64 wall_nsec;
 
 	if (!wall_clock)
 		return;
@@ -1610,17 +1622,12 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
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
@@ -1868,7 +1875,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
 	offset = kvm_compute_tsc_offset(vcpu, data);
-	ns = ktime_get_boottime_ns();
+	ns = get_kvmclock_base_ns();
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 
 	if (vcpu->arch.virtual_tsc_khz) {
@@ -2206,7 +2213,7 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 	spin_lock(&ka->pvclock_gtod_sync_lock);
 	if (!ka->use_master_clock) {
 		spin_unlock(&ka->pvclock_gtod_sync_lock);
-		return ktime_get_boottime_ns() + ka->kvmclock_offset;
+		return get_kvmclock_base_ns() + ka->kvmclock_offset;
 	}
 
 	hv_clock.tsc_timestamp = ka->master_cycle_now;
@@ -2222,7 +2229,7 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 				   &hv_clock.tsc_to_system_mul);
 		ret = __pvclock_read_cycles(&hv_clock, rdtsc());
 	} else
-		ret = ktime_get_boottime_ns() + ka->kvmclock_offset;
+		ret = get_kvmclock_base_ns() + ka->kvmclock_offset;
 
 	put_cpu();
 
@@ -2321,7 +2328,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	}
 	if (!use_master_clock) {
 		host_tsc = rdtsc();
-		kernel_ns = ktime_get_boottime_ns();
+		kernel_ns = get_kvmclock_base_ns();
 	}
 
 	tsc_timestamp = kvm_read_l1_tsc(v, host_tsc);
@@ -2361,6 +2368,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
 	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
 	vcpu->last_guest_tsc = tsc_timestamp;
+	WARN_ON(vcpu->hv_clock.system_time < 0);
 
 	/* If the host uses TSC clocksource, then it is stable */
 	pvclock_flags = 0;
@@ -9473,7 +9481,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	mutex_init(&kvm->arch.apic_map_lock);
 	spin_lock_init(&kvm->arch.pvclock_gtod_sync_lock);
 
-	kvm->arch.kvmclock_offset = -ktime_get_boottime_ns();
+	kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
 	pvclock_update_vm_gtod_copy(kvm);
 
 	kvm->arch.guest_can_read_msr_platform_info = true;
-- 
1.8.3.1


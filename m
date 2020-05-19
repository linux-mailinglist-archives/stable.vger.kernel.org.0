Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A29C1D92D1
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 10:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgESI7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 04:59:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22122 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726333AbgESI7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 04:59:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589878751;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=d0xXP6m9Y5f9o8aotxcyATC7Qn8xvZso5obs+H3a6OE=;
        b=eKtPhNURp8Nlj8rH7eTFDb3G4HcfmSxWxwH8BaM4jG+4WLsG95rvzHb94A3LtFeSys/ahv
        WCg3H4fTQbnJ4/EHHiwusNY7qQW+Or9o1KQo/63g2Vp7lNPVKR9yLw9VNoKNM0fawk8nkD
        kZInPlX31fA60bQ2/BZAWZl2UpQK6BM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-NSA_GfIeOw2qKqgH7yrnRg-1; Tue, 19 May 2020 04:59:07 -0400
X-MC-Unique: NSA_GfIeOw2qKqgH7yrnRg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79125108BD0C
        for <stable@vger.kernel.org>; Tue, 19 May 2020 08:59:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 939161001B07;
        Tue, 19 May 2020 08:58:54 +0000 (UTC)
Date:   Tue, 19 May 2020 10:58:52 +0200
From:   Frantisek Hrbata <fhrbata@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     rhkernel-list@redhat.com, Andrew Jones <drjones@redhat.com>,
        stable@vger.kernel.org, Bandan Das <bsd@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [RHEL 8.3 BZ 1768622 PATCH 3/3] KVM: x86: use raw clock values
 consistently
Message-ID: <20200519085852.GE20516@localhost.localdomain>
Reply-To: Frantisek Hrbata <fhrbata@redhat.com>
References: <20200518191516.165550666@fuller.cnet>
 <20200518191759.624834612@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518191759.624834612@fuller.cnet>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marcelo,

I'm marking this as superseded by pwid 303977

http://patchwork.lab.bos.redhat.com/patch/303977/

which was included in kernel-4.18.0-196.el8

    commit 9751522d92195bc64883c71e2bee8ed0fcbc5007
    Author: Vitaly Kuznetsov <vkuznets@redhat.com>
    Date:   Mon Apr 20 15:20:04 2020 -0400

    [x86] kvm: x86: use raw clock values consistently

    Message-id: <20200420152004.933168-1-vkuznets@redhat.com>
    Patchwork-id: 303977
    Patchwork-instance: patchwork
    O-Subject: [RHEL8.3 virt PATCH v2 312/614] KVM: x86: use raw clock values consistently
    Bugzilla: 1813987
    RH-Acked-by: Andrew Jones <drjones@redhat.com>
    RH-Acked-by: Paolo Bonzini <pbonzini@redhat.com>
    RH-Acked-by: Tony Camuso <tcamuso@redhat.com>

Note there is a difference between yours and Vitaly's patch in the
following hunk

+@@ -1656,6 +1656,18 @@ static void update_pvclock_gtod(struct timekeeper *tk)

        write_seqcount_end(&vdata->seq);
  }
@@ -14,12 +16,12 @@
 +static s64 get_kvmclock_base_ns(void)
 +{
 +      /* Master clock not used, so we can just use CLOCK_BOOTTIME.  */
-+      return ktime_get_boottime_ns();
++      return ktime_get_boot_ns();
 +}
  #endif


This is in !CONFIG_X86_64 path, so I'm not sure how much we care about
this. Anyway Vitaly's patch corrects this, because
rhel does not have upstream commit 9285ec4c8b61d4930a575081abeba2cd4f449a74

Thank you

On Mon, May 18, 2020 at 04:15:19PM -0300, Marcelo Tosatti wrote:
> BZ: 1768622 
> Brew: https://brewweb.engineering.redhat.com/brew/taskinfo?taskID=28587593
> commit 8171cd68806bd2fc28ef688e32fb2a3b3deb04e5
> 
> Commit 53fafdbb8b21f ("KVM: x86: switch KVMCLOCK base to monotonic raw
> clock") changed kvmclock to use tkr_raw instead of tkr_mono.  However,
> the default kvmclock_offset for the VM was still based on the monotonic
> clock and, if the raw clock drifted enough from the monotonic clock,
> this could cause a negative system_time to be written to the guest's
> struct pvclock.  RHEL5 does not like it and (if it boots fast enough to
> observe a negative time value) it hangs.
> 
> There is another thing to be careful about: getboottime64 returns the
> host boot time with tkr_mono frequency, and subtracting the tkr_raw-based
> kvmclock value will cause the wallclock to be off if tkr_raw drifts
> from tkr_mono.  To avoid this, compute the wallclock delta from the
> current time instead of being clever and using getboottime64.
> 
> Fixes: 53fafdbb8b21f ("KVM: x86: switch KVMCLOCK base to monotonic raw clock")
> Cc: stable@vger.kernel.org
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Index: kernel-rhel/arch/x86/kvm/x86.c
> ===================================================================
> --- kernel-rhel.orig/arch/x86/kvm/x86.c
> +++ kernel-rhel/arch/x86/kvm/x86.c
> @@ -1595,6 +1595,18 @@ static void update_pvclock_gtod(struct t
>  
>  	write_seqcount_end(&vdata->seq);
>  }
> +
> +static s64 get_kvmclock_base_ns(void)
> +{
> +	/* Count up from boot time, but with the frequency of the raw clock.  */
> +	return ktime_to_ns(ktime_add(ktime_get_raw(), pvclock_gtod_data.offs_boot));
> +}
> +#else
> +static s64 get_kvmclock_base_ns(void)
> +{
> +	/* Master clock not used, so we can just use CLOCK_BOOTTIME.  */
> +	return ktime_get_boottime_ns();
> +}
>  #endif
>  
>  void kvm_set_pending_timer(struct kvm_vcpu *vcpu)
> @@ -1608,7 +1620,7 @@ static void kvm_write_wall_clock(struct
>  	int version;
>  	int r;
>  	struct pvclock_wall_clock wc;
> -	struct timespec64 boot;
> +	u64 wall_nsec;
>  
>  	if (!wall_clock)
>  		return;
> @@ -1628,17 +1640,12 @@ static void kvm_write_wall_clock(struct
>  	/*
>  	 * The guest calculates current wall clock time by adding
>  	 * system time (updated by kvm_guest_time_update below) to the
> -	 * wall clock specified here.  guest system time equals host
> -	 * system time for us, thus we must fill in host boot time here.
> +	 * wall clock specified here.  We do the reverse here.
>  	 */
> -	getboottime64(&boot);
> +	wall_nsec = ktime_get_real_ns() - get_kvmclock_ns(kvm);
>  
> -	if (kvm->arch.kvmclock_offset) {
> -		struct timespec64 ts = ns_to_timespec64(kvm->arch.kvmclock_offset);
> -		boot = timespec64_sub(boot, ts);
> -	}
> -	wc.sec = (u32)boot.tv_sec; /* overflow in 2106 guest time */
> -	wc.nsec = boot.tv_nsec;
> +	wc.nsec = do_div(wall_nsec, 1000000000);
> +	wc.sec = (u32)wall_nsec; /* overflow in 2106 guest time */
>  	wc.version = version;
>  
>  	kvm_write_guest(kvm, wall_clock, &wc, sizeof(wc));
> @@ -1886,7 +1893,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu
>  
>  	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
>  	offset = kvm_compute_tsc_offset(vcpu, data);
> -	ns = ktime_get_boot_ns();
> +	ns = get_kvmclock_base_ns();
>  	elapsed = ns - kvm->arch.last_tsc_nsec;
>  
>  	if (vcpu->arch.virtual_tsc_khz) {
> @@ -2224,7 +2231,7 @@ u64 get_kvmclock_ns(struct kvm *kvm)
>  	spin_lock(&ka->pvclock_gtod_sync_lock);
>  	if (!ka->use_master_clock) {
>  		spin_unlock(&ka->pvclock_gtod_sync_lock);
> -		return ktime_get_boot_ns() + ka->kvmclock_offset;
> +		return get_kvmclock_base_ns() + ka->kvmclock_offset;
>  	}
>  
>  	hv_clock.tsc_timestamp = ka->master_cycle_now;
> @@ -2240,7 +2247,7 @@ u64 get_kvmclock_ns(struct kvm *kvm)
>  				   &hv_clock.tsc_to_system_mul);
>  		ret = __pvclock_read_cycles(&hv_clock, rdtsc());
>  	} else
> -		ret = ktime_get_boot_ns() + ka->kvmclock_offset;
> +		ret = get_kvmclock_base_ns() + ka->kvmclock_offset;
>  
>  	put_cpu();
>  
> @@ -2339,7 +2346,7 @@ static int kvm_guest_time_update(struct
>  	}
>  	if (!use_master_clock) {
>  		host_tsc = rdtsc();
> -		kernel_ns = ktime_get_boot_ns();
> +		kernel_ns = get_kvmclock_base_ns();
>  	}
>  
>  	tsc_timestamp = kvm_read_l1_tsc(v, host_tsc);
> @@ -2379,6 +2386,7 @@ static int kvm_guest_time_update(struct
>  	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
>  	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
>  	vcpu->last_guest_tsc = tsc_timestamp;
> +	WARN_ON(vcpu->hv_clock.system_time < 0);
>  
>  	/* If the host uses TSC clocksource, then it is stable */
>  	pvclock_flags = 0;
> @@ -9486,7 +9494,7 @@ int kvm_arch_init_vm(struct kvm *kvm, un
>  	mutex_init(&kvm->arch.apic_map_lock);
>  	spin_lock_init(&kvm->arch.pvclock_gtod_sync_lock);
>  
> -	kvm->arch.kvmclock_offset = -ktime_get_boot_ns();
> +	kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
>  	pvclock_update_vm_gtod_copy(kvm);
>  
>  	kvm->arch.guest_can_read_msr_platform_info = true;
> 
> 

-- 
Frantisek Hrbata


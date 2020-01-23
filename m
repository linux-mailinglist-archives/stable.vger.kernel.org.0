Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C2E146968
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 14:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgAWNoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 08:44:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59972 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726227AbgAWNoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 08:44:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579787041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vda9KDIFJr+wjRE5OYCcBuFGB2g+mH5LvFQuqQ/dtxg=;
        b=iJyIOAKR78OVOzk4woy6KTsnTPbhTzX6Am06h3D5CXE9y72XRbslK87rZaKc+smXiTHPvm
        5a7fCKxS0QTZuApH2W5gKMXz7VPmZoXeQKgs9+zIPJkQhGQ69SNny88KtlcsQNxFApwGhx
        uk4BBJVHiQzKD95TYA53iS9x2t/8i8s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-oYLmN9pXMX6VbF4qc1cdHQ-1; Thu, 23 Jan 2020 08:44:00 -0500
X-MC-Unique: oYLmN9pXMX6VbF4qc1cdHQ-1
Received: by mail-wm1-f69.google.com with SMTP id y24so1033006wmj.8
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 05:43:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Vda9KDIFJr+wjRE5OYCcBuFGB2g+mH5LvFQuqQ/dtxg=;
        b=k9CYT4THCQzyHmLHRHy9vGdNgM7ZCThiZaRoAZEyjrnZHM96nqoKgo7jcwkp8pBzrw
         QbWsESYwgJbLt1AsaG69xu9ivtLf9jgi5sxe0UxmKclTN2F1AIIy/QIHL2KXWHJLb0rV
         +LieBlygBsVXwhVrzlxOf9IrQDfSHKNs7A9HjV7oCN7VLjCXFR9g/1ZwvVouzWi/9C/P
         GuTLQNtP7ucgdsq8i4UwdN8tmG/H1pzwOyS5fsmyg9vms7VQXO9M3z7ItF86lI3bttlU
         GOpllG9caRZYhdVZhjGHfIUANCzJvrrI8whDAH522yRm0iyUF6vnBbkk/KMncYJzGqSn
         y1XQ==
X-Gm-Message-State: APjAAAWwkZb9JWXg0nUOihlCQ4Kz/vf1+2M1R1q3DJ2vqW4jka6obpij
        g6vjzzyCqaElyHSEy1QlSZDBMIL2MIRnN7YwRYkLm8hn4t38q6d8fF/iWLAnUPpEHZdhlmjP1Ho
        YxCdQrHHjBHP2WrVR
X-Received: by 2002:adf:f8c8:: with SMTP id f8mr17593232wrq.331.1579787038715;
        Thu, 23 Jan 2020 05:43:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqzjdq+EOBlRJBt0coAiDqqB3allEb9sEp3iyRqddmN2eFsF0WnTlt1LX0bsDukKtWWQ+vsDPg==
X-Received: by 2002:adf:f8c8:: with SMTP id f8mr17593214wrq.331.1579787038428;
        Thu, 23 Jan 2020 05:43:58 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id r68sm2618036wmr.43.2020.01.23.05.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 05:43:57 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     mtosatti@redhat.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: use raw clock values consistently
In-Reply-To: <1579702953-24184-3-git-send-email-pbonzini@redhat.com>
References: <1579702953-24184-1-git-send-email-pbonzini@redhat.com> <1579702953-24184-3-git-send-email-pbonzini@redhat.com>
Date:   Thu, 23 Jan 2020 14:43:57 +0100
Message-ID: <87r1zqqode.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Commit 53fafdbb8b21f ("KVM: x86: switch KVMCLOCK base to monotonic raw
> clock") changed kvmclock to use tkr_raw instead of tkr_mono.  However,
> the default kvmclock_offset for the VM was still based on the monotonic
> clock and, if the raw clock drifted enough from the monotonic clock,
> this could cause a negative system_time to be written to the guest's
> struct pvclock.  RHEL5 does not like it and (if it boots fast enough to
> observe a negative time value) it hangs.
>
> There is another thing to be careful about: getboottime64 returns the
> host boot time in tkr_mono units, and subtracting tkr_raw units will
> cause the wallclock to be off if tkr_raw drifts from tkr_mono.  To
> avoid this, compute the wallclock delta from the current time instead
> of being clever and using getboottime64.
>
> Fixes: 53fafdbb8b21f ("KVM: x86: switch KVMCLOCK base to monotonic raw clock")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 38 +++++++++++++++++++++++---------------
>  1 file changed, 23 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1b4273cce63c..b5e0648580e1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1577,6 +1577,18 @@ static void update_pvclock_gtod(struct timekeeper *tk)
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

But we could've still used the RAW+offs_boot version, right? And this is
just to basically preserve the existing behavior on !x86.

>  
>  void kvm_set_pending_timer(struct kvm_vcpu *vcpu)
> @@ -1590,7 +1602,7 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
>  	int version;
>  	int r;
>  	struct pvclock_wall_clock wc;
> -	struct timespec64 boot;
> +	u64 wall_nsec;
>  
>  	if (!wall_clock)
>  		return;
> @@ -1610,17 +1622,12 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
>  	/*
>  	 * The guest calculates current wall clock time by adding
>  	 * system time (updated by kvm_guest_time_update below) to the
> -	 * wall clock specified here.  guest system time equals host
> -	 * system time for us, thus we must fill in host boot time here.
> +	 * wall clock specified here.  We do the reverse here.
>  	 */
> -	getboottime64(&boot);
> +	wall_nsec = ktime_get_real_ns() - get_kvmclock_ns(kvm);

There are not that many hosts with more than 50 years uptime and likely
none running Linux with live kernel patching support so I bet noone will
ever see this overflowing, however, as wall_nsec is u64 and we're
dealing with kvmclock here I'd suggest to add a WARN_ON().

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
> @@ -1868,7 +1875,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  
>  	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
>  	offset = kvm_compute_tsc_offset(vcpu, data);
> -	ns = ktime_get_boottime_ns();
> +	ns = get_kvmclock_base_ns();
>  	elapsed = ns - kvm->arch.last_tsc_nsec;
>  
>  	if (vcpu->arch.virtual_tsc_khz) {
> @@ -2206,7 +2213,7 @@ u64 get_kvmclock_ns(struct kvm *kvm)
>  	spin_lock(&ka->pvclock_gtod_sync_lock);
>  	if (!ka->use_master_clock) {
>  		spin_unlock(&ka->pvclock_gtod_sync_lock);
> -		return ktime_get_boottime_ns() + ka->kvmclock_offset;
> +		return get_kvmclock_base_ns() + ka->kvmclock_offset;
>  	}
>  
>  	hv_clock.tsc_timestamp = ka->master_cycle_now;
> @@ -2222,7 +2229,7 @@ u64 get_kvmclock_ns(struct kvm *kvm)
>  				   &hv_clock.tsc_to_system_mul);
>  		ret = __pvclock_read_cycles(&hv_clock, rdtsc());
>  	} else
> -		ret = ktime_get_boottime_ns() + ka->kvmclock_offset;
> +		ret = get_kvmclock_base_ns() + ka->kvmclock_offset;
>  
>  	put_cpu();
>  
> @@ -2321,7 +2328,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  	}
>  	if (!use_master_clock) {
>  		host_tsc = rdtsc();
> -		kernel_ns = ktime_get_boottime_ns();
> +		kernel_ns = get_kvmclock_base_ns();
>  	}
>  
>  	tsc_timestamp = kvm_read_l1_tsc(v, host_tsc);
> @@ -2361,6 +2368,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
>  	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
>  	vcpu->last_guest_tsc = tsc_timestamp;
> +	WARN_ON(vcpu->hv_clock.system_time < 0);
>  
>  	/* If the host uses TSC clocksource, then it is stable */
>  	pvclock_flags = 0;
> @@ -9473,7 +9481,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	mutex_init(&kvm->arch.apic_map_lock);
>  	spin_lock_init(&kvm->arch.pvclock_gtod_sync_lock);
>  
> -	kvm->arch.kvmclock_offset = -ktime_get_boottime_ns();
> +	kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
>  	pvclock_update_vm_gtod_copy(kvm);
>  
>  	kvm->arch.guest_can_read_msr_platform_info = true;

This looks correct to me but kvmclock is a glorious beast so take this
with a grain of salt)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


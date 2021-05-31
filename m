Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B33639641A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 17:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbhEaPqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:46:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28614 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233456AbhEaPoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 11:44:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622475751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uoeKMi2Uiw1QmmSIqVRqQ3HJ68tJTjt/a0gPTkedxsY=;
        b=EBVqNjr26c8nAMBupOEygxhbE9yCu7qzgM5IqBsH8dYoUk02aszYZo6DOSX9df6erxQ/C0
        kv0y95T4WdO+WvEycAbtdjTaBIiHLfWwm5SXDyjG/sjM+QWhqa/pMn14g6aHjowKYfJAVT
        iS2PQG1sbiVBp2z8saXwUg3shr7S93M=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-KiiT8XBWP9i_XgILFyX4gA-1; Mon, 31 May 2021 11:42:30 -0400
X-MC-Unique: KiiT8XBWP9i_XgILFyX4gA-1
Received: by mail-wr1-f71.google.com with SMTP id i102-20020adf90ef0000b029010dfcfc46c0so4127637wri.1
        for <stable@vger.kernel.org>; Mon, 31 May 2021 08:42:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uoeKMi2Uiw1QmmSIqVRqQ3HJ68tJTjt/a0gPTkedxsY=;
        b=d6huS+RdEqO21Hw6JI/inz1VFij7Wkm81R/KjIFMfvbMmeq1VtieTNvRbf+8jHopkj
         WhY7JUm/Zl2R9FRLA5w9AI9+k4wzep84D5SDMwTIy6PTcyP+VNRLZMhI3vPTQa9alJPe
         mrXRSD8hw53+voUVjuSWm8zowDnZBTPM2Ar4P2FpJBND/CgGiGultu+llV9hWDRTUj3J
         JnPVQwE2xjzqW/0Wu1r3beXxvqjGjOMTuLVLdkV2V8BzhsYx6Owl6ZCt1ekAU7PHT0Wf
         CV/IZaJ6LRo/C97LhcR/Au1zkOgzjCgQ5WcKtCpXzFronf+J7cySjAk5cHnjqQUG6YCr
         FU6A==
X-Gm-Message-State: AOAM531v9IjAOpXj1Il02gpDzvJ+oyfuRFFSTB/1heYi6SXO6COcWgst
        M4bm43IFKPTRdSQDJzGot3Ih0pZJ/a3tFRlIB94RRmz6d0xo5UCPk5nlAL0SRhKd1DCAzUplLpm
        ljqS2OAADmm0NS4XH
X-Received: by 2002:a5d:58d3:: with SMTP id o19mr9532482wrf.404.1622475748673;
        Mon, 31 May 2021 08:42:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnYxuyqfBlq/lWhbjCoF9Z3VdkFFcDKinaBhLgcf/eee3xLyOGQBRLyMfyXk6wsHQ5rxGGMQ==
X-Received: by 2002:a5d:58d3:: with SMTP id o19mr9532469wrf.404.1622475748425;
        Mon, 31 May 2021 08:42:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o11sm38020wrq.93.2021.05.31.08.42.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 08:42:27 -0700 (PDT)
Subject: Re: [PATCH v3 | stable v5.10 3/3] x86/kvm: Disable all PV features on
 crash
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210531140526.42932-1-krzysztof.kozlowski@canonical.com>
 <20210531140526.42932-4-krzysztof.kozlowski@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2c8796f9-e2fb-18ad-53ee-47a20496ba52@redhat.com>
Date:   Mon, 31 May 2021 17:42:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210531140526.42932-4-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31/05/21 16:05, Krzysztof Kozlowski wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> commit 3d6b84132d2a57b5a74100f6923a8feb679ac2ce upstream.
> 
> Crash shutdown handler only disables kvmclock and steal time, other PV
> features remain active so we risk corrupting memory or getting some
> side-effects in kdump kernel. Move crash handler to kvm.c and unify
> with CPU offline.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20210414123544.1060604-5-vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>   arch/x86/include/asm/kvm_para.h |  6 -----
>   arch/x86/kernel/kvm.c           | 44 ++++++++++++++++++++++++---------
>   arch/x86/kernel/kvmclock.c      | 21 ----------------
>   3 files changed, 32 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 9c56e0defd45..69299878b200 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -92,7 +92,6 @@ unsigned int kvm_arch_para_hints(void);
>   void kvm_async_pf_task_wait_schedule(u32 token);
>   void kvm_async_pf_task_wake(u32 token);
>   u32 kvm_read_and_reset_apf_flags(void);
> -void kvm_disable_steal_time(void);
>   bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token);
>   
>   DECLARE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
> @@ -137,11 +136,6 @@ static inline u32 kvm_read_and_reset_apf_flags(void)
>   	return 0;
>   }
>   
> -static inline void kvm_disable_steal_time(void)
> -{
> -	return;
> -}
> -
>   static __always_inline bool kvm_handle_async_pf(struct pt_regs *regs, u32 token)
>   {
>   	return false;
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index be1c42e663c6..7462b79c39de 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -38,6 +38,7 @@
>   #include <asm/tlb.h>
>   #include <asm/cpuidle_haltpoll.h>
>   #include <asm/ptrace.h>
> +#include <asm/reboot.h>
>   #include <asm/svm.h>
>   
>   DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
> @@ -375,6 +376,14 @@ static void kvm_pv_disable_apf(void)
>   	pr_info("Unregister pv shared memory for cpu %d\n", smp_processor_id());
>   }
>   
> +static void kvm_disable_steal_time(void)
> +{
> +	if (!has_steal_clock)
> +		return;
> +
> +	wrmsr(MSR_KVM_STEAL_TIME, 0, 0);
> +}
> +
>   static void kvm_pv_guest_cpu_reboot(void *unused)
>   {
>   	/*
> @@ -417,14 +426,6 @@ static u64 kvm_steal_clock(int cpu)
>   	return steal;
>   }
>   
> -void kvm_disable_steal_time(void)
> -{
> -	if (!has_steal_clock)
> -		return;
> -
> -	wrmsr(MSR_KVM_STEAL_TIME, 0, 0);
> -}
> -
>   static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
>   {
>   	early_set_memory_decrypted((unsigned long) ptr, size);
> @@ -461,13 +462,14 @@ static bool pv_tlb_flush_supported(void)
>   
>   static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
>   
> -static void kvm_guest_cpu_offline(void)
> +static void kvm_guest_cpu_offline(bool shutdown)
>   {
>   	kvm_disable_steal_time();
>   	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
>   		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
>   	kvm_pv_disable_apf();
> -	apf_task_wake_all();
> +	if (!shutdown)
> +		apf_task_wake_all();
>   	kvmclock_disable();
>   }
>   
> @@ -613,7 +615,7 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
>   	unsigned long flags;
>   
>   	local_irq_save(flags);
> -	kvm_guest_cpu_offline();
> +	kvm_guest_cpu_offline(false);
>   	local_irq_restore(flags);
>   	return 0;
>   }
> @@ -622,7 +624,7 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
>   
>   static int kvm_suspend(void)
>   {
> -	kvm_guest_cpu_offline();
> +	kvm_guest_cpu_offline(false);
>   
>   	return 0;
>   }
> @@ -637,6 +639,20 @@ static struct syscore_ops kvm_syscore_ops = {
>   	.resume		= kvm_resume,
>   };
>   
> +/*
> + * After a PV feature is registered, the host will keep writing to the
> + * registered memory location. If the guest happens to shutdown, this memory
> + * won't be valid. In cases like kexec, in which you install a new kernel, this
> + * means a random memory location will be kept being written.
> + */
> +#ifdef CONFIG_KEXEC_CORE
> +static void kvm_crash_shutdown(struct pt_regs *regs)
> +{
> +	kvm_guest_cpu_offline(true);
> +	native_machine_crash_shutdown(regs);
> +}
> +#endif
> +
>   static void kvm_flush_tlb_others(const struct cpumask *cpumask,
>   			const struct flush_tlb_info *info)
>   {
> @@ -705,6 +721,10 @@ static void __init kvm_guest_init(void)
>   	kvm_guest_cpu_init();
>   #endif
>   
> +#ifdef CONFIG_KEXEC_CORE
> +	machine_ops.crash_shutdown = kvm_crash_shutdown;
> +#endif
> +
>   	register_syscore_ops(&kvm_syscore_ops);
>   
>   	/*
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 327a0de01066..c4ac26333bc4 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -20,7 +20,6 @@
>   #include <asm/hypervisor.h>
>   #include <asm/mem_encrypt.h>
>   #include <asm/x86_init.h>
> -#include <asm/reboot.h>
>   #include <asm/kvmclock.h>
>   
>   static int kvmclock __initdata = 1;
> @@ -204,23 +203,6 @@ static void kvm_setup_secondary_clock(void)
>   }
>   #endif
>   
> -/*
> - * After the clock is registered, the host will keep writing to the
> - * registered memory location. If the guest happens to shutdown, this memory
> - * won't be valid. In cases like kexec, in which you install a new kernel, this
> - * means a random memory location will be kept being written. So before any
> - * kind of shutdown from our side, we unregister the clock by writing anything
> - * that does not have the 'enable' bit set in the msr
> - */
> -#ifdef CONFIG_KEXEC_CORE
> -static void kvm_crash_shutdown(struct pt_regs *regs)
> -{
> -	native_write_msr(msr_kvm_system_time, 0, 0);
> -	kvm_disable_steal_time();
> -	native_machine_crash_shutdown(regs);
> -}
> -#endif
> -
>   void kvmclock_disable(void)
>   {
>   	native_write_msr(msr_kvm_system_time, 0, 0);
> @@ -350,9 +332,6 @@ void __init kvmclock_init(void)
>   #endif
>   	x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
>   	x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
> -#ifdef CONFIG_KEXEC_CORE
> -	machine_ops.crash_shutdown  = kvm_crash_shutdown;
> -#endif
>   	kvm_get_preset_lpj();
>   
>   	/*
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


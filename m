Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EC4396EB8
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 10:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhFAIVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 04:21:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25256 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233295AbhFAIVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 04:21:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622535564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dQn9qliZC74WZmcuZfcGnDIysTFyW6KqNAODqWdztnI=;
        b=UIgS+f7iv0i7lZ1SDy+9CjEsStXgXqBDzoGO7rJhVOOwFtKS8gfXIfIoMUk6mF4QoS4Y8a
        koCvsvocqnQH06Rf7qYR1SqvqPrI995934ZYOJM9xMFWaLwx+t04aHsxzi56jvVesGkZeM
        cLM6cU/pUTKrLjAxKOHw/ccMln5wpGI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-D4qnPf07PkyA5lghANGXeQ-1; Tue, 01 Jun 2021 04:19:22 -0400
X-MC-Unique: D4qnPf07PkyA5lghANGXeQ-1
Received: by mail-ej1-f70.google.com with SMTP id z1-20020a1709068141b02903cd421d7803so3033586ejw.22
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 01:19:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dQn9qliZC74WZmcuZfcGnDIysTFyW6KqNAODqWdztnI=;
        b=GMEFTk1uTFFdwl3i/NqJen5W756djsLnIW96FeDhwN89aRdo8ypX/YsR+YBo8TcOpp
         VJzVmSjSJEYxNhsI/6Vo0lbB98dKu1owlk22BV7qBuzuqfzao0Sc9KMBnYoC5UdnUi8U
         uzI9pNMk4EgkrCBKy3g8sYcVQ0XrIkgfQzJFgAIheGDoFSBXfpm2uDdxa9A6Vmp9VOw6
         CT4Mhb3IEdJ/4xrSjlXNOGGGFUAoNgzGAASqtu7x/T3J+icp/v2ikeD0PfDKhfg66LLd
         X7TloTm3kXPMKDhDCA616825aKGt39TydGdLTKGvBY5rD2QPcR/U6hVjX38cuWTXOKXO
         NW1A==
X-Gm-Message-State: AOAM531mExIELylZ7EWeNJE5moSgHbKvV/Q2hzUh2ixBi23GJPJHM8yb
        XmOl79pJTXjXyaQdTeAdHhyuDeSPyHexQXWDx5Ss4Kx8nrQVX3+vTquILTha7a+FfQsT6KhBv49
        m2FGQMI0aG/nt6BjZ
X-Received: by 2002:a17:906:4c57:: with SMTP id d23mr4747936ejw.147.1622535561388;
        Tue, 01 Jun 2021 01:19:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZVWF6JFXU2CZvdXnHQhQlwqbbQI153qLoxBOmLBzZ6sacP1UlDGaid3pod+jeLP1sUM7mhQ==
X-Received: by 2002:a17:906:4c57:: with SMTP id d23mr4747918ejw.147.1622535561196;
        Tue, 01 Jun 2021 01:19:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u15sm3062712edy.29.2021.06.01.01.19.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 01:19:20 -0700 (PDT)
Subject: Re: [PATCH v3 | stable v5.12 3/3] x86/kvm: Disable all PV features on
 crash
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210601071644.6055-1-krzysztof.kozlowski@canonical.com>
 <20210601071644.6055-3-krzysztof.kozlowski@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <db60506d-fe90-4008-e8ac-270112e24965@redhat.com>
Date:   Tue, 1 Jun 2021 10:19:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210601071644.6055-3-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/06/21 09:16, Krzysztof Kozlowski wrote:
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
> index 2ebb93c34bc5..919411a0117d 100644
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
> index cf869de98eec..b825c87c12ef 100644
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
> @@ -203,23 +202,6 @@ static void kvm_setup_secondary_clock(void)
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
> @@ -349,9 +331,6 @@ void __init kvmclock_init(void)
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6978939640C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 17:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhEaPpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:45:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233940AbhEaPm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 11:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622475649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aaXc+hP0smwHBHQCyv04SH53vYhPdtvDnEcp8VmVras=;
        b=EyQAODFFKfkD59I7CnK0TGWrYbcY01fNdWmzxqd2/RgSaGxFdFcjVOBGabA2T15l64acby
        K1ZtP2mlJSxWer+A9XdVsZ/okUli/SiqZWOqlwDSf3VDNnxbUJz6jaXEXDfg0Hfj58MEQ4
        jzadGkVroek2VJNlYSQqbAw1wZyGZuc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-0v-JRnrNMA2NUVdkdkIKcQ-1; Mon, 31 May 2021 11:40:47 -0400
X-MC-Unique: 0v-JRnrNMA2NUVdkdkIKcQ-1
Received: by mail-ed1-f69.google.com with SMTP id s20-20020a0564025214b029038752a2d8f3so6385057edd.2
        for <stable@vger.kernel.org>; Mon, 31 May 2021 08:40:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aaXc+hP0smwHBHQCyv04SH53vYhPdtvDnEcp8VmVras=;
        b=HTBWF9BHyhB8taTKS9RMl8yZ7WyUkPbXA7JebF7IqSC6EVJEEjq4AIpr5DO3kKx6rg
         QpDkDMwJe0BkpNJS1qwTGdKmvmXnFpIgn2I8qCtSnj5QAsAIlhpWB1jvAkdijc9KV9zE
         EFNlw2rNAjwRuAtxfBTXgAM8aS7sUBYXpTMveCG6LA4n9xPO1HUQv2kwf/7j8GGpzKSG
         nGEGnSo+27Y7TOdnK2aSPT+9bXCFVM49HDVHx+tTlTJDRDyrnNgjqo3kM54zAlBnHdFk
         cEQ0cz3Zq8ydhe6kuL7gI9reyIPnz7yKhxfK9nW+OzKniQPDjkNK/zwXmPN5LpJyItdB
         vZWA==
X-Gm-Message-State: AOAM531U4xX8sfhWUe+Ot1keBOA1nqrC6gkHqrQHIaNuEAjhJzoocRqZ
        qZmbf3P801AksO08ypXVVQa04RpgfF/e2ttAmdfqM+oRbDvxfK4+DrFAtJEUz939sVDoIwliuKf
        E7mYRARfb09YW7P1q
X-Received: by 2002:a17:906:2da1:: with SMTP id g1mr22987760eji.47.1622475645810;
        Mon, 31 May 2021 08:40:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEFxqhw1psOxIruKQJWTUlEHYo6NHYAJ0zXxEacBjyMVQ/uw7JGz6A4UQzrZopbuAvYcWAXQ==
X-Received: by 2002:a17:906:2da1:: with SMTP id g1mr22987747eji.47.1622475645617;
        Mon, 31 May 2021 08:40:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y9sm6872356edc.46.2021.05.31.08.40.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 08:40:44 -0700 (PDT)
Subject: Re: [PATCH v3 | stable v5.4 3/3] x86/kvm: Disable all PV features on
 crash
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210531140347.42681-1-krzysztof.kozlowski@canonical.com>
 <20210531140347.42681-4-krzysztof.kozlowski@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9869811c-4ceb-fd6a-2c6f-cc6877112c8a@redhat.com>
Date:   Mon, 31 May 2021 17:40:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210531140347.42681-4-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31/05/21 16:03, Krzysztof Kozlowski wrote:
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
> index a617fd360023..f913f62eb6c3 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -91,7 +91,6 @@ unsigned int kvm_arch_para_hints(void);
>   void kvm_async_pf_task_wait(u32 token, int interrupt_kernel);
>   void kvm_async_pf_task_wake(u32 token);
>   u32 kvm_read_and_reset_pf_reason(void);
> -extern void kvm_disable_steal_time(void);
>   void do_async_page_fault(struct pt_regs *regs, unsigned long error_code, unsigned long address);
>   
>   #ifdef CONFIG_PARAVIRT_SPINLOCKS
> @@ -125,11 +124,6 @@ static inline u32 kvm_read_and_reset_pf_reason(void)
>   {
>   	return 0;
>   }
> -
> -static inline void kvm_disable_steal_time(void)
> -{
> -	return;
> -}
>   #endif
>   
>   #endif /* _ASM_X86_KVM_PARA_H */
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index d6f04d32dec0..6ff2c7cac4c4 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -34,6 +34,7 @@
>   #include <asm/apicdef.h>
>   #include <asm/hypervisor.h>
>   #include <asm/tlb.h>
> +#include <asm/reboot.h>
>   
>   static int kvmapf = 1;
>   
> @@ -352,6 +353,14 @@ static void kvm_pv_disable_apf(void)
>   	       smp_processor_id());
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
> @@ -394,14 +403,6 @@ static u64 kvm_steal_clock(int cpu)
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
> @@ -429,13 +430,14 @@ static void __init sev_map_percpu_data(void)
>   	}
>   }
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
> @@ -573,7 +575,7 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
>   	unsigned long flags;
>   
>   	local_irq_save(flags);
> -	kvm_guest_cpu_offline();
> +	kvm_guest_cpu_offline(false);
>   	local_irq_restore(flags);
>   	return 0;
>   }
> @@ -582,7 +584,7 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
>   
>   static int kvm_suspend(void)
>   {
> -	kvm_guest_cpu_offline();
> +	kvm_guest_cpu_offline(false);
>   
>   	return 0;
>   }
> @@ -597,6 +599,20 @@ static struct syscore_ops kvm_syscore_ops = {
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
>   static void __init kvm_apf_trap_init(void)
>   {
>   	update_intr_gate(X86_TRAP_PF, async_page_fault);
> @@ -673,6 +689,10 @@ static void __init kvm_guest_init(void)
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
> index bd3962953f78..4a0802af2e3e 100644
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
> @@ -197,23 +196,6 @@ static void kvm_setup_secondary_clock(void)
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
> @@ -344,9 +326,6 @@ void __init kvmclock_init(void)
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


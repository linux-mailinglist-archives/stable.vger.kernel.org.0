Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0293963F2
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 17:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhEaPlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:41:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38212 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234810AbhEaPkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 11:40:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622475502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bVMdCyMtdTKKusaIm7OQka5RMMLVYzl2wB1TiD5Xc2k=;
        b=CbpIfp1vUCSfDKN4I1f527YA/YbSXTKz7fdfdJtF5Hs7fS+e9RmEWML/07xrsah6VQl73G
        CfDYpkXO6371b1vWoGDOrAGGWb4JLTULbR/CkjbcELJ2D2iEIlJTZWycN25NiIvFX9MA91
        jUzZdQa9anf+KybADJ7s+fwTTZpOjJ8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-JZc_1bIdOpyIklCdd8Qixg-1; Mon, 31 May 2021 11:38:21 -0400
X-MC-Unique: JZc_1bIdOpyIklCdd8Qixg-1
Received: by mail-ed1-f70.google.com with SMTP id s20-20020a0564025214b029038752a2d8f3so6382766edd.2
        for <stable@vger.kernel.org>; Mon, 31 May 2021 08:38:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bVMdCyMtdTKKusaIm7OQka5RMMLVYzl2wB1TiD5Xc2k=;
        b=VuNcFpQjRe1YPS9D3w8kS6UgW0UTdjMZiCJvQXQ4/Ar9bAKfE94GqHPI/9g1vSbiFm
         1O0rSILM4XF3SmIOXFet/SwI6ZinWQ36Sp5qxM47Ww8lmG8YM+ZC6j8v79Z6pBXmpVHn
         KI6PtqIhtQNkH7WsI2t9gfQhJB+DCZ7xPqPnMNfXS9JFt5Z+MTyBreOipXrAh5Kzu8Py
         9hH66MERtJjxcOonI2IEIbaKvlnpEf0QWgZue7isfi3WKhFqTrEYQ1ZcnRj2jZtU71P+
         eHS80yueNEiqoDZTrPyppmX1uxJTlHlqpykVUlmlHBForPMU68AlUIdQDupgIdGaLq0+
         obTQ==
X-Gm-Message-State: AOAM531EOX+AjpYubUU9bAbcEDWNT13mnbeDpnqqweJ0HgPns/MFHfqN
        ixDdfEZXJ+NkyIla32eGfDex1LXQC/5H/WGM+qJ83XTXOx4s8a9j+Lqc1os2LdRmjUJmr9ajwoZ
        Ck6AImjCHI4EQJUTp
X-Received: by 2002:a17:906:2bc6:: with SMTP id n6mr17249093ejg.256.1622475499664;
        Mon, 31 May 2021 08:38:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxm2c50zdg3zhxdIVCuZ/++yTzcNu5IJZbYuFrDqhZDtdIDomUtdQV4FzPS+74AEq5jZ4W8hQ==
X-Received: by 2002:a17:906:2bc6:: with SMTP id n6mr17249078ejg.256.1622475499507;
        Mon, 31 May 2021 08:38:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o64sm6020918eda.83.2021.05.31.08.38.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 08:38:18 -0700 (PDT)
Subject: Re: [PATCH v3 | stable v5.4 2/3] x86/kvm: Disable kvmclock on all
 CPUs on shutdown
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210531140347.42681-1-krzysztof.kozlowski@canonical.com>
 <20210531140347.42681-3-krzysztof.kozlowski@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4ed2d57b-7918-1c24-b3b6-39fd0d6cf2b3@redhat.com>
Date:   Mon, 31 May 2021 17:38:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210531140347.42681-3-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31/05/21 16:03, Krzysztof Kozlowski wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> commit c02027b5742b5aa804ef08a4a9db433295533046 upstream.
> 
> Currenly, we disable kvmclock from machine_shutdown() hook and this
> only happens for boot CPU. We need to disable it for all CPUs to
> guard against memory corruption e.g. on restore from hibernate.
> 
> Note, writing '0' to kvmclock MSR doesn't clear memory location, it
> just prevents hypervisor from updating the location so for the short
> while after write and while CPU is still alive, the clock remains usable
> and correct so we don't need to switch to some other clocksource.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20210414123544.1060604-4-vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>   arch/x86/include/asm/kvm_para.h | 4 ++--
>   arch/x86/kernel/kvm.c           | 1 +
>   arch/x86/kernel/kvmclock.c      | 5 +----
>   3 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 9b4df6eaa11a..a617fd360023 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -6,8 +6,6 @@
>   #include <asm/alternative.h>
>   #include <uapi/asm/kvm_para.h>
>   
> -extern void kvmclock_init(void);
> -
>   #ifdef CONFIG_KVM_GUEST
>   bool kvm_check_and_clear_guest_paused(void);
>   #else
> @@ -85,6 +83,8 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
>   }
>   
>   #ifdef CONFIG_KVM_GUEST
> +void kvmclock_init(void);
> +void kvmclock_disable(void);
>   bool kvm_para_available(void);
>   unsigned int kvm_arch_para_features(void);
>   unsigned int kvm_arch_para_hints(void);
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 82a2756e0ef8..d6f04d32dec0 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -436,6 +436,7 @@ static void kvm_guest_cpu_offline(void)
>   		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
>   	kvm_pv_disable_apf();
>   	apf_task_wake_all();
> +	kvmclock_disable();
>   }
>   
>   static int kvm_cpu_online(unsigned int cpu)
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 904494b924c1..bd3962953f78 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -214,11 +214,9 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
>   }
>   #endif
>   
> -static void kvm_shutdown(void)
> +void kvmclock_disable(void)
>   {
>   	native_write_msr(msr_kvm_system_time, 0, 0);
> -	kvm_disable_steal_time();
> -	native_machine_shutdown();
>   }
>   
>   static void __init kvmclock_init_mem(void)
> @@ -346,7 +344,6 @@ void __init kvmclock_init(void)
>   #endif
>   	x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
>   	x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
> -	machine_ops.shutdown  = kvm_shutdown;
>   #ifdef CONFIG_KEXEC_CORE
>   	machine_ops.crash_shutdown  = kvm_crash_shutdown;
>   #endif
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


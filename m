Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA213963EF
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 17:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbhEaPkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:40:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25058 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234444AbhEaPjP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 11:39:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622475445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YwRXfWjrxYK9Y84Eg/D6Foi/lMqmaHTjbxdXaDwY3uk=;
        b=V2fuK6W9DIEBR3G+CzKtPhsupOjIOCRtZvPAwwz0SXuFiWnm8kSwtabMtbU1AsMdhahYK0
        lqwIi/r2O9oYhG4VkLbBe5//PokwXEce8Vyj987NMU70jMOCHIgMpsh37AsPDh3mmT9Uhc
        g3efdCnVWboJUZ8n4Yi2ZxoGpd+/Tos=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-vQ6jptDkOFaG1msVp87lug-1; Mon, 31 May 2021 11:37:21 -0400
X-MC-Unique: vQ6jptDkOFaG1msVp87lug-1
Received: by mail-ej1-f69.google.com with SMTP id f1-20020a1709064941b02903f6b5ef17bfso262417ejt.20
        for <stable@vger.kernel.org>; Mon, 31 May 2021 08:37:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YwRXfWjrxYK9Y84Eg/D6Foi/lMqmaHTjbxdXaDwY3uk=;
        b=tsIYyWY8/8AfuS0H0hSm56puE2c8lZQz+C88UWdEOKwycVaGJNOiBMBuOmjoPnIKDA
         MFXpXVerqqtvwmpbxOUY9YePiN/Ueg6TqDFuTm9/dnyxanDMKnR5NOeEGJyCSS7pPkJ6
         K5XHLsg7LeBXMKzJrBcq9Ym1aOR1+fk7fGRKK3L+xiPk8dgJiPJ2QMhgDMgl3ggYvbZK
         sqBrXIROZd/+gT6N7oWsFBdeDJJY5nIm04EjD8KGSVs7bqjuz7vw13C1+uNLXxQbpmOf
         etbSlqEp2MMbcyFydocIod06oLjriG0npAEl2TqhA0W2Zz4pERz29sZ5yGcmUXDmDZKI
         4gyA==
X-Gm-Message-State: AOAM533x87l1aubU34ATyks0MJw8HcdXif5bTA9N4+D+m04erhZAZbi6
        jEh+UUQ2/096MOWKlDGbZ8vVjA7wAV0io2jtiij9Ed6gjpK5q56ZfdOefdCctyb5VFVzQ/OCgF9
        hN93q9/Qoivt/fj/Y
X-Received: by 2002:a17:906:365a:: with SMTP id r26mr14583312ejb.340.1622475440712;
        Mon, 31 May 2021 08:37:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOyvrU05/63C7HwZCpW38F1gh4JXf2DYk2FBsuy6DpJpsS+ORIHpxhLpKFwFn0J1vJbcIwMg==
X-Received: by 2002:a17:906:365a:: with SMTP id r26mr14583298ejb.340.1622475440542;
        Mon, 31 May 2021 08:37:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e22sm7312716edu.35.2021.05.31.08.37.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 08:37:19 -0700 (PDT)
Subject: Re: [PATCH v3 | stable v5.4 1/3] x86/kvm: Teardown PV features on
 boot CPU as well
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210531140347.42681-1-krzysztof.kozlowski@canonical.com>
 <20210531140347.42681-2-krzysztof.kozlowski@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a6b79959-c988-576e-75ee-047ee3f6f8cb@redhat.com>
Date:   Mon, 31 May 2021 17:37:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210531140347.42681-2-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31/05/21 16:03, Krzysztof Kozlowski wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> commit 8b79feffeca28c5459458fe78676b081e87c93a4 upstream.
> 
> Various PV features (Async PF, PV EOI, steal time) work through memory
> shared with hypervisor and when we restore from hibernation we must
> properly teardown all these features to make sure hypervisor doesn't
> write to stale locations after we jump to the previously hibernated kernel
> (which can try to place anything there). For secondary CPUs the job is
> already done by kvm_cpu_down_prepare(), register syscore ops to do
> the same for boot CPU.
> 
> Krzysztof:
> This fixes memory corruption visible after second resume from
> hibernation:
> 
>    BUG: Bad page state in process dbus-daemon  pfn:18b01
>    page:ffffea000062c040 refcount:0 mapcount:0 mapping:0000000000000000 index:0x1 compound_mapcount: -30591
>    flags: 0xfffffc0078141(locked|error|workingset|writeback|head|mappedtodisk|reclaim)
>    raw: 000fffffc0078141 dead0000000002d0 dead000000000100 0000000000000000
>    raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
>    page dumped because: PAGE_FLAGS_CHECK_AT_PREP flag set
>    bad because of flags: 0x78141(locked|error|workingset|writeback|head|mappedtodisk|reclaim)
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20210414123544.1060604-3-vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> [krzysztof: Extend the commit message]
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>   arch/x86/kernel/kvm.c | 57 +++++++++++++++++++++++++++++++------------
>   1 file changed, 41 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index e820568ed4d5..82a2756e0ef8 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -24,6 +24,7 @@
>   #include <linux/debugfs.h>
>   #include <linux/nmi.h>
>   #include <linux/swait.h>
> +#include <linux/syscore_ops.h>
>   #include <asm/timer.h>
>   #include <asm/cpu.h>
>   #include <asm/traps.h>
> @@ -428,6 +429,25 @@ static void __init sev_map_percpu_data(void)
>   	}
>   }
>   
> +static void kvm_guest_cpu_offline(void)
> +{
> +	kvm_disable_steal_time();
> +	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> +		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
> +	kvm_pv_disable_apf();
> +	apf_task_wake_all();
> +}
> +
> +static int kvm_cpu_online(unsigned int cpu)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	kvm_guest_cpu_init();
> +	local_irq_restore(flags);
> +	return 0;
> +}
> +
>   #ifdef CONFIG_SMP
>   #define KVM_IPI_CLUSTER_SIZE	(2 * BITS_PER_LONG)
>   
> @@ -547,31 +567,34 @@ static void __init kvm_smp_prepare_boot_cpu(void)
>   	kvm_spinlock_init();
>   }
>   
> -static void kvm_guest_cpu_offline(void)
> +static int kvm_cpu_down_prepare(unsigned int cpu)
>   {
> -	kvm_disable_steal_time();
> -	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> -		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
> -	kvm_pv_disable_apf();
> -	apf_task_wake_all();
> -}
> +	unsigned long flags;
>   
> -static int kvm_cpu_online(unsigned int cpu)
> -{
> -	local_irq_disable();
> -	kvm_guest_cpu_init();
> -	local_irq_enable();
> +	local_irq_save(flags);
> +	kvm_guest_cpu_offline();
> +	local_irq_restore(flags);
>   	return 0;
>   }
>   
> -static int kvm_cpu_down_prepare(unsigned int cpu)
> +#endif
> +
> +static int kvm_suspend(void)
>   {
> -	local_irq_disable();
>   	kvm_guest_cpu_offline();
> -	local_irq_enable();
> +
>   	return 0;
>   }
> -#endif
> +
> +static void kvm_resume(void)
> +{
> +	kvm_cpu_online(raw_smp_processor_id());
> +}
> +
> +static struct syscore_ops kvm_syscore_ops = {
> +	.suspend	= kvm_suspend,
> +	.resume		= kvm_resume,
> +};
>   
>   static void __init kvm_apf_trap_init(void)
>   {
> @@ -649,6 +672,8 @@ static void __init kvm_guest_init(void)
>   	kvm_guest_cpu_init();
>   #endif
>   
> +	register_syscore_ops(&kvm_syscore_ops);
> +
>   	/*
>   	 * Hard lockup detection is enabled by default. Disable it, as guests
>   	 * can get false positives too easily, for example if the host is
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


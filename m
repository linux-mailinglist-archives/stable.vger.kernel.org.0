Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD62396417
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 17:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbhEaPqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:46:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23249 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233284AbhEaPoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 11:44:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622475742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J1P99hzECAG2LO8GEqZPHteEu65MWrpU8LHHbDVM2bc=;
        b=KhBX18jYJNvZ5Xe5swyxSI5b8ffbqehLxORPGlqY5eMMzu3z5yBic+3SoVMOC+MHjIPOru
        06c6RpSlasTCDa+yKDcBZS2ki3cRkCwZikaD1ZLdC+KXlPnFgS6SkkcXr81IZE6TlyjlkF
        Rq4EOcWG4u4C7gQQ39IG+AzOQjomiBk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-Qy2PA1VtMDC58M-WrvWIZg-1; Mon, 31 May 2021 11:42:21 -0400
X-MC-Unique: Qy2PA1VtMDC58M-WrvWIZg-1
Received: by mail-ed1-f70.google.com with SMTP id c21-20020a0564021015b029038c3f08ce5aso6417175edu.18
        for <stable@vger.kernel.org>; Mon, 31 May 2021 08:42:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J1P99hzECAG2LO8GEqZPHteEu65MWrpU8LHHbDVM2bc=;
        b=VJFZKzqxqez7zaW5T59+PSUNJveo19D3iPQ3mhgAVqfB0wGlaGy61Eo0WCX8016SnJ
         rZ60szy06aTpCWYcN8B4ky2Vi+0/1YEfgxdLjXZKHwj0G+LiC+oj/ygqrsJ+6gaUPisr
         PiX6ATYiJInkmTKOSc6T7Cqr4pytR2rf+hlYWpJEQecuzKFPKJyF6jWlrIOSz4rNdUXE
         9YOZ+5mXYW5+SVjoepgaDO2I6SXpNDRNxE7u9TwLpR8XgZlO6b41Zi8/np5JnjqRhhrQ
         c+XPQ1IeUxfj/r7XRnjKUeXeDLquF3lNpBM75G+aSyi9p2wuBxyydHdCgEsb+Xw8iZ0z
         czxw==
X-Gm-Message-State: AOAM532DZKziCnWZqSdbAe0pTWfdwBJYe26JRVEJbil+V0YZQL3sa8cl
        MKdxC5xPwsQ+oqsrz4lM4EPb1z5dGvd8mejthZ/MUwgozt8ysRFxD2ImHkhMtpkTQWNlJJk+Lpn
        9bAVNR2C+/zSO+AML
X-Received: by 2002:a05:6402:3551:: with SMTP id f17mr25998961edd.313.1622475740088;
        Mon, 31 May 2021 08:42:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzja+sSQyMtDFIF//0azDQNDpHipzhgcIb3A+xb2glhBze97oAjKXk6yude+UyxtUucqX3WRA==
X-Received: by 2002:a05:6402:3551:: with SMTP id f17mr25998945edd.313.1622475739903;
        Mon, 31 May 2021 08:42:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gx23sm6202354ejb.125.2021.05.31.08.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 08:42:19 -0700 (PDT)
Subject: Re: [PATCH v3 | stable v5.10 1/3] x86/kvm: Teardown PV features on
 boot CPU as well
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210531140526.42932-1-krzysztof.kozlowski@canonical.com>
 <20210531140526.42932-2-krzysztof.kozlowski@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0a96e347-aa80-b8c2-59f3-db1a14fae7c1@redhat.com>
Date:   Mon, 31 May 2021 17:42:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210531140526.42932-2-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31/05/21 16:05, Krzysztof Kozlowski wrote:
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
> [krzysztof: Extend the commit message, adjust for v5.10 context]
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>   arch/x86/kernel/kvm.c | 57 +++++++++++++++++++++++++++++++------------
>   1 file changed, 41 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 7f57ede3cb8e..6af3f9c3956c 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -26,6 +26,7 @@
>   #include <linux/kprobes.h>
>   #include <linux/nmi.h>
>   #include <linux/swait.h>
> +#include <linux/syscore_ops.h>
>   #include <asm/timer.h>
>   #include <asm/cpu.h>
>   #include <asm/traps.h>
> @@ -460,6 +461,25 @@ static bool pv_tlb_flush_supported(void)
>   
>   static DEFINE_PER_CPU(cpumask_var_t, __pv_cpu_mask);
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
>   
>   static bool pv_ipi_supported(void)
> @@ -587,31 +607,34 @@ static void __init kvm_smp_prepare_boot_cpu(void)
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
>   static void kvm_flush_tlb_others(const struct cpumask *cpumask,
>   			const struct flush_tlb_info *info)
> @@ -681,6 +704,8 @@ static void __init kvm_guest_init(void)
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


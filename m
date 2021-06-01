Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E35396EB1
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 10:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhFAIUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 04:20:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27204 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233088AbhFAIUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 04:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622535537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=luHofvlOpKui1GNWZ63TEsBp2SL1jenwY1eGBpPATcg=;
        b=aRxd7A0CrPVCtyi+qB9g6TyVfsyJoz5MQhL5IimGcvJbxsmC48/hsCw/8d7Ucxg/M+zh7g
        wThkci30RTx8FbYhDfSFcc+Zds3SQqjBZAPOHTHxNT0HN/LapdRw6T+J8Y2tD1kzVHtzYc
        yJpwll2g76gO3E9t2dWLI+gU+UUuLK4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-4GHr8cHiNru3ojeazBClGA-1; Tue, 01 Jun 2021 04:18:56 -0400
X-MC-Unique: 4GHr8cHiNru3ojeazBClGA-1
Received: by mail-ej1-f71.google.com with SMTP id h18-20020a1709063992b02903d59b32b039so3073481eje.12
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 01:18:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=luHofvlOpKui1GNWZ63TEsBp2SL1jenwY1eGBpPATcg=;
        b=eR9X1CM50uRMw2ccHpqND7kHUIAEwcHCFK6+gFEF9zbJnA4Jet++G8rbGA4gUmzHhk
         p51f0LMk/OEkEb0y7YXQ7btDM99uOhzjx4qX7fGBziqSOq20gRDSZ+w6eQuZVRTTEeDH
         eOPOkSa1YD9AfKM1uXHU8tYB+6XxWdpL7CjGNE/SBPFfwGXuNYDCRIXk5Ze7PUfd47Tt
         mKOMHQM8de/R+wF6RkB2Ls8Hzun8CKq9amIjJM4XPbspWUopYebFFcHCLk+oKqixY2cR
         EOp2M3v0c+PBCssX4qnzpEyfd8o4P60i01Bzxe0C5x+p/NlNgJTnw+N0WeL+cXwE+9EK
         62Gw==
X-Gm-Message-State: AOAM532EgSQNNuXvOyeMBPWnxVZjbsqOxWSXGnZdViMaXSDuR0s8jgx/
        +dpYNYBKfoqxHKx2UGYgmbip88DuGx/yFR5iBBEv5uvOHojC+T1VqjLNf7PBaoHR5RyHa7lMNyj
        ynBIpG6QbGcWHsEcQ
X-Received: by 2002:a17:906:c14c:: with SMTP id dp12mr27561794ejc.312.1622535535009;
        Tue, 01 Jun 2021 01:18:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6trG4pPgpraD0bcLLugyhWa2Yf2AGeHXPpw2r0jOWTtFazKW8C5Y2oWB+OfbzFSP4Ic53cQ==
X-Received: by 2002:a17:906:c14c:: with SMTP id dp12mr27561775ejc.312.1622535534764;
        Tue, 01 Jun 2021 01:18:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f10sm4437719edx.60.2021.06.01.01.18.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 01:18:54 -0700 (PDT)
Subject: Re: [PATCH v3 | stable v5.12 1/3] x86/kvm: Teardown PV features on
 boot CPU as well
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210601071644.6055-1-krzysztof.kozlowski@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a93cd5cb-7112-f13a-a34c-bf3ec6a645f4@redhat.com>
Date:   Tue, 1 Jun 2021 10:18:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210601071644.6055-1-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/06/21 09:16, Krzysztof Kozlowski wrote:
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
> index 78bb0fae3982..5ae57be19187 100644
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


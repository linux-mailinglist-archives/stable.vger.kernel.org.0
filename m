Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E444396418
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 17:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhEaPqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:46:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51146 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233308AbhEaPoG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 11:44:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622475746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/r/0Q5nxjBppI+2zHYvIoy7on9Wwj4hvZ2i0fuW+bYc=;
        b=IR2Mp6Fxxp1syTM/ktrI+kjK9nF+mnShE+yftIboMJBt3PIZ39PTfW2d4/WWnkxGNUroP9
        YuiNZC35fcHa7PD3z03HyJQ/wIhegDu4OflS1cZaBH/C9eMfiocUsPt9m79gdpjlx9LskY
        HX6TXIIPHx28dSryTWfSs/sppZYWLnM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-Uw7X6eVRNYiNWOV-2fIaug-1; Mon, 31 May 2021 11:42:25 -0400
X-MC-Unique: Uw7X6eVRNYiNWOV-2fIaug-1
Received: by mail-wr1-f69.google.com with SMTP id g14-20020a5d698e0000b0290117735bd4d3so170018wru.13
        for <stable@vger.kernel.org>; Mon, 31 May 2021 08:42:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/r/0Q5nxjBppI+2zHYvIoy7on9Wwj4hvZ2i0fuW+bYc=;
        b=To2JuDNWFsVOof+OcJ5rcoahl3Xl+uyO3LE/SY2vCqX1/oqXpuF7730yCgRyD9rCAT
         GwtPKd/bT1RcJgh6oBAlc0Sy8bMrZSanUS0OYGc6i7XR6Ta6NLszjGOz20JK6OnvxJfz
         V7ry4odmuj3p3hVfTTukTR55pjGdbi0I/0lSQ86G1iGOKckIbJHEqiJp6nG8bTWv0+MR
         5CHxtKX/PcQSGPa3DGSl2Jb3HGH4G4tVWQXWN9nP3W1Axra/i/IQjOLnEH89Uts5RsmV
         fH+AIEE5SBv4amgUFgrsJ0W++Icfc1gWn3ALrTh42NetUgQnHcNvMCR+dhPvplZ0aHmu
         KTyQ==
X-Gm-Message-State: AOAM5331DZTc/qTI98VQsGrqArHM+/dM6Y9gkF+hYeniyytpol3z/c+H
        6NVXNzvuXBgG/9/N+4jI37soU8gOJkw/2Yez17VKf4EGblwk3GpZNGW4ncqVcuj28qcmQdUAcxO
        it1eAlQzQEm2wdJPc
X-Received: by 2002:a5d:6701:: with SMTP id o1mr23458244wru.390.1622475744283;
        Mon, 31 May 2021 08:42:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmoKQ68kh9pWXFDBTbwSkwp4OpC4Htfkp26y1lHfoaETlb0f2ar7+RGYuZKfwSnYUIeYoP2w==
X-Received: by 2002:a5d:6701:: with SMTP id o1mr23458232wru.390.1622475744129;
        Mon, 31 May 2021 08:42:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d17sm112331wrg.26.2021.05.31.08.42.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 08:42:23 -0700 (PDT)
Subject: Re: [PATCH v3 | stable v5.10 2/3] x86/kvm: Disable kvmclock on all
 CPUs on shutdown
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210531140526.42932-1-krzysztof.kozlowski@canonical.com>
 <20210531140526.42932-3-krzysztof.kozlowski@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f9d415bc-ca6b-c028-5d90-dbe0f6fd633a@redhat.com>
Date:   Mon, 31 May 2021 17:42:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210531140526.42932-3-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31/05/21 16:05, Krzysztof Kozlowski wrote:
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
> index 338119852512..9c56e0defd45 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -7,8 +7,6 @@
>   #include <linux/interrupt.h>
>   #include <uapi/asm/kvm_para.h>
>   
> -extern void kvmclock_init(void);
> -
>   #ifdef CONFIG_KVM_GUEST
>   bool kvm_check_and_clear_guest_paused(void);
>   #else
> @@ -86,6 +84,8 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
>   }
>   
>   #ifdef CONFIG_KVM_GUEST
> +void kvmclock_init(void);
> +void kvmclock_disable(void);
>   bool kvm_para_available(void);
>   unsigned int kvm_arch_para_features(void);
>   unsigned int kvm_arch_para_hints(void);
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 6af3f9c3956c..be1c42e663c6 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -468,6 +468,7 @@ static void kvm_guest_cpu_offline(void)
>   		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
>   	kvm_pv_disable_apf();
>   	apf_task_wake_all();
> +	kvmclock_disable();
>   }
>   
>   static int kvm_cpu_online(unsigned int cpu)
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 5ee705b44560..327a0de01066 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -221,11 +221,9 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
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
> @@ -352,7 +350,6 @@ void __init kvmclock_init(void)
>   #endif
>   	x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
>   	x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
> -	machine_ops.shutdown  = kvm_shutdown;
>   #ifdef CONFIG_KEXEC_CORE
>   	machine_ops.crash_shutdown  = kvm_crash_shutdown;
>   #endif
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


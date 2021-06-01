Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15E3396EB6
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 10:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbhFAIUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 04:20:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26584 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233295AbhFAIUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 04:20:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622535553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AjeIHW5GBq8wBGrlWDRGcAskr9em/09WJVL20sAlcxI=;
        b=QqXBnIVoSkojQX/UaSgGIVp+L+B54pS+T2/aeMKFlV3EGg4cgDF/xsn2rb2BsMvDBWq8Tf
        xX4J7nl8mcHrwpfecho5zpmEwrYjpGKiB1OP5g5pv7OhL8NdmlOCkXXW/073MxbwgK9rqF
        0opDAgilI/E2hnDKakwTLka+Yw414iw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-_7badSCjPp2awIHP-xQ-MQ-1; Tue, 01 Jun 2021 04:19:12 -0400
X-MC-Unique: _7badSCjPp2awIHP-xQ-MQ-1
Received: by mail-ej1-f70.google.com with SMTP id am5-20020a1709065685b02903eef334e563so1407307ejc.2
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 01:19:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AjeIHW5GBq8wBGrlWDRGcAskr9em/09WJVL20sAlcxI=;
        b=gPa/kYrYUCONYzXfOpEKM8r5UrSXBjDSDZQZaKF3DB8iQDIjmS+Qev58lQznIckvLG
         KyCk93rJqlAXMWkko+d8taPP9bkHUYbSn2SkaS3KK54pK7GU3CrL5h/yxyvJGlXJmt3i
         +BPeNsf+vE3jvUFecNcE2yRIi7MgQXczyCDRScZ95KzSRewN2gHCWVjIKi9M1KVd3eq9
         8PFzvY6dDZSHIRIqOQfKr6sU8C9G766bXwLKlGoV3JVcvxJDtBXzdE+xUyEPaMhyxJDX
         nXr0tV9Y1aqmUW3f3FVsaLuRKCI1ipZ8ynYTzHwlQfoShL2rTmZV+L+bd3U6PyzdLmKD
         /zag==
X-Gm-Message-State: AOAM532cin0gXXgvBqvpLnPucfMLlWLdywudMttx3cKi09a85hdjaO0e
        L9m0xAbcCfANNo7qQI/qG4Sf1fafvNiTE+pWyCOSAC5O2gcAobQU/H8jZCXG9gqQzdyjGYEBZKk
        mhPYOugiodIhlXDII
X-Received: by 2002:a17:906:7052:: with SMTP id r18mr27515630ejj.449.1622535551575;
        Tue, 01 Jun 2021 01:19:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGoS71gu5xYQzgz+GlpqiPBWi3/U00yrDURKmqtqd3X7BI11sRwQkc6CPmkVMiSDBSitONSg==
X-Received: by 2002:a17:906:7052:: with SMTP id r18mr27515612ejj.449.1622535551397;
        Tue, 01 Jun 2021 01:19:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u21sm260100ejm.89.2021.06.01.01.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 01:19:10 -0700 (PDT)
Subject: Re: [PATCH v3 | stable v5.12 2/3] x86/kvm: Disable kvmclock on all
 CPUs on shutdown
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        stable@vger.kernel.org
Cc:     Andrea Righi <andrea.righi@canonical.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210601071644.6055-1-krzysztof.kozlowski@canonical.com>
 <20210601071644.6055-2-krzysztof.kozlowski@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d531d404-ad7b-615c-2e87-31506ecf466c@redhat.com>
Date:   Tue, 1 Jun 2021 10:19:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210601071644.6055-2-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/06/21 09:16, Krzysztof Kozlowski wrote:
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
> index 5ae57be19187..2ebb93c34bc5 100644
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
> index 1fc0962c89c0..cf869de98eec 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -220,11 +220,9 @@ static void kvm_crash_shutdown(struct pt_regs *regs)
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
> @@ -351,7 +349,6 @@ void __init kvmclock_init(void)
>   #endif
>   	x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
>   	x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
> -	machine_ops.shutdown  = kvm_shutdown;
>   #ifdef CONFIG_KEXEC_CORE
>   	machine_ops.crash_shutdown  = kvm_crash_shutdown;
>   #endif
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


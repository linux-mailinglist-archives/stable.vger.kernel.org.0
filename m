Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FFF3A45C1
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 17:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhFKP4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 11:56:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230155AbhFKP4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 11:56:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623426843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K/W9sou9gDRpHUzvlAgo/d0h0bEb4aG6pesxj4+DQaY=;
        b=P9VanDl3dI6xiCvnXoW2XldUnSIWxN6zY0Zju9erEDVGz1Mqs3DKcn/Qn+30jPSEcPXtd/
        yrRD9AYhxpuGnVtj16R/qaeqYuLZGMi1JYrC738Etc1OMbYQBz7OaVNcxJB4DiwFtZl4L2
        VSk6eVuZbIKk+I9RrzqHLfsfjLZWkVY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-P16Ze2HPN0CLVoLy_rgtKQ-1; Fri, 11 Jun 2021 11:54:02 -0400
X-MC-Unique: P16Ze2HPN0CLVoLy_rgtKQ-1
Received: by mail-wr1-f70.google.com with SMTP id g14-20020a5d698e0000b0290117735bd4d3so2798750wru.13
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 08:54:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K/W9sou9gDRpHUzvlAgo/d0h0bEb4aG6pesxj4+DQaY=;
        b=ipK83dCizPQgfA0byONEvRETvpeX9Xrn6HL6mzA3bAVyJGd0rWjhWJvC87OO3TFcWV
         YhGm4hijL82DWxJn+yjhrTy/mAS6JnBcbK+EifyRrsr8Eqb3uzFaCJqVG7jnynO3lA+u
         lK7vMpkLsXjESHGY4mU1YKCt1xkF/Xzwj7LfGIBYKluaIsZOykma2omeMKWPeF6KEVmG
         sx1ZayG65G/vqZGjUqSspaiizQ1HeeZnwUh1g+KsQdxsv+5lEcGq5Sas6v7aitsQWBlC
         SYqmR6I3bYlhwdZ3uWidHbnLTbA6lEUt06q82x6Lihp7v4PuYtebwLq27eZ+/qSsS0/z
         Yf6w==
X-Gm-Message-State: AOAM532EKZOm6oODlBB9sMVcx5Kito0Dq9YbRDZQOmd91ijWdvWjQJKI
        PrKMqzSNPmuMK7HllLqV1M8IgUkBPbvOPYBotwZA6k7ZL2ZFxAH2+HqKxCsCycBkWZlsne4MQeP
        GgYfdJ3r/CNq0LhloGYPq0w1JmknTViuZh3rzf90Jh9OAH351RU9ICqfRBRioU/YyDEe5
X-Received: by 2002:a7b:c189:: with SMTP id y9mr4664414wmi.106.1623426840903;
        Fri, 11 Jun 2021 08:54:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZCst0fXPSfny8EGVNzM5i2LQfg5owSCBUWeIsLcOMd7YqAYkLzgvGWGmqL3W6popgFe4ebA==
X-Received: by 2002:a7b:c189:: with SMTP id y9mr4664390wmi.106.1623426840602;
        Fri, 11 Jun 2021 08:54:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b135sm13410912wmb.5.2021.06.11.08.53.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 08:53:59 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Fix x86_emulator slab cache leak
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
References: <1623387573-5969-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2ea05111-1598-f82c-e868-0615bc003612@redhat.com>
Date:   Fri, 11 Jun 2021 17:53:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1623387573-5969-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/06/21 06:59, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Commit c9b8b07cded58 (KVM: x86: Dynamically allocate per-vCPU emulation context)
> tries to allocate per-vCPU emulation context dynamically, however, the
> x86_emulator slab cache is still exiting after the kvm module is unload
> as below after destroying the VM and unloading the kvm module.
> 
> grep x86_emulator /proc/slabinfo
> x86_emulator          36     36   2672   12    8 : tunables    0    0    0 : slabdata      3      3      0
> 
> This patch fixes this slab cache leak by destroying the x86_emulator slab cache
> when the kvm module is unloaded.
> 
> Fixes: c9b8b07cded58 (KVM: x86: Dynamically allocate per-vCPU emulation context)
> Cc: stable@vger.kernel.org
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>   arch/x86/kvm/x86.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6d3955a6a763..fe26f33e8782 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8258,6 +8258,7 @@ void kvm_arch_exit(void)
>   	kvm_x86_ops.hardware_enable = NULL;
>   	kvm_mmu_module_exit();
>   	free_percpu(user_return_msrs);
> +	kmem_cache_destroy(x86_emulator_cache);
>   	kmem_cache_destroy(x86_fpu_cache);
>   #ifdef CONFIG_KVM_XEN
>   	static_key_deferred_flush(&kvm_xen_enabled);
> 

Queued, thanks

Paolo


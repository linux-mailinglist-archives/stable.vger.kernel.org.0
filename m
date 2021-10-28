Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFBA43E13D
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 14:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhJ1MvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 08:51:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50789 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229578AbhJ1MvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Oct 2021 08:51:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635425319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c6G/II7fL4gELJ4h9W5hS038cvePCeWjBA3QvVbg4gs=;
        b=a4HfW4u7YzrORV/8JTuuFiPZ7/D2JX83/Nj+tZKOuq1mOgsnwvBTga9AMGf+UvLBM6tjju
        4nYFvRAcSFzS460l0fnGDO4J4iGCk4VYWo2tyrpyeyYu0ftxIyTEReTyR4Og5vOX5u3PnW
        5mXkf/exxcNMEXaJd3a8L/vNIjB6eHE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-PWlLoxDKOiKoWKkAVYze-w-1; Thu, 28 Oct 2021 08:48:38 -0400
X-MC-Unique: PWlLoxDKOiKoWKkAVYze-w-1
Received: by mail-wm1-f71.google.com with SMTP id p18-20020a05600c205200b0032ccb9d9f76so1974092wmg.8
        for <stable@vger.kernel.org>; Thu, 28 Oct 2021 05:48:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=c6G/II7fL4gELJ4h9W5hS038cvePCeWjBA3QvVbg4gs=;
        b=NVxVh+jl206sLEiyroFDgcJ/+opwB7HgEi086twlFQuZLoP/puzmr24bkxLUjAb6qC
         5p7Ex7rCL5YVb7TmYPSWCo10n/CP65C53i2wKsEBtJMk8zjhVfTtCFC/1xUxUieU+H3c
         Zb0f3B0Y3HEAGM87yyKdmyTq7SQ1svBs5qsjeTa9Q0IVljriP9ajgRhWDJdDBF4pab4f
         icJdoYt0JyvuOd8AR3dm4r4rXwPmLyfvIqtS6HvZ2A3FuKH7Hivn0TiF8/PUCQngOCgo
         k+8esZpbU/W6OSaW8AAc+MSnDCKa2rMS3sv7jsl/b3U9ORbOQb/931ZFfRjMGNUF6rXq
         9czg==
X-Gm-Message-State: AOAM530OGXmiApSjisV7A9nzRS++C4X8MGzFarniOMAg/ihZIKoLzNSm
        OnS8s/HDbAHYmasma+ngzusjUIxpeQx35Q1UnAnP2AMiiLhrLVUMo1GI+bp2jlxNxVOmYdILa2j
        Amzuupd/f8mXQZ4Rc
X-Received: by 2002:a5d:494d:: with SMTP id r13mr5398473wrs.222.1635425316779;
        Thu, 28 Oct 2021 05:48:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyphiwbppA55lbN7UG/B24xFETMuoF0a3jMrnz/JMYxTCVZ3HDSz8H33Rx9vifqKN9gv1eqlg==
X-Received: by 2002:a5d:494d:: with SMTP id r13mr5398447wrs.222.1635425316564;
        Thu, 28 Oct 2021 05:48:36 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.14.190])
        by smtp.gmail.com with ESMTPSA id p188sm2565459wmp.30.2021.10.28.05.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 05:48:36 -0700 (PDT)
Message-ID: <3d621619-e6b2-9388-06dd-0ea4cc805ed7@redhat.com>
Date:   Thu, 28 Oct 2021 14:48:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3] KVM: PPC: Tick accounting should defer vtime
 accounting 'til after IRQ handling
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     stable@vger.kernel.org
References: <20211027142150.3711582-1-npiggin@gmail.com>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <20211027142150.3711582-1-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/10/2021 16:21, Nicholas Piggin wrote:
> From: Laurent Vivier <lvivier@redhat.com>
> 
> Commit 112665286d08 ("KVM: PPC: Book3S HV: Context tracking exit guest
> context before enabling irqs") moved guest_exit() into the interrupt
> protected area to avoid wrong context warning (or worse). The problem is
> that tick-based time accounting has not yet been updated at this point
> (because it depends on the timer interrupt firing), so the guest time
> gets incorrectly accounted to system time.
> 
> To fix the problem, follow the x86 fix in commit 160457140187 ("Defer
> vtime accounting 'til after IRQ handling"), and allow host IRQs to run
> before accounting the guest exit time.
> 
> In the case vtime accounting is enabled, this is not required because TB
> is used directly for accounting.
> 
> Before this patch, with CONFIG_TICK_CPU_ACCOUNTING=y in the host and a
> guest running a kernel compile, the 'guest' fields of /proc/stat are
> stuck at zero. With the patch they can be observed increasing roughly as
> expected.
> 
> Fixes: e233d54d4d97 ("KVM: booke: use __kvm_guest_exit")
> Fixes: 112665286d08 ("KVM: PPC: Book3S HV: Context tracking exit guest context before enabling irqs")
> Cc: <stable@vger.kernel.org> # 5.12
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> [np: only required for tick accounting, add Book3E fix, tweak changelog]
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
> Since v2:
> - I took over the patch with Laurent's blessing.
> - Changed to avoid processing IRQs if we do have vtime accounting
>    enabled.
> - Changed so in either case the accounting is called with irqs disabled.
> - Added similar Book3E fix.
> - Rebased on upstream, tested, observed bug and confirmed fix.
> 
>   arch/powerpc/kvm/book3s_hv.c | 30 ++++++++++++++++++++++++++++--
>   arch/powerpc/kvm/booke.c     | 16 +++++++++++++++-
>   2 files changed, 43 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 2acb1c96cfaf..7b74fc0a986b 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3726,7 +3726,20 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
>   
>   	kvmppc_set_host_core(pcpu);
>   
> -	guest_exit_irqoff();
> +	context_tracking_guest_exit();
> +	if (!vtime_accounting_enabled_this_cpu()) {
> +		local_irq_enable();
> +		/*
> +		 * Service IRQs here before vtime_account_guest_exit() so any
> +		 * ticks that occurred while running the guest are accounted to
> +		 * the guest. If vtime accounting is enabled, accounting uses
> +		 * TB rather than ticks, so it can be done without enabling
> +		 * interrupts here, which has the problem that it accounts
> +		 * interrupt processing overhead to the host.
> +		 */
> +		local_irq_disable();
> +	}
> +	vtime_account_guest_exit();
>   
>   	local_irq_enable();
>   
> @@ -4510,7 +4523,20 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>   
>   	kvmppc_set_host_core(pcpu);
>   
> -	guest_exit_irqoff();
> +	context_tracking_guest_exit();
> +	if (!vtime_accounting_enabled_this_cpu()) {
> +		local_irq_enable();
> +		/*
> +		 * Service IRQs here before vtime_account_guest_exit() so any
> +		 * ticks that occurred while running the guest are accounted to
> +		 * the guest. If vtime accounting is enabled, accounting uses
> +		 * TB rather than ticks, so it can be done without enabling
> +		 * interrupts here, which has the problem that it accounts
> +		 * interrupt processing overhead to the host.
> +		 */
> +		local_irq_disable();
> +	}
> +	vtime_account_guest_exit();
>   
>   	local_irq_enable();
>   
> diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
> index 977801c83aff..8c15c90dd3a9 100644
> --- a/arch/powerpc/kvm/booke.c
> +++ b/arch/powerpc/kvm/booke.c
> @@ -1042,7 +1042,21 @@ int kvmppc_handle_exit(struct kvm_vcpu *vcpu, unsigned int exit_nr)
>   	}
>   
>   	trace_kvm_exit(exit_nr, vcpu);
> -	guest_exit_irqoff();
> +
> +	context_tracking_guest_exit();
> +	if (!vtime_accounting_enabled_this_cpu()) {
> +		local_irq_enable();
> +		/*
> +		 * Service IRQs here before vtime_account_guest_exit() so any
> +		 * ticks that occurred while running the guest are accounted to
> +		 * the guest. If vtime accounting is enabled, accounting uses
> +		 * TB rather than ticks, so it can be done without enabling
> +		 * interrupts here, which has the problem that it accounts
> +		 * interrupt processing overhead to the host.
> +		 */
> +		local_irq_disable();
> +	}
> +	vtime_account_guest_exit();
>   
>   	local_irq_enable();
>   
> 

I'm wondering if we should put the context_tracking_guest_exit() just after the 
"srcu_read_unlock(&vc->kvm->srcu, srcu_idx);" as it was before 61bd0f66ff92 ("KVM: PPC: 
Book3S HV: Fix guest time accounting with VIRT_CPU_ACCOUNTING_GEN")?

Thanks,
Laurent


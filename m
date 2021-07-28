Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3113D9947
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 01:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhG1XLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 19:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbhG1XLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 19:11:16 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173CEC0613C1
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 16:11:14 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b6so7461991pji.4
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 16:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wjVZYNNKvkz+dEqnRUcvgnvoiUT+17D6nY+LOvQaqFM=;
        b=LyMc9TiBuRMdPTTAqLyUditTfLnTTRPuRFiSp1/g8qRVaSD911B/hJ1JigdxNGzzZf
         ZHDMhL9XPwZG0HIqkWCW3SRP6cYblxII2QqbZ8fV6TaLmbFo8yqjFMTib+i6WYFJT4sa
         IS+58xCLXSpKvXmnCksM0Ei9UmmjMgvt+D6PsoZKlOXTW1JNEoz2ICejKZ4GhKjStROc
         SVpNxF9wX1owUlE9qVtbjcXiGgU6XC57ml5EvUyT+9nNzkUIO+tvjupt7nbZBOwxAHDX
         Lk5rYLBoFYdJENOhInfMC+gB4BDDNYozGaNPHUto8QY+oIZsV9E4sLKSqGMHV/oM9B3T
         Y2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wjVZYNNKvkz+dEqnRUcvgnvoiUT+17D6nY+LOvQaqFM=;
        b=g10pv3BVSgxMga8eJat4dy4ipW1RQd0wd9K8m7whTj01lDKr8cD4cdCySnxdg1Z+e9
         x0PBaVj5ROgYgKzoy8l7kAFOVf/S7tJIncrgVw1MN7bvcRlMYER8ZF9GmL781Kyf0bEA
         OQCrJyyzkIGZwpsw4p5w28tG51X/cUG9QTXiEvNUsjIRRGXoTIdOVERBI8JEzxBoXOE4
         1lq8+MCAUoghSFrp4QZNSZ0NbXiIctLdxvPBOErzqh26EGvvv+5tnjbuQJPmsb7ufMF8
         FUc8Rp2cRCaansdSKoN0Q95CURHfqrTCs4cL+kuUQ9YCPm6cYo6edWr/9bzCE5ctwjuy
         xPQQ==
X-Gm-Message-State: AOAM530xnH/4gN8n7I5dOZq3rYUy3W+Ij6NY6LYQcWnHi9RqGj0i9EfC
        JXqBMG4umpHQHIFzsab37H8B1Q==
X-Google-Smtp-Source: ABdhPJwa932+QRBDfM/6XzzlKH/E0wkeUZlFkYSZiAe7DrHhqPtKcatkq6xNejJSqEGJGcEs0DXqLA==
X-Received: by 2002:a17:90a:bd06:: with SMTP id y6mr2147490pjr.6.1627513873271;
        Wed, 28 Jul 2021 16:11:13 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p17sm1058543pfh.33.2021.07.28.16.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 16:11:12 -0700 (PDT)
Date:   Wed, 28 Jul 2021 23:11:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Stas Sergeev <stsp2@yandex.ru>
Subject: Re: [PATCH v3] KVM: x86: accept userspace interrupt only if no event
 is injected
Message-ID: <YQHkDDN+T3mFTcP+@google.com>
References: <20210727210916.1652841-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727210916.1652841-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021, Paolo Bonzini wrote:
> Once an exception has been injected, any side effects related to
> the exception (such as setting CR2 or DR6) have been taked place.
> Therefore, once KVM sets the VM-entry interruption information
> field or the AMD EVENTINJ field, the next VM-entry must deliver that
> exception.
> 
> Pending interrupts are processed after injected exceptions, so
> in theory it would not be a problem to use KVM_INTERRUPT when
> an injected exception is present.  However, DOSEMU is using
> run->ready_for_interrupt_injection to detect interrupt windows
> and then using KVM_SET_SREGS/KVM_SET_REGS to inject the
> interrupt manually.  For this to work, the interrupt window
> must be delayed after the completion of the previous event
> injection.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Stas Sergeev <stsp2@yandex.ru>
> Tested-by: Stas Sergeev <stsp2@yandex.ru>
> Fixes: 71cc849b7093 ("KVM: x86: Fix split-irqchip vs interrupt injection window request")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4116567f3d44..e5d5c5ed7dd4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4358,8 +4358,17 @@ static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
>  
>  static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_arch_interrupt_allowed(vcpu) &&
> -		kvm_cpu_accept_dm_intr(vcpu);
> +	/*
> +	 * Do not cause an interrupt window exit if an exception
> +	 * is pending or an event needs reinjection; userspace
> +	 * might want to inject the interrupt manually using KVM_SET_REGS
> +	 * or KVM_SET_SREGS.  For that to work, we must be at an
> +	 * instruction boundary and with no events half-injected.
> +	 */
> +	return (kvm_arch_interrupt_allowed(vcpu) &&

Ha, adding a '(' is one way to fix the indentation.

Reviewed-by: Sean Christopherson <seanjc@google.com> 

> +		kvm_cpu_accept_dm_intr(vcpu) &&
> +		!kvm_event_needs_reinjection(vcpu) &&
> +		!vcpu->arch.exception.pending);
>  }
>  
>  static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
> -- 
> 2.27.0
> 

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FC73D9FB1
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 10:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbhG2IiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 04:38:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47456 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235035AbhG2IiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 04:38:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627547880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h9s53MGl1rBQL5mhO1IHQK6+kE0XMxm2Yaf9T/ll/VA=;
        b=XRCBm4Sz7XPd9Ckbu/Rm9CPPzmJ2SRkhotfwCFx1iw0FT+5LjaCJkvAHR+kFyTr/8B+edV
        SWQ9+rRGeDL86jQwekykaw/UEZ0ExkyiSIolaUNfPRQRzGVYoxgtYSfWUh3AmHu/0vtUml
        zzGYwSY9LelgkDkYtm7VmLxA1IMOdjY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-bgnhqiASPtux4fOhu1d6Qg-1; Thu, 29 Jul 2021 04:37:59 -0400
X-MC-Unique: bgnhqiASPtux4fOhu1d6Qg-1
Received: by mail-ed1-f71.google.com with SMTP id ay20-20020a0564022034b02903bc515b673dso2607488edb.3
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 01:37:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h9s53MGl1rBQL5mhO1IHQK6+kE0XMxm2Yaf9T/ll/VA=;
        b=U0hSKtW1a3bwaOn8NgBpSbDxOK09mM/bBrWSTyPfprBpfB/WljRILMKqAfbIqYtoEl
         gHPoPK3++tVV/uraR30IbUYtzwpMghGvO15WnVvSNQLZjwS16MwaFbJ5Fsq03pdpvB+M
         xMu1iKj62E3xTR3lEZ5mvR2/Alhe0xp9Q61mf4NM4QJW5sRPhUQabNyUPutIaNAsmubd
         CLSi3/IssA2//gLr5Viou0FadDw6OhZTBklnbG2r+hsx2vi3JoBqSb36RbFiEsn6dnek
         T8Q6wIXjG0x1yqc9NIpkeq2sQcHVXooCQw9uRkrUnqsNiv9WmirPna1vHkqrCgRwWDJx
         2Sww==
X-Gm-Message-State: AOAM533WVPelNHugOOurulAtYn59da7Nc2Iw+2N8zRRxSVmGLF8YrVo+
        Sw9irnH9T1tEHVV8MuglpD8FrHCbr5s0nX0PvhW+lNRt74Z0I8KEwsb82CnovgVlif0GBcdieIF
        kAoIaxVansqRT/Y5F
X-Received: by 2002:aa7:c7d0:: with SMTP id o16mr4681426eds.75.1627547877953;
        Thu, 29 Jul 2021 01:37:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxM18yfayknqXO86HfCAFiH8nAuvRcrUT6sLY94aq/LKMjzfXrWzeT8+KayYkgxlj5KHwraJQ==
X-Received: by 2002:aa7:c7d0:: with SMTP id o16mr4681410eds.75.1627547877728;
        Thu, 29 Jul 2021 01:37:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id op26sm737825ejb.27.2021.07.29.01.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 01:37:57 -0700 (PDT)
Subject: Re: [linux-4.14.y] KVM: x86: determine if an exception has an error
 code only when injecting it.
To:     Zubin Mithra <zsm@chromium.org>, stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        mlevitsk@redhat.com
References: <20210728230833.1762416-1-zsm@chromium.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fb5339b2-06c5-b4ec-3d6d-78737f88399b@redhat.com>
Date:   Thu, 29 Jul 2021 10:37:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210728230833.1762416-1-zsm@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/07/21 01:08, Zubin Mithra wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> commit b97f074583736c42fb36f2da1164e28c73758912 upstream.
> 
> A page fault can be queued while vCPU is in real paged mode on AMD, and
> AMD manual asks the user to always intercept it
> (otherwise result is undefined).
> The resulting VM exit, does have an error code.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Message-Id: <20210225154135.405125-2-mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Zubin Mithra <zsm@chromium.org>
> ---
> Backport Note:
> * Syzkaller triggered a WARNING with the following stacktrace:
>   WARNING: CPU: 3 PID: 3436 at arch/x86/kvm/x86.c:7529 kvm_arch_vcpu_ioctl_run+0x247/0x2dd2
>   Kernel panic - not syncing: panic_on_warn set ...
> 
>   CPU: 3 PID: 3436 Comm: poc Not tainted 4.14.241-00082-gce4d1565392b #7
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
>   Call Trace:
>    dump_stack+0xf8/0x163
>    panic+0x15a/0x2c2
>    ? unregister_sha256_avx+0x1b/0x1b
>    ? kvm_arch_vcpu_ioctl_run+0x247/0x2dd2
>    __warn+0xe4/0x117
>    ? kvm_arch_vcpu_ioctl_run+0x247/0x2dd2
>    report_bug+0x93/0xdd
>    fixup_bug+0x28/0x4b
>    do_error_trap+0xb6/0x1b2
>    ? fixup_bug+0x4b/0x4b
>    ? kasan_slab_free+0x141/0x154
>    ? kasan_slab_free+0xad/0x154
>    ? kmem_cache_free+0x14d/0x301
>    ? put_pid+0x57/0x6f
>    ? kvm_vcpu_ioctl+0x214/0x73d
>    ? vfs_ioctl+0x46/0x5a
>    ? trace_hardirqs_off_caller+0x10c/0x115
>    ? trace_hardirqs_off_thunk+0x1a/0x1c
>    invalid_op+0x1b/0x40
>   RIP: 0010:kvm_arch_vcpu_ioctl_run+0x247/0x2dd2
> 
> * This commit is present in linux-5.13.y.
> 
> * Conflict arises as the following commit is is not present in
> linux-5.10.y and older.
> - b3646477d458 ("KVM: x86: use static calls to reduce kvm_x86_ops overhead")
> 
> * Tests run: syzkaller reproducer, Chrome OS tryjobs
> 
>   arch/x86/kvm/x86.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 37d826acd017..d77caab7ad5e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -400,8 +400,6 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
>   
>   	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
>   	queue:
> -		if (has_error && !is_protmode(vcpu))
> -			has_error = false;
>   		if (reinject) {
>   			/*
>   			 * On vmentry, vcpu->arch.exception.pending is only
> @@ -6624,13 +6622,20 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
>   	kvm_x86_ops->update_cr8_intercept(vcpu, tpr, max_irr);
>   }
>   
> +static void kvm_inject_exception(struct kvm_vcpu *vcpu)
> +{
> +       if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
> +               vcpu->arch.exception.error_code = false;
> +       kvm_x86_ops->queue_exception(vcpu);
> +}
> +
>   static int inject_pending_event(struct kvm_vcpu *vcpu)
>   {
>   	int r;
>   
>   	/* try to reinject previous events if any */
>   	if (vcpu->arch.exception.injected) {
> -		kvm_x86_ops->queue_exception(vcpu);
> +		kvm_inject_exception(vcpu);
>   		return 0;
>   	}
>   
> @@ -6675,7 +6680,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
>   			kvm_update_dr7(vcpu);
>   		}
>   
> -		kvm_x86_ops->queue_exception(vcpu);
> +		kvm_inject_exception(vcpu);
>   	} else if (vcpu->arch.smi_pending && !is_smm(vcpu)) {
>   		vcpu->arch.smi_pending = false;
>   		enter_smm(vcpu);
> 


Acked-by: Paolo Bonzini <pbonzini@redhat.com>


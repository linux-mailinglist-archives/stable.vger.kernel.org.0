Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3B63D9FAF
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 10:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbhG2Ihx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 04:37:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31572 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235227AbhG2Ihw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 04:37:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627547869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oN/rvP0Yi5chsoAvoIak0wOM2mazR3gDf7uOcJtC0qk=;
        b=dmSFee7p458U0+x1KSDFM1+W3NMb7zgT2quE4kiddVEzHTwf/IXlbEwkJbNAFoOwncGEy9
        Ws9+euT3suqVAoQF2Rvc/sUWLWX15yXuHBAOf2A66lN+JwuKfgQb5vdft4QsSU+8mv998l
        vPr/BKj2USt5G9mbuPKa5PZxCdYUEp4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-a-bimGw2OvKdFcGFv83ybw-1; Thu, 29 Jul 2021 04:37:47 -0400
X-MC-Unique: a-bimGw2OvKdFcGFv83ybw-1
Received: by mail-ed1-f69.google.com with SMTP id b88-20020a509f610000b02903ab1f22e1dcso2590046edf.23
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 01:37:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oN/rvP0Yi5chsoAvoIak0wOM2mazR3gDf7uOcJtC0qk=;
        b=cSlLMNeH62oG8ntSyg6REHVPBZkBdrIRWzu0SBuXZlN6NHLypjOIQxdTMFF9nbpXKk
         vPEJCX/Az2GkVb/0KbrBcvasvQyZiT/C33XyXX3SiqPWSXRZXs953ZdDBZiicViMAxP2
         KcJsJQnk+0gtc08Dm/HjzwkMF75H/WMZK6IOFoZvxPGpHwWLMVBaJLEDX2de9wpQvavC
         /DBKgjc6zR7KfrZkfrqAZDD+zjCjYM/mjiP1+oRfutAEE4wJSZfEA0/Z/WtMf+TqAEdL
         fIZoE8nK8UIPGnBd7tc4StSiGng/nfkPPW0WvTp5BPpLU7j63ugi5ToYytuhkFCAY2Hr
         F6QA==
X-Gm-Message-State: AOAM532LEshr78MxMpIGuZexjeoJhoHvUJTSpxMvm1zgiNpT+JlhTkAq
        aEyrbvu0o/iISEDJlFRYXD7uZPgx+BXFGlI6H2oASgLiVtEauHv3hboJxEg/3EbOoxceIGdIYsp
        eklp5DyQ32WDAeN0r
X-Received: by 2002:a50:fe06:: with SMTP id f6mr1797920edt.38.1627547866571;
        Thu, 29 Jul 2021 01:37:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxYa7m95CEGlGw+dlQOEI7750RF/AY8CgFnGwi+xUsiPv6kPk9q1EHgQKQFTUDgGSqzUPD8w==
X-Received: by 2002:a50:fe06:: with SMTP id f6mr1797907edt.38.1627547866381;
        Thu, 29 Jul 2021 01:37:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id lv9sm712386ejb.124.2021.07.29.01.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 01:37:45 -0700 (PDT)
Subject: Re: [linux-5.4.y] KVM: x86: determine if an exception has an error
 code only when injecting it.
To:     Zubin Mithra <zsm@chromium.org>, stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        mlevitsk@redhat.com
References: <20210728230745.1762245-1-zsm@chromium.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <868a3b0e-0c95-8d62-d93c-3c82aadb72c6@redhat.com>
Date:   Thu, 29 Jul 2021 10:37:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210728230745.1762245-1-zsm@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/07/21 01:07, Zubin Mithra wrote:
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
>   WARNING: CPU: 0 PID: 3594 at arch/x86/kvm/x86.c:8635 kvm_arch_vcpu_ioctl_run+0x338/0x2421
>   Kernel panic - not syncing: panic_on_warn set ...
>   CPU: 0 PID: 3594 Comm: poc Not tainted 5.4.136-00181-g253dccefb5cb #3
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
>   Call Trace:
>    dump_stack+0x97/0xd3
>    panic+0x198/0x388
>    ? __warn_printk+0xee/0xee
>    ? printk+0xad/0xde
>    ? rcu_read_unlock_sched_notrace+0xf/0xf
>    ? kvm_arch_vcpu_ioctl_run+0x338/0x2421
>    __warn+0xd3/0x113
>    ? kvm_arch_vcpu_ioctl_run+0x338/0x2421
>    report_bug+0xbf/0x100
>    fixup_bug+0x28/0x4b
>    do_error_trap+0xe7/0xf7
>    ? kvm_arch_vcpu_ioctl_run+0x338/0x2421
>    do_invalid_op+0x3a/0x3f
>    ? kvm_arch_vcpu_ioctl_run+0x338/0x2421
>    invalid_op+0x23/0x30
>   RIP: 0010:kvm_arch_vcpu_ioctl_run+0x338/0x2421
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
> index 377157656a8b..5d35b9656b67 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -475,8 +475,6 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
>   
>   	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
>   	queue:
> -		if (has_error && !is_protmode(vcpu))
> -			has_error = false;
>   		if (reinject) {
>   			/*
>   			 * On vmentry, vcpu->arch.exception.pending is only
> @@ -7592,6 +7590,13 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
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
> @@ -7599,7 +7604,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
>   	/* try to reinject previous events if any */
>   
>   	if (vcpu->arch.exception.injected)
> -		kvm_x86_ops->queue_exception(vcpu);
> +		kvm_inject_exception(vcpu);
>   	/*
>   	 * Do not inject an NMI or interrupt if there is a pending
>   	 * exception.  Exceptions and interrupts are recognized at
> @@ -7665,7 +7670,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
>   			}
>   		}
>   
> -		kvm_x86_ops->queue_exception(vcpu);
> +		kvm_inject_exception(vcpu);
>   	}
>   
>   	/* Don't consider new event if we re-injected an event */
> 


Acked-by: Paolo Bonzini <pbonzini@redhat.com>


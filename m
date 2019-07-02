Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABED75D481
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 18:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfGBQnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 12:43:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39845 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfGBQnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 12:43:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so18617549wrt.6
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 09:43:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kV2rDBr8f3q9kLby6YRxl8ZXleRdsPAklKANirTDrb4=;
        b=r7BD0raMGv7FmVVeOJtKWpcILxvXPvtUlfgCVtG33G6tXVz3uEo1wZUUetOz3P8Ko6
         uWB7Oer+8XES0UQuMFFBiTYfuq/fYcUXePQiCOWTYQrXRWUizr9L92qWoCy30py0DHVH
         gU97x4YVHRQ+uuoqwxKozccsflkBvS1Gzu5f9/5EKN9QXKfv2CIwGbtXUVZdLe8+9d8j
         wEsRd/R+NWWTQ6JVSkGaBO7PfZM8eQfyMhek+1biuZxd/RGyVik/Ewg+qIYb+tyHknTA
         3MFrbL5uECCBlrC+Iy6PIASwF0cdkwDFvBTWGMIFA7+0xzlX/ddK7WHs9124cioe8J95
         e6IQ==
X-Gm-Message-State: APjAAAUg4eBPVyCz2lYEE6NrQCzxV1hjasWZf37cw8cXy/zcGmZyEdT/
        5a6B7rFP59/241dGlG3WPu60gaQm/9w=
X-Google-Smtp-Source: APXvYqyCjkw4IWIQFh2eWCekFXDCVrk3wVqWTz5BvaxR3YLEORVKvovktt+CsNcs/+L6TdZmGAhXPg==
X-Received: by 2002:a5d:500f:: with SMTP id e15mr12587591wrt.41.1562085814230;
        Tue, 02 Jul 2019 09:43:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id z1sm15403353wrv.90.2019.07.02.09.43.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:43:33 -0700 (PDT)
Subject: Re: [PATCH] KVM: LAPIC: Fix pending interrupt in IRR blocked by
 software disable LAPIC
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rong Chen <rong.a.chen@intel.com>,
        Feng Tang <feng.tang@intel.com>, stable@vger.kernel.org
References: <1562059502-8581-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c75371c8-7dbc-7ce8-c0f3-0396305b896b@redhat.com>
Date:   Tue, 2 Jul 2019 18:43:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562059502-8581-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/07/19 11:25, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Thomas reported that:
> 
>  | Background:
>  | 
>  |    In preparation of supporting IPI shorthands I changed the CPU offline
>  |    code to software disable the local APIC instead of just masking it.
>  |    That's done by clearing the APIC_SPIV_APIC_ENABLED bit in the APIC_SPIV
>  |    register.
>  | 
>  | Failure:
>  | 
>  |    When the CPU comes back online the startup code triggers occasionally
>  |    the warning in apic_pending_intr_clear(). That complains that the IRRs
>  |    are not empty.
>  | 
>  |    The offending vector is the local APIC timer vector who's IRR bit is set
>  |    and stays set.
>  | 
>  | It took me quite some time to reproduce the issue locally, but now I can
>  | see what happens.
>  | 
>  | It requires apicv_enabled=0, i.e. full apic emulation. With apicv_enabled=1
>  | (and hardware support) it behaves correctly.
>  | 
>  | Here is the series of events:
>  | 
>  |     Guest CPU
>  | 
>  |     goes down
>  | 
>  |       native_cpu_disable()		
>  | 
>  | 			apic_soft_disable();
>  | 
>  |     play_dead()
>  | 
>  |     ....
>  | 
>  |     startup()
>  | 
>  |       if (apic_enabled())
>  |         apic_pending_intr_clear()	<- Not taken
>  | 
>  |      enable APIC
>  | 
>  |         apic_pending_intr_clear()	<- Triggers warning because IRR is stale
>  | 
>  | When this happens then the deadline timer or the regular APIC timer -
>  | happens with both, has fired shortly before the APIC is disabled, but the
>  | interrupt was not serviced because the guest CPU was in an interrupt
>  | disabled region at that point.
>  | 
>  | The state of the timer vector ISR/IRR bits:
>  | 
>  |     	     	       	        ISR     IRR
>  | before apic_soft_disable()    0	      1
>  | after apic_soft_disable()     0	      1
>  | 
>  | On startup		      		 0	      1
>  | 
>  | Now one would assume that the IRR is cleared after the INIT reset, but this
>  | happens only on CPU0.
>  | 
>  | Why?
>  | 
>  | Because our CPU0 hotplug is just for testing to make sure nothing breaks
>  | and goes through an NMI wakeup vehicle because INIT would send it through
>  | the boots-trap code which is not really working if that CPU was not
>  | physically unplugged.
>  | 
>  | Now looking at a real world APIC the situation in that case is:
>  | 
>  |     	     	       	      	ISR     IRR
>  | before apic_soft_disable()    0	      1
>  | after apic_soft_disable()     0	      1
>  | 
>  | On startup		      		 0	      0
>  | 
>  | Why?
>  | 
>  | Once the dying CPU reenables interrupts the pending interrupt gets
>  | delivered as a spurious interupt and then the state is clear.
>  | 
>  | While that CPU0 hotplug test case is surely an esoteric issue, the APIC
>  | emulation is still wrong, Even if the play_dead() code would not enable
>  | interrupts then the pending IRR bit would turn into an ISR .. interrupt
>  | when the APIC is reenabled on startup.
> 
> 
> From SDM 10.4.7.2 Local APIC State After It Has Been Software Disabled
> * Pending interrupts in the IRR and ISR registers are held and require
>   masking or handling by the CPU.
> 
> In Thomas's testing, hardware cpu will not respect soft disable LAPIC 
> when IRR has already been set or APICv posted-interrupt is in flight, 
> so we can skip soft disable APIC checking when clearing IRR and set ISR,
> continue to respect soft disable APIC when attempting to set IRR.
> 
> Reported-by: Rong Chen <rong.a.chen@intel.com>
> Reported-by: Feng Tang <feng.tang@intel.com>
> Reported-by: Thomas Gleixner <tglx@linutronix.de>
> Tested-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Rong Chen <rong.a.chen@intel.com>
> Cc: Feng Tang <feng.tang@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 05d8934..f857a12 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2376,7 +2376,7 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	u32 ppr;
>  
> -	if (!apic_enabled(apic))
> +	if (!kvm_apic_hw_enabled(apic))
>  		return -1;
>  
>  	__apic_update_ppr(apic, &ppr);
> 

Queued, thanks.

Paolo

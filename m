Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CC5233FE3
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 09:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731685AbgGaHSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 03:18:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42241 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731629AbgGaHSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 03:18:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596179917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FBeZiBi3rY5wwl7r2xHV4CjPc5IMTAH+aLjF+XSNGTI=;
        b=Qf72zOYEqFw7j5JgeP44uhf/xyG/xshVgmt5c+CFJSR2un/6O6KjpR39bUIcoPv7CPMFTH
        HSeGYiKif0u60Z9ssNYgS9GsvVPB01oVTVt2Cs8xkq+fXG67bBjb+w2TWK1ilzR2fGA5IP
        zusCRWwqEW1DBOpzGCWyZpIpMtgRl5U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-C2R-7gH9PqOacdhv-8I_uQ-1; Fri, 31 Jul 2020 03:18:36 -0400
X-MC-Unique: C2R-7gH9PqOacdhv-8I_uQ-1
Received: by mail-wr1-f69.google.com with SMTP id e12so8836010wra.13
        for <stable@vger.kernel.org>; Fri, 31 Jul 2020 00:18:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FBeZiBi3rY5wwl7r2xHV4CjPc5IMTAH+aLjF+XSNGTI=;
        b=L/XFbLUTixT1HQZng8J+oRTLkV/OPTWWYvzfIe9wbACvHXzmTjApsqTIU6mmx0TzTa
         AK+yc29DsGoSFIMN88vadNmNqU6uMYsdjilmOYta09OaL4uo3MfbxweWuzEfHno6L7r8
         ItIO7qCEFxJwCMs4bsGi8+SISRltM2d+3PA7wxbOmvWBiUDkgRzaeegsl1FS0oaqHZMH
         udMxsPdzuBKzd0Kk6BYQ3qh+jmKOd58sH0NHi9FZKhrnimOiUvIyqa11dKii6i0eGNth
         CceTR5svAXW3NZveal1kVOiL+NUhmhzAhyzjVwdCEux/aahKoqb1k5bsZrvREKn6/fTQ
         qC/A==
X-Gm-Message-State: AOAM5330z1rUIl7HPXHINEzA5ufRS+o2RihsR5SqFT0K4HkDWttaU1LF
        iEsnpkGdNT8x2xjqUpkjB2ODEVyU27Mwq+phbX/CHKptTLmYjfUA93V+uYvXFT4KHTd8XJ4pO4X
        y/yLPHY5GQ31PAgka
X-Received: by 2002:a7b:c40a:: with SMTP id k10mr2454204wmi.127.1596179914866;
        Fri, 31 Jul 2020 00:18:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4jKCODk7T1VsBYriZd1g/iAJIFX62aV+2CqLzzD8PaXGWqc3wXNimK5Bl5W0qr0xLjLvzyA==
X-Received: by 2002:a7b:c40a:: with SMTP id k10mr2454188wmi.127.1596179914663;
        Fri, 31 Jul 2020 00:18:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:90a5:f767:5f9f:3445? ([2001:b07:6468:f312:90a5:f767:5f9f:3445])
        by smtp.gmail.com with ESMTPSA id s19sm14586327wrb.54.2020.07.31.00.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 00:18:34 -0700 (PDT)
Subject: Re: [PATCH v3 1/3] KVM: LAPIC: Prevent setting the tscdeadline timer
 if the lapic is hw disabled
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
References: <1596165141-28874-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f28c7ad5-ea17-382e-f61e-c48418e49363@redhat.com>
Date:   Fri, 31 Jul 2020 09:18:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1596165141-28874-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31/07/20 05:12, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Prevent setting the tscdeadline timer if the lapic is hw disabled.
> 
> Fixes: bce87cce88 (KVM: x86: consolidate different ways to test for in-kernel LAPIC)
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * add Fixes tag and cc stable
> 
>  arch/x86/kvm/lapic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 5bf72fc..4ce2ddd 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2195,7 +2195,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  
> -	if (!lapic_in_kernel(vcpu) || apic_lvtt_oneshot(apic) ||
> +	if (!kvm_apic_present(vcpu) || apic_lvtt_oneshot(apic) ||
>  			apic_lvtt_period(apic))
>  		return;
>  
> 

Testcase please.

Paolo


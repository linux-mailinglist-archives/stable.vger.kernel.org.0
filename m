Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B3B4353F6
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 21:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhJTTo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 15:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbhJTToZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 15:44:25 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACA5C061749
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 12:42:11 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id u6-20020a17090a3fc600b001a00250584aso1310895pjm.4
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 12:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wpm3Gl8wXKPGXafIgFGP0xD6h/zadXUfu6GUjVrj6ns=;
        b=acg+FfyUS0RRG91XmDNK9hsP2+A1X4msHJW9htVgi4KwyGHvgm+Agooulgt0iLmMbz
         rbct5fnAphkQ/y2uOT5Z1Q9GnwNbVkE/uiNp1fYDMAKUJw/SHsgT5zj0a5JWFz/JJXBv
         6bg1M5hK/hvlZmBXZwwSVJGtuB4y2VY6BV/plwRqiyOgN/lDzgNm4i6dlgUSk//Xi3xW
         rgkZvwYT63T8EXp1eph1nZn6F+uirjFGAM0ZEc7DPfJmlcehlpg54aY9wdo9PL/9+s4n
         BRP4QYLigPWg91zIFhOyWBu1q5lhskwgHHNT5ZSAXglNTNXO2QKcS95IEm1M8xUkHlc5
         OMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wpm3Gl8wXKPGXafIgFGP0xD6h/zadXUfu6GUjVrj6ns=;
        b=uC/RViyKxUYpPJE7UCkwTcwL6TJIIjoprSSYnJ+WCTmspw5Cg6e5MwUg4hetaeKjF8
         k+rSBrUx2goAvAZojntQGg8Q/CS+VWrElVSlA8vza37zZu5j76DLJy2KsVCWK8jQafvE
         nDQhoQW6cFG6hoXf/jCKCxdGmk7d41oLB94weD/C5UKWCdoVgo+mTCu/z6XXwnM9Wd+x
         UB8S3HgL07Nakui408qUO3KLNM+HmeYpk8GYyIchscrFObgcNRz6T/hkkKOUVR3oo01n
         81Nl6GarNwWTJBY2a4e3IYtI9mepp0q++ixvegt3U68V1iYXcvjNHwdzSk9AjMvdkv0+
         EshA==
X-Gm-Message-State: AOAM533Kq8TiDM3IzppKsFFxrg6miZ73Ik6nxtfq+walmpHJV+kmtiOK
        I6XhJImX2tZWOUs2NMV6q9iapA==
X-Google-Smtp-Source: ABdhPJxy4kapndcHpucNwp6t7qxDpD1XglobjefCoqmc4trIw1WxM5NQumPUzkOK+VHDnc46UWVtpw==
X-Received: by 2002:a17:90b:33c3:: with SMTP id lk3mr943772pjb.237.1634758930294;
        Wed, 20 Oct 2021 12:42:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nv5sm3583377pjb.10.2021.10.20.12.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 12:42:09 -0700 (PDT)
Date:   Wed, 20 Oct 2021 19:42:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        wanpengli@tencent.com, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: check for interrupts before deciding whether
 to exit the fast path
Message-ID: <YXBxDYJcrx/C9QDS@google.com>
References: <20211020145231.871299-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020145231.871299-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 20, 2021, Paolo Bonzini wrote:
> The kvm_x86_sync_pir_to_irr callback can sometimes set KVM_REQ_EVENT.
> If that happens exactly at the time that an exit is handled as
> EXIT_FASTPATH_REENTER_GUEST, vcpu_enter_guest will go incorrectly
> through the loop that calls kvm_x86_run, instead of processing
> the request promptly.
> 
> Fixes: 379a3c8ee444 ("KVM: VMX: Optimize posted-interrupt delivery for timer fastpath")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  arch/x86/kvm/x86.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fa48948b4934..b9b31e5f72b0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9781,14 +9781,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
>  			break;
>  
> -                if (unlikely(kvm_vcpu_exit_request(vcpu))) {
> +		if (vcpu->arch.apicv_active)
> +			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
> +
> +		if (unlikely(kvm_vcpu_exit_request(vcpu))) {
>  			exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
>  			break;
>  		}
> -
> -		if (vcpu->arch.apicv_active)
> -			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
> -        }
> +	}

I think someone working on git has a meta-entry in the obfuscated C context.
This is the most convoluted diff possible for a simple code move :-)

>  	/*
>  	 * Do this here before restoring debug registers on the host.  And
> -- 
> 2.27.0
> 

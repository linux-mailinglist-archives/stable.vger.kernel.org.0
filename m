Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BF1472F2D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239181AbhLMO1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbhLMO1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:27:48 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE7BC061574;
        Mon, 13 Dec 2021 06:27:48 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id r25so52220891edq.7;
        Mon, 13 Dec 2021 06:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5uz2bkPs9pu4ybBTlw8INklC2IY/HyciJ34wdpnt1cA=;
        b=PZX8RlKlhtrHTBr3+MPycG9W385C0LeJWaMA/bcECVbKL8fJwdA2TQBbIXquRKbGM3
         WvK/FsAUrwksaBfWtRpJI4Z9GCYNnvk5oY8VjL0g6G54dw+rAIi5x71fUTvOejFzT/Ax
         7DIptUZfWjwlrKTC/lRDwnwGlLO0mimG8sGT9du08XyVPZo+eip10eapIVc+ctMork1j
         ZWOHGw28SBrczIIaQ9AdFurt1zBvxJ2kCjihXgguXRmA5c9AtV9tUAMRQgN/WTCLhhvU
         JHd2CbEtQMnwDDEUq/wWqdysSUeaEUv8VvBSCAFo3Q1pDsLSk2nCqYmLAjMs9rU5JyWC
         MXhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5uz2bkPs9pu4ybBTlw8INklC2IY/HyciJ34wdpnt1cA=;
        b=SFO6AiLo7hMjmv94g3vS6u+QnQKwEWZTs10juzPurIfA3usr63UNRrIZ8i8JyvV1uF
         l43/cSjbvhsebZXTH/ccqhvMXzjuk7PiD8zYLgXMOEQ97yQ2yxAOy6guxusF250pgzRU
         fErM0nDUBDTtCnzCbb3Lbm4zWDPBMA/DurbHCpKAn3jalVbW4aL4DDn+5GFqrQevA//s
         wyRPY5Ga0U1ei1sWLXVOjIUii7GaB4iCNiq3CfIR1U8AsEq1bEHBU+sMejmGBtcUcSym
         iP3vZZL+7YEO8KQGEeQrMpKbEcrqbW/ppkAu4xGPMCODXHNbXrZczA+h94+rTtsJCR1H
         SdDA==
X-Gm-Message-State: AOAM531QizpsmFYS6eH9neNVYOyijfpQnxBdk7tlhRrN/1SLkvzOArQ+
        pHddQBLlr4MrpGlzHxtuxh8=
X-Google-Smtp-Source: ABdhPJyZZvAP9DR71TNi/kbNtqFoG9VKoIhctK7pqYCRxr1qrpcJC++LKCj1kf4UQxfE0PrsodEZKw==
X-Received: by 2002:a17:907:6e10:: with SMTP id sd16mr45440822ejc.158.1639405663099;
        Mon, 13 Dec 2021 06:27:43 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id f22sm6603789edf.93.2021.12.13.06.27.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 06:27:42 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <c7d9016a-8129-0568-a640-cbbca18867bb@redhat.com>
Date:   Mon, 13 Dec 2021 15:27:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH MANUALSEL 5.15 4/9] KVM: SEV: do not take kvm->lock when
 destroying
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20211213141944.352249-1-sashal@kernel.org>
 <20211213141944.352249-4-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211213141944.352249-4-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 15:19, Sasha Levin wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> [ Upstream commit 10a37929efeb4c51a0069afdd537c4fa3831f6e5 ]
> 
> Taking the lock is useless since there are no other references,
> and there are already accesses (e.g. to sev->enc_context_owner)
> that do not take it.  So get rid of it.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20211123005036.2954379-12-pbonzini@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/svm/sev.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 134c4ea5e6ad8..ae8092f0d401e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1842,8 +1842,6 @@ void sev_vm_destroy(struct kvm *kvm)
>   		return;
>   	}
>   
> -	mutex_lock(&kvm->lock);
> -
>   	/*
>   	 * Ensure that all guest tagged cache entries are flushed before
>   	 * releasing the pages back to the system for use. CLFLUSH will
> @@ -1863,8 +1861,6 @@ void sev_vm_destroy(struct kvm *kvm)
>   		}
>   	}
>   
> -	mutex_unlock(&kvm->lock);
> -
>   	sev_unbind_asid(kvm, sev->handle);
>   	sev_asid_free(sev);
>   }
> 

This is cosmetic only, so

NACK

Paolo

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F962AF28A
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 14:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgKKNva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 08:51:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37112 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726977AbgKKNvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 08:51:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605102678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YJxupq7pI+urri4ZzMajTis99KW81YuqHS8unqtfooI=;
        b=W7K7Xi6B/kFjdPpzaMVtsiOXcBIEYqyUQE7gXw1O4d4AOIeY+itWhW1oNRrXJuC5zJbM/w
        2E7CaOIbsFZZftLwSna9hu4h4ztVOcWj/fg+iVWuXv8p0sge9XL8wiPxCzJIpobEk6XLKR
        G0rsbbYBTm3Kuc5TBq4Y/hCNCwItcfY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-rAX7aAfiNd--fnpAHvwWOg-1; Wed, 11 Nov 2020 08:51:15 -0500
X-MC-Unique: rAX7aAfiNd--fnpAHvwWOg-1
Received: by mail-wr1-f69.google.com with SMTP id x16so610012wrg.7
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 05:51:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YJxupq7pI+urri4ZzMajTis99KW81YuqHS8unqtfooI=;
        b=PjhyyogYKzXwwec0L2NvWBPAFYjYvE2FRxUQZ9WY6vHG2PuROEWLInqF+MEs3iwrRm
         moOOBbjtplCvIG1gqUwGEO2OhNQ2a03TT8Bz7Xcgun3DHZOlB9QMUCk3akcvnrFNwV/Y
         yl3LpsVwg4bAP5gOe/PZ7k6dYvg5uicfrYGBJktYvStScXlRcBBQaIxSImsmMOp2flRI
         UQSNw8NPU9suJk4NF6Ky/waKpQ/px/k0xxMHbXAse8CJYapAeBqubmbe7kl91C0D8UNO
         VQVgqQfzegj0pdmm9cHJrDfGw/BuJulYBgyPlOkMhnmu+28LXTAtCUxpr54wrObMEIsk
         T66A==
X-Gm-Message-State: AOAM53203QAed4o93R2W2tXvjdyStHFyxc2vjc3+MC9BI5XUAERe0y1o
        8zhsxMYX6oBoNIuB04UmkBIcgGpqZ9j3GVwZ5JHhtP34/45DEDrMtG1+0W8+pgiav0BF6kGJF1Q
        cEn+hof2NJ97aTooG
X-Received: by 2002:a1c:b18a:: with SMTP id a132mr4262747wmf.95.1605102673966;
        Wed, 11 Nov 2020 05:51:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzoKSU0jh+cvL08VUGwRz2I6w7/9JOjvq8Lxt748+5n9ZDqYRx9g1BiDWS053ccuC3wsJDHpQ==
X-Received: by 2002:a1c:b18a:: with SMTP id a132mr4262729wmf.95.1605102673764;
        Wed, 11 Nov 2020 05:51:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t4sm2820719wmb.20.2020.11.11.05.51.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 05:51:13 -0800 (PST)
Subject: Re: [PATCH stable-5.4] KVM: x86: don't expose MSR_IA32_UMWAIT_CONTROL
 unconditionally
To:     Jack Wang <jinpu.wang@cloud.ionos.com>, gregkh@linuxfoundation.org,
        sashal@kernel.org, stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20201111132047.64845-1-jinpu.wang@cloud.ionos.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9cdcac85-3f02-190f-cf4c-296a8eb415de@redhat.com>
Date:   Wed, 11 Nov 2020 14:51:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201111132047.64845-1-jinpu.wang@cloud.ionos.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/11/20 14:20, Jack Wang wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> This msr is only available when the host supports WAITPKG feature.
> 
> This breaks a nested guest, if the L1 hypervisor is set to ignore
> unknown msrs, because the only other safety check that the
> kernel does is that it attempts to read the msr and
> rejects it if it gets an exception.
> 
> Cc: stable@vger.kernel.org
> Fixes: 6e3ba4abce ("KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL")
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Message-Id: <20200523161455.3940-3-mlevitsk@redhat.com>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> (cherry picked from commit f4cfcd2d5aea4e96c5d483c476f3057b6b7baf6a
> use boot_cpu_has for checking the feature)
> Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>   arch/x86/kvm/x86.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 708b37274cb5..4cacf4669235 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5226,6 +5226,10 @@ static void kvm_init_msr_list(void)
>   			if (!kvm_x86_ops->rdtscp_supported())
>   				continue;
>   			break;
> +		case MSR_IA32_UMWAIT_CONTROL:
> +			if (!boot_cpu_has(X86_FEATURE_WAITPKG))
> +				continue;
> +			break;
>   		case MSR_IA32_RTIT_CTL:
>   		case MSR_IA32_RTIT_STATUS:
>   			if (!kvm_x86_ops->pt_supported())
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks,

Paolo


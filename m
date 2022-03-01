Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF6C4C9680
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbiCAUZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238591AbiCAUXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:23:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47590A27A6
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 12:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646165975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o1zmZFRJ9OdQdfdwAgs/BlX0aZlb5VfZ7KW5288RJgM=;
        b=XDKCKYj6B/aRb1mdpwmBwsH04T5FRmUYESw6jU0DC7Ea8jPKYoked5IAQ7vLrbH/nhYuGh
        B3Uf/aSte3mz6ymcqB2v1gPno21J4Wsa/8Ua6QQPYrfttURWl7mQLYgUbpRSBksBqZeQ+s
        HePN/oBv3093H7t8bwpteb5xdtXZsjg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-buhWx65qNkezX9bpjGYPWg-1; Tue, 01 Mar 2022 15:19:34 -0500
X-MC-Unique: buhWx65qNkezX9bpjGYPWg-1
Received: by mail-wr1-f71.google.com with SMTP id o1-20020adfe801000000b001f023455317so673661wrm.3
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 12:19:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o1zmZFRJ9OdQdfdwAgs/BlX0aZlb5VfZ7KW5288RJgM=;
        b=pOWOTApuJ3dLTZI/cpHth8jYIXaLJC+FbghA3z3XvK7ouvmz92l23gWgLk4W93pVUK
         pWsk2jk+c+FIhJ6QFQ3LYQa158k9KABtg7M0pbMxfUuf7s/xXz7jlcloDzS0HszCJqVG
         IGuNmvEz84CHGyAAD9UErhIagDnj6/CLJdkT2IUAdbZZ3YXVdjv0XqRH6ODXny1e9dj6
         RmNfsFELTQUdtl2xvEOay7FN4tw5FRk23r5D66hXKWgsgX51S74dMcFzwDQ8nypJwzwi
         ttpCDvo43GWdWoLF/kW+zCFeqpzMSeC6N5QQZbgcJHlwJIcV6IUxHEtXHsJgAEoKEIRH
         7OTg==
X-Gm-Message-State: AOAM531GQlt4nC6HclN7cJJQqc92JorH6jGAGSjMcgpkI+YBZC6KJApr
        zh+EWpoS1R7F1ivYbYounZvLpqw0P1HDUyZ3Vry7TEnseYJ8ivYPLdmAUOOGlFUJHtAeGRoc1yD
        U46Lu/1E3qoDly+TJ
X-Received: by 2002:a5d:55cd:0:b0:1ef:6e69:9c78 with SMTP id i13-20020a5d55cd000000b001ef6e699c78mr16887047wrw.626.1646165973551;
        Tue, 01 Mar 2022 12:19:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzRLZQEeitRS41cQmrq1zwFWmk9PeKXhCoOD1q3lUcKFS2IAVUJNtFHgSyS25+0oSD7oFs06A==
X-Received: by 2002:a5d:55cd:0:b0:1ef:6e69:9c78 with SMTP id i13-20020a5d55cd000000b001ef6e699c78mr16887032wrw.626.1646165973345;
        Tue, 01 Mar 2022 12:19:33 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id n10-20020a5d598a000000b001efab095615sm9930224wri.29.2022.03.01.12.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 12:19:32 -0800 (PST)
Message-ID: <fa245ee1-8b87-5a41-3045-9a4d30211029@redhat.com>
Date:   Tue, 1 Mar 2022 21:19:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH AUTOSEL 5.16 06/28] kvm: x86: Disable KVM_HC_CLOCK_PAIRING
 if tsc is in always catchup mode
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Anton Romanov <romanton@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220301201344.18191-1-sashal@kernel.org>
 <20220301201344.18191-6-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301201344.18191-6-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/22 21:13, Sasha Levin wrote:
> From: Anton Romanov <romanton@google.com>
> 
> [ Upstream commit 3a55f729240a686aa8af00af436306c0cd532522 ]
> 
> If vcpu has tsc_always_catchup set each request updates pvclock data.
> KVM_HC_CLOCK_PAIRING consumers such as ptp_kvm_x86 rely on tsc read on
> host's side and do hypercall inside pvclock_read_retry loop leading to
> infinite loop in such situation.
> 
> v3:
>      Removed warn
>      Changed return code to KVM_EFAULT
> v2:
>      Added warn
> 
> Signed-off-by: Anton Romanov <romanton@google.com>
> Message-Id: <20220216182653.506850-1-romanton@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/x86.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0714fa0e7ede0..18fc0367ef21a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8769,6 +8769,13 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
>   	if (clock_type != KVM_CLOCK_PAIRING_WALLCLOCK)
>   		return -KVM_EOPNOTSUPP;
>   
> +	/*
> +	 * When tsc is in permanent catchup mode guests won't be able to use
> +	 * pvclock_read_retry loop to get consistent view of pvclock
> +	 */
> +	if (vcpu->arch.tsc_always_catchup)
> +		return -KVM_EOPNOTSUPP;
> +
>   	if (!kvm_get_walltime_and_clockread(&ts, &cycle))
>   		return -KVM_EOPNOTSUPP;
>   

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


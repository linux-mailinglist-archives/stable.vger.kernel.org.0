Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877634C9135
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 18:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbiCARL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 12:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236429AbiCARL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 12:11:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8C4D506FE
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 09:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646154641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PIJRnLFY1UWXUOWR2QU+D8DLrJdFCZESqRQM5Q/WC7w=;
        b=VW9o0TBX3KK9Aep3dpF7eDhijC2hVVJtXiKtCZyN8kIaU1DIFPU8kjZXpoqEPFN/wfwP+1
        I+/+B0cInVuVkUCDwfbjwlv2zX1wAW4B3wKYI4uIglU3D40aSTY11+stn72NoBq18y0GdK
        RPGxACvsOoD/OocHbyPBmVXfwxhLakY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-2xvEJapxMoqBLKiGNxcChQ-1; Tue, 01 Mar 2022 12:10:40 -0500
X-MC-Unique: 2xvEJapxMoqBLKiGNxcChQ-1
Received: by mail-wm1-f70.google.com with SMTP id h19-20020a05600c351300b0038141cf26deso1495621wmq.8
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 09:10:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PIJRnLFY1UWXUOWR2QU+D8DLrJdFCZESqRQM5Q/WC7w=;
        b=Cv1k3cPfJzlSL1WKg8exrwrpn/pCusLN0qE4yM/t7++dXDX6iLOIKMVY3fS310l4FE
         SDiwllFOTfQVCN5mX0uchh0G4ZVIn0hYTfZowNUwCj/Qqvw0/ZMHyWgzSdBzE4JKc0WN
         LZh7ZKoWtR4EBhkI4Lcl8NYuE5BpOBmNvTIY3mhnhNDSDxWoS2JpSMa1l4NVd4HTBRTg
         LsCQF+zg5VXZvzxn8bZNX5eC2IUMfMCIhVI8r8NYUDbFTG2uD2wn1Iw8RjAVtiYIFY54
         GhlFBc/08pcLruGm2qnshJJPujGOcIfn0x20epQUC2ash4dxKM+mhtejN1Tp1IcXQFsZ
         MH0w==
X-Gm-Message-State: AOAM5337IX1QxMpk19vPtUwFNG5TY00m+k4co4/klX1q8eUeOTx9PaBd
        keUagiRbl8bBvpa8QYLKHZrP+eArASSgKr/WR5kPEpWaOiWQFc+sejn78o3/KJHWzk/JZH9yIlu
        f6NPLxBz+TDOqVo8A
X-Received: by 2002:adf:d089:0:b0:1ed:9e86:2144 with SMTP id y9-20020adfd089000000b001ed9e862144mr19799484wrh.363.1646154639290;
        Tue, 01 Mar 2022 09:10:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwuw7dcMqBQBwKYp5Dn5fVfKfoBsddZLZJfioYVHvc08h1r/JVDl5hRQquCb6XhxeMfCabqIw==
X-Received: by 2002:adf:d089:0:b0:1ed:9e86:2144 with SMTP id y9-20020adfd089000000b001ed9e862144mr19799450wrh.363.1646154638858;
        Tue, 01 Mar 2022 09:10:38 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id n4-20020a05600c4f8400b00380e45cd564sm3715244wmq.8.2022.03.01.09.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 09:10:38 -0800 (PST)
Message-ID: <c020e65d-9528-dab4-a577-3564f939c39d@redhat.com>
Date:   Tue, 1 Mar 2022 18:10:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.10 2/2] KVM: x86: nSVM: deal with L1
 hypervisor that intercepts interrupts but lets L2 control them
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220222140532.211620-1-sashal@kernel.org>
 <20220222140532.211620-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220222140532.211620-2-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/22/22 15:05, Sasha Levin wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> [ Upstream commit 2b0ecccb55310a4b8ad5d59c703cf8c821be6260 ]
> 
> Fix a corner case in which the L1 hypervisor intercepts
> interrupts (INTERCEPT_INTR) and either doesn't set
> virtual interrupt masking (V_INTR_MASKING) or enters a
> nested guest with EFLAGS.IF disabled prior to the entry.
> 
> In this case, despite the fact that L1 intercepts the interrupts,
> KVM still needs to set up an interrupt window to wait before
> injecting the INTR vmexit.
> 
> Currently the KVM instead enters an endless loop of 'req_immediate_exit'.
> 
> Exactly the same issue also happens for SMIs and NMI.
> Fix this as well.
> 
> Note that on VMX, this case is impossible as there is only
> 'vmexit on external interrupts' execution control which either set,
> in which case both host and guest's EFLAGS.IF
> are ignored, or not set, in which case no VMexits are delivered.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Message-Id: <20220207155447.840194-8-mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/svm/svm.c | 17 +++++++++++++----
>   1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d515c8e68314c..ec9586a30a50c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3237,11 +3237,13 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>   	if (svm->nested.nested_run_pending)
>   		return -EBUSY;
>   
> +	if (svm_nmi_blocked(vcpu))
> +		return 0;
> +
>   	/* An NMI must not be injected into L2 if it's supposed to VM-Exit.  */
>   	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
>   		return -EBUSY;
> -
> -	return !svm_nmi_blocked(vcpu);
> +	return 1;
>   }
>   
>   static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
> @@ -3293,9 +3295,13 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
>   static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> +
>   	if (svm->nested.nested_run_pending)
>   		return -EBUSY;
>   
> +	if (svm_interrupt_blocked(vcpu))
> +		return 0;
> +
>   	/*
>   	 * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
>   	 * e.g. if the IRQ arrived asynchronously after checking nested events.
> @@ -3303,7 +3309,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>   	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_intr(svm))
>   		return -EBUSY;
>   
> -	return !svm_interrupt_blocked(vcpu);
> +	return 1;
>   }
>   
>   static void enable_irq_window(struct kvm_vcpu *vcpu)
> @@ -4023,11 +4029,14 @@ static int svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>   	if (svm->nested.nested_run_pending)
>   		return -EBUSY;
>   
> +	if (svm_smi_blocked(vcpu))
> +		return 0;
> +
>   	/* An SMI must not be injected into L2 if it's supposed to VM-Exit.  */
>   	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_smi(svm))
>   		return -EBUSY;
>   
> -	return !svm_smi_blocked(vcpu);
> +	return 1;
>   }
>   
>   static int svm_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)


Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo


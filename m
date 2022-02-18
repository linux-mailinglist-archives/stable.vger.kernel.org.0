Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDEE4BBA6D
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbiBROKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:10:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233569AbiBROKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:10:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 84E06195075
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645193390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7EAhZpHRnkPiQQF9svrka3nrY9GsVGrrWMQzOfKW6Hw=;
        b=T8QUvlixe2LTeFa0hyrWD1HTu8Z+u/hnunF6SzMZTsS6MqWhUz9UU/9NFJ1SVD54O7eAVc
        uUGshzyMazM8Q0GFA1KcvhmgEkJL2t+95jmb24mmO6v09sw4l1UKZN4pIfRQeBLIvTHR3s
        D6zqYX+VlnX0w+IY1p+CjWCi0yrjceo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-h5DbmyrSM_eSBVvFEZSUUw-1; Fri, 18 Feb 2022 09:09:49 -0500
X-MC-Unique: h5DbmyrSM_eSBVvFEZSUUw-1
Received: by mail-ej1-f72.google.com with SMTP id q3-20020a17090676c300b006a9453c33b0so3075099ejn.13
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:09:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7EAhZpHRnkPiQQF9svrka3nrY9GsVGrrWMQzOfKW6Hw=;
        b=zPkfZdLMB+VPqC9yLEoHOJrpjV4rAScIomCFOJDaOMmRhmVO7gEHSpHksMQ2c6jaDl
         nQlhKuAe+c7tSSEpeHGpnINtgr8qDfESHhhEFgVNCXXuXULhcYruHebjWnUC8rIh0lx/
         DOboUrel1nI6hWiKf3NfMWwNV2HhQT9SNlZwgL4KQ9iVyGAEyUk+39WltQD5zWwZxr0a
         Lz9TmwUw/taBsGhExA1wrbVmxGde2irllzB1Ujiv2sZF4b82+7KjLs5ZW86AmDRXlwbr
         uub8WQqMb6mSmqnRoiDbWC0GnDsCHUa+A3XYa3Gfn5RVfOZw8yFr/VCTmA/NPCo2+63H
         4Q4w==
X-Gm-Message-State: AOAM532RveeAf6EoHySkExY4uasd5XHg2NPptk/UCH2tvEqVD8+QvT7D
        zJxger1oBgDU5149SBs04wC9DIMxmLnyZpae7GTpLjZQ/N4LVK4o/Tq8JR/U7DdcN0q77mUX4+Z
        R6mkxl4zXzetMDTPn
X-Received: by 2002:aa7:d49a:0:b0:410:875c:e21b with SMTP id b26-20020aa7d49a000000b00410875ce21bmr8285692edr.357.1645193387951;
        Fri, 18 Feb 2022 06:09:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx/2DxN5lWCcQZG7GqwtJJm23Vt/gumTW3gmY9BbRagNYv8s3JuWSJwmM1a6xuc7vTX2vY1dg==
X-Received: by 2002:aa7:d49a:0:b0:410:875c:e21b with SMTP id b26-20020aa7d49a000000b00410875ce21bmr8285669edr.357.1645193387760;
        Fri, 18 Feb 2022 06:09:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id dz8sm4750970edb.96.2022.02.18.06.09.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 06:09:47 -0800 (PST)
Message-ID: <33cd06f5-4dda-09ce-2929-403cf594b20f@redhat.com>
Date:   Fri, 18 Feb 2022 15:09:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [stable-5.10] KVM: SVM: Never reject emulation due to SMAP errata
 for !SEV guests
Content-Language: en-US
To:     Jack Wang <jinpu.wang@ionos.com>, gregkh@linuxfoundation.org,
        sashal@kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Liam Merwick <liam.merwick@oracle.com>
References: <20220218140750.236302-1-jinpu.wang@ionos.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220218140750.236302-1-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/18/22 15:07, Jack Wang wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> commit 55467fcd55b89c622e62b4afe60ac0eb2fae91f2 upstream.
> 
> Always signal that emulation is possible for !SEV guests regardless of
> whether or not the CPU provided a valid instruction byte stream.  KVM can
> read all guest state (memory and registers) for !SEV guests, i.e. can
> fetch the code stream from memory even if the CPU failed to do so because
> of the SMAP errata.
> 
> Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violation)")
> Cc: stable@vger.kernel.org
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
> Message-Id: <20220120010719.711476-2-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [jwang: adjust context for kernel 5.10.101]
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>   arch/x86/kvm/svm/svm.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d515c8e68314..7773a765f548 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4103,6 +4103,10 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
>   	bool smep, smap, is_user;
>   	unsigned long cr4;
>   
> +	/* Emulation is always possible when KVM has access to all guest state. */
> +	if (!sev_guest(vcpu->kvm))
> +		return true;
> +
>   	/*
>   	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
>   	 *
> @@ -4151,9 +4155,6 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
>   	smap = cr4 & X86_CR4_SMAP;
>   	is_user = svm_get_cpl(vcpu) == 3;
>   	if (smap && (!smep || is_user)) {
> -		if (!sev_guest(vcpu->kvm))
> -			return true;
> -
>   		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
>   
>   		/*

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


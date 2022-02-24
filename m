Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164624C2E3A
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 15:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbiBXOXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 09:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiBXOXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 09:23:19 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBE010075C;
        Thu, 24 Feb 2022 06:22:45 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id qx21so4634149ejb.13;
        Thu, 24 Feb 2022 06:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zYTHUsVVhBwj0g4Gze0zy2RUZ5LyrxDkA+fp8E1dT/8=;
        b=bUSWfnuHV6MsxDaAFBe/JODFU0yALi+lxDfaUl/fPb5TY2Nnf45hMpyf2aEVrRz6kh
         8rCFA+jEIeielP42fOHvWQPq2OSgUZWG/SBNXBcgzKAxr5Loh2yVBatjbNGvFP8KRkFR
         2lIBNm+P8achvv7DW8oxjPteqR1o7x/sxIKKypSF1AgtMxeemjaGQWIsOUSb2M/XnNcV
         UNC9y4V4dZBF6oCEn0CpSFEHfazHkkHMaBuGNY0WVTdkVYuCvQBGwKigu4wUOuugBBZp
         U+Wc32NEDol3lGb0vh8AT7ijboa+HvlM8/D7mBtBKd4bw05mBD0yuvJf6mXTE51236kF
         HBYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zYTHUsVVhBwj0g4Gze0zy2RUZ5LyrxDkA+fp8E1dT/8=;
        b=NmlYBZN/MZKsFsDTdjNcB6ts/S9E4QfInlHigTwBfvw8hG92lqhgOGlNGXfzThFOQv
         OcjYnm8+ze2WB3X6klbjbuhJ9HjK+Rrlrda/B9MYhvLx1fzsaCAWgdUAW+y2ZqCZAREl
         a6EaqJ6Y7VGU389ueP96ZZXKRNNk61WnmWI/Z59LQN2+XUhjuRASOZMxwKaI1UjV72+Q
         aiyvLi8q5JOT6nXgefRLxty6S/SV7MQ9NT0hMQSdR2lM/TLx0wNzJGM08E00nlQyC99j
         csKhRDAShFy28OlbS9uVQS5AbX29u9Zk0STFhFsHoKoZsSB8/kGp9nizwsU+mak7Il50
         nrYA==
X-Gm-Message-State: AOAM531jnhA7AZN1DSCGyCi6ucTk/u6Ph19ksoWuWv76TpU/ad4NdWXn
        pODjCdC0PyQBNu8owD9cS4A=
X-Google-Smtp-Source: ABdhPJzpx4N3xp1lLjkagnxhXCabnGndX91MAsGN9ExhB14AG7jRfTUCqS6EGeMdSNZnv+DNnPGwEA==
X-Received: by 2002:a17:907:90c7:b0:6d1:c55:86a4 with SMTP id gk7-20020a17090790c700b006d10c5586a4mr2478924ejb.484.1645712564078;
        Thu, 24 Feb 2022 06:22:44 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id r1sm1433162ejh.52.2022.02.24.06.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Feb 2022 06:22:43 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <e459dbcc-3a43-bd20-6f78-1a9d712ae020@redhat.com>
Date:   Thu, 24 Feb 2022 15:22:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: x86: nSVM: disallow userspace setting of
 MSR_AMD64_TSC_RATIO to non default value when tsc scaling disabled
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220223115649.319134-1-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220223115649.319134-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/23/22 12:56, Maxim Levitsky wrote:
> If nested tsc scaling is disabled, MSR_AMD64_TSC_RATIO should
> never have non default value.
> 
> Due to way nested tsc scaling support was implmented in qemu,
> it would set this msr to 0 when nested tsc scaling was disabled.
> Ignore that value for now, as it causes no harm.
> 
> 
> Fixes: 5228eb96a487 ("KVM: x86: nSVM: implement nested TSC scaling")
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/svm.c | 19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)

Queued, thanks.

Paolo

> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7038c76fa841..b80ad471776f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2705,8 +2705,23 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>   	u64 data = msr->data;
>   	switch (ecx) {
>   	case MSR_AMD64_TSC_RATIO:
> -		if (!msr->host_initiated && !svm->tsc_scaling_enabled)
> -			return 1;
> +
> +		if (!svm->tsc_scaling_enabled) {
> +
> +			if (!msr->host_initiated)
> +				return 1;
> +			/*
> +			 * In case TSC scaling is not enabled, always
> +			 * leave this MSR at the default value.
> +			 *
> +			 * Due to bug in qemu 6.2.0, it would try to set
> +			 * this msr to 0 if tsc scaling is not enabled.
> +			 * Ignore this value as well.
> +			 */
> +			if (data != 0 && data != svm->tsc_ratio_msr)
> +				return 1;
> +			break;
> +		}
>   
>   		if (data & TSC_RATIO_RSVD)
>   			return 1;


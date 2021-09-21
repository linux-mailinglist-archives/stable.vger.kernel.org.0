Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0413413948
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 19:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhIUR4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 13:56:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231904AbhIUR4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 13:56:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632246877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Q2MHEXLXim+/y032QTQuhLFxwAxHerebm3zs86tuZU=;
        b=UE2d/FVom9DKgIJ//Or7D3p51xnm4oCyOe67cjQ54cHpq2Zyk4Bs4bgvtt8t6IkJ3RXrSr
        iLYlZkWxFARskfehQ0McNiMaWi5Y0yIvwgC9lrT+TRy8XWz6isHrPnChiINKLTHpaT6DO6
        2ocloIE+XTayS3PKn12tbJ342fZvlT8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-fD0K3gqZN_y4Q7z5iEYxPg-1; Tue, 21 Sep 2021 13:54:36 -0400
X-MC-Unique: fD0K3gqZN_y4Q7z5iEYxPg-1
Received: by mail-ed1-f69.google.com with SMTP id h24-20020a50cdd8000000b003d8005fe2f8so15755115edj.6
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 10:54:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1Q2MHEXLXim+/y032QTQuhLFxwAxHerebm3zs86tuZU=;
        b=BPorT2RPSn8AUQWRk96qioC7mwnoo4vWI0EO8zLE2GswjKbFWkyicbiVV3gxTDHkX5
         Lgac33MTw8CWxgpDj0oCkWClMpraPWns4WVf6N8kFTV+ycCOzzR0mm0Zo9F5aSGSLAxB
         +Ygo8hMffvpwAzBxViasht4+Jq8ejailoeymqTQfCAHtQMluGLYnUz5p61fuJgx4cUrZ
         3eDbLzT4IKkypdD72oREAnC8GOZYBdR0miXTXpgL2qDNkot1JFbBHyz+fNGhjhzxFgvI
         JoWSzU/8N0d6fytQvMbDBqqSTFtsGFrEUwxqEJ/idOwQbssh+6Fd1YL0B77kOa4Dd8P9
         fEVg==
X-Gm-Message-State: AOAM53120EEl9NSAIBKfUf//nqVT1o+dD0BpyUTNWs0ys0Mm7WTgrbzk
        FCeT8qodikkWSueYV/XqkuuZZC1/pkfIFeIO2Yl+Y2ITmlo9LHPzoqeyv7X/35/fHYXvIbXk8x6
        oIos02K2uZcO1Pf70
X-Received: by 2002:a17:906:fc09:: with SMTP id ov9mr36344895ejb.128.1632246875395;
        Tue, 21 Sep 2021 10:54:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXK/mL83pYtX0BzGMb+1ADVxehMaWKTjXAZ/aKuq5m8OXlXbQkmZvV+/7fOBolEtPtEiTNBA==
X-Received: by 2002:a17:906:fc09:: with SMTP id ov9mr36344874ejb.128.1632246875238;
        Tue, 21 Sep 2021 10:54:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u4sm7792965ejc.19.2021.09.21.10.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 10:54:34 -0700 (PDT)
Subject: Re: [PATCH V2] KVM: SEV: Acquire vcpu mutex when updating VMSA
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210915171755.3773766-1-pgonda@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ec40f2bc-6f36-bac4-27ba-ba38720db807@redhat.com>
Date:   Tue, 21 Sep 2021 19:54:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210915171755.3773766-1-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15/09/21 19:17, Peter Gonda wrote:
> Adds vcpu mutex guard to the VMSA updating code. Refactors out
> __sev_launch_update_vmsa() function to deal with per vCPU parts
> of sev_launch_update_vmsa().
> 
> Fixes: ad73109ae7ec ("KVM: SVM: Provide support to launch and run an SEV-ES guest")
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> 
> V2
>   * Refactor per vcpu work to separate function.
>   * Remove check to skip already initialized VMSAs.
>   * Removed vmsa struct zeroing.
> 
> ---
>   arch/x86/kvm/svm/sev.c | 53 ++++++++++++++++++++++++------------------
>   1 file changed, 30 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75e0b21ad07c..766510fe3abb 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -595,43 +595,50 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>   	return 0;
>   }
>   
> -static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
> +				    int *error)
>   {
> -	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct sev_data_launch_update_vmsa vmsa;
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	int ret;
> +
> +	/* Perform some pre-encryption checks against the VMSA */
> +	ret = sev_es_sync_vmsa(svm);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * The LAUNCH_UPDATE_VMSA command will perform in-place encryption of
> +	 * the VMSA memory content (i.e it will write the same memory region
> +	 * with the guest's key), so invalidate it first.
> +	 */
> +	clflush_cache_range(svm->vmsa, PAGE_SIZE);
> +
> +	vmsa.reserved = 0;
> +	vmsa.handle = to_kvm_svm(kvm)->sev_info.handle;
> +	vmsa.address = __sme_pa(svm->vmsa);
> +	vmsa.len = PAGE_SIZE;
> +	return sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
> +}
> +
> +static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
>   	struct kvm_vcpu *vcpu;
>   	int i, ret;
>   
>   	if (!sev_es_guest(kvm))
>   		return -ENOTTY;
>   
> -	vmsa.reserved = 0;
> -
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		struct vcpu_svm *svm = to_svm(vcpu);
> -
> -		/* Perform some pre-encryption checks against the VMSA */
> -		ret = sev_es_sync_vmsa(svm);
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		ret = mutex_lock_killable(&vcpu->mutex);
>   		if (ret)
>   			return ret;
>   
> -		/*
> -		 * The LAUNCH_UPDATE_VMSA command will perform in-place
> -		 * encryption of the VMSA memory content (i.e it will write
> -		 * the same memory region with the guest's key), so invalidate
> -		 * it first.
> -		 */
> -		clflush_cache_range(svm->vmsa, PAGE_SIZE);
> +		ret = __sev_launch_update_vmsa(kvm, vcpu, &argp->error);
>   
> -		vmsa.handle = sev->handle;
> -		vmsa.address = __sme_pa(svm->vmsa);
> -		vmsa.len = PAGE_SIZE;
> -		ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa,
> -				    &argp->error);
> +		mutex_unlock(&vcpu->mutex);
>   		if (ret)
>   			return ret;
> -
> -		svm->vcpu.arch.guest_state_protected = true;
>   	}
>   
>   	return 0;
> 

Queued, thanks.

Paolo


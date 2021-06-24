Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9183B390F
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 00:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhFXWHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 18:07:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31898 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232693AbhFXWHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 18:07:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624572290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zUqGiC/pVTvNwSK7cLH6J1baKcMTefGVXAbkJmBdujk=;
        b=I/ddAD0vitI2YiW9dhdMSKVJjX1bIfNBDi7DNhvDmqPvmn0uLqw1wP24BgPgwKEv5PIb+g
        3Z50Ls1YLbjX/suTUVjWPDLJcH3Mn2400pP23IrbA6uRlAfOT87J9gnjhPaQDMdxSu3Prk
        LYFPhljb6Ker4EJK8qDUFFopq4qh4yI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-OR0JprJsP6etI6ZNMAiIjQ-1; Thu, 24 Jun 2021 18:04:48 -0400
X-MC-Unique: OR0JprJsP6etI6ZNMAiIjQ-1
Received: by mail-wm1-f69.google.com with SMTP id u17-20020a05600c19d1b02901af4c4deac5so2161188wmq.7
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 15:04:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zUqGiC/pVTvNwSK7cLH6J1baKcMTefGVXAbkJmBdujk=;
        b=cEr9lsTOd3nRDEgbiALwu6u2TR50JMatowvx1KxAas1+VPgddmPy+ZYPoTGjLv7r3+
         ZFwu3HZJomAa8W3TRKamRhuQYWdKCf/V6VZJm5mwO3CDESf8Rjk4FoOiOT/YnLoZ8L3d
         gkt7tj3baT34t9whcIYmyv6HAFnsGZl+H7Fb+y/wYD9JgxY+h++tvfHnNpLUJwRB+8EJ
         EnazkU98AYwv4zyXV+UCqZpJQWsCTuvLDMd0RN0j1i7HtAu6xfAqc0kmRbPUeL5lyjDt
         htO18QlmQAxHKLhUT9LWSbuNizNg8/tMskUYZ42s6NhQObD6tadYuhtrJui/1TmDzoXS
         1y7w==
X-Gm-Message-State: AOAM5328/IEhBI5B82mpUHfa7iVtiRa1o7peqH4Y576MFCGRFF6GDBuL
        Oq/QiudKQpKCu/eV7SrYC7ltA+aMzbx4Czc508IR8vCqxF8ajhvT0qCJ7Kow7hxgyqKmyrRn1qu
        E34yi+9DEgTLDLA1q
X-Received: by 2002:a05:600c:219:: with SMTP id 25mr6898871wmi.106.1624572287319;
        Thu, 24 Jun 2021 15:04:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzLyc2cb9IwrIINqpZWJFl30UvyVa18NTO7cHT2SQ8ImqAF7M6lyA0JL7TiaX6sW7FKuwyng==
X-Received: by 2002:a05:600c:219:: with SMTP id 25mr6898852wmi.106.1624572287057;
        Thu, 24 Jun 2021 15:04:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u10sm4062559wmm.21.2021.06.24.15.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 15:04:46 -0700 (PDT)
Subject: Re: [PATCH 5.12] KVM: SVM: Call SEV Guest Decommission if ASID
 binding fails
To:     Alper Gun <alpergun@google.com>, stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>
References: <20210624220211.1973589-1-alpergun@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <330d4365-36a2-b4c2-007e-ff19d0d250ec@redhat.com>
Date:   Fri, 25 Jun 2021 00:04:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210624220211.1973589-1-alpergun@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/06/21 00:02, Alper Gun wrote:
> commit 934002cd660b035b926438244b4294e647507e13 upstream.
> 
> Send SEV_CMD_DECOMMISSION command to PSP firmware if ASID binding
> fails. If a failure happens after  a successful LAUNCH_START command,
> a decommission command should be executed. Otherwise, guest context
> will be unfreed inside the AMD SP. After the firmware will not have
> memory to allocate more SEV guest context, LAUNCH_START command will
> begin to fail with SEV_RET_RESOURCE_LIMIT error.
> 
> The existing code calls decommission inside sev_unbind_asid, but it is
> not called if a failure happens before guest activation succeeds. If
> sev_bind_asid fails, decommission is never called. PSP firmware has a
> limit for the number of guests. If sev_asid_binding fails many times,
> PSP firmware will not have resources to create another guest context.
> 
> Cc: stable@vger.kernel.org
> Fixes: 59414c989220 ("KVM: SVM: Add support for KVM_SEV_LAUNCH_START command")
> Reported-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: Alper Gun <alpergun@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/svm/sev.c | 26 +++++++++++++++-----------
>   1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index dbc6214d69de..96a61fab9c58 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -143,9 +143,19 @@ static void sev_asid_free(int asid)
>   	mutex_unlock(&sev_bitmap_lock);
>   }
>   
> +static void sev_decommission(unsigned int handle)
> +{
> +	struct sev_data_decommission decommission;
> +
> +	if (!handle)
> +		return;
> +
> +	decommission.handle = handle;
> +	sev_guest_decommission(&decommission, NULL);
> +}
> +
>   static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>   {
> -	struct sev_data_decommission *decommission;
>   	struct sev_data_deactivate *data;
>   
>   	if (!handle)
> @@ -165,15 +175,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>   
>   	kfree(data);
>   
> -	decommission = kzalloc(sizeof(*decommission), GFP_KERNEL);
> -	if (!decommission)
> -		return;
> -
> -	/* decommission handle */
> -	decommission->handle = handle;
> -	sev_guest_decommission(decommission, NULL);
> -
> -	kfree(decommission);
> +	sev_decommission(handle);
>   }
>   
>   static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> @@ -303,8 +305,10 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   	/* Bind ASID to this guest */
>   	ret = sev_bind_asid(kvm, start->handle, error);
> -	if (ret)
> +	if (ret) {
> +		sev_decommission(start->handle);
>   		goto e_free_session;
> +	}
>   
>   	/* return handle to userspace */
>   	params.handle = start->handle;
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAFD3B3910
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 00:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbhFXWHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 18:07:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229848AbhFXWHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 18:07:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624572333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8CmUEsgUeJLzmUaEuY7hklAVzAvdjstNeVIFa3OagmE=;
        b=BSDHXbylSGNiqj1rIf4eCl3kmpwEyG3jYlml0r+Ohg4OT0mIOSTqnYNn5OEluRWKNtI1xh
        6c52kkdbfOqrGSGiOnX4sNjHNoVstlzMsIKGr0PRT7K9xH8EMw8IMD7ZvVbITck5wCRWI9
        CFwvdG2O9NH7YFszmysPsAmIu+eQuEU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-aADFlmcoPRamia9KmG7i4w-1; Thu, 24 Jun 2021 18:05:32 -0400
X-MC-Unique: aADFlmcoPRamia9KmG7i4w-1
Received: by mail-ed1-f71.google.com with SMTP id i19-20020a05640200d3b02903948b71f25cso4105137edu.4
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 15:05:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8CmUEsgUeJLzmUaEuY7hklAVzAvdjstNeVIFa3OagmE=;
        b=Nfh9B17mhnDZP5lJLF0V+epbsPluxEvATbl5Qva66iwy/zipUc8UParHjhlKhUm7Aw
         PFHWQMKn4cV9cFfJHhPLvSyAFgkvh6DSU6V3KPRiutwSCo1e34I69lmI9o01mnR7qp3p
         VHBlapBOjRXvty95IkwlQ1RUSgYgKEzuc4QB96hZJYJXYvTbxuNMH75mAuKEkoV/Ybav
         Q1ohuiIaT9q2wP6gNTkS+ZoafBwpkjHxy/NlGO+fl2xcwaqINcr1ftfjrydm1OVRP59D
         cdp3P1q6C0GQnJiNJwge2Qe1Xbh2bp+i22kiqv3chSI3kwT+rFq1ABdGHHbI7soVEKBE
         KDEA==
X-Gm-Message-State: AOAM531yL8Afd2Xw/XqmEos6ODpJdHGaveklofMBeDWdfi5OA1nt/jPY
        t9SwDWVYjMzxYml8g7CWfNTTy+EvYC+/ACXnt4aVWTtCA2xJ8dLxvu06siBcRhXIythnh/7NV5a
        mb0ll1AzmdRy1h9WU
X-Received: by 2002:a05:6402:27d0:: with SMTP id c16mr9987536ede.60.1624572331452;
        Thu, 24 Jun 2021 15:05:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQPVhZmSqtOoaXiVi7UnyFu9MHzYiuCKrUG2r+cgwqFyo0cbFuuns9eP9gA+jjzAafZw0VSQ==
X-Received: by 2002:a05:6402:27d0:: with SMTP id c16mr9987516ede.60.1624572331321;
        Thu, 24 Jun 2021 15:05:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n2sm2861730edq.2.2021.06.24.15.05.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 15:05:30 -0700 (PDT)
Subject: Re: [PATCH 5.12] KVM: SVM: Call SEV Guest Decommission if ASID
 binding fails
To:     Alper Gun <alpergun@google.com>, stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>
References: <20210624220211.1973589-1-alpergun@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <296f54c9-72f2-b92f-b5b0-12a139c8a5f9@redhat.com>
Date:   Fri, 25 Jun 2021 00:05:30 +0200
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

Oops, NACK.  Sorry.  You need to preserve the kzalloc in older versions 
of Linux.

Paolo


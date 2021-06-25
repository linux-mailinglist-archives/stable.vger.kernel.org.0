Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2873B3FE6
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 10:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhFYJCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 05:02:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38786 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229956AbhFYJCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 05:02:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624611582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5BtP5FLSgf6lBnM5l9zY3JG8zZxGey31Lt90Xe63dGM=;
        b=CgVH3pejEXEZbfUakUakUIKtTP5uT17+3kxo+ZpoU9m1jXDWZFYiLWik6iDE5uJHPuHbd6
        uDvRKIC6m89w7QLq9nA53536j7eR89PGpxY0p8it8V0PmAY5G+RPSAEGTXXo2JlIqjDisr
        sETZdngptYMoYxD4dH3qsi2NMlEHpVA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578--LyYWrGrMUeR9l2SV01oUQ-1; Fri, 25 Jun 2021 04:59:40 -0400
X-MC-Unique: -LyYWrGrMUeR9l2SV01oUQ-1
Received: by mail-ed1-f72.google.com with SMTP id r15-20020aa7da0f0000b02903946a530334so4816547eds.22
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 01:59:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5BtP5FLSgf6lBnM5l9zY3JG8zZxGey31Lt90Xe63dGM=;
        b=GVdTASiq34HM3vj0CwxS69vmog2lKeG/t4Oq9HPsOPOnqY2VR1dufxJHY2qAMG9DDc
         5TVn69Ya5e/AF6fyL/3IUnluaUQvOSnOyCtLuFo/3BMOhrcR9/hBPqrOC7Hw32Q2hTCa
         kEJJirrgTGf+plR/hOL6W18nkoFIyf5Ciwhc1UchDlvwvTz4qeBZCJf9L9grBXzNdaq5
         wa+FiinwCy7uHHoI0+W97RbIv2ukItPRYoxKeD447SbrZE8FkDqdZGWUn8QWFLGEglnd
         J7yVcR4FWEHs32AYD8pfBtjr0pp2E3sj5o4cWbn2B1mcEE7e7RObo5Mpg9/5vc9GxDHX
         p55A==
X-Gm-Message-State: AOAM533FGPMhgwZOn7IvWbIlDKn4r78PmxUmo8I7hOZUjZ5jSqAwiFYz
        mapa5N4QerUxhaNqEBHUS5oCxLFhgGL4OV/Zhbm6hKA0draOt+cQKMmDMcsMb3q8axDIFFvV0Us
        1pQkhAOimxrqmthCK
X-Received: by 2002:a17:906:585a:: with SMTP id h26mr9853715ejs.31.1624611579529;
        Fri, 25 Jun 2021 01:59:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2XQaAmrVzhODL/eL2UZR35mf+jh6qh2fOPFZAMgeuDXucpGft4giZoX5VbO3s33x0vyrEAA==
X-Received: by 2002:a17:906:585a:: with SMTP id h26mr9853674ejs.31.1624611578875;
        Fri, 25 Jun 2021 01:59:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x21sm3518354edv.97.2021.06.25.01.59.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 01:59:38 -0700 (PDT)
Subject: Re: [PATCH 5.10 v2] KVM: SVM: Call SEV Guest Decommission if ASID
 binding fails
To:     Alper Gun <alpergun@google.com>, stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>
References: <20210624234855.2428305-1-alpergun@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c3193c80-851f-422c-df2c-6f35d7e0157a@redhat.com>
Date:   Fri, 25 Jun 2021 10:59:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210624234855.2428305-1-alpergun@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/06/21 01:48, Alper Gun wrote:
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
>   arch/x86/kvm/svm/sev.c | 32 +++++++++++++++++++++-----------
>   1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 16b10b9436dc..01547bdbfb06 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -130,9 +130,25 @@ static void sev_asid_free(int asid)
>   	mutex_unlock(&sev_bitmap_lock);
>   }
>   
> -static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
> +static void sev_decommission(unsigned int handle)
>   {
>   	struct sev_data_decommission *decommission;
> +
> +	if (!handle)
> +		return;
> +
> +	decommission = kzalloc(sizeof(*decommission), GFP_KERNEL);
> +	if (!decommission)
> +		return;
> +
> +	decommission->handle = handle;
> +	sev_guest_decommission(decommission, NULL);
> +
> +	kfree(decommission);
> +}
> +
> +static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
> +{
>   	struct sev_data_deactivate *data;
>   
>   	if (!handle)
> @@ -152,15 +168,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
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
> @@ -288,8 +296,10 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
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


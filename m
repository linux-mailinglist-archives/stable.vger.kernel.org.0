Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F84472F48
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbhLMO3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233978AbhLMO3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:29:06 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47203C061574;
        Mon, 13 Dec 2021 06:29:06 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id y13so52306895edd.13;
        Mon, 13 Dec 2021 06:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kRj85z1WUDfF4U3gKS3A1mzB7eXs1fbiphqLRnz7cUs=;
        b=GLaVCsjy3B6LUwV3TizwWJg6mHkOlG09kLTDBstKyALnHNTMDpZk1NSO7zRznkPrtr
         wLjd+GIRFRk0m1axrmARb836eJOYA7wArdFZTnT3Gvbkjh00G84xTiJPxKjZ6ZOBAsIi
         WVUpznM96E5HTlLrjxpOqMIQX0Twx6Vc2T8YLJXwZsFOUPKol8z0XBoPOfEjwzYJnqPq
         dt/F52X7fpMAiFKncEL8bXj0RVYxyhQWh3L9Wyu74N6XadScxDnZdWVdHgH61TALkwZu
         bMvEuQ+QeteXZJMbvCGS96COyzP14pSxU+bKmhL8gwqzIoxp3qgMhyDkNvlrBtlpa9YN
         hXUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kRj85z1WUDfF4U3gKS3A1mzB7eXs1fbiphqLRnz7cUs=;
        b=Z9sO+j+glsltV5BSQSGy/5tsSqPf9Ae1HRnEdMjru3cJv1LZs+Vn8feouMLQ9EjyaW
         7w2xwVB3k46kat9NfLnsMRtYZ2EsycvZ2mAu4MFBqkZn9qRp4oY95wynURSn+3dniYiQ
         8hMc0M3QyclLAWz6mO1XboRLxv5gp7k97pJk2EJXpBP4u2b6E0m/t0JvCM8dud1Y94jw
         c4aYm5F8nHZilxXghB7LBHG9tr9dNirnJODwgG6nyXVQeyaUQ2e/Han98raNMgPqYvbg
         fwi0wH1y1jsDS0t4+S8Xdqn4ST8fy6JVtIzGbY9dcmjZCrM2+53hIWs6JMazMtfaXpSb
         K07A==
X-Gm-Message-State: AOAM531x7SfA//VSo7YsmxTnPGT99+MlRVos3eRutC9WQo5g9s75lOzT
        rgqaU+cSxqxPLFhqjl3JxtM=
X-Google-Smtp-Source: ABdhPJyje88YC8lsCYNlveQcR6MH0xfWqLRxxMsU4G+0dH4LCuTCb0EnZhd1ZXQnpg0IexFfBgnNng==
X-Received: by 2002:a17:907:948c:: with SMTP id dm12mr43444091ejc.551.1639405744446;
        Mon, 13 Dec 2021 06:29:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id w22sm6763424edd.49.2021.12.13.06.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 06:29:03 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <283f2ad2-2991-38fb-2d9d-51230c7994f0@redhat.com>
Date:   Mon, 13 Dec 2021 15:29:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH MANUALSEL 5.10 2/4] KVM: VMX: clear
 vmx_x86_ops.sync_pir_to_irr if APICv is disabled
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org
References: <20211213142020.352376-1-sashal@kernel.org>
 <20211213142020.352376-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211213142020.352376-2-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 15:20, Sasha Levin wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> [ Upstream commit e90e51d5f01d2baae5dcce280866bbb96816e978 ]
> 
> There is nothing to synchronize if APICv is disabled, since neither
> other vCPUs nor assigned devices can set PIR.ON.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/vmx/vmx.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5b7664d51dc2b..dff8ab5a53280 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7814,10 +7814,10 @@ static __init int hardware_setup(void)
>   		ple_window_shrink = 0;
>   	}
>   
> -	if (!cpu_has_vmx_apicv()) {
> +	if (!cpu_has_vmx_apicv())
>   		enable_apicv = 0;
> +	if (!enable_apicv)
>   		vmx_x86_ops.sync_pir_to_irr = NULL;
> -	}
>   
>   	if (cpu_has_vmx_tsc_scaling()) {
>   		kvm_has_tsc_control = true;
> 

NACK - the patch is only okay to backport for 5.15

Paolo

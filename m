Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4A13BF784
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 11:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhGHJZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 05:25:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50426 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231263AbhGHJZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 05:25:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625736166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E+pSefAOiJpQ8wwMbW477tKyPDbTdepoxRASTY2DASI=;
        b=AJ4pCF/Q4fn079htocNQiFq9Ez2nTvNXvP3K76BtMf5vOIDKN98e+c4Mw+bWyGpSAUCL4C
        SGPKDx9k5YhpRsj2Pyr81O0Zd42i7odsOHgvaqSjQtTGYJuQ7HP3BjEtG5B7NPanwZYJA3
        83wAnmWQBcjFW+LfhlKZeTlu06OV4Uc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-16uZIKpzNhuRTyQlVZSYaA-1; Thu, 08 Jul 2021 05:22:44 -0400
X-MC-Unique: 16uZIKpzNhuRTyQlVZSYaA-1
Received: by mail-ed1-f70.google.com with SMTP id i19-20020a05640200d3b02903948b71f25cso2975817edu.4
        for <stable@vger.kernel.org>; Thu, 08 Jul 2021 02:22:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E+pSefAOiJpQ8wwMbW477tKyPDbTdepoxRASTY2DASI=;
        b=nrChNYzFHBq9NvZNuQ+XI115rfb3Mkv1KJZpg56fe9Fkx4+ZQohh1Epm56jtZ5Xvjt
         7GrIEHZGA08mW9dEQEXbOZY9o10jaK2JB/8Ox1jFP2rpyJA2PXYD3Stq31naj6WGba0u
         p6bpgbL4K5vVihBCtv5krRCTUweFSlJZwXft65uebpOW8gObQKRqyq44fZa1NSIvcqrx
         +IEh7JtsKjlJ1GB3U9BP1UPa1Q6Z/e9RyNtCT7pr6sRWdDxekxsZ7JJWT8GawP2v4qiG
         c6Hc2tVvP5ubRoDoeL0C36WTMCLXMdk1p6JjI3xarQAsRiVst3QcC+fMiF82CWGPQTXr
         32SQ==
X-Gm-Message-State: AOAM531rjm9WhpzTDomIiMPzYhqFUdiJ9dUIQ7yAhLl9PABWXjUjEzh8
        xL/ZXaeq8vf+k1anYYPNd7GZo/Z2rdqYgBt5U0CRGzmHdzVIxxLMJvm8UAaWrusQ8HeNUIiXrwE
        vuDWwOCWoBsZ4G9Kj
X-Received: by 2002:a50:fe8d:: with SMTP id d13mr36939058edt.14.1625735855522;
        Thu, 08 Jul 2021 02:17:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCk/LVZXmqKMW0Pw9a1WdvcT7laxKprAseHNRCetnTsu0RK3rK6AVAUZtIKCpJfy9FpteB2g==
X-Received: by 2002:a50:fe8d:: with SMTP id d13mr36939044edt.14.1625735855405;
        Thu, 08 Jul 2021 02:17:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r23sm908746edv.26.2021.07.08.02.17.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 02:17:34 -0700 (PDT)
Subject: Re: [PATCH for 4.19, 5.4] KVM: SVM: Periodically schedule when
 unregistering regions on destroy
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        David Rientjes <rientjes@google.com>
References: <20210708050253.341098-1-nobuhiro1.iwamatsu@toshiba.co.jp>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e6bb1290-6db7-97c1-cb24-403beb4e1609@redhat.com>
Date:   Thu, 8 Jul 2021 11:17:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210708050253.341098-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/07/21 07:02, Nobuhiro Iwamatsu wrote:
> From: David Rientjes <rientjes@google.com>
> 
> commit 7be74942f184fdfba34ddd19a0d995deb34d4a03 upstream.

Part of 5.9.

> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index c5673bda4b66df..3f776e654e3aec 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1910,6 +1910,7 @@ static void sev_vm_destroy(struct kvm *kvm)
>   		list_for_each_safe(pos, q, head) {
>   			__unregister_enc_region_locked(kvm,
>   				list_entry(pos, struct enc_region, list));
> +			cond_resched();
>   		}
>   	}
>   
> 

Patch is the same as the upstream commit, except for the name of the 
file.  Thanks!

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo


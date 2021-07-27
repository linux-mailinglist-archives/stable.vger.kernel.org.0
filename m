Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BCB3D73EE
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 13:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236238AbhG0LBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 07:01:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236326AbhG0LBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 07:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627383667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9H/TvzRoo+SL7oAvVanOfbNOjOMZ8k/vzemy9cQe4vE=;
        b=famSDk3ful7/WsAKyemhvKmYdsjoxBsioO2NX8EbD94wsWOQfPg07rrvPhLo8nUcQB5lL/
        yz46UckqDeFuR3yHZx4OBMtNmhmD+cfcOeolVcbUCIGvxtUFgwLRZy08s9GcmrqnD0yTDF
        5F8kFaHN+hgcYkKQzBWbk7RUKRpGomo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-f_Zec6ItMImji7brCdXBlA-1; Tue, 27 Jul 2021 07:01:06 -0400
X-MC-Unique: f_Zec6ItMImji7brCdXBlA-1
Received: by mail-ed1-f71.google.com with SMTP id w17-20020a50fa910000b02903a66550f6f4so5166430edr.21
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 04:01:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9H/TvzRoo+SL7oAvVanOfbNOjOMZ8k/vzemy9cQe4vE=;
        b=MFtGf1qpAskw7p0DeL0JVYU2yNj+k5QmcHQ+yM8rJ+C0ITk+YR+sl9yYA8y7If4qXJ
         vffB+hhvFb1FtNtuNLo2U1gOjjIme+kWfy33HvE3qGuQUmllMMFsQj9shw0LcHSD4PF1
         afks1fmRxhYKP2DvE/ctiUO+hcVYnCLKBpW3x6tAx6Y/zatJiXOA9VCmdAhzV/ghyxqF
         qstC9mGLZf41ZkMLCsTv+KuCubYp6l+7Gj7TPn7S4YEtSsvkHhohQqcIM+crJnWrTGTX
         FO3+f7598DpHWmoW39JKt9uWs64Ej3LSdL1FkC49Le3yJbJGdrsrtJyZ2B8fUlwskF5H
         V7nw==
X-Gm-Message-State: AOAM531adOLL0xiCIwlWgcrQuZjSeCIM2ogy7rBkYjFfcbul8KOe18oD
        MouaGOf/zu2VkasWHbUXNSBu7AMxWUvJgECt5L/Kqj48yKpRjCxPLxF386K7euBi/s2C++9irYY
        rzYPf6yD6Lafqe9o5kjOdaRGhHE7nfUSS7pFGJYQzILE+pZVIwpLwbh/VXQLFnQ4NPSVa
X-Received: by 2002:a05:6402:5250:: with SMTP id t16mr26900014edd.317.1627383664935;
        Tue, 27 Jul 2021 04:01:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyi4AwXkzrsqVzKnGRVp1u/p1QAev44CFrFUYLkNs6WWalzvoazCVnL/c1/v5yDwDeCQ8Atg==
X-Received: by 2002:a05:6402:5250:: with SMTP id t16mr26899985edd.317.1627383664673;
        Tue, 27 Jul 2021 04:01:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id s8sm1097936edy.18.2021.07.27.04.01.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 04:01:04 -0700 (PDT)
Subject: Re: [PATCH v2 4.19 3/3] KVM: Use kvm_pfn_t for local PFN variable in
 hva_to_pfn_remapped()
To:     Ovidiu Panait <ovidiu.panait@windriver.com>, stable@vger.kernel.org
References: <20210727082924.2336367-1-ovidiu.panait@windriver.com>
 <20210727082924.2336367-3-ovidiu.panait@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <07f120ee-28fd-4521-495f-071a0d71a8cc@redhat.com>
Date:   Tue, 27 Jul 2021 13:01:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210727082924.2336367-3-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/07/21 10:29, Ovidiu Panait wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> commit a9545779ee9e9e103648f6f2552e73cfe808d0f4 upstream
> 
> Use kvm_pfn_t, a.k.a. u64, for the local 'pfn' variable when retrieving
> a so called "remapped" hva/pfn pair.  In theory, the hva could resolve to
> a pfn in high memory on a 32-bit kernel.
> 
> This bug was inadvertantly exposed by commit bd2fae8da794 ("KVM: do not
> assume PTE is writable after follow_pfn"), which added an error PFN value
> to the mix, causing gcc to comlain about overflowing the unsigned long.
> 
>    arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function ‘hva_to_pfn_remapped’:
>    include/linux/kvm_host.h:89:30: error: conversion from ‘long long unsigned int’
>                                    to ‘long unsigned int’ changes value from
>                                    ‘9218868437227405314’ to ‘2’ [-Werror=overflow]
>     89 | #define KVM_PFN_ERR_RO_FAULT (KVM_PFN_ERR_MASK + 2)
>        |                              ^
> virt/kvm/kvm_main.c:1935:9: note: in expansion of macro ‘KVM_PFN_ERR_RO_FAULT’
> 
> Cc: stable@vger.kernel.org
> Fixes: add6a0cd1c5b ("KVM: MMU: try to fix up page faults before giving up")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20210208201940.1258328-1-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>   virt/kvm/kvm_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3559eba5f502..a3d82113ae1c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1501,7 +1501,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   			       bool write_fault, bool *writable,
>   			       kvm_pfn_t *p_pfn)
>   {
> -	unsigned long pfn;
> +	kvm_pfn_t pfn;
>   	pte_t *ptep;
>   	spinlock_t *ptl;
>   	int r;
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

and the other two are the same as v1.

Paolo


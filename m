Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6396E3DFD4D
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 10:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhHDIvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 04:51:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235216AbhHDIvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 04:51:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628067098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SHYqJ5q7gJH7GGRNVGUkDvpZYBDXmFP+5URLXuA7ksE=;
        b=c4t/VHnBe1yRDMB3aEyQyEk47DwxNBXbovaY/LBtc3j6zzaDKN1eRIAQ6/1fxjGltXRe+b
        ER+4aHNyNH7HlvFKvE0IcbvXHlgNHNxj9MiJBfmvndFsu6x7V7LVDQ/5a8iDkiFp+D+4tj
        bDhgOI4p1wgl9Tbg1UrMSYDaKclyeeM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-9-BHwwY1NNCjA0WgAPiIpg-1; Wed, 04 Aug 2021 04:51:37 -0400
X-MC-Unique: 9-BHwwY1NNCjA0WgAPiIpg-1
Received: by mail-ej1-f69.google.com with SMTP id r21-20020a1709067055b02904be5f536463so618000ejj.0
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 01:51:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SHYqJ5q7gJH7GGRNVGUkDvpZYBDXmFP+5URLXuA7ksE=;
        b=gZXvQKLw6O2GIsog8MVpI+sX4qvqTaB3Eid1f4ut9dkEjRKkgftMm76hVvKihgfHGl
         sRug8xx1braGQ1T5ReJecJQUglCly3bw9zBBY5ytKDQh8Yp6VDTawmgxt9TBfsiAQWvp
         I1hTXfnq5Jj6P8BmnJ43FC4A0LXFiprvfMD/zvYDJ7TTm4plsiV43w5rXpccKuVvzqFS
         8FU57toVKbZV14LxXryEVf/rHcGeR2sQLuiLAJ9BEEXL/HYM25gm5Xf0Lhbstrx+68X7
         yt4JIqM5sUalBj+PQ+JBGlVblPJHLG8ZqQfslquJUBTwR6nVvhhEMyO+4SPW2NCdlRhn
         l6hA==
X-Gm-Message-State: AOAM532ULbNierMKIoEtgg4CV3ReFdIq1L4BurvfX40FcgE87lgcrUJE
        /PVNJg0pRlY18RXeJnSzu7k0QIoGzrW739n5NECZU+y6ivaJSQHZcU9GW4BCCDpGUFBN69Auwpm
        pO5bF6st8VkljYs6e3DcoZZoS74ZuZvyxGcJWr2u1YoToonPs7Jfmr+5WHXJAe4KCV8Tk
X-Received: by 2002:a05:6402:1b11:: with SMTP id by17mr31083489edb.110.1628067095877;
        Wed, 04 Aug 2021 01:51:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/VkPJNf6CWJ3WRWlFcsDAjSCm4Ru09Cg07sLxHdmMqXRb02wURjadNfne/MCNRfXRDxt1Ug==
X-Received: by 2002:a05:6402:1b11:: with SMTP id by17mr31083473edb.110.1628067095680;
        Wed, 04 Aug 2021 01:51:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id s7sm546722edu.23.2021.08.04.01.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 01:51:35 -0700 (PDT)
Subject: Re: [PATCH 4.14 3/3] KVM: Use kvm_pfn_t for local PFN variable in
 hva_to_pfn_remapped()
To:     Ovidiu Panait <ovidiu.panait@windriver.com>, stable@vger.kernel.org
References: <20210803135521.2603575-1-ovidiu.panait@windriver.com>
 <20210803135521.2603575-3-ovidiu.panait@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aec49add-75f1-eee3-fcad-c95c628c9205@redhat.com>
Date:   Wed, 4 Aug 2021 10:51:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210803135521.2603575-3-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/08/21 15:55, Ovidiu Panait wrote:
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
> index 469361d01116..36b9f2b29071 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1497,7 +1497,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4683B3D692C
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 00:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhGZVWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 17:22:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29142 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231839AbhGZVWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 17:22:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627336970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WeoSATKCsUczJoZWnPn33Qg+mplhNYCcnwstKUtpHBs=;
        b=S3v5D/WXe19O6aU6rFvedndDx9KkVrk5wnnG10s6sR8tkkPDfgnRJVRETx1NycMQBIaIxb
        DgptGKEnbqRDrPVkW6KcmuRSiIePbA6vpWE5DA9Z3d5BQOErLKUgM5psdxcyAGRkaXbWOL
        dZnE6NZzukI8wl3VMvjzM7AAWSDZ8uQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-Zbv7h50OPkqSY6tdaNx_cA-1; Mon, 26 Jul 2021 18:02:48 -0400
X-MC-Unique: Zbv7h50OPkqSY6tdaNx_cA-1
Received: by mail-ed1-f69.google.com with SMTP id i89-20020a50b0620000b02903b8906e05b4so5385358edd.19
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 15:02:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WeoSATKCsUczJoZWnPn33Qg+mplhNYCcnwstKUtpHBs=;
        b=nH5Pdz4PpaC8UjZ+27LUbohXmTtCSf1JA3O//CJKuo5VLxp1Rkv2pM7HbAw+RuSu4z
         Ez8GdMNXVfZSwHE8MZiwYvu7iI+ZL0/xjsiHA0zjGmKBwYl1k8L/H/deTw9nFhM3s64B
         AvbciLNqDA1xWQptrj8KNJBS63D9BPAlJPxfMaN2N+EEKsIyoaf4KjbVS5kPjYoYNlHp
         WpCprovY7hPy5gbMOoFEBcDskV85VhEYb/84evdioctQd0BY7tbExD/BUcdRf4WaDRPg
         mmmm8mb3ueDMLCntPhvvvxGUTsUG//OGNz7FqNF4oP3ZM2LlTT3ydfbUkhXx8/j1hA3S
         u6ow==
X-Gm-Message-State: AOAM532RTBrezzVIP3Upa1VllRGucNzauM1mn/gQ4iQxot1k4XeX0Z0A
        C97U8hxHNKHd/LTOLEbk6T2SBoq9eA2VNr6DVXTmk9aC5b58AoC2883qaEAdwstmScDn2r8d47i
        Wseu24FQZzXJVUxHD
X-Received: by 2002:a17:906:c834:: with SMTP id dd20mr12151123ejb.371.1627336967603;
        Mon, 26 Jul 2021 15:02:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvH/3aCqmYYflBf/gRwLdTFogim/fAaLvtF2xdQqxRPsK9uaxN0bsiIQHQ3PcBI8SRCAJd/g==
X-Received: by 2002:a17:906:c834:: with SMTP id dd20mr12151108ejb.371.1627336967433;
        Mon, 26 Jul 2021 15:02:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id n13sm262249ejk.97.2021.07.26.15.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 15:02:46 -0700 (PDT)
Subject: Re: [PATCH 4.19 111/120] KVM: do not assume PTE is writable after
 follow_pfn
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        David Stevens <stevensd@google.com>, 3pvd@google.com,
        Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
References: <20210726153832.339431936@linuxfoundation.org>
 <20210726153836.031515657@linuxfoundation.org>
 <CADVatmOcg_7eQno88nu4ijX9QOoA0h2QY=hoj3TZU+tNqj0TMg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8cf86f5f-480a-7093-e890-467f290b0ed3@redhat.com>
Date:   Tue, 27 Jul 2021 00:02:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CADVatmOcg_7eQno88nu4ijX9QOoA0h2QY=hoj3TZU+tNqj0TMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/07/21 23:17, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Jul 26, 2021 at 4:58 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> From: Paolo Bonzini <pbonzini@redhat.com>
>>
>> commit bd2fae8da794b55bf2ac02632da3a151b10e664c upstream.
> 
> The build of mips malta_kvm_defconfig fails with the error:
> In file included from arch/mips/kvm/../../../virt/kvm/kvm_main.c:21:
> arch/mips/kvm/../../../virt/kvm/kvm_main.c: In function 'hva_to_pfn_remapped':
> ./include/linux/kvm_host.h:70:33: error: conversion from 'long long
> unsigned int' to 'long unsigned int' changes value from
> '9218868437227405314' to '2' [-Werror=overflow]
>     70 | #define KVM_PFN_ERR_RO_FAULT    (KVM_PFN_ERR_MASK + 2)
>        |                                 ^
> arch/mips/kvm/../../../virt/kvm/kvm_main.c:1530:23: note: in expansion
> of macro 'KVM_PFN_ERR_RO_FAULT'
>   1530 |                 pfn = KVM_PFN_ERR_RO_FAULT;
> 
> It built fine after reverting this patch.
> gcc version 11.1.1 20210723

I'll resend a version that works tomorrow (including the second patch 
too, which depends on this one for context).

Paolo


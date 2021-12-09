Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6646946F6B7
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 23:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhLIWYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 17:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbhLIWYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 17:24:42 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB17C061746;
        Thu,  9 Dec 2021 14:21:08 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y12so23622247eda.12;
        Thu, 09 Dec 2021 14:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Dlj/WYRY7/ClYkHsGEEcYhdPH9nMRT+214uI4LyQAGc=;
        b=NnjXVk467jZl/XDZaIpXX0lAlMnwACMmr4dRYlCYIAM0KMcFgdLtzmIjFp0m1Ey0Vd
         9y40gk49XZO2vD5iq0JC4l5N/PH5TFgFsRHaK1WaI8U8EDiafSA9HV/02LtW/4p0gOPM
         TWdxmE6/faQIcL205oVb8PMWqzLSkJE3zAWEdjLU/0jl9d2Q5p3jYAhwU649RMj0LyeG
         oxE6bWZeHfewUWg5o0zrzNxJdeX5xKZL36sdwTDQEK8FnAaWFdt5aoxxTL43wXZtVkWZ
         WHFRdSHg2aFiitLJipD1Pf19EG7ANqCSwBVywWYxkaK7g8lrSpcOHMYkwCW0fcMN9orq
         pCBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Dlj/WYRY7/ClYkHsGEEcYhdPH9nMRT+214uI4LyQAGc=;
        b=5/l/eXnASn3jR0Cp5TuQF9n4pq9Y0dEVhYUb3VYmJFtq3fUlt25yi2Zx0KsW3+RFRe
         DW/7yBWSlT6MDFFDwffbHmAlN9iaoDo1I/Tx8/HKEZFbjKV1Dn4TnNJo3n/Kc2W9x2JS
         9xhCpRJsV7SPXnFnno7jUsc0eL+prgb6EJ8L/lwpIQEJZT0TjOc04L+VZkzJZjkeitsT
         g5Bk/bqenS5MxZwf6IVUtvosq6544YN/emmDMm98f6xPQJ2cO7B/laJ6Hd20jWgucxJF
         y1zoc+JQEqGOK0aZuRsbwM79IpwaoX2LfGwC4wm1kyjqRxWnauHPkiqVCaDOgaBIyXKr
         xN8Q==
X-Gm-Message-State: AOAM532RpxgsFoSIUzUn6XnKNNqsSngKtk8pJgPliBTJ7DGxDxuuKTzK
        RcYKnypTIw14qRBRyAGuN3E=
X-Google-Smtp-Source: ABdhPJy1m4SZAg0AX8MXC+xVkvsgyntHVWZpnvIO8U4y6EnryXOs96wIRrrK46NKAe8inacnwZUYZg==
X-Received: by 2002:a05:6402:3da:: with SMTP id t26mr33649387edw.232.1639088467053;
        Thu, 09 Dec 2021 14:21:07 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id mp9sm482998ejc.106.2021.12.09.14.21.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 14:21:06 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <a9be23ee-d485-c334-4524-2daa1758cafd@redhat.com>
Date:   Thu, 9 Dec 2021 23:21:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2] selftests: KVM: avoid failures due to reserved
 HyperTransport region
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com,
        joao.m.martins@oracle.com, stable@vger.kernel.org,
        David Matlack <dmatlack@google.com>
References: <20211209205256.301140-1-pbonzini@redhat.com>
 <YbJ5jyCyqZwZU3uH@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YbJ5jyCyqZwZU3uH@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/9/21 22:47, Sean Christopherson wrote:
>> +		/*
>> +		 * Otherwise it's at the top of the physical address
>> +		 * space, possibly reduced due to SME by bits 11:6 of
>> +		 * CPUID[0x8000001f].EBX.
>> +		 */
>> +		eax = 0x80000008;
>> +		cpuid(&eax, &ebx, &ecx, &edx);
>
> Should't this check 0x80000000.eax >= 0x80000008 first?  Or do we just accept
> failure if family==0x17 and there's no 0x80000008?  One paranoid option would be
> to use the pre-fam17 value, e.g.
> 
>          /* Before family 17h, the HyperTransport area is just below 1T. */
>          ht_gfn = (1 << 28) - num_ht_pages;
>          if (x86_family(eax) < 0x17)
>                  goto out;
> 
>          eax = 0x80000000;
>          cpuid(&eax, &ebx, &ecx, &edx);
>          max_ext_leaf = eax;
> 
>          /* Use the old, conservative value if MAXPHYADDR isn't enumerated. */
>          if (max_ext_leaf < 0x80000008)
>                  goto out;

Yes, this works for me too.  Though in practice I don't think any 64-bit 
machine ever existed without 0x80000008 (you need it to decide what's a 
canonical address and what isn't), so that would have to be a 32-bit 
fam17h machine.

Paolo

>          /* comment */
>          eax = 0x80000008;
>          cpuid(&eax, &ebx, &ecx, &edx);
>          max_pfn = (1ULL << ((eax & 255) - vm->page_shift)) - 1;
>          if (max_ext_leaf >= 0x8000001f) {
>                  <adjust>
>          }
>          ht_gfn = max_pfn - num_ht_pages;
> out:
>          return min(max_gfn, ht_gfn - 1);
> 
>> +             max_pfn = (1ULL << ((eax & 255) - vm->page_shift)) - 1;
> LOL, "& 255", you just couldn't resist, huh?  My version of Rami Code only goes
> up to 15.:-)
> 


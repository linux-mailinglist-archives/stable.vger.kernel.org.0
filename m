Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612733D553C
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 10:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhGZHgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 03:36:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231707AbhGZHgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 03:36:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627287397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yIF7WLgZ3sI73sCOTFvo6HTCUqvgf4OX+6hRCZKHcRY=;
        b=V/+vxQRRzbWDh3lkIiyc6GqMwPgPnQNbD5pseuxXkKH2xEaT/MHiveqKqXlEp951tYtBNP
        CFY5fHo7RhUZlEHzD7t/1KELSEOS7FJp0jLUkHIsqz/pocDYr6vYFFhjsZq9Tt6t8SS3xz
        6AiHbXchBDDMRcKU2vIMkFbKepVZr1A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-k5pHphZ-PpyQZs1Elegwwg-1; Mon, 26 Jul 2021 04:16:35 -0400
X-MC-Unique: k5pHphZ-PpyQZs1Elegwwg-1
Received: by mail-ed1-f71.google.com with SMTP id u25-20020aa7d8990000b02903bb6a903d90so1528035edq.17
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 01:16:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yIF7WLgZ3sI73sCOTFvo6HTCUqvgf4OX+6hRCZKHcRY=;
        b=a6XbIi9DaCEaDKcr/gLvyw8E7Agrew/FUO3VLsRf4ALxj03ysMuscDz5YA65aUbE+b
         2UMmv7fZNv5bdcEOsxjcqxE08igJvXAD3YveQETSbLnOivPCCX2g/jTAXbpfIQ5oGqHY
         kPmRsENVDAwH+gQWcw6PTWPMa48aJ3/lUuuV3dVsJMyzpuWu14LsRDcc44da7GqHFLbb
         62mxIg0Z1+6Lm6rV/Yixl7ccX8CzHRotR+v0LH92usfBtoobfZK3rWNKfZFHr9Irw9V9
         1imzFrLb1O6Dv1LytzzrdZaNJxmg8AEtBd9NnGy4g4cqiU1f0gYpBF/Xgir9DyREgIxA
         jwbg==
X-Gm-Message-State: AOAM5302CmWQyZC0MLxCKFnxBAa/d5/Za2I4tt4oZP2rEHqxzjWnlLsn
        24Y0h0VCfgX6eyzfLhF9ceGNM3ouuelkGIe+cFOcqjUbBCDPPaGE9nbW6e4gonh503ADgNlJLxG
        9J/2jlQMk6Rm4e/KD
X-Received: by 2002:a17:906:c302:: with SMTP id s2mr16050806ejz.151.1627287394297;
        Mon, 26 Jul 2021 01:16:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmG8F3CgBIcE6CannsRCjSYpsJuEN5fgAivKN92W5SzYH5Kp2ixx+xkvFt9Od/wP4+/jf6zw==
X-Received: by 2002:a17:906:c302:: with SMTP id s2mr16050795ejz.151.1627287394150;
        Mon, 26 Jul 2021 01:16:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id op23sm14002829ejb.7.2021.07.26.01.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 01:16:33 -0700 (PDT)
Subject: Re: [PATCH 4.19 2/2] KVM: do not allow mapping valid but
 non-reference-counted pages
To:     Ovidiu Panait <ovidiu.panait@windriver.com>, stable@vger.kernel.org
Cc:     stevensd@google.com, jannh@google.com, npiggin@gmail.com
References: <20210723201134.3031383-1-ovidiu.panait@windriver.com>
 <20210723201134.3031383-2-ovidiu.panait@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e562ad2b-f5ad-7c56-8482-45a645bd1b51@redhat.com>
Date:   Mon, 26 Jul 2021 10:16:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210723201134.3031383-2-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23/07/21 22:11, Ovidiu Panait wrote:
> From: Nicholas Piggin <npiggin@gmail.com>
> 
> commit f8be156be163a052a067306417cd0ff679068c97 upstream.
> 
> It's possible to create a region which maps valid but non-refcounted
> pages (e.g., tail pages of non-compound higher order allocations). These
> host pages can then be returned by gfn_to_page, gfn_to_pfn, etc., family
> of APIs, which take a reference to the page, which takes it from 0 to 1.
> When the reference is dropped, this will free the page incorrectly.
> 
> Fix this by only taking a reference on valid pages if it was non-zero,
> which indicates it is participating in normal refcounting (and can be
> released with put_page).
> 
> This addresses CVE-2021-22543.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> Tested-by: Paolo Bonzini <pbonzini@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>   virt/kvm/kvm_main.c | 19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6aeac96bf147..3559eba5f502 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1489,6 +1489,13 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
>   	return true;
>   }
>   
> +static int kvm_try_get_pfn(kvm_pfn_t pfn)
> +{
> +	if (kvm_is_reserved_pfn(pfn))
> +		return 1;
> +	return get_page_unless_zero(pfn_to_page(pfn));
> +}
> +
>   static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   			       unsigned long addr, bool *async,
>   			       bool write_fault, bool *writable,
> @@ -1538,13 +1545,21 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   	 * Whoever called remap_pfn_range is also going to call e.g.
>   	 * unmap_mapping_range before the underlying pages are freed,
>   	 * causing a call to our MMU notifier.
> +	 *
> +	 * Certain IO or PFNMAP mappings can be backed with valid
> +	 * struct pages, but be allocated without refcounting e.g.,
> +	 * tail pages of non-compound higher order allocations, which
> +	 * would then underflow the refcount when the caller does the
> +	 * required put_page. Don't allow those pages here.
>   	 */
> -	kvm_get_pfn(pfn);
> +	if (!kvm_try_get_pfn(pfn))
> +		r = -EFAULT;
>   
>   out:
>   	pte_unmap_unlock(ptep, ptl);
>   	*p_pfn = pfn;
> -	return 0;
> +
> +	return r;
>   }
>   
>   /*
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


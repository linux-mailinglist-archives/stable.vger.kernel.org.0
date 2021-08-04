Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96EF3DFD4C
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 10:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbhHDIvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 04:51:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235456AbhHDIvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 04:51:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628067090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gaSMtauxOtTadJuf0PxdSTVb19KzJdmSwiLcjg10gew=;
        b=gNaOQmK4XQGy/UaAiARgnS1mkL+2k+murSSIK//0TMWjre9GfQF7TlGJKGF+PAQt5KET6C
        1hBiURm/jhxuWMyiMFwx0bzYOgqL/InE3c0Nzs4CBUdUxY/sIedv9rvSUz29J2D0+IGwpM
        2YGn1R/F/tZdx38S8Cb1bIpIqMBMyvw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-BXGrG-0SOQypT9hK1Q3cDw-1; Wed, 04 Aug 2021 04:51:29 -0400
X-MC-Unique: BXGrG-0SOQypT9hK1Q3cDw-1
Received: by mail-ej1-f69.google.com with SMTP id gg35-20020a17090689a3b0290580ff45a075so575388ejc.20
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 01:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gaSMtauxOtTadJuf0PxdSTVb19KzJdmSwiLcjg10gew=;
        b=k2a2DzHar0uyofhiJo/JEuaMVZ5rIgSTRXPk0oUGdXrSew0wQUKdmrro5W82JXiGW2
         +za79a6t3t7jGrleJjJaHBEg4D4CetBU4wLod9G8gDj5ob3l4eYk7jrM1rRIAwqLW6sn
         /c5tdeTfqdEXU7hZWxMnxF8Cw2GB1fU6ZLynRovJOCMHVP7Kwvz0KCFOuMAYMpy+iPJO
         hsn2imbvLU+gLAUy2k045HyiyTCGWiXFnU3U6f8THZqrANKgCW5TnIenzntEGQGxvpjZ
         jX50LnT02J+ULuD60t2/RyyFiwWF+jfLensIkoVaXLNbbU1ecqFBWXyJmNmEvn1zH9WL
         oGwA==
X-Gm-Message-State: AOAM532dhtSrqVyC6KYTKI2Njv4ywYod5Tk4pFX15bcKD8d3CJlMbwhC
        5x+VKN6YMX+ljj5K5W8bVR25Bec13SPPHajsiqbp0e3AtVm1or67MWdDb3wTN+Eu3BcJtyoT7pl
        2wcIT5trMNaxa0xPvf2K5zuw6XhzkGDixLftppskE6u3gRh+eF9iC+ONAybfxyBwrOtaa
X-Received: by 2002:a50:9b16:: with SMTP id o22mr28409578edi.342.1628067088277;
        Wed, 04 Aug 2021 01:51:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwO0KlruRkujkJlLOdWahcMLV8a7IomU/DkgNvUUXCVHhHtzX/3zYb62mJKV3jJY5lWdrCKJA==
X-Received: by 2002:a50:9b16:: with SMTP id o22mr28409559edi.342.1628067088126;
        Wed, 04 Aug 2021 01:51:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id w6sm658559edd.22.2021.08.04.01.51.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 01:51:27 -0700 (PDT)
Subject: Re: [PATCH 4.14 2/3] KVM: do not allow mapping valid but
 non-reference-counted pages
To:     Ovidiu Panait <ovidiu.panait@windriver.com>, stable@vger.kernel.org
References: <20210803135521.2603575-1-ovidiu.panait@windriver.com>
 <20210803135521.2603575-2-ovidiu.panait@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d853fd33-02e6-f8e4-de16-4e3e88a991e3@redhat.com>
Date:   Wed, 4 Aug 2021 10:51:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210803135521.2603575-2-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/08/21 15:55, Ovidiu Panait wrote:
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
> index 4e23d0b4b810..469361d01116 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1485,6 +1485,13 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
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
> @@ -1534,13 +1541,21 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
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


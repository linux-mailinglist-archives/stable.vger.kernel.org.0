Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E063D553B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 10:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhGZHfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 03:35:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41188 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231707AbhGZHfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 03:35:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627287381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F2iQWR/fPfVCY/ICOS4oVHqZhA4R7bJqSP5unOpfSFA=;
        b=QVEIQNlY0MKv17I4Nvs5RAnLugQjR7uzbe6eEiEXxaHm9KKZXfl0UakW4wZDgUOHpxom4A
        QSTxd66t+cBSdhBfC8Bf7vQDQLX23qVkScChvObstK7JLBn6u8u1r8ARGHZ5SgOBeThbeo
        G7EV0leY1UdKBPgZPOJ2sNcH93WITAY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-Juq406j_PRKjY8W6fDfZgA-1; Mon, 26 Jul 2021 04:16:20 -0400
X-MC-Unique: Juq406j_PRKjY8W6fDfZgA-1
Received: by mail-ej1-f72.google.com with SMTP id qf6-20020a1709077f06b029057e66b6665aso861357ejc.18
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 01:16:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F2iQWR/fPfVCY/ICOS4oVHqZhA4R7bJqSP5unOpfSFA=;
        b=dahfAQbaKvVNk/irWose8WNvHONTB2m8c7d+R/YuFR/01BguyHBIoHYEw+Uh996le0
         Z7iHFYW2memwHWixo75m35Ou0Vmx1WRN00XQ06ThMiFpSbO2Aq6/akTTENbIjXVds+i7
         piOREy99+OduCVYVR2iITemXjyS/AQyEHEVlt2l3Z36sAoqUz2Vqc8uBM7OvLpAgmcEY
         iBWV1YONufomqwLn1hcyI96H8xA6fFN61G2/F3vx0xUYjvJC0Noij/kaKmbcN6e84/bN
         IUI4JdIq36mtBhnAD8UJJmTQjXfrTU2yCDlr4Pi/ZZZZPlZI3sXx1zHL3ffELzCQ8ptY
         jW8g==
X-Gm-Message-State: AOAM532DayvK21itg3s5vPolv5RyYgQUp7QP+3vbIB3J3TYMXtCWveDV
        gQq0pZkimoQ8FoZLVirS+9hPnPZx9G7RVlpLgv8fTkYPQobL2EBmK+2mTQW2JnS2y1/gv44bnU6
        DyBCuJKWZCOFaQx7B
X-Received: by 2002:a05:6402:b4e:: with SMTP id bx14mr19980069edb.158.1627287379040;
        Mon, 26 Jul 2021 01:16:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvlwNUpV4PZG2udeTQIg49HRF1Qx9LzkFRIzJWqJYzdpEqI+OvbIM77dHVGSImP6iS1xa5jA==
X-Received: by 2002:a05:6402:b4e:: with SMTP id bx14mr19980059edb.158.1627287378917;
        Mon, 26 Jul 2021 01:16:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n2sm18648184edi.32.2021.07.26.01.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 01:16:18 -0700 (PDT)
Subject: Re: [PATCH 4.19 1/2] KVM: do not assume PTE is writable after
 follow_pfn
To:     Ovidiu Panait <ovidiu.panait@windriver.com>, stable@vger.kernel.org
Cc:     stevensd@google.com, jannh@google.com, npiggin@gmail.com
References: <20210723201134.3031383-1-ovidiu.panait@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d854104d-6afd-befe-231f-5210c75f3eb8@redhat.com>
Date:   Mon, 26 Jul 2021 10:16:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210723201134.3031383-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23/07/21 22:11, Ovidiu Panait wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> commit bd2fae8da794b55bf2ac02632da3a151b10e664c upstream.
> 
> In order to convert an HVA to a PFN, KVM usually tries to use
> the get_user_pages family of functinso.  This however is not
> possible for VM_IO vmas; in that case, KVM instead uses follow_pfn.
> 
> In doing this however KVM loses the information on whether the
> PFN is writable.  That is usually not a problem because the main
> use of VM_IO vmas with KVM is for BARs in PCI device assignment,
> however it is a bug.  To fix it, use follow_pte and check pte_write
> while under the protection of the PTE lock.  The information can
> be used to fail hva_to_pfn_remapped or passed back to the
> caller via *writable.
> 
> Usage of follow_pfn was introduced in commit add6a0cd1c5b ("KVM: MMU: try to fix
> up page faults before giving up", 2016-07-05); however, even older version
> have the same issue, all the way back to commit 2e2e3738af33 ("KVM:
> Handle vma regions with no backing page", 2008-07-20), as they also did
> not check whether the PFN was writable.
> 
> Fixes: 2e2e3738af33 ("KVM: Handle vma regions with no backing page")
> Reported-by: David Stevens <stevensd@google.com>
> Cc: 3pvd@google.com
> Cc: Jann Horn <jannh@google.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [OP: backport to 4.19, adjust follow_pte() -> follow_pte_pmd()]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>   virt/kvm/kvm_main.c | 15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 1ecb27b3421a..6aeac96bf147 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1495,9 +1495,11 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   			       kvm_pfn_t *p_pfn)
>   {
>   	unsigned long pfn;
> +	pte_t *ptep;
> +	spinlock_t *ptl;
>   	int r;
>   
> -	r = follow_pfn(vma, addr, &pfn);
> +	r = follow_pte_pmd(vma->vm_mm, addr, NULL, NULL, &ptep, NULL, &ptl);
>   	if (r) {
>   		/*
>   		 * get_user_pages fails for VM_IO and VM_PFNMAP vmas and does
> @@ -1512,14 +1514,19 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   		if (r)
>   			return r;
>   
> -		r = follow_pfn(vma, addr, &pfn);
> +		r = follow_pte_pmd(vma->vm_mm, addr, NULL, NULL, &ptep, NULL, &ptl);
>   		if (r)
>   			return r;
> +	}
>   
> +	if (write_fault && !pte_write(*ptep)) {
> +		pfn = KVM_PFN_ERR_RO_FAULT;
> +		goto out;
>   	}
>   
>   	if (writable)
> -		*writable = true;
> +		*writable = pte_write(*ptep);
> +	pfn = pte_pfn(*ptep);
>   
>   	/*
>   	 * Get a reference here because callers of *hva_to_pfn* and
> @@ -1534,6 +1541,8 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   	 */
>   	kvm_get_pfn(pfn);
>   
> +out:
> +	pte_unmap_unlock(ptep, ptl);
>   	*p_pfn = pfn;
>   	return 0;
>   }
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


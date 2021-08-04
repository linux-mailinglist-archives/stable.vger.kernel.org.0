Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C36B3DFD4B
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 10:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbhHDIvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 04:51:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55954 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235456AbhHDIvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 04:51:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628067080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HtbTKGAwy+APkp9aiVQbkhffpYPCPITp45lCe5lgXQY=;
        b=hpCxNf9h25xow8aLxOLLQz6kuTU99c78+G3H+2tHrmGDAVxwj2pcYQvSDbTvc3cc+Ga7sY
        eVxNOlf5DyEGcgbWY2JafVxmDFmXMaUK/hRijDNkNQ2jzMxAyNyexjcEp7uc7ALPoKqycP
        09SzDnuEVbWC85TfPD9goATbn5ZqNFs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-z3Uyqt2oN3mbV5znnKGz2A-1; Wed, 04 Aug 2021 04:51:19 -0400
X-MC-Unique: z3Uyqt2oN3mbV5znnKGz2A-1
Received: by mail-ed1-f69.google.com with SMTP id b13-20020a056402278db029039c013d5b80so1120509ede.7
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 01:51:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HtbTKGAwy+APkp9aiVQbkhffpYPCPITp45lCe5lgXQY=;
        b=gOSaje0412v59klMliFAFi9UcZTx2Mu1exy2jBAzF4j/piTVMknGbxGTOA8MPtTawo
         7OKodOx+pPkT2yquKC9rJ0+iyBMDyRimjyjGAha0UcMqae+74shQ47VquTYdV5X0OOax
         0AilfrKPdPaAkMkRaKdlSRyocGvosXY0tvg97TlwLVHUmizPChZNezj5FDXpUrp/IAkQ
         jFoUqMVPJ9S7N4lNVNywubdMFb7ocwxuhxzNb+72xtzPI3hSnbjusyGdfRL+QA5/Notl
         kW1m3HatNT2UuHQV1AZ79cOvql+yeo25Jp/paTxWxMIDLprwOXwk1t15mdWQlM/YaVlP
         8AGA==
X-Gm-Message-State: AOAM5319ChDHq+kAuSruGXYk5VOij4XAeMPopWiR0ldD9hPk34uwifUu
        RmGbvH5FfTXnMWx4Yjmd3STHECUO0Q6hBp8FQGvocbCJ1eI9zUUshitPKzDV5uGRi8lTRTQveUI
        qAvdX533ul+bMz6hSi7knza7aoyHO8X+PRujJNQj5gppkm9FXwGv0mK47jlY8taPTWkzr
X-Received: by 2002:a17:906:6490:: with SMTP id e16mr24273028ejm.467.1628067078167;
        Wed, 04 Aug 2021 01:51:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXhO7F3DMIM44uYe4F6hyXqwiLRc52wNtZHVMYde5quVFBM22b7EpFb91/SHHlC2is16s8IA==
X-Received: by 2002:a17:906:6490:: with SMTP id e16mr24273013ejm.467.1628067077964;
        Wed, 04 Aug 2021 01:51:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id g8sm662707edw.89.2021.08.04.01.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 01:51:17 -0700 (PDT)
Subject: Re: [PATCH 4.14 1/3] KVM: do not assume PTE is writable after
 follow_pfn
To:     Ovidiu Panait <ovidiu.panait@windriver.com>, stable@vger.kernel.org
References: <20210803135521.2603575-1-ovidiu.panait@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cb9ce276-972b-31a0-f3c5-ea26227f8658@redhat.com>
Date:   Wed, 4 Aug 2021 10:51:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210803135521.2603575-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/08/21 15:55, Ovidiu Panait wrote:
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
> [OP: backport to 4.14, adjust follow_pte() -> follow_pte_pmd()]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>   virt/kvm/kvm_main.c | 15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 547ae59199db..4e23d0b4b810 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1491,9 +1491,11 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
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
> @@ -1508,14 +1510,19 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
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
> @@ -1530,6 +1537,8 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
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


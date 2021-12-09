Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A0E46F62C
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 22:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhLIVvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 16:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhLIVvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 16:51:38 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119ECC0617A2
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 13:48:04 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id m24so4889474pls.10
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 13:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8u1RdndtwaGuHxWx/fyS/o76eZaEiG1iSAyvhYohYQI=;
        b=knsg3iw10lckcvL/Yr+MVQ58SDQdLFyk8NpPtr5+Vdw3CUkquAyf0ujIde2qMrY/hB
         jbDhS3XoAdvzOlgh+DGy2LyONMVw4q9rxZSqDoE41QuioOFzL4rvIcJX5q1mJTvvQ6au
         Ta9hgWDZOLAwO5xcHUhaXSNeeoYbQmfq7B3BzSj+XsSx26UG7pGGLaUJUItwS4RfVHHE
         EJ/cudYAVo+QMypyH5Jp/EgrQcK2Dep3yC7yV+xA/ZteZoIauYewntyonAGpiX/X+tMd
         N23B8GWS3+gCxGZGcAyTw9ZbqvlK/IW7dZNOrPB1NSKdotFwwPC9BIrCz7s//poNQv8R
         ML6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8u1RdndtwaGuHxWx/fyS/o76eZaEiG1iSAyvhYohYQI=;
        b=extt+gvdzzcR8D9a5pNqLm47aqao5YpU5wzAtkYUp3SicGVZmmhM47QHnfu5yelEts
         HZ7rshVt2EfPbsH59rJTiRVVEX3TWwrvov2PKR5XEWPrpIGmjiEttjwag8SArw77cTx/
         BtF6pUp/cbjQPlfHhS5CcyLnRcMInLCu89CK0lBQzap4Usc9WXfvqaOAvShZTrILrC5M
         XePoU7hURCsT8y4pUSgeO9CguQYb1NqgZYB0EWj3Hndog4I1nHaoMeLxFOhlF32mUvew
         rxCY0G7tdQ9/fqiDBfhnHPM9uOqAcOS4yfRHemslEQWzdRG0DzoFsmmgGcfqGb45X4Az
         OuqQ==
X-Gm-Message-State: AOAM531uiujN/1YSbRUxEA8riRr67VCXwR49zU0N8Chwelw3/eq6CEAX
        8Peiyk2gGmdYjFUEeUfcoW0tyw==
X-Google-Smtp-Source: ABdhPJx3iAM4QvC/YeiKhY5HZQaxbii/oD8MpYuJCDnaxMX16W9Awm1RxsSLUynoS9utfpNu4vfpFw==
X-Received: by 2002:a17:90b:4b0e:: with SMTP id lx14mr19384187pjb.160.1639086483348;
        Thu, 09 Dec 2021 13:48:03 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u13sm546735pgp.27.2021.12.09.13.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 13:48:02 -0800 (PST)
Date:   Thu, 9 Dec 2021 21:47:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com,
        joao.m.martins@oracle.com, stable@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2] selftests: KVM: avoid failures due to reserved
 HyperTransport region
Message-ID: <YbJ5jyCyqZwZU3uH@google.com>
References: <20211209205256.301140-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209205256.301140-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021, Paolo Bonzini wrote:
> +unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
> +{
> +	const unsigned long num_ht_pages = 12 << 18; /* 12 GiB */
> +	unsigned long ht_gfn, max_gfn, max_pfn;
> +	uint32_t eax, ebx, ecx, edx;
> +
> +	max_gfn = (1ULL << (vm->pa_bits - vm->page_shift)) - 1;
> +
> +	/* Avoid reserved HyperTransport region on AMD processors.  */
> +	eax = ecx = 0;
> +	cpuid(&eax, &ebx, &ecx, &edx);
> +	if (ebx != X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx ||
> +	    ecx != X86EMUL_CPUID_VENDOR_AuthenticAMD_ecx ||
> +	    edx != X86EMUL_CPUID_VENDOR_AuthenticAMD_edx)
> +		return max_gfn;
> +
> +	/* On parts with <40 physical address bits, the area is fully hidden */
> +	if (vm->pa_bits < 40)
> +		return max_gfn;
> +
> +	eax = 1;
> +	cpuid(&eax, &ebx, &ecx, &edx);
> +	if (x86_family(eax) < 0x17) {
> +		/* Before family 17h, the HyperTransport area is just below 1T.  */
> +		ht_gfn = (1 << 28) - num_ht_pages;
> +	} else {
> +		/*
> +		 * Otherwise it's at the top of the physical address
> +		 * space, possibly reduced due to SME by bits 11:6 of
> +		 * CPUID[0x8000001f].EBX.
> +		 */
> +		eax = 0x80000008;
> +		cpuid(&eax, &ebx, &ecx, &edx);

Should't this check 0x80000000.eax >= 0x80000008 first?  Or do we just accept
failure if family==0x17 and there's no 0x80000008?  One paranoid option would be
to use the pre-fam17 value, e.g.

        /* Before family 17h, the HyperTransport area is just below 1T. */
        ht_gfn = (1 << 28) - num_ht_pages;
        if (x86_family(eax) < 0x17)
                goto out;

        eax = 0x80000000;
        cpuid(&eax, &ebx, &ecx, &edx);
        max_ext_leaf = eax;

        /* Use the old, conservative value if MAXPHYADDR isn't enumerated. */
        if (max_ext_leaf < 0x80000008)
                goto out;

        /* comment */
        eax = 0x80000008;
        cpuid(&eax, &ebx, &ecx, &edx);
        max_pfn = (1ULL << ((eax & 255) - vm->page_shift)) - 1;
        if (max_ext_leaf >= 0x8000001f) {
                <adjust>
        }
        ht_gfn = max_pfn - num_ht_pages;
out:
        return min(max_gfn, ht_gfn - 1);

> +             max_pfn = (1ULL << ((eax & 255) - vm->page_shift)) - 1;

LOL, "& 255", you just couldn't resist, huh?  My version of Rami Code only goes
up to 15.  :-)

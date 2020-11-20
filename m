Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344092BB135
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 18:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbgKTRJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 12:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729976AbgKTRJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 12:09:07 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD88C0613CF;
        Fri, 20 Nov 2020 09:09:07 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id q28so7819546pgk.1;
        Fri, 20 Nov 2020 09:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S7NIupRzj3PUr0ZCv6mIkIMUnIw4nNedbT1JtFuJtQg=;
        b=BvT8QPjD5F7pdrvLKVYHj/ZNriTsFhgHF0+BQGonq0YOOD95joc0eNp0bAs+Hkjf7m
         VsBdwUQzy6pXLrmYme9/muSh4pCnjkh6yz62WbhxtW1qPMUoi9ebWuWOAiLjXd7YJ4XC
         A8saEcMIVPKB0lm4zCVrdXDRvOMkpBmKIwmjmqIpkPN0YyxroxoTKQSqpe/co9EUL/+n
         cIpUF4r0BVJ+Yr92UWOx1bvF84n5cmD4NhwxTn2OSF4IDKBhFip3fD+dhWbkKN0aut1Y
         qQ/6NXEztDeGU8shSrglSPk9jpK+dCBaEK1I2T3CoWEUUkrF0t0XRETSC5WoYsJ5mfiF
         nxAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=S7NIupRzj3PUr0ZCv6mIkIMUnIw4nNedbT1JtFuJtQg=;
        b=NuYpNMUfxHi7p87UkXdbO4ycD0TfSiKe6pE4O4z8OYlQmoLvQMay2TTFjZcldgNaHR
         I16tukX3JDhAfVD5GmX+qthWYNZcYFmNtT+Oj/8MD0KO7lkSxHW/Kx9YN3X5IRniPXKb
         o8C7kGCO+O6a9wiNHTDl7dlsKyeUcnASL7LDmlt51rpXq86GJCOv0hrCxg+Oz8TLCwLt
         p4tIpu2AV8zF9iPW8JhD4T7+QAS854f9Wdt3GM9vDmBpYjJIOrBABzQbRsgX3ovoU4PU
         dxkt4uUSp08Ft/X0U42L4xR5H5+90goNwsTFhZ1i6rn4ahybF1yqCyExJqy65S92EVZ1
         T3mQ==
X-Gm-Message-State: AOAM533DsoUrdHoGTro7yJtLIInVWMJcvHqBcJ80/U1UhpANuqcqWgGS
        lYZkm+aSjXsDlnh0lQywh0Y=
X-Google-Smtp-Source: ABdhPJyA750sKahKtUX1refXtKAQhPqtVn1tIpVDVcrxdlyb5F7dNflMGdvgDmmn4jagOr89LRPoPg==
X-Received: by 2002:a62:cec6:0:b029:18a:d620:6b86 with SMTP id y189-20020a62cec60000b029018ad6206b86mr14299369pfg.2.1605892146573;
        Fri, 20 Nov 2020 09:09:06 -0800 (PST)
Received: from google.com ([2620:15c:211:201:7220:84ff:fe09:5e58])
        by smtp.gmail.com with ESMTPSA id z11sm4244993pfk.52.2020.11.20.09.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 09:09:05 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Fri, 20 Nov 2020 09:09:03 -0800
From:   Minchan Kim <minchan@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Yu Zhao <yuzhao@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/6] arm64: pgtable: Ensure dirty bit is preserved across
 pte_wrprotect()
Message-ID: <20201120170903.GC3377168@google.com>
References: <20201120143557.6715-1-will@kernel.org>
 <20201120143557.6715-3-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120143557.6715-3-will@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 20, 2020 at 02:35:53PM +0000, Will Deacon wrote:
> With hardware dirty bit management, calling pte_wrprotect() on a writable,
> dirty PTE will lose the dirty state and return a read-only, clean entry.
> 
> Move the logic from ptep_set_wrprotect() into pte_wrprotect() to ensure that
> the dirty bit is preserved for writable entries, as this is required for
> soft-dirty bit management if we enable it in the future.
> 
> Cc: <stable@vger.kernel.org>

It this stable material if it would be a problem once ARM64 supports
softdirty in future?

> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/pgtable.h | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 1bdf51f01e73..a155551863c9 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -162,13 +162,6 @@ static inline pmd_t set_pmd_bit(pmd_t pmd, pgprot_t prot)
>  	return pmd;
>  }
>  
> -static inline pte_t pte_wrprotect(pte_t pte)
> -{
> -	pte = clear_pte_bit(pte, __pgprot(PTE_WRITE));
> -	pte = set_pte_bit(pte, __pgprot(PTE_RDONLY));
> -	return pte;
> -}
> -
>  static inline pte_t pte_mkwrite(pte_t pte)
>  {
>  	pte = set_pte_bit(pte, __pgprot(PTE_WRITE));
> @@ -194,6 +187,20 @@ static inline pte_t pte_mkdirty(pte_t pte)
>  	return pte;
>  }
>  
> +static inline pte_t pte_wrprotect(pte_t pte)
> +{
> +	/*
> +	 * If hardware-dirty (PTE_WRITE/DBM bit set and PTE_RDONLY
> +	 * clear), set the PTE_DIRTY bit.
> +	 */
> +	if (pte_hw_dirty(pte))
> +		pte = pte_mkdirty(pte);
> +
> +	pte = clear_pte_bit(pte, __pgprot(PTE_WRITE));
> +	pte = set_pte_bit(pte, __pgprot(PTE_RDONLY));
> +	return pte;
> +}
> +
>  static inline pte_t pte_mkold(pte_t pte)
>  {
>  	return clear_pte_bit(pte, __pgprot(PTE_AF));
> @@ -843,12 +850,6 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addres
>  	pte = READ_ONCE(*ptep);
>  	do {
>  		old_pte = pte;
> -		/*
> -		 * If hardware-dirty (PTE_WRITE/DBM bit set and PTE_RDONLY
> -		 * clear), set the PTE_DIRTY bit.
> -		 */
> -		if (pte_hw_dirty(pte))
> -			pte = pte_mkdirty(pte);
>  		pte = pte_wrprotect(pte);
>  		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
>  					       pte_val(old_pte), pte_val(pte));
> -- 
> 2.29.2.454.gaff20da3a2-goog
> 

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C79361134F4
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbfLDS1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:27:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:60136 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728328AbfLDS1u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:27:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9D3CDB256;
        Wed,  4 Dec 2019 18:27:46 +0000 (UTC)
Subject: Re: [PATCH 4.9 105/125] mm, gup: add missing refcount overflow checks
 on x86 and s390
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
References: <20191204175308.377746305@linuxfoundation.org>
 <20191204175325.500930880@linuxfoundation.org>
From:   Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; prefer-encrypt=mutual; keydata=
 mQINBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABtCBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PokCVAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJcbbyGBQkH8VTqAAoJECJPp+fMgqZkpGoP
 /1jhVihakxw1d67kFhPgjWrbzaeAYOJu7Oi79D8BL8Vr5dmNPygbpGpJaCHACWp+10KXj9yz
 fWABs01KMHnZsAIUytVsQv35DMMDzgwVmnoEIRBhisMYOQlH2bBn/dqBjtnhs7zTL4xtqEcF
 1hoUFEByMOey7gm79utTk09hQE/Zo2x0Ikk98sSIKBETDCl4mkRVRlxPFl4O/w8dSaE4eczH
 LrKezaFiZOv6S1MUKVKzHInonrCqCNbXAHIeZa3JcXCYj1wWAjOt9R3NqcWsBGjFbkgoKMGD
 usiGabetmQjXNlVzyOYdAdrbpVRNVnaL91sB2j8LRD74snKsV0Wzwt90YHxDQ5z3M75YoIdl
 byTKu3BUuqZxkQ/emEuxZ7aRJ1Zw7cKo/IVqjWaQ1SSBDbZ8FAUPpHJxLdGxPRN8Pfw8blKY
 8mvLJKoF6i9T6+EmlyzxqzOFhcc4X5ig5uQoOjTIq6zhLO+nqVZvUDd2Kz9LMOCYb516cwS/
 Enpi0TcZ5ZobtLqEaL4rupjcJG418HFQ1qxC95u5FfNki+YTmu6ZLXy+1/9BDsPuZBOKYpUm
 3HWSnCS8J5Ny4SSwfYPH/JrtberWTcCP/8BHmoSpS/3oL3RxrZRRVnPHFzQC6L1oKvIuyXYF
 rkybPXYbmNHN+jTD3X8nRqo+4Qhmu6SHi3VquQENBFsZNQwBCACuowprHNSHhPBKxaBX7qOv
 KAGCmAVhK0eleElKy0sCkFghTenu1sA9AV4okL84qZ9gzaEoVkgbIbDgRbKY2MGvgKxXm+kY
 n8tmCejKoeyVcn9Xs0K5aUZiDz4Ll9VPTiXdf8YcjDgeP6/l4kHb4uSW4Aa9ds0xgt0gP1Xb
 AMwBlK19YvTDZV5u3YVoGkZhspfQqLLtBKSt3FuxTCU7hxCInQd3FHGJT/IIrvm07oDO2Y8J
 DXWHGJ9cK49bBGmK9B4ajsbe5GxtSKFccu8BciNluF+BqbrIiM0upJq5Xqj4y+Xjrpwqm4/M
 ScBsV0Po7qdeqv0pEFIXKj7IgO/d4W2bABEBAAGJA3IEGAEKACYWIQSpQNQ0mSwujpkQPVAi
 T6fnzIKmZAUCWxk1DAIbAgUJA8JnAAFACRAiT6fnzIKmZMB0IAQZAQoAHRYhBKZ2GgCcqNxn
 k0Sx9r6Fd25170XjBQJbGTUMAAoJEL6Fd25170XjDBUH/2jQ7a8g+FC2qBYxU/aCAVAVY0NE
 YuABL4LJ5+iWwmqUh0V9+lU88Cv4/G8fWwU+hBykSXhZXNQ5QJxyR7KWGy7LiPi7Cvovu+1c
 9Z9HIDNd4u7bxGKMpn19U12ATUBHAlvphzluVvXsJ23ES/F1c59d7IrgOnxqIcXxr9dcaJ2K
 k9VP3TfrjP3g98OKtSsyH0xMu0MCeyewf1piXyukFRRMKIErfThhmNnLiDbaVy6biCLx408L
 Mo4cCvEvqGKgRwyckVyo3JuhqreFeIKBOE1iHvf3x4LU8cIHdjhDP9Wf6ws1XNqIvve7oV+w
 B56YWoalm1rq00yUbs2RoGcXmtX1JQ//aR/paSuLGLIb3ecPB88rvEXPsizrhYUzbe1TTkKc
 4a4XwW4wdc6pRPVFMdd5idQOKdeBk7NdCZXNzoieFntyPpAq+DveK01xcBoXQ2UktIFIsXey
 uSNdLd5m5lf7/3f0BtaY//f9grm363NUb9KBsTSnv6Vx7Co0DWaxgC3MFSUhxzBzkJNty+2d
 10jvtwOWzUN+74uXGRYSq5WefQWqqQNnx+IDb4h81NmpIY/X0PqZrapNockj3WHvpbeVFAJ0
 9MRzYP3x8e5OuEuJfkNnAbwRGkDy98nXW6fKeemREjr8DWfXLKFWroJzkbAVmeIL0pjXATxr
 +tj5JC0uvMrrXefUhXTo0SNoTsuO/OsAKOcVsV/RHHTwCDR2e3W8mOlA3QbYXsscgjghbuLh
 J3oTRrOQa8tUXWqcd5A0+QPo5aaMHIK0UAthZsry5EmCY3BrbXUJlt+23E93hXQvfcsmfi0N
 rNh81eknLLWRYvMOsrbIqEHdZBT4FHHiGjnck6EYx/8F5BAZSodRVEAgXyC8IQJ+UVa02QM5
 D2VL8zRXZ6+wARKjgSrW+duohn535rG/ypd0ctLoXS6dDrFokwTQ2xrJiLbHp9G+noNTHSan
 ExaRzyLbvmblh3AAznb68cWmM3WVkceWACUalsoTLKF1sGrrIBj5updkKkzbKOq5gcC5AQ0E
 Wxk1NQEIAJ9B+lKxYlnKL5IehF1XJfknqsjuiRzj5vnvVrtFcPlSFL12VVFVUC2tT0A1Iuo9
 NAoZXEeuoPf1dLDyHErrWnDyn3SmDgb83eK5YS/K363RLEMOQKWcawPJGGVTIRZgUSgGusKL
 NuZqE5TCqQls0x/OPljufs4gk7E1GQEgE6M90Xbp0w/r0HB49BqjUzwByut7H2wAdiNAbJWZ
 F5GNUS2/2IbgOhOychHdqYpWTqyLgRpf+atqkmpIJwFRVhQUfwztuybgJLGJ6vmh/LyNMRr8
 J++SqkpOFMwJA81kpjuGR7moSrUIGTbDGFfjxmskQV/W/c25Xc6KaCwXah3OJ40AEQEAAYkC
 PAQYAQoAJhYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJbGTU1AhsMBQkDwmcAAAoJECJPp+fM
 gqZkPN4P/Ra4NbETHRj5/fM1fjtngt4dKeX/6McUPDIRuc58B6FuCQxtk7sX3ELs+1+w3eSV
 rHI5cOFRSdgw/iKwwBix8D4Qq0cnympZ622KJL2wpTPRLlNaFLoe5PkoORAjVxLGplvQIlhg
 miljQ3R63ty3+MZfkSVsYITlVkYlHaSwP2t8g7yTVa+q8ZAx0NT9uGWc/1Sg8j/uoPGrctml
 hFNGBTYyPq6mGW9jqaQ8en3ZmmJyw3CHwxZ5FZQ5qc55xgshKiy8jEtxh+dgB9d8zE/S/UGI
 E99N/q+kEKSgSMQMJ/CYPHQJVTi4YHh1yq/qTkHRX+ortrF5VEeDJDv+SljNStIxUdroPD29
 2ijoaMFTAU+uBtE14UP5F+LWdmRdEGS1Ah1NwooL27uAFllTDQxDhg/+LJ/TqB8ZuidOIy1B
 xVKRSg3I2m+DUTVqBy7Lixo73hnW69kSjtqCeamY/NSu6LNP+b0wAOKhwz9hBEwEHLp05+mj
 5ZFJyfGsOiNUcMoO/17FO4EBxSDP3FDLllpuzlFD7SXkfJaMWYmXIlO0jLzdfwfcnDzBbPwO
 hBM8hvtsyq8lq8vJOxv6XD6xcTtj5Az8t2JjdUX6SF9hxJpwhBU0wrCoGDkWp4Bbv6jnF7zP
 Nzftr4l8RuJoywDIiJpdaNpSlXKpj/K6KrnyAI/joYc7
Message-ID: <7ca516fa-c526-b5e6-4b7c-855f229112ac@suse.cz>
Date:   Wed, 4 Dec 2019 19:27:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191204175325.500930880@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/4/19 6:56 PM, Greg Kroah-Hartman wrote:
> From: Vlastimil Babka <vbabka@suse.cz>
> 
> The mainline commit 8fde12ca79af ("mm: prevent get_user_pages() from
> overflowing page refcount") was backported to 4.9.y stable as commit
> 2ed768cfd895. The backport however missed that in 4.9, there are several
> arch-specific gup.c versions with fast gup implementations, so these do not
> prevent refcount overflow.
> 
> This is partially fixed for x86 in stable-only commit d73af79742e7 ("x86, mm,
> gup: prevent get_page() race with munmap in paravirt guest"). This stable-only
> commit adds missing parts to x86 version, as well as s390 version, both taken
> from the SUSE SLES/openSUSE 4.12-based kernels.
> 
> The remaining architectures with own gup.c are sparc, mips, sh. It's unlikely
> the known overflow scenario based on FUSE, which needs 140GB of RAM, is a
> problem for those architectures, and I don't feel confident enough to patch
> them.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

No, this one had a leak bug and I've sent updated version:
https://lore.kernel.org/linux-mm/e274291b-054f-2fad-28e8-59fabf312e61@suse.cz/

> ---
>  arch/s390/mm/gup.c |  9 ++++++---
>  arch/x86/mm/gup.c  | 10 ++++++++--
>  2 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
> index 97fc449a74707..33a940389a6d1 100644
> --- a/arch/s390/mm/gup.c
> +++ b/arch/s390/mm/gup.c
> @@ -38,7 +38,8 @@ static inline int gup_pte_range(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
>  		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
>  		page = pte_page(pte);
>  		head = compound_head(page);
> -		if (!page_cache_get_speculative(head))
> +		if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)
> +		    || !page_cache_get_speculative(head)))
>  			return 0;
>  		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
>  			put_page(head);
> @@ -76,7 +77,8 @@ static inline int gup_huge_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
>  		refs++;
>  	} while (addr += PAGE_SIZE, addr != end);
>  
> -	if (!page_cache_add_speculative(head, refs)) {
> +	if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)
> +	    || !page_cache_add_speculative(head, refs))) {
>  		*nr -= refs;
>  		return 0;
>  	}
> @@ -150,7 +152,8 @@ static int gup_huge_pud(pud_t *pudp, pud_t pud, unsigned long addr,
>  		refs++;
>  	} while (addr += PAGE_SIZE, addr != end);
>  
> -	if (!page_cache_add_speculative(head, refs)) {
> +	if (unlikely(WARN_ON_ONCE(page_ref_count(head) < 0)
> +	    || !page_cache_add_speculative(head, refs))) {
>  		*nr -= refs;
>  		return 0;
>  	}
> diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
> index d7db45bdfb3bd..551fc7fea046d 100644
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -202,10 +202,12 @@ static int __gup_device_huge_pmd(pmd_t pmd, unsigned long addr,
>  			undo_dev_pagemap(nr, nr_start, pages);
>  			return 0;
>  		}
> +		if (unlikely(!try_get_page(page))) {
> +			put_dev_pagemap(pgmap);
> +			return 0;
> +		}
>  		SetPageReferenced(page);
>  		pages[*nr] = page;
> -		get_page(page);
> -		put_dev_pagemap(pgmap);
>  		(*nr)++;
>  		pfn++;
>  	} while (addr += PAGE_SIZE, addr != end);
> @@ -230,6 +232,8 @@ static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
>  
>  	refs = 0;
>  	head = pmd_page(pmd);
> +	if (WARN_ON_ONCE(page_ref_count(head) <= 0))
> +		return 0;
>  	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>  	do {
>  		VM_BUG_ON_PAGE(compound_head(page) != head, page);
> @@ -289,6 +293,8 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
>  
>  	refs = 0;
>  	head = pud_page(pud);
> +	if (WARN_ON_ONCE(page_ref_count(head) <= 0))
> +		return 0;
>  	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
>  	do {
>  		VM_BUG_ON_PAGE(compound_head(page) != head, page);
> 


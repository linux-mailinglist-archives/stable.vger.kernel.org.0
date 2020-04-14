Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1122E1A7B35
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 14:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502259AbgDNMtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 08:49:53 -0400
Received: from foss.arm.com ([217.140.110.172]:54680 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502250AbgDNMtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 08:49:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 637941FB;
        Tue, 14 Apr 2020 05:49:51 -0700 (PDT)
Received: from [192.168.1.172] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 568493F73D;
        Tue, 14 Apr 2020 05:49:50 -0700 (PDT)
Subject: Re: [PATCH 1/5] arm64: vdso: don't free unallocated pages
To:     Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     catalin.marinas@arm.com, will@kernel.org, stable@vger.kernel.org
References: <20200414104252.16061-1-mark.rutland@arm.com>
 <20200414104252.16061-2-mark.rutland@arm.com>
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
Message-ID: <c5596228-2685-abb3-5ab1-9519759e1f7a@arm.com>
Date:   Tue, 14 Apr 2020 13:50:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200414104252.16061-2-mark.rutland@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mark,

On 4/14/20 11:42 AM, Mark Rutland wrote:
> The aarch32_vdso_pages[] array never has entries allocated in the C_VVAR
> or C_VDSO slots, and as the array is zero initialized these contain
> NULL.
> 
> However in __aarch32_alloc_vdso_pages() when
> aarch32_alloc_kuser_vdso_page() fails we attempt to free the page whose
> struct page is at NULL, which is obviously nonsensical.
> 

Could you please explain why do you think that free(NULL) is "nonsensical"? And
if this is causing a bug (according to the cover-letter), could you please
provide a stack-trace?

> This patch removes the erroneous page freeing.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/kernel/vdso.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
> index 354b11e27c07..033a48f30dbb 100644
> --- a/arch/arm64/kernel/vdso.c
> +++ b/arch/arm64/kernel/vdso.c
> @@ -260,18 +260,7 @@ static int __aarch32_alloc_vdso_pages(void)
>  	if (ret)
>  		return ret;
>  
> -	ret = aarch32_alloc_kuser_vdso_page();
> -	if (ret) {
> -		unsigned long c_vvar =
> -			(unsigned long)page_to_virt(aarch32_vdso_pages[C_VVAR]);
> -		unsigned long c_vdso =
> -			(unsigned long)page_to_virt(aarch32_vdso_pages[C_VDSO]);
> -
> -		free_page(c_vvar);
> -		free_page(c_vdso);
> -	}
> -
> -	return ret;
> +	return aarch32_alloc_kuser_vdso_page();
>  }
>  #else
>  static int __aarch32_alloc_vdso_pages(void)
> 

-- 
Regards,
Vincenzo

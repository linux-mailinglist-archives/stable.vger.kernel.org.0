Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453BD472A65
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241032AbhLMKki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240026AbhLMKkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:40:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1238AC053AF0;
        Mon, 13 Dec 2021 02:31:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1CB7B8104D;
        Mon, 13 Dec 2021 10:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C450BC34601;
        Mon, 13 Dec 2021 10:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639391475;
        bh=YqTqbD22bE3nbM3gT9uMbugvqLUIVy1xvqjX4jOnawo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VnSTRR8x0Qi3FwpeicOeUIzpUGuXMcdl8//Eixs5/LlOJ42Wqsf1Bpxiw1/v5DvvQ
         u9XyrnMcbnZa8ldqRHNNy/FpFgHA3PYJy6yVkDyb8n5wlS3zjAB6BdZNmpIBJI0j+w
         hZ/Ht2+Mws4JlRQU7vWC/istzB7AQXvey27yhFKb2faxntxTKGBXcJSMjLUYP75HL1
         sze5PsU/Db9Qk8XqWQrKyomukom+2bdWtlTC+B112b8kTJbrprUY8wFdNdTZy1bzGa
         ktK6VcMq2zCJ2HEPuDIEUyd+DnuI1CmKH5G7CsVBS9XwR0ep1k6FqUsEUBlUvPAEAs
         yD6oHRRyRj0bQ==
Date:   Mon, 13 Dec 2021 12:31:05 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux@armlinux.org.uk, rppt@linux.ibm.com,
        tony@atomide.com, wangkefeng.wang@huawei.com,
        yj.chiang@mediatek.com
Subject: Re: [PATCH 5.4 1/5] memblock: free_unused_memmap: use pageblock
 units instead of MAX_ORDER
Message-ID: <Ybcg6ZmQCSLbsy17@kernel.org>
References: <20211213085710.28962-1-mark-pk.tsai@mediatek.com>
 <20211213085710.28962-2-mark-pk.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213085710.28962-2-mark-pk.tsai@mediatek.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 04:57:06PM +0800, Mark-PK Tsai wrote:

> Subject: [PATCH 5.4 1/5] memblock: free_unused_memmap: use pageblock units instead of MAX_ORDER

I'd replace memblock: with arm: in the subject. I believe it's clearer this
way.

The same applies for the second patch in the series and for 5.10 posting.

> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> commit e2a86800d58639b3acde7eaeb9eb393dca066e08 upstream.
> 
> The code that frees unused memory map uses rounds start and end of the
> holes that are freed to MAX_ORDER_NR_PAGES to preserve continuity of the
> memory map for MAX_ORDER regions.
> 
> Lots of core memory management functionality relies on homogeneity of the
> memory map within each pageblock which size may differ from MAX_ORDER in
> certain configurations.
> 
> Although currently, for the architectures that use free_unused_memmap(),
> pageblock_order and MAX_ORDER are equivalent, it is cleaner to have common
> notation thought mm code.
> 
> Replace MAX_ORDER_NR_PAGES with pageblock_nr_pages and update the comments
> to make it more clear why the alignment to pageblock boundaries is
> required.
> 
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Tested-by: Tony Lindgren <tony@atomide.com>
> Link: https://lore.kernel.org/lkml/20210630071211.21011-1-rppt@kernel.org/
> [backport upstream modification in mm/memblock.c to arch/arm/mm/init.c]
> Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
> ---
>  arch/arm/mm/init.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index 7ea4d3b43444..6905dd8bc03f 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -381,11 +381,11 @@ static void __init free_unused_memmap(void)
>  				 ALIGN(prev_end, PAGES_PER_SECTION));
>  #else
>  		/*
> -		 * Align down here since the VM subsystem insists that the
> -		 * memmap entries are valid from the bank start aligned to
> -		 * MAX_ORDER_NR_PAGES.
> +		 * Align down here since many operations in VM subsystem
> +		 * presume that there are no holes in the memory map inside
> +		 * a pageblock
>  		 */
> -		start = round_down(start, MAX_ORDER_NR_PAGES);
> +		start = round_down(start, pageblock_nr_pages);
>  #endif
>  		/*
>  		 * If we had a previous bank, and there is a space
> @@ -395,12 +395,12 @@ static void __init free_unused_memmap(void)
>  			free_memmap(prev_end, start);
>  
>  		/*
> -		 * Align up here since the VM subsystem insists that the
> -		 * memmap entries are valid from the bank end aligned to
> -		 * MAX_ORDER_NR_PAGES.
> +		 * Align up here since many operations in VM subsystem
> +		 * presume that there are no holes in the memory map inside
> +		 * a pageblock
>  		 */
>  		prev_end = ALIGN(memblock_region_memory_end_pfn(reg),
> -				 MAX_ORDER_NR_PAGES);
> +				 pageblock_nr_pages);
>  	}
>  
>  #ifdef CONFIG_SPARSEMEM
> -- 
> 2.18.0
> 

-- 
Sincerely yours,
Mike.

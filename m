Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06592603714
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 02:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiJSAYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 20:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiJSAYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 20:24:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58A5DE80
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 17:24:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F7D56172F
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 00:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E809C433C1;
        Wed, 19 Oct 2022 00:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666139072;
        bh=fJDsvxvbiS6PeUatTvAK+KDfxKecYDKmx+l9E/r4RoA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=lvt17nE49iaTbIYT3SlsksQJ8BwAO179kRlBkbZGfXVeGaDU2UXT5sPXJrfKCcPIy
         dxrsyT0EPwId4WHP8e0j75RfSchYBpVD3FTpaqtmcirVEk0qQWsGYDTI5C7zseBPBC
         QF7i1+tWXlsAGAKFNFZo///4C1XChS8yz15dm4FtuLrULe/evVb1lA3cGF/yBrUyFv
         eEeuMX3lYxWY7nSokqJGsYCZjcBHo1MnRRnSwbXe4uBOYak4UGRq57w+UeHP28leUD
         iuIvjdyAXUMp8wIS5aAAqUpAKsyit195yvwmuXTB2b/QI8SxXbtZ9vTZBygTf1LZ3J
         zZZTYKzbU5+Nw==
Message-ID: <1d9772ac-4b73-4c76-8924-89425b7dd30b@kernel.org>
Date:   Tue, 18 Oct 2022 17:24:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] ARC: mm: fix leakage of memory allocated for PTE
Content-Language: en-US
To:     Pavel.Kozlov@synopsys.com, linux-snps-arc@lists.infradead.org
Cc:     Vineet Gupta <vgupta@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        stable@vger.kernel.org
References: <20221017161127.24351-1-kozlov@synopsys.com>
From:   Vineet Gupta <vgupta@kernel.org>
In-Reply-To: <20221017161127.24351-1-kozlov@synopsys.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/17/22 09:11, Pavel.Kozlov@synopsys.com wrote:
> From: Pavel Kozlov <pavel.kozlov@synopsys.com>
>
> Since commit d9820ff ("ARC: mm: switch pgtable_t back to struct page *")
> a memory leakage problem occurs. Memory allocated for page table entries
> not released during process termination. This issue can be reproduced by
> a small program that allocates a large amount of memory. After several
> runs, you'll see that the amount of free memory has reduced and will
> continue to reduce after each run. All ARC CPUs are effected by this
> issue. The issue was introduced since the kernel stable release v5.15-rc1.
>
> As described in commit d9820ff after switch pgtable_t back to struct
> page *, a pointer to "struct page" and appropriate functions are used to
> allocate and free a memory page for PTEs, but the pmd_pgtable macro hasn't
> changed and returns the direct virtual address from the PMD (PGD) entry.
> Than this address used as a parameter in the __pte_free() and as a result
> this function couldn't release memory page allocated for PTEs.
>
> Fix this issue by changing the pmd_pgtable macro and returning pointer to
> struct page.

Good catch. Curious how did you find it. KMEMCHECK or some such or just oom.

> Fixes: d9820ff76f95 ("ARC: mm: switch pgtable_t back to struct page *")
> Signed-off-by: Pavel Kozlov <pavel.kozlov@synopsys.com>
> Cc: Vineet Gupta <vgupta@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: <stable@vger.kernel.org> # 4.15.x

You meant 5.15.x

Added to for-curr.

Thx,
-Vineet

> ---
>   arch/arc/include/asm/pgtable-levels.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arc/include/asm/pgtable-levels.h b/arch/arc/include/asm/pgtable-levels.h
> index 64ca25d199be..ef68758b69f7 100644
> --- a/arch/arc/include/asm/pgtable-levels.h
> +++ b/arch/arc/include/asm/pgtable-levels.h
> @@ -161,7 +161,7 @@
>   #define pmd_pfn(pmd)		((pmd_val(pmd) & PAGE_MASK) >> PAGE_SHIFT)
>   #define pmd_page(pmd)		virt_to_page(pmd_page_vaddr(pmd))
>   #define set_pmd(pmdp, pmd)	(*(pmdp) = pmd)
> -#define pmd_pgtable(pmd)	((pgtable_t) pmd_page_vaddr(pmd))
> +#define pmd_pgtable(pmd)	((pgtable_t) pmd_page(pmd))
>   
>   /*
>    * 4th level paging: pte


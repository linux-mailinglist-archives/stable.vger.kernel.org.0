Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D8B5F7A7C
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 17:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiJGPZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 11:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJGPZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 11:25:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E20D792F4C
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 08:25:36 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E0B28106F;
        Fri,  7 Oct 2022 08:25:42 -0700 (PDT)
Received: from [10.1.29.15] (e122027.cambridge.arm.com [10.1.29.15])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 213CD3F67D;
        Fri,  7 Oct 2022 08:25:34 -0700 (PDT)
Message-ID: <048b5256-ac74-8c60-ee52-878f8584985e@arm.com>
Date:   Fri, 7 Oct 2022 16:25:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] arm64: mte: Avoid setting PG_mte_tagged if no tags
 cleared or restored
Content-Language: en-GB
To:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     james.morse@arm.com, dvyukov@google.com,
        syzbot+c2c79c6d6eddc5262b77@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>
References: <20221006163354.3194102-1-catalin.marinas@arm.com>
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <20221006163354.3194102-1-catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/10/2022 17:33, Catalin Marinas wrote:
> Prior to commit 69e3b846d8a7 ("arm64: mte: Sync tags for pages where PTE
> is untagged"), mte_sync_tags() was only called for pte_tagged() entries
> (those mapped with PROT_MTE). Therefore mte_sync_tags() could safely use
> test_and_set_bit(PG_mte_tagged, &page->flags) without inadvertently
> setting PG_mte_tagged on an untagged page.
> 
> The above commit was required as guests may enable MTE without any
> control at the stage 2 mapping, nor a PROT_MTE mapping in the VMM.
> However, the side-effect was that any page with a PTE that looked like
> swap (or migration) was getting PG_mte_tagged set automatically. A
> subsequent page copy (e.g. migration) copied the tags to the destination
> page even if the tags were owned by KASAN.
> 
> This issue was masked by the page_kasan_tag_reset() call introduced in
> commit e5b8d9218951 ("arm64: mte: reset the page tag in page->flags").
> When this commit was reverted (20794545c146), KASAN started reporting
> access faults because the overriding tags in a page did not match the
> original page->flags (with CONFIG_KASAN_HW_TAGS=y):
> 
>   BUG: KASAN: invalid-access in copy_page+0x10/0xd0 arch/arm64/lib/copy_page.S:26
>   Read at addr f5ff000017f2e000 by task syz-executor.1/2218
>   Pointer tag: [f5], memory tag: [f2]
> 
> Move the PG_mte_tagged bit setting from mte_sync_tags() to the actual
> place where tags are cleared (mte_sync_page_tags()) or restored
> (mte_restore_tags()).
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Reported-by: syzbot+c2c79c6d6eddc5262b77@syzkaller.appspotmail.com
> Fixes: 69e3b846d8a7 ("arm64: mte: Sync tags for pages where PTE is untagged")
> Cc: <stable@vger.kernel.org> # 5.14.x
> Cc: Steven Price <steven.price@arm.com>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Link: https://lore.kernel.org/r/0000000000004387dc05e5888ae5@google.com/

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
> 
> This seems to work for me but reproducing the issue is not entirely
> consistent. Once reviewed, we can merge it and then it will hit the
> various CI systems and syzbot.

As you say - it seems to work, hopefully the bots will agree!

Steve

> 
>  arch/arm64/kernel/mte.c | 9 +++++++--
>  arch/arm64/mm/mteswap.c | 7 ++++++-
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index aca88470fb69..7467217c1eaf 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -48,7 +48,12 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
>  	if (!pte_is_tagged)
>  		return;
>  
> -	mte_clear_page_tags(page_address(page));
> +	/*
> +	 * Test PG_mte_tagged again in case it was racing with another
> +	 * set_pte_at().
> +	 */
> +	if (!test_and_set_bit(PG_mte_tagged, &page->flags))
> +		mte_clear_page_tags(page_address(page));
>  }
>  
>  void mte_sync_tags(pte_t old_pte, pte_t pte)
> @@ -64,7 +69,7 @@ void mte_sync_tags(pte_t old_pte, pte_t pte)
>  
>  	/* if PG_mte_tagged is set, tags have already been initialised */
>  	for (i = 0; i < nr_pages; i++, page++) {
> -		if (!test_and_set_bit(PG_mte_tagged, &page->flags))
> +		if (!test_bit(PG_mte_tagged, &page->flags))
>  			mte_sync_page_tags(page, old_pte, check_swap,
>  					   pte_is_tagged);
>  	}
> diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
> index 4334dec93bd4..bed803d8e158 100644
> --- a/arch/arm64/mm/mteswap.c
> +++ b/arch/arm64/mm/mteswap.c
> @@ -53,7 +53,12 @@ bool mte_restore_tags(swp_entry_t entry, struct page *page)
>  	if (!tags)
>  		return false;
>  
> -	mte_restore_page_tags(page_address(page), tags);
> +	/*
> +	 * Test PG_mte_tagged again in case it was racing with another
> +	 * set_pte_at().
> +	 */
> +	if (!test_and_set_bit(PG_mte_tagged, &page->flags))
> +		mte_restore_page_tags(page_address(page), tags);
>  
>  	return true;
>  }
> 
> base-commit: d2995249a2f72333a4ab4922ff3c42a76c023791


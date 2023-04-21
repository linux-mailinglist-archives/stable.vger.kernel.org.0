Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E876EAA6F
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 14:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjDUMhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 08:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbjDUMhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 08:37:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D892B74F
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 05:37:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6614661284
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 12:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AD2C433D2;
        Fri, 21 Apr 2023 12:37:35 +0000 (UTC)
Date:   Fri, 21 Apr 2023 13:37:32 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, vincenzo.frascino@arm.com,
        will@kernel.org, eugenis@google.com, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: mte: Do not set PG_mte_tagged if tags were not
 initialized
Message-ID: <ZEKDjDnrgDLKiZnK@arm.com>
References: <20230420214327.2357985-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420214327.2357985-1-pcc@google.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 20, 2023 at 02:43:27PM -0700, Peter Collingbourne wrote:
> The mte_sync_page_tags() function sets PG_mte_tagged if it initializes
> page tags. Then we return to mte_sync_tags(), which sets PG_mte_tagged
> again. At best, this is redundant. However, it is possible for
> mte_sync_page_tags() to return without having initialized tags for the
> page, i.e. in the case where check_swap is true (non-compound page),
> is_swap_pte(old_pte) is false and pte_is_tagged is false. So at worst,
> we set PG_mte_tagged on a page with uninitialized tags. This can happen
> if, for example, page migration causes a PTE for an untagged page to
> be replaced. If the userspace program subsequently uses mprotect() to
> enable PROT_MTE for that page, the uninitialized tags will be exposed
> to userspace.
> 
> Fix it by removing the redundant call to set_page_mte_tagged().
> 
> Fixes: e059853d14ca ("arm64: mte: Fix/clarify the PG_mte_tagged semantics")
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Cc: <stable@vger.kernel.org> # 6.1
> Link: https://linux-review.googlesource.com/id/Ib02d004d435b2ed87603b858ef7480f7b1463052
> ---
>  arch/arm64/kernel/mte.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index f5bcb0dc6267..7e89968bd282 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -66,13 +66,10 @@ void mte_sync_tags(pte_t old_pte, pte_t pte)
>  		return;
>  
>  	/* if PG_mte_tagged is set, tags have already been initialised */
> -	for (i = 0; i < nr_pages; i++, page++) {
> -		if (!page_mte_tagged(page)) {
> +	for (i = 0; i < nr_pages; i++, page++)
> +		if (!page_mte_tagged(page))
>  			mte_sync_page_tags(page, old_pte, check_swap,
>  					   pte_is_tagged);
> -			set_page_mte_tagged(page);
> -		}
> -	}

It makes sense, not sure why I added it here when mte_sync_page_tags()
was already setting the flag if needed.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

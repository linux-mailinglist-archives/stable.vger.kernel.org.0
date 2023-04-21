Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E697B6EAA51
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 14:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjDUMZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 08:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDUMZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 08:25:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197ECCC03
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 05:24:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29E8865047
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 12:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E292C433EF;
        Fri, 21 Apr 2023 12:24:08 +0000 (UTC)
Date:   Fri, 21 Apr 2023 13:24:05 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     andreyknvl@gmail.com,
        Qun-wei Lin =?utf-8?B?KOael+e+pOW0tCk=?= 
        <Qun-wei.Lin@mediatek.com>,
        Guangye Yang =?utf-8?B?KOadqOWFieS4mik=?= 
        <guangye.yang@mediatek.com>, linux-mm@kvack.org,
        Chinwen Chang =?utf-8?B?KOW8temMpuaWhyk=?= 
        <chinwen.chang@mediatek.com>, kasan-dev@googlegroups.com,
        ryabinin.a.a@gmail.com, linux-arm-kernel@lists.infradead.org,
        vincenzo.frascino@arm.com, will@kernel.org, eugenis@google.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] arm64: Also reset KASAN tag if page is not PG_mte_tagged
Message-ID: <ZEKAZZLeqY/Vvu+z@arm.com>
References: <20230420210945.2313627-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420210945.2313627-1-pcc@google.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 20, 2023 at 02:09:45PM -0700, Peter Collingbourne wrote:
> Consider the following sequence of events:
> 
> 1) A page in a PROT_READ|PROT_WRITE VMA is faulted.
> 2) Page migration allocates a page with the KASAN allocator,
>    causing it to receive a non-match-all tag, and uses it
>    to replace the page faulted in 1.
> 3) The program uses mprotect() to enable PROT_MTE on the page faulted in 1.

Ah, so there is no race here, it's simply because the page allocation
for migration has a non-match-all kasan tag in page->flags.

How do we handle the non-migration case with mprotect()? IIRC
post_alloc_hook() always resets the page->flags since
GFP_HIGHUSER_MOVABLE has the __GFP_SKIP_KASAN_UNPOISON flag.

> As a result of step 3, we are left with a non-match-all tag for a page
> with tags accessible to userspace, which can lead to the same kind of
> tag check faults that commit e74a68468062 ("arm64: Reset KASAN tag in
> copy_highpage with HW tags only") intended to fix.
> 
> The general invariant that we have for pages in a VMA with VM_MTE_ALLOWED
> is that they cannot have a non-match-all tag. As a result of step 2, the
> invariant is broken. This means that the fix in the referenced commit
> was incomplete and we also need to reset the tag for pages without
> PG_mte_tagged.
> 
> Fixes: e5b8d9218951 ("arm64: mte: reset the page tag in page->flags")

This commit was reverted in 20794545c146 (arm64: kasan: Revert "arm64:
mte: reset the page tag in page->flags"). It looks a bit strange to fix
it up.

> diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
> index 4aadcfb01754..a7bb20055ce0 100644
> --- a/arch/arm64/mm/copypage.c
> +++ b/arch/arm64/mm/copypage.c
> @@ -21,9 +21,10 @@ void copy_highpage(struct page *to, struct page *from)
>  
>  	copy_page(kto, kfrom);
>  
> +	if (kasan_hw_tags_enabled())
> +		page_kasan_tag_reset(to);
> +
>  	if (system_supports_mte() && page_mte_tagged(from)) {
> -		if (kasan_hw_tags_enabled())
> -			page_kasan_tag_reset(to);

This should work but can we not do this at allocation time like we do
for the source page and remove any page_kasan_tag_reset() here
altogether?

-- 
Catalin

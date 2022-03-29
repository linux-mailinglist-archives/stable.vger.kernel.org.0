Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2424EB400
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 21:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236919AbiC2TPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 15:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240899AbiC2TPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 15:15:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FDA24BC6;
        Tue, 29 Mar 2022 12:13:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2372421980;
        Tue, 29 Mar 2022 19:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648581230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8vITF4y5I3Qh2gV4oA1G6ENMes/c4yf/oaIqSyELU/A=;
        b=ck65D7u93Kgsw+DJKq0LsvxejQOPTajh6zrG90DpA9EQ0RVdKIP7h7cZ3UXAOgNycSqrnJ
        tPbDwyldcWKsLH9w5HGRVvMWq/78FFfIg7g9nFhTLjIXOafVpxWDw2U54l3oZoy1B9zYvx
        VyAV7j9n8xo3o08As3ERBzoJipB8VcI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648581230;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8vITF4y5I3Qh2gV4oA1G6ENMes/c4yf/oaIqSyELU/A=;
        b=TqVsSeCz/588wD5Fm9vxZ4m41p58zhiATVblsqqooXov50DRQ0dIpT9mwtOqVZ15qVmmOK
        vfe9GHN0kqOBkbAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 66A3313A7E;
        Tue, 29 Mar 2022 19:13:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id t7ScFW1aQ2IOVQAAMHmgww
        (envelope-from <osalvador@suse.de>); Tue, 29 Mar 2022 19:13:49 +0000
Date:   Tue, 29 Mar 2022 21:13:47 +0200
From:   Oscar Salvador <osalvador@suse.de>
To:     Rik van Riel <riel@surriel.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kernel-team@fb.com, Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm,hwpoison: unmap poisoned page before invalidation
Message-ID: <YkNaa9zF8wZb+cFa@localhost.localdomain>
References: <20220325161428.5068d97e@imladris.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325161428.5068d97e@imladris.surriel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 25, 2022 at 04:14:28PM -0400, Rik van Riel wrote:
> In some cases it appears the invalidation of a hwpoisoned page
> fails because the page is still mapped in another process. This
> can cause a program to be continuously restarted and die when
> it page faults on the page that was not invalidated. Avoid that
> problem by unmapping the hwpoisoned page when we find it.
> 
> Another issue is that sometimes we end up oopsing in finish_fault,
> if the code tries to do something with the now-NULL vmf->page.
> I did not hit this error when submitting the previous patch because
> there are several opportunities for alloc_set_pte to bail out before
> accessing vmf->page, and that apparently happened on those systems,
> and most of the time on other systems, too.
> 
> However, across several million systems that error does occur a
> handful of times a day. It can be avoided by returning VM_FAULT_NOPAGE
> which will cause do_read_fault to return before calling finish_fault.
> 
> Fixes: e53ac7374e64 ("mm: invalidate hwpoison page cache page in fault path")
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: stable@vger.kernel.org

Reviewed-by: Oscar Salvador <osalvador@suse.de>

> ---
>  mm/memory.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index be44d0b36b18..76e3af9639d9 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3918,14 +3918,18 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
>  		return ret;
>  
>  	if (unlikely(PageHWPoison(vmf->page))) {
> +		struct page *page = vmf->page;
>  		vm_fault_t poisonret = VM_FAULT_HWPOISON;
>  		if (ret & VM_FAULT_LOCKED) {
> +			if (page_mapped(page))
> +				unmap_mapping_pages(page_mapping(page),
> +						    page->index, 1, false);
>  			/* Retry if a clean page was removed from the cache. */
> -			if (invalidate_inode_page(vmf->page))
> -				poisonret = 0;
> -			unlock_page(vmf->page);
> +			if (invalidate_inode_page(page))
> +				poisonret = VM_FAULT_NOPAGE;
> +			unlock_page(page);
>  		}
> -		put_page(vmf->page);
> +		put_page(page);
>  		vmf->page = NULL;
>  		return poisonret;
>  	}
> -- 
> 2.35.1
> 
> 
> 

-- 
Oscar Salvador
SUSE Labs

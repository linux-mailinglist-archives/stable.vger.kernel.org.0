Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC8C4E90A7
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 11:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbiC1JCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 05:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236136AbiC1JCF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 05:02:05 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B594EA25;
        Mon, 28 Mar 2022 02:00:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D4FC11F383;
        Mon, 28 Mar 2022 09:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648458023; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=47pPpyGxuilOfnCBTjS7w3pI+iy5tOMsC7jtD+lLV90=;
        b=j3VTfzogM268touRV4Bk9j9IbSXqySsLpCu637yg4u3UHRXVzXFp8C/LXvTjFqfA8qklUa
        cyq5m7d4v1yvK5/VdXSfWna2NUq4G77k2eBKf0a+B6FYETVNzAF+/jqF/6fYCsPn79YgVE
        KOsHUtcraiBIIUMXN8S1L38FyH4tmfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648458023;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=47pPpyGxuilOfnCBTjS7w3pI+iy5tOMsC7jtD+lLV90=;
        b=oEGcYiXSrqVndh2Efqz55c0Kt3SLjTd6PHyfyfszeiv/H8CoqFAdsasE+gUaAdn5lUREac
        yNRHDdLHHRK/YTCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 29F3913B08;
        Mon, 28 Mar 2022 09:00:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /W/zBid5QWKzHAAAMHmgww
        (envelope-from <osalvador@suse.de>); Mon, 28 Mar 2022 09:00:23 +0000
Date:   Mon, 28 Mar 2022 11:00:21 +0200
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
Message-ID: <YkF5Jd6fauTRvVVg@localhost.localdomain>
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

What is the effect of returning VM_FAULT_NOPAGE?
I take that we are cool because the pte has been installed and points to
a new page? (I could not find where that is being done).


-- 
Oscar Salvador
SUSE Labs

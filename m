Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4ACD692291
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 16:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbjBJPrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 10:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbjBJPrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 10:47:05 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD9470736;
        Fri, 10 Feb 2023 07:47:03 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9457F33D3E;
        Fri, 10 Feb 2023 15:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1676044022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zQiRrtYqGHTqMan1QOBtU2HAPA2lYDV21aWW21XE6PQ=;
        b=UZw8qv+Kd4zClQd8KO3TPveGTkmVKY4aIYXMRqxzVPlszQUsphTQTlyOvUv/HfLO/jjJXw
        P7LAU5hjiOt/vePjJASa7uLHgbt4YPAZ60U8vRieT8FYTOcqmjS+crLEeIaBkBnxVM+nxb
        xPcLU+abjJRLH06UNwXi7lUrqmjsrlw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1676044022;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zQiRrtYqGHTqMan1QOBtU2HAPA2lYDV21aWW21XE6PQ=;
        b=OegnDL9GaFqyLqe7iav24qdt1DV9FmsQH2HgPxL0OQar/5DSXZcSIeWbwrtUBA/mIguufx
        TbrkJqF0u2wDSiDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 76B481325E;
        Fri, 10 Feb 2023 15:47:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Mk1BHPZm5mNKbwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 10 Feb 2023 15:47:02 +0000
Message-ID: <7c72fefb-a3a2-0996-e800-7b56288002ab@suse.cz>
Date:   Fri, 10 Feb 2023 16:47:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] Fix page corruption caused by racy check in __free_pages
Content-Language: en-US
To:     David Chen <david.chen@nutanix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <BYAPR02MB448855960A9656EEA81141FC94D99@BYAPR02MB4488.namprd02.prod.outlook.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <BYAPR02MB448855960A9656EEA81141FC94D99@BYAPR02MB4488.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/9/23 18:48, David Chen wrote:
> When we upgraded our kernel, we started seeing some page corruption like
> the following consistently:
> 
>  BUG: Bad page state in process ganesha.nfsd  pfn:1304ca
>  page:0000000022261c55 refcount:0 mapcount:-128 mapping:0000000000000000 index:0x0 pfn:0x1304ca
>  flags: 0x17ffffc0000000()
>  raw: 0017ffffc0000000 ffff8a513ffd4c98 ffffeee24b35ec08 0000000000000000
>  raw: 0000000000000000 0000000000000001 00000000ffffff7f 0000000000000000
>  page dumped because: nonzero mapcount
>  CPU: 0 PID: 15567 Comm: ganesha.nfsd Kdump: loaded Tainted: P    B      O      5.10.158-1.nutanix.20221209.el7.x86_64 #1
>  Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/05/2016
>  Call Trace:
>   dump_stack+0x74/0x96
>   bad_page.cold+0x63/0x94
>   check_new_page_bad+0x6d/0x80
>   rmqueue+0x46e/0x970
>   get_page_from_freelist+0xcb/0x3f0
>   ? _cond_resched+0x19/0x40
>   __alloc_pages_nodemask+0x164/0x300
>   alloc_pages_current+0x87/0xf0
>   skb_page_frag_refill+0x84/0x110
>   ...
> 
> Sometimes, it would also show up as corruption in the free list pointer and
> cause crashes.
> 
> After bisecting the issue, we found the issue started from e320d3012d25:
> 
> 	if (put_page_testzero(page))
> 		free_the_page(page, order);
> 	else if (!PageHead(page))
> 		while (order-- > 0)
> 			free_the_page(page + (1 << order), order);
> 
> So the problem is the check PageHead is racy because at this point we
> already dropped our reference to the page. So even if we came in with
> compound page, the page can already be freed and PageHead can return
> false and we will end up freeing all the tail pages causing double free.
> 
> Fixes: e320d3012d25 ("mm/page_alloc.c: fix freeing non-compound pages")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: linux-mm@kvack.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Chunwei Chen <david.chen@nutanix.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

That's nasty enough to go into 6.2, IMHO.

> ---
>  mm/page_alloc.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0745aedebb37..3bb3484563ed 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5631,9 +5631,12 @@ EXPORT_SYMBOL(get_zeroed_page);
>   */
>  void __free_pages(struct page *page, unsigned int order)
>  {
> +	/* get PageHead before we drop reference */
> +	int head = PageHead(page);
> +
>  	if (put_page_testzero(page))
>  		free_the_page(page, order);
> -	else if (!PageHead(page))
> +	else if (!head)
>  		while (order-- > 0)
>  			free_the_page(page + (1 << order), order);
>  }


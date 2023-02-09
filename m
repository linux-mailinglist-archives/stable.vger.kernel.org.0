Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA4F6910C1
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 19:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjBISx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 13:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBISx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 13:53:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20243EF98;
        Thu,  9 Feb 2023 10:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sM8Z/mmxWNfsz4RQHpXXEAWg51FPNsdPW49xov8P/5Q=; b=PP6DRn1jq/FEW26D6i/yEuCXl1
        j33WhbBlUtkdiVz7SAsUQoMRJZbmdGsRnrlMiIhW41JeXn2Yx4gubaNxGgmK/vZO+ROyO44HqhTkg
        XSFvz8NXIuk6j5X1gSrgcxHVZrlZseC74bHN3Zr0VcEmH5ny9hpFus/yxrCsG4OUeMsVCf6+PgSXH
        zTYnUMWaGeomp5gkEiRHN2R8DtWITx3CkMh6cH5gaXzsuP6KQihO0nKTn3NySy+6k2L+FIYVZgazM
        6MjOeInkfYxgd9PyETwpWnA/YCeplgQ0+2hxhUHVZ6MrkZIUZyM1RmIw7ZS6g9REVaiJO8o/D5igM
        DaGerXrw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pQC2q-002Qfo-Vn; Thu, 09 Feb 2023 18:53:21 +0000
Date:   Thu, 9 Feb 2023 18:53:20 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     David Chen <david.chen@nutanix.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] Fix page corruption caused by racy check in __free_pages
Message-ID: <Y+VBIMEKI1BiSu4X@casper.infradead.org>
References: <BYAPR02MB448855960A9656EEA81141FC94D99@BYAPR02MB4488.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR02MB448855960A9656EEA81141FC94D99@BYAPR02MB4488.namprd02.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 09, 2023 at 05:48:28PM +0000, David Chen wrote:
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

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

That's a pretty narrow window you managed to hit!  Just a few
instructions wide.  I guess that answers the question Andrew originally
had (Does this ever happen?)  I just changed it from a silent memory
leak into a double-free.

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
> -- 
> 2.22.3

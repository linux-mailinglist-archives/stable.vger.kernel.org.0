Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80130242161
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 22:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgHKUtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 16:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbgHKUtK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 16:49:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D693620756;
        Tue, 11 Aug 2020 20:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597178950;
        bh=yM/w8kXZUP5qcU80J3itZ4RsFnZNvfDi4xYYcznEv38=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cS0cTNVmGkt992d1vJ3VHy+wVjf7tezfQwBBWYEgsF0dH6psuNCda03sryMPHsQlk
         /kf8tmYeikxutlzIRdt8ZA3Br4iHTjyeYBdTG87dm3bYPRn4nReCSvkYE63kvV4Gef
         XF/8V9dnIGk7sKr6UPfiiYhHIQ+Dfg0Bbb3aoO7k=
Date:   Tue, 11 Aug 2020 13:49:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Eugeniu Rosca <erosca@de.adit-jv.com>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>, <linux-mm@kvack.org>,
        <stable@vger.kernel.org>, Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: Re: [PATCH] mm: slub: fix conversion of freelist_corrupted()
Message-Id: <20200811134909.536004dcfc4c78204313dcd2@linux-foundation.org>
In-Reply-To: <20200811124656.10308-1-erosca@de.adit-jv.com>
References: <20200811124656.10308-1-erosca@de.adit-jv.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 11 Aug 2020 14:46:56 +0200 Eugeniu Rosca <erosca@de.adit-jv.com> wrote:

> Commit 52f23478081ae0 ("mm/slub.c: fix corrupted freechain in
> deactivate_slab()") suffered an update when picked up from LKML [1].
> 
> Specifically, relocating 'freelist = NULL' into 'freelist_corrupted()'
> created a no-op statement. Fix it by sticking to the behavior intended
> in the original patch [1]. Prefer the lowest-line-count solution.
> 
> [1] https://lore.kernel.org/linux-mm/20200331031450.12182-1-dongli.zhang@oracle.com/
> 
> ...
>
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -677,7 +677,6 @@ static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
>  	if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
>  	    !check_valid_pointer(s, page, nextfree)) {
>  		object_err(s, page, freelist, "Freechain corrupt");
> -		freelist = NULL;
>  		slab_fix(s, "Isolate corrupted freechain");
>  		return true;
>  	}
> @@ -2184,8 +2183,10 @@ static void deactivate_slab(struct kmem_cache *s, struct page *page,
>  		 * 'freelist' is already corrupted.  So isolate all objects
>  		 * starting at 'freelist'.
>  		 */
> -		if (freelist_corrupted(s, page, freelist, nextfree))
> +		if (freelist_corrupted(s, page, freelist, nextfree)) {
> +			freelist = NULL;
>  			break;
> +		}
>  
>  		do {
>  			prior = page->freelist;

Looks right.

What are the runtime effects of this change?  In other words, what are
the end user visible effects of the present defect?

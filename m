Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9781549D882
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 03:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiA0Cxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 21:53:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47244 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiA0Cxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 21:53:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0129B820F7;
        Thu, 27 Jan 2022 02:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4020FC340E7;
        Thu, 27 Jan 2022 02:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643252023;
        bh=hPXwuHX97gtrZ2qX/gY+pvj3t/ttZmCqUDNaDC2UqWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zmL+oDzWp8h60f/hTpsBb/c0cN3xGb1HUsjOr0f1L2FsqRE8CCVW56DND4NIB10NB
         1NCvo0OI2yBh+r4RUcHO8TUwfvJlMkoCqSLI1qXFOHCulp9Ml6pBEgieNapbBd6TYO
         KCT87NO3QaXFALF2tX3LiALDtI36NqSBp9b/c3hI=
Date:   Wed, 26 Jan 2022 18:53:40 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>, cgel.zte@gmail.com,
        shakeelb@google.com, rdunlap@infradead.org, dbueso@suse.de,
        unixbhaskar@gmail.com, chi.minghao@zte.com.cn, arnd@arndb.de,
        Zeal Robot <zealci@zte.com.cn>, linux-mm@kvack.org,
        1vier1@web.de, stable@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm/util.c: Make kvfree() safe for calling while holding
 spinlocks
Message-Id: <20220126185340.58f88e8e1b153b6650c83270@linux-foundation.org>
In-Reply-To: <20211222194828.15320-1-manfred@colorfullife.com>
References: <20211222194828.15320-1-manfred@colorfullife.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 22 Dec 2021 20:48:28 +0100 Manfred Spraul <manfred@colorfullife.com> wrote:

> One codepath in find_alloc_undo() calls kvfree() while holding a spinlock.
> Since vfree() can sleep this is a bug.
> 
> Previously, the code path used kfree(), and kfree() is safe to be called
> while holding a spinlock.
> 
> Minghao proposed to fix this by updating find_alloc_undo().
> 
> Alternate proposal to fix this: Instead of changing find_alloc_undo(),
> change kvfree() so that the same rules as for kfree() apply:
> Having different rules for kfree() and kvfree() just asks for bugs.
> 
> Disadvantage: Releasing vmalloc'ed memory will be delayed a bit.

I know we've been around this loop a bunch of times and deferring was
considered.   But I forget the conclusion.  IIRC, mhocko was involved?

> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -610,12 +610,12 @@ EXPORT_SYMBOL(kvmalloc_node);
>   * It is slightly more efficient to use kfree() or vfree() if you are certain
>   * that you know which one to use.
>   *
> - * Context: Either preemptible task context or not-NMI interrupt.
> + * Context: Any context except NMI interrupt.
>   */
>  void kvfree(const void *addr)
>  {
>  	if (is_vmalloc_addr(addr))
> -		vfree(addr);
> +		vfree_atomic(addr);
>  	else
>  		kfree(addr);
>  }



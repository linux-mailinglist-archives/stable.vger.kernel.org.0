Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B439D632
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 21:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfHZTCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 15:02:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727226AbfHZTCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 15:02:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A3612070B;
        Mon, 26 Aug 2019 19:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566846169;
        bh=omxtfLtd/IDEk8FXD3GfAIpsIYEgH+RYCTrdf2tgP6Y=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=Tadiyj3HrCvZQxD9lEH+TgAnoGfIasg8PypHvslDIBgcArKDwUS+f825vmhO0/KZ3
         QzZIFI/KU2InZ6RLFOR0EFswI4TEzldfcfgutGrA4cq3yIfOfUftD097ljNUZCRdKi
         QxDjQURRO6KIQ5mKdbg1lu1yqTPlHX9jNxxxBhIQ=
Date:   Mon, 26 Aug 2019 21:02:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     henryburns@google.com, akpm@linux-foundation.org,
        henrywolfeburns@gmail.com, jwadams@google.com, minchan@kernel.org,
        sergey.senozhatsky@gmail.com, shakeelb@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm/zsmalloc.c: fix race condition in
 zs_destroy_pool" failed to apply to 4.9-stable tree
Message-ID: <20190826190247.GB24930@kroah.com>
References: <156684443123212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156684443123212@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 08:33:51PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

It actually applies, but it breaks the build :(






> ------------------ original commit in Linus's tree ------------------
> 
> >From 701d678599d0c1623aaf4139c03eea260a75b027 Mon Sep 17 00:00:00 2001
> From: Henry Burns <henryburns@google.com>
> Date: Sat, 24 Aug 2019 17:55:06 -0700
> Subject: [PATCH] mm/zsmalloc.c: fix race condition in zs_destroy_pool
> 
> In zs_destroy_pool() we call flush_work(&pool->free_work).  However, we
> have no guarantee that migration isn't happening in the background at
> that time.
> 
> Since migration can't directly free pages, it relies on free_work being
> scheduled to free the pages.  But there's nothing preventing an
> in-progress migrate from queuing the work *after*
> zs_unregister_migration() has called flush_work().  Which would mean
> pages still pointing at the inode when we free it.
> 
> Since we know at destroy time all objects should be free, no new
> migrations can come in (since zs_page_isolate() fails for fully-free
> zspages).  This means it is sufficient to track a "# isolated zspages"
> count by class, and have the destroy logic ensure all such pages have
> drained before proceeding.  Keeping that state under the class spinlock
> keeps the logic straightforward.
> 
> In this case a memory leak could lead to an eventual crash if compaction
> hits the leaked page.  This crash would only occur if people are
> changing their zswap backend at runtime (which eventually starts
> destruction).
> 
> Link: http://lkml.kernel.org/r/20190809181751.219326-2-henryburns@google.com
> Fixes: 48b4800a1c6a ("zsmalloc: page migration support")
> Signed-off-by: Henry Burns <henryburns@google.com>
> Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Cc: Henry Burns <henrywolfeburns@gmail.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Jonathan Adams <jwadams@google.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 5105b9b66653..08def3a0d200 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -54,6 +54,7 @@
>  #include <linux/mount.h>
>  #include <linux/pseudo_fs.h>
>  #include <linux/migrate.h>
> +#include <linux/wait.h>
>  #include <linux/pagemap.h>
>  #include <linux/fs.h>
>  
> @@ -268,6 +269,10 @@ struct zs_pool {
>  #ifdef CONFIG_COMPACTION
>  	struct inode *inode;
>  	struct work_struct free_work;
> +	/* A wait queue for when migration races with async_free_zspage() */
> +	struct wait_queue_head migration_wait;
> +	atomic_long_t isolated_pages;
> +	bool destroying;
>  #endif
>  };
>  
> @@ -1874,6 +1879,19 @@ static void putback_zspage_deferred(struct zs_pool *pool,
>  
>  }
>  
> +static inline void zs_pool_dec_isolated(struct zs_pool *pool)
> +{
> +	VM_BUG_ON(atomic_long_read(&pool->isolated_pages) <= 0);
> +	atomic_long_dec(&pool->isolated_pages);
> +	/*
> +	 * There's no possibility of racing, since wait_for_isolated_drain()
> +	 * checks the isolated count under &class->lock after enqueuing
> +	 * on migration_wait.
> +	 */
> +	if (atomic_long_read(&pool->isolated_pages) == 0 && pool->destroying)
> +		wake_up_all(&pool->migration_wait);
> +}
> +
>  static void replace_sub_page(struct size_class *class, struct zspage *zspage,
>  				struct page *newpage, struct page *oldpage)
>  {
> @@ -1943,6 +1961,7 @@ static bool zs_page_isolate(struct page *page, isolate_mode_t mode)
>  	 */
>  	if (!list_empty(&zspage->list) && !is_zspage_isolated(zspage)) {
>  		get_zspage_mapping(zspage, &class_idx, &fullness);
> +		atomic_long_inc(&pool->isolated_pages);
>  		remove_zspage(class, zspage, fullness);
>  	}
>  
> @@ -2042,8 +2061,16 @@ static int zs_page_migrate(struct address_space *mapping, struct page *newpage,
>  	 * Page migration is done so let's putback isolated zspage to
>  	 * the list if @page is final isolated subpage in the zspage.
>  	 */
> -	if (!is_zspage_isolated(zspage))
> +	if (!is_zspage_isolated(zspage)) {
> +		/*
> +		 * We cannot race with zs_destroy_pool() here because we wait
> +		 * for isolation to hit zero before we start destroying.
> +		 * Also, we ensure that everyone can see pool->destroying before
> +		 * we start waiting.
> +		 */
>  		putback_zspage_deferred(pool, class, zspage);
> +		zs_pool_dec_isolated(pool);
> +	}
>  
>  	reset_page(page);
>  	put_page(page);
> @@ -2094,8 +2121,8 @@ static void zs_page_putback(struct page *page)
>  		 * so let's defer.
>  		 */
>  		putback_zspage_deferred(pool, class, zspage);
> +		zs_pool_dec_isolated(pool);
>  	}
> -
>  	spin_unlock(&class->lock);
>  }
>  
> @@ -2118,8 +2145,36 @@ static int zs_register_migration(struct zs_pool *pool)
>  	return 0;
>  }
>  
> +static bool pool_isolated_are_drained(struct zs_pool *pool)
> +{
> +	return atomic_long_read(&pool->isolated_pages) == 0;
> +}
> +
> +/* Function for resolving migration */
> +static void wait_for_isolated_drain(struct zs_pool *pool)
> +{
> +
> +	/*
> +	 * We're in the process of destroying the pool, so there are no
> +	 * active allocations. zs_page_isolate() fails for completely free
> +	 * zspages, so we need only wait for the zs_pool's isolated
> +	 * count to hit zero.
> +	 */
> +	wait_event(pool->migration_wait,
> +		   pool_isolated_are_drained(pool));
> +}
> +
>  static void zs_unregister_migration(struct zs_pool *pool)
>  {
> +	pool->destroying = true;
> +	/*
> +	 * We need a memory barrier here to ensure global visibility of
> +	 * pool->destroying. Thus pool->isolated pages will either be 0 in which
> +	 * case we don't care, or it will be > 0 and pool->destroying will
> +	 * ensure that we wake up once isolation hits 0.
> +	 */
> +	smp_mb();
> +	wait_for_isolated_drain(pool); /* This can block */
>  	flush_work(&pool->free_work);
>  	iput(pool->inode);
>  }
> @@ -2357,6 +2412,8 @@ struct zs_pool *zs_create_pool(const char *name)
>  	if (!pool->name)
>  		goto err;
>  
> +	init_waitqueue_head(&pool->migration_wait);
> +
>  	if (create_cache(pool))
>  		goto err;
>  
> 

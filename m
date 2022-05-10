Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC0A5209D1
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 02:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbiEJAKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 20:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbiEJAKc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 20:10:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF419FDF;
        Mon,  9 May 2022 17:06:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5D1AB819B0;
        Tue, 10 May 2022 00:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD17C385C5;
        Tue, 10 May 2022 00:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652141193;
        bh=DgAVSJugWswR9uGU+ofLa7fkVHUE/3d5Oo1amCmtuNs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BPrOIvDlxOMKUg1sOv2e2PoJnlDv3eWLxx0sGSl0HsM6FQEouAPObXr1iCN5PWqP1
         xlwCdWAvnwhnBHmbuDq0MYeyEHoryRYw9h4oCjbAPN3GbIYIrhZTIs8+9eMuRi1XSm
         gLuN3VXFFEVIHvkw4926kwehsfY2sHummU76ogwc=
Date:   Mon, 9 May 2022 17:06:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Cc:     stable@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zsmalloc: Fix races between asynchronous zspage free
 and page migration
Message-Id: <20220509170632.fec2f56ad9f640329330b9de@linux-foundation.org>
In-Reply-To: <20220509024703.243847-1-sultan@kerneltoast.com>
References: <20220509024703.243847-1-sultan@kerneltoast.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun,  8 May 2022 19:47:02 -0700 Sultan Alsawaf <sultan@kerneltoast.com> wrote:

> From: Sultan Alsawaf <sultan@kerneltoast.com>
> 
> The asynchronous zspage free worker tries to lock a zspage's entire page
> list without defending against page migration. Since pages which haven't
> yet been locked can concurrently migrate off the zspage page list while
> lock_zspage() churns away, lock_zspage() can suffer from a few different
> lethal races. It can lock a page which no longer belongs to the zspage and
> unsafely dereference page_private(), it can unsafely dereference a torn
> pointer to the next page (since there's a data race), and it can observe a
> spurious NULL pointer to the next page and thus not lock all of the
> zspage's pages (since a single page migration will reconstruct the entire
> page list, and create_page_chain() unconditionally zeroes out each list
> pointer in the process).
> 
> Fix the races by using migrate_read_lock() in lock_zspage() to synchronize
> with page migration.
> 
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1718,11 +1718,40 @@ static enum fullness_group putback_zspage(struct size_class *class,
>   */
>  static void lock_zspage(struct zspage *zspage)
>  {
> -	struct page *page = get_first_page(zspage);
> +	struct page *curr_page, *page;
>  
> -	do {
> -		lock_page(page);
> -	} while ((page = get_next_page(page)) != NULL);
> +	/*
> +	 * Pages we haven't locked yet can be migrated off the list while we're
> +	 * trying to lock them, so we need to be careful and only attempt to
> +	 * lock each page under migrate_read_lock(). Otherwise, the page we lock
> +	 * may no longer belong to the zspage. This means that we may wait for
> +	 * the wrong page to unlock, so we must take a reference to the page
> +	 * prior to waiting for it to unlock outside migrate_read_lock().
> +	 */
> +	while (1) {
> +		migrate_read_lock(zspage);
> +		page = get_first_page(zspage);
> +		if (trylock_page(page))
> +			break;
> +		get_page(page);
> +		migrate_read_unlock(zspage);
> +		wait_on_page_locked(page);

Why not simply lock_page() here?  The get_page() alone won't protect
from all the dire consequences which you have identified?

> +		put_page(page);
> +	}
> +
> +	curr_page = page;
> +	while ((page = get_next_page(curr_page))) {
> +		if (trylock_page(page)) {
> +			curr_page = page;
> +		} else {
> +			get_page(page);
> +			migrate_read_unlock(zspage);
> +			wait_on_page_locked(page);

ditto.

> +			put_page(page);
> +			migrate_read_lock(zspage);
> +		}
> +	}
> +	migrate_read_unlock(zspage);
>  }
>  
>  static int zs_init_fs_context(struct fs_context *fc)


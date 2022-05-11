Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C79523C22
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 20:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242923AbiEKSBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 14:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346068AbiEKSBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 14:01:06 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6119938196;
        Wed, 11 May 2022 11:01:04 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r71so2113635pgr.0;
        Wed, 11 May 2022 11:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x6ZYfx/FmTGeNp3axjnUCK+9peN+HxRl/Crr+HjHafo=;
        b=kdxcJwBXu9IAQwLPKaeCqP7YPp/1DBAqxphMpSVyqGIqOa0OSxCCNVw8XUUQLIk8Iq
         RmqMcKeTnf3XhIKp34f5vPjEPHY+pI+zBYIX7nUKXY4ruJR3uRxJ2gdDcFsX6Nvc/jqE
         6xuYNWxiDv9gtug8krZRcaETvQGEKG7avfoTf4IzT4viPi2ryVvtHDzL9l+/e1iRi38E
         Fwgg3ktWJTVcSHJ5fLByxGNbVzPQBYrW/vWgnVG3mZxTgZqxsO4BQiRLafCfvEubxyYu
         OU5++CwStDqEjRdoqB8LhUOykxzPMGvgGcnLdiTPBtpaN+NIo9u37frPazQWFkRGMoQh
         7/gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=x6ZYfx/FmTGeNp3axjnUCK+9peN+HxRl/Crr+HjHafo=;
        b=KIw3sRw9QGUDNaC+7OGWCnqeauT93LMrNeicB5zi2iVLujpiSkrqGZF61sHadMrgUQ
         XWXl/m+aN4q7s0VviRNKC9RjSFP1lYlDSAlra8VIkYJzVHGgRs0gCMJA9lao+jb9Cz8f
         vZ+Sqwor2sBqJFEKsTDm1sgcosvBEOscKYtGc9hrd4nHjf1vmaNaSOH+bc+hze4vsLb+
         oaA/yUyJAA/vcGm4VHGkWlF+yGwobS4urrvq7IGbUkv2PVPyOwgYVyYgRmMXHXkJ24pJ
         5qNjkr/0ZPuswx2CTuJoc0cc8Q5NWMRZ4RWNtoDU8UlM38oNBtfHWWyGepFBsYuGnJ6i
         iVIA==
X-Gm-Message-State: AOAM533FqbPL62MMbi7PAeRNRlicMuavWxe9O/G7tdXEGfSqVB8LeVBn
        H8nMLZgBh6DJdCH1DwOKvMU96xJEkDc=
X-Google-Smtp-Source: ABdhPJxLiD0hYeL6U2Xb/mgBAeEQ9rqMsPYLjeZwvpkGd/pYpUn7M+ZShhJi3ZLNLXB8LHNzFIIM4w==
X-Received: by 2002:a65:4c8e:0:b0:3aa:24bf:9e63 with SMTP id m14-20020a654c8e000000b003aa24bf9e63mr21840616pgt.592.1652292063854;
        Wed, 11 May 2022 11:01:03 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:69ef:9c87:7816:4f74])
        by smtp.gmail.com with ESMTPSA id y3-20020a626403000000b0050dc76281b6sm2130000pfb.144.2022.05.11.11.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 11:01:03 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Wed, 11 May 2022 11:01:01 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Cc:     stable@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zsmalloc: Fix races between asynchronous zspage free and
 page migration
Message-ID: <Ynv53fkx8cG0ixaE@google.com>
References: <20220509024703.243847-1-sultan@kerneltoast.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509024703.243847-1-sultan@kerneltoast.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 08, 2022 at 07:47:02PM -0700, Sultan Alsawaf wrote:
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
> Cc: stable@vger.kernel.org
> Fixes: 48b4800a1c6a ("zsmalloc: page migration support")

Shouldn't the fix be Fixes: 77ff465799c6 ("zsmalloc: zs_page_migrate: skip
unnecessary loops but not return -EBUSY if zspage is not inuse)?
Because we didn't migrate ZS_EMPTY pages before.

> Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
> ---
>  mm/zsmalloc.c | 37 +++++++++++++++++++++++++++++++++----
>  1 file changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 9152fbde33b5..5d5fc04385b8 100644
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

I couldn't get the point here. Why couldn't we simple lock zspage migration?

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 9152fbde33b5..05ff2315b7b1 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1987,7 +1987,10 @@ static void async_free_zspage(struct work_struct *work)
 
        list_for_each_entry_safe(zspage, tmp, &free_pages, list) {
                list_del(&zspage->list);
+
+               migrate_read_lock(zspage);
                lock_zspage(zspage);
+               migrate_read_unlock(zspage);
 
                get_zspage_mapping(zspage, &class_idx, &fullness);
                VM_BUG_ON(fullness != ZS_EMPTY);


> +	 */
> +	while (1) {
> +		migrate_read_lock(zspage);
> +		page = get_first_page(zspage);
> +		if (trylock_page(page))
> +			break;
> +		get_page(page);
> +		migrate_read_unlock(zspage);
> +		wait_on_page_locked(page);
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
> +			put_page(page);
> +			migrate_read_lock(zspage);
> +		}
> +	}
> +	migrate_read_unlock(zspage);
>  }
>  
>  static int zs_init_fs_context(struct fs_context *fc)
> -- 
> 2.36.0
> 

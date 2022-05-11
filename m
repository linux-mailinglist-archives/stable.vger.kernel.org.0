Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F99F523F98
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 23:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243914AbiEKVpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 17:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348263AbiEKVpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 17:45:34 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01740880F3;
        Wed, 11 May 2022 14:45:34 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso3233380pjg.0;
        Wed, 11 May 2022 14:45:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hccI8UlqfXJMYenm6/39/T+QVSnq+XdDQON/tzN24oY=;
        b=2Nau2VXc0KmD4X8B5ngja7opkUeMPRmu+Hm5ew+Fr08r4qyrW7TNxBMSZ5Zlkf31hx
         mDbaMak+8JSHHdZHgxG+pJBFAMDvBqHreLmuhBmHuXJyJUvn0XThOxtwNLRLj2YJf6p6
         yBOFONZnhStFKAMF/taQMyM6uB391fZPLw1cC9wY6aOzp+FpN8fsZldpoj9/pLEHKEg5
         ZbYzpDFCktiVsREGo0CD43ZcW636NB9Yt22+lJQS84KYxixjmavyhWECVWYCC6/e52t6
         4i+sdmVb9qzIbkyVQ8YvX2tQ36I2VcBr27TVranLA10stDPF059KxEt87TXeZD1wbtEB
         8q6Q==
X-Gm-Message-State: AOAM5326Pqsl1bkhvQ/imZjDfxMb06Hy36m0IW3j533pXoZER9CcpWW+
        bYdNLFRCTnM6srcvw6HCTNU=
X-Google-Smtp-Source: ABdhPJyqwwqMWMSTHIkPjyk0V3hrhrXMPefLSWa46Y0DRvr8ESWCK43x0POV9JQ/7C6WKYMm+wlv6Q==
X-Received: by 2002:a17:90a:db45:b0:1d9:29d0:4c6e with SMTP id u5-20020a17090adb4500b001d929d04c6emr7428285pjx.46.1652305533462;
        Wed, 11 May 2022 14:45:33 -0700 (PDT)
Received: from sultan-box.localdomain ([204.152.216.102])
        by smtp.gmail.com with ESMTPSA id az12-20020a170902a58c00b0015e8d4eb2d5sm2312664plb.287.2022.05.11.14.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 14:45:32 -0700 (PDT)
Date:   Wed, 11 May 2022 14:45:30 -0700
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Minchan Kim <minchan@kernel.org>
Cc:     stable@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zsmalloc: Fix races between asynchronous zspage free and
 page migration
Message-ID: <Ynwuepzrr3krjLG0@sultan-box.localdomain>
References: <20220509024703.243847-1-sultan@kerneltoast.com>
 <Ynv53fkx8cG0ixaE@google.com>
 <YnwTfBLn+6vYSe59@sultan-box.localdomain>
 <Ynwlh3RT0PAYpWpD@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ynwlh3RT0PAYpWpD@google.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 11, 2022 at 02:07:19PM -0700, Minchan Kim wrote:
> Then, how about this?

Your proposal is completely wrong still. My original patch is fine; we can stick
with that.

> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 9152fbde33b5..2f205c18aee4 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1716,12 +1716,31 @@ static enum fullness_group putback_zspage(struct size_class *class,
>   * To prevent zspage destroy during migration, zspage freeing should
>   * hold locks of all pages in the zspage.
>   */
> -static void lock_zspage(struct zspage *zspage)
> +static void lock_zspage(struct zs_pool *pool, struct zspage *zspage)
>  {
> -       struct page *page = get_first_page(zspage);
> -
> +       struct page *page;
> +       int nr_locked;
> +       struct page *locked_pages[ZS_MAX_PAGES_PER_ZSPAGE];
> +       struct address_space *mapping;
> +retry:
> +       nr_locked = 0;
> +       memset(locked_pages, 0, sizeof(struct page) * ARRAY_SIZE(locked_pages));

This memset() zeroes out memory past the end of the array because it is an array
of pointers, not an array of page structs; the sizeof() is incorrect.

> +       page = get_first_page(zspage);

You can't use get_first_page() outside of the migrate lock.

>         do {
>                 lock_page(page);

You can't lock a page that you don't own.

> +               locked_pages[nr_locked++] = page;
> +               /*
> +                * subpage in the zspage could be migrated under us so
> +                * verify it. Once it happens, retry the lock sequence.
> +                */
> +               mapping = page_mapping(page)

This doesn't compile.

> +               if (mapping != pool->inode->i_mapping ||
> +                   page_private(page) != (unsigned long)zspage) {
> +                       do {
> +                               unlock_page(locked_pages[--nr_locked]);
> +                       } while (nr_locked > 0)

This doesn't compile.

> +                       goto retry;
> +               }

There's no need to unlock all of the pages that were locked so far because once
a page is locked, it cannot be migrated.

>         } while ((page = get_next_page(page)) != NULL);
>  }

You can't use get_next_page() outside of the migrate lock.

> 
> @@ -1987,7 +2006,7 @@ static void async_free_zspage(struct work_struct *work)
> 
>         list_for_each_entry_safe(zspage, tmp, &free_pages, list) {
>                 list_del(&zspage->list);
> -               lock_zspage(zspage);
> +               lock_zspage(pool, zspage);
> 
>                 get_zspage_mapping(zspage, &class_idx, &fullness);
>                 VM_BUG_ON(fullness != ZS_EMPTY);

Sultan

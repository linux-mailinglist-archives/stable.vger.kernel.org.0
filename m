Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603AF52408E
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 01:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242020AbiEKXLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 19:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235432AbiEKXLc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 19:11:32 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8828F166D69;
        Wed, 11 May 2022 16:11:31 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id p8so3222036pfh.8;
        Wed, 11 May 2022 16:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MEqjTqSjqmMIuaSPAUx7oOxbnCyzM14W0OQ7p+YKgaA=;
        b=OO0FDV1bq7bbLEcW5K/OOQn7t+mbQn/HmxR876UxN64L7J9yFUl79YN2I1G8BzI8LS
         8ahyE8bbfwQMDNOIf9/MoCUJkFG00zgJ/wr1j7W9uawZDvB4pwcI5i7+GCHBGMF9MZbC
         0OtOftsAeWpC2Sy47SXjajI3ibQ6btVwUzR2s+UeE/MiuCwlZ2jyLWyg/HYTuPyaSp+h
         yW4Tvf5glxvINMJIAxyzVw+d9/Nx3C48/MTJj/GItj1LZedsMnjcDWC/JWqjHi9kgEVe
         N4CE3ovzSnNJrT9XZvLd2OCd7HZqq+HCfcJWIeIM8ERhTB8eaWvN5JmXHWhaqA0N/4AZ
         cZMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=MEqjTqSjqmMIuaSPAUx7oOxbnCyzM14W0OQ7p+YKgaA=;
        b=elWiyGF36jleeAG/B6cD1HAIibfxoi+nUMRAP9iAuqpXaP20SBgBnDkVNXmaGD/l94
         5+jnK7uJDU+uOA8GOBsYM6cluJscJPf/VGpF3BOVJJUBDw5Azx2iTolYi8Isf77D155g
         HxR/A83SRVGEnCFGzei7TI1d82DI9Hr36jRzBC2+U5A4w52YzNlQMWdO4JSismXKYuHp
         raIZgqgyMA9H5ED/a0Iw+l+4BndBRuSSwJYkWQlGwTIndP7B04+/xLnra8M6x7BxCC4Y
         UnDB7cO/Lxd/1JflhnJyWB0XewdFmfKJIs06SLJlBbeFjVzEhPx1XuTll/Z7Reshrw8u
         LMpQ==
X-Gm-Message-State: AOAM530hHvD2cTSBRQ7BUhz+lXgUiQ82G/2G6L39gEMG6eBQKHh+10wY
        I9V6vFnDaTol22ge6BLZQJ0=
X-Google-Smtp-Source: ABdhPJzvsu0OLili6rcBqqXjjxsInmK4R1TnfZvsyecNHFOt+dDtHqGBt6AWAjI3D8PIZqxqvdNMog==
X-Received: by 2002:a05:6a00:1307:b0:50d:b02e:11df with SMTP id j7-20020a056a00130700b0050db02e11dfmr2831252pfu.4.1652310691014;
        Wed, 11 May 2022 16:11:31 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:69ef:9c87:7816:4f74])
        by smtp.gmail.com with ESMTPSA id 32-20020a631560000000b003c14af5060esm419508pgv.38.2022.05.11.16.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 16:11:30 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Wed, 11 May 2022 16:11:28 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Cc:     stable@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zsmalloc: Fix races between asynchronous zspage free and
 page migration
Message-ID: <YnxCoCJJxk/1ONeP@google.com>
References: <20220509024703.243847-1-sultan@kerneltoast.com>
 <Ynv53fkx8cG0ixaE@google.com>
 <YnwTfBLn+6vYSe59@sultan-box.localdomain>
 <Ynwlh3RT0PAYpWpD@google.com>
 <Ynwuepzrr3krjLG0@sultan-box.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ynwuepzrr3krjLG0@sultan-box.localdomain>
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

On Wed, May 11, 2022 at 02:45:30PM -0700, Sultan Alsawaf wrote:
> On Wed, May 11, 2022 at 02:07:19PM -0700, Minchan Kim wrote:
> > Then, how about this?
> 
> Your proposal is completely wrong still. My original patch is fine; we can stick
> with that.
> 
> > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > index 9152fbde33b5..2f205c18aee4 100644
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -1716,12 +1716,31 @@ static enum fullness_group putback_zspage(struct size_class *class,
> >   * To prevent zspage destroy during migration, zspage freeing should
> >   * hold locks of all pages in the zspage.
> >   */
> > -static void lock_zspage(struct zspage *zspage)
> > +static void lock_zspage(struct zs_pool *pool, struct zspage *zspage)
> >  {
> > -       struct page *page = get_first_page(zspage);
> > -
> > +       struct page *page;
> > +       int nr_locked;
> > +       struct page *locked_pages[ZS_MAX_PAGES_PER_ZSPAGE];
> > +       struct address_space *mapping;
> > +retry:
> > +       nr_locked = 0;
> > +       memset(locked_pages, 0, sizeof(struct page) * ARRAY_SIZE(locked_pages));
> 
> This memset() zeroes out memory past the end of the array because it is an array
> of pointers, not an array of page structs; the sizeof() is incorrect.
> 
> > +       page = get_first_page(zspage);
> 
> You can't use get_first_page() outside of the migrate lock.
> 
> >         do {
> >                 lock_page(page);
> 
> You can't lock a page that you don't own.

That's key point what my idea was wrong.

Thanks for correction!

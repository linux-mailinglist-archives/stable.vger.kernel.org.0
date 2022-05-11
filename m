Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61737523F37
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 23:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347982AbiEKVHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 17:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347976AbiEKVHY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 17:07:24 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A3769734;
        Wed, 11 May 2022 14:07:22 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so3139608pjq.2;
        Wed, 11 May 2022 14:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b6r4iHXphce3qNrnt+WRxrpdsuktB8YXEoXsfGUyHyI=;
        b=d4IUXwD6gNj+uMj33TgTBflRj0rCzQNCBSP2h/Dsw1Iic+6tmFza6E33WjBeogUxoZ
         AXIYPxoDF965KU6BDZsGazc/wZ4G/Xp0tjVwjWHxKvKOSk8krMWdCH3KZmJ0zX1z8lJf
         kqh/21TsYPw21f4ZKwa9Cl3uxGSMGvlmNBquUpHI64w58P2SZ8BEnXTSeBmJbBuVziKM
         8VnV7k8BAdJUdtCI7BNzD4gGGjiid1w5DE14hFWu4z/nipkb4+MkQPaWeZ78lOp/nNgF
         Pl4/leS3mZ0ZiMOHxGhjI8LgV2DbiD6+rptjSoAfZiNdAKlq0J5CHsInL7e7fkXIGZmj
         0v4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=b6r4iHXphce3qNrnt+WRxrpdsuktB8YXEoXsfGUyHyI=;
        b=yG4sJACYvMFxOzgf7HuEIz/VwsmQcl1lv6gdVrI2c8xxjxORtdiPRk/T7fQ9tteS2z
         AJ8TaXCzBClhfUHRzZOoCSTk8HofbVp2sFVSJghQHSY5lQlIXFNBa3Noe2p10EuOm3wA
         SUzqFs2tAjSHp17EXA8DHYkiFSPTjHmCUbKytD30k0lQy4lrDFegO+LnyFUitR4mDair
         EwnKZOkmUqUjowU2YFptSobksTpb4P+22OAg4IZZEkJYXKnk5nyo9DzM8l7CWDyAqBoz
         +c8m9Z61XaKM2HmsFu4m3Y9LZ1zI0qFffnf3BaYT+82v/CFWwmU3tCcugvCtYAvkPHYS
         ycWw==
X-Gm-Message-State: AOAM533TfmZpJwK9gKN/UoVdrO74Bv3ZLEwg7MoLDXKqwW+BUWxx2UuS
        Af8ispytLjvrMm5PhJ36OOk=
X-Google-Smtp-Source: ABdhPJw/H8QUlaG/k/sM5buMEEA7It/aboEPNCK6XBNNFa2imfElrbbgBDOeD4Oqn5yTRTrjuxAgLA==
X-Received: by 2002:a17:90a:d497:b0:1dc:9cbe:6a47 with SMTP id s23-20020a17090ad49700b001dc9cbe6a47mr7218865pju.108.1652303241630;
        Wed, 11 May 2022 14:07:21 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:69ef:9c87:7816:4f74])
        by smtp.gmail.com with ESMTPSA id p5-20020a170902b08500b0015e8d4eb1d6sm2361601plr.32.2022.05.11.14.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 14:07:21 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Wed, 11 May 2022 14:07:19 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Cc:     stable@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zsmalloc: Fix races between asynchronous zspage free and
 page migration
Message-ID: <Ynwlh3RT0PAYpWpD@google.com>
References: <20220509024703.243847-1-sultan@kerneltoast.com>
 <Ynv53fkx8cG0ixaE@google.com>
 <YnwTfBLn+6vYSe59@sultan-box.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnwTfBLn+6vYSe59@sultan-box.localdomain>
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

On Wed, May 11, 2022 at 12:50:20PM -0700, Sultan Alsawaf wrote:
> On Wed, May 11, 2022 at 11:01:01AM -0700, Minchan Kim wrote:
> > On Sun, May 08, 2022 at 07:47:02PM -0700, Sultan Alsawaf wrote:
> > > Cc: stable@vger.kernel.org
> > > Fixes: 48b4800a1c6a ("zsmalloc: page migration support")
> > 
> > Shouldn't the fix be Fixes: 77ff465799c6 ("zsmalloc: zs_page_migrate: skip
> > unnecessary loops but not return -EBUSY if zspage is not inuse)?
> > Because we didn't migrate ZS_EMPTY pages before.
> 
> Hi,
> 
> Yeah, 77ff465799c6 indeed seems like the commit that introduced the bug.
> 
> > I couldn't get the point here. Why couldn't we simple lock zspage migration?
> > 
> > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > index 9152fbde33b5..05ff2315b7b1 100644
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -1987,7 +1987,10 @@ static void async_free_zspage(struct work_struct *work)
> >  
> >         list_for_each_entry_safe(zspage, tmp, &free_pages, list) {
> >                 list_del(&zspage->list);
> > +
> > +               migrate_read_lock(zspage);
> >                 lock_zspage(zspage);
> > +               migrate_read_unlock(zspage);
> >  
> >                 get_zspage_mapping(zspage, &class_idx, &fullness);
> >                 VM_BUG_ON(fullness != ZS_EMPTY);
> 
> There are two problems with this:
> 1. migrate_read_lock() is a rwlock and lock_page() can sleep.
> 2. This will cause a deadlock because it violates the lock ordering in
>    zs_page_migrate(), since zs_page_migrate() takes migrate_write_lock() under
>    the page lock.
> 

That's true. Thanks!

Then, how about this?

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 9152fbde33b5..2f205c18aee4 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1716,12 +1716,31 @@ static enum fullness_group putback_zspage(struct size_class *class,
  * To prevent zspage destroy during migration, zspage freeing should
  * hold locks of all pages in the zspage.
  */
-static void lock_zspage(struct zspage *zspage)
+static void lock_zspage(struct zs_pool *pool, struct zspage *zspage)
 {
-       struct page *page = get_first_page(zspage);
-
+       struct page *page;
+       int nr_locked;
+       struct page *locked_pages[ZS_MAX_PAGES_PER_ZSPAGE];
+       struct address_space *mapping;
+retry:
+       nr_locked = 0;
+       memset(locked_pages, 0, sizeof(struct page) * ARRAY_SIZE(locked_pages));
+       page = get_first_page(zspage);
        do {
                lock_page(page);
+               locked_pages[nr_locked++] = page;
+               /*
+                * subpage in the zspage could be migrated under us so
+                * verify it. Once it happens, retry the lock sequence.
+                */
+               mapping = page_mapping(page)
+               if (mapping != pool->inode->i_mapping ||
+                   page_private(page) != (unsigned long)zspage) {
+                       do {
+                               unlock_page(locked_pages[--nr_locked]);
+                       } while (nr_locked > 0)
+                       goto retry;
+               }
        } while ((page = get_next_page(page)) != NULL);
 }

@@ -1987,7 +2006,7 @@ static void async_free_zspage(struct work_struct *work)

        list_for_each_entry_safe(zspage, tmp, &free_pages, list) {
                list_del(&zspage->list);
-               lock_zspage(zspage);
+               lock_zspage(pool, zspage);

                get_zspage_mapping(zspage, &class_idx, &fullness);
                VM_BUG_ON(fullness != ZS_EMPTY);



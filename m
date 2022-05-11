Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2AFF523DF2
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 21:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245458AbiEKTu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 15:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241363AbiEKTu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 15:50:26 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5491230225;
        Wed, 11 May 2022 12:50:23 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so5876940pju.2;
        Wed, 11 May 2022 12:50:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NQqa4NCLuH69QVRWRKwlBaMthxo9RbegNopzdicXQlQ=;
        b=pGfANRYR/Kwia4UK8epGkbpDyy1dNzZ66ewceqHhl38v6sZg4gQkFFrC16GP7TO6Og
         IJaBWsF6ee1WU/lVjhJhpMfTts7/B6+ATBI3H6HFD93mjhV4wt+Yr22zj2TRHaNUJyCV
         TDxKXY3VZNpyaZFJsOs0twHqlRj9CiTz4IWQOl0DNW1V7aLev1YuZnfm+G9JYIZXCwTk
         XMUxxpOFLJpSIEv5Z9bMXGzBUCGuuyvmKBQLWnWBz8vOkcK9Hc6/52IZUOnUBgUnMmAg
         MtBA3Ht0BwF/mFYAYF9JzZhH/+SeZu3JikJB+rp3voebTXV7fjVHmg9HsiFy34Kwoohj
         ZXWw==
X-Gm-Message-State: AOAM532WTulN3OdQMQKlciGofnHKDulS59UB8QaHQED//vLZqXc4z5d/
        o0JISRcMjhsiN81Lzags06k=
X-Google-Smtp-Source: ABdhPJz0rPYrf6faYGgucXqaE8izHgU+jh+jnUWb+tXPQuELlzX4XQ2p5283OLQ3hg3fmxjaMZjGDg==
X-Received: by 2002:a17:902:cec9:b0:15e:cbf4:c246 with SMTP id d9-20020a170902cec900b0015ecbf4c246mr27625166plg.1.1652298623146;
        Wed, 11 May 2022 12:50:23 -0700 (PDT)
Received: from sultan-box.localdomain ([204.152.216.102])
        by smtp.gmail.com with ESMTPSA id b8-20020a1709027e0800b0015ef27092aasm2292465plm.190.2022.05.11.12.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 12:50:22 -0700 (PDT)
Date:   Wed, 11 May 2022 12:50:20 -0700
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Minchan Kim <minchan@kernel.org>
Cc:     stable@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zsmalloc: Fix races between asynchronous zspage free and
 page migration
Message-ID: <YnwTfBLn+6vYSe59@sultan-box.localdomain>
References: <20220509024703.243847-1-sultan@kerneltoast.com>
 <Ynv53fkx8cG0ixaE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ynv53fkx8cG0ixaE@google.com>
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

On Wed, May 11, 2022 at 11:01:01AM -0700, Minchan Kim wrote:
> On Sun, May 08, 2022 at 07:47:02PM -0700, Sultan Alsawaf wrote:
> > Cc: stable@vger.kernel.org
> > Fixes: 48b4800a1c6a ("zsmalloc: page migration support")
> 
> Shouldn't the fix be Fixes: 77ff465799c6 ("zsmalloc: zs_page_migrate: skip
> unnecessary loops but not return -EBUSY if zspage is not inuse)?
> Because we didn't migrate ZS_EMPTY pages before.

Hi,

Yeah, 77ff465799c6 indeed seems like the commit that introduced the bug.

> I couldn't get the point here. Why couldn't we simple lock zspage migration?
> 
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 9152fbde33b5..05ff2315b7b1 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1987,7 +1987,10 @@ static void async_free_zspage(struct work_struct *work)
>  
>         list_for_each_entry_safe(zspage, tmp, &free_pages, list) {
>                 list_del(&zspage->list);
> +
> +               migrate_read_lock(zspage);
>                 lock_zspage(zspage);
> +               migrate_read_unlock(zspage);
>  
>                 get_zspage_mapping(zspage, &class_idx, &fullness);
>                 VM_BUG_ON(fullness != ZS_EMPTY);

There are two problems with this:
1. migrate_read_lock() is a rwlock and lock_page() can sleep.
2. This will cause a deadlock because it violates the lock ordering in
   zs_page_migrate(), since zs_page_migrate() takes migrate_write_lock() under
   the page lock.

Sultan

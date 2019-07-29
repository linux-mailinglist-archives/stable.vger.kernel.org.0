Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C80A07932C
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 20:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfG2SjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 14:39:09 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42064 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbfG2SjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 14:39:09 -0400
Received: by mail-io1-f68.google.com with SMTP id e20so91882343iob.9
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 11:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1FwMHPlbmAPxJQ/mJ/56Fjrh96L8HY/RcidjTcs4/fk=;
        b=tKzCUvFdpAjThXn2UowV+bawmycTgopdxquIlC+dqdFlomKh47e7PWPAWXwPDhlEV0
         WGaL2Lf3K2nX3uFrFKxHvVy8tSxAc9k2gVTAD9NVYrqF8DkZZW7UipkFX9bjCJCenxdt
         8Yu/uW7CHfDxENOSQSV6rziYo0QM8mfjwOKxWkAT1Jf4g729nbl1Eezj6UAWOTn672O/
         z1GpzyJZZlnM6k4dWYNVDKijnjLKx/kofl9zYXDCLISx67v1pkIzpZOukDv0BLs20LUp
         KWxNi9rJdkEwe55x4UrQMFO2ktWdudcrVcoyNBOJlB/pjpy3BEx0u41fUVp5lz6G+xXW
         k4HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1FwMHPlbmAPxJQ/mJ/56Fjrh96L8HY/RcidjTcs4/fk=;
        b=P0y77/pplHMII0M0quikTgmL4ZZvHXOqa8f408vor+uBbQj4odxobVWWPkZU1r0rHj
         3Lsnp7tEd4YPZc2fgUbUGj/BKYEZDaNqHutgjZAJYd7A/v5yGjfq0zLQqcvbrToApnnQ
         1x5/Fq/quU1F49GsN9lCq0aT/J4SmE1SeFIdLGN+Gb22Yujn95VskLeEvuUNNAtDber+
         wstChaK4NfrRm1d2Tvjt5I5rJgKVL9F/RH6mCGEEm1h6K18AsXUDza6j98Xwsaro4Kwl
         oj0KgyJVonKZIoFMY4/A4rOMBW4IoMFsOxnY7M2JRSr/GwBTAV/tO23PrROvrRzY3Jkm
         DMiA==
X-Gm-Message-State: APjAAAX/1p5HP+1MxF8XrWCdJSxw05AiJ0OTYUbjrLFdYo26XqYZ8vMO
        Jyz5VzmkGE2LtD3/RY9P3ZuEaWjLJkksfEvuG2uUPg==
X-Google-Smtp-Source: APXvYqwOyvbINe7VjyObX3vCNtadyRi+XDTMas83pG4+8ZVxw9xxSxj0gKL6sLA3lpVp0q7URJsTTC8vSVXcO2bi+AM=
X-Received: by 2002:a5d:9e48:: with SMTP id i8mr101423232ioi.51.1564425548036;
 Mon, 29 Jul 2019 11:39:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190726224810.79660-1-henryburns@google.com> <CA+VK+GM4AXrmZtv_narEU6pHO+NGrTc74iSSUNNbutZySfXjRw@mail.gmail.com>
In-Reply-To: <CA+VK+GM4AXrmZtv_narEU6pHO+NGrTc74iSSUNNbutZySfXjRw@mail.gmail.com>
From:   Henry Burns <henryburns@google.com>
Date:   Mon, 29 Jul 2019 11:38:32 -0700
Message-ID: <CAGQXPTgGJBiLVqAGWQZpSrTcWw4FnzDSkQWFOPhJ=TqtnQZPvw@mail.gmail.com>
Subject: Re: [PATCH] mm/z3fold.c: Fix z3fold_destroy_pool() ordering
To:     Jonathan Adams <jwadams@google.com>
Cc:     Vitaly Vul <vitaly.vul@sony.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The constraint from the zpool use of z3fold_destroy_pool() is there
are no outstanding handles to memory (so no active allocations), but
it is possible for there to be outstanding work on either of the two
wqs in the pool.


If there is work queued on pool->compact_workqueue when it is called,
z3fold_destroy_pool() will do:

   z3fold_destroy_pool()
     destroy_workqueue(pool->release_wq)
     destroy_workqueue(pool->compact_wq)
       drain_workqueue(pool->compact_wq)
         do_compact_page(zhdr)
           kref_put(&zhdr->refcount)
             __release_z3fold_page(zhdr, ...)
               queue_work_on(pool->release_wq, &pool->work) *BOOM*

So compact_wq needs to be destroyed before release_wq.

Fixes: 5d03a6613957 ("mm/z3fold.c: use kref to prevent page free/compact race")

Signed-off-by: Henry Burns <henryburns@google.com>


> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> Reviewed-by: Jonathan Adams <jwadams@google.com>
>
> > Cc: <stable@vger.kernel.org>
> > ---
> >  mm/z3fold.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/z3fold.c b/mm/z3fold.c
> > index 1a029a7432ee..43de92f52961 100644
> > --- a/mm/z3fold.c
> > +++ b/mm/z3fold.c
> > @@ -818,8 +818,15 @@ static void z3fold_destroy_pool(struct z3fold_pool *pool)
> >  {
> >         kmem_cache_destroy(pool->c_handle);
> >         z3fold_unregister_migration(pool);
> > -       destroy_workqueue(pool->release_wq);
> > +
> > +       /*
> > +        * We need to destroy pool->compact_wq before pool->release_wq,
> > +        * as any pending work on pool->compact_wq will call
> > +        * queue_work(pool->release_wq, &pool->work).
> > +        */
> > +
> >         destroy_workqueue(pool->compact_wq);
> > +       destroy_workqueue(pool->release_wq);
> >         kfree(pool);
> >  }
> >
> > --
> > 2.22.0.709.g102302147b-goog
> >

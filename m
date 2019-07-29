Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDAC07934C
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 20:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387980AbfG2SmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 14:42:25 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34233 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387397AbfG2SmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 14:42:22 -0400
Received: by mail-io1-f68.google.com with SMTP id k8so122357806iot.1
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 11:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3tfpxcMIOawO8s0nF6u5AxpRiYOClgINgvc5ma6ttZw=;
        b=IQmmqup/6r9M4vGzFNJ2eQeqgw7xlIoAUs5jeMBIFXwMw1/6E8KZwGF59gU1R/s1wr
         od8n0zVv12PnonheCchmyOFja2Rj5CqOQgVE6IuSCXp0atpMNpN4A4t4/7Vf5jI1f1tC
         bqmDTxp9EjXqdrgmgE7jOAMpjGGp01BzpAfRmS/bOjpScIYhwcfWKhJCbOf4mGM/MuOx
         kfDC4rfXTjw6TLq0kV/0cEZZi4Hv/UOPJ9FqlF/1RHxu+j97c80UihRGIktDhfVOQUtm
         u+Knabw655Ohtf9vz38yQiZVVGmgt0OllVIj/2aK5dgiGvZqqDwcxin29m4BabmpHLuu
         rFwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3tfpxcMIOawO8s0nF6u5AxpRiYOClgINgvc5ma6ttZw=;
        b=CoBrd0RGUyQqpblhqCl3ngGQc6KjYaHACOnSeLK2IbD0tdaacwmRzIFvw20Gp/shFT
         K+KfU6v2A7lsMn04HlS6F14rTV4jVd4/8EDN83m8wpXxsVMN3kX31h+sqcbf0LsO4hJE
         /ZCZyk9tb44fqcnR4MmTDWikJOX4cicJKUWxa8p58hghhFk5rPQwIiqKBmefVoy9lCG1
         GXU+0UGUYcfFDvUb81x3vahX42ac5/XlOclpa/cHtRfp+wGyofNPV8xACSjXi5cEVmZS
         /hireKwD2OFd6/6KLYEW4tC0WysyJWfrki4oB8HLnyaUE7Y7KETJhhA/Z1qjU0Aup3QO
         AEqQ==
X-Gm-Message-State: APjAAAXFgOvn1xsoG0UGawc8XyyzUiJ/RZu2RlRuUAuOXYwV//7RRnw9
        KD2wJ93KfdoiiKEI5u79hmD5SA/CTq7Ezhc+7/wyoA==
X-Google-Smtp-Source: APXvYqwjLiqzT6+l8biMGbT+ubzfDFZQP3pdxi7Bs2LEIu59aazQJHsn2226HIPI6J8GkYWgkqquogjLf6r6kCe70Dg=
X-Received: by 2002:a6b:c38b:: with SMTP id t133mr38575856iof.162.1564425741290;
 Mon, 29 Jul 2019 11:42:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190726224810.79660-1-henryburns@google.com> <20190726224810.79660-2-henryburns@google.com>
 <CA+VK+GPC+akF0qGrKFivtNneweEfdC9uEx=QgmztB4M_xvMeKQ@mail.gmail.com>
In-Reply-To: <CA+VK+GPC+akF0qGrKFivtNneweEfdC9uEx=QgmztB4M_xvMeKQ@mail.gmail.com>
From:   Henry Burns <henryburns@google.com>
Date:   Mon, 29 Jul 2019 11:41:45 -0700
Message-ID: <CAGQXPTi8+EanC2ygr4W7qDN1bnas_3utxFkSCj4Xdzo4H134nw@mail.gmail.com>
Subject: Re: [PATCH] mm/z3fold.c: Fix z3fold_destroy_pool() race condition
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

Calling z3fold_deregister_migration() before the workqueues are drained
means that there can be allocated pages referencing a freed inode,
causing any thread in compaction to be able to trip over the bad
pointer in PageMovable().

Fixes: 1f862989b04a ("mm/z3fold.c: support page migration")

Signed-off-by: Henry Burns <henryburns@google.com>

> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> Reviewed-by: Jonathan Adams <jwadams@google.com>
>
> > Cc: <stable@vger.kernel.org>
> > ---
> >  mm/z3fold.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/z3fold.c b/mm/z3fold.c
> > index 43de92f52961..ed19d98c9dcd 100644
> > --- a/mm/z3fold.c
> > +++ b/mm/z3fold.c
> > @@ -817,16 +817,19 @@ static struct z3fold_pool *z3fold_create_pool(const char *name, gfp_t gfp,
> >  static void z3fold_destroy_pool(struct z3fold_pool *pool)
> >  {
> >         kmem_cache_destroy(pool->c_handle);
> > -       z3fold_unregister_migration(pool);
> >
> >         /*
> >          * We need to destroy pool->compact_wq before pool->release_wq,
> >          * as any pending work on pool->compact_wq will call
> >          * queue_work(pool->release_wq, &pool->work).
> > +        *
> > +        * There are still outstanding pages until both workqueues are drained,
> > +        * so we cannot unregister migration until then.
> >          */
> >
> >         destroy_workqueue(pool->compact_wq);
> >         destroy_workqueue(pool->release_wq);
> > +       z3fold_unregister_migration(pool);
> >         kfree(pool);
> >  }
> >
> > --
> > 2.22.0.709.g102302147b-goog
> >

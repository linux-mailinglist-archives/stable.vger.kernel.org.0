Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1251774E9
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 01:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfGZXVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 19:21:10 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45178 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfGZXVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 19:21:09 -0400
Received: by mail-qk1-f194.google.com with SMTP id s22so40323311qkj.12
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 16:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ds6Pn84xnJTs59aQRjsfc8MfNMObGqVIqTNdYf6jDF8=;
        b=pmprGLF2LW0+Sp8wpilnKxyQ9fpy3RtVaI/uwKChRR6jU8kYntVB/SBwjs2iJ/Ef8t
         AgoaxKSIaFJe7S7BnUBMzaU5bXb26v3v8TOCHBgGl7orVWxAEikEx7zs9FYVRZ2Kuhq4
         LSTUWhQCKjMaQS5eEZ+BcJitwk4cPKvlrXSZDX1iHbS8B0nL0AA6pOZy4QXcTcQMysE5
         AythhYvQwGo01Exhcg+nMLtnS5XdBJBKrjciS0HpJOZvZWTfMOeSAbBRtlq3DFoVJ+4G
         xBuI0RwArlsSejlPmK0YyqwlQDzixITgfEA6xxl4awy3u7kqIvjgYTSSMEYLmZZ99w5Y
         y/EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ds6Pn84xnJTs59aQRjsfc8MfNMObGqVIqTNdYf6jDF8=;
        b=l5MG+6KCv+qHhV6xTYGmxZbRPH/pHl+rdHnAF7HUphdH1rPXvjOCTX68IxXWiDXl1c
         YoN7GQGA/wfCmQVT2nPso3cTvW/gclE/JvLvJBKBsFYbYea0x/gVSHNVi9OCPLm6+Zds
         vyRw/mIbisXQcZefp3/3Jpox4Tda3Hn8zfPiZB4scwJ4ss0eEVCNF6zFAbVMwPIT5Hrp
         rtTSjUpF/BaClGCSapJwhBrs3uKwQRxSFsTC4IYFr1WSm+mDVS355lVGdaEkFoXN59MM
         IlPPXeyD685Pgfn2HU3rlpfJaAYI71G8Muqc1BN7HYji7F7v7aSCcELDFo8XH65SkmJi
         9Auw==
X-Gm-Message-State: APjAAAVrLvAOKy3QkuXDdTJ3e5hLGnC0S9O+Bhv/hPocAAuGSQ9Istn0
        Bx3Pj+sXHjVO0KgSCN25gtAdKrrVdZ+H48ieWlWy
X-Google-Smtp-Source: APXvYqxKsvOaZxq1HqBf7Rf4YiQTcQkrpQGtj9XSIYZVHNSOdDHelqirkEJK9WTuzvgEgdBC2jX6zOfxq5cVBDabxl8=
X-Received: by 2002:a37:9ac9:: with SMTP id c192mr65323076qke.30.1564183268223;
 Fri, 26 Jul 2019 16:21:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190726224810.79660-1-henryburns@google.com> <20190726224810.79660-2-henryburns@google.com>
In-Reply-To: <20190726224810.79660-2-henryburns@google.com>
From:   Jonathan Adams <jwadams@google.com>
Date:   Fri, 26 Jul 2019 16:20:32 -0700
Message-ID: <CA+VK+GPC+akF0qGrKFivtNneweEfdC9uEx=QgmztB4M_xvMeKQ@mail.gmail.com>
Subject: Re: [PATCH] mm/z3fold.c: Fix z3fold_destroy_pool() race condition
To:     Henry Burns <henryburns@google.com>
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

On Fri, Jul 26, 2019 at 3:48 PM Henry Burns <henryburns@google.com> wrote:
>
> The constraint from the zpool use of z3fold_destroy_pool() is there are no
> outstanding handles to memory (so no active allocations), but it is possible
> for there to be outstanding work on either of the two wqs in the pool.
>
> Calling z3fold_deregister_migration() before the workqueues are drained
> means that there can be allocated pages referencing a freed inode,
> causing any thread in compaction to be able to trip over the bad
> pointer in PageMovable().
>
> Fixes: 1f862989b04a ("mm/z3fold.c: support page migration")
>
> Signed-off-by: Henry Burns <henryburns@google.com>

Reviewed-by: Jonathan Adams <jwadams@google.com>

> Cc: <stable@vger.kernel.org>
> ---
>  mm/z3fold.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/mm/z3fold.c b/mm/z3fold.c
> index 43de92f52961..ed19d98c9dcd 100644
> --- a/mm/z3fold.c
> +++ b/mm/z3fold.c
> @@ -817,16 +817,19 @@ static struct z3fold_pool *z3fold_create_pool(const char *name, gfp_t gfp,
>  static void z3fold_destroy_pool(struct z3fold_pool *pool)
>  {
>         kmem_cache_destroy(pool->c_handle);
> -       z3fold_unregister_migration(pool);
>
>         /*
>          * We need to destroy pool->compact_wq before pool->release_wq,
>          * as any pending work on pool->compact_wq will call
>          * queue_work(pool->release_wq, &pool->work).
> +        *
> +        * There are still outstanding pages until both workqueues are drained,
> +        * so we cannot unregister migration until then.
>          */
>
>         destroy_workqueue(pool->compact_wq);
>         destroy_workqueue(pool->release_wq);
> +       z3fold_unregister_migration(pool);
>         kfree(pool);
>  }
>
> --
> 2.22.0.709.g102302147b-goog
>

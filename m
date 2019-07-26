Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF267774E7
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 01:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfGZXUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 19:20:23 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35094 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbfGZXUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 19:20:23 -0400
Received: by mail-qt1-f194.google.com with SMTP id d23so54292276qto.2
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 16:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WuNOArHZs/CiCRyKyjlclGYC7Ncl5iJJmT+ESUl6jAA=;
        b=kEGHfnb+ky7mAtpgS94T1BlDhXrjAF9XMpWdm7fL5wWt0lI7aJD3/bimEU3aictx5/
         /FVoxvjWSJOsaau/ArFWCvjl3UvCYt0UKuqbV3FAYijG3r3NaxbYAKdIv1U91mIBuOWl
         kovT+dhR3I24/oGuwK8rnhXVMwHQc2af+OjHNTY8E16Znr5UlJcLtWNs1/2WObenCUL6
         0XF23LaWT12L30puEcM9OgpjsfeZcqTR9sQGgi8O0ELN4Rr38CxkxB+JwiB78TG4CrBN
         8pld23xKRXm20Xxzwcz/LE4LBTuO3cSd5KZ05jAqnl4jlavcMrtBsfAUmwQu1m8TlvJn
         qLYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WuNOArHZs/CiCRyKyjlclGYC7Ncl5iJJmT+ESUl6jAA=;
        b=XIamBiJUcCh3opkLuBJsz+WtC17BPW5lahXN+/I6XPH+87v/tbUrHy3V7WgRRnVcp4
         zddxipIfSWUb5cJxA+ZfNk0U/Y5fe1nm8LtR7GELgBwV5KWeWASZaCvGlLdiMtbniPcK
         g+Kgn3UzZFJViFoBRU8X9ZiW/ayYnNMA9rhWhoDDsDWpbi0dHn1IFWBbxu2Gb/ovrX1Y
         N6n/HRWKijggSSDKXOfOAlUeSIvr/TOGD2EMpnnmx9bWsmXRHdpp6+hIAqumHzQkw2Ox
         Pf6QeP8Jk5EgWTtbm94Qq8reH0PNEWX0PjLiWG3xrGwrJcVSiGVYt3XbXzXGTuU+qA7Y
         +d8Q==
X-Gm-Message-State: APjAAAU9B1k0x9rgSbI2wapzUXNuRxjZP95Kn+dI73DHJObdHqewQOgu
        qCdWyg+B8/pHqu6t9cUqguuQhKg8WmFzgs3ZSV76
X-Google-Smtp-Source: APXvYqz0xh0QBYyY/zS/kJUsfUUaNRgWxOlmqjlpIVRroO/0xl0eD/u8MIKEBwL+baTN5sYIunTa2DIgnA074DTtHAM=
X-Received: by 2002:a0c:b12b:: with SMTP id q40mr71961348qvc.0.1564183221451;
 Fri, 26 Jul 2019 16:20:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190726224810.79660-1-henryburns@google.com>
In-Reply-To: <20190726224810.79660-1-henryburns@google.com>
From:   Jonathan Adams <jwadams@google.com>
Date:   Fri, 26 Jul 2019 16:19:45 -0700
Message-ID: <CA+VK+GM4AXrmZtv_narEU6pHO+NGrTc74iSSUNNbutZySfXjRw@mail.gmail.com>
Subject: Re: [PATCH] mm/z3fold.c: Fix z3fold_destroy_pool() ordering
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
> If there is work queued on pool->compact_workqueue when it is called,
> z3fold_destroy_pool() will do:
>
>    z3fold_destroy_pool()
>      destroy_workqueue(pool->release_wq)
>      destroy_workqueue(pool->compact_wq)
>        drain_workqueue(pool->compact_wq)
>          do_compact_page(zhdr)
>            kref_put(&zhdr->refcount)
>              __release_z3fold_page(zhdr, ...)
>                queue_work_on(pool->release_wq, &pool->work) *BOOM*
>
> So compact_wq needs to be destroyed before release_wq.
>
> Fixes: 5d03a6613957 ("mm/z3fold.c: use kref to prevent page free/compact race")
>
> Signed-off-by: Henry Burns <henryburns@google.com>

Reviewed-by: Jonathan Adams <jwadams@google.com>

> Cc: <stable@vger.kernel.org>
> ---
>  mm/z3fold.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/mm/z3fold.c b/mm/z3fold.c
> index 1a029a7432ee..43de92f52961 100644
> --- a/mm/z3fold.c
> +++ b/mm/z3fold.c
> @@ -818,8 +818,15 @@ static void z3fold_destroy_pool(struct z3fold_pool *pool)
>  {
>         kmem_cache_destroy(pool->c_handle);
>         z3fold_unregister_migration(pool);
> -       destroy_workqueue(pool->release_wq);
> +
> +       /*
> +        * We need to destroy pool->compact_wq before pool->release_wq,
> +        * as any pending work on pool->compact_wq will call
> +        * queue_work(pool->release_wq, &pool->work).
> +        */
> +
>         destroy_workqueue(pool->compact_wq);
> +       destroy_workqueue(pool->release_wq);
>         kfree(pool);
>  }
>
> --
> 2.22.0.709.g102302147b-goog
>

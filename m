Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221A3774B4
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 00:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfGZWxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 18:53:30 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:44671 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbfGZWxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 18:53:30 -0400
Received: by mail-yw1-f67.google.com with SMTP id l79so20841909ywe.11
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 15:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m8/4TDGoTP0YJOmmNh1QY5sjP7utSN3T4GKeg0uRKkI=;
        b=S58mOK6kmyfjaqk1fnTJ++/++kcxrVvJPN9KcacKz65Ijo+9nbPY62HM1CffSp86Gu
         /dPN5MfoF9x3qzmvRf4i/6AryZbuh86DENdsSJKo1zLveUuyHt3BmI5KngT42emGLpRg
         LfE5/fDELYjpJFgZ6/3aEWoIOYp7eIVl/VMYJO3P6dhqng+w41uZfFsmu2hMSxMur74E
         cjujptrMLPPTtmOt4Ya3Uv+rKDOFMywYfHOEFwqVFz7D2oHaFLDQNzYLJ324mImcBbId
         h3rDRv/vOKwwLN7nnncz9jasy9fPT3hIXPkkvg9QeXHJnJnt2ZVEQ6gEW6zaDfc0rSja
         EY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m8/4TDGoTP0YJOmmNh1QY5sjP7utSN3T4GKeg0uRKkI=;
        b=S59FGgrjYenoyXleCzGLfxnOO9fV5zWMFSx/QpCnwqIKnENhZ9I5V9zitcE/vorRiN
         mh+/siYbBTB4rsSCvvfStPkgSvClzleehwtuPxWVR35GqOeIYjqsM90buFrlAWjETgmb
         ecgEoExtoREbien494LjBb6bVmkCsY/IVyRfRLddXd6PoEMAqt2rHRhdzNJdL3PIxMfp
         OQtloml6QLFccIRkq0WGe9ats6phHNRa4PNneHFtw8/dgExVx5jTSi/tacjWrIgsCEK3
         IABY3FMGD9hBHAbq7TMXzvI4yhLePXjkZSIMAcJ/swLVZy/5Ge+Y49rTqn8BbN9OqG0e
         nBeA==
X-Gm-Message-State: APjAAAUQK47VKxqhci63lv0DCEd0PUEdZMU1JpqHdZT+0xnPOhSUIHeZ
        uOWluyH2l6/lXzEUL6+IZ6cACxNFKbh2eWSmcBxnwA==
X-Google-Smtp-Source: APXvYqzNhimbC8mzTJcKYV0Wi6pTpAOpfQ/Ahx7/RLFgCd5sUCIjXXqqjCww0QbPgslVApm1LWoPGyUTAhbML+xsfXs=
X-Received: by 2002:a81:19c6:: with SMTP id 189mr57026739ywz.296.1564181608700;
 Fri, 26 Jul 2019 15:53:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190726224810.79660-1-henryburns@google.com>
In-Reply-To: <20190726224810.79660-1-henryburns@google.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Fri, 26 Jul 2019 15:53:17 -0700
Message-ID: <CALvZod7Q_86F=aH6zP0TRFZ_6N5e2oFnjoSTPv=mcAdi0HEg3A@mail.gmail.com>
Subject: Re: [PATCH] mm/z3fold.c: Fix z3fold_destroy_pool() ordering
To:     Henry Burns <henryburns@google.com>
Cc:     Vitaly Vul <vitaly.vul@sony.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Adams <jwadams@google.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux MM <linux-mm@kvack.org>,
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

Reviewed-by: Shakeel Butt <shakeelb@google.com>

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

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9C3572188
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 19:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiGLREn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 13:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiGLREm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 13:04:42 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E32BE6A9
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 10:04:41 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id r9so6989748lfp.10
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 10:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xirVZQi4/Rn9raXFS5zkMYYSI5CRi816R1gYtGmE3bA=;
        b=tBQqShKbTvHXHbAYDzM+CNMmI6+l0tl34y69dUNTnG4xnkVbOPuAmTJm6kC4o5Op6G
         yXDAdwx9ktBFRxPJtrrpmpWqBAIbPu4w//Q2pV6X9fw98XZhflNgAj7RNjifKDz+DEqW
         3gM838M1I7N8aTMhjQ2RfxiRVBQ2ADaZP8Sod3ATbQaFU6fd1AvPp4fqUi3udTKaGqXi
         vTLu/CjtKem8i7zParwFU+XFA9b/uHC46owYIKuofX7ttxxCIrPEFQ9QH7VpvCHEJSZ8
         g1V8Vb6WgrzbVL9DhKKfWWZ4gTto3/f0JZWZUNl4wtdvWvP2Ee4H1krfosHO4VjUK9O3
         svyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xirVZQi4/Rn9raXFS5zkMYYSI5CRi816R1gYtGmE3bA=;
        b=hZxo4D10p140Z2RIlhqBNPkMU5l6oKKvUMvSZaZ5aNkamCskVkZ+Fp1bBdaEu970Qr
         i/j83Tc+fep3NmqcMllqFedodbwyn7HeAs8oL6xqDsobuz3V5IrxCYk11r8ZERLTo6TH
         DMYzTc5OtYlyDi1mJJrhCzQaH9hn752X0wEWpYam2MiqMJ9P44da/xDZok7GMtfTgwik
         cxVXTo0F54xyliOi/VieKxU4GY/wJTqQgvKgVFGX9lxl6Yt+TlbnnE36I52r1Wv6uH54
         Ud0Usz3aEj14Ksup1DNXgH4RfnvCGtjfSPPD3OiGOvarJ9Vr+CNflwcTnVVm+jwf0CFj
         SrOg==
X-Gm-Message-State: AJIora9m9McOVWsRVxWZcUVQZXTcSh9OsAJ2TGwCKYL5HkMgjpftiue3
        G69XUo6dDgJvm2EYQpXTH30AkNJySe7EmgraKC4ohw==
X-Google-Smtp-Source: AGRyM1uvtgdV9DafdzQ2FaV87vUIm0iyQ7ArP3pz0QYRjBDVcXqv9kbO0Et610aRRp5So1WDaIoP8Wm8YzeAvg855B8=
X-Received: by 2002:a05:6512:e88:b0:489:d187:9b3c with SMTP id
 bi8-20020a0565120e8800b00489d1879b3cmr9854310lfb.669.1657645480022; Tue, 12
 Jul 2022 10:04:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220711165906.2682-1-namit@vmware.com>
In-Reply-To: <20220711165906.2682-1-namit@vmware.com>
From:   James Houghton <jthoughton@google.com>
Date:   Tue, 12 Jul 2022 10:04:28 -0700
Message-ID: <CADrL8HV9dHK86z4LEkxMXmgb13PPLxWv+64NqFAE0tSj_t7F=w@mail.gmail.com>
Subject: Re: [PATCH] userfaultfd: provide properly masked address for huge-pages
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Nadav Amit <namit@vmware.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>, Jan Kara <jack@suse.cz>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 5:33 PM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> From: Nadav Amit <namit@vmware.com>
>
> Commit 824ddc601adc ("userfaultfd: provide unmasked address on
> page-fault") was introduced to fix an old bug, in which the offset in
> the address of a page-fault was masked. Concerns were raised - although
> were never backed by actual code - that some userspace code might break
> because the bug has been around for quite a while. To address these
> concerns a new flag was introduced, and only when this flag is set by
> the user, userfaultfd provides the exact address of the page-fault.
>
> The commit however had a bug, and if the flag is unset, the offset was
> always masked based on a base-page granularity. Yet, for huge-pages, the
> behavior prior to the commit was that the address is masked to the
> huge-page granulrity.
>
> While there are no reports on real breakage, fix this issue. If the flag
> is unset, use the address with the masking that was done before.
>
> Fixes: 824ddc601adc ("userfaultfd: provide unmasked address on page-fault")
> Reported-by: James Houghton <jthoughton@google.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Nadav Amit <namit@vmware.com>

Reviewed-by: James Houghton <jthoughton@google.com>

Thanks!

> ---
>  fs/userfaultfd.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index e943370107d0..de86f5b2859f 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -192,17 +192,19 @@ static inline void msg_init(struct uffd_msg *msg)
>  }
>
>  static inline struct uffd_msg userfault_msg(unsigned long address,
> +                                           unsigned long real_address,
>                                             unsigned int flags,
>                                             unsigned long reason,
>                                             unsigned int features)
>  {
>         struct uffd_msg msg;
> +
>         msg_init(&msg);
>         msg.event = UFFD_EVENT_PAGEFAULT;
>
> -       if (!(features & UFFD_FEATURE_EXACT_ADDRESS))
> -               address &= PAGE_MASK;
> -       msg.arg.pagefault.address = address;
> +       msg.arg.pagefault.address = (features & UFFD_FEATURE_EXACT_ADDRESS) ?
> +                                   real_address : address;
> +
>         /*
>          * These flags indicate why the userfault occurred:
>          * - UFFD_PAGEFAULT_FLAG_WP indicates a write protect fault.
> @@ -488,8 +490,8 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
>
>         init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
>         uwq.wq.private = current;
> -       uwq.msg = userfault_msg(vmf->real_address, vmf->flags, reason,
> -                       ctx->features);
> +       uwq.msg = userfault_msg(vmf->address, vmf->real_address, vmf->flags,
> +                               reason, ctx->features);
>         uwq.ctx = ctx;
>         uwq.waken = false;
>
> --
> 2.25.1
>

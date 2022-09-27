Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E225EBD9D
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 10:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiI0IlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 04:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiI0IlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 04:41:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD2F58B62;
        Tue, 27 Sep 2022 01:41:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AA3D61725;
        Tue, 27 Sep 2022 08:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0F0C433C1;
        Tue, 27 Sep 2022 08:41:06 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="U2RFQizA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664268064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IV/Em9oY+NQiUPjmtckttX54KTlCyU8xGN0JLMqvDIc=;
        b=U2RFQizAC2uVi7PeJpBOJhVm8sonI94kcMjpmIb7C+lbxJFAWil0g+O/A0FycoIKy0lXtM
        6tGzi54hJvOMspzhR1YjM3/RFjGIOff6q+8UwTD3o5ErqUraiYhx26mwfv8NWoCEBDBca1
        lXLtqDS1rHPcULbQg37rDsMricNl+lw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2a250998 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 27 Sep 2022 08:41:04 +0000 (UTC)
Received: by mail-ua1-f44.google.com with SMTP id b7so3314326uas.2;
        Tue, 27 Sep 2022 01:41:04 -0700 (PDT)
X-Gm-Message-State: ACrzQf1FGwfMhMpu43EGPvGPV6mYxIKl4Gye+3CWgi+0ChW7DyIdeBmW
        7o+3OK8m64SzASfUdBkuSdXaU023FH0MEh4Wz9Y=
X-Google-Smtp-Source: AMsMyM4Y7JRr9Bp3JZsLnSgTZEfxIosiNasa58p2BBabUeLL6/OJszW06By24Gtt3fxOa/Q+yiVFeaS0jpV5tLXPSBo=
X-Received: by 2002:a9f:3562:0:b0:3d0:ad99:b875 with SMTP id
 o89-20020a9f3562000000b003d0ad99b875mr1217071uao.102.1664268062673; Tue, 27
 Sep 2022 01:41:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220926213130.1508261-1-Jason@zx2c4.com> <YzKZnkwCi0UwY/4Q@owl.dominikbrodowski.net>
 <CAHmME9oGkjAxvoBvWMBRSjFmKLzOdzfcQAB4q3P869BsySSfNg@mail.gmail.com> <YzK0ntZJvMzFzui0@owl.dominikbrodowski.net>
In-Reply-To: <YzK0ntZJvMzFzui0@owl.dominikbrodowski.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 27 Sep 2022 10:40:51 +0200
X-Gmail-Original-Message-ID: <CAHmME9q3w1XHyS5QpyW79xK9xjnZmzyBr-Pk3QOsp=mJ_Loauw@mail.gmail.com>
Message-ID: <CAHmME9q3w1XHyS5QpyW79xK9xjnZmzyBr-Pk3QOsp=mJ_Loauw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] random: split initialization into early step and
 later step
To:     Dominik Brodowski <linux@dominikbrodowski.net>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kasan-dev@googlegroups.com, Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 27, 2022 at 10:30 AM Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
>
> Am Tue, Sep 27, 2022 at 10:28:11AM +0200 schrieb Jason A. Donenfeld:
> > On Tue, Sep 27, 2022 at 8:35 AM Dominik Brodowski
> > <linux@dominikbrodowski.net> wrote:
> > > >  #if defined(LATENT_ENTROPY_PLUGIN)
> > > >       static const u8 compiletime_seed[BLAKE2S_BLOCK_SIZE] __initconst __latent_entropy;
> > > > @@ -803,34 +798,46 @@ int __init random_init(const char *command_line)
> > > >                       i += longs;
> > > >                       continue;
> > > >               }
> > > > -             entropy[0] = random_get_entropy();
> > > > -             _mix_pool_bytes(entropy, sizeof(*entropy));
> > > >               arch_bits -= sizeof(*entropy) * 8;
> > > >               ++i;
> > > >       }
> > >
> > >
> > > Previously, random_get_entropy() was mixed into the pool ARRAY_SIZE(entropy)
> > > times.
> > >
> > > > +/*
> > > > + * This is called a little bit after the prior function, and now there is
> > > > + * access to timestamps counters. Interrupts are not yet enabled.
> > > > + */
> > > > +void __init random_init(void)
> > > > +{
> > > > +     unsigned long entropy = random_get_entropy();
> > > > +     ktime_t now = ktime_get_real();
> > > > +
> > > > +     _mix_pool_bytes(utsname(), sizeof(*(utsname())));
> > >
> > > But now, it's only mixed into the pool once. Is this change on purpose?
> >
> > Yea, it is. I don't think it's really doing much of use. Before we did
> > it because it was convenient -- because we simply could. But in
> > reality mostly what we care about is capturing when it gets to that
> > point in the execution. For jitter, the actual jitter function
> > (try_to_generate_entropy()) is better here.
> >
> > However, before feeling too sad about it, remember that
> > extract_entropy() is still filling a block with rdtsc when rdrand
> > fails, the same way as this function was. So it's still in there
> > anyway.
>
> With that explanation on the record (I think it's important to make such
> subtle changes explicit),
>
>         Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>

I'll augment the commit message to note this too. Thanks for the review.

Jason

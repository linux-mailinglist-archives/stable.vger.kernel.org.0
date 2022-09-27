Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3895EBD50
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 10:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiI0Ib3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 04:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiI0IbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 04:31:02 -0400
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1486D38465;
        Tue, 27 Sep 2022 01:30:41 -0700 (PDT)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id 38C19201335;
        Tue, 27 Sep 2022 08:30:39 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id 8A4968052E; Tue, 27 Sep 2022 10:30:22 +0200 (CEST)
Date:   Tue, 27 Sep 2022 10:30:22 +0200
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kasan-dev@googlegroups.com, Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] random: split initialization into early step and
 later step
Message-ID: <YzK0ntZJvMzFzui0@owl.dominikbrodowski.net>
References: <20220926213130.1508261-1-Jason@zx2c4.com>
 <YzKZnkwCi0UwY/4Q@owl.dominikbrodowski.net>
 <CAHmME9oGkjAxvoBvWMBRSjFmKLzOdzfcQAB4q3P869BsySSfNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9oGkjAxvoBvWMBRSjFmKLzOdzfcQAB4q3P869BsySSfNg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Tue, Sep 27, 2022 at 10:28:11AM +0200 schrieb Jason A. Donenfeld:
> On Tue, Sep 27, 2022 at 8:35 AM Dominik Brodowski
> <linux@dominikbrodowski.net> wrote:
> > >  #if defined(LATENT_ENTROPY_PLUGIN)
> > >       static const u8 compiletime_seed[BLAKE2S_BLOCK_SIZE] __initconst __latent_entropy;
> > > @@ -803,34 +798,46 @@ int __init random_init(const char *command_line)
> > >                       i += longs;
> > >                       continue;
> > >               }
> > > -             entropy[0] = random_get_entropy();
> > > -             _mix_pool_bytes(entropy, sizeof(*entropy));
> > >               arch_bits -= sizeof(*entropy) * 8;
> > >               ++i;
> > >       }
> >
> >
> > Previously, random_get_entropy() was mixed into the pool ARRAY_SIZE(entropy)
> > times.
> >
> > > +/*
> > > + * This is called a little bit after the prior function, and now there is
> > > + * access to timestamps counters. Interrupts are not yet enabled.
> > > + */
> > > +void __init random_init(void)
> > > +{
> > > +     unsigned long entropy = random_get_entropy();
> > > +     ktime_t now = ktime_get_real();
> > > +
> > > +     _mix_pool_bytes(utsname(), sizeof(*(utsname())));
> >
> > But now, it's only mixed into the pool once. Is this change on purpose?
> 
> Yea, it is. I don't think it's really doing much of use. Before we did
> it because it was convenient -- because we simply could. But in
> reality mostly what we care about is capturing when it gets to that
> point in the execution. For jitter, the actual jitter function
> (try_to_generate_entropy()) is better here.
> 
> However, before feeling too sad about it, remember that
> extract_entropy() is still filling a block with rdtsc when rdrand
> fails, the same way as this function was. So it's still in there
> anyway.

With that explanation on the record (I think it's important to make such
subtle changes explicit),

	Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>

Thanks,
	Dominik

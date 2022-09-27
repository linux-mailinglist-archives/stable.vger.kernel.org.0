Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4461B5EBD3B
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 10:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiI0I2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 04:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbiI0I2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 04:28:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C524B07FC;
        Tue, 27 Sep 2022 01:28:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01E35B81A3C;
        Tue, 27 Sep 2022 08:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C852C433D7;
        Tue, 27 Sep 2022 08:28:26 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Q4YS52KU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664267304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gF2B0EX39catiZugICdowKOfDfyx3TjUROolfQVqhqI=;
        b=Q4YS52KUu5BTFy2/9feSQ0tXR2kzgs2Z///o6YVaxJeW9gKooHCd30CLHGPwQcmNKAAmZJ
        I3xDj6yFp/COv/CvZbeSkFlJMHkZeXSgNUrAeu3P25akAz8lzIKIiyR8K5f98qSgf/mF/R
        +pZlIGj5629qBBX1COF5dhqN2eEQSSs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c51ab9de (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 27 Sep 2022 08:28:23 +0000 (UTC)
Received: by mail-vs1-f54.google.com with SMTP id p4so8953522vsa.9;
        Tue, 27 Sep 2022 01:28:23 -0700 (PDT)
X-Gm-Message-State: ACrzQf3Bhcp8KjMLL1p1KTx/lvHJtgj7+CmqN723cEaLDOZrDbPB5+WH
        i8GO+KQPz+ij7jpjhOnk1fAceUbfaeYvgm6lhZM=
X-Google-Smtp-Source: AMsMyM6X2DSr6gttEtduc86QXGelPE6LLKNPgVbMAN95bkgM5yITN8MEKy/4Iw4i/OTaE7jkF9BrcUcaw1srErYF8T0=
X-Received: by 2002:a67:c289:0:b0:398:cdc:c3ef with SMTP id
 k9-20020a67c289000000b003980cdcc3efmr11024734vsj.76.1664267302601; Tue, 27
 Sep 2022 01:28:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220926213130.1508261-1-Jason@zx2c4.com> <YzKZnkwCi0UwY/4Q@owl.dominikbrodowski.net>
In-Reply-To: <YzKZnkwCi0UwY/4Q@owl.dominikbrodowski.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 27 Sep 2022 10:28:11 +0200
X-Gmail-Original-Message-ID: <CAHmME9oGkjAxvoBvWMBRSjFmKLzOdzfcQAB4q3P869BsySSfNg@mail.gmail.com>
Message-ID: <CAHmME9oGkjAxvoBvWMBRSjFmKLzOdzfcQAB4q3P869BsySSfNg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] random: split initialization into early step and
 later step
To:     linux@dominikbrodowski.net
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

On Tue, Sep 27, 2022 at 8:35 AM Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
> >  #if defined(LATENT_ENTROPY_PLUGIN)
> >       static const u8 compiletime_seed[BLAKE2S_BLOCK_SIZE] __initconst __latent_entropy;
> > @@ -803,34 +798,46 @@ int __init random_init(const char *command_line)
> >                       i += longs;
> >                       continue;
> >               }
> > -             entropy[0] = random_get_entropy();
> > -             _mix_pool_bytes(entropy, sizeof(*entropy));
> >               arch_bits -= sizeof(*entropy) * 8;
> >               ++i;
> >       }
>
>
> Previously, random_get_entropy() was mixed into the pool ARRAY_SIZE(entropy)
> times.
>
> > +/*
> > + * This is called a little bit after the prior function, and now there is
> > + * access to timestamps counters. Interrupts are not yet enabled.
> > + */
> > +void __init random_init(void)
> > +{
> > +     unsigned long entropy = random_get_entropy();
> > +     ktime_t now = ktime_get_real();
> > +
> > +     _mix_pool_bytes(utsname(), sizeof(*(utsname())));
>
> But now, it's only mixed into the pool once. Is this change on purpose?

Yea, it is. I don't think it's really doing much of use. Before we did
it because it was convenient -- because we simply could. But in
reality mostly what we care about is capturing when it gets to that
point in the execution. For jitter, the actual jitter function
(try_to_generate_entropy()) is better here.

However, before feeling too sad about it, remember that
extract_entropy() is still filling a block with rdtsc when rdrand
fails, the same way as this function was. So it's still in there
anyway.

Jason

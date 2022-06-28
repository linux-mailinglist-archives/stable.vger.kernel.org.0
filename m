Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0208B55D8AE
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237120AbiF1K4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 06:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbiF1K4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 06:56:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E5F31DC0;
        Tue, 28 Jun 2022 03:56:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2084D6172D;
        Tue, 28 Jun 2022 10:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEDDC341CA;
        Tue, 28 Jun 2022 10:56:13 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DZ4i0nqt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656413770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vK9AHD5OsxUNDkkwqCV5llgm1F9isE9MtKI9yy29+5M=;
        b=DZ4i0nqtGDy3D3eNEtBOkOITJm2P60GTinJ3J43dv/ToqFx8EqrNqGwKSRwWbt4Rz/X/Em
        QgxyyLjX6FiHV1eRVGtPiPXsKT4qbws4f3jLxIV1DJ+f2ZgCK8txp/tOZ2WQ1+TeXVnvm8
        UTGX0QHeTfT29sVEcfD7wDYIIfIfTP8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 241a822b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 28 Jun 2022 10:56:10 +0000 (UTC)
Received: by mail-io1-f48.google.com with SMTP id a10so12417351ioe.9;
        Tue, 28 Jun 2022 03:56:09 -0700 (PDT)
X-Gm-Message-State: AJIora9gDcTSzrWqICFpZ2cuznhZPHQLDOW+NaVcE7RR7Y7T8rgHHjU8
        cdfsnLN+uauUc6pOhnzJ1eBUPXrFequTBamgWqQ=
X-Google-Smtp-Source: AGRyM1t1lmY6/wZwNnHsBU7eO6ZSHnyC2xKUI1N/qkeGSZu6YPuMt2fPDxGqx/QQBe7oXrTCXeuktwWPo+DE6JnMShQ=
X-Received: by 2002:a02:8568:0:b0:339:c51c:867 with SMTP id
 g95-20020a028568000000b00339c51c0867mr10752625jai.170.1656413768767; Tue, 28
 Jun 2022 03:56:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220627113749.564132-1-Jason@zx2c4.com> <20220627120735.611821-1-Jason@zx2c4.com>
 <87y1xib8pv.fsf@toke.dk> <CAO+Okf5r-rVVqwYiCHXEt_jh0StmVoUikqYfSn7y3QpGZMR3Vg@mail.gmail.com>
 <CAHmME9o4m5MNvDtQUc3OiYLVzNgk3u2i0EF4NhNV4uifZZLJ3g@mail.gmail.com>
 <CAHmME9prgW60P+CO1JSdf5o1hBh8JtciBxcYm25ZO6oTCkwkxg@mail.gmail.com> <YrrdTcRCKBt15HLz@gondor.apana.org.au>
In-Reply-To: <YrrdTcRCKBt15HLz@gondor.apana.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 28 Jun 2022 12:55:57 +0200
X-Gmail-Original-Message-ID: <CAHmME9qm49R6i8Y9LpQXPuxEoTZx2nFSizxX-VEH6UDfLEji1g@mail.gmail.com>
Message-ID: <CAHmME9qm49R6i8Y9LpQXPuxEoTZx2nFSizxX-VEH6UDfLEji1g@mail.gmail.com>
Subject: Re: [PATCH v6] ath9k: sleep for less time when unregistering hwrng
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Gregory Erwin <gregerwin256@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Herbert,

On Tue, Jun 28, 2022 at 12:52 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Jun 28, 2022 at 12:48:50PM +0200, Jason A. Donenfeld wrote:
> >
> > $ curl https://lore.kernel.org/lkml/20220627104955.534013-1-Jason@zx2c4.com/raw
> > | git am
> >
> > That one, if you want to give it a spin and see if that 5-6s is back
> > to ~1s or less.
>
> Whatever caused kthread_should_stop to return true should have
> woken the thread and caused schedule_timeout to return.
>
> If it's not waking the thread up then we should find out why.
>
> Oh wait you're checking kthread_should_stop before the schedule
> call instead of afterwards, that would do it.

Oh, that's a really good observation, thank you! I'll send a patch
that does it right. I have to check kthread_should_stop() before,
because the wake up might have been consumed by a sleep inside of the
hwrng ->read_data() function, causing it to return early. So we have
to check it before going to sleep again. And after, I need to be
checking the return value of schedule_timeout_interruptible(), which
I'm not in this latest. So v+1 coming up.

By the way, this thread might interest you:
https://lore.kernel.org/lkml/20220627145716.641185-1-Jason@zx2c4.com/

Jason

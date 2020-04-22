Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141121B454C
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 14:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgDVMmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 08:42:20 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:44858 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgDVMmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 08:42:19 -0400
Received: by mail-ot1-f65.google.com with SMTP id j4so1828559otr.11
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 05:42:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+1M0NVjVIfiDf5WxyWqgdJi0Ejne9DtjuFiuDolawXg=;
        b=bg5WE0IC/OU44ImHQioBXVfHSA4VscKN0wS6Cg+S/tUjVO8Plo/RFnto8ByTHZWXkX
         14N483kk1opbDo1gQSeQedmTGTkcbn+qtquAT6KzMrgk5vEq65Yshe6b9v7Zm8CCTOsm
         ltRnFqi0wVSyOhuaG+oGHr0Tjs/9pgJYr1beuMw2pxstoKMjUIC6WyhiJN1u+iDKhHG2
         cQKFJrGD/ptfmhxH65T3ZZl1w994QbRy2zbiVhm4oikd+P9cA9u7QAL5kt78h2lQV+pr
         HsevLuCZEcbvdUxEX+jdva+pXfJNKu4eB7PV1OMg+f5ER+xp9qCoS2aFQk/QsOvOlYld
         qgWA==
X-Gm-Message-State: AGi0PuYg42U+b9GQKBgygT1MnbDbnTcsf653N+voOAT25xRpDTYqQaEh
        cTj0G4U8IIqudBmvcYi7NCV8VXOZ6jkU3NsVZJs=
X-Google-Smtp-Source: APiQypKXVAqidqoIdJ8o9BvLpLjmaZMSWD0KW6YTulWW9ox+6sa/rlKruxqpj6YMg0E2J7vnv8VTFirWlN1vHXiyvck=
X-Received: by 2002:a9d:564:: with SMTP id 91mr452774otw.250.1587559338565;
 Wed, 22 Apr 2020 05:42:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200422111957.569589-1-lee.jones@linaro.org> <20200422111957.569589-5-lee.jones@linaro.org>
 <d4b3dc8228014f29b9449bcff6e61315@AcuMS.aculab.com>
In-Reply-To: <d4b3dc8228014f29b9449bcff6e61315@AcuMS.aculab.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 22 Apr 2020 14:42:07 +0200
Message-ID: <CAMuHMdUX8FojWFgK7EE0bm1ifNhr6iqno_k=VkJuQicWGheHYw@mail.gmail.com>
Subject: Re: [PATCH 4.9 04/21] devres: Align data[] to ARCH_KMALLOC_MINALIGN
To:     David Laight <David.Laight@aculab.com>
Cc:     Lee Jones <lee.jones@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alexey Brodkin <alexey.brodkin@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>,
        Will Deacon <will.deacon@arm.com>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi David,

On Wed, Apr 22, 2020 at 2:17 PM David Laight <David.Laight@aculab.com> wrote:
> From: Lee Jones <lee.jones@linaro.org>
> > Sent: 22 April 2020 12:20
> > From: Alexey Brodkin <alexey.brodkin@synopsys.com>
> >
> > [ Upstream commit a66d972465d15b1d89281258805eb8b47d66bd36 ]
> >
> > Initially we bumped into problem with 32-bit aligned atomic64_t
> > on ARC, see [1]. And then during quite lengthly discussion Peter Z.
> > mentioned ARCH_KMALLOC_MINALIGN which IMHO makes perfect sense.
> > If allocation is done by plain kmalloc() obtained buffer will be
> > ARCH_KMALLOC_MINALIGN aligned and then why buffer obtained via
> > devm_kmalloc() should have any other alignment?
> >
> > This way we at least get the same behavior for both types of
> > allocation.
>
> Anyone any idea how much difference it would actually make
> to align all architectures to at least 32-bits (or even 64-bits)?
>
> I think the only times it would make a difference would be for
> allocations that (for example, 62 bytes on m68k) just
> fit in a 64 byte block - so suddenly grow to 128 bytes.
> (Or whatever granularity the allocator uses).

I believe ARCH_KMALLOC_MINALIGN is already at least 16 _bytes_
on all architectures (up to at last 128, perhaps even 256?).

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

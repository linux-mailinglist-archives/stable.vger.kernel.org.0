Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36F24FB672
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 10:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241273AbiDKI4H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 11 Apr 2022 04:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240222AbiDKI4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 04:56:06 -0400
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6558D3EAB6;
        Mon, 11 Apr 2022 01:53:53 -0700 (PDT)
Received: by mail-qk1-f171.google.com with SMTP id 75so7242547qkk.8;
        Mon, 11 Apr 2022 01:53:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rPZ/wvLlErvlmCophlU8VgOKZ6EBQYYUESc80mCcO8Y=;
        b=WKQuIfRV4eKMiShrepznzCmzjrpBfTiQDksBx8noyr9MIdkktDKOZAajjvK1bwdorH
         zdmu0MJhmphZv9BUJgyfvTX42+7uNj9BCdmSG7pqLygEuWhZzGPt7cXWB7n/swVs0AkU
         o9/vV8+kvwkgWLyDwHW3E2ceE5rcYHF6aWseIZIOKdqgurfvzLa0IkFCJz2xnT0pzEYL
         7G9RWlWgQUse55/zodxcExGJhnC9fVblMl25u9O0rDiwRNh6IGaAV/+o4j7QIG9oVNkM
         FIRJXva/LjONLk/o5lmDfal1BEkXSczoHqD7G5/M/59PaG5jkNdet6dplH0DGqmQaPuc
         kH8g==
X-Gm-Message-State: AOAM531ws1zUpzA9UGbgzY0UAVrqTTp2FxA129OMTtMozoUDeH4TOXUu
        B+BaSRJ7ELzoiN/ZFzXYxr5JGwHJCMf7/A==
X-Google-Smtp-Source: ABdhPJyei55FF+NH/zkzl6endo+Q6+02jO8FYqS7UpSAKFPNUoJIqE9TdpCqTkm14tO5P9JpS4vOsw==
X-Received: by 2002:a37:ac12:0:b0:69c:e9e:8c02 with SMTP id e18-20020a37ac12000000b0069c0e9e8c02mr4554437qkm.603.1649667232208;
        Mon, 11 Apr 2022 01:53:52 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id p13-20020a05622a048d00b002e1ce0c627csm25663550qtx.58.2022.04.11.01.53.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 01:53:51 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id k36so4538270ybj.11;
        Mon, 11 Apr 2022 01:53:51 -0700 (PDT)
X-Received: by 2002:a25:9e89:0:b0:63c:ad37:a5de with SMTP id
 p9-20020a259e89000000b0063cad37a5demr21296668ybq.342.1649667231109; Mon, 11
 Apr 2022 01:53:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220406201523.243733-1-laurent@vivier.eu> <20220406201523.243733-2-laurent@vivier.eu>
 <Yk5tNOPE4b2QbHLG@kroah.com> <198be9ea-a8c2-0f9e-6ae5-a7358035def4@vivier.eu> <Yk6CO11wyo86ylee@kroah.com>
In-Reply-To: <Yk6CO11wyo86ylee@kroah.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 11 Apr 2022 10:53:39 +0200
X-Gmail-Original-Message-ID: <CAMuHMdW=-nnKSLRZbHGkQQ8zEBxjQ4T1XXyTfv5-fM-h-+fQQA@mail.gmail.com>
Message-ID: <CAMuHMdW=-nnKSLRZbHGkQQ8zEBxjQ4T1XXyTfv5-fM-h-+fQQA@mail.gmail.com>
Subject: Re: [PATCH v16 1/4] tty: goldfish: introduce gf_ioread32()/gf_iowrite32()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Laurent Vivier <laurent@vivier.eu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-rtc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Apr 7, 2022 at 8:18 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Apr 07, 2022 at 08:00:08AM +0200, Laurent Vivier wrote:
> > Le 07/04/2022 à 06:48, Greg KH a écrit :
> > > On Wed, Apr 06, 2022 at 10:15:20PM +0200, Laurent Vivier wrote:
> > > > Revert
> > > > commit da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
> > > >
> > > > and define gf_ioread32()/gf_iowrite32() to be able to use accessors
> > > > defined by the architecture.
> > > >
> > > > Cc: stable@vger.kernel.org # v5.11+
> > > > Fixes: da31de35cd2f ("tty: goldfish: use __raw_writel()/__raw_readl()")
> > > > Signed-off-by: Laurent Vivier <laurent@vivier.eu>
> > > > Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > > > ---
> > > >   drivers/tty/goldfish.c   | 20 ++++++++++----------
> > > >   include/linux/goldfish.h | 15 +++++++++++----
> > > >   2 files changed, 21 insertions(+), 14 deletions(-)
> > > >
> > >
> > > Why is this a commit for the stable trees?  What bug does it fix?  You
> > > did not describe the problem in the changelog text at all, this looks
> > > like a housekeeping change only.
> >
> > Arnd asked for that in:
> >
> >   Re: [PATCH v11 2/5] tty: goldfish: introduce gf_ioread32()/gf_iowrite32()
> >   https://lore.kernel.org/lkml/CAK8P3a1oN8NrUjkh2X8jHQbyz42Xo6GSa=5n0gD6vQcXRjmq1Q@mail.gmail.com/
>
> You did not provide a reason in this changelog to explain any of that :(

OK if I queue that patch with the rationale from Arnd's email added
to the patch description?

This series has been dragging out for way too long...

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

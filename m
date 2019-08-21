Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B24C7977E9
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 13:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfHUL23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 07:28:29 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34807 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfHUL23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 07:28:29 -0400
Received: by mail-ot1-f65.google.com with SMTP id c7so1718510otp.1;
        Wed, 21 Aug 2019 04:28:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TuaZG7Omor+G/AkU6ujx9Ln8/VDzjqK3KDTH0UUDhuU=;
        b=PinaZKHD4MuwCZgZ4BVknOphxjy2VBVHAwQZfD0PhJmnMkEmRfVl/TjzA0xTDT9aCH
         6GGI2TEp9EFtbLlxMcCbQAkVlHVdEwtPztJZSSniTXbvqjbXWz8xWg5Hjpg7MHjz78ma
         VYZ5oXNXq8vRgpnlwDpJtHClnnuOuFtYBeASegTLX3ra86Fbv9LNUrlGlPNNIlwQsee8
         FZ+AYOi/1flfvsTqdHWmhhfsVCcTuIPFQSFMjmIRVWstrEAMIeum8dmpHkqZ11UBKnyH
         oRUl5m+n0EeYNzkYbdEkvd2ydwYe4tA3Q9DeJv04XrdCDaCZQrniGgDAVMju9ymxEcD1
         Ksbw==
X-Gm-Message-State: APjAAAVbdjYAIFF6v6oVUB7XIamb/A9lhBSQ/cFnus7gAs1cHzd7lA4w
        6z27WBxi0Kk5MqoWwXrx6Yrqu9Bapa5oh5alYlI=
X-Google-Smtp-Source: APXvYqzVn6iwJJMy6xFU1GI7NKYrOHxrMHDdMw9ASzfZioKrVpu3RDiY5PRKEzuvDoneJw6SALvZzP5Pr3jReVY2v8w=
X-Received: by 2002:a9d:68c5:: with SMTP id i5mr3012150oto.250.1566386908109;
 Wed, 21 Aug 2019 04:28:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190805155515.22621-1-jacopo+renesas@jmondi.org> <20190805181244.663585ac@archlinux>
In-Reply-To: <20190805181244.663585ac@archlinux>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 21 Aug 2019 13:28:16 +0200
Message-ID: <CAMuHMdVT--S48M+BHTOH5SDi7AG=asOdNWH_UyM5nygZjWLmdg@mail.gmail.com>
Subject: Re: [PATCH] iio: adc: max9611: Fix temperature reading in probe
To:     Jonathan Cameron <jic23@kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Stefan Agner <stefan@agner.ch>, linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jonathan, Jacopo,

On Mon, Aug 5, 2019 at 7:15 PM Jonathan Cameron <jic23@kernel.org> wrote:
> On Mon,  5 Aug 2019 17:55:15 +0200
> Jacopo Mondi <jacopo+renesas@jmondi.org> wrote:
>
> > The max9611 driver reads the die temperature at probe time to validate
> > the communication channel. Use the actual read value to perform the test
> > instead of the read function return value, which was mistakenly used so
> > far.
> >
> > The temperature reading test was only successful because the 0 return
> > value is in the range of supported temperatures.
> >
> > Fixes: 69780a3bbc0b ("iio: adc: Add Maxim max9611 ADC driver")
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>
> Applied to the fixes-togreg branch of iio.git and marked for
> stable.  That'll be a bit fiddly given other changes around this
> so we may need to do backports.

This is now commit b9ddd5091160793e ("iio: adc: max9611: Fix temperature
reading in probe") in v5.3-rc5, and has been backported to 4.14, 4.19,
and 5.2.

> > --- a/drivers/iio/adc/max9611.c
> > +++ b/drivers/iio/adc/max9611.c
> > @@ -480,7 +480,7 @@ static int max9611_init(struct max9611_dev *max9611)
> >       if (ret)
> >               return ret;
> >
> > -     regval = ret & MAX9611_TEMP_MASK;
> > +     regval &= MAX9611_TEMP_MASK;
> >
> >       if ((regval > MAX9611_TEMP_MAX_POS &&
> >            regval < MAX9611_TEMP_MIN_NEG) ||

While this did fix a bug, it also introduced a regression: on Salvator-XS,
which has two max9611 instances, I now see intermittent failures

    max9611 4-007c: Invalid value received from ADC 0x8000: aborting
    max9611: probe of 4-007c failed with error -5

and/or

    max9611 4-007f: Invalid value received from ADC 0x8000: aborting
    max9611: probe of 4-007f failed with error -5

during boot.

Retrying on failure fixes the issue, e.g.:

    max9611_init:483: regval = 0x8000
    max9611 4-007f: Invalid value received from ADC 0x8000: aborting
    max9611_init:483: regval = 0x2780

According to the datasheet, 0x8000 is the Power-On Reset value.
Looks like it should be ignored, and retried?

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

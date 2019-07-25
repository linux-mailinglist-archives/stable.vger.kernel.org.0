Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4D075ACF
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 00:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfGYWnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 18:43:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbfGYWnH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 18:43:07 -0400
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E8BB22BF5;
        Thu, 25 Jul 2019 22:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564094585;
        bh=lBESfuT3DmI+rgGQfA5Bgd1cqeRkqGQxNUSPLRT7J/w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Nv80oMNgEN71r3/BbqLh/q7zx+mZrVMhluqgvK4uigmTgyG2Qrpej99va5ARTRYqz
         hNJlcDNZ5zVI3+fa4g9d0ZUUDegPlf28mUu6+eCDC/czkZ0H05t/GEVU1VfhMYABRd
         1/+T5bnkyHC2A6g6LO4gPGxap4XYNjcZRILpeRwo=
Received: by mail-qt1-f180.google.com with SMTP id z4so50787195qtc.3;
        Thu, 25 Jul 2019 15:43:05 -0700 (PDT)
X-Gm-Message-State: APjAAAX3lNwfuIZomWaUDY6UePS9LWFNB8ZwsoP68vLsCDLHse9OPlIg
        q/gviR489Nggv9+Uu89u1gtUHUPhZN4ilTLH6Q==
X-Google-Smtp-Source: APXvYqxdeWh9cmjbYBWJqGtuD2MR1ApRKd+If++ai9lKP0uWwFcRMyo2Qs/i7JSDX0ekJFmk7Df2ahT9V7pGKFBaufs=
X-Received: by 2002:a0c:b627:: with SMTP id f39mr66634624qve.72.1564094584748;
 Thu, 25 Jul 2019 15:43:04 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1562597164.git.hns@goldelico.com> <8ae7cf816b22ef9cecee0d789fcf9e8a06495c39.1562597164.git.hns@goldelico.com>
 <20190724194259.GA25847@bogus> <2EA06398-E45B-481B-9A26-4DD2E043BF9C@goldelico.com>
In-Reply-To: <2EA06398-E45B-481B-9A26-4DD2E043BF9C@goldelico.com>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 25 Jul 2019 16:42:53 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLe_Y9Z6MRt7ojgSVKAb9n95S8j=eGidSVNz2T83j-zPQ@mail.gmail.com>
Message-ID: <CAL_JsqLe_Y9Z6MRt7ojgSVKAb9n95S8j=eGidSVNz2T83j-zPQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] DTS: ARM: gta04: introduce legacy spi-cs-high to make
 display work again
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 12:23 AM H. Nikolaus Schaller <hns@goldelico.com> wrote:
>
> Hi Rob,
>
> > Am 24.07.2019 um 21:42 schrieb Rob Herring <robh@kernel.org>:
> >
> > On Mon, Jul 08, 2019 at 04:46:05PM +0200, H. Nikolaus Schaller wrote:
> >> commit 6953c57ab172 "gpio: of: Handle SPI chipselect legacy bindings"
> >>
> >> did introduce logic to centrally handle the legacy spi-cs-high property
> >> in combination with cs-gpios. This assumes that the polarity
> >> of the CS has to be inverted if spi-cs-high is missing, even
> >> and especially if non-legacy GPIO_ACTIVE_HIGH is specified.
> >>
> >> The DTS for the GTA04 was orginally introduced under the assumption
> >> that there is no need for spi-cs-high if the gpio is defined with
> >> proper polarity GPIO_ACTIVE_HIGH.
> >
> > Given that spi-cs-high is called legacy, that would imply that DT's
> > should not have to use spi-cs-high.
>
> Yes.
>
> >
> >> This was not a problem until gpiolib changed the interpretation of
> >> GPIO_ACTIVE_HIGH and missing spi-cs-high.
> >
> > Then we should fix gpiolib...
>
> I tried to convince Linus that this is the right way but he convinced
> me that a fix that handles all cases does not exist.
>
> There seem to be embedded devices with older DTB (potentially in ROM)
> which provide a plain 0 value for a gpios definition. And either with
> or without spi-cs-high.
>
> Since "0" is the same as "GPIO_ACTIVE_HIGH", the absence of
> spi-cs-high was and must be interpreted as active low for these
> devices. This leads to the inversion logic in code.
>
> AFAIR it boils down to the question if gpiolib and the bindings
> should still support such legacy devices with out-of tree DTB,
> but force in-tree DTS to add the legacy spi-cs-high property.
>
> Or if we should fix the 2 or 3 cases of in-tree legacy cases
> and potentially break out-of tree DTBs.

If it is small number of platforms, then the kernel could handle those
cases explicitly as needed.

> IMHO it is more general to keep the out-of-tree DTBs working
> and "fix" what we can control (in-tree DTS).

If we do this, then we need to not call spi-cs-high legacy because
we're stuck with it forever.

Rob

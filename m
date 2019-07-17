Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA5F6B76D
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 09:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfGQHmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 03:42:14 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45471 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfGQHmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jul 2019 03:42:14 -0400
Received: by mail-lf1-f67.google.com with SMTP id u10so15671436lfm.12
        for <stable@vger.kernel.org>; Wed, 17 Jul 2019 00:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+jWO892WyYwNNlx4XjLEXTvovHEolIYBgPi4scRWWls=;
        b=X3AkXbIDWqTmTwTBb38t0domzuKwmPG9pUwpFDTowmcTZ9WhRRruBuBf04i+ZF8HEo
         Z/IPHP54WZNjelXr/3mu9EDlAnqh6WSnfMUjCvZfuYlyvFsqO1qJbGNbVtqEYlEWwAd/
         WwwR45Wxqj+Qj5aMF2W+3azAzeyN3k9o3dNooAXS+H1DQ8lerNtjcajbZwnHQwVE48EM
         lwC0A7LCqzfejAY6hLKtGaPS6jn+Nd+YA32mAAx5Xtn1YfUVjZG4IqD2nawyJoCQptVg
         2E8mgLbl5yrqNHW0FUQKufVloPtH4RuE4efLMVbJwSpW8I+oXQ4DJyvrcKz77PoNgztM
         cLAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+jWO892WyYwNNlx4XjLEXTvovHEolIYBgPi4scRWWls=;
        b=biu99tzClxxtEL88xv0rIHCB4B9ie8CsGGNNr6KI8YT2dhRjYDWb+ykafyuX5pQUXK
         H/bFYXTc6Aje2101HAMjc4nCPTq8Wmm4vuqxocqaVDUSiY+YoCEKU904om0eb9S2fvYh
         WkRKXwpryoM9Qg+ifx1lnpSW8pGs1dimG6Eu9sh93vrOhGVKt5t48dTIR27jJKyLI+G7
         ZwPg0OE2P5V9e9aMRDKH6SX8LpIcy+3yI+3O6UVyNlZgP5lxQMyq7hVFTih3BRMMc7cj
         Gn3TX3e0Or9pwjGEIBPT3z7oRyq925i7ebN7X2S0cdpxsLBwPwmFnHYuQ9MI0PX8ki1V
         RVMw==
X-Gm-Message-State: APjAAAWA1/4erNDaP2kOwJkWf2fju8hPrQgLjk2qMr7IIAtgpJTHbhgG
        psi4nX/e1ucDtvvw1+raI61lIT/j/+3cEyl4nbfqOw==
X-Google-Smtp-Source: APXvYqwJoW96AIGFygPrAw90IMEEjX7EdMH8w/b/BDxpGRuA50XTQS6fRZpuxIw+qfJpfl8vZyHaBojQZ5NfMXjEQIo=
X-Received: by 2002:ac2:5c42:: with SMTP id s2mr5984283lfp.61.1563349332503;
 Wed, 17 Jul 2019 00:42:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190520172139.16991-1-linus.walleij@linaro.org>
In-Reply-To: <20190520172139.16991-1-linus.walleij@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 17 Jul 2019 09:42:00 +0200
Message-ID: <CACRpkdbcobeABjcA8+_cAjgddZnmHwoCx4pqAPbSS1GDNm6J2g@mail.gmail.com>
Subject: Re: [PATCH] regmap-irq: do not write mask register if mask_base is zero
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Cc:     Mark Zhang <markz@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Jinyoung Park <jinyoungp@nvidia.com>,
        Venkat Reddy Talla <vreddytalla@nvidia.com>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, May 20, 2019 at 7:23 PM Linus Walleij <linus.walleij@linaro.org> wrote:

> From: Mark Zhang <markz@nvidia.com>
>
> commit 7151449fe7fa5962c6153355f9779d6be99e8e97 upstream.
>
> If client have not provided the mask base register then do not
> write into the mask register.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Signed-off-by: Jinyoung Park <jinyoungp@nvidia.com>
> Signed-off-by: Venkat Reddy Talla <vreddytalla@nvidia.com>
> Signed-off-by: Mark Zhang <markz@nvidia.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
> This commit was found in an nVidia product tree based on
> v4.19, and looks like definitive stable material to me.
> It should go into v4.19 only as far as I can tell.

Was this missed or is there some reason for why this didn't get
queued to stable?

Yours,
Linus Walleij

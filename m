Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5D56534F
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 10:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfGKIrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 04:47:06 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37104 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbfGKIrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 04:47:06 -0400
Received: by mail-ot1-f66.google.com with SMTP id s20so5056158otp.4;
        Thu, 11 Jul 2019 01:47:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=InDqlUc6M2ei9HBm2FeFX9lOv0/+G+KcR9Zyp274VQk=;
        b=uiD/6nAox5sf9MyASGX/o8MZNGjuDt893GGhyZyM0yokbC0BwLgxzh/3WK+53keFSE
         21IDYx5JLMMn4D5a34N5oh0DcoVG//K54a8ht7uS4G0hKd0tnxG6dFAi2g1wur/GIF33
         IIuoMEYVzg/KxZzINyg7LmKOQ2fqOtfhL8kMUNSTvsBEC7Su4hPtcoZ52iPVsoyKhjx4
         F0E+pQd9lahOPvuFHPGBPlj3rLyf9MtZOebwrEK4YXvBYetmqFGhN6TPM3XJmOHrv7FF
         Q6V8tPjdfaU/FXzCirYho8CNPjaqufTtj8cb8LwBX6xBss9z6hR9CRvHX/dFdm8h5thB
         EP1g==
X-Gm-Message-State: APjAAAXIDrYY5KQ8EF59BakSuln7Dv+mUIM55WLqkBUvusznFiABacn+
        Mv1K6KAB18aZKXY+avo4onV0L5qJw3WfO2By5HBI1w==
X-Google-Smtp-Source: APXvYqwz2SDh16EiNuG+bu35TpYvKuhn+aH+jK0by5wsHLtJnFoiw9CZshX3kBSUqbf5RMDgYOc6TuQLMHpZjylKYxI=
X-Received: by 2002:a9d:69ce:: with SMTP id v14mr2507066oto.39.1562834825315;
 Thu, 11 Jul 2019 01:47:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190711082936.8706-1-brgl@bgdev.pl>
In-Reply-To: <20190711082936.8706-1-brgl@bgdev.pl>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 11 Jul 2019 10:46:54 +0200
Message-ID: <CAMuHMdWzEOVLUZM_rFfMKqF_G_gZXBpV7TC-OXmN8YKw6_occQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] gpio: em: remove the gpiochip before removing the
 irq domain
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Phil Reid <preid@electromag.com.au>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CC Niklas, who has the hardware

On Thu, Jul 11, 2019 at 10:29 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> In commit 8764c4ca5049 ("gpio: em: use the managed version of
> gpiochip_add_data()") we implicitly altered the ordering of resource
> freeing: since gpiochip_remove() calls gpiochip_irqchip_remove()
> internally, we now can potentially use the irq_domain after it was
> destroyed in the remove() callback (as devm resources are freed after
> remove() has returned).
>
> Use devm_add_action_or_reset() to keep the ordering right and entirely
> kill the remove() callback in the driver.
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Fixes: 8764c4ca5049 ("gpio: em: use the managed version of gpiochip_add_data()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6425D91F9
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 15:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405307AbfJPNGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 09:06:30 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45153 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405306AbfJPNGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 09:06:30 -0400
Received: by mail-qk1-f194.google.com with SMTP id z67so22606263qkb.12
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 06:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ibLQ/kFLIHda3Y//bQcDwf2homCjSjyyoH0S4z0cTi0=;
        b=a94BSy1heELw6oQDUPEnoTERpUHN+acuOd0wnC3jqn9l5uUkZyf9dZrbPfBsgyyjoB
         46cVLk2CsG3+k+5q4BQZRP+CZ7CIyNtt9MxsxFE1T1Hi3/x7CG7lfGFm7Y12IG6UFBex
         3dwOAE21oTPYTqCK0ab/6nxRLdx9SmwmLVp8+FfFitRb0jbq+JQ5z8lfl7IFGgmP3plc
         lSFppFRtCbW6HlaxC++0Ip6P65ryKDvkL+6ngS5Dh+P78wnOxhrM+uqc4grIOclXyUXh
         YRQZ3y9fQAGFSOkuMZxLHc6xMNt6fNBpmLJrnqHbgvQjqFWyUijlsAuHihXc/qHECE4I
         ji0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ibLQ/kFLIHda3Y//bQcDwf2homCjSjyyoH0S4z0cTi0=;
        b=aDbbBNytzPVyDicPMxO/KHiXNq+5jLCrjVXYipZ/n1TX3ibpElsAXoFhaTvfep8wHM
         bRCcK0CVSU2OW/44cLW3aKNiUyJpRJf0TSPWdsOUNT9bCvNRmbM1R8e6KLj6UczeRbD9
         RthWl655TGpei241UEg7kOdfz6n3yoz/lWUbWZFRSj9kJw9AgozNy5ncthZiHCkHvwvf
         HdvUT3lIZRDNP1r69xUjtDGJRJ0Jqw59KMEa8PFHYeagqSF/uFNEZGgizXFQTg7+NnVt
         GvQNAVbKgnCq1EetvmiM43rcQ7GsZfGkGEqkElFWInixvq0LdjN2pfck/CuEm2fLpWJf
         lj4A==
X-Gm-Message-State: APjAAAVi9B2OeBUG/BWVsKrPwIbGte+5cqBAljsmK0DKpw/4OoKrMRh1
        YjPsj1c6dCL6/6wpjn0Y7wLeOr4VafPi1Jcvth9JOPoF
X-Google-Smtp-Source: APXvYqy+NEWe4TqFletEN/CXcIe/pp7ETy4SmUg71QD2TK/ETQMTLSHfXEKD6o3Wu7yhacbaqLmMOspTKMUXblUjUDI=
X-Received: by 2002:a05:620a:2f4:: with SMTP id a20mr3378514qko.163.1571231189266;
 Wed, 16 Oct 2019 06:06:29 -0700 (PDT)
MIME-Version: 1.0
References: <20191014155341.13145-1-brgl@bgdev.pl>
In-Reply-To: <20191014155341.13145-1-brgl@bgdev.pl>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 16 Oct 2019 15:06:18 +0200
Message-ID: <CACRpkdYL_PGbksmav7b1t=jPzGZG4Y_mXoH7Dvdgs69Qhh-UFg@mail.gmail.com>
Subject: Re: [PATCH v5.3] gpio: fix getting nonexclusive gpiods from DT
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 5:53 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:

> From: Marco Felsch <m.felsch@pengutronix.de>
>
> Since commit ec757001c818 ("gpio: Enable nonexclusive gpiods from DT
> nodes") we are able to get GPIOD_FLAGS_BIT_NONEXCLUSIVE marked gpios.
> Currently the gpiolib uses the wrong flags variable for the check. We
> need to check the gpiod_flags instead of the of_gpio_flags else we
> return -EBUSY for GPIOD_FLAGS_BIT_NONEXCLUSIVE marked and requested
> gpiod's.
>
> Fixes: ec757001c818 gpio: Enable nonexclusive gpiods from DT nodes
> Cc: stable@vger.kernel.org
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> [Bartosz: the function was moved to gpiolib-of.c so updated the patch]
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> [Bartosz: backported to v5.3.y]
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Thanks for fixing up this backport Bartosz, much appreciated!

Yours,
Linus Walleij

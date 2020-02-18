Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B75016246D
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 11:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgBRKWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 05:22:22 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44717 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgBRKWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 05:22:21 -0500
Received: by mail-qt1-f193.google.com with SMTP id j23so296497qtr.11
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 02:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jcijWLGUlZ8GgDNFPut3P5OmzC3gncuLiap7isWZjgk=;
        b=j6+aJwtcULrl6SmiRgNh4CBUBQTOfkxgDzVYO0lJp/vlUKc+7ihhc1hO5Zw8h+HUOi
         IkRjxilM1shdIt/E4L3TQZcHmnAZ7PLOgAIq6cDwaRUtU1c6i0vw6t/6wZ7oMjGZA3S2
         Y2yP8kFEjqlMqWEYr7uiM4v9GrmCJ034aYdZlczf1I0RzEiqcsje369Vgj3gtS18REjd
         DHLDhypnd3RWqdNshdMBRBtKnd/TGoexOPwKiuz8ejc0azD8ScG5cZXA31/GPOvY9hws
         3WUTT2aWBbPe+JVahGMC1HzFdFnOHhltAAHt14Noch80XBrxQo1GRbjistaNxnIHA51w
         GHOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jcijWLGUlZ8GgDNFPut3P5OmzC3gncuLiap7isWZjgk=;
        b=S/o4DlPlf1lUgZmFIRuxs43ytoYXDJMzRmoHy1HJx2Z8DxsNU0Y1668MeruPHaUepT
         DWL/rISHc4pYQpa2fSAn9EDA9bd//ltfxhDj7Wr+WtlNUUPfA9TfgcUgQdI7IL0UQpEj
         MglAxZJw9Mv09xFfMbh4EqXFbS2EAeDMBf9G7iXpXEhr2EWpCV7pMgh3y835UttY34r1
         GT4ULF58i4TvWNJ2G5IIXH6KKWpXqwI4xLLYktZtMNQii/YNFjWdYBRsPwoQVXzeSWB5
         9yByQQ/NZNdlgBr6t1vV1etBYZv2SEx8cHIiV1vZgbeByaxQHOvlW+pysz208q0AeaGA
         JaNg==
X-Gm-Message-State: APjAAAXMPwisio/6f0WvK0a9BqOL1TCw6nQQ1ddVoGaWP2ou08Hiart0
        YB+2sfjiFgzgnjyadjiABBzE1ivmos+6qm6kzovNeQ==
X-Google-Smtp-Source: APXvYqzWsJO4o+rLLiO9z/NWy6qPc1zKWJBW/rz0AKgMC0f+bsIObg0ctlwu4M5ADLVlloybivZkhN8mEckTRCQpUyA=
X-Received: by 2002:ac8:7657:: with SMTP id i23mr16804779qtr.197.1582021340839;
 Tue, 18 Feb 2020 02:22:20 -0800 (PST)
MIME-Version: 1.0
References: <20200218094234.23896-1-brgl@bgdev.pl> <20200218094234.23896-3-brgl@bgdev.pl>
 <6e7a5df7-6ded-7777-5552-879934c185ad@linaro.org> <CAMRc=McQ4ESq4g82QGjZiM0+NWUBrjUv71Be7UXzZpSsa9xAig@mail.gmail.com>
 <5f4cf6ca-c5e2-9fd2-b4b8-f99a120e0d4b@linaro.org>
In-Reply-To: <5f4cf6ca-c5e2-9fd2-b4b8-f99a120e0d4b@linaro.org>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Tue, 18 Feb 2020 11:22:10 +0100
Message-ID: <CAMpxmJXpC+_4Z3T+z01DMr5yxgY0WoBuc_RdszHwnaC42NXu9g@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] nvmem: fix another memory leak in error path
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Khouloud Touil <ktouil@baylibre.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

wt., 18 lut 2020 o 11:11 Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> napisa=C5=82(a):
>
>
>
> On 18/02/2020 10:05, Bartosz Golaszewski wrote:
> > wt., 18 lut 2020 o 10:56 Srinivas Kandagatla
> > <srinivas.kandagatla@linaro.org> napisa=C5=82(a):
> >>
> >>
> >>
> >> On 18/02/2020 09:42, Bartosz Golaszewski wrote:
> >>> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> >>>
> >>> The nvmem struct is only freed on the first error check after its
> >>> allocation and leaked after that. Fix it with a new label.
> >>>
> >>> Cc: <stable@vger.kernel.org>
> >>> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> >>> ---
> >>>    drivers/nvmem/core.c | 8 ++++----
> >>>    1 file changed, 4 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
> >>> index b0be03d5f240..c9b3f4047154 100644
> >>> --- a/drivers/nvmem/core.c
> >>> +++ b/drivers/nvmem/core.c
> >>> @@ -343,10 +343,8 @@ struct nvmem_device *nvmem_register(const struct=
 nvmem_config *config)
> >>>                return ERR_PTR(-ENOMEM);
> >>>
> >>>        rval  =3D ida_simple_get(&nvmem_ida, 0, 0, GFP_KERNEL);
> >>> -     if (rval < 0) {
> >>> -             kfree(nvmem);
> >>> -             return ERR_PTR(rval);
> >>> -     }
> >>> +     if (rval < 0)
> >>> +             goto err_free_nvmem;
> >>>        if (config->wp_gpio)
> >>>                nvmem->wp_gpio =3D config->wp_gpio;
> >>>        else
> >>> @@ -432,6 +430,8 @@ struct nvmem_device *nvmem_register(const struct =
nvmem_config *config)
> >>>        put_device(&nvmem->dev);
> >>>    err_ida_remove:
> >>>        ida_simple_remove(&nvmem_ida, nvmem->id);
> >>> +err_free_nvmem:
> >>> +     kfree(nvmem);
> >>
> >> This is not correct fix to start with, if the device has already been
> >> intialized before jumping here then nvmem would be freed as part of
> >> nvmem_release().
> >>
> >> So the bug was actually introduced by adding err_ida_remove label.
> >>
> >> You can free nvmem at that point but not at any point after that as
> >> device core would be holding a reference to it.
> >>
> >
> > OK I see - I missed the release() callback assignment. Frankly: I find
> > this split of resource management responsibility confusing. Since the
> > users are expected to call nvmem_unregister() anyway - wouldn't it be
> > more clear to just free all resources there? What is the advantage of
> > defining the release() callback for device type here?
>
> Because we are using dev pointer from nvmem structure, and this dev
> pointer should be valid until release callback is invoked.
>
> Freeing nvmem at any early stage would make dev pointer invalid and
> device core would dereference it!
>

Ok, let me brew up a v3 with that in mind.

Bart

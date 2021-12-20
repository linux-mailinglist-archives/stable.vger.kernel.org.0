Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7202B47AFA3
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236469AbhLTPQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:16:28 -0500
Received: from mail-ua1-f49.google.com ([209.85.222.49]:44871 "EHLO
        mail-ua1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237016AbhLTPOb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:14:31 -0500
Received: by mail-ua1-f49.google.com with SMTP id p2so18208816uad.11;
        Mon, 20 Dec 2021 07:14:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1RrQd9GJbr8VHOo3UvKL+r03emDIirUU1mO3qVTnuYM=;
        b=3XOnZL4iH1g8qcNmMWjxGHfPI3AX0/isMQHTWVpftMLNFO1idbKx9cyeGyK8+udwOO
         1On2T/jg29z/wTOzwsHgqTFvPQrSmjEF8Tk6rQVMV5srcs/U9u62owWDjg8O842fUKUT
         Frjm9m6v+cArKImmnacto+1e7eCR2qVtLl0gycxDtbYAY++jt/8jOgE8i5CtLi/Cy2IB
         b1C0K6Ub7ogcasGsuh4O1tsvnyI8i876qC3lnRoi9UfVgGIMCiTp3kM2JYunlT8kZqbk
         IYkMPamxsMKdvSpNFylTMeVxClTJlV0vE3imyc6lsekFOJYJZA1QOb1/t1FjT8lRJIeX
         LsGw==
X-Gm-Message-State: AOAM531REjL5EQID0NEhDRnMpkuj89YywhQ6uGdwaDwmsVVrRUC01C1i
        QQke6dPP3To2iE/MNUMKuVQZFFSxq8bZzw==
X-Google-Smtp-Source: ABdhPJx1SwCbCv6Yyod5pRZs7WEMI3XY0JRVQg/V/k5uXzc5nIHmxL085ZvJa0u26rjTxqqUuvfS5A==
X-Received: by 2002:a05:6102:3554:: with SMTP id e20mr4987497vss.50.1640013269993;
        Mon, 20 Dec 2021 07:14:29 -0800 (PST)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id x34sm2418512uac.12.2021.12.20.07.14.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 07:14:29 -0800 (PST)
Received: by mail-ua1-f51.google.com with SMTP id t13so18218557uad.9;
        Mon, 20 Dec 2021 07:14:28 -0800 (PST)
X-Received: by 2002:a9f:3e01:: with SMTP id o1mr5360780uai.89.1640013268654;
 Mon, 20 Dec 2021 07:14:28 -0800 (PST)
MIME-Version: 1.0
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
 <a7fbb773-eb85-ccc7-8bfb-0bfab062ffe1@leemhuis.info> <CAMRc=MfAxzmAfATV2NwfTgpfmyxFx8bgTbaAfWxSi9zmBecPng@mail.gmail.com>
In-Reply-To: <CAMRc=MfAxzmAfATV2NwfTgpfmyxFx8bgTbaAfWxSi9zmBecPng@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 20 Dec 2021 16:14:17 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVp621B0DywkW6sx6wNcPFez9=3-=cfSo7UoRttJ6QXCg@mail.gmail.com>
Message-ID: <CAMuHMdVp621B0DywkW6sx6wNcPFez9=3-=cfSo7UoRttJ6QXCg@mail.gmail.com>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Edmond Chung <edmondchung@google.com>,
        Andrew Chant <achant@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 3:57 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> On Sat, Dec 18, 2021 at 7:28 AM Thorsten Leemhuis
> <regressions@leemhuis.info> wrote:
> > [TLDR: I'm adding this regression to regzbot, the Linux kernel
> > regression tracking bot; most text you find below is compiled from a few
> > templates paragraphs some of you might have seen already.]
> >
> > On 17.12.21 16:35, Marcelo Roberto Jimenez wrote:
> > > Some GPIO lines have stopped working after the patch
> > > commit 2ab73c6d8323f ("gpio: Support GPIO controllers without pin-ranges")
> > >
> > > And this has supposedly been fixed in the following patches
> > > commit 89ad556b7f96a ("gpio: Avoid using pin ranges with !PINCTRL")
> > > commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not defined")
> >
> > There seems to be a backstory here. Are there any entries and bug
> > trackers or earlier discussions everyone that looks into this should be
> > aware of?
> >
>
> Agreed with Thorsten. I'd like to first try to determine what's wrong
> before reverting those, as they are correct in theory but maybe the
> implementation missed something.
>
> Have you tried tracing the execution on your platform in order to see
> what the driver is doing?

Looking at commits that have related Fixes tags:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bf781869e5cf3e4ec1a47dad69b6f0df97629cbd
https://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git/commit/?id=e8f24c58d1b69ecf410a673c22f546dc732bb879

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

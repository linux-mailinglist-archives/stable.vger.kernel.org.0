Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0E2D5F771
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 13:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfGDLta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 07:49:30 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39404 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727574AbfGDLt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 07:49:29 -0400
Received: by mail-ot1-f67.google.com with SMTP id r21so988537otq.6;
        Thu, 04 Jul 2019 04:49:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9xEWPejmpIWFTbFjzce4Zj6zywXXGW0Iij2wHk7f11M=;
        b=uh9kGeqNrjP7WCSq9SDyONqUKFZX/kAOgxMYZ8PX/EbIQiL+h3mj6KI4JZwsL3WfFA
         QXfn5zlXvoGgKo76X6Pht2K7QOsG9XgFaz7qnEK1uJ9SNt3PeLzYuYHWKWa6Q7VBaw1u
         iA93PWh409iVdkBWQxMFlgD830zq4V4k5EN1vp3Sg/HmZJ77+iAckCLfmFFpLaFpICUr
         3PWTq2DdIWO5C+5fNriHuemqAslZhpjJgsTC6p77KI4x+0pZy8p97gRDYEzFFGHGoLRN
         MS4wZ5tNq5/WcCIp8N5A0qMvT3v/Bc5VTY6/0DrvehD0qRiAnIrwOmE2XOZ/gveFUbrh
         onTg==
X-Gm-Message-State: APjAAAUYb3Grsqjzyz15+cN4aDe7aaiDTGANAiZNKnUb6/brcIyBVJEl
        mcwRRsPqqkD6CJwSmIHrJWUcIX2TATPvZKWIjYE=
X-Google-Smtp-Source: APXvYqw/cs2Mt3Js4W2qPvntgiHP6KeISngqlC9yO6L5/qIpIQNg08AZWAXxjh+pIOjaAyKDfibVyqFd7YYIVFmaJGE=
X-Received: by 2002:a9d:704f:: with SMTP id x15mr13052250otj.297.1562240968938;
 Thu, 04 Jul 2019 04:49:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190704113800.3299636-1-arnd@arndb.de>
In-Reply-To: <20190704113800.3299636-1-arnd@arndb.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 4 Jul 2019 13:49:17 +0200
Message-ID: <CAMuHMdXFkF_940-sKCZrx3KxgJU4wA-ezb_gfgHL9J-G1y4mVA@mail.gmail.com>
Subject: Re: [PATCH] iio: adc: gyroadc: fix uninitialized return code
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Marek Vasut <marek.vasut@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>,
        stable <stable@vger.kernel.org>,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Rob Herring <robh@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Arnd,

On Thu, Jul 4, 2019 at 1:38 PM Arnd Bergmann <arnd@arndb.de> wrote:
> gcc-9 complains about a blatant uninitialized variable use that
> all earlier compiler versions missed:
>
> drivers/iio/adc/rcar-gyroadc.c:510:5: warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]

Actually gcc-4.1 warned about that one too ;-)

So either I must have missed that warning when it appeared first,
or I must have concluded wrongly that it was a false positive.
Sorry for that...

> Return -EINVAL instead here.
>
> Cc: stable@vger.kernel.org
> Fixes: 059c53b32329 ("iio: adc: Add Renesas GyroADC driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

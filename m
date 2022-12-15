Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30DBB64D8B1
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 10:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiLOJgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 04:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiLOJgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 04:36:46 -0500
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727DF3B9D5;
        Thu, 15 Dec 2022 01:36:42 -0800 (PST)
Received: by mail-qt1-f179.google.com with SMTP id h16so4711169qtu.2;
        Thu, 15 Dec 2022 01:36:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g2NPyqXJNNNln99iz2q7S9fU77v53XVtuYkV5/riHK4=;
        b=rvRZgTky8JfMbrRMuRuLemz7U44fGeqT5+zWcZasq/EF0wo2M4EPpQEchxrOzfzFWD
         hd3e1pVcF4lm3RQDsSWkHV80MsJf7LB7Aag+u2TroTK4ffghVfCe6zDw0bWdrUlSPR/p
         zLHgQRBFIqATgtjGVsAssW6xgaC11aWbI+kUaNGYEXkFWw0jl/l1Hs1B1vaxW9mDjEXi
         wcTioP3IS4z28iPggYibZQnqdVifqVFRhMhEx7LMaf3shBUQukhgcLWv94hvGCwCU2M9
         8hgmo2HJjieXSWKn+tz7/l6mjP0bmIHhLnn4hkmmsUttSNueDfmYjg7mZIKLinBh+9WU
         uWzw==
X-Gm-Message-State: ANoB5pm2mX6tZZVGBAOErpxix3cL1iOAuvBHCbddrmirwnrJdK/w+j70
        w19ugasWuXBIKbDiaCw7gFmsxJQIenSnlQ==
X-Google-Smtp-Source: AA0mqf74faInuqayWHSXly9Xm3tR6H7DAvKLkrxaBS3NNiKKkkkwCJOkkZWSt6fPuKuRS8aR81HzFQ==
X-Received: by 2002:ac8:541a:0:b0:3a5:24fc:4bbb with SMTP id b26-20020ac8541a000000b003a524fc4bbbmr16080672qtq.7.1671097001447;
        Thu, 15 Dec 2022 01:36:41 -0800 (PST)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id ay42-20020a05620a17aa00b006ef1a8f1b81sm11706323qkb.5.2022.12.15.01.36.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 01:36:41 -0800 (PST)
Received: by mail-yb1-f170.google.com with SMTP id 186so2801147ybe.8;
        Thu, 15 Dec 2022 01:36:40 -0800 (PST)
X-Received: by 2002:a25:7104:0:b0:702:90b4:2e24 with SMTP id
 m4-20020a257104000000b0070290b42e24mr13831647ybc.365.1671097000657; Thu, 15
 Dec 2022 01:36:40 -0800 (PST)
MIME-Version: 1.0
References: <cad03d25-0ea0-32c4-8173-fd1895314bce@I-love.SAKURA.ne.jp>
In-Reply-To: <cad03d25-0ea0-32c4-8173-fd1895314bce@I-love.SAKURA.ne.jp>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 15 Dec 2022 10:36:29 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUH4CU9EfoirSxjivg08FDimtstn7hizemzyQzYeq6b6g@mail.gmail.com>
Message-ID: <CAMuHMdUH4CU9EfoirSxjivg08FDimtstn7hizemzyQzYeq6b6g@mail.gmail.com>
Subject: Re: [PATCH] fbcon: Use kzalloc() in fbcon_prepare_logo()
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Daniel Vetter <daniel@ffwll.ch>, Helge Deller <deller@gmx.de>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Handa-san,

On Thu, Nov 17, 2022 at 4:32 PM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> A kernel built with syzbot's config file reported that
>
>   scr_memcpyw(q, save, array3_size(logo_lines, new_cols, 2))
>
> causes uninitialized "save" to be copied.

> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Thanks for your patch, which is now commit a6a00d7e8ffd78d1
("fbcon: Use kzalloc() in fbcon_prepare_logo()") in v6.1-rc7,
and which is being backported to stable.

> --- a/drivers/video/fbdev/core/fbcon.c
> +++ b/drivers/video/fbdev/core/fbcon.c
> @@ -577,7 +577,7 @@ static void fbcon_prepare_logo(struct vc_data *vc, struct fb_info *info,
>                 if (scr_readw(r) != vc->vc_video_erase_char)
>                         break;
>         if (r != q && new_rows >= rows + logo_lines) {
> -               save = kmalloc(array3_size(logo_lines, new_cols, 2),
> +               save = kzalloc(array3_size(logo_lines, new_cols, 2),
>                                GFP_KERNEL);
>                 if (save) {
>                         int i = min(cols, new_cols);

The next line is:

                        scr_memsetw(save, erase,
array3_size(logo_lines, new_cols, 2));

So how can this turn out to be uninitialized later below?

                scr_memcpyw(q, save, array3_size(logo_lines, new_cols, 2));

What am I missing?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

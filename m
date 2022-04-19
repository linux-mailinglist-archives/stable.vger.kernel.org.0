Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6403B5060F3
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 02:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240521AbiDSA3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240738AbiDSA31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:29:27 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCF122B33;
        Mon, 18 Apr 2022 17:26:24 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id y19so12054900qvk.5;
        Mon, 18 Apr 2022 17:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r/8IhUYumPgGlWcaLrv8LYlYLLFMia8Jo1Q6MnYM6Pc=;
        b=oOe1aYS1bBzFC/F96YEOjVTh7L+YEnCIa+QNbLoE6bvFoub44qnRlFaXxscXqSK9EJ
         2rLbF0IeAWRUhSoGMh6gST1B3jNHNmxbVdIzszhVozRT/NL2l+1wU/iW60VjqyaYsEoO
         OoKewCg6FOgDKhAZBj2ZaBelbT9iDBVBCD1qdDfJnw5qIfEHq9eBQBT4pj8037EmPj6f
         mx82V2EaaHs9E4uDz1cAZsA6uljOv5C30vnOrOCeKM+RN6kBz7AreF1ae5oo0DvCZ+cW
         i/gXCOOZyjLCZmitGgNIXFAZF/iT9HpqShURI7lv3MwZ/DcjokaXlV41GGjR/+/ofwZX
         gIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r/8IhUYumPgGlWcaLrv8LYlYLLFMia8Jo1Q6MnYM6Pc=;
        b=ps0tRqyOpZ21zCzudmu9Eqc1WDlFsbanF3j+pFqBxu/52+jZaDCBBXbx8DAevfiB0W
         mnrMb5DarefUcVguNdgosBQ94OU4WRwB71vx7Kqbv8w92SlLKMdAMoWE9rHx0aNycd7b
         LYQbEoS9hhUGEd9BR3lnhOqPjl5xKP7L0nMlYSckzSSpPiOlZvv9MBUxZbf6phDqsNHP
         xZ+7NM8Gg9eUhLU4mELGoXERnUxQ6S8fIvw9R4hMvXKkmnq64lZ81o81h+npmwAF3Nq0
         CnMQZgUD0SkqKtprhzAPDswsX4nNw7v3pbCOzUpU1H1hvxKb7DyHGhEc/7IaXwQpLEWa
         Ao4Q==
X-Gm-Message-State: AOAM531M0GW6KJrDyK2B6/BnF4FcdmoHXtkCU0Q5t/Y41zpl0FIv17ou
        8WgMYM+VS2sVlYW5xd1oJYe1oGUPBE66+0tSn3c=
X-Google-Smtp-Source: ABdhPJw255BQZzve7Trub/Gqg+xCd5BgjLuRRScROAjRoahM4+lRqR32/NLf//asvQe/oIUfmy1RSJm+LhjwKs399vU=
X-Received: by 2002:a05:6214:acf:b0:446:7570:bdd1 with SMTP id
 g15-20020a0562140acf00b004467570bdd1mr390259qvi.103.1650327983517; Mon, 18
 Apr 2022 17:26:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220417181538.57fa1303@blackhole> <CA+E=qVeX2aU0hiDMxLXzVk-YiMsqKKFKpm=cc=72joMhZmNV1g@mail.gmail.com>
In-Reply-To: <CA+E=qVeX2aU0hiDMxLXzVk-YiMsqKKFKpm=cc=72joMhZmNV1g@mail.gmail.com>
From:   Vasily Khoruzhick <anarsoul@gmail.com>
Date:   Mon, 18 Apr 2022 17:25:57 -0700
Message-ID: <CA+E=qVdEtx8wVbcrMQYGB1ur1ykvNRp1L174mVSMkB0zeOPYNQ@mail.gmail.com>
Subject: Re: [PATCH] drm/bridge: fix anx6345 power up sequence
To:     Torsten Duwe <duwe@lst.de>
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Thierry Reding <treding@nvidia.com>,
        Lyude Paul <lyude@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Geyer <harald@ccbib.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 17, 2022 at 11:52 AM Vasily Khoruzhick <anarsoul@gmail.com> wrote:
>
> On Sun, Apr 17, 2022 at 9:15 AM Torsten Duwe <duwe@lst.de> wrote:
> >
> > Align the power-up sequence with the known-good procedure documented in [1]:
> > un-swap dvdd12 and dvdd25, and allow a little extra time for them to settle
> > before de-asserting reset.
>
> Hi Torsten,
>
> Interesting find! I tried to fix the issue several times by playing
> with the delays to no avail.
>
> What's interesting, ANX6345 datasheet allows DVDD12 to come up either
> earlier or later than DVDD25 with the delay of T1 (2ms typical)
> between them, and actually bringing up DVDD12 first works fine in
> u-boot.
>
> The datasheet also requires reset to be deasserted no earlier than T2
> (2-5ms) after all the rails are stable.
>
> Another thing it mentions is that the system clock must be stable for
> T3 (1-3ms) before reset is deasserted, T3 is already a part of T2,
> however it cannot be gated on Pinebook, see [1], page 15
>
> The change looks good to me, but I'll need some time to actually test
> it. If you don't hear from me for longer than a week please ping me.

Your change doesn't fix the issue for me. Running "xrandr --output
eDP-1 --off; xrandr --output eDP-1 --auto" in a loop triggers the
issue pretty quickly even with the patch.

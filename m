Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D252563118
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 12:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbiGAKOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 06:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbiGAKOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 06:14:02 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F4D7435F;
        Fri,  1 Jul 2022 03:14:01 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id p136so3228615ybg.4;
        Fri, 01 Jul 2022 03:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/iB+M+0hVpqsRqriYarOMDGWv0AtTyLwSJV6suVTYyw=;
        b=RUa6GRZLbe8sy+nguH+vxiUKCkl84S9pTY/kCbQf79AXErS1GwfwhMZUET04xWxhxD
         4as4KgeOrC0AsNDqOdWV3LaiwxKcd7lqvHITR/M1j6WBtayFDtLWUe9STIgYIdNodo5e
         bue0IoxVFvDY3MPfmZRp3/0Cu/TxjObMuMgii6fIM2CFkAe+Uc8lkbTQxb/XmzMROoYX
         y/995itSu7ofu+tWc9b9996nbs/Gsab5ApfZMxhBoQQrFCGmBMCx+INZ1myrZOTSoWsB
         hIqdYQjYi7wT2sprqAoKVt35pW+UwW75QRkQVnX/Mp0b/P6xV6Fp1Ap/TO9cLaiY3e2k
         kDTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/iB+M+0hVpqsRqriYarOMDGWv0AtTyLwSJV6suVTYyw=;
        b=YQCP9M8oo1W5MLRmOh4RHScjASFnITgcydA7KyRCvLZkG25jYCZNfBgDa9ddeDYMRc
         cUceytEkXJIjbmUoF6HeECRsYy9s9TP0bL8RwtwrY5K5FRW6zeKg/VRcj6o0EdRAmNPY
         sPtSIiuqkzwUgZzXedNw1CK1ph1OM0D51zj7aZ1w3Z0XUKPMZjMlW7FOZz/DkhGnmpk8
         KLob4FWOpZ4J2EO9eT3u8hM9UbNyS8JldIhnrwaaxVOBPNJ7CQ8ELbCLxnIlcOKvvkht
         Xeh7hgqXRZBhzVHaeDgqqZZAtBgU+g0UP+BIOOExYJy3EY7dv3oUcgknZPMINg8Lkd5w
         F9CA==
X-Gm-Message-State: AJIora+2f4ROMt2mBgIPYEIPUrcbGJEC0Hk8kgClYjSF12uzAP+D93nr
        mG7Ny7jwlsQCUSTFMImT7X/0+CZC9cYFwgYl7CY=
X-Google-Smtp-Source: AGRyM1uuLhfXVwXfyXEHG2xyPbHKXd4KR3y+NqOljBKVm9GdhT1AnffWZCs0PYHMmTYEe6tHWe0ApNumYbr2LnkJle0=
X-Received: by 2002:a25:187:0:b0:66c:eaea:71ec with SMTP id
 129-20020a250187000000b0066ceaea71ecmr14896072ybb.570.1656670440998; Fri, 01
 Jul 2022 03:14:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220630230107.13438-1-nm@ti.com>
In-Reply-To: <20220630230107.13438-1-nm@ti.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 1 Jul 2022 12:13:24 +0200
Message-ID: <CAHp75Vfm+NDzZEB1Qp-3+mbj=NOko=5jjcHr_A4J6-jMpTykhg@mail.gmail.com>
Subject: Re: [PATCH] iio: adc: ti-adc128s052: Fix number of channels when
 device tree is used
To:     Nishanth Menon <nm@ti.com>
Cc:     Javier Martinez Canillas <javier@osg.samsung.com>,
        =?UTF-8?B?TnVubyBTw6E=?= <nuno.sa@analog.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-iio <linux-iio@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
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

On Fri, Jul 1, 2022 at 1:02 AM Nishanth Menon <nm@ti.com> wrote:
>
> When device_match_data is called - with device tree, of_match list is

device_get_match_data() ?

> looked up to find the data, which by default is 0. So, no matter which
> kind of device compatible we use, we match with config 0 which implies
> we enable 8 channels even on devices that do not have 8 channels.
>
> Solve it by providing the match data similar to what we do with the ACPI
> lookup information.
>
> Fixes: 9e611c9e5a20 ("iio: adc128s052: Add OF match table")
> Cc: <stable@vger.kernel.org> # 5.0+
> Signed-off-by: Nishanth Menon <nm@ti.com>

...

> +       { .compatible = "ti,adc128s052", .data = 0},

No assignment, 0 _is_ the default here.

> +       { .compatible = "ti,adc122s021", .data = 1},
> +       { .compatible = "ti,adc122s051", .data = 1},
> +       { .compatible = "ti,adc122s101", .data = 1},
> +       { .compatible = "ti,adc124s021", .data = 2},
> +       { .compatible = "ti,adc124s051", .data = 2},
> +       { .compatible = "ti,adc124s101", .data = 2},

What you need _ideally_ is rather use pointers to data structure where
each of that chip is defined, then it will be as simple as


const struct my_custom_drvdata *data;

data = device_get_match_data(dev);

Where my_custom_drvdata::num_of_channels will be already assigned to
whatever you want on a per chip basis.

If the number of channels is the only data you have, then yes, cast it
to void * in the OF ID table and

num = (uintptr_t)device_get_match_data(dev);

will suffice.

-- 
With Best Regards,
Andy Shevchenko

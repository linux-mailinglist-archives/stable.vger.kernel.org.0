Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C3145D929
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbhKYL0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238332AbhKYLYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 06:24:35 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E056C0613D7;
        Thu, 25 Nov 2021 03:16:23 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id az37so11462763uab.13;
        Thu, 25 Nov 2021 03:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/sJ5B3jXlGyBILLnUHy77HmaGaWwuAA8bSDGuBZ2r1M=;
        b=NLJj0axX1bPFOQD4ljA9ti4yWQN2TG00NEUMABfCAJWmEZZbY8nuyZODDYjNb1sMGb
         jI0ah4U1VsTDvxRzxKIvr3UQygTogZvU1FTvIa+apmmfQ7KVMoOs0zSi6Tiou/FAk3tr
         KsFXlxQ89wgymbYEwO+xNbITP4k3cXsn51dyAhdcWNfskmP0j8RR21SxJgooKKJxmZKC
         P6HPQdelxKfuJTG9aJXUhNJlYjtsYBhmF1BWcW66BF/AzvTBDQUkcjZKmDbpdMBPCVUO
         ZAvUy0eB45N3oubNCUY+6zCowLRjACqhCwwxLabC9rPZORI34CEhhOGXW/uJu5gvwXAy
         xbzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/sJ5B3jXlGyBILLnUHy77HmaGaWwuAA8bSDGuBZ2r1M=;
        b=ItJoJtiSrn7SLLE2dXEhedbeDiYQxpqDJHGekrP1XCUauAq/3lOpgyYpfDbWL9S9Kw
         4aTpGZ7kagNbSskoUclfAGftcfSteQEoU9VWteaOR44DtyqetT4igWxYqHjQqfJXi85Z
         a9JsRzpKmYU+8MCCbNxQYToVjIeKs5G+FBfw+SSy9ZDZjBB/fZqThi6sM4IzMOfQHnP3
         YYNQflHe9PgyYAF1+CO+GepkkyoFzZf9clWKdmNM96CuO68KVYqvPzV4BtJdj+39cep/
         14WAC06CMgIBJAdO/+J0MdCxnsccBOw60w1Fji15f1hgFt2BJcnGGMUiqBvLuJoY9v1u
         NKGA==
X-Gm-Message-State: AOAM530BV+4nHyhSNHNAqlIOHOqHh0rNtYxETjpDFT/sJmjUikvwCm99
        2/M+D0rh5tzCX2+oOvFG3HxYixa+dbYh+6vOfZ0=
X-Google-Smtp-Source: ABdhPJz2Sy6YfkZRX6R5PSTBGald8FDZB5YsRR3m2r+z+Fe2P6LBW+Oo8PoF2CfeAiCsGiYKYv+L0Xx6STxShWUa4Gc=
X-Received: by 2002:a05:6102:358b:: with SMTP id h11mr7950623vsu.24.1637838982783;
 Thu, 25 Nov 2021 03:16:22 -0800 (PST)
MIME-Version: 1.0
References: <20210921113754.767631-1-festevam@gmail.com> <20211125083400.h7qoyj52fcn4khum@pengutronix.de>
In-Reply-To: <20211125083400.h7qoyj52fcn4khum@pengutronix.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 25 Nov 2021 08:16:12 -0300
Message-ID: <CAOMZO5BXGxXKZAq2jeJ=yRww+Hoft_9=6jUheM92w5majQ1UdQ@mail.gmail.com>
Subject: Re: [PATCH] usb: chipidea: ci_hdrc_imx: Fix -EPROBE_DEFER handling
 for phy
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     peter.chen@kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Marek Vasut <marex@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Schrempf Frieder <frieder.schrempf@kontron.de>,
        stable <stable@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Gavin Schenk <g.schenk@eckelmann.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Uwe,

On Thu, Nov 25, 2021 at 5:34 AM Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@pengutronix.de> wrote:
>
> With an old style device tree using fsl,usbphy
> devm_usb_get_phy_by_phandle() returning ERR_PTR(-EPROBE_DEFER) results in
> ci->usb_phy =3D ERR_PTR(-EPROBE_DEFER) in the chipidea driver which then
> chokes on that with
>
>         Unable to handle kernel paging request at virtual address fffffe9=
3
>
> Handle errors other then -ENODEV as was done before v5.15-rc5 in
> ci_hdrc_imx_probe().
>
> Fixes: 8253a34bfae3 ("usb: chipidea: ci_hdrc_imx: Also search for 'phys' =
phandle")
> Cc: stable@vger.kernel.org
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
>
> this patch became commit 8253a34bfae3278baca52fc1209b7c29270486ca in
> v5.15-rc5. On an i.MX25 I experience the following fault:
>
> [    2.248749] 8<--- cut here ---
> [    2.259025] Unable to handle kernel paging request at virtual address =
fffffe93

Sorry for the breakage.

Dan has sent a fix for this:
https://www.spinics.net/lists/linux-usb/msg219148.html

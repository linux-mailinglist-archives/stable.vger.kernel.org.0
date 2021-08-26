Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1C63F86DD
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 14:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242313AbhHZMBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 08:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242246AbhHZMBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 08:01:08 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CBEC061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 05:00:21 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id v26so1874947vsa.0
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 05:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nigauri-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ls2ypno4o2WXx/qIUwwal89wxoQGs4dCDmma7F8fOas=;
        b=wnqoAHJLnXB6H7zSmKlyAT7GoPufCt1zOyAKr2MLn/KjEvkfL8FNLCIrTN0lokpW/G
         aOZY5Zj8eHKkoJyiwlFw0wHcY0VIjnuoIn3pdtAIpLErNygqI/3W1rSlrJOoKcEEUT+i
         xmbrfxvjKVNZANJ/6XkQbiUWa1HxPpYvtf/xXVkBdLXbNn3V/bhlRB7F9PC3GWI1lYBJ
         mxedbJ7+2O/I4M0AJUJ72a8eMits+rhFVxAFVYzQHTElMkd1D4eMDHyv0Rk6EL25uu2m
         bxfXr0EGK2jU2n10mhlhqccklMzkGyviG2EAb+R5OFRZ0L95bGdMcoHvDUHwQQNWISmJ
         4pcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ls2ypno4o2WXx/qIUwwal89wxoQGs4dCDmma7F8fOas=;
        b=CpW7MaFg2U3h2h5cIpU6wUXZRYfpNpPoWFVNcjGtL5246aFu/kECKCPDWNp91VSqim
         h9Q1q9hN1l1HI4IapJMTcT7rh635pGarMITLTqUO2C3W0lK0WG3S8ahKoCovsOmcSb52
         WLCGdBaxJJ96DdPoMxE3fr66tCGEvwQeyGKZmgC6CIbdUd0Wk0EsE2k7sUnzByZ4BApu
         gyKW6DXaSeNKjGKmkGSuFKlvg0dOUeCteRtjhqfkEpR1ZRVMT2AjGwAE/2G4g15EoZHa
         yfhKRaRshTgpiqv8FufXsnNWWcNlW5eotIuNbM+zswna7juRD2podQVjnebe4DLY+XiB
         Hrmw==
X-Gm-Message-State: AOAM531XY/8Y6kpn+7Hqp4mjzMSXeSUPL1+rBPAouyIWmcNQEKALRHQx
        4ibhYMDjcBiNgVvh/VVhyCLaGabrV2naQbIS/Bs0
X-Google-Smtp-Source: ABdhPJxl1t8cPnYP7bde8aXk2a6tsl/I44XcfcVvB/2t/hON9zl/ZkiYAEA5BoInYFUmxsAyHBqm7EFNZeVolv/D5pQ=
X-Received: by 2002:a05:6102:3ed6:: with SMTP id n22mr1667398vsv.24.1629979220306;
 Thu, 26 Aug 2021 05:00:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210824170743.710957-1-sashal@kernel.org> <20210824170743.710957-26-sashal@kernel.org>
In-Reply-To: <20210824170743.710957-26-sashal@kernel.org>
From:   Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Date:   Thu, 26 Aug 2021 20:59:53 +0900
Message-ID: <CABMQnVJrxqB8koLO9-mBCZgRyQydU7x7B8aHgRPjpxw92hBWjQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 25/31] mmc: dw_mmc: Wait for data transfer after
 response errors.
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Doug Anderson <dianders@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Alim Akhtar <alim.akhtar@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,


2021=E5=B9=B48=E6=9C=8825=E6=97=A5(=E6=B0=B4) 2:39 Sasha Levin <sashal@kern=
el.org>:
>
> From: Doug Anderson <dianders@chromium.org>
>
> [ Upstream commit 46d179525a1f6d16957dcb4624517bc04142b3e7 ]
>
> According to the DesignWare state machine description, after we get a
> "response error" or "response CRC error" we move into data transfer
> mode. That means that we don't necessarily need to special case
> trying to deal with the failure right away. We can wait until we are
> notified that the data transfer is complete (with or without errors)
> and then we can deal with the failure.
>
> It may sound strange to defer dealing with a command that we know will
> fail anyway, but this appears to fix a bug. During tuning (CMD19) on
> a specific card on an rk3288-based system, we found that we could get
> a "response CRC error". Sending the stop command after the "response
> CRC error" would then throw the system into a confused state causing
> all future tuning phases to report failure.
>
> When in the confused state, the controller would show these (hex codes
> are interrupt status register):
>  CMD ERR: 0x00000046 (cmd=3D19)
>  CMD ERR: 0x0000004e (cmd=3D12)
>  DATA ERR: 0x00000208
>  DATA ERR: 0x0000020c
>  CMD ERR: 0x00000104 (cmd=3D19)
>  CMD ERR: 0x00000104 (cmd=3D12)
>  DATA ERR: 0x00000208
>  DATA ERR: 0x0000020c
>  ...
>  ...
>
> It is inherently difficult to deal with the complexity of trying to
> correctly send a stop command while a data transfer is taking place
> since you need to deal with different corner cases caused by the fact
> that the data transfer could complete (with errors or without errors)
> during various places in sending the stop command (dw_mci_stop_dma,
> send_stop_abort, etc)
>
> Instead of adding a bunch of extra complexity to deal with this, it
> seems much simpler to just use the more straightforward (and less
> error-prone) path of letting the data transfer finish. There
> shouldn't be any huge benefit to sending the stop command slightly
> earlier, anyway.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> Cc: Alim Akhtar <alim.akhtar@gmail.com>
> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This commit also requires the following modifications:
  ba2d139b02ba68: mmc: dw_mmc: Fix occasional hang after tuning on eMMC

Please apply this commit too.

Best regards,
  Nobuhiro


> ---
>  drivers/mmc/host/dw_mmc.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 581f5d0271f4..afdf539e06e9 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1744,6 +1744,33 @@ static void dw_mci_tasklet_func(unsigned long priv=
)
>                         }
>
>                         if (cmd->data && err) {
> +                               /*
> +                                * During UHS tuning sequence, sending th=
e stop
> +                                * command after the response CRC error w=
ould
> +                                * throw the system into a confused state
> +                                * causing all future tuning phases to re=
port
> +                                * failure.
> +                                *
> +                                * In such case controller will move into=
 a data
> +                                * transfer state after a response error =
or
> +                                * response CRC error. Let's let that fin=
ish
> +                                * before trying to send a stop, so we'll=
 go to
> +                                * STATE_SENDING_DATA.
> +                                *
> +                                * Although letting the data transfer tak=
e place
> +                                * will waste a bit of time (we already k=
now
> +                                * the command was bad), it can't cause a=
ny
> +                                * errors since it's possible it would ha=
ve
> +                                * taken place anyway if this tasklet got
> +                                * delayed. Allowing the transfer to take=
 place
> +                                * avoids races and keeps things simple.
> +                                */
> +                               if ((err !=3D -ETIMEDOUT) &&
> +                                   (cmd->opcode =3D=3D MMC_SEND_TUNING_B=
LOCK)) {
> +                                       state =3D STATE_SENDING_DATA;
> +                                       continue;
> +                               }
> +
>                                 dw_mci_stop_dma(host);
>                                 send_stop_abort(host, data);
>                                 state =3D STATE_SENDING_STOP;
> --
> 2.30.2
>


--=20
Nobuhiro Iwamatsu
   iwamatsu at {nigauri.org / debian.org}
   GPG ID: 40AD1FA6

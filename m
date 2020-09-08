Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1459260BF1
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 09:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729295AbgIHH1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 03:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgIHH1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 03:27:48 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E8CC061573;
        Tue,  8 Sep 2020 00:27:47 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j2so17945113wrx.7;
        Tue, 08 Sep 2020 00:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KOkWytvEQvcwRPaTbbeU+nJ2kZpJZSrQDxi081fe4SY=;
        b=VYOBXZVmm6Me9qi2cd3T0B/OHWxYd9Ambemd6O5THwOeqoYikp+sY/gKnIm7j4SjE5
         nVFpiqk8CNOhnkwk3Z0bUqDXZyYc4d7SD2dAsnn9g4HyCLk+kXTqxBr8ly6SsM6zBBLO
         w/n7zcnOX9DC9ykasRnl+a2R/+yCpi25q5t9LQbCKdpGjiZzaA6DUGUWU/v+zKU41Xah
         3v+dN1tAuBLvJ41uDHHJUI+9N+fy04RyuaKu0eeVLtMxE00q16uOds4Z2hnuFvdDat/d
         4f9Dop7JC5IP6sZlOgVPP54Q+Epr3d78yyyDtWgtGftL/frpXXVK3527GizQK67Bel0P
         /fxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KOkWytvEQvcwRPaTbbeU+nJ2kZpJZSrQDxi081fe4SY=;
        b=oKBe8PwCAO7QIXyryiLbh3eMeJ0zIWc6Xb0nOTtjRkPoAp4EFJw88OpEkTItUIetAq
         eO39rZdvWerHtVMNiLM/mk6R3phH7DpTLusTUxtVAJBDpTnVGuBAf2rkMbRWsjwKMD1P
         awgNOkkokmJ+IZIMJ18N7m4l8R7SxgyH4dT5Sc/GMQ2zvzij9KOhCM40IlCYbizfy1x0
         BlpP9zDOKXnw+FDI/gSqEdNktTJ9m9DUWCIBS03w/hgiEp/1zeate5CT5yBBKHMxEof9
         oUVPgXJcyTDFoxN2Tl/kTqBlmn746+MW6KTeadYyHKs6w3ByS4uCQsWl1Cs+ijqtACUb
         zoKQ==
X-Gm-Message-State: AOAM530NlEf3j64Y+hZWGXoOsR4I78ZFMpf/ztpQARz+RUAg+e6n4I8D
        jhmtQfDIcJgREEDAz/IeGPg/34wc6F9U2L2Xn0E=
X-Google-Smtp-Source: ABdhPJzy45/B81xFTZ9qjxIyvVXE4rPehBDIzrqnJqdm5h0UGpJq905XCRaEh6NE80cNlJ8M295wsyMpnc8KnrLSWF8=
X-Received: by 2002:a05:6000:36d:: with SMTP id f13mr24484491wrf.425.1599550066606;
 Tue, 08 Sep 2020 00:27:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200901152713.18629-1-krzk@kernel.org>
In-Reply-To: <20200901152713.18629-1-krzk@kernel.org>
From:   Chunyan Zhang <zhang.lyra@gmail.com>
Date:   Tue, 8 Sep 2020 15:27:10 +0800
Message-ID: <CAAfSe-u6Prn=nnX8Y67DearNEuHH90Fo71R7hmxbvWGuPxyk2w@mail.gmail.com>
Subject: Re: [PATCH 01/11] spi: sprd: Release DMA channel also on probe deferral
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-spi@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-tegra@vger.kernel.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Sep 2020 at 23:27, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> If dma_request_chan() for TX channel fails with EPROBE_DEFER, the RX
> channel would not be released and on next re-probe it would be requested
> second time.
>
> Fixes: 386119bc7be9 ("spi: sprd: spi: sprd: Add DMA mode support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Acked-by: Chunyan Zhang <zhang.lyra@gmail.com>

Thanks,
Chunyan

> ---
>  drivers/spi/spi-sprd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/spi/spi-sprd.c b/drivers/spi/spi-sprd.c
> index 6678f1cbc566..0443fec3a6ab 100644
> --- a/drivers/spi/spi-sprd.c
> +++ b/drivers/spi/spi-sprd.c
> @@ -563,11 +563,11 @@ static int sprd_spi_dma_request(struct sprd_spi *ss)
>
>         ss->dma.dma_chan[SPRD_SPI_TX]  = dma_request_chan(ss->dev, "tx_chn");
>         if (IS_ERR_OR_NULL(ss->dma.dma_chan[SPRD_SPI_TX])) {
> +               dma_release_channel(ss->dma.dma_chan[SPRD_SPI_RX]);
>                 if (PTR_ERR(ss->dma.dma_chan[SPRD_SPI_TX]) == -EPROBE_DEFER)
>                         return PTR_ERR(ss->dma.dma_chan[SPRD_SPI_TX]);
>
>                 dev_err(ss->dev, "request TX DMA channel failed!\n");
> -               dma_release_channel(ss->dma.dma_chan[SPRD_SPI_RX]);
>                 return PTR_ERR(ss->dma.dma_chan[SPRD_SPI_TX]);
>         }
>
> --
> 2.17.1
>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2839220357F
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 13:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgFVLSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 07:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbgFVLSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 07:18:02 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC05C061794;
        Mon, 22 Jun 2020 04:18:02 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dp18so17595287ejc.8;
        Mon, 22 Jun 2020 04:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zTuD0pvK9ddq/193/N5U9u32frcmzUdwxwqpfYQjgV4=;
        b=c/FVEizNmu//8AR+7hIlH701rjkqL2J9o+1R3gDqO39I/P87WYgoh3pF/1txlnGZyb
         HrKnL88xf8Fr8Jr77DlaTDoD5BfWGYTKDvMLKiUDN8tXqUX3PRb61sTYbbdkZ5XRghcV
         vN23fcOSigXZD+EEc9pN4M56c4lxjZ44nsRsVtuujT7b4/rdeebdRNhMeqPPbhYiDk+d
         ed/G1jgJcdT3fYoTpIO82l5DNG95iCcWwzeku6+YWvMk7tR+VcBI8JsN1Flq2TZ+lRF9
         XQFGXwpKGTCmnkC6uHt76uvBU9uy1YhS7SiHuYYIyE2CQgn1+tkVHoP8LsbMm7WeJ+g8
         IgfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zTuD0pvK9ddq/193/N5U9u32frcmzUdwxwqpfYQjgV4=;
        b=gw1R80k2klntpRG17NRe1eKm/+Q/esP68asQR9YGUh2oniR77lniH5mM9XCSVNLAWO
         uEPU9gksQilWaqVu4I3nupmX321R6BumKnNr+yDGAjk9a4AiBoplHZVVxsqUHcP0vk3k
         Ioxa3UB9r7t8LmE/++JBLbKu35qJhEZW5eG/gRWlBC2fWC+4kWdQxg8tRXBDmUZ+iWVN
         kU8kAF21whGt6rq2A/06f+UsN83avrrnH4BhEBkgPomEmzNN9jPXVHrkgckRGukUrBBd
         b2DVN5tCYlE3FdhskWBEd41iQ4ult2DAuXRX+2XxYWcAH7xLgPlE4+kS5g9WeWb4bYPQ
         /7ng==
X-Gm-Message-State: AOAM531yfl4i51/gviNnfdqy54FddsnEXpW8TjkIB4nlq/XxwC+uG1X3
        nQGTo7lMk6RD1tEh2ByV26B11yOQ1rjo5QtafDM=
X-Google-Smtp-Source: ABdhPJwttZ0XVywCYT66vUFeQ/CJWzTALslMCl4YzEdZZqWY491buLqoD4N2QmCEJ4OC/PBuo+Evi5yTO8YgflNYVSM=
X-Received: by 2002:a17:906:492:: with SMTP id f18mr5336759eja.279.1592824681148;
 Mon, 22 Jun 2020 04:18:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200622110543.5035-1-krzk@kernel.org> <20200622110543.5035-2-krzk@kernel.org>
In-Reply-To: <20200622110543.5035-2-krzk@kernel.org>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 22 Jun 2020 14:17:50 +0300
Message-ID: <CA+h21hr+P6hq52jpLSR0xo8QKi-5aRUE2n4yeumSbrdUOJsgFQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] spi: spi-fsl-dspi: Fix lockup if device is
 shutdown during SPI transfer
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>, Peng Ma <peng.ma@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Jun 2020 at 14:08, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> During shutdown, the driver should unregister the SPI controller
> and stop the hardware.  Otherwise the dspi_transfer_one_message() could
> wait on completion infinitely.
>
> Additionally, calling spi_unregister_controller() first in device
> shutdown reverse-matches the probe function, where SPI controller is
> registered at the end.
>
> Fixes: dc234825997e ("spi: spi-fsl-dspi: Adding shutdown hook")
> Cc: <stable@vger.kernel.org>
> Reported-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>
> kexec() not tested, only system shutdown.
>
> Changes since v3:
> 1. New patch.
> ---
>  drivers/spi/spi-fsl-dspi.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
>
> diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
> index ec0fd0d366eb..ec7919d9c0d9 100644
> --- a/drivers/spi/spi-fsl-dspi.c
> +++ b/drivers/spi/spi-fsl-dspi.c
> @@ -1452,20 +1452,7 @@ static int dspi_remove(struct platform_device *pdev)
>
>  static void dspi_shutdown(struct platform_device *pdev)
>  {
> -       struct spi_controller *ctlr = platform_get_drvdata(pdev);
> -       struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);
> -
> -       /* Disable RX and TX */
> -       regmap_update_bits(dspi->regmap, SPI_MCR,
> -                          SPI_MCR_DIS_TXF | SPI_MCR_DIS_RXF,
> -                          SPI_MCR_DIS_TXF | SPI_MCR_DIS_RXF);
> -
> -       /* Stop Running */
> -       regmap_update_bits(dspi->regmap, SPI_MCR, SPI_MCR_HALT, SPI_MCR_HALT);
> -
> -       dspi_release_dma(dspi);
> -       clk_disable_unprepare(dspi->clk);
> -       spi_unregister_controller(dspi->ctlr);
> +       dspi_remove(pdev);
>  }
>
>  static struct platform_driver fsl_dspi_driver = {
> --
> 2.17.1
>

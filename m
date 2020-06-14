Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491ED1F888C
	for <lists+stable@lfdr.de>; Sun, 14 Jun 2020 13:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgFNLO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jun 2020 07:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgFNLO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jun 2020 07:14:27 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA45C05BD43;
        Sun, 14 Jun 2020 04:14:27 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id s28so7379023edw.11;
        Sun, 14 Jun 2020 04:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ED3h3EXXfTCLRR9+3wTxrVE3ldaqz7FtCzqR4tZbLdg=;
        b=LMLleMBIzLSrJyibtHMZuEBHOyKoKt6QUU2DRycKzCu/MgLZv+MxHRxwa6Zw4S9uDr
         stVxzzZDeFLp4AtAsKsgc5mhMuVTdU41yqPn8yY8gsPA1GXnrIVRV2cwQq0XxoXbjwXv
         XoJ85H0d5mt7y7f7w9CjR9ByK0BUWUYcejf199G+6fWQXurm0ZRXUlxdS5FfnucJw57d
         6Wgkc5oOjEiw9Ez10gEFa/7s1wz4ihHyVMrYIt1Ke9q2pTNX2IX82lilxkmFjbqUvyKr
         9V59wlfADUoTzK/9POGpoSvpSe1HEq40grKfWDDubDZAQR9OGuHoD0azViYRb3c4Y1Au
         Ppbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ED3h3EXXfTCLRR9+3wTxrVE3ldaqz7FtCzqR4tZbLdg=;
        b=DQUGJNzxcSyL07fT/fvW24RkXHf3BvzSWI7u4mQ6xNFpW3jnnVfAb67W46rKV9cwz+
         kTDqIqox4IU39PNAGq71T4mxqhUtk9oI8Blk5lnvo2+qgpwHw/KI49Rlk3Q1SWeR2PLd
         PVV5GEcUzrpbZF8jW7MyzNQwoV+bMjkLopzCM36PkfFE5tTSQN4Ian9zBzTTM7P/FhjD
         Q3TNZqicine7Z6ZL9R76UytJY+C4X8ASZvrlwHkh5X8KKrMR4aqmhWxzrhDDSeJwGJIs
         t4w6ToFQ0H9jzooygq9RXviU0GBck7iyN4wPJGS+Lb6TNQrGFPYtOpHtoh6YonTlrnJJ
         h3XQ==
X-Gm-Message-State: AOAM531U7D8m6XzTvu8y2XOi+tGgmnXntQyv9ATAx0kkYjiPYp9adz7n
        CRHTNAPPxzfs0cEp0eiJQ6FTYktEHoTPf3zLWh0=
X-Google-Smtp-Source: ABdhPJyPnaJ4BjcnebsrqdADJqqfslllyRBBt6esfDqbtn0UUL9VzRGCnFhRiepLeJuhAre5OrmgLlpXte2OADefVdw=
X-Received: by 2002:aa7:dc50:: with SMTP id g16mr20191572edu.318.1592133265843;
 Sun, 14 Jun 2020 04:14:25 -0700 (PDT)
MIME-Version: 1.0
References: <1592132154-20175-1-git-send-email-krzk@kernel.org> <1592132154-20175-2-git-send-email-krzk@kernel.org>
In-Reply-To: <1592132154-20175-2-git-send-email-krzk@kernel.org>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 14 Jun 2020 14:14:15 +0300
Message-ID: <CA+h21ho_pa0H2MG-aAmUCFj37aYW4es-2V75P4KL-Zjq7qtfRQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] spi: spi-fsl-dspi: Initialize completion before
 possible interrupt
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 14 Jun 2020 at 13:56, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> If interrupt fires early, the dspi_interrupt() could complete
> (dspi->xfer_done) before its initialization happens.
>
> Fixes: 4f5ee75ea171 ("spi: spi-fsl-dspi: Replace interruptible wait queue with a simple completion")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---

Why would an interrupt fire before spi_register_controller, therefore
before dspi_transfer_one_message could get called?
Is this master or slave mode?

>  drivers/spi/spi-fsl-dspi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
> index 57e7a626ba00..efb63ed9fd86 100644
> --- a/drivers/spi/spi-fsl-dspi.c
> +++ b/drivers/spi/spi-fsl-dspi.c
> @@ -1385,6 +1385,8 @@ static int dspi_probe(struct platform_device *pdev)
>                 goto poll_mode;
>         }
>
> +       init_completion(&dspi->xfer_done);
> +
>         ret = request_threaded_irq(dspi->irq, dspi_interrupt, NULL,
>                                    IRQF_SHARED, pdev->name, dspi);
>         if (ret < 0) {
> @@ -1392,8 +1394,6 @@ static int dspi_probe(struct platform_device *pdev)
>                 goto out_clk_put;
>         }
>
> -       init_completion(&dspi->xfer_done);
> -
>  poll_mode:
>
>         if (dspi->devtype_data->trans_mode == DSPI_DMA_MODE) {
> --
> 2.7.4
>

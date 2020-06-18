Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283D21FFD67
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 23:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgFRVaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 17:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgFRVaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 17:30:06 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADF2C06174E;
        Thu, 18 Jun 2020 14:30:06 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id n24so8002922ejd.0;
        Thu, 18 Jun 2020 14:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ykZ4SZiO2L+lGiylinFmtfZd/XWsNghkreDxSemBMeE=;
        b=ahi68J1fAzlWZjWzkcRtSZkzQJL3AsR80bjgBccnIzL4RnNYXbhdiKNQQhjKBsko0y
         u9uziEUbNTnfkCSpULCtUN9zQ6bNQOjqPVShsNRoz1K9K+JF8CB9f/vEFnZtfMxhvG42
         iBJm43VT6tsXyqR65VfzQaWtiMwUT8VnwHz17TWm5/RbQ4nZChOeoqPOwyLsqwWP9Y0k
         ToLNpG85Z+j34wdo8c+8cBxC3RkvzJZbR2EO8reW9dL+Wd/JPJ49sx7umytySAVWo5eQ
         HNIrDLyasm/DYk3oyAuWCjnfoYNPqoEfD9s/V/zNJ0zqZ4YptC5RD+n/EnYrJcpZYOyS
         Fh0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ykZ4SZiO2L+lGiylinFmtfZd/XWsNghkreDxSemBMeE=;
        b=gnknt3FyrRWzxE++a80ng0Tbt5sKvxOOb3xvgEWoTds6w5ams5Q/JODdC3P6AWiU3X
         fgRPSYwq29Mv/tWV5xNGqRBSXmRIN9936amBf7e9XrAQ/S0bQ646n3+kwjumxhIu0H6m
         3gt5kojdzmGiPiVV/3hjBIcc7xtWmqOG7uEOfPPxLZd1YEXO4vUaxmy2lbNF3Ic9EkFo
         pGmvEKFofihShwDHVlK4Uh+THecwGsOugn75urLS8wxdJNCD+eIIylEJ1TDPEAY+4ou6
         Z3YmtsxiA1hzkDFKgUrOZwP+JF4A6OKrYAdE78r2wxOWibuwp2n5nhHxws+SgK5gYCVe
         XkRg==
X-Gm-Message-State: AOAM532M6YdD5LpPalwpzxTvboftdII/zBsjgqAEI/X2n9yLob9j9DyD
        jzRfq1escn9HJXrHyYRhNAJ0xoUYe/Q1XYQ10xmtHQ==
X-Google-Smtp-Source: ABdhPJx2itWXtg2D1eefNsa/RWOUObRSyv88SL+3ci7UXhYLVVf5K8shCG2o83AbLlnaaFWqUJki/IhMpyJ7LjymJzo=
X-Received: by 2002:a17:906:1d56:: with SMTP id o22mr661899ejh.406.1592515805136;
 Thu, 18 Jun 2020 14:30:05 -0700 (PDT)
MIME-Version: 1.0
References: <1592300467-29196-1-git-send-email-krzk@kernel.org> <1592300467-29196-2-git-send-email-krzk@kernel.org>
In-Reply-To: <1592300467-29196-2-git-send-email-krzk@kernel.org>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 19 Jun 2020 00:29:54 +0300
Message-ID: <CA+h21hr93QUsi_ebHXOJfQ81m6N+N0=yYoTYpV4wzZoMA8MFXg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] spi: spi-fsl-dspi: Initialize completion before
 possible interrupt
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Krzysztof,

On Tue, 16 Jun 2020 at 12:42, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> The interrupt handler calls completion and is IRQ requested before the
> completion is initialized.  Logically it should be the other way.
>
> Fixes: 4f5ee75ea171 ("spi: spi-fsl-dspi: Replace interruptible wait queue with a simple completion")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
>
> ---

I fail to see any good reason why this patch would go to a stable kernel.

>
> Changes since v2:
> 1. None
>
> Changes since v1:
> 1. Rework the commit msg.
> ---
>  drivers/spi/spi-fsl-dspi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
> index 7ecc90ec8f2f..51e0bf617b16 100644
> --- a/drivers/spi/spi-fsl-dspi.c
> +++ b/drivers/spi/spi-fsl-dspi.c
> @@ -1389,6 +1389,8 @@ static int dspi_probe(struct platform_device *pdev)
>                 goto poll_mode;
>         }
>
> +       init_completion(&dspi->xfer_done);
> +
>         ret = request_threaded_irq(dspi->irq, dspi_interrupt, NULL,
>                                    IRQF_SHARED, pdev->name, dspi);
>         if (ret < 0) {
> @@ -1396,8 +1398,6 @@ static int dspi_probe(struct platform_device *pdev)
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

Thanks,
-Vladimir

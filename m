Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C299E20358A
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 13:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgFVLVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 07:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728664AbgFVLRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 07:17:39 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C91C061794;
        Mon, 22 Jun 2020 04:17:38 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id k11so17594466ejr.9;
        Mon, 22 Jun 2020 04:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TZiwZIrCsEEo6wwyPFdJPE4K71P6aGthJLmX8PuGg2U=;
        b=YYNlxB3Uju5mOajQTpUA4vt4nTLtkKo0voPP61L+DegsW9AcPKRSvzXweV6r3OZKDS
         ZPR1tKH6zK2JInKbEmi3gMXOO2R9tmGL45IRX/tOT3pq1pY2tJ/Le0qZvcNfCN5MYYvJ
         jKdm1rJOiDRG5Hn9FUMmuUO+qJa2cqya3dr2ZQl9bLMTTjEf1kLlwmTnxNUsevwQG4E7
         mAeXziqLLgNBJrhvQ8Xiib4UU08aWyCVVSnivJm3Vsx4F0zno9jlet3oNyIGO8LSE76j
         kloffnQrKGSfYFYuXzWcf/MD5XbQB48LfbBYX9sPz5LnuvDng0JgzQj9IDZKbTY7NMaJ
         mE3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TZiwZIrCsEEo6wwyPFdJPE4K71P6aGthJLmX8PuGg2U=;
        b=oWWVURlv1qg1usXADoVJPbCYw8ZTwk6JnmTsywjIKLuvjWcq7hnHYGnX4kx80kNNwp
         Qf3PmFO5pqGzPEdkmpMtDPwOKbUMYW83uH42kZ4aZypHHowvK88qNRjhgpaRh9x4xqx/
         aaloy1bO0LJ1b93el/lKtEaPWw4QPa82SNNnwMJM1YEQqPlqqNZhQvh+Ua2N/gmm2Aw6
         0hz9fUGXzm4NiKHKkShPB2urQfZijJNzzknSQobzz9lIhgudwGNr3hYXJMpyq97aGNxd
         13WnIPPG03pSgIeK/6o0ZFmYK0cQ9E7Sw3PO3xSxnkDmaHGrHYX/iEHgtdnlyWiCVX4/
         YSsg==
X-Gm-Message-State: AOAM533rFf936+madbWBOAz1urbJ9pj5AACRsspLm6R0wg2hT8yrFfsq
        8ZEBjvs5XOCwzNZUgZzCUSKO56tyQ+y6T2voUjo=
X-Google-Smtp-Source: ABdhPJyP1teXpZMQJBSy6XRfAPiUcGdFA51dFuisvct6xWquwQV7kcR13vg76tHLi5aN+VwYBucVCdFLkuJU6CUrNpU=
X-Received: by 2002:a17:906:2e50:: with SMTP id r16mr14796322eji.305.1592824657403;
 Mon, 22 Jun 2020 04:17:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200622110543.5035-1-krzk@kernel.org>
In-Reply-To: <20200622110543.5035-1-krzk@kernel.org>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 22 Jun 2020 14:17:26 +0300
Message-ID: <CA+h21hqQLaghmEYso9ZMeJHQuiDMgi5UN9-06je84_0n9iripA@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] spi: spi-fsl-dspi: Fix lockup if device is removed
 during SPI transfer
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

On Mon, 22 Jun 2020 at 14:06, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> During device removal, the driver should unregister the SPI controller
> and stop the hardware.  Otherwise the dspi_transfer_one_message() could
> wait on completion infinitely.
>
> Additionally, calling spi_unregister_controller() first in device
> removal reverse-matches the probe function, where SPI controller is
> registered at the end.
>
> Fixes: 05209f457069 ("spi: fsl-dspi: add missing clk_disable_unprepare() in dspi_remove()")
> Cc: <stable@vger.kernel.org>
> Reported-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>
> Changes since v3:
> 1. New patch.
> ---
>  drivers/spi/spi-fsl-dspi.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
> index 58190c94561f..ec0fd0d366eb 100644
> --- a/drivers/spi/spi-fsl-dspi.c
> +++ b/drivers/spi/spi-fsl-dspi.c
> @@ -1434,9 +1434,18 @@ static int dspi_remove(struct platform_device *pdev)
>         struct fsl_dspi *dspi = spi_controller_get_devdata(ctlr);
>
>         /* Disconnect from the SPI framework */
> +       spi_unregister_controller(dspi->ctlr);
> +
> +       /* Disable RX and TX */
> +       regmap_update_bits(dspi->regmap, SPI_MCR,
> +                          SPI_MCR_DIS_TXF | SPI_MCR_DIS_RXF,
> +                          SPI_MCR_DIS_TXF | SPI_MCR_DIS_RXF);
> +
> +       /* Stop Running */
> +       regmap_update_bits(dspi->regmap, SPI_MCR, SPI_MCR_HALT, SPI_MCR_HALT);
> +
>         dspi_release_dma(dspi);
>         clk_disable_unprepare(dspi->clk);
> -       spi_unregister_controller(dspi->ctlr);
>
>         return 0;
>  }
> --
> 2.17.1
>

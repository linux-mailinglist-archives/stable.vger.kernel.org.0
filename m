Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3FC62A034
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 18:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiKORYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 12:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbiKORYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 12:24:43 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80188252B8;
        Tue, 15 Nov 2022 09:24:42 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id l2so13752916pld.13;
        Tue, 15 Nov 2022 09:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xc5csCyHnP/k7L77v/+McWwIPnI6MnCC2Uk0vP8Ve7M=;
        b=CcajGkdqwVHA5iHM028V119bOfmakt04BU3AHIfjB12cWtWWJtxJzWwVjSgdK9GPON
         oyr8tIGm6XLpd7gCK7mwWYb/bSP0r7SdbL74vSwl2cjQhpj8Dv2nyeFKY16wrz7Tl69e
         2ri9vZcKja2GEJYBsfHe7qh4bSj7nybzz3yyWdbmdCG3JYOA/RyjUYBQtUv+aunoIyvn
         epiAERLSDsC1MpSN7DY/bvtSn7kL4skrGTPWcWcVppmadjoAXnoCVz87vvvT4dy1vfDC
         TnKlvyUwIhwOI2VveLGps2Xtvyvi49Gt6VupGIn0+R1e+A2A+7HzMX+6tJLme59q/2zn
         at7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xc5csCyHnP/k7L77v/+McWwIPnI6MnCC2Uk0vP8Ve7M=;
        b=7ihGthdN7C32ppdrEbrJHTAQeM1lGRdU1LyQ02F9T7RpzySsZ/5MzQpcIVRcaaNI+x
         RI+kv5PGSBRrmrrArISgWGCUfGDnjv/+9ozdoHbCBoBmmEe3BCWAQAZAxq0590ouL0Np
         Y2Qr3NeoEccWh1I9O/rkDr4QZhMh+AG7/geXyrjy3SMcQYrC1TiI5NxByB7PUtM+LSvJ
         Ev+jQr1TaGBEfvy1iHM3AZXWbsUZCgp5x7iH+eyRjDbcVbJhG2eaj17KC9N6HKTo8kbo
         +dVoi1d+H7p/I/s+ULe00Md2aUFgvGffwQlPs1qR2YQLFGH5AZMzTPfDPyil1N+0Swr4
         4mfQ==
X-Gm-Message-State: ANoB5plhuvMlobC6CkvlojWK8Ubjo93JNjZhFQ7Zk+gaAdPGrKjW/w4P
        9/3o4I7LBtN9E/VV0FyiXbg2S/3tq/aWyZMMQyw=
X-Google-Smtp-Source: AA0mqf6D2D8zz7o8Jr/zeZfYFOQEGRjsHxF3dTs6zxLdMf5s6WaYptKqxgGJEqxh/K5UpBPlj7bVVLqzQQntSN1B5dw=
X-Received: by 2002:a17:90a:de96:b0:214:132a:2b90 with SMTP id
 n22-20020a17090ade9600b00214132a2b90mr1482901pjv.195.1668533081732; Tue, 15
 Nov 2022 09:24:41 -0800 (PST)
MIME-Version: 1.0
References: <20221115162654.2016820-1-frieder@fris.de>
In-Reply-To: <20221115162654.2016820-1-frieder@fris.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 15 Nov 2022 14:24:24 -0300
Message-ID: <CAOMZO5BEYhGS-nRuiTr6veujLM=k7bP9hHHCy6X62hfFzyLh_A@mail.gmail.com>
Subject: Re: [PATCH v2] spi: spi-imx: Fix spi_bus_clk if requested clock is
 higher than input clock
To:     Frieder Schrempf <frieder@fris.de>
Cc:     David Jander <david@protonic.nl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Marek Vasut <marex@denx.de>, stable@vger.kernel.org,
        Baruch Siach <baruch.siach@siklu.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 15, 2022 at 1:27 PM Frieder Schrempf <frieder@fris.de> wrote:
>
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>
> In case the requested bus clock is higher than the input clock, the correct
> dividers (pre = 0, post = 0) are returned from mx51_ecspi_clkdiv(), but
> *fres is left uninitialized and therefore contains an arbitrary value.
>
> This causes trouble for the recently introduced PIO polling feature as the
> value in spi_imx->spi_bus_clk is used there to calculate for which
> transfers to enable PIO polling.
>
> Fix this by setting *fres even if no clock dividers are in use.
>
> This issue was observed on Kontron BL i.MX8MM with an SPI peripheral clock set
> to 50 MHz by default and a requested SPI bus clock of 80 MHz for the SPI NOR
> flash.
>
> With the fix applied the debug message from mx51_ecspi_clkdiv() now prints the
> following:
>
> spi_imx 30820000.spi: mx51_ecspi_clkdiv: fin: 50000000, fspi: 50000000,
> post: 0, pre: 0
>
> Fixes: 07e759387788 ("spi: spi-imx: add PIO polling support")
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: David Jander <david@protonic.nl>
> Cc: Fabio Estevam <festevam@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Marek Vasut <marex@denx.de>
> Cc: stable@vger.kernel.org
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>

Thanks for the fix:

Tested-by: Fabio Estevam <festevam@gmail.com>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A90E62AFA9
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 00:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiKOXtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 18:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiKOXtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 18:49:13 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3DBD2E9;
        Tue, 15 Nov 2022 15:49:11 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id E3904851B2;
        Wed, 16 Nov 2022 00:49:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1668556149;
        bh=31yr6ZgXFXDXweBdQrEwTiSggKicUZ/huC49zRMLSfg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=io9oqNvJWp3SW6vQybIXU0ZJYQ13PBHm8+dGSYl8m1PZemDnEhAwhu0m9Bm2YJ963
         qzsR3mOsLVxSV/VYN55G1MjL1EWMuz3vHokgNjSh2sOQeOcvCSgMILnRs9V0YPv6fc
         aNKv/tTP92Ntrfk1RC9+2YW40mTkFSb3RWaSIaChnemE0xXoY+n+5FzyXGTtZe+87E
         w2AnfYVRW0M3RMlbfLNP0CVxCQI968hL2Shq6+i/OZdMTCk7dP8iLdgH+8tEu3lXvM
         8y2wD63l7yeeRd+SddXbNDuVwa3RYwpLBnHs4tww4qu3+i66MPQi6DfvIBcanrXa9F
         eBNHjoGTEcUZQ==
Message-ID: <7b31dd4d-a74c-1013-491f-81538001917e@denx.de>
Date:   Wed, 16 Nov 2022 00:49:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v3] spi: spi-imx: Fix spi_bus_clk if requested clock is
 higher than input clock
Content-Language: en-US
To:     Frieder Schrempf <frieder@fris.de>,
        David Jander <david@protonic.nl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Baruch Siach <baruch.siach@siklu.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20221115181002.2068270-1-frieder@fris.de>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <20221115181002.2068270-1-frieder@fris.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/22 19:10, Frieder Schrempf wrote:
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
> Fixes: 6fd8b8503a0d ("spi: spi-imx: Fix out-of-order CS/SCLK operation at low speeds")
> Fixes: 07e759387788 ("spi: spi-imx: add PIO polling support")
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: David Jander <david@protonic.nl>
> Cc: Fabio Estevam <festevam@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Marek Vasut <marex@denx.de>
> Cc: stable@vger.kernel.org
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> Tested-by: Fabio Estevam <festevam@gmail.com>
> ---
> 
> Changes for v3:
> 
> * Add back the Fixes tag for commit 6fd8b8503a0d
> * Add Fabio's Tested-by (Thanks!)
> 
> Changes for v2:
> 
> * Remove the reference and the Fixes tag for commit 6fd8b8503a0d as it is
>    incorrect.
> ---
>   drivers/spi/spi-imx.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
> index 30d82cc7300b..468ce0a2b282 100644
> --- a/drivers/spi/spi-imx.c
> +++ b/drivers/spi/spi-imx.c
> @@ -444,8 +444,7 @@ static unsigned int mx51_ecspi_clkdiv(struct spi_imx_data *spi_imx,
>   	unsigned int pre, post;
>   	unsigned int fin = spi_imx->spi_clk;
>   
> -	if (unlikely(fspi > fin))
> -		return 0;
> +	fspi = min(fspi, fin);
>   
>   	post = fls(fin) - fls(fspi);
>   	if (fin > fspi << post)

Can you also test the SPI flash at some 100 kHz, just to see whether it 
still works properly ? (to retain behavior fixed first in 6fd8b8503a0dc 
("spi: spi-imx: Fix out-of-order CS/SCLK operation at low speeds") )

The fix here does look fine by me however.

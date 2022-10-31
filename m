Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C485612E4B
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 01:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiJaAeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 20:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaAeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 20:34:14 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDE35F99;
        Sun, 30 Oct 2022 17:34:13 -0700 (PDT)
Received: from [192.168.2.128] (unknown [109.252.112.196])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dmitry.osipenko)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 922BE66022B7;
        Mon, 31 Oct 2022 00:34:10 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1667176451;
        bh=Se05eSRLeRPRO0tc082b+iLshP4XonM5++oF0adSkAI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Kzrirl3ONp4LtQFGuzyI0m5aHKfmlXlo6Pe0cA1TRZHn7qg4Xv7X/O159iBZYWnsE
         yEGDyUZ35tq7stW/LoGr/+Br37yVacOy2ZI2gUX7DIfF2dWpsh5MgYrLFp5oMgDqPc
         tGnUsZwJLnax+xygQxCillBNzsu3mQ4kfxlsmJiJ+0pcTrwaB4Ug293Asm8sFwaVDa
         rXMuSo65aTRr366VvNRETLo38gbnV/J1ikmoHo6K3y/QqlNr1C3po7l+qmKZvFAnl7
         pqoA18i1/AegbE/3JV7UEcecmCqYSYA4aK+1zCA+Av2xTDrTKcgsBCTKSl9UZKu//T
         TOnvoCnZW4mFg==
Message-ID: <603a0227-7d25-b9da-6dc3-fa9fe1b951e7@collabora.com>
Date:   Mon, 31 Oct 2022 03:34:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] clk: tegra: fix HOST1X clock divider on Tegra20 and
 Tegra30
To:     luca.ceresoli@bootlin.com, linux-tegra@vger.kernel.org
Cc:     Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        stable@vger.kernel.org
References: <20221028074826.2317640-1-luca.ceresoli@bootlin.com>
Content-Language: en-US
From:   Dmitry Osipenko <dmitry.osipenko@collabora.com>
In-Reply-To: <20221028074826.2317640-1-luca.ceresoli@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/28/22 10:48, luca.ceresoli@bootlin.com wrote:
> From: Luca Ceresoli <luca.ceresoli@bootlin.com>
> 
> On Tegra20 and Tegra30 the HOST1X clock is a fractional clock divider with
> 7 integer bits + 1 decimal bit. This has been verified on both
> documentation and real hardware for Tegra20 an on the documentation I was
> able to find for Tegra30.
> 
> However in the kernel code this clock is declared as an integer divider. A
> consequence of this is that requesting 144 MHz for HOST1X which is fed by
> pll_p running at 216 MHz would result in 108 MHz (216 / 2) instead of 144
> MHz (216 / 1.5).
> 
> Fix by replacing the INT() macro with the MUX() macro which, despite the
> name, defines a fractional divider. The only difference between the two
> macros is the former does not have the TEGRA_DIVIDER_INT flag.
> 
> Also move the line together with the other MUX*() ones to keep the existing
> file organization.
> 
> Fixes: 76ebc134d45d ("clk: tegra: move periph clocks to common file")
> Cc: stable@vger.kernel.org
> Cc: Peter De Schrijver <pdeschrijver@nvidia.com>
> Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
> ---
>  drivers/clk/tegra/clk-tegra-periph.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
> index 4dcf7f7cb8a0..806d835ca0d2 100644
> --- a/drivers/clk/tegra/clk-tegra-periph.c
> +++ b/drivers/clk/tegra/clk-tegra-periph.c
> @@ -615,7 +615,6 @@ static struct tegra_periph_init_data periph_clks[] = {
>  	INT("vde", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_VDE, 61, 0, tegra_clk_vde),
>  	INT("vi", mux_pllm_pllc_pllp_plla, CLK_SOURCE_VI, 20, 0, tegra_clk_vi),
>  	INT("epp", mux_pllm_pllc_pllp_plla, CLK_SOURCE_EPP, 19, 0, tegra_clk_epp),
> -	INT("host1x", mux_pllm_pllc_pllp_plla, CLK_SOURCE_HOST1X, 28, 0, tegra_clk_host1x),
>  	INT("mpe", mux_pllm_pllc_pllp_plla, CLK_SOURCE_MPE, 60, 0, tegra_clk_mpe),
>  	INT("2d", mux_pllm_pllc_pllp_plla, CLK_SOURCE_2D, 21, 0, tegra_clk_gr2d),
>  	INT("3d", mux_pllm_pllc_pllp_plla, CLK_SOURCE_3D, 24, 0, tegra_clk_gr3d),
> @@ -664,6 +663,7 @@ static struct tegra_periph_init_data periph_clks[] = {
>  	MUX("owr", mux_pllp_pllc_clkm, CLK_SOURCE_OWR, 71, TEGRA_PERIPH_ON_APB, tegra_clk_owr_8),
>  	MUX("nor", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_NOR, 42, 0, tegra_clk_nor),
>  	MUX("mipi", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_MIPI, 50, TEGRA_PERIPH_ON_APB, tegra_clk_mipi),
> +	MUX("host1x", mux_pllm_pllc_pllp_plla, CLK_SOURCE_HOST1X, 28, 0, tegra_clk_host1x),
>  	MUX("vi_sensor", mux_pllm_pllc_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor),
>  	MUX("vi_sensor", mux_pllc_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor_9),
>  	MUX("cilab", mux_pllp_pllc_clkm, CLK_SOURCE_CILAB, 144, 0, tegra_clk_cilab),

This was attempted in the past
https://lore.kernel.org/all/20180723085010.GK1636@tbergstrom-lnx.Nvidia.com/

I assume here you're also porting the downstream patches to upstream.
This one is too questionable. The host1x clock shouldn't affect overall
performance to begin with. It doesn't make sense to use fractional clock
just for getting extra KHz.

-- 
Best regards,
Dmitry


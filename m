Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8959F615DBE
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 09:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiKBIdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 04:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiKBIdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 04:33:03 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE2C27932;
        Wed,  2 Nov 2022 01:33:00 -0700 (PDT)
Received: from booty (unknown [77.244.183.192])
        (Authenticated sender: luca.ceresoli@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 54E3840016;
        Wed,  2 Nov 2022 08:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667377978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nDDyvRuP5YVwgQ4Sv51x8uHgPQuqZr7+R+y4amwnRCA=;
        b=EaZG7r64T44bSau9BAfVyn1Rg9Www9852QY5f6ONdfxVuykC9ga2q4Y1sQ9fc6FeArOIxK
        eIstuHfDtP8S4Q4XhXd9wvRvyimA9WVHMqMCf452HwFtFRVE+XzAaSUKoX28i0RgKsMy/1
        DfMqm4ZProgyWDBYlL3Pq4bmENNAk/ZgAzIJcOJgnEU84Bguk7w59CxNNugES4I9GYDbFt
        3b5SwaL1Ay/G3hMdLHdMMgSHrF6bFwD81bOERx85g3lQih31W20L2GbDJR5N/vJwBXv8y/
        OORfRwu2ILWhslXyPimEcLADNgjFiKSEJe4jnE/0Hn/3ovwUThtPN78hD/ukOA==
Date:   Wed, 2 Nov 2022 09:32:55 +0100
From:   Luca Ceresoli <luca.ceresoli@bootlin.com>
To:     Dmitry Osipenko <dmitry.osipenko@collabora.com>
Cc:     linux-tegra@vger.kernel.org,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        stable@vger.kernel.org, Ben Dooks <ben.dooks@codethink.co.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH] clk: tegra: fix HOST1X clock divider on Tegra20 and
 Tegra30
Message-ID: <20221102093255.0b5ba7d6@booty>
In-Reply-To: <603a0227-7d25-b9da-6dc3-fa9fe1b951e7@collabora.com>
References: <20221028074826.2317640-1-luca.ceresoli@bootlin.com>
        <603a0227-7d25-b9da-6dc3-fa9fe1b951e7@collabora.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dmitry,

On Mon, 31 Oct 2022 03:34:07 +0300
Dmitry Osipenko <dmitry.osipenko@collabora.com> wrote:

> On 10/28/22 10:48, luca.ceresoli@bootlin.com wrote:
> > From: Luca Ceresoli <luca.ceresoli@bootlin.com>
> > 
> > On Tegra20 and Tegra30 the HOST1X clock is a fractional clock divider with
> > 7 integer bits + 1 decimal bit. This has been verified on both
> > documentation and real hardware for Tegra20 an on the documentation I was
> > able to find for Tegra30.
> > 
> > However in the kernel code this clock is declared as an integer divider. A
> > consequence of this is that requesting 144 MHz for HOST1X which is fed by
> > pll_p running at 216 MHz would result in 108 MHz (216 / 2) instead of 144
> > MHz (216 / 1.5).
> > 
> > Fix by replacing the INT() macro with the MUX() macro which, despite the
> > name, defines a fractional divider. The only difference between the two
> > macros is the former does not have the TEGRA_DIVIDER_INT flag.
> > 
> > Also move the line together with the other MUX*() ones to keep the existing
> > file organization.
> > 
> > Fixes: 76ebc134d45d ("clk: tegra: move periph clocks to common file")
> > Cc: stable@vger.kernel.org
> > Cc: Peter De Schrijver <pdeschrijver@nvidia.com>
> > Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
> > ---
> >  drivers/clk/tegra/clk-tegra-periph.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
> > index 4dcf7f7cb8a0..806d835ca0d2 100644
> > --- a/drivers/clk/tegra/clk-tegra-periph.c
> > +++ b/drivers/clk/tegra/clk-tegra-periph.c
> > @@ -615,7 +615,6 @@ static struct tegra_periph_init_data periph_clks[] = {
> >  	INT("vde", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_VDE, 61, 0, tegra_clk_vde),
> >  	INT("vi", mux_pllm_pllc_pllp_plla, CLK_SOURCE_VI, 20, 0, tegra_clk_vi),
> >  	INT("epp", mux_pllm_pllc_pllp_plla, CLK_SOURCE_EPP, 19, 0, tegra_clk_epp),
> > -	INT("host1x", mux_pllm_pllc_pllp_plla, CLK_SOURCE_HOST1X, 28, 0, tegra_clk_host1x),
> >  	INT("mpe", mux_pllm_pllc_pllp_plla, CLK_SOURCE_MPE, 60, 0, tegra_clk_mpe),
> >  	INT("2d", mux_pllm_pllc_pllp_plla, CLK_SOURCE_2D, 21, 0, tegra_clk_gr2d),
> >  	INT("3d", mux_pllm_pllc_pllp_plla, CLK_SOURCE_3D, 24, 0, tegra_clk_gr3d),
> > @@ -664,6 +663,7 @@ static struct tegra_periph_init_data periph_clks[] = {
> >  	MUX("owr", mux_pllp_pllc_clkm, CLK_SOURCE_OWR, 71, TEGRA_PERIPH_ON_APB, tegra_clk_owr_8),
> >  	MUX("nor", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_NOR, 42, 0, tegra_clk_nor),
> >  	MUX("mipi", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_MIPI, 50, TEGRA_PERIPH_ON_APB, tegra_clk_mipi),
> > +	MUX("host1x", mux_pllm_pllc_pllp_plla, CLK_SOURCE_HOST1X, 28, 0, tegra_clk_host1x),
> >  	MUX("vi_sensor", mux_pllm_pllc_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor),
> >  	MUX("vi_sensor", mux_pllc_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, tegra_clk_vi_sensor_9),
> >  	MUX("cilab", mux_pllp_pllc_clkm, CLK_SOURCE_CILAB, 144, 0, tegra_clk_cilab),  
> 
> This was attempted in the past
> https://lore.kernel.org/all/20180723085010.GK1636@tbergstrom-lnx.Nvidia.com/
> 
> I assume here you're also porting the downstream patches to upstream.
> This one is too questionable. The host1x clock shouldn't affect overall
> performance to begin with. It doesn't make sense to use fractional clock
> just for getting extra KHz.

Thank you for the review and for the pointer!

Indeed I'm not sure this patch brings an actual improvement to my use
case, however I reached it by trying to replicate the configuration on
a known-working kernel 3.1, which uses a 1.5 divider. This seems to be
the same reason that led to the 2018 patch that also got rejected.

I'll be OK with dropping this patch after I have a 100% working setup
with an integer divider, which is very likely given your reply. But it
took time before I found the root cause of this issue, and I would like
to avoid other people waste time in the future, so what about adding a
comment there?

What about:

  /*
   * The host1x clock shouldn't affect overall performance. It doesn't
   * make sense to use fractional clock just for getting extra KHz, so
   * let's pretend it's an integer divider
   */

?

-- 
Luca Ceresoli, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

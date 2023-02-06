Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C3668C814
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 21:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjBFUwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 15:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbjBFUwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 15:52:45 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468BC2CC75;
        Mon,  6 Feb 2023 12:52:40 -0800 (PST)
Received: from booty (unknown [77.244.183.192])
        (Authenticated sender: luca.ceresoli@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 19C2AC0003;
        Mon,  6 Feb 2023 20:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675716758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=prmY1sdOw0bhFLGxGD8Ft2qaDqoVwbMTn9dC7Z/uNN0=;
        b=VgVszzRmFCbNGirdnGdgX55toIvftKb+rLOsJAfRgzbD1rQ2dh9INwn9i3pxeo75g9LKjr
        tVm52onfwHwvTogom4B65Meus8OMWa62J16N6HYRiL/OZprm6+JDMObnbVnod0GSRdUPHk
        i4shuI7sSGY3z936nKr52uN9zOhJg20y93hzbZOBWAmcLLeBHdDlowgIX3ovU1oMmWVirQ
        7aFy5ZyVpUuhpu05B8ts/iYFtCDnL+1o6KiRsdtir9KV3caAEhLzvnaUZmdx1bMFTCDEB2
        v/Fgon/OKnVbO3AXK9dq3hBruFUhQK++0RjrK90xecxwXax7JaFkQpK1vQx0IQ==
Date:   Mon, 6 Feb 2023 21:52:33 +0100
From:   Luca Ceresoli <luca.ceresoli@bootlin.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Artur =?UTF-8?Q?=C5=9Awigo=C5=84?= <a.swigon@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Alexandre Bailon <abailon@baylibre.com>
Subject: Re: [PATCH 04/23] interconnect: imx: fix registration race
Message-ID: <20230206215233.66433c1a@booty>
In-Reply-To: <Y+C1zpn3PvRc+6uf@hovoldconsulting.com>
References: <20230201101559.15529-1-johan+linaro@kernel.org>
        <20230201101559.15529-5-johan+linaro@kernel.org>
        <20230203170121.187108bd@booty>
        <Y+C1zpn3PvRc+6uf@hovoldconsulting.com>
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

Hello Johan,

On Mon, 6 Feb 2023 09:09:50 +0100
Johan Hovold <johan@kernel.org> wrote:

> On Fri, Feb 03, 2023 at 05:01:21PM +0100, Luca Ceresoli wrote:
> > Hello Johan,
> > 
> > On Wed,  1 Feb 2023 11:15:40 +0100
> > Johan Hovold <johan+linaro@kernel.org> wrote:
> >   
> > > The current interconnect provider registration interface is inherently
> > > racy as nodes are not added until the after adding the provider. This
> > > can specifically cause racing DT lookups to fail.
> > > 
> > > Switch to using the new API where the provider is not registered until
> > > after it has been fully initialised.
> > > 
> > > Fixes: f0d8048525d7 ("interconnect: Add imx core driver")
> > > Cc: stable@vger.kernel.org      # 5.8
> > > Cc: Leonard Crestez <leonard.crestez@nxp.com>
> > > Cc: Alexandre Bailon <abailon@baylibre.com>
> > > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>  
> > 
> > Georgi pointed me to this series after I reported a bug yesterday [0],
> > that I found on iMX8MP. So I ran some tests with my original, failing
> > tree, minus one patch with my debugging code to hunt for the bug, plus
> > patches 1-4 of this series.
> > 
> > The original code was failing approx 5~10% of the times. With your 4
> > patches applied it ran 139 times with zero errors, which looks great! I
> > won't be able to do more testing until next Monday to be extra sure.  
> 
> Thanks for testing.
> 
> It indeed looks like you're hitting the same race, and as the imx
> interconnect driver also initialises the provider data num_nodes count
> before adding the nodes it results in that NULL-deref (where the qcom
> driver failed a bit more gracefully).

My v6.2-rc5 tree with patches 1 to 4 added has booted 590 times with 0
errors, which add to the 139 times on Friday. This definitely deserves
my:

Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>

-- 
Luca Ceresoli, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

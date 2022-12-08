Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6433F646DAB
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 11:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLHK7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 05:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiLHK7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 05:59:24 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDAC900E0;
        Thu,  8 Dec 2022 02:51:29 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 67C6FC0004;
        Thu,  8 Dec 2022 10:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1670496687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jX4qpJhOZfq0Tc57pU2iw5g5rc8m7DS0d+5g0687Ft0=;
        b=F7JNzgIt3I6hYU/+MJtFg6ivPmkYClN5wsy3v7G1m9kQzXfuztQaq1LgcvBGV8sSBBnhYU
        bJdglueOmfSxR8ZR1WD0HWV41CHorRhPSqEdvGr0ZjOodhI1IlWvf91DoaVHILLYgy9kSM
        HPk17yM46JhEGztJVFQ10ZjoYRo6gOipTTp6GcK8El04ZCG3TfMjo9DN22UIfr1NJiRbCq
        M4zaed9uWAFIncMswV91KO1Tu7ehBppIAMeJwnSTWoL/edWIChknIC2M/HlpH3d2QHAZsT
        qYY7ktnnHLj46WRausFpBJPcgSHJHmeHj2edNgwwt3nmOpfT2KZI4foEXxxl+w==
Date:   Thu, 8 Dec 2022 11:51:24 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Marek Vasut <marex@denx.de>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-mtd@lists.infradead.org,
        stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [PATCH v1] Revert "ARM: dts: imx7: Fix NAND controller
 size-cells"
Message-ID: <20221208115124.6cc7a8bf@xps-13>
In-Reply-To: <0aa2d48b-35a0-1781-f265-0387d213bdd6@denx.de>
References: <20221205152327.26881-1-francesco@dolcini.it>
        <0aa2d48b-35a0-1781-f265-0387d213bdd6@denx.de>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shawn,

+ Thorsten

marex@denx.de wrote on Mon, 5 Dec 2022 17:26:53 +0100:

> On 12/5/22 16:23, Francesco Dolcini wrote:
> > From: Francesco Dolcini <francesco.dolcini@toradex.com>
> >=20
> > This reverts commit 753395ea1e45c724150070b5785900b6a44bd5fb.
> >=20
> > It introduced a boot regression on colibri-imx7, and potentially any
> > other i.MX7 boards with MTD partition list generated into the fdt by
> > U-Boot.
> >=20
> > While the commit we are reverting here is not obviously wrong, it fixes
> > only a dt binding checker warning that is non-functional, while it
> > introduces a boot regression and there is no obvious fix ready.
> >=20
> > Cc: stable@vger.kernel.org
> > Fixes: 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
> > Link: https://lore.kernel.org/all/Y4dgBTGNWpM6SQXI@francesco-nb.int.tor=
adex.com/
> > Link: https://lore.kernel.org/all/20221205144917.6514168a@xps-13/
> > Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
[...]
> Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
[...]
> Acked-by: Marek Vasut <marex@denx.de>
[...]

As discussed in the above links, boot is broken on imx7 Colibri boards,
this revert was the most quick and straightforward fix we agreed upon
with the hope (~ duty?) it would make it in v6.1. Any chance you could
pick this up rapidly and forward it to Linus? Or should we involve
him directly (Thorsten?).

Thanks,
Miqu=C3=A8l

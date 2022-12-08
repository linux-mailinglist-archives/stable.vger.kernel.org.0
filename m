Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E6364747E
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 17:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiLHQlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 11:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiLHQlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 11:41:18 -0500
Received: from smtp-out-05.comm2000.it (smtp-out-05.comm2000.it [212.97.32.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34D8220F6;
        Thu,  8 Dec 2022 08:41:17 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-05.comm2000.it (Postfix) with ESMTPSA id E9E8A825E0E;
        Thu,  8 Dec 2022 17:40:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1670517676;
        bh=MGqMe6BXHhrUSxKHY7PoPpSFfKzeQ+lcsCV605kXZyc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=0gWjV0LFFvQ4mYVT/KEaf98mcFxvQ/Z00lesQaSifF1BUNfx27TyH9oz07wdYUzhd
         No7zusuVqTfwHpd7wpWWT1Sxspw2zbTl7//CWR8iEp1ZvedcBkr0I91DdAcXw8gkEY
         Qu2pCDf7xwGviRS0gg6PEwtZKDsj7wCvgWSZ6bsTieDlnRf0j/C0i+Zs4nD2KK1EMZ
         YVi4q+kWD1zo6pNPjVpn2C38Huk3XzF+pD5ogBNkmvAfOX4OaGbBhajimVHWAKNrLX
         h9GL1Y4xss6/g0kUIMmUBNRYYUFs90Bn/8WSxG//aXoRcpgZ6Co87fCz8Ea12W8tdd
         iAi//h2nXaKmw==
Date:   Thu, 8 Dec 2022 17:40:49 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Marek Vasut <marex@denx.de>,
        Francesco Dolcini <francesco@dolcini.it>,
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
Message-ID: <Y5ITkZtKWHzWaLS4@francesco-nb.int.toradex.com>
References: <20221205152327.26881-1-francesco@dolcini.it>
 <0aa2d48b-35a0-1781-f265-0387d213bdd6@denx.de>
 <20221208115124.6cc7a8bf@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208115124.6cc7a8bf@xps-13>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ Arnd

On Thu, Dec 08, 2022 at 11:51:24AM +0100, Miquel Raynal wrote:
> marex@denx.de wrote on Mon, 5 Dec 2022 17:26:53 +0100:
> > On 12/5/22 16:23, Francesco Dolcini wrote:
> > > From: Francesco Dolcini <francesco.dolcini@toradex.com>
> > > 
> > > This reverts commit 753395ea1e45c724150070b5785900b6a44bd5fb.
> > > 
> > > It introduced a boot regression on colibri-imx7, and potentially any
> > > other i.MX7 boards with MTD partition list generated into the fdt by
> > > U-Boot.
> > > 
> > > While the commit we are reverting here is not obviously wrong, it fixes
> > > only a dt binding checker warning that is non-functional, while it
> > > introduces a boot regression and there is no obvious fix ready.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Fixes: 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
> > > Link: https://lore.kernel.org/all/Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com/
> > > Link: https://lore.kernel.org/all/20221205144917.6514168a@xps-13/
> > > Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> [...]
> > Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
> [...]
> > Acked-by: Marek Vasut <marex@denx.de>
> [...]
> 
> As discussed in the above links, boot is broken on imx7 Colibri boards,
> this revert was the most quick and straightforward fix we agreed upon
> with the hope (~ duty?) it would make it in v6.1. Any chance you could
> pick this up rapidly and forward it to Linus? Or should we involve
> him directly (Thorsten?).

Hello Arnd,
FYI - see Miquel explanation above.

Francesco

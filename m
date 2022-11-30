Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E00863DFD2
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiK3Sux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbiK3Sum (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:50:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5489D828
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:50:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7787561D80
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B22C433D6;
        Wed, 30 Nov 2022 18:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834239;
        bh=3WX50qTqO/8QYogW+x6n11KWeXNnWx2Sg8qqP3ImZnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vsh8nPCFFjfEnkjxNZ9ERn2vyHRhYWwDGnqh4KFX11nHsTM4ru5LUfI5QQY7oBZm/
         k1f/FD5mgwQ1/Hm07779xHAYk2DHmSJXzhVGrohrSBufuusH74fNnddQlXgtXYZ125
         zLM5gnInQYYStX9PZMWYTjpDQiuFnc5xZWUYVjWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Kleine-Budde <mkl@pengutronix.de>,
        David Jander <david@protonic.nl>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>, Marek Vasut <marex@denx.de>,
        Frieder Schrempf <frieder.schrempf@kontron.de>
Subject: [PATCH 6.0 181/289] spi: spi-imx: Fix spi_bus_clk if requested clock is higher than input clock
Date:   Wed, 30 Nov 2022 19:22:46 +0100
Message-Id: <20221130180548.231443046@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

commit db2d2dc9a0b58c6faefb6b002fdbed4f0362d1a4 upstream.

In case the requested bus clock is higher than the input clock, the correct
dividers (pre = 0, post = 0) are returned from mx51_ecspi_clkdiv(), but
*fres is left uninitialized and therefore contains an arbitrary value.

This causes trouble for the recently introduced PIO polling feature as the
value in spi_imx->spi_bus_clk is used there to calculate for which
transfers to enable PIO polling.

Fix this by setting *fres even if no clock dividers are in use.

This issue was observed on Kontron BL i.MX8MM with an SPI peripheral clock set
to 50 MHz by default and a requested SPI bus clock of 80 MHz for the SPI NOR
flash.

With the fix applied the debug message from mx51_ecspi_clkdiv() now prints the
following:

spi_imx 30820000.spi: mx51_ecspi_clkdiv: fin: 50000000, fspi: 50000000,
post: 0, pre: 0

Fixes: 6fd8b8503a0d ("spi: spi-imx: Fix out-of-order CS/SCLK operation at low speeds")
Fixes: 07e759387788 ("spi: spi-imx: add PIO polling support")
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: David Jander <david@protonic.nl>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Marek Vasut <marex@denx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Tested-by: Fabio Estevam <festevam@gmail.com>
Acked-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20221115181002.2068270-1-frieder@fris.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-imx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -444,8 +444,7 @@ static unsigned int mx51_ecspi_clkdiv(st
 	unsigned int pre, post;
 	unsigned int fin = spi_imx->spi_clk;
 
-	if (unlikely(fspi > fin))
-		return 0;
+	fspi = min(fspi, fin);
 
 	post = fls(fin) - fls(fspi);
 	if (fin > fspi << post)



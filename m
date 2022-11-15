Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80DF62A11D
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 19:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiKOSK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 13:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbiKOSKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 13:10:21 -0500
X-Greylist: delayed 6968 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Nov 2022 10:10:16 PST
Received: from mail.fris.de (mail.fris.de [IPv6:2a01:4f8:c2c:390b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E014D23E89;
        Tue, 15 Nov 2022 10:10:16 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 48EBBBFAAB;
        Tue, 15 Nov 2022 19:10:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fris.de; s=dkim;
        t=1668535814; h=from:subject:date:message-id:to:cc:mime-version:
         content-transfer-encoding; bh=H45maZABLXregYfqLWfeajAgJSlwlOq3Okec5GHiVqQ=;
        b=tQX//QtZ+IrdGz7dRr777MgmC/yKvVgO1bgw+PhI6TvciqiL06D05PgqRuSVYEAQ9nY89p
        nV4jT3M4ZoDCcxk9wMiOftdlWn/yDqooGK21N8JE8jQz5G3NSfhsRUf05v7RNN56hK6cfW
        ZkjrkgnvXNl8vNvsayySjmtuI0tECvLiR4RYInUf7b2FZvnK6rlaxAKcwQ1YZE6IIdVqma
        lJqkcnKxhx6cmlKT1PJ79OnjAASZtEsViftUEos5kMYezQ+XyEHwG1Gs2fQPPGaLgqX9UF
        xve9YsRTePL4qOdf5CoUXJTn2Doz4QLtcMTcHp+FeWkrBQGSWd82sOi2iG/eQA==
From:   Frieder Schrempf <frieder@fris.de>
To:     David Jander <david@protonic.nl>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Marek Vasut <marex@denx.de>, Mark Brown <broonie@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Baruch Siach <baruch.siach@siklu.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: [PATCH v3] spi: spi-imx: Fix spi_bus_clk if requested clock is higher than input clock
Date:   Tue, 15 Nov 2022 19:10:00 +0100
Message-Id: <20221115181002.2068270-1-frieder@fris.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

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
---

Changes for v3:

* Add back the Fixes tag for commit 6fd8b8503a0d
* Add Fabio's Tested-by (Thanks!)

Changes for v2:

* Remove the reference and the Fixes tag for commit 6fd8b8503a0d as it is
  incorrect.
---
 drivers/spi/spi-imx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 30d82cc7300b..468ce0a2b282 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -444,8 +444,7 @@ static unsigned int mx51_ecspi_clkdiv(struct spi_imx_data *spi_imx,
 	unsigned int pre, post;
 	unsigned int fin = spi_imx->spi_clk;
 
-	if (unlikely(fspi > fin))
-		return 0;
+	fspi = min(fspi, fin);
 
 	post = fls(fin) - fls(fspi);
 	if (fin > fspi << post)
-- 
2.38.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9498955D57A
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243661AbiF1CWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243561AbiF1CVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:21:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91FF24960;
        Mon, 27 Jun 2022 19:21:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65FD4B81C0B;
        Tue, 28 Jun 2022 02:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D82C341CB;
        Tue, 28 Jun 2022 02:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382863;
        bh=1lnzaHrP8/Nz40BDmWvhOM2XuhI02Wl0KrII2CAXXCU=;
        h=From:To:Cc:Subject:Date:From;
        b=gCiuGTtCmaLiJJXDoxrb1vyiB3gZl3Z2l0zxxj3NF25mbP775LD75c0XiS5gFc5g4
         y8c1Fe7CXtXF/S5eAPI3FdrWhxsrUXIA9iE4GhnEbEoLLeeMLmqtIjpDrz/dCi8ZV9
         RU48yQ1B1DyCam6f+FqurBoklk9AJZHYCiDlkjkZZvC3xnPkmDA9wXdded338+AMfQ
         9eC8QpFfLEtC4R7rLprqNF/V0eXRX5Q+UFdncE8AKc2MxxRWss7i/GbSTAH1RFx0sm
         lYzlCz29k8nUFKZ0XBY5u8l7/J00y2FKhj+JN5zJoJPcOjCdBWQdCiAoi2VM4EmJqL
         pTGz57RBWcfyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 01/41] spi: spi-cadence: Fix SPI CS gets toggling sporadically
Date:   Mon, 27 Jun 2022 22:20:20 -0400
Message-Id: <20220628022100.595243-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>

[ Upstream commit 21b511ddee09a78909035ec47a6a594349fe3296 ]

As part of unprepare_transfer_hardware, SPI controller will be disabled
which will indirectly deassert the CS line. This will create a problem
in some of the devices where message will be transferred with
cs_change flag set(CS should not be deasserted).
As per SPI controller implementation, if SPI controller is disabled then
all output enables are inactive and all pins are set to input mode which
means CS will go to default state high(deassert). This leads to an issue
when core explicitly ask not to deassert the CS (cs_change = 1). This
patch fix the above issue by checking the Slave select status bits from
configuration register before disabling the SPI.

Signed-off-by: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Link: https://lore.kernel.org/r/20220606062525.18447-1-amit.kumar-mahapatra@xilinx.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index ceb16e70d235..90b18c32f859 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -69,6 +69,7 @@
 #define CDNS_SPI_BAUD_DIV_SHIFT		3 /* Baud rate divisor shift in CR */
 #define CDNS_SPI_SS_SHIFT		10 /* Slave Select field shift in CR */
 #define CDNS_SPI_SS0			0x1 /* Slave Select zero */
+#define CDNS_SPI_NOSS			0x3C /* No Slave select */
 
 /*
  * SPI Interrupt Registers bit Masks
@@ -449,15 +450,20 @@ static int cdns_prepare_transfer_hardware(struct spi_master *master)
  * @master:	Pointer to the spi_master structure which provides
  *		information about the controller.
  *
- * This function disables the SPI master controller.
+ * This function disables the SPI master controller when no slave selected.
  *
  * Return:	0 always
  */
 static int cdns_unprepare_transfer_hardware(struct spi_master *master)
 {
 	struct cdns_spi *xspi = spi_master_get_devdata(master);
+	u32 ctrl_reg;
 
-	cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
+	/* Disable the SPI if slave is deselected */
+	ctrl_reg = cdns_spi_read(xspi, CDNS_SPI_CR);
+	ctrl_reg = (ctrl_reg & CDNS_SPI_CR_SSCTRL) >>  CDNS_SPI_SS_SHIFT;
+	if (ctrl_reg == CDNS_SPI_NOSS)
+		cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
 
 	return 0;
 }
-- 
2.35.1


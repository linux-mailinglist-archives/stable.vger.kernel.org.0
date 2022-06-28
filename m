Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77AF55CBE6
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242825AbiF1CbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244669AbiF1C1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:27:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEAF25E94;
        Mon, 27 Jun 2022 19:25:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8898C61919;
        Tue, 28 Jun 2022 02:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BECC34115;
        Tue, 28 Jun 2022 02:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383120;
        bh=5pfkAnqQPIGk0SIB2DxjUn1P/mejnMof4JcEG9D5NXU=;
        h=From:To:Cc:Subject:Date:From;
        b=i+QzcquQd/PxAE4mhpjRBRjv6jcgDUwRKYudyanP4Bd/ojBY5JqYgfzhMrprmihga
         Yy7QY3FbJGRI/zn5E61owOA1duwiZJVh4G6EU2eV8jmjcGGqfSathj0es8BZFQbD0d
         x7IrfPoYm+aLwymqZGvCQ1m4AoM6Z1HQIi7S99+Wm4cl+i9vcse7dl+ST5RipIkaSl
         dNg5QJUPd+0BMUqn+Ho6oLIgAdWY8J0oGDGtO24d2FjQpIyNSRootogwPZcz8l0HTp
         bhSkwfP3o+w1eWWmnXShx1HewD2i/utxHdA/XG4D4GcBirq9Ydp8C4aBputdNlSHUC
         NpLCUVKdRBZpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/22] spi: spi-cadence: Fix SPI CS gets toggling sporadically
Date:   Mon, 27 Jun 2022 22:24:56 -0400
Message-Id: <20220628022518.596687-1-sashal@kernel.org>
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
index 91f83683c15a..ea7ba502c1eb 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -73,6 +73,7 @@
 #define CDNS_SPI_BAUD_DIV_SHIFT		3 /* Baud rate divisor shift in CR */
 #define CDNS_SPI_SS_SHIFT		10 /* Slave Select field shift in CR */
 #define CDNS_SPI_SS0			0x1 /* Slave Select zero */
+#define CDNS_SPI_NOSS			0x3C /* No Slave select */
 
 /*
  * SPI Interrupt Registers bit Masks
@@ -457,15 +458,20 @@ static int cdns_prepare_transfer_hardware(struct spi_master *master)
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6C86A054A
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 10:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbjBWJwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 04:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbjBWJwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 04:52:49 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B584ECEC;
        Thu, 23 Feb 2023 01:52:47 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 31N9qcBl077086;
        Thu, 23 Feb 2023 03:52:38 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1677145958;
        bh=kN2RfnUUgzUkwI/ceg/z1+1sFH16ZWxamJeuThGZBG4=;
        h=From:To:CC:Subject:Date;
        b=RsGg7G6EjFczahcvt4jv5U3I45u+EasuFuc3C8GNmf0XlwfQXpPkZvmOykWP3BusP
         Ox14gX4nz5GHeXl+dSwaKFEFawgxKfG4Hi2sEYYkHhDdom2uoGwOAjRdmiK7m9z8RT
         POB/p5cE4ItiZMZjb5E7j1N2dNy5VFExulWLCYlU=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 31N9qcaJ007277
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Feb 2023 03:52:38 -0600
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 23
 Feb 2023 03:52:37 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 23 Feb 2023 03:52:37 -0600
Received: from localhost (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 31N9qarm120592;
        Thu, 23 Feb 2023 03:52:37 -0600
From:   Dhruva Gole <d-gole@ti.com>
To:     Mark Brown <broonie@kernel.org>
CC:     Vignesh Raghavendra <vigneshr@ti.com>, Dhruva Gole <d-gole@ti.com>,
        Pratyush Yadav <ptyadav@amazon.de>,
        <linux-spi@vger.kernel.org>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        <linux-kernel@vger.kernel.org>,
        David Binderman <dcb314@hotmail.com>, <stable@vger.kernel.org>
Subject: [PATCH] spi: spi-sn-f-ospi: fix duplicate flag while assigning to mode_bits
Date:   Thu, 23 Feb 2023 15:22:02 +0530
Message-ID: <20230223095202.924626-1-d-gole@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Replace the SPI_TX_OCTAL flag that appeared two time with SPI_RX_OCTAL
in the chain of '|' operators while assigning to mode_bits

Fixes: 1b74dd64c861 ("spi: Add Socionext F_OSPI SPI flash controller driver")

Reported-by: David Binderman <dcb314@hotmail.com>
Link: https://lore.kernel.org/all/DB6P189MB0568F3BE9384315F5C8C1A3E9CA49@DB6P189MB0568.EURP189.PROD.OUTLOOK.COM/

Cc: stable@vger.kernel.org
Signed-off-by: Dhruva Gole <d-gole@ti.com>
---
 drivers/spi/spi-sn-f-ospi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sn-f-ospi.c b/drivers/spi/spi-sn-f-ospi.c
index 348c6e1edd38..333b22dfd8db 100644
--- a/drivers/spi/spi-sn-f-ospi.c
+++ b/drivers/spi/spi-sn-f-ospi.c
@@ -611,7 +611,7 @@ static int f_ospi_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ctlr->mode_bits = SPI_TX_DUAL | SPI_TX_QUAD | SPI_TX_OCTAL
-		| SPI_RX_DUAL | SPI_RX_QUAD | SPI_TX_OCTAL
+		| SPI_RX_DUAL | SPI_RX_QUAD | SPI_RX_OCTAL
 		| SPI_MODE_0 | SPI_MODE_1 | SPI_LSB_FIRST;
 	ctlr->mem_ops = &f_ospi_mem_ops;
 	ctlr->bus_num = -1;
-- 
2.25.1


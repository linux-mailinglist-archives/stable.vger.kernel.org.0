Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6094F613E
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 16:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbiDFOLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 10:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbiDFOLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 10:11:02 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CC410FAF7;
        Wed,  6 Apr 2022 03:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649239549; x=1680775549;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UzpLkLsQSybYrDctDJM7hazMV+345ZJBUluwhHnkHow=;
  b=zV7ZUNi0+RKZ+oCQB4whtuJTcbI6/vCjFes8qlF2BG7eWjbV5IOkP3MS
   XqUg7ZzCIKqGQN91shMqA9PGfV8kBAqgjg96OPIaHpInqx8/FYm6FKRwP
   taIopUY0tQffylehSitNVsyzIk0TjHFhMy5nEA9WsJhKeb337ngOPxYvw
   e9qwq4ZzpiXvGTggpazLZ8QGTx8BDXP2v0ys1RrDDaNpi1pZn8YptOny3
   qgEhRzrhfzKaCC20oyDT2bClg5vUP0MhkQKXLG/AljQHcuWn+lSjA2k0L
   WMIghSev/ylqVlomf3HAWNO3qrL0dWyGIVhqOSzll6zYjItoiPzWeFiui
   g==;
X-IronPort-AV: E=Sophos;i="5.90,239,1643698800"; 
   d="scan'208";a="91453048"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Apr 2022 03:03:45 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 6 Apr 2022 03:03:44 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 6 Apr 2022 03:03:42 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <broonie@kernel.org>
CC:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <claudiu.beznea@microchip.com>, <linux-spi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/2] spi: atmel-quadspi.c: Fix the buswidth adjustment between spi-mem and controller
Date:   Wed, 6 Apr 2022 13:03:39 +0300
Message-ID: <20220406100340.224975-1-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use the spi_mem_default_supports_op() core helper in order to take into
account the buswidth specified by the user in device tree.

Cc: <stable@vger.kernel.org>
Fixes: 0e6aae08e9ae ("spi: Add QuadSPI driver for Atmel SAMA5D2")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/spi/atmel-quadspi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index 92d9610df1fd..938017a60c8e 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -277,6 +277,9 @@ static int atmel_qspi_find_mode(const struct spi_mem_op *op)
 static bool atmel_qspi_supports_op(struct spi_mem *mem,
 				   const struct spi_mem_op *op)
 {
+	if (!spi_mem_default_supports_op(mem, op))
+		return false;
+
 	if (atmel_qspi_find_mode(op) < 0)
 		return false;
 
-- 
2.25.1


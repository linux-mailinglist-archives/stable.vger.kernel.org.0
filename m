Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720524F644A
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 18:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236602AbiDFQEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 12:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237068AbiDFQEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 12:04:13 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDA32C49A6;
        Wed,  6 Apr 2022 06:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649252172; x=1680788172;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dY3I42F8Fmle57bb/MnsyT2f27MUv242lzfRVo6wB7E=;
  b=DFbiJEB7eNaoTE/Lgo+Bgf/RfQsYjJzHTwBizdkH1lxu39d0KvF2r7H2
   ck4YMUbulwdKGpUqAN+J0fMLs+kQL1VdvTNj6+jCt1Kvsvrtel2qaMdAa
   oOGjRd5r9M5TFrXkmZC6Ti2tVfXnFw5zXTAhXGcQECY861VY6M0Xq+HMl
   smJhR9i6eSvwCJw2zdyJN3mLiGCPkxNCOg9OX/d1b4vmeWs74xq5R7kED
   k3w78+40A4pUyrrflMa7F4Y8RmmX+9CRtxrLqVUEvbCU1LXRHeynLt9Yx
   MzFRY7i7Czt3JA9J9Vw6xtVeYCYnfWMNIRn+MT1YN2MN4k2pGaPfIFqRO
   A==;
X-IronPort-AV: E=Sophos;i="5.90,239,1643698800"; 
   d="scan'208";a="151734981"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Apr 2022 06:36:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 6 Apr 2022 06:36:11 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 6 Apr 2022 06:36:09 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <broonie@kernel.org>
CC:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <claudiu.beznea@microchip.com>, <linux-spi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 1/2] spi: atmel-quadspi: Fix the buswidth adjustment between spi-mem and controller
Date:   Wed, 6 Apr 2022 16:36:03 +0300
Message-ID: <20220406133604.455356-1-tudor.ambarus@microchip.com>
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
v2: amend patch's subject, s/"spi: atmel-quadspi.c:"/"spi: atmel-quadspi:"

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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB75575C26
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 09:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiGOHKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 03:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiGOHKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 03:10:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909CDEE37
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 00:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657869006; x=1689405006;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C/MAlPLMWEV1J9Q5LO3Lj0G6NxieuxVNyi8tsXc7Nyk=;
  b=0ApVPOlph0O/6DYIZIRCEYWdPsGu6u2GNgHqW/F70OBkjX42HKjO1q+R
   LyrLSqJyDR4KVwmwQrCPeHkn2T8V5RS2q9iCY8efEs+IIaoBlzr1iHtYH
   vZfnjOKNwZcgzwRKTYeIcxD6dflMmoZJ6EvkkweBrHhv2uRItepdGnZUJ
   8D+rp/bTbOveypXZKw+XbJuRcmBxvN9Y8rWSNjG+j60BpK+WAsIewbCo0
   3Oso85wh4KdX6oc40RWNtdHlJe+Gmjms7TxyfMKoBsB3qIevFABUEn2Uy
   gVN5JKRAEpsG6BCZ96QOuwlDzvUYLPf2KD2LFv+aMHzZjhaojpgok6mp9
   w==;
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="182297661"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jul 2022 00:10:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 15 Jul 2022 00:10:05 -0700
Received: from kavya.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 15 Jul 2022 00:10:03 -0700
From:   Kavyasree Kotagiri <kavyasree.kotagiri@microchip.com>
To:     <horatiu.vultur@microchip.com>
CC:     <madhuri.sripada@microchip.com>,
        <Kavyasree.Kotagiri@microchip.com>, <stable@vger.kernel.org>
Subject: [Internal PATCH 6/8] spi: atmel-quadspi.c: Fix the buswidth adjustment between spi-mem and controller
Date:   Fri, 15 Jul 2022 05:09:38 -0200
Message-ID: <20220715070940.540335-7-kavyasree.kotagiri@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220715070940.540335-1-kavyasree.kotagiri@microchip.com>
References: <20220715070940.540335-1-kavyasree.kotagiri@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

Use the spi_mem_default_supports_op() core helper in order to take into
account the buswidth specified by the user in device tree.

Cc: <stable@vger.kernel.org>
Fixes: 0e6aae08e9ae ("spi: Add QuadSPI driver for Atmel SAMA5D2")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
(cherry picked from commit 41ddc39b3d13273648b9aa34075a085a31ce6031)
---
 drivers/spi/atmel-quadspi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index 841eb826d2d4..1893293667ab 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -456,6 +456,9 @@ static bool atmel_qspi_supports_op(struct spi_mem *mem,
 {
 	struct atmel_qspi *aq = spi_controller_get_devdata(mem->spi->master);
 
+	if (!spi_mem_default_supports_op(mem, op))
+		return false;
+
 	if (aq->caps->octal) {
 		if (atmel_qspi_sama7g5_find_mode(op) < 0)
 			return false;
-- 
2.25.1


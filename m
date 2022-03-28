Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69CE4E9444
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240960AbiC1L0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241681AbiC1LYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:24:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3622257495;
        Mon, 28 Mar 2022 04:21:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4E72611BD;
        Mon, 28 Mar 2022 11:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D24C340F3;
        Mon, 28 Mar 2022 11:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466491;
        bh=3FDGENo31HR4d2ixNLW5MS9/VHe0brDMr3Xy9M1Mn4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WetsHffifX9FhXemJjlYZh73djiZxW40FUCzXfckukj+Mhp9c1jmkRjqVaZv6j++G
         3YBtocR1VOaDUHYmPRiB+0AUsu9+qILFmSm4Aem2elCLy2QvnSXgOdRLCUJwXZCGGJ
         2pZW/vY5apZsJ7jhmUUBNWJb6FOUZzFIBlo342OfGhUqavNZOyzppBWaPdE3/c6/zP
         5FISdb2gSXu1xWndsuWENVug7BrRhbt0fSV2UQwh+CIFtmWYu24qD58yXzva+IIwfT
         06lLIu5uyrSj+mBnte8jJ4C1ZRwn6Bnhdxch0heQ+JfCWpk6eAnLvUGPx4cx8hxTpI
         tCTavWE6Z26vQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eddie James <eajames@linux.ibm.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 35/35] spi: fsi: Implement a timeout for polling status
Date:   Mon, 28 Mar 2022 07:20:11 -0400
Message-Id: <20220328112011.1555169-35-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112011.1555169-1-sashal@kernel.org>
References: <20220328112011.1555169-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 89b35e3f28514087d3f1e28e8f5634fbfd07c554 ]

The data transfer routines must poll the status register to
determine when more data can be shifted in or out. If the hardware
gets into a bad state, these polling loops may never exit. Prevent
this by returning an error if a timeout is exceeded.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20220317211426.38940-1-eajames@linux.ibm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/spi/spi-fsi.c b/drivers/spi/spi-fsi.c
index b6c7467f0b59..d403a7a3021d 100644
--- a/drivers/spi/spi-fsi.c
+++ b/drivers/spi/spi-fsi.c
@@ -25,6 +25,7 @@
 
 #define SPI_FSI_BASE			0x70000
 #define SPI_FSI_INIT_TIMEOUT_MS		1000
+#define SPI_FSI_STATUS_TIMEOUT_MS	100
 #define SPI_FSI_MAX_RX_SIZE		8
 #define SPI_FSI_MAX_TX_SIZE		40
 
@@ -299,6 +300,7 @@ static int fsi_spi_transfer_data(struct fsi_spi *ctx,
 				 struct spi_transfer *transfer)
 {
 	int rc = 0;
+	unsigned long end;
 	u64 status = 0ULL;
 
 	if (transfer->tx_buf) {
@@ -315,10 +317,14 @@ static int fsi_spi_transfer_data(struct fsi_spi *ctx,
 			if (rc)
 				return rc;
 
+			end = jiffies + msecs_to_jiffies(SPI_FSI_STATUS_TIMEOUT_MS);
 			do {
 				rc = fsi_spi_status(ctx, &status, "TX");
 				if (rc)
 					return rc;
+
+				if (time_after(jiffies, end))
+					return -ETIMEDOUT;
 			} while (status & SPI_FSI_STATUS_TDR_FULL);
 
 			sent += nb;
@@ -329,10 +335,14 @@ static int fsi_spi_transfer_data(struct fsi_spi *ctx,
 		u8 *rx = transfer->rx_buf;
 
 		while (transfer->len > recv) {
+			end = jiffies + msecs_to_jiffies(SPI_FSI_STATUS_TIMEOUT_MS);
 			do {
 				rc = fsi_spi_status(ctx, &status, "RX");
 				if (rc)
 					return rc;
+
+				if (time_after(jiffies, end))
+					return -ETIMEDOUT;
 			} while (!(status & SPI_FSI_STATUS_RDR_FULL));
 
 			rc = fsi_spi_read_reg(ctx, SPI_FSI_DATA_RX, &in);
-- 
2.34.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C324FC9DA
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243069AbiDLAsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243074AbiDLAsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:48:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D6D2F008;
        Mon, 11 Apr 2022 17:45:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1155F612A8;
        Tue, 12 Apr 2022 00:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56B5C385A4;
        Tue, 12 Apr 2022 00:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724352;
        bh=Y1aB9MwLiATjOiD+6V5TB0Qd/gFN1usrajp7Ns/Ldzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D/bnrfkZWNVlNy8jIOBnpQl3+nJDwapiI9WNm+v3di4e8kGBbHdfzkA2A9B/PCaPd
         +larWqif6xIcw1NYx3/EFid7u5byWKb3743m4GNL61lxBIRb3Jy2b0GtReyu1Aa0rP
         rTsGY7DHDShyvnVou2GnAUAqPcWupBjfvPS46uCeCR6f3giYKjbESCF5yjGQWKoAHV
         GTz+N/eTV5td+cln126gOJovnToWof9Q0ka36I0QkUZOzK8SEdRu+3xm4hl7BmRZ3l
         d52MOyVqaJ2sN92Yu4PndKygmJvtpejm4J2w1VR/r/sD8na1qEqbM5aB47X5KN27ss
         PzYBqHKkROxuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 34/49] spi: cadence-quadspi: fix protocol setup for non-1-1-X operations
Date:   Mon, 11 Apr 2022 20:43:52 -0400
Message-Id: <20220412004411.349427-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
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

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit 97e4827d775faa9a32b5e1a97959c69dd77d17a3 ]

cqspi_set_protocol() only set the data width, but ignored the command
and address width (except for 8-8-8 DTR ops), leading to corruption of
all transfers using 1-X-X or X-X-X ops. Fix by setting the other two
widths as well.

While we're at it, simplify the code a bit by replacing the
CQSPI_INST_TYPE_* constants with ilog2().

Tested on a TI AM64x with a Macronix MX25U51245G QSPI flash with 1-4-4
read and write operations.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Link: https://lore.kernel.org/r/20220331110819.133392-1-matthias.schiffer@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 46 ++++++++-----------------------
 1 file changed, 12 insertions(+), 34 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index b808c94641fa..75f356041138 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -19,6 +19,7 @@
 #include <linux/iopoll.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
+#include <linux/log2.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/of.h>
@@ -102,12 +103,6 @@ struct cqspi_driver_platdata {
 #define CQSPI_TIMEOUT_MS			500
 #define CQSPI_READ_TIMEOUT_MS			10
 
-/* Instruction type */
-#define CQSPI_INST_TYPE_SINGLE			0
-#define CQSPI_INST_TYPE_DUAL			1
-#define CQSPI_INST_TYPE_QUAD			2
-#define CQSPI_INST_TYPE_OCTAL			3
-
 #define CQSPI_DUMMY_CLKS_PER_BYTE		8
 #define CQSPI_DUMMY_BYTES_MAX			4
 #define CQSPI_DUMMY_CLKS_MAX			31
@@ -376,10 +371,6 @@ static unsigned int cqspi_calc_dummy(const struct spi_mem_op *op, bool dtr)
 static int cqspi_set_protocol(struct cqspi_flash_pdata *f_pdata,
 			      const struct spi_mem_op *op)
 {
-	f_pdata->inst_width = CQSPI_INST_TYPE_SINGLE;
-	f_pdata->addr_width = CQSPI_INST_TYPE_SINGLE;
-	f_pdata->data_width = CQSPI_INST_TYPE_SINGLE;
-
 	/*
 	 * For an op to be DTR, cmd phase along with every other non-empty
 	 * phase should have dtr field set to 1. If an op phase has zero
@@ -389,32 +380,23 @@ static int cqspi_set_protocol(struct cqspi_flash_pdata *f_pdata,
 		       (!op->addr.nbytes || op->addr.dtr) &&
 		       (!op->data.nbytes || op->data.dtr);
 
-	switch (op->data.buswidth) {
-	case 0:
-		break;
-	case 1:
-		f_pdata->data_width = CQSPI_INST_TYPE_SINGLE;
-		break;
-	case 2:
-		f_pdata->data_width = CQSPI_INST_TYPE_DUAL;
-		break;
-	case 4:
-		f_pdata->data_width = CQSPI_INST_TYPE_QUAD;
-		break;
-	case 8:
-		f_pdata->data_width = CQSPI_INST_TYPE_OCTAL;
-		break;
-	default:
-		return -EINVAL;
-	}
+	f_pdata->inst_width = 0;
+	if (op->cmd.buswidth)
+		f_pdata->inst_width = ilog2(op->cmd.buswidth);
+
+	f_pdata->addr_width = 0;
+	if (op->addr.buswidth)
+		f_pdata->addr_width = ilog2(op->addr.buswidth);
+
+	f_pdata->data_width = 0;
+	if (op->data.buswidth)
+		f_pdata->data_width = ilog2(op->data.buswidth);
 
 	/* Right now we only support 8-8-8 DTR mode. */
 	if (f_pdata->dtr) {
 		switch (op->cmd.buswidth) {
 		case 0:
-			break;
 		case 8:
-			f_pdata->inst_width = CQSPI_INST_TYPE_OCTAL;
 			break;
 		default:
 			return -EINVAL;
@@ -422,9 +404,7 @@ static int cqspi_set_protocol(struct cqspi_flash_pdata *f_pdata,
 
 		switch (op->addr.buswidth) {
 		case 0:
-			break;
 		case 8:
-			f_pdata->addr_width = CQSPI_INST_TYPE_OCTAL;
 			break;
 		default:
 			return -EINVAL;
@@ -432,9 +412,7 @@ static int cqspi_set_protocol(struct cqspi_flash_pdata *f_pdata,
 
 		switch (op->data.buswidth) {
 		case 0:
-			break;
 		case 8:
-			f_pdata->data_width = CQSPI_INST_TYPE_OCTAL;
 			break;
 		default:
 			return -EINVAL;
-- 
2.35.1


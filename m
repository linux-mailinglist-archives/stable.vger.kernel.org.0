Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3FD5050E2
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbiDRM3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240015AbiDRM3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:29:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58564205F0;
        Mon, 18 Apr 2022 05:23:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0D0060F0C;
        Mon, 18 Apr 2022 12:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD71C385A8;
        Mon, 18 Apr 2022 12:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284584;
        bh=Y1aB9MwLiATjOiD+6V5TB0Qd/gFN1usrajp7Ns/Ldzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKdjB+b3/lhhsIrsJcLkKOzhZ6EC+pNunPNsBZuCRhjg3xPSHYlY6ymFPzjwLSZm8
         BarNK/9iVd0IepHbtKGy2aNG5P1G9d4P7XQEJQjCR1v9mfyJblwI3qAgikaagt9ptW
         84SO/JhuxKsAr0Tb2VI2abFx19ScUrAldXwY92SU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 161/219] spi: cadence-quadspi: fix protocol setup for non-1-1-X operations
Date:   Mon, 18 Apr 2022 14:12:10 +0200
Message-Id: <20220418121211.390290803@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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




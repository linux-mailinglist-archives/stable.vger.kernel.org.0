Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB25E51A961
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354748AbiEDRLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357016AbiEDRJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB7048325;
        Wed,  4 May 2022 09:56:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57C65616B8;
        Wed,  4 May 2022 16:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E40C385A5;
        Wed,  4 May 2022 16:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683415;
        bh=9+4wzC9LHCwQFi6ITf/BO+2efJaeedcPk7eHgJRbozk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+CukQy0sLI+ozv7nYNqP56NJAdgbpsRYLRRqo2DdW9KIX2zJWB3PjAzcQQTZXNF3
         TY4Yc1I8iJi3IwC5I2NDr/yalXu3npXWEkqP3zb/EJNKDv4wA0YVKaI0UzyRy1DY74
         qU2ZRFjL1coB1psmrbD+oJ5uAc5xdc9Z4dPbcohw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 100/225] memory: renesas-rpc-if: Fix HF/OSPI data transfer in Manual Mode
Date:   Wed,  4 May 2022 18:45:38 +0200
Message-Id: <20220504153119.663029404@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 7e842d70fe599bc13594b650b2144c4b6e6d6bf1 ]

HyperFlash devices fail to probe:

    rpc-if-hyperflash rpc-if-hyperflash: probing of hyperbus device failed

In HyperFlash or Octal-SPI Flash mode, the Transfer Data Enable bits
(SPIDE) in the Manual Mode Enable Setting Register (SMENR) are derived
from half of the transfer size, cfr. the rpcif_bits_set() helper
function.  However, rpcif_reg_{read,write}() does not take the bus size
into account, and does not double all Manual Mode Data Register access
sizes when communicating with a HyperFlash or Octal-SPI Flash device.

Fix this, and avoid the back-and-forth conversion between transfer size
and Transfer Data Enable bits, by explicitly storing the transfer size
in struct rpcif, and using that value to determine access size in
rpcif_reg_{read,write}().

Enforce that the "high" Manual Mode Read/Write Data Registers
(SM[RW]DR1) are only used for 8-byte data accesses.
While at it, forbid writing to the Manual Mode Read Data Registers,
as they are read-only.

Fixes: fff53a551db50f5e ("memory: renesas-rpc-if: Correct QSPI data transfer in Manual mode")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/cde9bfacf704c81865f57b15d1b48a4793da4286.1649681476.git.geert+renesas@glider.be
Link: https://lore.kernel.org/r/20220420070526.9367-1-krzysztof.kozlowski@linaro.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/renesas-rpc-if.c | 60 +++++++++++++++++++++++++--------
 include/memory/renesas-rpc-if.h |  1 +
 2 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index 2e545f473cc6..019a0822bde0 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -164,25 +164,39 @@ static const struct regmap_access_table rpcif_volatile_table = {
 
 
 /*
- * Custom accessor functions to ensure SMRDR0 and SMWDR0 are always accessed
- * with proper width. Requires SMENR_SPIDE to be correctly set before!
+ * Custom accessor functions to ensure SM[RW]DR[01] are always accessed with
+ * proper width.  Requires rpcif.xfer_size to be correctly set before!
  */
 static int rpcif_reg_read(void *context, unsigned int reg, unsigned int *val)
 {
 	struct rpcif *rpc = context;
 
-	if (reg == RPCIF_SMRDR0 || reg == RPCIF_SMWDR0) {
-		u32 spide = readl(rpc->base + RPCIF_SMENR) & RPCIF_SMENR_SPIDE(0xF);
-
-		if (spide == 0x8) {
+	switch (reg) {
+	case RPCIF_SMRDR0:
+	case RPCIF_SMWDR0:
+		switch (rpc->xfer_size) {
+		case 1:
 			*val = readb(rpc->base + reg);
 			return 0;
-		} else if (spide == 0xC) {
+
+		case 2:
 			*val = readw(rpc->base + reg);
 			return 0;
-		} else if (spide != 0xF) {
+
+		case 4:
+		case 8:
+			*val = readl(rpc->base + reg);
+			return 0;
+
+		default:
 			return -EILSEQ;
 		}
+
+	case RPCIF_SMRDR1:
+	case RPCIF_SMWDR1:
+		if (rpc->xfer_size != 8)
+			return -EILSEQ;
+		break;
 	}
 
 	*val = readl(rpc->base + reg);
@@ -193,18 +207,34 @@ static int rpcif_reg_write(void *context, unsigned int reg, unsigned int val)
 {
 	struct rpcif *rpc = context;
 
-	if (reg == RPCIF_SMRDR0 || reg == RPCIF_SMWDR0) {
-		u32 spide = readl(rpc->base + RPCIF_SMENR) & RPCIF_SMENR_SPIDE(0xF);
-
-		if (spide == 0x8) {
+	switch (reg) {
+	case RPCIF_SMWDR0:
+		switch (rpc->xfer_size) {
+		case 1:
 			writeb(val, rpc->base + reg);
 			return 0;
-		} else if (spide == 0xC) {
+
+		case 2:
 			writew(val, rpc->base + reg);
 			return 0;
-		} else if (spide != 0xF) {
+
+		case 4:
+		case 8:
+			writel(val, rpc->base + reg);
+			return 0;
+
+		default:
 			return -EILSEQ;
 		}
+
+	case RPCIF_SMWDR1:
+		if (rpc->xfer_size != 8)
+			return -EILSEQ;
+		break;
+
+	case RPCIF_SMRDR0:
+	case RPCIF_SMRDR1:
+		return -EPERM;
 	}
 
 	writel(val, rpc->base + reg);
@@ -469,6 +499,7 @@ int rpcif_manual_xfer(struct rpcif *rpc)
 
 			smenr |= RPCIF_SMENR_SPIDE(rpcif_bits_set(rpc, nbytes));
 			regmap_write(rpc->regmap, RPCIF_SMENR, smenr);
+			rpc->xfer_size = nbytes;
 
 			memcpy(data, rpc->buffer + pos, nbytes);
 			if (nbytes == 8) {
@@ -533,6 +564,7 @@ int rpcif_manual_xfer(struct rpcif *rpc)
 			regmap_write(rpc->regmap, RPCIF_SMENR, smenr);
 			regmap_write(rpc->regmap, RPCIF_SMCR,
 				     rpc->smcr | RPCIF_SMCR_SPIE);
+			rpc->xfer_size = nbytes;
 			ret = wait_msg_xfer_end(rpc);
 			if (ret)
 				goto err_out;
diff --git a/include/memory/renesas-rpc-if.h b/include/memory/renesas-rpc-if.h
index 7c93f5177532..9c0ad64b8d29 100644
--- a/include/memory/renesas-rpc-if.h
+++ b/include/memory/renesas-rpc-if.h
@@ -72,6 +72,7 @@ struct rpcif {
 	enum rpcif_type type;
 	enum rpcif_data_dir dir;
 	u8 bus_size;
+	u8 xfer_size;
 	void *buffer;
 	u32 xferlen;
 	u32 smcr;
-- 
2.35.1




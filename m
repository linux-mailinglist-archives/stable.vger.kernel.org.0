Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC313C4B48
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239214AbhGLG4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239205AbhGLGtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:49:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64BA861106;
        Mon, 12 Jul 2021 06:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072399;
        bh=sEwMg+eoMcrVaD1eHQgAKL9veI66PO3MnXlMlxX3Mew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kou9tyfyAlWIXQ9Av0+hzJXcFzUsOHdqUV5OMvp07Zns33YNZ9oNnB9r3PU7l/f35
         Ifj+U8Y6TWjoK8DHv2OaLJGYgyll6+skEQd9XZuGx/Phaaac2V4cOURXJpcUZK2D5a
         HnyP+EUOUBEQ6B6xgAws/NH4tb1vqllpBdQUE2rE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 474/593] mtd: rawnand: arasan: Ensure proper configuration for the asserted target
Date:   Mon, 12 Jul 2021 08:10:34 +0200
Message-Id: <20210712060942.263932704@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit b5437c7b682c9a505065b4ab4716cdc951dc3c7c ]

The controller being always asserting one CS or the other, there is no
need to actually select the right target before doing a page read/write.
However, the anfc_select_target() helper actually also changes the
timing configuration and clock in the case were two different NAND chips
with different timing requirements would be used. In this situation, we
must ensure proper configuration of the controller by calling it.

As a consequence of this change, the anfc_select_target() helper is
being moved earlier in the driver.

Fixes: 88ffef1b65cf ("mtd: rawnand: arasan: Support the hardware BCH ECC engine")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210526093242.183847-4-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/arasan-nand-controller.c | 90 ++++++++++++-------
 1 file changed, 57 insertions(+), 33 deletions(-)

diff --git a/drivers/mtd/nand/raw/arasan-nand-controller.c b/drivers/mtd/nand/raw/arasan-nand-controller.c
index fbb4ea751be8..0ee3192916d9 100644
--- a/drivers/mtd/nand/raw/arasan-nand-controller.c
+++ b/drivers/mtd/nand/raw/arasan-nand-controller.c
@@ -272,6 +272,37 @@ static int anfc_pkt_len_config(unsigned int len, unsigned int *steps,
 	return 0;
 }
 
+static int anfc_select_target(struct nand_chip *chip, int target)
+{
+	struct anand *anand = to_anand(chip);
+	struct arasan_nfc *nfc = to_anfc(chip->controller);
+	int ret;
+
+	/* Update the controller timings and the potential ECC configuration */
+	writel_relaxed(anand->timings, nfc->base + DATA_INTERFACE_REG);
+
+	/* Update clock frequency */
+	if (nfc->cur_clk != anand->clk) {
+		clk_disable_unprepare(nfc->controller_clk);
+		ret = clk_set_rate(nfc->controller_clk, anand->clk);
+		if (ret) {
+			dev_err(nfc->dev, "Failed to change clock rate\n");
+			return ret;
+		}
+
+		ret = clk_prepare_enable(nfc->controller_clk);
+		if (ret) {
+			dev_err(nfc->dev,
+				"Failed to re-enable the controller clock\n");
+			return ret;
+		}
+
+		nfc->cur_clk = anand->clk;
+	}
+
+	return 0;
+}
+
 /*
  * When using the embedded hardware ECC engine, the controller is in charge of
  * feeding the engine with, first, the ECC residue present in the data array.
@@ -400,6 +431,18 @@ static int anfc_read_page_hw_ecc(struct nand_chip *chip, u8 *buf,
 	return 0;
 }
 
+static int anfc_sel_read_page_hw_ecc(struct nand_chip *chip, u8 *buf,
+				     int oob_required, int page)
+{
+	int ret;
+
+	ret = anfc_select_target(chip, chip->cur_cs);
+	if (ret)
+		return ret;
+
+	return anfc_read_page_hw_ecc(chip, buf, oob_required, page);
+};
+
 static int anfc_write_page_hw_ecc(struct nand_chip *chip, const u8 *buf,
 				  int oob_required, int page)
 {
@@ -460,6 +503,18 @@ static int anfc_write_page_hw_ecc(struct nand_chip *chip, const u8 *buf,
 	return ret;
 }
 
+static int anfc_sel_write_page_hw_ecc(struct nand_chip *chip, const u8 *buf,
+				      int oob_required, int page)
+{
+	int ret;
+
+	ret = anfc_select_target(chip, chip->cur_cs);
+	if (ret)
+		return ret;
+
+	return anfc_write_page_hw_ecc(chip, buf, oob_required, page);
+};
+
 /* NAND framework ->exec_op() hooks and related helpers */
 static int anfc_parse_instructions(struct nand_chip *chip,
 				   const struct nand_subop *subop,
@@ -752,37 +807,6 @@ static const struct nand_op_parser anfc_op_parser = NAND_OP_PARSER(
 		NAND_OP_PARSER_PAT_WAITRDY_ELEM(false)),
 	);
 
-static int anfc_select_target(struct nand_chip *chip, int target)
-{
-	struct anand *anand = to_anand(chip);
-	struct arasan_nfc *nfc = to_anfc(chip->controller);
-	int ret;
-
-	/* Update the controller timings and the potential ECC configuration */
-	writel_relaxed(anand->timings, nfc->base + DATA_INTERFACE_REG);
-
-	/* Update clock frequency */
-	if (nfc->cur_clk != anand->clk) {
-		clk_disable_unprepare(nfc->controller_clk);
-		ret = clk_set_rate(nfc->controller_clk, anand->clk);
-		if (ret) {
-			dev_err(nfc->dev, "Failed to change clock rate\n");
-			return ret;
-		}
-
-		ret = clk_prepare_enable(nfc->controller_clk);
-		if (ret) {
-			dev_err(nfc->dev,
-				"Failed to re-enable the controller clock\n");
-			return ret;
-		}
-
-		nfc->cur_clk = anand->clk;
-	}
-
-	return 0;
-}
-
 static int anfc_check_op(struct nand_chip *chip,
 			 const struct nand_operation *op)
 {
@@ -1006,8 +1030,8 @@ static int anfc_init_hw_ecc_controller(struct arasan_nfc *nfc,
 	if (!anand->bch)
 		return -EINVAL;
 
-	ecc->read_page = anfc_read_page_hw_ecc;
-	ecc->write_page = anfc_write_page_hw_ecc;
+	ecc->read_page = anfc_sel_read_page_hw_ecc;
+	ecc->write_page = anfc_sel_write_page_hw_ecc;
 
 	return 0;
 }
-- 
2.30.2




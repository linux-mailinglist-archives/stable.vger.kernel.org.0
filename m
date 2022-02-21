Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6E54BE1EE
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346986AbiBUJD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347767AbiBUJBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:01:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF282980C;
        Mon, 21 Feb 2022 00:57:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0053D61140;
        Mon, 21 Feb 2022 08:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAD5C340E9;
        Mon, 21 Feb 2022 08:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433797;
        bh=yYV72LLm4rWP4TZMDH94vDkyz3GDLcEC49kBuewSJl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRR2RqEvPoGRdt0OXSwUxefd4aGTfRYc87XdMLB4xcENuU+wltgDi/sk50f9L19fM
         mYj531qWvrCqszuB/TEUEH2hHW1dpy4ujuNhHkQFjL7l7QyC1YrZ6uWk1qbWThidaw
         cTCxStc190ya4K+yyTvJtl4bTh+bZ8oVr/dGnvkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 45/58] mtd: rawnand: brcmnand: Refactored code to introduce helper functions
Date:   Mon, 21 Feb 2022 09:49:38 +0100
Message-Id: <20220221084913.333269706@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Kamal Dasu <kdasu.kdev@gmail.com>

[ Upstream commit 3c7c1e4594efd57b98ae6f7298f40cff4f4fb47b ]

Refactored NAND ECC and CMD address configuration code to use helper
functions.

Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c | 100 ++++++++++++++---------
 1 file changed, 62 insertions(+), 38 deletions(-)

diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
index 774ffa9e23f38..db18198f2834f 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -589,6 +589,54 @@ static inline void brcmnand_write_fc(struct brcmnand_controller *ctrl,
 	__raw_writel(val, ctrl->nand_fc + word * 4);
 }
 
+static void brcmnand_clear_ecc_addr(struct brcmnand_controller *ctrl)
+{
+
+	/* Clear error addresses */
+	brcmnand_write_reg(ctrl, BRCMNAND_UNCORR_ADDR, 0);
+	brcmnand_write_reg(ctrl, BRCMNAND_CORR_ADDR, 0);
+	brcmnand_write_reg(ctrl, BRCMNAND_UNCORR_EXT_ADDR, 0);
+	brcmnand_write_reg(ctrl, BRCMNAND_CORR_EXT_ADDR, 0);
+}
+
+static u64 brcmnand_get_uncorrecc_addr(struct brcmnand_controller *ctrl)
+{
+	u64 err_addr;
+
+	err_addr = brcmnand_read_reg(ctrl, BRCMNAND_UNCORR_ADDR);
+	err_addr |= ((u64)(brcmnand_read_reg(ctrl,
+					     BRCMNAND_UNCORR_EXT_ADDR)
+					     & 0xffff) << 32);
+
+	return err_addr;
+}
+
+static u64 brcmnand_get_correcc_addr(struct brcmnand_controller *ctrl)
+{
+	u64 err_addr;
+
+	err_addr = brcmnand_read_reg(ctrl, BRCMNAND_CORR_ADDR);
+	err_addr |= ((u64)(brcmnand_read_reg(ctrl,
+					     BRCMNAND_CORR_EXT_ADDR)
+					     & 0xffff) << 32);
+
+	return err_addr;
+}
+
+static void brcmnand_set_cmd_addr(struct mtd_info *mtd, u64 addr)
+{
+	struct nand_chip *chip =  mtd_to_nand(mtd);
+	struct brcmnand_host *host = nand_get_controller_data(chip);
+	struct brcmnand_controller *ctrl = host->ctrl;
+
+	brcmnand_write_reg(ctrl, BRCMNAND_CMD_EXT_ADDRESS,
+			   (host->cs << 16) | ((addr >> 32) & 0xffff));
+	(void)brcmnand_read_reg(ctrl, BRCMNAND_CMD_EXT_ADDRESS);
+	brcmnand_write_reg(ctrl, BRCMNAND_CMD_ADDRESS,
+			   lower_32_bits(addr));
+	(void)brcmnand_read_reg(ctrl, BRCMNAND_CMD_ADDRESS);
+}
+
 static inline u16 brcmnand_cs_offset(struct brcmnand_controller *ctrl, int cs,
 				     enum brcmnand_cs_reg reg)
 {
@@ -1217,9 +1265,12 @@ static void brcmnand_send_cmd(struct brcmnand_host *host, int cmd)
 {
 	struct brcmnand_controller *ctrl = host->ctrl;
 	int ret;
+	u64 cmd_addr;
+
+	cmd_addr = brcmnand_read_reg(ctrl, BRCMNAND_CMD_ADDRESS);
+
+	dev_dbg(ctrl->dev, "send native cmd %d addr 0x%llx\n", cmd, cmd_addr);
 
-	dev_dbg(ctrl->dev, "send native cmd %d addr_lo 0x%x\n", cmd,
-		brcmnand_read_reg(ctrl, BRCMNAND_CMD_ADDRESS));
 	BUG_ON(ctrl->cmd_pending != 0);
 	ctrl->cmd_pending = cmd;
 
@@ -1380,12 +1431,7 @@ static void brcmnand_cmdfunc(struct mtd_info *mtd, unsigned command,
 	if (!native_cmd)
 		return;
 
-	brcmnand_write_reg(ctrl, BRCMNAND_CMD_EXT_ADDRESS,
-		(host->cs << 16) | ((addr >> 32) & 0xffff));
-	(void)brcmnand_read_reg(ctrl, BRCMNAND_CMD_EXT_ADDRESS);
-	brcmnand_write_reg(ctrl, BRCMNAND_CMD_ADDRESS, lower_32_bits(addr));
-	(void)brcmnand_read_reg(ctrl, BRCMNAND_CMD_ADDRESS);
-
+	brcmnand_set_cmd_addr(mtd, addr);
 	brcmnand_send_cmd(host, native_cmd);
 	brcmnand_waitfunc(mtd, chip);
 
@@ -1605,20 +1651,10 @@ static int brcmnand_read_by_pio(struct mtd_info *mtd, struct nand_chip *chip,
 	struct brcmnand_controller *ctrl = host->ctrl;
 	int i, j, ret = 0;
 
-	/* Clear error addresses */
-	brcmnand_write_reg(ctrl, BRCMNAND_UNCORR_ADDR, 0);
-	brcmnand_write_reg(ctrl, BRCMNAND_CORR_ADDR, 0);
-	brcmnand_write_reg(ctrl, BRCMNAND_UNCORR_EXT_ADDR, 0);
-	brcmnand_write_reg(ctrl, BRCMNAND_CORR_EXT_ADDR, 0);
-
-	brcmnand_write_reg(ctrl, BRCMNAND_CMD_EXT_ADDRESS,
-			(host->cs << 16) | ((addr >> 32) & 0xffff));
-	(void)brcmnand_read_reg(ctrl, BRCMNAND_CMD_EXT_ADDRESS);
+	brcmnand_clear_ecc_addr(ctrl);
 
 	for (i = 0; i < trans; i++, addr += FC_BYTES) {
-		brcmnand_write_reg(ctrl, BRCMNAND_CMD_ADDRESS,
-				   lower_32_bits(addr));
-		(void)brcmnand_read_reg(ctrl, BRCMNAND_CMD_ADDRESS);
+		brcmnand_set_cmd_addr(mtd, addr);
 		/* SPARE_AREA_READ does not use ECC, so just use PAGE_READ */
 		brcmnand_send_cmd(host, CMD_PAGE_READ);
 		brcmnand_waitfunc(mtd, chip);
@@ -1638,21 +1674,15 @@ static int brcmnand_read_by_pio(struct mtd_info *mtd, struct nand_chip *chip,
 					host->hwcfg.sector_size_1k);
 
 		if (!ret) {
-			*err_addr = brcmnand_read_reg(ctrl,
-					BRCMNAND_UNCORR_ADDR) |
-				((u64)(brcmnand_read_reg(ctrl,
-						BRCMNAND_UNCORR_EXT_ADDR)
-					& 0xffff) << 32);
+			*err_addr = brcmnand_get_uncorrecc_addr(ctrl);
+
 			if (*err_addr)
 				ret = -EBADMSG;
 		}
 
 		if (!ret) {
-			*err_addr = brcmnand_read_reg(ctrl,
-					BRCMNAND_CORR_ADDR) |
-				((u64)(brcmnand_read_reg(ctrl,
-						BRCMNAND_CORR_EXT_ADDR)
-					& 0xffff) << 32);
+			*err_addr = brcmnand_get_correcc_addr(ctrl);
+
 			if (*err_addr)
 				ret = -EUCLEAN;
 		}
@@ -1722,7 +1752,7 @@ static int brcmnand_read(struct mtd_info *mtd, struct nand_chip *chip,
 	dev_dbg(ctrl->dev, "read %llx -> %p\n", (unsigned long long)addr, buf);
 
 try_dmaread:
-	brcmnand_write_reg(ctrl, BRCMNAND_UNCORR_COUNT, 0);
+	brcmnand_clear_ecc_addr(ctrl);
 
 	if (has_flash_dma(ctrl) && !oob && flash_dma_buf_ok(buf)) {
 		err = brcmnand_dma_trans(host, addr, buf, trans * FC_BYTES,
@@ -1866,15 +1896,9 @@ static int brcmnand_write(struct mtd_info *mtd, struct nand_chip *chip,
 		goto out;
 	}
 
-	brcmnand_write_reg(ctrl, BRCMNAND_CMD_EXT_ADDRESS,
-			(host->cs << 16) | ((addr >> 32) & 0xffff));
-	(void)brcmnand_read_reg(ctrl, BRCMNAND_CMD_EXT_ADDRESS);
-
 	for (i = 0; i < trans; i++, addr += FC_BYTES) {
 		/* full address MUST be set before populating FC */
-		brcmnand_write_reg(ctrl, BRCMNAND_CMD_ADDRESS,
-				   lower_32_bits(addr));
-		(void)brcmnand_read_reg(ctrl, BRCMNAND_CMD_ADDRESS);
+		brcmnand_set_cmd_addr(mtd, addr);
 
 		if (buf) {
 			brcmnand_soc_data_bus_prepare(ctrl->soc, false);
-- 
2.34.1




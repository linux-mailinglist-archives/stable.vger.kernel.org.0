Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB9E60BAFA
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbiJXUnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbiJXUnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:43:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39112B63E;
        Mon, 24 Oct 2022 11:51:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 75C11CE16D6;
        Mon, 24 Oct 2022 12:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BC7C433D6;
        Mon, 24 Oct 2022 12:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615742;
        bh=QG5TJidSSe20q6w/U96C+IpsB/oyzh/jpVsc0UJamV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jD5Y1Mc0hROlIqyCSveUR36KXBtU1vHXSRyRD8AM7e9kNAiC1d4ORun3s0lHhIruM
         u3tgozxg+pkKxeVl6m+ISxb5m3SF3MucJlG1zylk/n5dKgflT137gZS5khUkMgZdbU
         Ow/C9+j84JW7L8//FwVbufGhKg/KvhmxC6eP361A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Conor Dooley <conor.dooley@microchip.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 359/530] mailbox: mpfs: fix handling of the reg property
Date:   Mon, 24 Oct 2022 13:31:43 +0200
Message-Id: <20221024113101.292886841@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 2e10289d1f304f5082a4dda55a677b72b3bdb581 ]

The "data" region of the PolarFire SoC's system controller mailbox is
not one continuous register space - the system controller's QSPI sits
between the control and data registers. Split the "data" reg into two
parts: "data" & "control". Optionally get the "data" register address
from the 3rd reg property in the devicetree & fall back to using the
old base + MAILBOX_REG_OFFSET that the current code uses.

Fixes: 83d7b1560810 ("mbox: add polarfire soc system controller mailbox")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-mpfs.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/mailbox/mailbox-mpfs.c b/drivers/mailbox/mailbox-mpfs.c
index 4e34854d1238..e432a8f0d148 100644
--- a/drivers/mailbox/mailbox-mpfs.c
+++ b/drivers/mailbox/mailbox-mpfs.c
@@ -62,6 +62,7 @@ struct mpfs_mbox {
 	struct mbox_controller controller;
 	struct device *dev;
 	int irq;
+	void __iomem *ctrl_base;
 	void __iomem *mbox_base;
 	void __iomem *int_reg;
 	struct mbox_chan chans[1];
@@ -73,7 +74,7 @@ static bool mpfs_mbox_busy(struct mpfs_mbox *mbox)
 {
 	u32 status;
 
-	status = readl_relaxed(mbox->mbox_base + SERVICES_SR_OFFSET);
+	status = readl_relaxed(mbox->ctrl_base + SERVICES_SR_OFFSET);
 
 	return status & SCB_STATUS_BUSY_MASK;
 }
@@ -99,14 +100,13 @@ static int mpfs_mbox_send_data(struct mbox_chan *chan, void *data)
 
 		for (index = 0; index < (msg->cmd_data_size / 4); index++)
 			writel_relaxed(word_buf[index],
-				       mbox->mbox_base + MAILBOX_REG_OFFSET + index * 0x4);
+				       mbox->mbox_base + index * 0x4);
 		if (extra_bits) {
 			u8 i;
 			u8 byte_off = ALIGN_DOWN(msg->cmd_data_size, 4);
 			u8 *byte_buf = msg->cmd_data + byte_off;
 
-			val = readl_relaxed(mbox->mbox_base +
-					    MAILBOX_REG_OFFSET + index * 0x4);
+			val = readl_relaxed(mbox->mbox_base + index * 0x4);
 
 			for (i = 0u; i < extra_bits; i++) {
 				val &= ~(0xffu << (i * 8u));
@@ -114,14 +114,14 @@ static int mpfs_mbox_send_data(struct mbox_chan *chan, void *data)
 			}
 
 			writel_relaxed(val,
-				       mbox->mbox_base + MAILBOX_REG_OFFSET + index * 0x4);
+				       mbox->mbox_base + index * 0x4);
 		}
 	}
 
 	opt_sel = ((msg->mbox_offset << 7u) | (msg->cmd_opcode & 0x7fu));
 	tx_trigger = (opt_sel << SCB_CTRL_POS) & SCB_CTRL_MASK;
 	tx_trigger |= SCB_CTRL_REQ_MASK | SCB_STATUS_NOTIFY_MASK;
-	writel_relaxed(tx_trigger, mbox->mbox_base + SERVICES_CR_OFFSET);
+	writel_relaxed(tx_trigger, mbox->ctrl_base + SERVICES_CR_OFFSET);
 
 	return 0;
 }
@@ -141,7 +141,7 @@ static void mpfs_mbox_rx_data(struct mbox_chan *chan)
 	if (!mpfs_mbox_busy(mbox)) {
 		for (i = 0; i < num_words; i++) {
 			response->resp_msg[i] =
-				readl_relaxed(mbox->mbox_base + MAILBOX_REG_OFFSET
+				readl_relaxed(mbox->mbox_base
 					      + mbox->resp_offset + i * 0x4);
 		}
 	}
@@ -200,14 +200,18 @@ static int mpfs_mbox_probe(struct platform_device *pdev)
 	if (!mbox)
 		return -ENOMEM;
 
-	mbox->mbox_base = devm_platform_get_and_ioremap_resource(pdev, 0, &regs);
-	if (IS_ERR(mbox->mbox_base))
-		return PTR_ERR(mbox->mbox_base);
+	mbox->ctrl_base = devm_platform_get_and_ioremap_resource(pdev, 0, &regs);
+	if (IS_ERR(mbox->ctrl_base))
+		return PTR_ERR(mbox->ctrl_base);
 
 	mbox->int_reg = devm_platform_get_and_ioremap_resource(pdev, 1, &regs);
 	if (IS_ERR(mbox->int_reg))
 		return PTR_ERR(mbox->int_reg);
 
+	mbox->mbox_base = devm_platform_get_and_ioremap_resource(pdev, 2, &regs);
+	if (IS_ERR(mbox->mbox_base)) // account for the old dt-binding w/ 2 regs
+		mbox->mbox_base = mbox->ctrl_base + MAILBOX_REG_OFFSET;
+
 	mbox->irq = platform_get_irq(pdev, 0);
 	if (mbox->irq < 0)
 		return mbox->irq;
-- 
2.35.1




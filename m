Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DED532E4E
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 18:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239461AbiEXQCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 12:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239454AbiEXQCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 12:02:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159DA9D065;
        Tue, 24 May 2022 09:00:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93AC46175C;
        Tue, 24 May 2022 16:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6390C34115;
        Tue, 24 May 2022 16:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653408058;
        bh=bT4CTgHpvXVv/uW9tgfQDMcOFCpQ1VTbuOkkQWTBUAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttoiFQ4bJDH4O3uv91D1JAQ6efZJn1wn7tnraa8hcK7Rh1PYoY4NQ/cnLSkO9krfs
         ZYBB+dzfBaaar7pkMkcJ1QbwC7AIsBfE7Pa9HsLp2AP6OrDzReujXOTmjHF3+K5CDm
         Lhmb4ZUJSTdyx9DaRoijKS6XJOW9bI6Oz010xdPijTQbb0pCmN6dKcMy0ANYtRKSJm
         tBfJcTvfQjiCBwXARpo/gN8p0BuQlaeNvN/jEruqG0EjkiWMI59F8UdB4Z25uxNQXw
         MrcrH3A1WHhaE0hYX2+hiWwbmInsMkPT+14LxN9U6Bz9Ol+AH43ujayn7fYh59kkFW
         yxol+9k7H/jvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        "From : Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        seth.heasley@intel.com, nhorman@tuxdriver.com,
        christophe.jaillet@wanadoo.fr, bp@suse.de,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 7/8] i2c: ismt: Provide a DMA buffer for Interrupt Cause Logging
Date:   Tue, 24 May 2022 12:00:34 -0400
Message-Id: <20220524160035.827109-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524160035.827109-1-sashal@kernel.org>
References: <20220524160035.827109-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 17a0f3acdc6ec8b89ad40f6e22165a4beee25663 ]

Before sending a MSI the hardware writes information pertinent to the
interrupt cause to a memory location pointed by SMTICL register. This
memory holds three double words where the least significant bit tells
whether the interrupt cause of master/target/error is valid. The driver
does not use this but we need to set it up because otherwise it will
perform DMA write to the default address (0) and this will cause an
IOMMU fault such as below:

  DMAR: DRHD: handling fault status reg 2
  DMAR: [DMA Write] Request device [00:12.0] PASID ffffffff fault addr 0
        [fault reason 05] PTE Write access is not set

To prevent this from happening, provide a proper DMA buffer for this
that then gets mapped by the IOMMU accordingly.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-ismt.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/i2c/busses/i2c-ismt.c b/drivers/i2c/busses/i2c-ismt.c
index a35a27c320e7..3d2d92640651 100644
--- a/drivers/i2c/busses/i2c-ismt.c
+++ b/drivers/i2c/busses/i2c-ismt.c
@@ -82,6 +82,7 @@
 
 #define ISMT_DESC_ENTRIES	2	/* number of descriptor entries */
 #define ISMT_MAX_RETRIES	3	/* number of SMBus retries to attempt */
+#define ISMT_LOG_ENTRIES	3	/* number of interrupt cause log entries */
 
 /* Hardware Descriptor Constants - Control Field */
 #define ISMT_DESC_CWRL	0x01	/* Command/Write Length */
@@ -175,6 +176,8 @@ struct ismt_priv {
 	u8 head;				/* ring buffer head pointer */
 	struct completion cmp;			/* interrupt completion */
 	u8 buffer[I2C_SMBUS_BLOCK_MAX + 16];	/* temp R/W data buffer */
+	dma_addr_t log_dma;
+	u32 *log;
 };
 
 static const struct pci_device_id ismt_ids[] = {
@@ -409,6 +412,9 @@ static int ismt_access(struct i2c_adapter *adap, u16 addr,
 	memset(desc, 0, sizeof(struct ismt_desc));
 	desc->tgtaddr_rw = ISMT_DESC_ADDR_RW(addr, read_write);
 
+	/* Always clear the log entries */
+	memset(priv->log, 0, ISMT_LOG_ENTRIES * sizeof(u32));
+
 	/* Initialize common control bits */
 	if (likely(pci_dev_msi_enabled(priv->pci_dev)))
 		desc->control = ISMT_DESC_INT | ISMT_DESC_FAIR;
@@ -693,6 +699,8 @@ static void ismt_hw_init(struct ismt_priv *priv)
 	/* initialize the Master Descriptor Base Address (MDBA) */
 	writeq(priv->io_rng_dma, priv->smba + ISMT_MSTR_MDBA);
 
+	writeq(priv->log_dma, priv->smba + ISMT_GR_SMTICL);
+
 	/* initialize the Master Control Register (MCTRL) */
 	writel(ISMT_MCTRL_MEIE, priv->smba + ISMT_MSTR_MCTRL);
 
@@ -780,6 +788,12 @@ static int ismt_dev_init(struct ismt_priv *priv)
 	priv->head = 0;
 	init_completion(&priv->cmp);
 
+	priv->log = dmam_alloc_coherent(&priv->pci_dev->dev,
+					ISMT_LOG_ENTRIES * sizeof(u32),
+					&priv->log_dma, GFP_KERNEL);
+	if (!priv->log)
+		return -ENOMEM;
+
 	return 0;
 }
 
-- 
2.35.1


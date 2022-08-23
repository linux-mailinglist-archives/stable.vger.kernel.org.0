Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A933459D71F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348590AbiHWJNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348940AbiHWJLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:11:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F1B8670A;
        Tue, 23 Aug 2022 01:31:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1CEEB81C20;
        Tue, 23 Aug 2022 08:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD140C433C1;
        Tue, 23 Aug 2022 08:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243485;
        bh=2T9LF6WeK9qYQ/JCevFZRyjkSghw7v+l+v/fjmvZEQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U56gaPmeochb9HzxaiRxZcaKNFMKUC2SpduNW4MojEvfAt3fbcDtPM+zC0XvDqdlg
         iLAsIURfm/ShXDHNmkbOM1BM8nxvU8XzFde2L2BPc9dbCO61yW5nRoTnSSgeVcmQuj
         IdEcNJkm1qWx7yfkgsOrVSlikNE/zX1hQ+GWhsxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 292/365] mmc: tmio: avoid glitches when resetting
Date:   Tue, 23 Aug 2022 10:03:13 +0200
Message-Id: <20220823080130.426373931@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 2e586f8a5b0ed4a525014a692923ac96f6647816 ]

If we reset because of an error, we need to preserve values for the
clock frequency. Otherwise, glitches may be seen on the bus.

To achieve that, we introduce a 'preserve' parameter to the reset
function and the IP core specific reset callbacks to handle everything
accordingly.

Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20220625131722.1397-1-wsa@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi_core.c | 29 ++++++++++++++--------------
 drivers/mmc/host/tmio_mmc.c          |  2 +-
 drivers/mmc/host/tmio_mmc.h          |  6 +++++-
 drivers/mmc/host/tmio_mmc_core.c     | 28 +++++++++++++++++++++------
 4 files changed, 42 insertions(+), 23 deletions(-)

diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index 0d258b6e1a43..55f7b27c3de7 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -49,9 +49,6 @@
 #define HOST_MODE_GEN3_32BIT	(HOST_MODE_GEN3_WMODE | HOST_MODE_GEN3_BUSWIDTH)
 #define HOST_MODE_GEN3_64BIT	0
 
-#define CTL_SDIF_MODE	0xe6
-#define SDIF_MODE_HS400		BIT(0)
-
 #define SDHI_VER_GEN2_SDR50	0x490c
 #define SDHI_VER_RZ_A1		0x820b
 /* very old datasheets said 0x490c for SDR104, too. They are wrong! */
@@ -562,23 +559,25 @@ static void renesas_sdhi_scc_reset(struct tmio_mmc_host *host, struct renesas_sd
 }
 
 /* only populated for TMIO_MMC_MIN_RCAR2 */
-static void renesas_sdhi_reset(struct tmio_mmc_host *host)
+static void renesas_sdhi_reset(struct tmio_mmc_host *host, bool preserve)
 {
 	struct renesas_sdhi *priv = host_to_priv(host);
 	int ret;
 	u16 val;
 
-	if (priv->rstc) {
-		reset_control_reset(priv->rstc);
-		/* Unknown why but without polling reset status, it will hang */
-		read_poll_timeout(reset_control_status, ret, ret == 0, 1, 100,
-				  false, priv->rstc);
-		/* At least SDHI_VER_GEN2_SDR50 needs manual release of reset */
-		sd_ctrl_write16(host, CTL_RESET_SD, 0x0001);
-		priv->needs_adjust_hs400 = false;
-		renesas_sdhi_set_clock(host, host->clk_cache);
-	} else if (priv->scc_ctl) {
-		renesas_sdhi_scc_reset(host, priv);
+	if (!preserve) {
+		if (priv->rstc) {
+			reset_control_reset(priv->rstc);
+			/* Unknown why but without polling reset status, it will hang */
+			read_poll_timeout(reset_control_status, ret, ret == 0, 1, 100,
+					  false, priv->rstc);
+			/* At least SDHI_VER_GEN2_SDR50 needs manual release of reset */
+			sd_ctrl_write16(host, CTL_RESET_SD, 0x0001);
+			priv->needs_adjust_hs400 = false;
+			renesas_sdhi_set_clock(host, host->clk_cache);
+		} else if (priv->scc_ctl) {
+			renesas_sdhi_scc_reset(host, priv);
+		}
 	}
 
 	if (sd_ctrl_read16(host, CTL_VERSION) >= SDHI_VER_GEN3_SD) {
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index b55a29c53d9c..53a2ad9a24b8 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -75,7 +75,7 @@ static void tmio_mmc_set_clock(struct tmio_mmc_host *host,
 	tmio_mmc_clk_start(host);
 }
 
-static void tmio_mmc_reset(struct tmio_mmc_host *host)
+static void tmio_mmc_reset(struct tmio_mmc_host *host, bool preserve)
 {
 	sd_ctrl_write16(host, CTL_RESET_SDIO, 0x0000);
 	usleep_range(10000, 11000);
diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index e754bb3f5c32..501613c74406 100644
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -42,6 +42,7 @@
 #define CTL_DMA_ENABLE 0xd8
 #define CTL_RESET_SD 0xe0
 #define CTL_VERSION 0xe2
+#define CTL_SDIF_MODE 0xe6 /* only known on R-Car 2+ */
 
 /* Definitions for values the CTL_STOP_INTERNAL_ACTION register can take */
 #define TMIO_STOP_STP		BIT(0)
@@ -98,6 +99,9 @@
 /* Definitions for values the CTL_DMA_ENABLE register can take */
 #define DMA_ENABLE_DMASDRW	BIT(1)
 
+/* Definitions for values the CTL_SDIF_MODE register can take */
+#define SDIF_MODE_HS400		BIT(0) /* only known on R-Car 2+ */
+
 /* Define some IRQ masks */
 /* This is the mask used at reset by the chip */
 #define TMIO_MASK_ALL           0x837f031d
@@ -181,7 +185,7 @@ struct tmio_mmc_host {
 	int (*multi_io_quirk)(struct mmc_card *card,
 			      unsigned int direction, int blk_size);
 	int (*write16_hook)(struct tmio_mmc_host *host, int addr);
-	void (*reset)(struct tmio_mmc_host *host);
+	void (*reset)(struct tmio_mmc_host *host, bool preserve);
 	bool (*check_retune)(struct tmio_mmc_host *host, struct mmc_request *mrq);
 	void (*fixup_request)(struct tmio_mmc_host *host, struct mmc_request *mrq);
 	unsigned int (*get_timeout_cycles)(struct tmio_mmc_host *host);
diff --git a/drivers/mmc/host/tmio_mmc_core.c b/drivers/mmc/host/tmio_mmc_core.c
index a5850d83908b..437048bb8027 100644
--- a/drivers/mmc/host/tmio_mmc_core.c
+++ b/drivers/mmc/host/tmio_mmc_core.c
@@ -179,8 +179,17 @@ static void tmio_mmc_set_bus_width(struct tmio_mmc_host *host,
 	sd_ctrl_write16(host, CTL_SD_MEM_CARD_OPT, reg);
 }
 
-static void tmio_mmc_reset(struct tmio_mmc_host *host)
+static void tmio_mmc_reset(struct tmio_mmc_host *host, bool preserve)
 {
+	u16 card_opt, clk_ctrl, sdif_mode;
+
+	if (preserve) {
+		card_opt = sd_ctrl_read16(host, CTL_SD_MEM_CARD_OPT);
+		clk_ctrl = sd_ctrl_read16(host, CTL_SD_CARD_CLK_CTL);
+		if (host->pdata->flags & TMIO_MMC_MIN_RCAR2)
+			sdif_mode = sd_ctrl_read16(host, CTL_SDIF_MODE);
+	}
+
 	/* FIXME - should we set stop clock reg here */
 	sd_ctrl_write16(host, CTL_RESET_SD, 0x0000);
 	usleep_range(10000, 11000);
@@ -190,7 +199,7 @@ static void tmio_mmc_reset(struct tmio_mmc_host *host)
 	tmio_mmc_abort_dma(host);
 
 	if (host->reset)
-		host->reset(host);
+		host->reset(host, preserve);
 
 	sd_ctrl_write32_as_16_and_16(host, CTL_IRQ_MASK, host->sdcard_irq_mask_all);
 	host->sdcard_irq_mask = host->sdcard_irq_mask_all;
@@ -206,6 +215,13 @@ static void tmio_mmc_reset(struct tmio_mmc_host *host)
 		sd_ctrl_write16(host, CTL_TRANSACTION_CTL, 0x0001);
 	}
 
+	if (preserve) {
+		sd_ctrl_write16(host, CTL_SD_MEM_CARD_OPT, card_opt);
+		sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, clk_ctrl);
+		if (host->pdata->flags & TMIO_MMC_MIN_RCAR2)
+			sd_ctrl_write16(host, CTL_SDIF_MODE, sdif_mode);
+	}
+
 	if (host->mmc->card)
 		mmc_retune_needed(host->mmc);
 }
@@ -248,7 +264,7 @@ static void tmio_mmc_reset_work(struct work_struct *work)
 
 	spin_unlock_irqrestore(&host->lock, flags);
 
-	tmio_mmc_reset(host);
+	tmio_mmc_reset(host, true);
 
 	/* Ready for new calls */
 	host->mrq = NULL;
@@ -961,7 +977,7 @@ static void tmio_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		tmio_mmc_power_off(host);
 		/* For R-Car Gen2+, we need to reset SDHI specific SCC */
 		if (host->pdata->flags & TMIO_MMC_MIN_RCAR2)
-			tmio_mmc_reset(host);
+			tmio_mmc_reset(host, false);
 
 		host->set_clock(host, 0);
 		break;
@@ -1189,7 +1205,7 @@ int tmio_mmc_host_probe(struct tmio_mmc_host *_host)
 		_host->sdcard_irq_mask_all = TMIO_MASK_ALL;
 
 	_host->set_clock(_host, 0);
-	tmio_mmc_reset(_host);
+	tmio_mmc_reset(_host, false);
 
 	spin_lock_init(&_host->lock);
 	mutex_init(&_host->ios_lock);
@@ -1285,7 +1301,7 @@ int tmio_mmc_host_runtime_resume(struct device *dev)
 	struct tmio_mmc_host *host = dev_get_drvdata(dev);
 
 	tmio_mmc_clk_enable(host);
-	tmio_mmc_reset(host);
+	tmio_mmc_reset(host, false);
 
 	if (host->clk_cache)
 		host->set_clock(host, host->clk_cache);
-- 
2.35.1




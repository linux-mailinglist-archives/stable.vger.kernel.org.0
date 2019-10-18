Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C777DC154
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 11:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442438AbfJRJjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 05:39:53 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60999 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442433AbfJRJjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 05:39:53 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1iLOjf-0006mw-3H; Fri, 18 Oct 2019 11:39:51 +0200
Received: from sha by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1iLOje-0007me-LL; Fri, 18 Oct 2019 11:39:50 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-mmc@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Bruno Thomsen <bruno.thomsen@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] mmc: mxs: fix flags passed to dmaengine_prep_slave_sg
Date:   Fri, 18 Oct 2019 11:39:34 +0200
Message-Id: <20191018093934.29695-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since ceeeb99cd821 we no longer abuse the DMA_CTRL_ACK flag for custom
driver use and introduced the MXS_DMA_CTRL_WAIT4END instead. We have not
changed all users to this flag though. This patch fixes it for the
mxs-mmc driver.

Fixes: ceeeb99cd821 ("dmaengine: mxs: rename custom flag")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Tested-by: Fabio Estevam <festevam@gmail.com>
Reported-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Tested-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/mmc/host/mxs-mmc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 78e7e350655c..4031217d21c3 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -17,6 +17,7 @@
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
+#include <linux/dma/mxs-dma.h>
 #include <linux/highmem.h>
 #include <linux/clk.h>
 #include <linux/err.h>
@@ -266,7 +267,7 @@ static void mxs_mmc_bc(struct mxs_mmc_host *host)
 	ssp->ssp_pio_words[2] = cmd1;
 	ssp->dma_dir = DMA_NONE;
 	ssp->slave_dirn = DMA_TRANS_NONE;
-	desc = mxs_mmc_prep_dma(host, DMA_CTRL_ACK);
+	desc = mxs_mmc_prep_dma(host, MXS_DMA_CTRL_WAIT4END);
 	if (!desc)
 		goto out;
 
@@ -311,7 +312,7 @@ static void mxs_mmc_ac(struct mxs_mmc_host *host)
 	ssp->ssp_pio_words[2] = cmd1;
 	ssp->dma_dir = DMA_NONE;
 	ssp->slave_dirn = DMA_TRANS_NONE;
-	desc = mxs_mmc_prep_dma(host, DMA_CTRL_ACK);
+	desc = mxs_mmc_prep_dma(host, MXS_DMA_CTRL_WAIT4END);
 	if (!desc)
 		goto out;
 
@@ -441,7 +442,7 @@ static void mxs_mmc_adtc(struct mxs_mmc_host *host)
 	host->data = data;
 	ssp->dma_dir = dma_data_dir;
 	ssp->slave_dirn = slave_dirn;
-	desc = mxs_mmc_prep_dma(host, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	desc = mxs_mmc_prep_dma(host, DMA_PREP_INTERRUPT | MXS_DMA_CTRL_WAIT4END);
 	if (!desc)
 		goto out;
 
-- 
2.23.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF07E6816
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731751AbfJ0VZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732770AbfJ0VZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:25:35 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0651B21783;
        Sun, 27 Oct 2019 21:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211534;
        bh=Y2PGDeGpqDF5Aq1B/bYZdGBz4DvQrgjH7TQuNiejeWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNfTg1j2vaPklHnlY1ZtqEdBUG8BDX0l2+2NuLm3sof2SSvI9FVCCcEBDgkUtvMA6
         G00cL6Qt+/6WWIXz8IEU1Qoi+iI+xkc8BpU5BuwI7zyaw7OjhtRA3YxusDvOwrgpxp
         pVUXe4sZY8+Bt0jVY9ZEU7Aug18zCeMV8cUW4a9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Bruno Thomsen <bruno.thomsen@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.3 141/197] mmc: mxs: fix flags passed to dmaengine_prep_slave_sg
Date:   Sun, 27 Oct 2019 22:00:59 +0100
Message-Id: <20191027203359.315800560@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 2bb9f7566ba7ab3c2154964461e37b52cdc6b91b upstream.

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
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/mxs-mmc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

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
@@ -266,7 +267,7 @@ static void mxs_mmc_bc(struct mxs_mmc_ho
 	ssp->ssp_pio_words[2] = cmd1;
 	ssp->dma_dir = DMA_NONE;
 	ssp->slave_dirn = DMA_TRANS_NONE;
-	desc = mxs_mmc_prep_dma(host, DMA_CTRL_ACK);
+	desc = mxs_mmc_prep_dma(host, MXS_DMA_CTRL_WAIT4END);
 	if (!desc)
 		goto out;
 
@@ -311,7 +312,7 @@ static void mxs_mmc_ac(struct mxs_mmc_ho
 	ssp->ssp_pio_words[2] = cmd1;
 	ssp->dma_dir = DMA_NONE;
 	ssp->slave_dirn = DMA_TRANS_NONE;
-	desc = mxs_mmc_prep_dma(host, DMA_CTRL_ACK);
+	desc = mxs_mmc_prep_dma(host, MXS_DMA_CTRL_WAIT4END);
 	if (!desc)
 		goto out;
 
@@ -441,7 +442,7 @@ static void mxs_mmc_adtc(struct mxs_mmc_
 	host->data = data;
 	ssp->dma_dir = dma_data_dir;
 	ssp->slave_dirn = slave_dirn;
-	desc = mxs_mmc_prep_dma(host, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	desc = mxs_mmc_prep_dma(host, DMA_PREP_INTERRUPT | MXS_DMA_CTRL_WAIT4END);
 	if (!desc)
 		goto out;
 



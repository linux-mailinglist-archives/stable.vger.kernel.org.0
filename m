Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D56B44168F
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhKAJ0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:26:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232752AbhKAJYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:24:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5957261154;
        Mon,  1 Nov 2021 09:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758489;
        bh=WMv329dLJ1ZlxO+LN/bFjEC92A9Aqdkc0L0fRQbiXM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKuAFWxvL/5LKVuVArkCrc80LCX8LA/6jhgKJuu+wbVu3Wr2IyuseJU5iYfGW1Luh
         uyhF+Aj8e5RTUhH0ywoiHy01gUnefrH7AXkTK9YnuejtNCZqEr3eRwFvXFeFFZ0ogJ
         DFbAQ+F69Lj87sl7C0hgjl0g/pZPKgYk0wGtBWDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 20/35] mmc: sdhci-esdhc-imx: clear the buffer_read_ready to reset standard tuning circuit
Date:   Mon,  1 Nov 2021 10:17:32 +0100
Message-Id: <20211101082456.370421249@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082451.430720900@linuxfoundation.org>
References: <20211101082451.430720900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

commit 9af372dc70e9fdcbb70939dac75365e7b88580b4 upstream.

To reset standard tuning circuit completely, after clear ESDHC_MIX_CTRL_EXE_TUNE,
also need to clear bit buffer_read_ready, this operation will finally clear the
USDHC IP internal logic flag execute_tuning_with_clr_buf, make sure the following
normal data transfer will not be impacted by standard tuning logic used before.

Find this issue when do quick SD card insert/remove stress test. During standard
tuning prodedure, if remove SD card, USDHC standard tuning logic can't clear the
internal flag execute_tuning_with_clr_buf. Next time when insert SD card, all
data related commands can't get any data related interrupts, include data transfer
complete interrupt, data timeout interrupt, data CRC interrupt, data end bit interrupt.
Always trigger software timeout issue. Even reset the USDHC through bits in register
SYS_CTRL (0x2C, bit28 reset tuning, bit26 reset data, bit 25 reset command, bit 24
reset all) can't recover this. From the user's point of view, USDHC stuck, SD can't
be recognized any more.

Fixes: d9370424c948 ("mmc: sdhci-esdhc-imx: reset tuning circuit when power on mmc card")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1634263236-6111-1-git-send-email-haibo.chen@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -947,6 +947,7 @@ static void esdhc_reset_tuning(struct sd
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
 	u32 ctrl;
+	int ret;
 
 	/* Reset the tuning circuit */
 	if (esdhc_is_usdhc(imx_data)) {
@@ -959,7 +960,22 @@ static void esdhc_reset_tuning(struct sd
 		} else if (imx_data->socdata->flags & ESDHC_FLAG_STD_TUNING) {
 			ctrl = readl(host->ioaddr + SDHCI_AUTO_CMD_STATUS);
 			ctrl &= ~ESDHC_MIX_CTRL_SMPCLK_SEL;
+			ctrl &= ~ESDHC_MIX_CTRL_EXE_TUNE;
 			writel(ctrl, host->ioaddr + SDHCI_AUTO_CMD_STATUS);
+			/* Make sure ESDHC_MIX_CTRL_EXE_TUNE cleared */
+			ret = readl_poll_timeout(host->ioaddr + SDHCI_AUTO_CMD_STATUS,
+				ctrl, !(ctrl & ESDHC_MIX_CTRL_EXE_TUNE), 1, 50);
+			if (ret == -ETIMEDOUT)
+				dev_warn(mmc_dev(host->mmc),
+				 "Warning! clear execute tuning bit failed\n");
+			/*
+			 * SDHCI_INT_DATA_AVAIL is W1C bit, set this bit will clear the
+			 * usdhc IP internal logic flag execute_tuning_with_clr_buf, which
+			 * will finally make sure the normal data transfer logic correct.
+			 */
+			ctrl = readl(host->ioaddr + SDHCI_INT_STATUS);
+			ctrl |= SDHCI_INT_DATA_AVAIL;
+			writel(ctrl, host->ioaddr + SDHCI_INT_STATUS);
 		}
 	}
 }



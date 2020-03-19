Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C9718B6F6
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbgCSNVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730120AbgCSNVa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:21:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E18B3206D7;
        Thu, 19 Mar 2020 13:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624089;
        bh=JwmYO+T78n5hPTS8cxcIzBbs9aFdkcJ8A4d/0YHzVdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQEYogs7ohzYWNJTc+weCBQ+v1meLT+nPtjgNHlYyk9jcGdM0gsWgDm45Dz1dePPB
         pJoK7zBQ8VePHWfvpQ0oExKPe/9IK/ZolTiWhFm47jYYGN5a2J7tR5DSggiDyHWcfO
         5XKFUKgRS3dKljRzczcCoRcIp3sC6SrJvcfdOThQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/48] mmc: sdhci-omap: Dont finish_mrq() on a command error during tuning
Date:   Thu, 19 Mar 2020 14:04:16 +0100
Message-Id: <20200319123913.644900190@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
References: <20200319123902.941451241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

[ Upstream commit 5c41ea6d52003b5bc77c2a82fd5ca7d480237d89 ]

commit 5b0d62108b46 ("mmc: sdhci-omap: Add platform specific reset
callback") skips data resets during tuning operation. Because of this,
a data error or data finish interrupt might still arrive after a command
error has been handled and the mrq ended. This ends up with a "mmc0: Got
data interrupt 0x00000002 even though no data operation was in progress"
error message.

Fix this by adding a platform specific callback for sdhci_irq. Mark the
mrq as a failure but wait for a data interrupt instead of calling
finish_mrq().

Fixes: 5b0d62108b46 ("mmc: sdhci-omap: Add platform specific reset
callback")
Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-omap.c | 38 +++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/mmc/host/sdhci-omap.c b/drivers/mmc/host/sdhci-omap.c
index 79ee5fc5a2013..833e13cabd2a8 100644
--- a/drivers/mmc/host/sdhci-omap.c
+++ b/drivers/mmc/host/sdhci-omap.c
@@ -801,6 +801,43 @@ void sdhci_omap_reset(struct sdhci_host *host, u8 mask)
 	sdhci_reset(host, mask);
 }
 
+#define CMD_ERR_MASK (SDHCI_INT_CRC | SDHCI_INT_END_BIT | SDHCI_INT_INDEX |\
+		      SDHCI_INT_TIMEOUT)
+#define CMD_MASK (CMD_ERR_MASK | SDHCI_INT_RESPONSE)
+
+static u32 sdhci_omap_irq(struct sdhci_host *host, u32 intmask)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_omap_host *omap_host = sdhci_pltfm_priv(pltfm_host);
+
+	if (omap_host->is_tuning && host->cmd && !host->data_early &&
+	    (intmask & CMD_ERR_MASK)) {
+
+		/*
+		 * Since we are not resetting data lines during tuning
+		 * operation, data error or data complete interrupts
+		 * might still arrive. Mark this request as a failure
+		 * but still wait for the data interrupt
+		 */
+		if (intmask & SDHCI_INT_TIMEOUT)
+			host->cmd->error = -ETIMEDOUT;
+		else
+			host->cmd->error = -EILSEQ;
+
+		host->cmd = NULL;
+
+		/*
+		 * Sometimes command error interrupts and command complete
+		 * interrupt will arrive together. Clear all command related
+		 * interrupts here.
+		 */
+		sdhci_writel(host, intmask & CMD_MASK, SDHCI_INT_STATUS);
+		intmask &= ~CMD_MASK;
+	}
+
+	return intmask;
+}
+
 static struct sdhci_ops sdhci_omap_ops = {
 	.set_clock = sdhci_omap_set_clock,
 	.set_power = sdhci_omap_set_power,
@@ -811,6 +848,7 @@ static struct sdhci_ops sdhci_omap_ops = {
 	.platform_send_init_74_clocks = sdhci_omap_init_74_clocks,
 	.reset = sdhci_omap_reset,
 	.set_uhs_signaling = sdhci_omap_set_uhs_signaling,
+	.irq = sdhci_omap_irq,
 };
 
 static int sdhci_omap_set_capabilities(struct sdhci_omap_host *omap_host)
-- 
2.20.1




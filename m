Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAC61ACA34
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410444AbgDPPcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:32:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgDPNmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:42:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D89120732;
        Thu, 16 Apr 2020 13:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044532;
        bh=tmMhdRm1zeV2HIH7q7LunDiqIpUWh/7aYo8fmRoyCdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlIQm8vwzTcAnH4b2Sv7x2Fiqnxfo8fkgnG2xmsEOXLatKszLUnx+Eh2yP+7W5ZrW
         mSgUvDUm5vkAuXAraVZmSX8TjWzgEMj5iaeYzHLLLU6b5BC5hRALD3l+scFBfpcdws
         G2SZF5rXv3zgx+bWdKwgV/7O6DDX+Af1Uyq5Upu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 257/257] mmc: sdhci: Refactor sdhci_set_timeout()
Date:   Thu, 16 Apr 2020 15:25:08 +0200
Message-Id: <20200416131357.587820476@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

[ Upstream commit 7d76ed77cfbd39468ae58d419f537d35ca892d83 ]

Refactor sdhci_set_timeout() such that platform drivers can do some
functionality in a set_timeout() callback and then call
__sdhci_set_timeout() to complete the operation.

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20200116105154.7685-7-faiz_abbas@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci.c | 38 ++++++++++++++++++++------------------
 drivers/mmc/host/sdhci.h |  1 +
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 29c854e48bc69..1c9ca6864be36 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1003,27 +1003,29 @@ void sdhci_set_data_timeout_irq(struct sdhci_host *host, bool enable)
 }
 EXPORT_SYMBOL_GPL(sdhci_set_data_timeout_irq);
 
-static void sdhci_set_timeout(struct sdhci_host *host, struct mmc_command *cmd)
+void __sdhci_set_timeout(struct sdhci_host *host, struct mmc_command *cmd)
 {
-	u8 count;
-
-	if (host->ops->set_timeout) {
-		host->ops->set_timeout(host, cmd);
-	} else {
-		bool too_big = false;
-
-		count = sdhci_calc_timeout(host, cmd, &too_big);
+	bool too_big = false;
+	u8 count = sdhci_calc_timeout(host, cmd, &too_big);
+
+	if (too_big &&
+	    host->quirks2 & SDHCI_QUIRK2_DISABLE_HW_TIMEOUT) {
+		sdhci_calc_sw_timeout(host, cmd);
+		sdhci_set_data_timeout_irq(host, false);
+	} else if (!(host->ier & SDHCI_INT_DATA_TIMEOUT)) {
+		sdhci_set_data_timeout_irq(host, true);
+	}
 
-		if (too_big &&
-		    host->quirks2 & SDHCI_QUIRK2_DISABLE_HW_TIMEOUT) {
-			sdhci_calc_sw_timeout(host, cmd);
-			sdhci_set_data_timeout_irq(host, false);
-		} else if (!(host->ier & SDHCI_INT_DATA_TIMEOUT)) {
-			sdhci_set_data_timeout_irq(host, true);
-		}
+	sdhci_writeb(host, count, SDHCI_TIMEOUT_CONTROL);
+}
+EXPORT_SYMBOL_GPL(__sdhci_set_timeout);
 
-		sdhci_writeb(host, count, SDHCI_TIMEOUT_CONTROL);
-	}
+static void sdhci_set_timeout(struct sdhci_host *host, struct mmc_command *cmd)
+{
+	if (host->ops->set_timeout)
+		host->ops->set_timeout(host, cmd);
+	else
+		__sdhci_set_timeout(host, cmd);
 }
 
 static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_command *cmd)
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 4613d71b3cd6e..76e69288632db 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -796,5 +796,6 @@ void sdhci_reset_tuning(struct sdhci_host *host);
 void sdhci_send_tuning(struct sdhci_host *host, u32 opcode);
 void sdhci_abort_tuning(struct sdhci_host *host, u32 opcode);
 void sdhci_set_data_timeout_irq(struct sdhci_host *host, bool enable);
+void __sdhci_set_timeout(struct sdhci_host *host, struct mmc_command *cmd);
 
 #endif /* __SDHCI_HW_H */
-- 
2.20.1




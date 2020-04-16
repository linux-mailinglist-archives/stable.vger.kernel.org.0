Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DB11ACA3A
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408593AbgDPPcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbgDPNmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:42:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B89A2214D8;
        Thu, 16 Apr 2020 13:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044530;
        bh=zKyqng7UQLIRnBl9HEhPGNekpS+6cG07OfzlHTV9SNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zc5LEz+lDAbrXtEtCe0YTHqCBZEnUxW3uoBpI/UG0Hd9dByzqvyryK54kjRCm+N8d
         wRYEb/Ogan+LXdIMrKhsbr97iEKFq0sfvyQpwfrDT7npwazWnTiC89Kn8+r/uV5afM
         wiAPbEMndFJkWSZyhBT1R0ADHdLaYPIXrGgSbHVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Faiz Abbas <faiz_abbas@ti.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 256/257] mmc: sdhci: Convert sdhci_set_timeout_irq() to non-static
Date:   Thu, 16 Apr 2020 15:25:07 +0200
Message-Id: <20200416131357.487296244@linuxfoundation.org>
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

[ Upstream commit 7907ebe741a7f14ed12889ebe770438a4ff47613 ]

Export sdhci_set_timeout_irq() so that it is accessible from platform drivers.

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20200116105154.7685-6-faiz_abbas@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci.c | 3 ++-
 drivers/mmc/host/sdhci.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 659a9459ace34..29c854e48bc69 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -992,7 +992,7 @@ static void sdhci_set_transfer_irqs(struct sdhci_host *host)
 	sdhci_writel(host, host->ier, SDHCI_SIGNAL_ENABLE);
 }
 
-static void sdhci_set_data_timeout_irq(struct sdhci_host *host, bool enable)
+void sdhci_set_data_timeout_irq(struct sdhci_host *host, bool enable)
 {
 	if (enable)
 		host->ier |= SDHCI_INT_DATA_TIMEOUT;
@@ -1001,6 +1001,7 @@ static void sdhci_set_data_timeout_irq(struct sdhci_host *host, bool enable)
 	sdhci_writel(host, host->ier, SDHCI_INT_ENABLE);
 	sdhci_writel(host, host->ier, SDHCI_SIGNAL_ENABLE);
 }
+EXPORT_SYMBOL_GPL(sdhci_set_data_timeout_irq);
 
 static void sdhci_set_timeout(struct sdhci_host *host, struct mmc_command *cmd)
 {
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index fe83ece6965b1..4613d71b3cd6e 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -795,5 +795,6 @@ void sdhci_end_tuning(struct sdhci_host *host);
 void sdhci_reset_tuning(struct sdhci_host *host);
 void sdhci_send_tuning(struct sdhci_host *host, u32 opcode);
 void sdhci_abort_tuning(struct sdhci_host *host, u32 opcode);
+void sdhci_set_data_timeout_irq(struct sdhci_host *host, bool enable);
 
 #endif /* __SDHCI_HW_H */
-- 
2.20.1




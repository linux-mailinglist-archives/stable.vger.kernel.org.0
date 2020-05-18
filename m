Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB921D8231
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731261AbgERRyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731256AbgERRyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:54:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E823F20715;
        Mon, 18 May 2020 17:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824450;
        bh=MU67RfYfMuV3qxgKka3yAsweG+AZhjJO5xzh4rxpdgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0F24r5sLBjTpBbuKn6TnV7ZawqY3k9eeOfwXMHQdDErVSfI5jMsIT6S6a6Z2OHnYg
         uZAtrz5qvooe8rjyFSQHNmVEfn6bZ1Bp67iRKBDC/e9QnEbelZ4nY0XzzwtgOh58Oz
         /POf4mT48O19sKkhJlz61IiHMSZrgsJjz4jzkwwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raul E Rangel <rrangel@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/147] mmc: sdhci-acpi: Add SDHCI_QUIRK2_BROKEN_64_BIT_DMA for AMDI0040
Date:   Mon, 18 May 2020 19:35:40 +0200
Message-Id: <20200518173515.907161000@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raul E Rangel <rrangel@chromium.org>

[ Upstream commit 45a3fe3bf93b7cfeddc28ef7386555e05dc57f06 ]

The AMD eMMC 5.0 controller does not support 64 bit DMA.

Fixes: 34597a3f60b1 ("mmc: sdhci-acpi: Add support for ACPI HID of AMD Controller with HS400")
Signed-off-by: Raul E Rangel <rrangel@chromium.org>
Link: https://marc.info/?l=linux-mmc&m=158879884514552&w=2
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20200508165344.1.Id5bb8b1ae7ea576f26f9d91c761df7ccffbf58c5@changeid
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-acpi.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
index 1604f512c7bd1..01fc437ed9659 100644
--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -602,10 +602,12 @@ static int sdhci_acpi_emmc_amd_probe_slot(struct platform_device *pdev,
 }
 
 static const struct sdhci_acpi_slot sdhci_acpi_slot_amd_emmc = {
-	.chip   = &sdhci_acpi_chip_amd,
-	.caps   = MMC_CAP_8_BIT_DATA | MMC_CAP_NONREMOVABLE,
-	.quirks = SDHCI_QUIRK_32BIT_DMA_ADDR | SDHCI_QUIRK_32BIT_DMA_SIZE |
-			SDHCI_QUIRK_32BIT_ADMA_SIZE,
+	.chip		= &sdhci_acpi_chip_amd,
+	.caps		= MMC_CAP_8_BIT_DATA | MMC_CAP_NONREMOVABLE,
+	.quirks		= SDHCI_QUIRK_32BIT_DMA_ADDR |
+			  SDHCI_QUIRK_32BIT_DMA_SIZE |
+			  SDHCI_QUIRK_32BIT_ADMA_SIZE,
+	.quirks2	= SDHCI_QUIRK2_BROKEN_64_BIT_DMA,
 	.probe_slot     = sdhci_acpi_emmc_amd_probe_slot,
 };
 
-- 
2.20.1




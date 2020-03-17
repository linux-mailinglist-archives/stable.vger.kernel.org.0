Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA6718811F
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgCQLLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729178AbgCQLLN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:11:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10B8A205ED;
        Tue, 17 Mar 2020 11:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443471;
        bh=eFg44DtLtx240mxrbqaeZnXCo/psQRsqmlQBJ5JYo0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t78Y+1jxL4DhIEb+ZaNAFi1D+d2szoNFiUC0oTkXz1B6qD3sn+1QHNowmN5ba/tuZ
         DwLRNSgQDKXoQ/l5z1/yf44O1NCKj2ZOnjTXZgPs9ppu+hgrqi+1ZxrlS9OsPQznMQ
         ZYY1B2+pH/8NmgvNjBMR+PGblqgqdWvqbzmoyhk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ben Chuang <ben.chuang@genesyslogic.com.tw>,
        Raul E Rangel <rrangel@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.5 091/151] mmc: sdhci-pci-gli: Enable MSI interrupt for GL975x
Date:   Tue, 17 Mar 2020 11:55:01 +0100
Message-Id: <20200317103332.914733778@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Chuang <ben.chuang@genesyslogic.com.tw>

commit 31e43f31890ca6e909b27dcb539252b46aa465da upstream.

Enable MSI interrupt for GL9750/GL9755. Some platforms
do not support PCI INTx and devices can not work without
interrupt. Like messages below:

[    4.487132] sdhci-pci 0000:01:00.0: SDHCI controller found [17a0:9755] (rev 0)
[    4.487198] ACPI BIOS Error (bug): Could not resolve symbol [\_SB.PCI0.PBR2._PRT.APS2], AE_NOT_FOUND (20190816/psargs-330)
[    4.487397] ACPI Error: Aborting method \_SB.PCI0.PBR2._PRT due to previous error (AE_NOT_FOUND) (20190816/psparse-529)
[    4.487707] pcieport 0000:00:01.3: can't derive routing for PCI INT A
[    4.487709] sdhci-pci 0000:01:00.0: PCI INT A: no GSI

Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
Tested-by: Raul E Rangel <rrangel@chromium.org>
Fixes: e51df6ce668a ("mmc: host: sdhci-pci: Add Genesys Logic GL975x support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200219092900.9151-1-benchuanggli@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-pci-gli.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -262,10 +262,26 @@ static int gl9750_execute_tuning(struct
 	return 0;
 }
 
+static void gli_pcie_enable_msi(struct sdhci_pci_slot *slot)
+{
+	int ret;
+
+	ret = pci_alloc_irq_vectors(slot->chip->pdev, 1, 1,
+				    PCI_IRQ_MSI | PCI_IRQ_MSIX);
+	if (ret < 0) {
+		pr_warn("%s: enable PCI MSI failed, error=%d\n",
+		       mmc_hostname(slot->host->mmc), ret);
+		return;
+	}
+
+	slot->host->irq = pci_irq_vector(slot->chip->pdev, 0);
+}
+
 static int gli_probe_slot_gl9750(struct sdhci_pci_slot *slot)
 {
 	struct sdhci_host *host = slot->host;
 
+	gli_pcie_enable_msi(slot);
 	slot->host->mmc->caps2 |= MMC_CAP2_NO_SDIO;
 	sdhci_enable_v4_mode(host);
 
@@ -276,6 +292,7 @@ static int gli_probe_slot_gl9755(struct
 {
 	struct sdhci_host *host = slot->host;
 
+	gli_pcie_enable_msi(slot);
 	slot->host->mmc->caps2 |= MMC_CAP2_NO_SDIO;
 	sdhci_enable_v4_mode(host);
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2753C1D8566
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbgERSSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:18:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730700AbgERRzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:55:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C650A205CB;
        Mon, 18 May 2020 17:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824540;
        bh=GNu2r6irny4xGrrsA7iFeCohSmwcngBd3yJPvL+gAFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w96D89flZQewYL9YZu9O6+8SELvwUg/6MM1H+zb5Qo6yZbVdsbH4xNGp8dpL4Ugm+
         3mjFV/Q2kdnyd5Cd6lKU1E7jr0gTzus1gTMZ6ERD4hbHRp5uALqwl0iEsfeCReh/Ce
         6qPpHlGILTw1QoLq0bwqqmjVxncLePi+qsYlFFPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Renius Chen <renius.chen@genesyslogic.com.tw>,
        Dave Flogeras <dflogeras2@gmail.com>,
        Ben Chuang <ben.chuang@genesyslogic.com.tw>,
        Vineeth Pillai <vineethrp@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Samuel Zou <zou_wei@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/147] mmc: sdhci-pci-gli: Fix no irq handler from suspend
Date:   Mon, 18 May 2020 19:36:16 +0200
Message-Id: <20200518173520.582438135@linuxfoundation.org>
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

From: Ben Chuang <ben.chuang@genesyslogic.com.tw>

[ Upstream commit 282ede76e47048eebc8ce5324b412890f0ec0a69 ]

The kernel prints a message similar to
"[   28.881959] do_IRQ: 5.36 No irq handler for vector"
when GL975x resumes from suspend. Implement a resume callback to fix this.

Fixes: 31e43f31890c ("mmc: sdhci-pci-gli: Enable MSI interrupt for GL975x")
Co-developed-by: Renius Chen <renius.chen@genesyslogic.com.tw>
Signed-off-by: Renius Chen <renius.chen@genesyslogic.com.tw>
Tested-by: Dave Flogeras <dflogeras2@gmail.com>
Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
Tested-by: Vineeth Pillai <vineethrp@gmail.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20200427103048.20785-1-benchuanggli@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Samuel Zou <zou_wei@huawei.com>
[Samuel Zou: Make sdhci_pci_gli_resume() static]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-pci-gli.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci-gli.c b/drivers/mmc/host/sdhci-pci-gli.c
index ce15a05f23d41..ff39d81a5742c 100644
--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -334,6 +334,18 @@ static u32 sdhci_gl9750_readl(struct sdhci_host *host, int reg)
 	return value;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int sdhci_pci_gli_resume(struct sdhci_pci_chip *chip)
+{
+	struct sdhci_pci_slot *slot = chip->slots[0];
+
+	pci_free_irq_vectors(slot->chip->pdev);
+	gli_pcie_enable_msi(slot);
+
+	return sdhci_pci_resume_host(chip);
+}
+#endif
+
 static const struct sdhci_ops sdhci_gl9755_ops = {
 	.set_clock		= sdhci_set_clock,
 	.enable_dma		= sdhci_pci_enable_dma,
@@ -348,6 +360,9 @@ const struct sdhci_pci_fixes sdhci_gl9755 = {
 	.quirks2	= SDHCI_QUIRK2_BROKEN_DDR50,
 	.probe_slot	= gli_probe_slot_gl9755,
 	.ops            = &sdhci_gl9755_ops,
+#ifdef CONFIG_PM_SLEEP
+	.resume         = sdhci_pci_gli_resume,
+#endif
 };
 
 static const struct sdhci_ops sdhci_gl9750_ops = {
@@ -366,4 +381,7 @@ const struct sdhci_pci_fixes sdhci_gl9750 = {
 	.quirks2	= SDHCI_QUIRK2_BROKEN_DDR50,
 	.probe_slot	= gli_probe_slot_gl9750,
 	.ops            = &sdhci_gl9750_ops,
+#ifdef CONFIG_PM_SLEEP
+	.resume         = sdhci_pci_gli_resume,
+#endif
 };
-- 
2.20.1




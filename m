Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1709426B3E2
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbgIOXMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727246AbgIOOki (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:40:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B73D224D2;
        Tue, 15 Sep 2020 14:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180203;
        bh=EvKPk2aTXloeffpkx3rSI2pJWXaNbMqEKb1MTfgLSjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwSsh/1nbKFOodn52fjZ56ctkoPAtws+aedRzXspp09VH3SMnd2zKNot6I9ITo5je
         /SGeGvPzT/gWcj/vQTdhxU4QrzS6qUP2qKuTCUUBCvnfcfVe6ORuyfagOTO9RAdWlz
         7XTSaDaOmRJ+wKIvsfQyWlcrjQOFMJAAq1BvzWQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.8 147/177] mmc: sdhci-of-esdhc: Dont walk device-tree on every interrupt
Date:   Tue, 15 Sep 2020 16:13:38 +0200
Message-Id: <20200915140700.698930271@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

commit 060522d89705f9d961ef1762dc1468645dd21fbd upstream.

Commit b214fe592ab7 ("mmc: sdhci-of-esdhc: add erratum eSDHC7 support")
added code to check for a specific compatible string in the device-tree
on every esdhc interrupat. Instead of doing this record the quirk in
struct sdhci_esdhc and lookup the struct in esdhc_irq.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20200903012029.25673-1-chris.packham@alliedtelesis.co.nz
Fixes: b214fe592ab7 ("mmc: sdhci-of-esdhc: add erratum eSDHC7 support")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-esdhc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -81,6 +81,7 @@ struct sdhci_esdhc {
 	bool quirk_tuning_erratum_type2;
 	bool quirk_ignore_data_inhibit;
 	bool quirk_delay_before_data_reset;
+	bool quirk_trans_complete_erratum;
 	bool in_sw_tuning;
 	unsigned int peripheral_clock;
 	const struct esdhc_clk_fixup *clk_fixup;
@@ -1177,10 +1178,11 @@ static void esdhc_set_uhs_signaling(stru
 
 static u32 esdhc_irq(struct sdhci_host *host, u32 intmask)
 {
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_esdhc *esdhc = sdhci_pltfm_priv(pltfm_host);
 	u32 command;
 
-	if (of_find_compatible_node(NULL, NULL,
-				"fsl,p2020-esdhc")) {
+	if (esdhc->quirk_trans_complete_erratum) {
 		command = SDHCI_GET_CMD(sdhci_readw(host,
 					SDHCI_COMMAND));
 		if (command == MMC_WRITE_MULTIPLE_BLOCK &&
@@ -1334,8 +1336,10 @@ static void esdhc_init(struct platform_d
 		esdhc->clk_fixup = match->data;
 	np = pdev->dev.of_node;
 
-	if (of_device_is_compatible(np, "fsl,p2020-esdhc"))
+	if (of_device_is_compatible(np, "fsl,p2020-esdhc")) {
 		esdhc->quirk_delay_before_data_reset = true;
+		esdhc->quirk_trans_complete_erratum = true;
+	}
 
 	clk = of_clk_get(np, 0);
 	if (!IS_ERR(clk)) {



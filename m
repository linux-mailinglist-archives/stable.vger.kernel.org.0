Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE628500F31
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239078AbiDNNZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244267AbiDNNYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:24:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535011EAE8;
        Thu, 14 Apr 2022 06:19:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E77AC61670;
        Thu, 14 Apr 2022 13:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F298BC385A5;
        Thu, 14 Apr 2022 13:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942369;
        bh=77qcZ1Uzak7g1HQpiucAyiTuDej5Yx4twTR1oQQDeQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4QnbJgsAHj3Ax+teTfkCNEh9MU5wOVpJrRuixm5p6cIRhcaRjLCyfYmNjhLQw2nN
         gIyCE5MUEiTWon4LbYo94w78S+Kyzq9tXfpsWTfscKHZVJa/1bPSiywn8rKTCsTnsG
         mseREn+Q2Oq45128bZtPK58HG6nFDiXo2NE4vQWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Qing <wangqing@vivo.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/338] spi: pxa2xx-pci: Balance reference count for PCI DMA device
Date:   Thu, 14 Apr 2022 15:09:34 +0200
Message-Id: <20220414110840.919447314@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 609d7ffdc42199a0ec949db057e3b4be6745d6c5 ]

The pci_get_slot() increases its reference count, the caller
must decrement the reference count by calling pci_dev_put().

Fixes: 743485ea3bee ("spi: pxa2xx-pci: Do a specific setup in a separate function")
Fixes: 25014521603f ("spi: pxa2xx-pci: Enable DMA for Intel Merrifield")
Reported-by: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220223191637.31147-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pxa2xx-pci.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
index 1736a48bbcce..54e316eb0891 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -72,14 +72,23 @@ static bool lpss_dma_filter(struct dma_chan *chan, void *param)
 	return true;
 }
 
+static void lpss_dma_put_device(void *dma_dev)
+{
+	pci_dev_put(dma_dev);
+}
+
 static int lpss_spi_setup(struct pci_dev *dev, struct pxa_spi_info *c)
 {
 	struct pci_dev *dma_dev;
+	int ret;
 
 	c->num_chipselect = 1;
 	c->max_clk_rate = 50000000;
 
 	dma_dev = pci_get_slot(dev->bus, PCI_DEVFN(PCI_SLOT(dev->devfn), 0));
+	ret = devm_add_action_or_reset(&dev->dev, lpss_dma_put_device, dma_dev);
+	if (ret)
+		return ret;
 
 	if (c->tx_param) {
 		struct dw_dma_slave *slave = c->tx_param;
@@ -103,8 +112,9 @@ static int lpss_spi_setup(struct pci_dev *dev, struct pxa_spi_info *c)
 
 static int mrfld_spi_setup(struct pci_dev *dev, struct pxa_spi_info *c)
 {
-	struct pci_dev *dma_dev = pci_get_slot(dev->bus, PCI_DEVFN(21, 0));
 	struct dw_dma_slave *tx, *rx;
+	struct pci_dev *dma_dev;
+	int ret;
 
 	switch (PCI_FUNC(dev->devfn)) {
 	case 0:
@@ -129,6 +139,11 @@ static int mrfld_spi_setup(struct pci_dev *dev, struct pxa_spi_info *c)
 		return -ENODEV;
 	}
 
+	dma_dev = pci_get_slot(dev->bus, PCI_DEVFN(21, 0));
+	ret = devm_add_action_or_reset(&dev->dev, lpss_dma_put_device, dma_dev);
+	if (ret)
+		return ret;
+
 	tx = c->tx_param;
 	tx->dma_dev = &dma_dev->dev;
 
-- 
2.34.1




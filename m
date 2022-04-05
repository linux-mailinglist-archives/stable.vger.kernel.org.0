Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBF44F3536
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245535AbiDEJMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244743AbiDEIwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3311C92A;
        Tue,  5 Apr 2022 01:43:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F141614E4;
        Tue,  5 Apr 2022 08:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112BAC385A0;
        Tue,  5 Apr 2022 08:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148186;
        bh=xIuKecHdhv3b4YQ0aWDboSEoCQ7kseCY+UT5iwlNlBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iT/EXzgrHi7la6/eYfYoa7gJBN9H+gG2aPAl7svSsKqMJSZksudx6K9Qoe6isQfvA
         rZTojtYhRvOm5vquF+VjQlZsHSeDPyNo8xv70QYvQA+kBjUhkqw1ShHMyYSjPC6eQT
         KJDXebtY7XBUsEDDbb89HRRyOMgSu7jB4dVifzzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Qing <wangqing@vivo.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0226/1017] spi: pxa2xx-pci: Balance reference count for PCI DMA device
Date:   Tue,  5 Apr 2022 09:18:59 +0200
Message-Id: <20220405070400.963127675@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 2e134eb4bd2c..6502fda6243e 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -76,14 +76,23 @@ static bool lpss_dma_filter(struct dma_chan *chan, void *param)
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
@@ -107,8 +116,9 @@ static int lpss_spi_setup(struct pci_dev *dev, struct pxa_spi_info *c)
 
 static int mrfld_spi_setup(struct pci_dev *dev, struct pxa_spi_info *c)
 {
-	struct pci_dev *dma_dev = pci_get_slot(dev->bus, PCI_DEVFN(21, 0));
 	struct dw_dma_slave *tx, *rx;
+	struct pci_dev *dma_dev;
+	int ret;
 
 	switch (PCI_FUNC(dev->devfn)) {
 	case 0:
@@ -133,6 +143,11 @@ static int mrfld_spi_setup(struct pci_dev *dev, struct pxa_spi_info *c)
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




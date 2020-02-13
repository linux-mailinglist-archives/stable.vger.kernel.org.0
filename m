Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0611F15C3BC
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgBMPnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:43:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387464AbgBMP1t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:49 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6404620661;
        Thu, 13 Feb 2020 15:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607669;
        bh=2LOS4tbupeTSygClD40dSb6uvh6u9TGMj8TmfoR5iNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gnPdq/eb82pZywKR0VZg3Xs+jcY+f+h6MBkc1IAPP1So3Az826t0gsz9gdOPDJ5TI
         G3A3d662zdtFutLZkxRkb/1DM/COeT0PsSy1B4ihammN6c+OSWMYiZKYuumiGLrj37
         UnankVi2Q57o/56DpeeCXZI/zm/Iw/DuuWMf3vAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 92/96] dmaengine: axi-dmac: add a check for devm_regmap_init_mmio
Date:   Thu, 13 Feb 2020 07:21:39 -0800
Message-Id: <20200213151913.393408150@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

commit a5b982af953bcc838cd198b0434834cc1dff14ec upstream.

The driver misses checking the result of devm_regmap_init_mmio().
Add a check to fix it.

Fixes: fc15be39a827 ("dmaengine: axi-dmac: add regmap support")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lore.kernel.org/r/20191209085711.16001-1-hslester96@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/dma-axi-dmac.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/dma/dma-axi-dmac.c
+++ b/drivers/dma/dma-axi-dmac.c
@@ -830,6 +830,7 @@ static int axi_dmac_probe(struct platfor
 	struct dma_device *dma_dev;
 	struct axi_dmac *dmac;
 	struct resource *res;
+	struct regmap *regmap;
 	int ret;
 
 	dmac = devm_kzalloc(&pdev->dev, sizeof(*dmac), GFP_KERNEL);
@@ -921,10 +922,17 @@ static int axi_dmac_probe(struct platfor
 
 	platform_set_drvdata(pdev, dmac);
 
-	devm_regmap_init_mmio(&pdev->dev, dmac->base, &axi_dmac_regmap_config);
+	regmap = devm_regmap_init_mmio(&pdev->dev, dmac->base,
+		 &axi_dmac_regmap_config);
+	if (IS_ERR(regmap)) {
+		ret = PTR_ERR(regmap);
+		goto err_free_irq;
+	}
 
 	return 0;
 
+err_free_irq:
+	free_irq(dmac->irq, dmac);
 err_unregister_of:
 	of_dma_controller_free(pdev->dev.of_node);
 err_unregister_device:



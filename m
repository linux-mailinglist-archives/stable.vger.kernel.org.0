Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E820A13F3B7
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390007AbgAPRKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:10:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390005AbgAPRKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 498D224685;
        Thu, 16 Jan 2020 17:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194645;
        bh=VBZLFpQEWBzgGdKuOJhdUA477Que6sRO1rLaseY0ejw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAKOCVtDABMJtnXhzYiXZM16bpQcUUlu43NPzY2w5+1BFGZo5Y1nRzhXRi9gNnicG
         oABOLDnavBzR00yxr7jw+K38XHpxxWfxKPDcvYPFafBBh9w/VbRpDnZ9KcWWiXBCEA
         0tMW79kGbhcpfD1ifL4VNkJcqxWyuGry8DiDJy1k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 501/671] dmaengine: dw: platform: Switch to acpi_dma_controller_register()
Date:   Thu, 16 Jan 2020 12:02:19 -0500
Message-Id: <20200116170509.12787-238-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit e7b8514e4d68bec21fc6385fa0a66797ddc34ac9 ]

There is a possibility to have registered ACPI DMA controller
while it has been gone already.

To avoid the potential crash, move to non-managed
acpi_dma_controller_register().

Fixes: 42c91ee71d6d ("dw_dmac: add ACPI support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20190820131546.75744-8-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw/platform.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw/platform.c b/drivers/dma/dw/platform.c
index c299ff181bb6..62218ea0894c 100644
--- a/drivers/dma/dw/platform.c
+++ b/drivers/dma/dw/platform.c
@@ -87,13 +87,20 @@ static void dw_dma_acpi_controller_register(struct dw_dma *dw)
 	dma_cap_set(DMA_SLAVE, info->dma_cap);
 	info->filter_fn = dw_dma_acpi_filter;
 
-	ret = devm_acpi_dma_controller_register(dev, acpi_dma_simple_xlate,
-						info);
+	ret = acpi_dma_controller_register(dev, acpi_dma_simple_xlate, info);
 	if (ret)
 		dev_err(dev, "could not register acpi_dma_controller\n");
 }
+
+static void dw_dma_acpi_controller_free(struct dw_dma *dw)
+{
+	struct device *dev = dw->dma.dev;
+
+	acpi_dma_controller_free(dev);
+}
 #else /* !CONFIG_ACPI */
 static inline void dw_dma_acpi_controller_register(struct dw_dma *dw) {}
+static inline void dw_dma_acpi_controller_free(struct dw_dma *dw) {}
 #endif /* !CONFIG_ACPI */
 
 #ifdef CONFIG_OF
@@ -249,6 +256,9 @@ static int dw_remove(struct platform_device *pdev)
 {
 	struct dw_dma_chip *chip = platform_get_drvdata(pdev);
 
+	if (ACPI_HANDLE(&pdev->dev))
+		dw_dma_acpi_controller_free(chip->dw);
+
 	if (pdev->dev.of_node)
 		of_dma_controller_free(pdev->dev.of_node);
 
-- 
2.20.1


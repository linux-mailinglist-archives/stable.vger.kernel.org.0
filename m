Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5EB14829F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391815AbgAXL3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:29:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391811AbgAXL3d (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:29:33 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9C3F206D4;
        Fri, 24 Jan 2020 11:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865372;
        bh=9srt8kOcacR7S2GQ88hdPUTd+9fmKeD2MB8shnj1wsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BTGXN+e3vaXjwGFOvns+QWjOe9kM3Y1XQjCI7nCMNpLlGHjRfPNeKXR/bFDwyvE3g
         DV04ufeQa0zG9302mwPJEE5f/eIorrkhqnJ435a2bcL8e2VPAx6wUuD2fbWpudWp3U
         yjGHZAYpVyd1eKz08LxxlX4FmofkwoCOJHnlsj+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 515/639] dmaengine: dw: platform: Switch to acpi_dma_controller_register()
Date:   Fri, 24 Jan 2020 10:31:25 +0100
Message-Id: <20200124093153.301317535@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c299ff181bb68..62218ea0894c9 100644
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




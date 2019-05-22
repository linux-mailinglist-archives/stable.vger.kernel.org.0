Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAB3126F48
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731324AbfEVTYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:24:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730590AbfEVTYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:24:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42102217D9;
        Wed, 22 May 2019 19:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553072;
        bh=IoWvHBc4tBzjlAk72m/+qe+eQqCGNqN/lSyE/o9xWuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6ZUthM6RZ9wJlZL9o8qEi6wXkUAV7wYhJNkXpOlcgOIyXzUTWNsbUCL6rfA04dsW
         WLOOAbVm9txS3wmC4/FWRA6x2/K/QyGmYx4xim7W9gvRDKmr7B1ZPZsqaI5wv6PDyq
         4+8dVWmBudrnjYKLMIYoH1LLiepo068OQ0gVLiYw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 032/317] spi: atmel-quadspi: fix crash while suspending
Date:   Wed, 22 May 2019 15:18:53 -0400
Message-Id: <20190522192338.23715-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit e5c27498a0403b270620b1a8a0a66e3efc222fb6 ]

atmel_qspi objects are kept in spi_controller objects, so, first get
pointer to spi_controller object and then get atmel_qspi object from
spi_controller object.

Fixes: 2d30ac5ed633 ("mtd: spi-nor: atmel-quadspi: Use spi-mem interface for atmel-quadspi driver")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/atmel-quadspi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index ddc7124108125..ec6e9970d7750 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -506,7 +506,8 @@ static int atmel_qspi_remove(struct platform_device *pdev)
 
 static int __maybe_unused atmel_qspi_suspend(struct device *dev)
 {
-	struct atmel_qspi *aq = dev_get_drvdata(dev);
+	struct spi_controller *ctrl = dev_get_drvdata(dev);
+	struct atmel_qspi *aq = spi_controller_get_devdata(ctrl);
 
 	clk_disable_unprepare(aq->clk);
 
@@ -515,7 +516,8 @@ static int __maybe_unused atmel_qspi_suspend(struct device *dev)
 
 static int __maybe_unused atmel_qspi_resume(struct device *dev)
 {
-	struct atmel_qspi *aq = dev_get_drvdata(dev);
+	struct spi_controller *ctrl = dev_get_drvdata(dev);
+	struct atmel_qspi *aq = spi_controller_get_devdata(ctrl);
 
 	clk_prepare_enable(aq->clk);
 
-- 
2.20.1


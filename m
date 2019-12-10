Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBFC119D2D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbfLJWgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:36:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:55746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730245AbfLJWeW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:34:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7A7D222C4;
        Tue, 10 Dec 2019 22:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017261;
        bh=vDiGZiY+5wXd6WRqyAiXilFpRVb/IMEXjNGreTTApFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZRt4vK/8H3q4iQcNFQ1JtfLZ64RogRQcAO+nFDCEOOfYoS5uQqKxVW9rjhUTd1Ac
         NMJWCotSBgBaxopoH4RarPut0zZcfHXB+vLY7XoAcLSp/ryhePAREWJ72x1Ua+kDAS
         CCSNBbZd4AE6elvdn8ow0LyY3WrPlq0GyNTF1nb4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 55/71] spi: pxa2xx: Add missed security checks
Date:   Tue, 10 Dec 2019 17:33:00 -0500
Message-Id: <20191210223316.14988-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223316.14988-1-sashal@kernel.org>
References: <20191210223316.14988-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 5eb263ef08b5014cfc2539a838f39d2fd3531423 ]

pxa2xx_spi_init_pdata misses checks for devm_clk_get and
platform_get_irq.
Add checks for them to fix the bugs.

Since ssp->clk and ssp->irq are used in probe, they are mandatory here.
So we cannot use _optional() for devm_clk_get and platform_get_irq.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Link: https://lore.kernel.org/r/20191109080943.30428-1-hslester96@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pxa2xx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 193aa3da50336..96ed01cb6489f 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1425,7 +1425,13 @@ pxa2xx_spi_init_pdata(struct platform_device *pdev)
 	}
 
 	ssp->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(ssp->clk))
+		return NULL;
+
 	ssp->irq = platform_get_irq(pdev, 0);
+	if (ssp->irq < 0)
+		return NULL;
+
 	ssp->type = type;
 	ssp->pdev = pdev;
 	ssp->port_id = pxa2xx_spi_get_port_id(adev);
-- 
2.20.1


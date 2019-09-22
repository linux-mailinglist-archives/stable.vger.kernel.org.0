Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78CB2BAAB1
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbfIVT3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:29:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392417AbfIVStd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:49:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC3B921A4C;
        Sun, 22 Sep 2019 18:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178172;
        bh=HlnVsCceNYZyYai/sxKuhEPWoP8UASBPHV6OlRRXLRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fhmv5FT4IqX8/Rn+E5x1sgf2sCNxHshmSe8mQLKHCLa3aG8XSM5XtaUFTB8lJi80a
         Eytuvv5XJI1eb6Kou+qp649qUlItZJuwemuIdEzv9UD62ITR/E2omgvwmq7Ekh73VK
         3v/eP6QTYHw9JGLEXMSXnw+8V0J5A/fHw69MGixc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Gareth Williams <gareth.williams.jx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 005/185] spi: dw-mmio: Clock should be shut when error occurs
Date:   Sun, 22 Sep 2019 14:46:23 -0400
Message-Id: <20190922184924.32534-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 3da9834d9381dd99273f2ad4e6d096c9187dc4f2 ]

When optional clock requesting fails, the main clock is still up and running,
we should shut it down in such caee.

Fixes: 560ee7e91009 ("spi: dw: Add support for an optional interface clock")
Cc: Phil Edworthy <phil.edworthy@renesas.com>
Cc: Gareth Williams <gareth.williams.jx@renesas.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Gareth Williams <gareth.williams.jx@renesas.com>
Link: https://lore.kernel.org/r/20190710114243.30101-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-mmio.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-dw-mmio.c b/drivers/spi/spi-dw-mmio.c
index 18c06568805e7..86789dbaf5771 100644
--- a/drivers/spi/spi-dw-mmio.c
+++ b/drivers/spi/spi-dw-mmio.c
@@ -172,8 +172,10 @@ static int dw_spi_mmio_probe(struct platform_device *pdev)
 
 	/* Optional clock needed to access the registers */
 	dwsmmio->pclk = devm_clk_get_optional(&pdev->dev, "pclk");
-	if (IS_ERR(dwsmmio->pclk))
-		return PTR_ERR(dwsmmio->pclk);
+	if (IS_ERR(dwsmmio->pclk)) {
+		ret = PTR_ERR(dwsmmio->pclk);
+		goto out_clk;
+	}
 	ret = clk_prepare_enable(dwsmmio->pclk);
 	if (ret)
 		goto out_clk;
-- 
2.20.1


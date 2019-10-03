Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5997CA866
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391068AbfJCQ00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730584AbfJCQ00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:26:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE5CB2133F;
        Thu,  3 Oct 2019 16:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119985;
        bh=HlnVsCceNYZyYai/sxKuhEPWoP8UASBPHV6OlRRXLRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3/zcTSAVgON5Hs0nK4DITuRkNeM7gh1BJJYPIPv9MFgysknvfivn7oNlgwC32o0C
         TrwBy+t/GhJf9wyH5RUfjBT062AebSY6zurlzBrN+s4it32PPcYNhMLsEQ2BmLIxeF
         NJiQnXyhPHJefesIBH3VGBaGz7VTTp6NpmryOmng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Edworthy <phil.edworthy@renesas.com>,
        Gareth Williams <gareth.williams.jx@renesas.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 037/313] spi: dw-mmio: Clock should be shut when error occurs
Date:   Thu,  3 Oct 2019 17:50:15 +0200
Message-Id: <20191003154536.898881972@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




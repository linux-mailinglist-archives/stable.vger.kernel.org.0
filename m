Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7672CA949
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404907AbfJCQkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392442AbfJCQkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:40:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76F5D21848;
        Thu,  3 Oct 2019 16:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120802;
        bh=HlnVsCceNYZyYai/sxKuhEPWoP8UASBPHV6OlRRXLRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1W1clVQtmcwgIeqmKxiMY5EfQA95yTNV7QaF68izX3WXHY2jtG2oRfQSzPeGC3i2u
         3pdY/NtRK7Y6esTljgy1+9OnbUrdU4002IEOoRNaUOsmkchJndf3m4gBzvO57K8rUW
         4E7JLXpnDjNpZf1GQP0M4H4Ktfl3my7sm1z9hOD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Edworthy <phil.edworthy@renesas.com>,
        Gareth Williams <gareth.williams.jx@renesas.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 044/344] spi: dw-mmio: Clock should be shut when error occurs
Date:   Thu,  3 Oct 2019 17:50:09 +0200
Message-Id: <20191003154544.428638528@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
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




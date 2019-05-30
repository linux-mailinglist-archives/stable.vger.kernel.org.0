Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0962EB90
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbfE3DNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728697AbfE3DNx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:53 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFA2E24547;
        Thu, 30 May 2019 03:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186032;
        bh=NP9GJwS7GdR8uLfmWhGAHZP3f6D5LrFqhmkGBFMjYQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=10zfsgnnuk3vStWlMwiypVZcsKMid6nlYIAF57WLcWrFT/2E1s3tkA1XmbmLmI3gI
         neaWpS0VGqwpWg80Gcd0ZDz2sEeDtWiv/kzNWy/J1MniYAAbQ/rDl0C/PoSlHI7vNI
         0HvfS1QR0lzTo/6nlgHAZiwBx0I+PBWqAcbr1SIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 070/346] spi: atmel-quadspi: fix crash while suspending
Date:   Wed, 29 May 2019 20:02:23 -0700
Message-Id: <20190530030544.608765568@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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




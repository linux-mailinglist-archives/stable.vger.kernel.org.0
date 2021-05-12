Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DE437CC4E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbhELQoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243161AbhELQgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:36:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93AAC61E17;
        Wed, 12 May 2021 16:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835275;
        bh=eS4i9oBkUN52Ge4jNwi9bMum1Voqp2NnkseaCe2dWaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sy6TMQICzQgzYYYB52/LEy45XzIjYihk3hMN5zyrwWGCKieNw47TG3fB6wq/N2U/h
         B3+1NC9cDEqPP1X6RBTDrFbrCY5tSywC7wbnSstc88QRJRV5aUV3Ul+UsxTtJeqYlT
         EiGun8GU47loDo+IhzPDDKYLCTm77npl6qe39kOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Alexandru Ardelean <aardelean@deviqon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 261/677] iio: adc: Kconfig: make AD9467 depend on ADI_AXI_ADC symbol
Date:   Wed, 12 May 2021 16:45:07 +0200
Message-Id: <20210512144845.910093169@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <aardelean@deviqon.com>

[ Upstream commit 194eafc9c1d49b53b59de9821fb63d423344cae3 ]

Because a dependency on HAS_IOMEM and OF was added for the ADI AXI ADC
driver, this makes the AD9467 driver have some build/dependency issues
when OF is disabled (typically on ACPI archs like x86).

This is because the selection of the AD9467 enforces the ADI_AXI_ADC symbol
which is blocked by the OF (and potentially HAS_IOMEM) being disabled.

To fix this, we make the AD9467 driver depend on the ADI_AXI_ADC symbol.
The AD9467 driver cannot operate on it's own. It requires the ADI AXI ADC
driver to stream data (or some similar IIO interface).

So, the fix here is to make the AD9467 symbol depend on the ADI_AXI_ADC
symbol. At some point this could become it's own subgroup of high-speed
ADCs.

Fixes: be24c65e9fa24 ("iio: adc: adi-axi-adc: add proper Kconfig dependencies")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Alexandru Ardelean <aardelean@deviqon.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20210324182746.9337-1-aardelean@deviqon.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index e0667c4b3c08..dda0f1e37ec1 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -249,7 +249,7 @@ config AD799X
 config AD9467
 	tristate "Analog Devices AD9467 High Speed ADC driver"
 	depends on SPI
-	select ADI_AXI_ADC
+	depends on ADI_AXI_ADC
 	help
 	  Say yes here to build support for Analog Devices:
 	  * AD9467 16-Bit, 200 MSPS/250 MSPS Analog-to-Digital Converter
-- 
2.30.2




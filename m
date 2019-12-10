Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6278F119BC6
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbfLJWLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:11:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728382AbfLJWEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:04:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFB8420838;
        Tue, 10 Dec 2019 22:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015440;
        bh=7Lwsdk8FMDxQADLZXYHrz6IWTdOq72axp5dI/yhXioY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPEONqC0HhlOBnncs3tQ6s8pJBPna50Qde5tsy6EMGKUAY3uuLVrZNM1pLWz0vxr2
         DwN2HK9P8t/sm3K3AiD+AyhShnIiI7lcUhPEnR4EobJdc0PLJ/0fjFkMhk1YSP+ynJ
         tD/R6VGAO63xSgSf01/bvKw7OCirv9ip4GJWQx8I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 049/130] iio: adc: max1027: Reset the device at probe time
Date:   Tue, 10 Dec 2019 17:01:40 -0500
Message-Id: <20191210220301.13262-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit db033831b4f5589f9fcbadb837614a7c4eac0308 ]

All the registers are configured by the driver, let's reset the chip
at probe time, avoiding any conflict with a possible earlier
configuration.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max1027.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/adc/max1027.c b/drivers/iio/adc/max1027.c
index ebc715927e63b..03af02769370b 100644
--- a/drivers/iio/adc/max1027.c
+++ b/drivers/iio/adc/max1027.c
@@ -462,6 +462,14 @@ static int max1027_probe(struct spi_device *spi)
 		goto fail_dev_register;
 	}
 
+	/* Internal reset */
+	st->reg = MAX1027_RST_REG;
+	ret = spi_write(st->spi, &st->reg, 1);
+	if (ret < 0) {
+		dev_err(&indio_dev->dev, "Failed to reset the ADC\n");
+		return ret;
+	}
+
 	/* Disable averaging */
 	st->reg = MAX1027_AVG_REG;
 	ret = spi_write(st->spi, &st->reg, 1);
-- 
2.20.1


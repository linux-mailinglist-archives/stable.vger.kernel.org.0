Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4FB2F2EA
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbfE3EYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:24:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730003AbfE3DOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:49 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9599F2456F;
        Thu, 30 May 2019 03:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186088;
        bh=G7/EF0+sycBI1xObFRMuUqqyLtCEWKWSYGWiHh9zcnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6S9ltkkNjR9rNuY3tcQTdfl2o6ivqDXbBPxJKtyGWqvneXbwuoMzBDZEt66ZNQX4
         1Sw4+JdCacirc9Ulg81WP3gj1hMQ8gjwiAYz7M5kV5kvJhUmAyPWDdnOKW2nGrN602
         U05YHWN7KddBuyBOeu7sRL2DjU8olcxGdXQhHAXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 217/346] iio: hmc5843: fix potential NULL pointer dereferences
Date:   Wed, 29 May 2019 20:04:50 -0700
Message-Id: <20190530030552.089778323@linuxfoundation.org>
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

[ Upstream commit 536cc27deade8f1ec3c1beefa60d5fbe0f6fcb28 ]

devm_regmap_init_i2c may fail and return NULL. The fix returns
the error when it fails.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/magnetometer/hmc5843_i2c.c | 7 ++++++-
 drivers/iio/magnetometer/hmc5843_spi.c | 7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/magnetometer/hmc5843_i2c.c b/drivers/iio/magnetometer/hmc5843_i2c.c
index 3de7f4426ac40..86abba5827a25 100644
--- a/drivers/iio/magnetometer/hmc5843_i2c.c
+++ b/drivers/iio/magnetometer/hmc5843_i2c.c
@@ -58,8 +58,13 @@ static const struct regmap_config hmc5843_i2c_regmap_config = {
 static int hmc5843_i2c_probe(struct i2c_client *cli,
 			     const struct i2c_device_id *id)
 {
+	struct regmap *regmap = devm_regmap_init_i2c(cli,
+			&hmc5843_i2c_regmap_config);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
 	return hmc5843_common_probe(&cli->dev,
-			devm_regmap_init_i2c(cli, &hmc5843_i2c_regmap_config),
+			regmap,
 			id->driver_data, id->name);
 }
 
diff --git a/drivers/iio/magnetometer/hmc5843_spi.c b/drivers/iio/magnetometer/hmc5843_spi.c
index 535f03a70d630..79b2b707f90e7 100644
--- a/drivers/iio/magnetometer/hmc5843_spi.c
+++ b/drivers/iio/magnetometer/hmc5843_spi.c
@@ -58,6 +58,7 @@ static const struct regmap_config hmc5843_spi_regmap_config = {
 static int hmc5843_spi_probe(struct spi_device *spi)
 {
 	int ret;
+	struct regmap *regmap;
 	const struct spi_device_id *id = spi_get_device_id(spi);
 
 	spi->mode = SPI_MODE_3;
@@ -67,8 +68,12 @@ static int hmc5843_spi_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
+	regmap = devm_regmap_init_spi(spi, &hmc5843_spi_regmap_config);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
 	return hmc5843_common_probe(&spi->dev,
-			devm_regmap_init_spi(spi, &hmc5843_spi_regmap_config),
+			regmap,
 			id->driver_data, id->name);
 }
 
-- 
2.20.1




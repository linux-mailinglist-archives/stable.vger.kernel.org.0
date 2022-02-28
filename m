Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47704C767D
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbiB1SEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240751AbiB1SD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:03:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF5D25C5F;
        Mon, 28 Feb 2022 09:47:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 486A360B2A;
        Mon, 28 Feb 2022 17:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8EFC340E7;
        Mon, 28 Feb 2022 17:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070461;
        bh=iX4GGGUBYLtFhqsSgufxOPti62s98X8cKQqYQbImluM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvIpaYl6ZtTD0M9VB9AVERnieC2It2yRMqEAapM+WEuqH4G9S6VAo6JQEwg6FkUKn
         jZanpYYCYzgIjXTGJcrUljD2eOMX7ZOfUUF69kNYVXyjohSP2eK/aQpuhrGNkv3fkd
         kdwoJGw+jrPIVWaF5u3EwpXa6b8Fa8WqgvGHHtfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.16 118/164] iio: accel: fxls8962af: add padding to regmap for SPI
Date:   Mon, 28 Feb 2022 18:24:40 +0100
Message-Id: <20220228172411.013872277@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

commit ccbed9d8d2a5351d8238f2d3f0741c9a3176f752 upstream.

Add missing don't care padding between address and
data for SPI transfers

Fixes: a3e0b51884ee ("iio: accel: add support for FXLS8962AF/FXLS8964AF accelerometers")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20211220125144.3630539-1-sean@geanix.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/fxls8962af-core.c |   12 ++++++++++--
 drivers/iio/accel/fxls8962af-i2c.c  |    2 +-
 drivers/iio/accel/fxls8962af-spi.c  |    2 +-
 drivers/iio/accel/fxls8962af.h      |    3 ++-
 4 files changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/iio/accel/fxls8962af-core.c
+++ b/drivers/iio/accel/fxls8962af-core.c
@@ -173,12 +173,20 @@ struct fxls8962af_data {
 	u16 upper_thres;
 };
 
-const struct regmap_config fxls8962af_regmap_conf = {
+const struct regmap_config fxls8962af_i2c_regmap_conf = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.max_register = FXLS8962AF_MAX_REG,
 };
-EXPORT_SYMBOL_GPL(fxls8962af_regmap_conf);
+EXPORT_SYMBOL_GPL(fxls8962af_i2c_regmap_conf);
+
+const struct regmap_config fxls8962af_spi_regmap_conf = {
+	.reg_bits = 8,
+	.pad_bits = 8,
+	.val_bits = 8,
+	.max_register = FXLS8962AF_MAX_REG,
+};
+EXPORT_SYMBOL_GPL(fxls8962af_spi_regmap_conf);
 
 enum {
 	fxls8962af_idx_x,
--- a/drivers/iio/accel/fxls8962af-i2c.c
+++ b/drivers/iio/accel/fxls8962af-i2c.c
@@ -18,7 +18,7 @@ static int fxls8962af_probe(struct i2c_c
 {
 	struct regmap *regmap;
 
-	regmap = devm_regmap_init_i2c(client, &fxls8962af_regmap_conf);
+	regmap = devm_regmap_init_i2c(client, &fxls8962af_i2c_regmap_conf);
 	if (IS_ERR(regmap)) {
 		dev_err(&client->dev, "Failed to initialize i2c regmap\n");
 		return PTR_ERR(regmap);
--- a/drivers/iio/accel/fxls8962af-spi.c
+++ b/drivers/iio/accel/fxls8962af-spi.c
@@ -18,7 +18,7 @@ static int fxls8962af_probe(struct spi_d
 {
 	struct regmap *regmap;
 
-	regmap = devm_regmap_init_spi(spi, &fxls8962af_regmap_conf);
+	regmap = devm_regmap_init_spi(spi, &fxls8962af_spi_regmap_conf);
 	if (IS_ERR(regmap)) {
 		dev_err(&spi->dev, "Failed to initialize spi regmap\n");
 		return PTR_ERR(regmap);
--- a/drivers/iio/accel/fxls8962af.h
+++ b/drivers/iio/accel/fxls8962af.h
@@ -17,6 +17,7 @@ int fxls8962af_core_probe(struct device
 int fxls8962af_core_remove(struct device *dev);
 
 extern const struct dev_pm_ops fxls8962af_pm_ops;
-extern const struct regmap_config fxls8962af_regmap_conf;
+extern const struct regmap_config fxls8962af_i2c_regmap_conf;
+extern const struct regmap_config fxls8962af_spi_regmap_conf;
 
 #endif				/* _FXLS8962AF_H_ */



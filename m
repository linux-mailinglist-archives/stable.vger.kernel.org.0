Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44404BE0AC
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349656AbiBUQ7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 11:59:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351323AbiBUQ7N (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 21 Feb 2022 11:59:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965FA23BF6
        for <Stable@vger.kernel.org>; Mon, 21 Feb 2022 08:58:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 340E961386
        for <Stable@vger.kernel.org>; Mon, 21 Feb 2022 16:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15282C340EC;
        Mon, 21 Feb 2022 16:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645462728;
        bh=B+ZLxRuTIY30GAWeypleMOFh/muQ8KDuM5qgFUx3ir4=;
        h=Subject:To:From:Date:From;
        b=iFjt50IB1N12VVIYGDmnt+kRTGgWfivFswhcbxeJB8AhR354an81spK2ZY1osVATb
         4zk6lyS9Bu59MOMO9Whe4ZTT3TX9GBcuopye9nKzTqYcHUE6nmKMQkScmWYVv+Js1/
         HJ+xuaGrPYB/ejTmt15UVeoJHptDGLPhNzq6GTlo=
Subject: patch "iio: accel: fxls8962af: add padding to regmap for SPI" added to char-misc-linus
To:     sean@geanix.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 17:58:41 +0100
Message-ID: <1645462721313@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: accel: fxls8962af: add padding to regmap for SPI

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ccbed9d8d2a5351d8238f2d3f0741c9a3176f752 Mon Sep 17 00:00:00 2001
From: Sean Nyekjaer <sean@geanix.com>
Date: Mon, 20 Dec 2021 13:51:43 +0100
Subject: iio: accel: fxls8962af: add padding to regmap for SPI

Add missing don't care padding between address and
data for SPI transfers

Fixes: a3e0b51884ee ("iio: accel: add support for FXLS8962AF/FXLS8964AF accelerometers")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20211220125144.3630539-1-sean@geanix.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/fxls8962af-core.c | 12 ++++++++++--
 drivers/iio/accel/fxls8962af-i2c.c  |  2 +-
 drivers/iio/accel/fxls8962af-spi.c  |  2 +-
 drivers/iio/accel/fxls8962af.h      |  3 ++-
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/accel/fxls8962af-core.c b/drivers/iio/accel/fxls8962af-core.c
index 32989d91b982..f7fd9e046588 100644
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
diff --git a/drivers/iio/accel/fxls8962af-i2c.c b/drivers/iio/accel/fxls8962af-i2c.c
index cfb004b20455..6bde9891effb 100644
--- a/drivers/iio/accel/fxls8962af-i2c.c
+++ b/drivers/iio/accel/fxls8962af-i2c.c
@@ -18,7 +18,7 @@ static int fxls8962af_probe(struct i2c_client *client)
 {
 	struct regmap *regmap;
 
-	regmap = devm_regmap_init_i2c(client, &fxls8962af_regmap_conf);
+	regmap = devm_regmap_init_i2c(client, &fxls8962af_i2c_regmap_conf);
 	if (IS_ERR(regmap)) {
 		dev_err(&client->dev, "Failed to initialize i2c regmap\n");
 		return PTR_ERR(regmap);
diff --git a/drivers/iio/accel/fxls8962af-spi.c b/drivers/iio/accel/fxls8962af-spi.c
index 57108d3d480b..6f4dff3238d3 100644
--- a/drivers/iio/accel/fxls8962af-spi.c
+++ b/drivers/iio/accel/fxls8962af-spi.c
@@ -18,7 +18,7 @@ static int fxls8962af_probe(struct spi_device *spi)
 {
 	struct regmap *regmap;
 
-	regmap = devm_regmap_init_spi(spi, &fxls8962af_regmap_conf);
+	regmap = devm_regmap_init_spi(spi, &fxls8962af_spi_regmap_conf);
 	if (IS_ERR(regmap)) {
 		dev_err(&spi->dev, "Failed to initialize spi regmap\n");
 		return PTR_ERR(regmap);
diff --git a/drivers/iio/accel/fxls8962af.h b/drivers/iio/accel/fxls8962af.h
index b67572c3ef06..9cbe98c3ba9a 100644
--- a/drivers/iio/accel/fxls8962af.h
+++ b/drivers/iio/accel/fxls8962af.h
@@ -17,6 +17,7 @@ int fxls8962af_core_probe(struct device *dev, struct regmap *regmap, int irq);
 int fxls8962af_core_remove(struct device *dev);
 
 extern const struct dev_pm_ops fxls8962af_pm_ops;
-extern const struct regmap_config fxls8962af_regmap_conf;
+extern const struct regmap_config fxls8962af_i2c_regmap_conf;
+extern const struct regmap_config fxls8962af_spi_regmap_conf;
 
 #endif				/* _FXLS8962AF_H_ */
-- 
2.35.1



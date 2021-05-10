Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13CE37872E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbhEJLO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236123AbhEJLHi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F47F61929;
        Mon, 10 May 2021 10:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644298;
        bh=Agkfor2JJ8xKqz1pTeXsVwJ2SVEWtZETXnHRKdSlESE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rnwFk4uMxCssEF1jpNa7tx44ybpIvRD36/7q8IgV4QMf9lQJain40zhmJPdra4JVa
         5ro3Vn0EOO7j6I0Jf6WcUOgaFW3xyNKJ55hKXOw83LXpe4wmBAVBl1NGLE5E593IL1
         Azhd+CvTBDUN5HAZEuRVBWGpctgExGV0artqAK/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>,
        Yicong Yang <yangyicong@hisilicon.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH 5.12 025/384] mtd: spi-nor: core: Fix an issue of releasing resources during read/write
Date:   Mon, 10 May 2021 12:16:54 +0200
Message-Id: <20210510102015.700714672@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

commit be94215be1ab19e5d38f50962f611c88d4bfc83a upstream.

If rmmod the driver during read or write, the driver will release the
resources which are used during read or write, so it is possible to
refer to NULL pointer.

Use the testcase "mtd_debug read /dev/mtd0 0xc00000 0x400000 dest_file &
sleep 0.5;rmmod spi_hisi_sfc_v3xx.ko", the issue can be reproduced in
hisi_sfc_v3xx driver.

To avoid the issue, fill the interface _get_device and _put_device of
mtd_info to grab the reference to the spi controller driver module, so
the request of rmmod the driver is rejected before read/write is finished.

Fixes: b199489d37b2 ("mtd: spi-nor: add the framework for SPI NOR")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Tested-by: Michael Walle <michael@walle.cc>
Tested-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Reviewed-by: Michael Walle <michael@walle.cc>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1617262486-4223-1-git-send-email-yangyicong@hisilicon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/core.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -3301,6 +3301,37 @@ static void spi_nor_resume(struct mtd_in
 		dev_err(dev, "resume() failed\n");
 }
 
+static int spi_nor_get_device(struct mtd_info *mtd)
+{
+	struct mtd_info *master = mtd_get_master(mtd);
+	struct spi_nor *nor = mtd_to_spi_nor(master);
+	struct device *dev;
+
+	if (nor->spimem)
+		dev = nor->spimem->spi->controller->dev.parent;
+	else
+		dev = nor->dev;
+
+	if (!try_module_get(dev->driver->owner))
+		return -ENODEV;
+
+	return 0;
+}
+
+static void spi_nor_put_device(struct mtd_info *mtd)
+{
+	struct mtd_info *master = mtd_get_master(mtd);
+	struct spi_nor *nor = mtd_to_spi_nor(master);
+	struct device *dev;
+
+	if (nor->spimem)
+		dev = nor->spimem->spi->controller->dev.parent;
+	else
+		dev = nor->dev;
+
+	module_put(dev->driver->owner);
+}
+
 void spi_nor_restore(struct spi_nor *nor)
 {
 	/* restore the addressing mode */
@@ -3495,6 +3526,8 @@ int spi_nor_scan(struct spi_nor *nor, co
 	mtd->_read = spi_nor_read;
 	mtd->_suspend = spi_nor_suspend;
 	mtd->_resume = spi_nor_resume;
+	mtd->_get_device = spi_nor_get_device;
+	mtd->_put_device = spi_nor_put_device;
 
 	if (nor->params->locking_ops) {
 		mtd->_lock = spi_nor_lock;



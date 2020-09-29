Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36DF227D434
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 19:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgI2RNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 13:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgI2RNC (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 29 Sep 2020 13:13:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1516820C09;
        Tue, 29 Sep 2020 17:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601399581;
        bh=qh/4FZtJSfhU9ZgAcS9kpuiuZ8n5eedmxde0vn7BKYs=;
        h=Subject:To:From:Date:From;
        b=a1IVm4TssCsHPcGf+9/GUX3N+H95v435cpjWIaAtWOvlahvVAjMMw3YXuXhTeOLWX
         qesShyoN13T5+vROwmXoGDv2lDT1wk+uuCi6ZygFKt0ONIkeHKguXAjULa/dTJQZKu
         l243GWI9rl7qFtVz0BkCtUFExyMUogw4d4+kx8TA=
Subject: patch "iio: adc: gyroadc: fix leak of device node iterator" added to staging-testing
To:     kernel@cdqe.de, Jonathan.Cameron@huawei.com, Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 29 Sep 2020 19:12:11 +0200
Message-ID: <160139953198160@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: gyroadc: fix leak of device node iterator

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From da4410d4078ba4ead9d6f1027d6db77c5a74ecee Mon Sep 17 00:00:00 2001
From: Tobias Jordan <kernel@cdqe.de>
Date: Sat, 26 Sep 2020 18:19:46 +0200
Subject: iio: adc: gyroadc: fix leak of device node iterator

Add missing of_node_put calls when exiting the for_each_child_of_node
loop in rcar_gyroadc_parse_subdevs early.

Also add goto-exception handling for the error paths in that loop.

Fixes: 059c53b32329 ("iio: adc: Add Renesas GyroADC driver")
Signed-off-by: Tobias Jordan <kernel@cdqe.de>
Link: https://lore.kernel.org/r/20200926161946.GA10240@agrajag.zerfleddert.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/rcar-gyroadc.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/adc/rcar-gyroadc.c b/drivers/iio/adc/rcar-gyroadc.c
index dcaefc108ff6..9f38cf3c7dc2 100644
--- a/drivers/iio/adc/rcar-gyroadc.c
+++ b/drivers/iio/adc/rcar-gyroadc.c
@@ -357,7 +357,7 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 			num_channels = ARRAY_SIZE(rcar_gyroadc_iio_channels_3);
 			break;
 		default:
-			return -EINVAL;
+			goto err_e_inval;
 		}
 
 		/*
@@ -374,7 +374,7 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 				dev_err(dev,
 					"Failed to get child reg property of ADC \"%pOFn\".\n",
 					child);
-				return ret;
+				goto err_of_node_put;
 			}
 
 			/* Channel number is too high. */
@@ -382,7 +382,7 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 				dev_err(dev,
 					"Only %i channels supported with %pOFn, but reg = <%i>.\n",
 					num_channels, child, reg);
-				return -EINVAL;
+				goto err_e_inval;
 			}
 		}
 
@@ -391,7 +391,7 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 			dev_err(dev,
 				"Channel %i uses different ADC mode than the rest.\n",
 				reg);
-			return -EINVAL;
+			goto err_e_inval;
 		}
 
 		/* Channel is valid, grab the regulator. */
@@ -401,7 +401,8 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 		if (IS_ERR(vref)) {
 			dev_dbg(dev, "Channel %i 'vref' supply not connected.\n",
 				reg);
-			return PTR_ERR(vref);
+			ret = PTR_ERR(vref);
+			goto err_of_node_put;
 		}
 
 		priv->vref[reg] = vref;
@@ -425,8 +426,10 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 		 * attached to the GyroADC at a time, so if we found it,
 		 * we can stop parsing here.
 		 */
-		if (childmode == RCAR_GYROADC_MODE_SELECT_1_MB88101A)
+		if (childmode == RCAR_GYROADC_MODE_SELECT_1_MB88101A) {
+			of_node_put(child);
 			break;
+		}
 	}
 
 	if (first) {
@@ -435,6 +438,12 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 	}
 
 	return 0;
+
+err_e_inval:
+	ret = -EINVAL;
+err_of_node_put:
+	of_node_put(child);
+	return ret;
 }
 
 static void rcar_gyroadc_deinit_supplies(struct iio_dev *indio_dev)
-- 
2.28.0



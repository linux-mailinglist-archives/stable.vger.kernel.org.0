Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B98A2A5690
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732979AbgKCU6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:58:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730727AbgKCU6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:58:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF8AE2053B;
        Tue,  3 Nov 2020 20:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437114;
        bh=KEtK5hdAZfsIrtGMreF2YXohOfq3j5+ktLYhH8ZE8NA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mLr1InVyN1UQncFwkAMEeLIXiTmFbHcrxiglal7e3CguUq8P0gLmRwUdC/S+qwrK+
         t2k1+xVx2f9GfykKn61BQwSJIdfja/IF7LwgD5UXAroIplV/wmbkHpDTijXzTWSA/d
         eQLGUIZXRGbKJmagOBsn3ZIw/51bmZe3ORGNjgeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Jordan <kernel@cdqe.de>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 151/214] iio: adc: gyroadc: fix leak of device node iterator
Date:   Tue,  3 Nov 2020 21:36:39 +0100
Message-Id: <20201103203304.951123480@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Jordan <kernel@cdqe.de>

commit da4410d4078ba4ead9d6f1027d6db77c5a74ecee upstream.

Add missing of_node_put calls when exiting the for_each_child_of_node
loop in rcar_gyroadc_parse_subdevs early.

Also add goto-exception handling for the error paths in that loop.

Fixes: 059c53b32329 ("iio: adc: Add Renesas GyroADC driver")
Signed-off-by: Tobias Jordan <kernel@cdqe.de>
Link: https://lore.kernel.org/r/20200926161946.GA10240@agrajag.zerfleddert.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/rcar-gyroadc.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/iio/adc/rcar-gyroadc.c
+++ b/drivers/iio/adc/rcar-gyroadc.c
@@ -357,7 +357,7 @@ static int rcar_gyroadc_parse_subdevs(st
 			num_channels = ARRAY_SIZE(rcar_gyroadc_iio_channels_3);
 			break;
 		default:
-			return -EINVAL;
+			goto err_e_inval;
 		}
 
 		/*
@@ -374,7 +374,7 @@ static int rcar_gyroadc_parse_subdevs(st
 				dev_err(dev,
 					"Failed to get child reg property of ADC \"%pOFn\".\n",
 					child);
-				return ret;
+				goto err_of_node_put;
 			}
 
 			/* Channel number is too high. */
@@ -382,7 +382,7 @@ static int rcar_gyroadc_parse_subdevs(st
 				dev_err(dev,
 					"Only %i channels supported with %pOFn, but reg = <%i>.\n",
 					num_channels, child, reg);
-				return -EINVAL;
+				goto err_e_inval;
 			}
 		}
 
@@ -391,7 +391,7 @@ static int rcar_gyroadc_parse_subdevs(st
 			dev_err(dev,
 				"Channel %i uses different ADC mode than the rest.\n",
 				reg);
-			return -EINVAL;
+			goto err_e_inval;
 		}
 
 		/* Channel is valid, grab the regulator. */
@@ -401,7 +401,8 @@ static int rcar_gyroadc_parse_subdevs(st
 		if (IS_ERR(vref)) {
 			dev_dbg(dev, "Channel %i 'vref' supply not connected.\n",
 				reg);
-			return PTR_ERR(vref);
+			ret = PTR_ERR(vref);
+			goto err_of_node_put;
 		}
 
 		priv->vref[reg] = vref;
@@ -425,8 +426,10 @@ static int rcar_gyroadc_parse_subdevs(st
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
@@ -435,6 +438,12 @@ static int rcar_gyroadc_parse_subdevs(st
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



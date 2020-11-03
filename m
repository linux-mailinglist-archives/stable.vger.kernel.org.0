Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4532A582F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731562AbgKCUt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:49:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731548AbgKCUt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1BE422404;
        Tue,  3 Nov 2020 20:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436567;
        bh=qQUYyIIlL7XImKMyfkk8YkKHO06lifVUOfq4x+HBHzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLB2e5O93TAh9XkOWeQeQp5RHn+R04bdnBEYZKGqhDWMmU0U8iK7E0QeF3MRBrAIJ
         AeyFEahFWCCddj2cqYi8HFjWyUmDyXucIHQRBHnZ83wf3dHRHZljCRIDFuNwhvD9Sh
         rsM40HPgj97tyN7IHmIv05u/iHQaEIA0xNPa/fbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.9 268/391] iio: ltc2983: Fix of_node refcounting
Date:   Tue,  3 Nov 2020 21:35:19 +0100
Message-Id: <20201103203405.113250315@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

commit b07c47bfab6f5c4c7182d23e854bbceaf7829c85 upstream.

When returning or breaking early from a
`for_each_available_child_of_node()` loop, we need to explicitly call
`of_node_put()` on the child node to possibly release the node.

Fixes: f110f3188e563 ("iio: temperature: Add support for LTC2983")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200925091045.302-1-nuno.sa@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/temperature/ltc2983.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -1285,18 +1285,20 @@ static int ltc2983_parse_dt(struct ltc29
 		ret = of_property_read_u32(child, "reg", &sensor.chan);
 		if (ret) {
 			dev_err(dev, "reg property must given for child nodes\n");
-			return ret;
+			goto put_child;
 		}
 
 		/* check if we have a valid channel */
 		if (sensor.chan < LTC2983_MIN_CHANNELS_NR ||
 		    sensor.chan > LTC2983_MAX_CHANNELS_NR) {
+			ret = -EINVAL;
 			dev_err(dev,
 				"chan:%d must be from 1 to 20\n", sensor.chan);
-			return -EINVAL;
+			goto put_child;
 		} else if (channel_avail_mask & BIT(sensor.chan)) {
+			ret = -EINVAL;
 			dev_err(dev, "chan:%d already in use\n", sensor.chan);
-			return -EINVAL;
+			goto put_child;
 		}
 
 		ret = of_property_read_u32(child, "adi,sensor-type",
@@ -1304,7 +1306,7 @@ static int ltc2983_parse_dt(struct ltc29
 		if (ret) {
 			dev_err(dev,
 				"adi,sensor-type property must given for child nodes\n");
-			return ret;
+			goto put_child;
 		}
 
 		dev_dbg(dev, "Create new sensor, type %u, chann %u",
@@ -1334,13 +1336,15 @@ static int ltc2983_parse_dt(struct ltc29
 			st->sensors[chan] = ltc2983_adc_new(child, st, &sensor);
 		} else {
 			dev_err(dev, "Unknown sensor type %d\n", sensor.type);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto put_child;
 		}
 
 		if (IS_ERR(st->sensors[chan])) {
 			dev_err(dev, "Failed to create sensor %ld",
 				PTR_ERR(st->sensors[chan]));
-			return PTR_ERR(st->sensors[chan]);
+			ret = PTR_ERR(st->sensors[chan]);
+			goto put_child;
 		}
 		/* set generic sensor parameters */
 		st->sensors[chan]->chan = sensor.chan;
@@ -1351,6 +1355,9 @@ static int ltc2983_parse_dt(struct ltc29
 	}
 
 	return 0;
+put_child:
+	of_node_put(child);
+	return ret;
 }
 
 static int ltc2983_setup(struct ltc2983_data *st, bool assign_iio)



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3009527839C
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 11:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgIYJLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 05:11:14 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:60546 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727324AbgIYJLO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 05:11:14 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08P94xRT022961;
        Fri, 25 Sep 2020 05:10:58 -0400
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 33r5u9fc4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 05:10:58 -0400
Received: from SCSQMBX11.ad.analog.com (scsqmbx11.ad.analog.com [10.77.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 08P9Au13038099
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 25 Sep 2020 05:10:57 -0400
Received: from SCSQMBX10.ad.analog.com (10.77.17.5) by SCSQMBX11.ad.analog.com
 (10.77.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1779.2; Fri, 25 Sep
 2020 02:10:54 -0700
Received: from zeus.spd.analog.com (10.66.68.11) by SCSQMBX10.ad.analog.com
 (10.77.17.5) with Microsoft SMTP Server id 15.1.1779.2 via Frontend
 Transport; Fri, 25 Sep 2020 02:10:53 -0700
Received: from NSA-L01.ad.analog.com ([10.32.226.88])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 08P9ApIx007631;
        Fri, 25 Sep 2020 05:10:52 -0400
From:   =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
To:     <linux-iio@vger.kernel.org>
CC:     Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Lars-Peter Clausen <lars@metafoo.de>, <stable@vger.kernel.org>
Subject: [PATCH 1/2] iio: ltc2983: Fix of_node refcounting
Date:   Fri, 25 Sep 2020 11:10:44 +0200
Message-ID: <20200925091045.302-1-nuno.sa@analog.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ADIRoutedOnPrem: True
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_02:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 impostorscore=0 mlxlogscore=952 suspectscore=1 clxscore=1011
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250063
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When returning or breaking early from a
`for_each_available_child_of_node()` loop, we need to explicitly call
`of_node_put()` on the child node to possibly release the node.

Fixes: f110f3188e563 ("iio: temperature: Add support for LTC2983")
Cc: stable@vger.kernel.org
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
---
 drivers/iio/temperature/ltc2983.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/temperature/ltc2983.c b/drivers/iio/temperature/ltc2983.c
index 55ff28a0f1c7..c6641bc185cb 100644
--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -1285,18 +1285,19 @@ static int ltc2983_parse_dt(struct ltc2983_data *st)
 		ret = of_property_read_u32(child, "reg", &sensor.chan);
 		if (ret) {
 			dev_err(dev, "reg property must given for child nodes\n");
-			return ret;
+			goto put_child;
 		}
 
 		/* check if we have a valid channel */
+		ret = -EINVAL;
 		if (sensor.chan < LTC2983_MIN_CHANNELS_NR ||
 		    sensor.chan > LTC2983_MAX_CHANNELS_NR) {
 			dev_err(dev,
 				"chan:%d must be from 1 to 20\n", sensor.chan);
-			return -EINVAL;
+			goto put_child;
 		} else if (channel_avail_mask & BIT(sensor.chan)) {
 			dev_err(dev, "chan:%d already in use\n", sensor.chan);
-			return -EINVAL;
+			goto put_child;
 		}
 
 		ret = of_property_read_u32(child, "adi,sensor-type",
@@ -1304,7 +1305,7 @@ static int ltc2983_parse_dt(struct ltc2983_data *st)
 		if (ret) {
 			dev_err(dev,
 				"adi,sensor-type property must given for child nodes\n");
-			return ret;
+			goto put_child;
 		}
 
 		dev_dbg(dev, "Create new sensor, type %u, chann %u",
@@ -1334,13 +1335,15 @@ static int ltc2983_parse_dt(struct ltc2983_data *st)
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
@@ -1351,6 +1354,9 @@ static int ltc2983_parse_dt(struct ltc2983_data *st)
 	}
 
 	return 0;
+put_child:
+	of_node_put(child);
+	return ret;
 }
 
 static int ltc2983_setup(struct ltc2983_data *st, bool assign_iio)
-- 
2.25.1


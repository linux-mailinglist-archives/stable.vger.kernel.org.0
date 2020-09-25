Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6420C27839E
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 11:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgIYJLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 05:11:15 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:61828 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727324AbgIYJLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 05:11:15 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08P94fdn022599;
        Fri, 25 Sep 2020 05:11:01 -0400
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 33r5u9fc4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 05:11:00 -0400
Received: from SCSQMBX11.ad.analog.com (scsqmbx11.ad.analog.com [10.77.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 08P9AxDM038108
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 25 Sep 2020 05:10:59 -0400
Received: from SCSQMBX10.ad.analog.com (10.77.17.5) by SCSQMBX11.ad.analog.com
 (10.77.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1779.2; Fri, 25 Sep
 2020 02:10:56 -0700
Received: from zeus.spd.analog.com (10.66.68.11) by SCSQMBX10.ad.analog.com
 (10.77.17.5) with Microsoft SMTP Server id 15.1.1779.2 via Frontend
 Transport; Fri, 25 Sep 2020 02:10:56 -0700
Received: from NSA-L01.ad.analog.com ([10.32.226.88])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 08P9ApJ0007631;
        Fri, 25 Sep 2020 05:10:54 -0400
From:   =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
To:     <linux-iio@vger.kernel.org>
CC:     Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Lars-Peter Clausen <lars@metafoo.de>, <stable@vger.kernel.org>
Subject: [PATCH 2/2] iio: ad7292: Fix of_node refcounting
Date:   Fri, 25 Sep 2020 11:10:45 +0200
Message-ID: <20200925091045.302-2-nuno.sa@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200925091045.302-1-nuno.sa@analog.com>
References: <20200925091045.302-1-nuno.sa@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ADIRoutedOnPrem: True
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_02:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 impostorscore=0 mlxlogscore=736 suspectscore=1 clxscore=1015
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250063
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When returning or breaking early from a
`for_each_available_child_of_node()` loop, we need to explicitly call
`of_node_put()` on the child node to possibly release the node.

Fixes: 506d2e317a0a0 ("iio: adc: Add driver support for AD7292")
Cc: stable@vger.kernel.org
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
---
 drivers/iio/adc/ad7292.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7292.c b/drivers/iio/adc/ad7292.c
index 2eafbe7ac7c7..ab204e9199e9 100644
--- a/drivers/iio/adc/ad7292.c
+++ b/drivers/iio/adc/ad7292.c
@@ -310,8 +310,10 @@ static int ad7292_probe(struct spi_device *spi)
 
 	for_each_available_child_of_node(spi->dev.of_node, child) {
 		diff_channels = of_property_read_bool(child, "diff-channels");
-		if (diff_channels)
+		if (diff_channels) {
+			of_node_put(child);
 			break;
+		}
 	}
 
 	if (diff_channels) {
-- 
2.25.1


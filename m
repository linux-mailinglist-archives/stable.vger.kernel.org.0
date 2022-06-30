Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A5756265B
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 01:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiF3XB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 19:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiF3XB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 19:01:57 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4806653D33;
        Thu, 30 Jun 2022 16:01:53 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 25UN18a4075834;
        Thu, 30 Jun 2022 18:01:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1656630068;
        bh=QtzutZRbSrOPPcLttyyspgFWlZmc7+nzWVIjmBpjb9k=;
        h=From:To:CC:Subject:Date;
        b=Cq+mwCtuPow287YDfQYtTCXLUdXorpPDwHhAb/+rz85iB/WX3AAq/RuoI5plJLeIi
         1lmIgccPWu+GkEhtNVfAfgmuMB0UDF+MG6gXcOY6lj32WJAwJ2b7YjbWejTRB1uKIw
         BJ2XGzEC2ohla1UqbPeZh402114Xc/xfZ+pSWdFE=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 25UN18dl085041
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 Jun 2022 18:01:08 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 30
 Jun 2022 18:01:08 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Thu, 30 Jun 2022 18:01:08 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 25UN18ou022220;
        Thu, 30 Jun 2022 18:01:08 -0500
From:   Nishanth Menon <nm@ti.com>
To:     Javier Martinez Canillas <javier@osg.samsung.com>,
        Nishanth Menon <nm@ti.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] iio: adc: ti-adc128s052: Fix number of channels when device tree is used
Date:   Thu, 30 Jun 2022 18:01:07 -0500
Message-ID: <20220630230107.13438-1-nm@ti.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When device_match_data is called - with device tree, of_match list is
looked up to find the data, which by default is 0. So, no matter which
kind of device compatible we use, we match with config 0 which implies
we enable 8 channels even on devices that do not have 8 channels.

Solve it by providing the match data similar to what we do with the ACPI
lookup information.

Fixes: 9e611c9e5a20 ("iio: adc128s052: Add OF match table")
Cc: <stable@vger.kernel.org> # 5.0+
Signed-off-by: Nishanth Menon <nm@ti.com>
---

Side note: commits 9e611c9e5a20c ("iio: adc128s052: Add OF match table"),
37cd3c8768edc ("iio: adc128s052: Add pin-compatible IDs"),
b41fa86b67bd3 ("iio:adc128s052: add support for adc124s021") introduce
code that is fixed by this patch, but it makes no real sense to go and
split this patch to apply to versions older than 5.0 - which seems to be
the earliest the patch would apply. I picked the "Add OF match table" as
the patch that set the precedence which follow on patches followed.

 drivers/iio/adc/ti-adc128s052.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/adc/ti-adc128s052.c b/drivers/iio/adc/ti-adc128s052.c
index 622fd384983c..21a7764cbb93 100644
--- a/drivers/iio/adc/ti-adc128s052.c
+++ b/drivers/iio/adc/ti-adc128s052.c
@@ -181,13 +181,13 @@ static int adc128_probe(struct spi_device *spi)
 }
 
 static const struct of_device_id adc128_of_match[] = {
-	{ .compatible = "ti,adc128s052", },
-	{ .compatible = "ti,adc122s021", },
-	{ .compatible = "ti,adc122s051", },
-	{ .compatible = "ti,adc122s101", },
-	{ .compatible = "ti,adc124s021", },
-	{ .compatible = "ti,adc124s051", },
-	{ .compatible = "ti,adc124s101", },
+	{ .compatible = "ti,adc128s052", .data = 0},
+	{ .compatible = "ti,adc122s021", .data = 1},
+	{ .compatible = "ti,adc122s051", .data = 1},
+	{ .compatible = "ti,adc122s101", .data = 1},
+	{ .compatible = "ti,adc124s021", .data = 2},
+	{ .compatible = "ti,adc124s051", .data = 2},
+	{ .compatible = "ti,adc124s101", .data = 2},
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, adc128_of_match);
-- 
2.31.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0AA74C4A74
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 17:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242834AbiBYQU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 11:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242856AbiBYQUS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 11:20:18 -0500
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAF4532E5;
        Fri, 25 Feb 2022 08:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1645805986; x=1677341986;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jV1/rxSD+P2pkzp3I06vMJiO2j7BJNM6TvzL+/6SkCM=;
  b=sBRXMRfSm7VCcv770ZYqVKITUqQ8lTT1YizF/Cj22XXwqUGT7pp+fbJy
   NwTILF8ToWdFG4vWQIfn0FMHFCNkhxKpHiW1MPnsXLRboGDg4fbDlLXaW
   +A2ttPEjIprnwunlsgOO+2C3VGpvjgZoxQbeh6yQ4833xuntZUEoQzY7m
   g=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 25 Feb 2022 08:19:45 -0800
X-QCInternal: smtphost
Received: from nasanex01b.na.qualcomm.com ([10.46.141.250])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 08:19:45 -0800
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 25 Feb 2022 08:19:44 -0800
From:   Elliot Berman <quic_eberman@quicinc.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
CC:     Ali Pouladi <quic_apouladi@quicinc.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-rtc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Carl van Schaik <quic_cvanscha@quicinc.com>,
        <stable@vger.kernel.org>, Elliot Berman <quic_eberman@quicinc.com>
Subject: [PATCH] rtc: pl031: fix rtc features null pointer dereference
Date:   Fri, 25 Feb 2022 08:19:24 -0800
Message-ID: <20220225161924.274141-1-quic_eberman@quicinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ali Pouladi <quic_apouladi@quicinc.com>

When there is no interrupt line, rtc alarm feature is disabled.

The clearing of the alarm feature bit was being done prior to allocations
of ldata->rtc device, resulting in a null pointer dereference.

Clear RTC_FEATURE_ALARM after the rtc device is allocated.

Fixes: d9b0dd54a194 ("rtc: pl031: use RTC_FEATURE_ALARM")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Pouladi <quic_apouladi@quicinc.com>
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
---
 drivers/rtc/rtc-pl031.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index e38ee8848385..bad6a5d9c683 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -350,9 +350,6 @@ static int pl031_probe(struct amba_device *adev, const struct amba_id *id)
 		}
 	}
 
-	if (!adev->irq[0])
-		clear_bit(RTC_FEATURE_ALARM, ldata->rtc->features);
-
 	device_init_wakeup(&adev->dev, true);
 	ldata->rtc = devm_rtc_allocate_device(&adev->dev);
 	if (IS_ERR(ldata->rtc)) {
@@ -360,6 +357,9 @@ static int pl031_probe(struct amba_device *adev, const struct amba_id *id)
 		goto out;
 	}
 
+	if (!adev->irq[0])
+		clear_bit(RTC_FEATURE_ALARM, ldata->rtc->features);
+
 	ldata->rtc->ops = ops;
 	ldata->rtc->range_min = vendor->range_min;
 	ldata->rtc->range_max = vendor->range_max;
-- 
2.25.1


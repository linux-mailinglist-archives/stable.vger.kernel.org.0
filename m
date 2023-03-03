Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D894A6A8F3E
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 03:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjCCCcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 21:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCCCc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 21:32:29 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AC53E0AE;
        Thu,  2 Mar 2023 18:32:26 -0800 (PST)
Received: from dggpeml100012.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PSX470hywznWkl;
        Fri,  3 Mar 2023 10:29:43 +0800 (CST)
Received: from localhost.localdomain (10.67.175.61) by
 dggpeml100012.china.huawei.com (7.185.36.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 10:32:24 +0800
From:   Zheng Yejian <zhengyejian1@huawei.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <agross@kernel.org>, <bjorn.andersson@linaro.org>,
        <balbi@kernel.org>, <lee.jones@linaro.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zhengyejian1@huawei.com>
Subject: [PATCH 5.10] usb: dwc3: dwc3-qcom: Add missing platform_device_put() in dwc3_qcom_acpi_register_core
Date:   Fri, 3 Mar 2023 10:34:59 +0800
Message-ID: <20230303023459.774689-1-zhengyejian1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.175.61]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit fa0ef93868a6062babe1144df2807a8b1d4924d2 upstream.

Add the missing platform_device_put() before return from
dwc3_qcom_acpi_register_core in the error handling case.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20211231113641.31474-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CVE: CVE-2023-22995
Fixes: 2bc02355f8ba ("usb: dwc3: qcom: Add support for booting with ACPI")
[Fix conflict due to lack of 8dc6e6dd1bee39cd65a232a17d51240fc65a0f4a]
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
---
 drivers/usb/dwc3/dwc3-qcom.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index dac13fe97811..416c94c612f5 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -613,8 +613,10 @@ static int dwc3_qcom_acpi_register_core(struct platform_device *pdev)
 	qcom->dwc3->dev.coherent_dma_mask = dev->coherent_dma_mask;
 
 	child_res = kcalloc(2, sizeof(*child_res), GFP_KERNEL);
-	if (!child_res)
+	if (!child_res) {
+		platform_device_put(qcom->dwc3);
 		return -ENOMEM;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
@@ -650,10 +652,15 @@ static int dwc3_qcom_acpi_register_core(struct platform_device *pdev)
 	}
 
 	ret = platform_device_add(qcom->dwc3);
-	if (ret)
+	if (ret) {
 		dev_err(&pdev->dev, "failed to add device\n");
+		goto out;
+	}
+	kfree(child_res);
+	return 0;
 
 out:
+	platform_device_put(qcom->dwc3);
 	kfree(child_res);
 	return ret;
 }
-- 
2.25.1


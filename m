Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855154FF953
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 16:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbiDMOui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 10:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiDMOui (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 10:50:38 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B65C63BF0
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 07:48:17 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id 9so2143769iou.5
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 07:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+IpVkEffy7PlUYnFxm9TjdHlDyLe6Pv7WXvVTMMNw9s=;
        b=z1g6cxyUI+ZITdpnQCCQY6aEP2Bat5C8q9ULSNL59iWOj+OuscEGKwBa56qB/LDiuo
         i4BDRQuCTwYIW51OULzItjuoLatStoFtqftALbVdcOyS/FcaFYW+sGVMkCuCgMZkcS6T
         1PswEn8Cb/7y/XqQ8NDixokxyS/GZH+Vxw6zvHWaGiOltdQ6PTpi2CbwVzFufzxbqCBf
         BVg9/344h8WlpJ5OTjwEsG5TN+ab9NHFhiQMk9It+3s1BrsYQf9S+zYr2vTMz4FgbF4s
         c0sodTIdneyBW1EarOky7U6Dp9/+l5wvAUs6/niQ/FI4FabJMC7y1qdTc9ZyPijugbzD
         NEpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+IpVkEffy7PlUYnFxm9TjdHlDyLe6Pv7WXvVTMMNw9s=;
        b=GGbeq7x4EdRBHzcu6xPT7IAGR8c8LheQPvnRf8sEoQ+/4Y6o/sdZQOKeGD/IvF7gJ+
         Juyik9QBX8xjdmLmDwx+Pr3ylPMFFiUivPUMT6K+mCSljS1zEqJhcQ+PFWm9LbuRHhZS
         SbxDdCTqzSOcJaWD7YOD/KCfza5WWpdZg/t31tB2AJE+YpASXylk1bRcCb0hlVrZLg9n
         nBi5nneP/AgMTOi8kV4++qtVlJv3etcwNXTpabIQqCWqn+RP0S0hz1K/quAW8VYdToxC
         VoEH3Ghw4NFE+vCzpvzu3L4viou+emc56AWLwb32gujvfOVPEG1vVxJJHdJ70bfTch8D
         Sv8Q==
X-Gm-Message-State: AOAM531TV/7bqV4j/ycOd3R7yFZzftuxsUhrW/b0Uw68ZJ4q0WJ16h9X
        49nxsLG7m5Ec4jw2GOTPpq+YyFmpafXMHQ==
X-Google-Smtp-Source: ABdhPJx/w7ihmRRL1LnVIdvfc8uMHPenPasOawMwk0L4IX/EMpdDCkbg+rzY/pJsgn2dUlqTa6SXJg==
X-Received: by 2002:a05:6638:1250:b0:314:d9da:13b2 with SMTP id o16-20020a056638125000b00314d9da13b2mr6173036jas.99.1649861296187;
        Wed, 13 Apr 2022 07:48:16 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u15-20020a056e021a4f00b002c665afb993sm108381ilv.11.2022.04.13.07.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 07:48:15 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     Deepak Kumar Singh <deesin@codeaurora.org>, clew@codeaurora.org,
        swboyd@chromium.org, bjorn.andersson@linaro.org, kuba@kernel.org,
        elder@kernel.org, gregkh@linuxfoundation.org
Subject: [PATCH 1/3] soc: qcom: aoss: Expose send for generic usecase
Date:   Wed, 13 Apr 2022 09:48:09 -0500
Message-Id: <20220413144811.522143-2-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220413144811.522143-1-elder@linaro.org>
References: <20220413144811.522143-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deepak Kumar Singh <deesin@codeaurora.org>

commit 8c75d585b931ac874fbe4ee5a8f1811d20c2817f upstream.

Not all upcoming usecases will have an interface to allow the aoss
driver to hook onto. Expose the send api and create a get function to
enable drivers to send their own messages to aoss.

Signed-off-by: Chris Lew <clew@codeaurora.org>
Signed-off-by: Deepak Kumar Singh <deesin@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1630420228-31075-2-git-send-email-deesin@codeaurora.org
---
 drivers/soc/qcom/qcom_aoss.c       | 54 +++++++++++++++++++++++++++++-
 include/linux/soc/qcom/qcom_aoss.h | 38 +++++++++++++++++++++
 2 files changed, 91 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/soc/qcom/qcom_aoss.h

diff --git a/drivers/soc/qcom/qcom_aoss.c b/drivers/soc/qcom/qcom_aoss.c
index a0659cf278456..d40d8e20ceb46 100644
--- a/drivers/soc/qcom/qcom_aoss.c
+++ b/drivers/soc/qcom/qcom_aoss.c
@@ -8,10 +8,12 @@
 #include <linux/io.h>
 #include <linux/mailbox_client.h>
 #include <linux/module.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/thermal.h>
 #include <linux/slab.h>
+#include <linux/soc/qcom/qcom_aoss.h>
 
 #define QMP_DESC_MAGIC			0x0
 #define QMP_DESC_VERSION		0x4
@@ -223,11 +225,14 @@ static bool qmp_message_empty(struct qmp *qmp)
  *
  * Return: 0 on success, negative errno on failure
  */
-static int qmp_send(struct qmp *qmp, const void *data, size_t len)
+int qmp_send(struct qmp *qmp, const void *data, size_t len)
 {
 	long time_left;
 	int ret;
 
+	if (WARN_ON(IS_ERR_OR_NULL(qmp) || !data))
+		return -EINVAL;
+
 	if (WARN_ON(len + sizeof(u32) > qmp->size))
 		return -EINVAL;
 
@@ -261,6 +266,7 @@ static int qmp_send(struct qmp *qmp, const void *data, size_t len)
 
 	return ret;
 }
+EXPORT_SYMBOL(qmp_send);
 
 static int qmp_qdss_clk_prepare(struct clk_hw *hw)
 {
@@ -519,6 +525,51 @@ static void qmp_cooling_devices_remove(struct qmp *qmp)
 		thermal_cooling_device_unregister(qmp->cooling_devs[i].cdev);
 }
 
+/**
+ * qmp_get() - get a qmp handle from a device
+ * @dev: client device pointer
+ *
+ * Return: handle to qmp device on success, ERR_PTR() on failure
+ */
+struct qmp *qmp_get(struct device *dev)
+{
+	struct platform_device *pdev;
+	struct device_node *np;
+	struct qmp *qmp;
+
+	if (!dev || !dev->of_node)
+		return ERR_PTR(-EINVAL);
+
+	np = of_parse_phandle(dev->of_node, "qcom,qmp", 0);
+	if (!np)
+		return ERR_PTR(-ENODEV);
+
+	pdev = of_find_device_by_node(np);
+	of_node_put(np);
+	if (!pdev)
+		return ERR_PTR(-EINVAL);
+
+	qmp = platform_get_drvdata(pdev);
+
+	return qmp ? qmp : ERR_PTR(-EPROBE_DEFER);
+}
+EXPORT_SYMBOL(qmp_get);
+
+/**
+ * qmp_put() - release a qmp handle
+ * @qmp: qmp handle obtained from qmp_get()
+ */
+void qmp_put(struct qmp *qmp)
+{
+	/*
+	 * Match get_device() inside of_find_device_by_node() in
+	 * qmp_get()
+	 */
+	if (!IS_ERR_OR_NULL(qmp))
+		put_device(qmp->dev);
+}
+EXPORT_SYMBOL(qmp_put);
+
 static int qmp_probe(struct platform_device *pdev)
 {
 	struct resource *res;
@@ -615,6 +666,7 @@ static struct platform_driver qmp_driver = {
 	.driver = {
 		.name		= "qcom_aoss_qmp",
 		.of_match_table	= qmp_dt_match,
+		.suppress_bind_attrs = true,
 	},
 	.probe = qmp_probe,
 	.remove	= qmp_remove,
diff --git a/include/linux/soc/qcom/qcom_aoss.h b/include/linux/soc/qcom/qcom_aoss.h
new file mode 100644
index 0000000000000..3c2a82e606f81
--- /dev/null
+++ b/include/linux/soc/qcom/qcom_aoss.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ */
+
+#ifndef __QCOM_AOSS_H__
+#define __QCOM_AOSS_H__
+
+#include <linux/err.h>
+#include <linux/device.h>
+
+struct qmp;
+
+#if IS_ENABLED(CONFIG_QCOM_AOSS_QMP)
+
+int qmp_send(struct qmp *qmp, const void *data, size_t len);
+struct qmp *qmp_get(struct device *dev);
+void qmp_put(struct qmp *qmp);
+
+#else
+
+static inline int qmp_send(struct qmp *qmp, const void *data, size_t len)
+{
+	return -ENODEV;
+}
+
+static inline struct qmp *qmp_get(struct device *dev)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline void qmp_put(struct qmp *qmp)
+{
+}
+
+#endif
+
+#endif
-- 
2.32.0


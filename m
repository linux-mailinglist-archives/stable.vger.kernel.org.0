Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCF5505214
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbiDRMmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239907AbiDRMiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:38:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30AD24957;
        Mon, 18 Apr 2022 05:28:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E4FEB80EC1;
        Mon, 18 Apr 2022 12:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0D7C385A1;
        Mon, 18 Apr 2022 12:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284932;
        bh=KS6SliFmK5MnBCfg+AP6JICc3H5SykJshEU/9N9nCoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=10tU6ygxkxiMvBSyUGLGQQDQ03W4eyyOa08lVtwsgvc0vJ+C0WTzz1u0UBuzT56lL
         z8NBE6Y/V3qPTd2/Z3wwCB0haMXrWcfdU3etYRhHuJ9uvjGnhJzyPWVAIXjy0ib9fd
         ++xsOGFyYcQtKlA/zqKoQWKb2XMF8zuuMqcqjW0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Lew <clew@codeaurora.org>,
        Deepak Kumar Singh <deesin@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alex Elder <elder@linaro.org>
Subject: [PATCH 5.15 012/189] soc: qcom: aoss: Expose send for generic usecase
Date:   Mon, 18 Apr 2022 14:10:32 +0200
Message-Id: <20220418121200.845220233@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/qcom_aoss.c       |   54 ++++++++++++++++++++++++++++++++++++-
 include/linux/soc/qcom/qcom_aoss.h |   38 ++++++++++++++++++++++++++
 2 files changed, 91 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/soc/qcom/qcom_aoss.h

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
@@ -223,11 +225,14 @@ static bool qmp_message_empty(struct qmp
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
 
@@ -261,6 +266,7 @@ static int qmp_send(struct qmp *qmp, con
 
 	return ret;
 }
+EXPORT_SYMBOL(qmp_send);
 
 static int qmp_qdss_clk_prepare(struct clk_hw *hw)
 {
@@ -519,6 +525,51 @@ static void qmp_cooling_devices_remove(s
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
@@ -615,6 +666,7 @@ static struct platform_driver qmp_driver
 	.driver = {
 		.name		= "qcom_aoss_qmp",
 		.of_match_table	= qmp_dt_match,
+		.suppress_bind_attrs = true,
 	},
 	.probe = qmp_probe,
 	.remove	= qmp_remove,
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



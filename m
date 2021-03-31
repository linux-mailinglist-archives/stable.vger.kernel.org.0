Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730103475C1
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 11:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbhCXKTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 06:19:43 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:46590 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbhCXKTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 06:19:17 -0400
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 24 Mar 2021 03:19:17 -0700
X-QCInternal: smtphost
Received: from ironmsg01-blr.qualcomm.com ([10.86.208.130])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/AES256-SHA; 24 Mar 2021 03:19:14 -0700
X-QCInternal: smtphost
Received: from c-rojay-linux.qualcomm.com ([10.206.21.80])
  by ironmsg01-blr.qualcomm.com with ESMTP; 24 Mar 2021 15:48:40 +0530
Received: by c-rojay-linux.qualcomm.com (Postfix, from userid 88981)
        id 210BF3166; Wed, 24 Mar 2021 15:48:39 +0530 (IST)
From:   Roja Rani Yarubandi <rojay@codeaurora.org>
To:     agross@kernel.org, bjorn.andersson@linaro.org,
        gregkh@linuxfoundation.org, mka@chromium.org, robh+dt@kernel.org
Cc:     linux-serial@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajendra Nayak <rnayak@codeaurora.org>,
        akashast@codeaurora.org, msavaliy@qti.qualcomm.com,
        Roja Rani Yarubandi <rojay@codeaurora.org>,
        stable@vger.kernel.org
Subject: [RESEND PATCH V3 1/2] soc: qcom-geni-se: Cleanup the code to remove proxy votes
Date:   Wed, 24 Mar 2021 15:48:35 +0530
Message-Id: <20210324101836.25272-2-rojay@codeaurora.org>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210324101836.25272-1-rojay@codeaurora.org>
References: <20210324101836.25272-1-rojay@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 048eb908a1f2 ("soc: qcom-geni-se: Add interconnect
support to fix earlycon crash")

ICC core and platforms drivers supports sync_state feature, which
ensures that the default ICC BW votes from the bootloader is not
removed until all it's consumers are probes.

The proxy votes were needed in case other QUP child drivers
I2C, SPI probes before UART, they can turn off the QUP-CORE clock
which is shared resources for all QUP driver, this causes unclocked
access to HW from earlycon.

Given above support from ICC there is no longer need to maintain
proxy votes on QUP-CORE ICC node from QUP wrapper driver for early
console usecase, the default votes won't be removed until real
console is probed.

Cc: stable@vger.kernel.org
Fixes: 266cd33b5913 ("interconnect: qcom: Ensure that the floor bandwidth value is enforced")
Fixes: 7d3b0b0d8184 ("interconnect: qcom: Use icc_sync_state")
Signed-off-by: Roja Rani Yarubandi <rojay@codeaurora.org>
Signed-off-by: Akash Asthana <akashast@codeaurora.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in V3:
 - As per Matthias comments, updated commit text with adding
   icc sync_state and geni icc earlycon commits info

Changes in V2:
 - No change

 drivers/soc/qcom/qcom-geni-se.c       | 74 ---------------------------
 drivers/tty/serial/qcom_geni_serial.c |  7 ---
 include/linux/qcom-geni-se.h          |  2 -
 3 files changed, 83 deletions(-)

diff --git a/drivers/soc/qcom/qcom-geni-se.c b/drivers/soc/qcom/qcom-geni-se.c
index c7c03ccfe888..5bdfb1565c14 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -3,7 +3,6 @@
 
 #include <linux/acpi.h>
 #include <linux/clk.h>
-#include <linux/console.h>
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
@@ -92,14 +91,11 @@ struct geni_wrapper {
 	struct device *dev;
 	void __iomem *base;
 	struct clk_bulk_data ahb_clks[NUM_AHB_CLKS];
-	struct geni_icc_path to_core;
 };
 
 static const char * const icc_path_names[] = {"qup-core", "qup-config",
 						"qup-memory"};
 
-static struct geni_wrapper *earlycon_wrapper;
-
 #define QUP_HW_VER_REG			0x4
 
 /* Common SE registers */
@@ -846,44 +842,11 @@ int geni_icc_disable(struct geni_se *se)
 }
 EXPORT_SYMBOL(geni_icc_disable);
 
-void geni_remove_earlycon_icc_vote(void)
-{
-	struct platform_device *pdev;
-	struct geni_wrapper *wrapper;
-	struct device_node *parent;
-	struct device_node *child;
-
-	if (!earlycon_wrapper)
-		return;
-
-	wrapper = earlycon_wrapper;
-	parent = of_get_next_parent(wrapper->dev->of_node);
-	for_each_child_of_node(parent, child) {
-		if (!of_device_is_compatible(child, "qcom,geni-se-qup"))
-			continue;
-
-		pdev = of_find_device_by_node(child);
-		if (!pdev)
-			continue;
-
-		wrapper = platform_get_drvdata(pdev);
-		icc_put(wrapper->to_core.path);
-		wrapper->to_core.path = NULL;
-
-	}
-	of_node_put(parent);
-
-	earlycon_wrapper = NULL;
-}
-EXPORT_SYMBOL(geni_remove_earlycon_icc_vote);
-
 static int geni_se_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct resource *res;
 	struct geni_wrapper *wrapper;
-	struct console __maybe_unused *bcon;
-	bool __maybe_unused has_earlycon = false;
 	int ret;
 
 	wrapper = devm_kzalloc(dev, sizeof(*wrapper), GFP_KERNEL);
@@ -906,43 +869,6 @@ static int geni_se_probe(struct platform_device *pdev)
 		}
 	}
 
-#ifdef CONFIG_SERIAL_EARLYCON
-	for_each_console(bcon) {
-		if (!strcmp(bcon->name, "qcom_geni")) {
-			has_earlycon = true;
-			break;
-		}
-	}
-	if (!has_earlycon)
-		goto exit;
-
-	wrapper->to_core.path = devm_of_icc_get(dev, "qup-core");
-	if (IS_ERR(wrapper->to_core.path))
-		return PTR_ERR(wrapper->to_core.path);
-	/*
-	 * Put minmal BW request on core clocks on behalf of early console.
-	 * The vote will be removed earlycon exit function.
-	 *
-	 * Note: We are putting vote on each QUP wrapper instead only to which
-	 * earlycon is connected because QUP core clock of different wrapper
-	 * share same voltage domain. If core1 is put to 0, then core2 will
-	 * also run at 0, if not voted. Default ICC vote will be removed ASA
-	 * we touch any of the core clock.
-	 * core1 = core2 = max(core1, core2)
-	 */
-	ret = icc_set_bw(wrapper->to_core.path, GENI_DEFAULT_BW,
-				GENI_DEFAULT_BW);
-	if (ret) {
-		dev_err(&pdev->dev, "%s: ICC BW voting failed for core: %d\n",
-			__func__, ret);
-		return ret;
-	}
-
-	if (of_get_compatible_child(pdev->dev.of_node, "qcom,geni-debug-uart"))
-		earlycon_wrapper = wrapper;
-	of_node_put(pdev->dev.of_node);
-exit:
-#endif
 	dev_set_drvdata(dev, wrapper);
 	dev_dbg(dev, "GENI SE Driver probed\n");
 	return devm_of_platform_populate(dev);
diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 3872bbfac24b..99375d99f6fa 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1177,12 +1177,6 @@ static inline void qcom_geni_serial_enable_early_read(struct geni_se *se,
 						      struct console *con) { }
 #endif
 
-static int qcom_geni_serial_earlycon_exit(struct console *con)
-{
-	geni_remove_earlycon_icc_vote();
-	return 0;
-}
-
 static struct qcom_geni_private_data earlycon_private_data;
 
 static int __init qcom_geni_serial_earlycon_setup(struct earlycon_device *dev,
@@ -1233,7 +1227,6 @@ static int __init qcom_geni_serial_earlycon_setup(struct earlycon_device *dev,
 	writel(stop_bit_len, uport->membase + SE_UART_TX_STOP_BIT_LEN);
 
 	dev->con->write = qcom_geni_serial_earlycon_write;
-	dev->con->exit = qcom_geni_serial_earlycon_exit;
 	dev->con->setup = NULL;
 	qcom_geni_serial_enable_early_read(&se, dev->con);
 
diff --git a/include/linux/qcom-geni-se.h b/include/linux/qcom-geni-se.h
index cddef864a760..7c811eebcaab 100644
--- a/include/linux/qcom-geni-se.h
+++ b/include/linux/qcom-geni-se.h
@@ -458,7 +458,5 @@ void geni_icc_set_tag(struct geni_se *se, u32 tag);
 int geni_icc_enable(struct geni_se *se);
 
 int geni_icc_disable(struct geni_se *se);
-
-void geni_remove_earlycon_icc_vote(void);
 #endif
 #endif
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member 
of Code Aurora Forum, hosted by The Linux Foundation


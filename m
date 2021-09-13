Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9AC408FAC
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242888AbhIMNpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241608AbhIMNoF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:44:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6402461458;
        Mon, 13 Sep 2021 13:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539855;
        bh=yNC7/3njqplb8VC9IvrkK/nCvp1Cp9KG2cJgY3jZz0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFLxAufn6T5vbOw3mkadL8bv5o3kG/Q+UKHxedDUNgg0jFB3RDGedPZmibWH8tLB+
         9irGVFMF6G5KuBz2RLzxhmI1LrKKe2DlTOVPhIqlSQAzNPAiT/+oXArq61oOrTc8XO
         fizSg1HWAjdjh9ZfZIB/s06hvOi6m8zaerU42Am8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/236] firmware: raspberrypi: Keep count of all consumers
Date:   Mon, 13 Sep 2021 15:14:35 +0200
Message-Id: <20210913131106.157276529@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit 1e7c57355a3bc617fc220234889e49fe722a6305 ]

When unbinding the firmware device we need to make sure it has no
consumers left. Otherwise we'd leave them with a firmware handle
pointing at freed memory.

Keep a reference count of all consumers and introduce rpi_firmware_put()
which will permit automatically decrease the reference count upon
unbinding consumer drivers.

Suggested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/raspberrypi.c             | 40 ++++++++++++++++++++--
 include/soc/bcm2835/raspberrypi-firmware.h |  2 ++
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/raspberrypi.c b/drivers/firmware/raspberrypi.c
index 2371d08bdd17..8996deadd79b 100644
--- a/drivers/firmware/raspberrypi.c
+++ b/drivers/firmware/raspberrypi.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/dma-mapping.h>
+#include <linux/kref.h>
 #include <linux/mailbox_client.h>
 #include <linux/module.h>
 #include <linux/of_platform.h>
@@ -27,6 +28,8 @@ struct rpi_firmware {
 	struct mbox_chan *chan; /* The property channel. */
 	struct completion c;
 	u32 enabled;
+
+	struct kref consumers;
 };
 
 static DEFINE_MUTEX(transaction_lock);
@@ -225,12 +228,31 @@ static void rpi_register_clk_driver(struct device *dev)
 						-1, NULL, 0);
 }
 
+static void rpi_firmware_delete(struct kref *kref)
+{
+	struct rpi_firmware *fw = container_of(kref, struct rpi_firmware,
+					       consumers);
+
+	mbox_free_channel(fw->chan);
+	kfree(fw);
+}
+
+void rpi_firmware_put(struct rpi_firmware *fw)
+{
+	kref_put(&fw->consumers, rpi_firmware_delete);
+}
+EXPORT_SYMBOL_GPL(rpi_firmware_put);
+
 static int rpi_firmware_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct rpi_firmware *fw;
 
-	fw = devm_kzalloc(dev, sizeof(*fw), GFP_KERNEL);
+	/*
+	 * Memory will be freed by rpi_firmware_delete() once all users have
+	 * released their firmware handles. Don't use devm_kzalloc() here.
+	 */
+	fw = kzalloc(sizeof(*fw), GFP_KERNEL);
 	if (!fw)
 		return -ENOMEM;
 
@@ -247,6 +269,7 @@ static int rpi_firmware_probe(struct platform_device *pdev)
 	}
 
 	init_completion(&fw->c);
+	kref_init(&fw->consumers);
 
 	platform_set_drvdata(pdev, fw);
 
@@ -275,7 +298,8 @@ static int rpi_firmware_remove(struct platform_device *pdev)
 	rpi_hwmon = NULL;
 	platform_device_unregister(rpi_clk);
 	rpi_clk = NULL;
-	mbox_free_channel(fw->chan);
+
+	rpi_firmware_put(fw);
 
 	return 0;
 }
@@ -284,16 +308,26 @@ static int rpi_firmware_remove(struct platform_device *pdev)
  * rpi_firmware_get - Get pointer to rpi_firmware structure.
  * @firmware_node:    Pointer to the firmware Device Tree node.
  *
+ * The reference to rpi_firmware has to be released with rpi_firmware_put().
+ *
  * Returns NULL is the firmware device is not ready.
  */
 struct rpi_firmware *rpi_firmware_get(struct device_node *firmware_node)
 {
 	struct platform_device *pdev = of_find_device_by_node(firmware_node);
+	struct rpi_firmware *fw;
 
 	if (!pdev)
 		return NULL;
 
-	return platform_get_drvdata(pdev);
+	fw = platform_get_drvdata(pdev);
+	if (!fw)
+		return NULL;
+
+	if (!kref_get_unless_zero(&fw->consumers))
+		return NULL;
+
+	return fw;
 }
 EXPORT_SYMBOL_GPL(rpi_firmware_get);
 
diff --git a/include/soc/bcm2835/raspberrypi-firmware.h b/include/soc/bcm2835/raspberrypi-firmware.h
index cc9cdbc66403..fdfef7fe40df 100644
--- a/include/soc/bcm2835/raspberrypi-firmware.h
+++ b/include/soc/bcm2835/raspberrypi-firmware.h
@@ -140,6 +140,7 @@ int rpi_firmware_property(struct rpi_firmware *fw,
 			  u32 tag, void *data, size_t len);
 int rpi_firmware_property_list(struct rpi_firmware *fw,
 			       void *data, size_t tag_size);
+void rpi_firmware_put(struct rpi_firmware *fw);
 struct rpi_firmware *rpi_firmware_get(struct device_node *firmware_node);
 #else
 static inline int rpi_firmware_property(struct rpi_firmware *fw, u32 tag,
@@ -154,6 +155,7 @@ static inline int rpi_firmware_property_list(struct rpi_firmware *fw,
 	return -ENOSYS;
 }
 
+static inline void rpi_firmware_put(struct rpi_firmware *fw) { }
 static inline struct rpi_firmware *rpi_firmware_get(struct device_node *firmware_node)
 {
 	return NULL;
-- 
2.30.2




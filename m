Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE6F14B746
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbgA1OM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:12:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:34362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728763AbgA1OMz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:12:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 771FC24690;
        Tue, 28 Jan 2020 14:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220773;
        bh=CfwPkFbg8bR94YgwudsN0HyJQWmcsxgi8/jUu+7gDeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WR5sC8FHg/607tWrkk23UamgTxpWaoIo61KDr5rMsjhMFRNtcoJkMTx9oYJquqr6Y
         2HDvkKcsGJufXBxYrBm+RbOm0inD1stRFFoYeC00C3GONjWV9aGXQeONAwC2K00Woh
         icpyx8tVdjStzIHbaZujHkpWjC5iNAES4S7+81tI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 114/183] mic: avoid statically declaring a struct device.
Date:   Tue, 28 Jan 2020 15:05:33 +0100
Message-Id: <20200128135841.313756995@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit bc83f79bd2119230888fb8574639d5a51b38f903 ]

Generally, declaring a platform device as a static variable is
a bad idea and can cause all kinds of problems, in particular
with the DMA configuration and lifetime rules.

A specific problem we hit here is from a bug in clang that warns
about certain (otherwise valid) macros when used in static variables:

drivers/misc/mic/card/mic_x100.c:285:27: warning: shift count >= width of type [-Wshift-count-overflow]
static u64 mic_dma_mask = DMA_BIT_MASK(64);
                          ^~~~~~~~~~~~~~~~
include/linux/dma-mapping.h:141:54: note: expanded from macro 'DMA_BIT_MASK'
 #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
                                                     ^ ~~~

A slightly better way here is to create the platform device dynamically
and set the dma mask in the probe function.
This avoids the warning and some other problems, but is still not ideal
because the device creation should really be separated from the driver,
and the fact that the device has no parent means we have to force
the dma mask rather than having it set up from the bus that the device
is actually on.

Fixes: dd8d8d44df64 ("misc: mic: MIC card driver specific changes to enable SCIF")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20190712092426.872625-1-arnd@arndb.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mic/card/mic_x100.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/misc/mic/card/mic_x100.c b/drivers/misc/mic/card/mic_x100.c
index b2958ce2368c7..cd778e2b4f3ea 100644
--- a/drivers/misc/mic/card/mic_x100.c
+++ b/drivers/misc/mic/card/mic_x100.c
@@ -249,6 +249,9 @@ static int __init mic_probe(struct platform_device *pdev)
 	mdrv->dev = &pdev->dev;
 	snprintf(mdrv->name, sizeof(mic_driver_name), mic_driver_name);
 
+	/* FIXME: use dma_set_mask_and_coherent() and check result */
+	dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+
 	mdev->mmio.pa = MIC_X100_MMIO_BASE;
 	mdev->mmio.len = MIC_X100_MMIO_LEN;
 	mdev->mmio.va = devm_ioremap(&pdev->dev, MIC_X100_MMIO_BASE,
@@ -294,18 +297,6 @@ static void mic_platform_shutdown(struct platform_device *pdev)
 	mic_remove(pdev);
 }
 
-static u64 mic_dma_mask = DMA_BIT_MASK(64);
-
-static struct platform_device mic_platform_dev = {
-	.name = mic_driver_name,
-	.id   = 0,
-	.num_resources = 0,
-	.dev = {
-		.dma_mask = &mic_dma_mask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
-	},
-};
-
 static struct platform_driver __refdata mic_platform_driver = {
 	.probe = mic_probe,
 	.remove = mic_remove,
@@ -315,6 +306,8 @@ static struct platform_driver __refdata mic_platform_driver = {
 	},
 };
 
+static struct platform_device *mic_platform_dev;
+
 static int __init mic_init(void)
 {
 	int ret;
@@ -327,9 +320,12 @@ static int __init mic_init(void)
 	}
 
 	mic_init_card_debugfs();
-	ret = platform_device_register(&mic_platform_dev);
+
+	mic_platform_dev = platform_device_register_simple(mic_driver_name,
+							   0, NULL, 0);
+	ret = PTR_ERR_OR_ZERO(mic_platform_dev);
 	if (ret) {
-		pr_err("platform_device_register ret %d\n", ret);
+		pr_err("platform_device_register_full ret %d\n", ret);
 		goto cleanup_debugfs;
 	}
 	ret = platform_driver_register(&mic_platform_driver);
@@ -340,7 +336,7 @@ static int __init mic_init(void)
 	return ret;
 
 device_unregister:
-	platform_device_unregister(&mic_platform_dev);
+	platform_device_unregister(mic_platform_dev);
 cleanup_debugfs:
 	mic_exit_card_debugfs();
 done:
@@ -350,7 +346,7 @@ done:
 static void __exit mic_exit(void)
 {
 	platform_driver_unregister(&mic_platform_driver);
-	platform_device_unregister(&mic_platform_dev);
+	platform_device_unregister(mic_platform_dev);
 	mic_exit_card_debugfs();
 }
 
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A59A4F011F
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 13:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiDBLf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 07:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbiDBLf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 07:35:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B30BD9D
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 04:33:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB86A61257
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 11:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E16C340EC;
        Sat,  2 Apr 2022 11:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648899213;
        bh=QumuaWRyEFH5/ZxpiLErubCVYgvCPvezP4oMKm3u2gc=;
        h=Subject:To:Cc:From:Date:From;
        b=u6sH3AmdTiGuF2PL4/4Xot0SkkJl16imGIEwD3RreeIwJHhk2yVUKgnz73s1yY39D
         6+ynhN2fOAz7luPGE43twUYnafcx4llx9KH7UZmr3C3/9T/wUiDzBpbfzsAQlEPS+r
         021X3Wqw+shjFi8LuflfCqGZ6LaMTlJIXyPKIQOA=
Subject: FAILED: patch "[PATCH] mmc: core: use sysfs_emit() instead of sprintf()" failed to apply to 5.10-stable tree
To:     s.shtylyov@omp.ru, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 13:33:23 +0200
Message-ID: <1648899203160121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f5d8a5fe77ce933f53eb8f2e22bb7a1a2019ea11 Mon Sep 17 00:00:00 2001
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Date: Tue, 8 Feb 2022 15:02:15 +0300
Subject: [PATCH] mmc: core: use sysfs_emit() instead of sprintf()

sprintf() (still used in the MMC core for the sysfs output) is vulnerable
to the buffer overflow.  Use the new-fangled sysfs_emit() instead.

Found by Linux Verification Center (linuxtesting.org) with the SVACE static
analysis tool.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/717729b2-d65b-c72e-9fac-471d28d00b5a@omp.ru
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 096ae624be9a..58a60afa650b 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -15,6 +15,7 @@
 #include <linux/stat.h>
 #include <linux/of.h>
 #include <linux/pm_runtime.h>
+#include <linux/sysfs.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -34,13 +35,13 @@ static ssize_t type_show(struct device *dev,
 
 	switch (card->type) {
 	case MMC_TYPE_MMC:
-		return sprintf(buf, "MMC\n");
+		return sysfs_emit(buf, "MMC\n");
 	case MMC_TYPE_SD:
-		return sprintf(buf, "SD\n");
+		return sysfs_emit(buf, "SD\n");
 	case MMC_TYPE_SDIO:
-		return sprintf(buf, "SDIO\n");
+		return sysfs_emit(buf, "SDIO\n");
 	case MMC_TYPE_SD_COMBO:
-		return sprintf(buf, "SDcombo\n");
+		return sysfs_emit(buf, "SDcombo\n");
 	default:
 		return -EFAULT;
 	}
diff --git a/drivers/mmc/core/bus.h b/drivers/mmc/core/bus.h
index 8105852c4b62..3996b191b68d 100644
--- a/drivers/mmc/core/bus.h
+++ b/drivers/mmc/core/bus.h
@@ -9,6 +9,7 @@
 #define _MMC_CORE_BUS_H
 
 #include <linux/device.h>
+#include <linux/sysfs.h>
 
 struct mmc_host;
 struct mmc_card;
@@ -17,7 +18,7 @@ struct mmc_card;
 static ssize_t mmc_##name##_show (struct device *dev, struct device_attribute *attr, char *buf)	\
 {										\
 	struct mmc_card *card = mmc_dev_to_card(dev);				\
-	return sprintf(buf, fmt, args);						\
+	return sysfs_emit(buf, fmt, args);					\
 }										\
 static DEVICE_ATTR(name, S_IRUGO, mmc_##name##_show, NULL)
 
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index bbbbcaf70a59..13abfcd130a5 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/pm_runtime.h>
+#include <linux/sysfs.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -812,12 +813,11 @@ static ssize_t mmc_fwrev_show(struct device *dev,
 {
 	struct mmc_card *card = mmc_dev_to_card(dev);
 
-	if (card->ext_csd.rev < 7) {
-		return sprintf(buf, "0x%x\n", card->cid.fwrev);
-	} else {
-		return sprintf(buf, "0x%*phN\n", MMC_FIRMWARE_LEN,
-			       card->ext_csd.fwrev);
-	}
+	if (card->ext_csd.rev < 7)
+		return sysfs_emit(buf, "0x%x\n", card->cid.fwrev);
+	else
+		return sysfs_emit(buf, "0x%*phN\n", MMC_FIRMWARE_LEN,
+				  card->ext_csd.fwrev);
 }
 
 static DEVICE_ATTR(fwrev, S_IRUGO, mmc_fwrev_show, NULL);
@@ -830,10 +830,10 @@ static ssize_t mmc_dsr_show(struct device *dev,
 	struct mmc_host *host = card->host;
 
 	if (card->csd.dsr_imp && host->dsr_req)
-		return sprintf(buf, "0x%x\n", host->dsr);
+		return sysfs_emit(buf, "0x%x\n", host->dsr);
 	else
 		/* return default DSR value */
-		return sprintf(buf, "0x%x\n", 0x404);
+		return sysfs_emit(buf, "0x%x\n", 0x404);
 }
 
 static DEVICE_ATTR(dsr, S_IRUGO, mmc_dsr_show, NULL);
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index bd87012c220c..24b0418a24bb 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -13,6 +13,7 @@
 #include <linux/stat.h>
 #include <linux/pm_runtime.h>
 #include <linux/scatterlist.h>
+#include <linux/sysfs.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -708,18 +709,16 @@ MMC_DEV_ATTR(ocr, "0x%08x\n", card->ocr);
 MMC_DEV_ATTR(rca, "0x%04x\n", card->rca);
 
 
-static ssize_t mmc_dsr_show(struct device *dev,
-                           struct device_attribute *attr,
-                           char *buf)
+static ssize_t mmc_dsr_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
 {
-       struct mmc_card *card = mmc_dev_to_card(dev);
-       struct mmc_host *host = card->host;
-
-       if (card->csd.dsr_imp && host->dsr_req)
-               return sprintf(buf, "0x%x\n", host->dsr);
-       else
-               /* return default DSR value */
-               return sprintf(buf, "0x%x\n", 0x404);
+	struct mmc_card *card = mmc_dev_to_card(dev);
+	struct mmc_host *host = card->host;
+
+	if (card->csd.dsr_imp && host->dsr_req)
+		return sysfs_emit(buf, "0x%x\n", host->dsr);
+	/* return default DSR value */
+	return sysfs_emit(buf, "0x%x\n", 0x404);
 }
 
 static DEVICE_ATTR(dsr, S_IRUGO, mmc_dsr_show, NULL);
@@ -735,9 +734,9 @@ static ssize_t info##num##_show(struct device *dev, struct device_attribute *att
 												\
 	if (num > card->num_info)								\
 		return -ENODATA;								\
-	if (!card->info[num-1][0])								\
+	if (!card->info[num - 1][0])								\
 		return 0;									\
-	return sprintf(buf, "%s\n", card->info[num-1]);						\
+	return sysfs_emit(buf, "%s\n", card->info[num - 1]);					\
 }												\
 static DEVICE_ATTR_RO(info##num)
 
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 41164748723d..25799accf8a0 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -7,6 +7,7 @@
 
 #include <linux/err.h>
 #include <linux/pm_runtime.h>
+#include <linux/sysfs.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -40,9 +41,9 @@ static ssize_t info##num##_show(struct device *dev, struct device_attribute *att
 												\
 	if (num > card->num_info)								\
 		return -ENODATA;								\
-	if (!card->info[num-1][0])								\
+	if (!card->info[num - 1][0])								\
 		return 0;									\
-	return sprintf(buf, "%s\n", card->info[num-1]);						\
+	return sysfs_emit(buf, "%s\n", card->info[num - 1]);					\
 }												\
 static DEVICE_ATTR_RO(info##num)
 
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index fda03b35c14a..c6268c38c69e 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -14,6 +14,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/pm_domain.h>
 #include <linux/acpi.h>
+#include <linux/sysfs.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -35,7 +36,7 @@ field##_show(struct device *dev, struct device_attribute *attr, char *buf)				\
 	struct sdio_func *func;						\
 									\
 	func = dev_to_sdio_func (dev);					\
-	return sprintf(buf, format_string, args);			\
+	return sysfs_emit(buf, format_string, args);			\
 }									\
 static DEVICE_ATTR_RO(field)
 
@@ -52,9 +53,9 @@ static ssize_t info##num##_show(struct device *dev, struct device_attribute *att
 												\
 	if (num > func->num_info)								\
 		return -ENODATA;								\
-	if (!func->info[num-1][0])								\
+	if (!func->info[num - 1][0])								\
 		return 0;									\
-	return sprintf(buf, "%s\n", func->info[num-1]);						\
+	return sysfs_emit(buf, "%s\n", func->info[num - 1]);					\
 }												\
 static DEVICE_ATTR_RO(info##num)
 


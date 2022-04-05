Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E891F4F258B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbiDEHuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbiDEHry (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFED791575;
        Tue,  5 Apr 2022 00:44:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C68D616C6;
        Tue,  5 Apr 2022 07:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3F2C340EE;
        Tue,  5 Apr 2022 07:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144675;
        bh=B2Gvg2dMSeDybRBkutfI6uE2QcVJM3mGlmrR9iRhpZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2ArvyJYVWjxuEhbxfNJ5rMnA9Vwwasdv0m3HZXSfyfjECGT4Vzj3886HytDeOYhq
         ALwsBtTYr3vSXuWwco9nYjclGLRlxZE69ytvmX/KSPpI4tvHwhapJdfA9Z67SZlHbj
         4AsVIHk49sdcxDc54H29mZaY3WDPnVtlo2OAC5zM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.17 0129/1126] mmc: core: use sysfs_emit() instead of sprintf()
Date:   Tue,  5 Apr 2022 09:14:36 +0200
Message-Id: <20220405070411.363731258@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Sergey Shtylyov <s.shtylyov@omp.ru>

commit f5d8a5fe77ce933f53eb8f2e22bb7a1a2019ea11 upstream.

sprintf() (still used in the MMC core for the sysfs output) is vulnerable
to the buffer overflow.  Use the new-fangled sysfs_emit() instead.

Found by Linux Verification Center (linuxtesting.org) with the SVACE static
analysis tool.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/717729b2-d65b-c72e-9fac-471d28d00b5a@omp.ru
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/bus.c      |    9 +++++----
 drivers/mmc/core/bus.h      |    3 ++-
 drivers/mmc/core/mmc.c      |   16 ++++++++--------
 drivers/mmc/core/sd.c       |   27 +++++++++++++--------------
 drivers/mmc/core/sdio.c     |    5 +++--
 drivers/mmc/core/sdio_bus.c |    7 ++++---
 6 files changed, 35 insertions(+), 32 deletions(-)

--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -15,6 +15,7 @@
 #include <linux/stat.h>
 #include <linux/of.h>
 #include <linux/pm_runtime.h>
+#include <linux/sysfs.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -34,13 +35,13 @@ static ssize_t type_show(struct device *
 
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
 
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/pm_runtime.h>
+#include <linux/sysfs.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -812,12 +813,11 @@ static ssize_t mmc_fwrev_show(struct dev
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
@@ -830,10 +830,10 @@ static ssize_t mmc_dsr_show(struct devic
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
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -13,6 +13,7 @@
 #include <linux/stat.h>
 #include <linux/pm_runtime.h>
 #include <linux/scatterlist.h>
+#include <linux/sysfs.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -708,18 +709,16 @@ MMC_DEV_ATTR(ocr, "0x%08x\n", card->ocr)
 MMC_DEV_ATTR(rca, "0x%04x\n", card->rca);
 
 
-static ssize_t mmc_dsr_show(struct device *dev,
-                           struct device_attribute *attr,
-                           char *buf)
-{
-       struct mmc_card *card = mmc_dev_to_card(dev);
-       struct mmc_host *host = card->host;
-
-       if (card->csd.dsr_imp && host->dsr_req)
-               return sprintf(buf, "0x%x\n", host->dsr);
-       else
-               /* return default DSR value */
-               return sprintf(buf, "0x%x\n", 0x404);
+static ssize_t mmc_dsr_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct mmc_card *card = mmc_dev_to_card(dev);
+	struct mmc_host *host = card->host;
+
+	if (card->csd.dsr_imp && host->dsr_req)
+		return sysfs_emit(buf, "0x%x\n", host->dsr);
+	/* return default DSR value */
+	return sysfs_emit(buf, "0x%x\n", 0x404);
 }
 
 static DEVICE_ATTR(dsr, S_IRUGO, mmc_dsr_show, NULL);
@@ -735,9 +734,9 @@ static ssize_t info##num##_show(struct d
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
 
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -7,6 +7,7 @@
 
 #include <linux/err.h>
 #include <linux/pm_runtime.h>
+#include <linux/sysfs.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -40,9 +41,9 @@ static ssize_t info##num##_show(struct d
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
 
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -14,6 +14,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/pm_domain.h>
 #include <linux/acpi.h>
+#include <linux/sysfs.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -35,7 +36,7 @@ field##_show(struct device *dev, struct
 	struct sdio_func *func;						\
 									\
 	func = dev_to_sdio_func (dev);					\
-	return sprintf(buf, format_string, args);			\
+	return sysfs_emit(buf, format_string, args);			\
 }									\
 static DEVICE_ATTR_RO(field)
 
@@ -52,9 +53,9 @@ static ssize_t info##num##_show(struct d
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
 



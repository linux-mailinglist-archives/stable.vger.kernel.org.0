Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE528AA89B
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfIEQTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:19:44 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45147 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387878AbfIEQSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:18:08 -0400
Received: by mail-pg1-f195.google.com with SMTP id 4so1662109pgm.12
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 09:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3Bt6nNLlt+xUVNaG8TogY6q5T68efSQtUAFTBH8Xlsg=;
        b=HI5tWkpkgDB2JApLY2ATp8wEzTgsgI7cUXG07/am8F65CP7VSB3lI0NXxyns+DWiX2
         gaWTANI3zq2OwmaBZXn99DM6sZThpLtoRKLYi5a2I85zG/SH7P8SCjVgftKwhY5ktFuA
         vJO992gbVyS1qZ7VJYG2btuxuSIAhhpNXMIqEzmVfiiabSsH0Mel1mVFYnYEbX7WVla8
         tN7UFY3JcIVURcYH4ZeeV0a1XoRM7rgtLWf0/zDA5+VHxMm9oxNpGTujIBcQCjB7dge2
         mpkITrf0/86JuXKn9lS53c6lBD7zg0AWMotgCzvCXmzDoFROpRfyCy8gCpdWJAq9a8Hw
         RNtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3Bt6nNLlt+xUVNaG8TogY6q5T68efSQtUAFTBH8Xlsg=;
        b=eXJn4S2MxQtD7lLQxRuv6ZVKJi7WY9tunGVjXiJLgNt3Rmgtc8kx6P0y1Nt2TRMm9n
         7BcPECKs4gf8+zLWKKUCkskDRduFkrlDey/RbjrTd/8ftTAVfnVceqiOxzjbQxhVWGRs
         F7MxT+T3sDNdUaByO9cwn8FTcXYNboLEU/gNGc+QTI254h3woKpNKbAS9CK/yPA3ZfAn
         /Ex4QtHJmpVytQ5u3tLSOLeZ/A6KnuWj3VKHqfiVjUBL/JBW4DFHnVJXgaKb5p9TM5Y8
         H7IyqvyDM7DxvJVAEWWOXyRDYx9wF7P+Jc5IqPDhFU9QuJZyLV0qs3RQSRCOLl6OF+ZN
         Ltcg==
X-Gm-Message-State: APjAAAWPOLd+cfGsY6chhkik9hZPdYsESJ+ApPCtukkF6DwLqG/i7v5p
        0Q9lBkt2lSI7JwXGluD/MUluRPb/Gvs=
X-Google-Smtp-Source: APXvYqyeuaXfpPcMY8LL3N9SzaC/DWAxU9D1agyzvWDKKPe/Or/72DzL6TV62pYkRSpSy8AT7z2T/g==
X-Received: by 2002:a63:6686:: with SMTP id a128mr3841760pgc.361.1567700287353;
        Thu, 05 Sep 2019 09:18:07 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m129sm6324005pga.39.2019.09.05.09.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 09:18:06 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [BACKPORT 4.14.y 05/18] mfd: palmas: Assign the right powerhold mask for tps65917
Date:   Thu,  5 Sep 2019 10:17:46 -0600
Message-Id: <20190905161759.28036-6-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905161759.28036-1-mathieu.poirier@linaro.org>
References: <20190905161759.28036-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keerthy <j-keerthy@ti.com>

commit 572ff4d560be3784205b224cd67d6715620092d7 upstream

The powerhold mask for TPS65917 is different when comapred to
the other palmas versions. Hence assign the right mask that enables
power off of tps65917 pmic correctly.

Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/mfd/palmas.c       | 10 +++++++++-
 include/linux/mfd/palmas.h |  3 +++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 3922a93f9f92..663a2398b6b1 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -430,6 +430,7 @@ static void palmas_power_off(void)
 {
 	unsigned int addr;
 	int ret, slave;
+	u8 powerhold_mask;
 	struct device_node *np = palmas_dev->dev->of_node;
 
 	if (of_property_read_bool(np, "ti,palmas-override-powerhold")) {
@@ -437,8 +438,15 @@ static void palmas_power_off(void)
 					  PALMAS_PRIMARY_SECONDARY_PAD2);
 		slave = PALMAS_BASE_TO_SLAVE(PALMAS_PU_PD_OD_BASE);
 
+		if (of_device_is_compatible(np, "ti,tps65917"))
+			powerhold_mask =
+				TPS65917_PRIMARY_SECONDARY_PAD2_GPIO_5_MASK;
+		else
+			powerhold_mask =
+				PALMAS_PRIMARY_SECONDARY_PAD2_GPIO_7_MASK;
+
 		ret = regmap_update_bits(palmas_dev->regmap[slave], addr,
-				PALMAS_PRIMARY_SECONDARY_PAD2_GPIO_7_MASK, 0);
+					 powerhold_mask, 0);
 		if (ret)
 			dev_err(palmas_dev->dev,
 				"Unable to write PRIMARY_SECONDARY_PAD2 %d\n",
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 6dec43826303..cffb23b8bd70 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -3733,6 +3733,9 @@ enum usb_irq_events {
 #define TPS65917_REGEN3_CTRL_MODE_ACTIVE			0x01
 #define TPS65917_REGEN3_CTRL_MODE_ACTIVE_SHIFT			0x00
 
+/* POWERHOLD Mask field for PRIMARY_SECONDARY_PAD2 register */
+#define TPS65917_PRIMARY_SECONDARY_PAD2_GPIO_5_MASK		0xC
+
 /* Registers for function RESOURCE */
 #define TPS65917_REGEN1_CTRL					0x2
 #define TPS65917_PLLEN_CTRL					0x3
-- 
2.17.1


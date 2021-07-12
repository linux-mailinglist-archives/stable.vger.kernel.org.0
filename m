Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5F33C528A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348147AbhGLHq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:46:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349825AbhGLHos (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:44:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49674613D8;
        Mon, 12 Jul 2021 07:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075689;
        bh=WF1o1BNDVfyRUhkdNwe1t1ceJv4yBBYYlDm+gtp63fY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWPerlh+4Imnxhrh7NFqlfDoGI9oDGBLD1AZ59+NMenGcPkM1Y9UX6zI+7iNU63oJ
         7KmRTQDnKhogVqnk59t0+MnQ+Zo3oiqPB6YqWpA0tLUvhO0/HSk8Gp++lT22aiyZ0S
         DF+0dqTADSBbrr3SFmGAv9+dH2Vi0fJhYNHYRh8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrej Picej <andpicej@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 321/800] hwmon: (lm70) Revert "hwmon: (lm70) Add support for ACPI"
Date:   Mon, 12 Jul 2021 08:05:44 +0200
Message-Id: <20210712061000.209357245@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit ac61c8aae446b9c0fe18981fe721d4a43e283ad6 ]

This reverts commit b58bd4c6dfe709646ed9efcbba2a70643f9bc873.

None of the ACPI IDs introduced with the reverted patch is a valid ACPI
device ID. Any ACPI users of this driver are advised to use PRP0001 and
a devicetree-compatible device identification.

Fixes: b58bd4c6dfe7 ("hwmon: (lm70) Add support for ACPI")
Cc: Andrej Picej <andpicej@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm70.c | 26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/hwmon/lm70.c b/drivers/hwmon/lm70.c
index 40eab3349904..6b884ea00987 100644
--- a/drivers/hwmon/lm70.c
+++ b/drivers/hwmon/lm70.c
@@ -22,10 +22,10 @@
 #include <linux/hwmon.h>
 #include <linux/mutex.h>
 #include <linux/mod_devicetable.h>
+#include <linux/of.h>
 #include <linux/property.h>
 #include <linux/spi/spi.h>
 #include <linux/slab.h>
-#include <linux/acpi.h>
 
 #define DRVNAME		"lm70"
 
@@ -148,29 +148,6 @@ static const struct of_device_id lm70_of_ids[] = {
 MODULE_DEVICE_TABLE(of, lm70_of_ids);
 #endif
 
-#ifdef CONFIG_ACPI
-static const struct acpi_device_id lm70_acpi_ids[] = {
-	{
-		.id = "LM000070",
-		.driver_data = LM70_CHIP_LM70,
-	},
-	{
-		.id = "TMP00121",
-		.driver_data = LM70_CHIP_TMP121,
-	},
-	{
-		.id = "LM000071",
-		.driver_data = LM70_CHIP_LM71,
-	},
-	{
-		.id = "LM000074",
-		.driver_data = LM70_CHIP_LM74,
-	},
-	{},
-};
-MODULE_DEVICE_TABLE(acpi, lm70_acpi_ids);
-#endif
-
 static int lm70_probe(struct spi_device *spi)
 {
 	struct device *hwmon_dev;
@@ -217,7 +194,6 @@ static struct spi_driver lm70_driver = {
 	.driver = {
 		.name	= "lm70",
 		.of_match_table	= of_match_ptr(lm70_of_ids),
-		.acpi_match_table = ACPI_PTR(lm70_acpi_ids),
 	},
 	.id_table = lm70_ids,
 	.probe	= lm70_probe,
-- 
2.30.2




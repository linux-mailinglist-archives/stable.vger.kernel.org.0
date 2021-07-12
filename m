Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8C03C4D17
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242354AbhGLHLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244139AbhGLHK1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35814613BE;
        Mon, 12 Jul 2021 07:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073596;
        bh=WF1o1BNDVfyRUhkdNwe1t1ceJv4yBBYYlDm+gtp63fY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFCW7wv8ABMDji7OQ6rp7dX3+I1xIprJMWESCSW1jemyL1k+V05VOIUlbCz0YWBfZ
         JSzBJP3Ht2hrhcgitIC5QkVKJf1FLeJqvP811n0RdarAZzRjWlVKqwjbdDfAkOZ/2V
         70G5cmRR0JURUBhOxiYmsFpmWxkNNVz9n8IvQRsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrej Picej <andpicej@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 294/700] hwmon: (lm70) Revert "hwmon: (lm70) Add support for ACPI"
Date:   Mon, 12 Jul 2021 08:06:17 +0200
Message-Id: <20210712061007.554077283@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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




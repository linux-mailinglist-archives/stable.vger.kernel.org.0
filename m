Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B881E3C498D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbhGLGpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:45:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236234AbhGLGm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:42:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 568A361152;
        Mon, 12 Jul 2021 06:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071957;
        bh=7/pLmnF+YKhsWzr6da5C8DpZEqIIGHYTU3pVCkbcCSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lrdSp4TwaSP4Y1HVgTJoMBdeQlCZ7K9zY61twBKYj0LDSzTHg4ddtpalQ0Fpbngss
         e/EhCCZU8Khuwcb7RdHlEGUWoc26yYE7zF3SGBD5QxZ7wgK5EfS7vb8qT87qdCOToq
         zVn6IiPEqPrvX1KHgvXo9JdSeZNvZ7+x/3vpb3A4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-hwmon@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 250/593] hwmon: (lm70) Use device_get_match_data()
Date:   Mon, 12 Jul 2021 08:06:50 +0200
Message-Id: <20210712060910.433390433@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 6e09d75513d2670b7ab91ab3584fc5bcf2675a75 ]

Use the more modern API to get the match data out of the of match table.
This saves some code, lines, and nicely avoids referencing the match
table when it is undefined with configurations where CONFIG_OF=n.

Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: <linux-hwmon@vger.kernel.org>
[robh: rework to use device_get_match_data()]
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm70.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/hwmon/lm70.c b/drivers/hwmon/lm70.c
index ae2b84263a44..40eab3349904 100644
--- a/drivers/hwmon/lm70.c
+++ b/drivers/hwmon/lm70.c
@@ -22,9 +22,9 @@
 #include <linux/hwmon.h>
 #include <linux/mutex.h>
 #include <linux/mod_devicetable.h>
+#include <linux/property.h>
 #include <linux/spi/spi.h>
 #include <linux/slab.h>
-#include <linux/of_device.h>
 #include <linux/acpi.h>
 
 #define DRVNAME		"lm70"
@@ -173,25 +173,15 @@ MODULE_DEVICE_TABLE(acpi, lm70_acpi_ids);
 
 static int lm70_probe(struct spi_device *spi)
 {
-	const struct of_device_id *of_match;
 	struct device *hwmon_dev;
 	struct lm70 *p_lm70;
 	int chip;
 
-	of_match = of_match_device(lm70_of_ids, &spi->dev);
-	if (of_match)
-		chip = (int)(uintptr_t)of_match->data;
-	else {
-#ifdef CONFIG_ACPI
-		const struct acpi_device_id *acpi_match;
+	if (dev_fwnode(&spi->dev))
+		chip = (int)(uintptr_t)device_get_match_data(&spi->dev);
+	else
+		chip = spi_get_device_id(spi)->driver_data;
 
-		acpi_match = acpi_match_device(lm70_acpi_ids, &spi->dev);
-		if (acpi_match)
-			chip = (int)(uintptr_t)acpi_match->driver_data;
-		else
-#endif
-			chip = spi_get_device_id(spi)->driver_data;
-	}
 
 	/* signaling is SPI_MODE_0 */
 	if (spi->mode & (SPI_CPOL | SPI_CPHA))
-- 
2.30.2




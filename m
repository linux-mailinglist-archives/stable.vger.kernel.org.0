Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6C53CDB78
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244753AbhGSOnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245308AbhGSOiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:38:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6989B6023D;
        Mon, 19 Jul 2021 15:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707870;
        bh=sX/1dpxLfrkwkd8GfgqXXons5CRaM2BzMnnGYZmHzvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QHeIj52/0VX4HDSTkR8ihBkV0n7LYNGI6IN5/3MN986Rvr5SJfcqxBRDcQuJ5q5Zv
         oOuSNa7TsVBF9PBvToxXAMil099uVVOxR3dsnK4ot4wKFdpQyogPyLDpj9/0f8Yt4B
         fbWiBQrmw+V0bxhJaDvgqZMlMnQxeLbYJWxGiuc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 089/315] hwmon: (max31722) Remove non-standard ACPI device IDs
Date:   Mon, 19 Jul 2021 16:49:38 +0200
Message-Id: <20210719144945.798186605@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 97387c2f06bcfd79d04a848d35517b32ee6dca7c ]

Valid Maxim Integrated ACPI device IDs would start with MXIM,
not with MAX1. On top of that, ACPI device IDs reflecting chip names
are almost always invalid.

Remove the invalid ACPI IDs.

Fixes: 04e1e70afec6 ("hwmon: (max31722) Add support for MAX31722/MAX31723 temperature sensors")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max31722.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/hwmon/max31722.c b/drivers/hwmon/max31722.c
index 30a100e70a0d..877c3d7dca01 100644
--- a/drivers/hwmon/max31722.c
+++ b/drivers/hwmon/max31722.c
@@ -9,7 +9,6 @@
  * directory of this archive for more details.
  */
 
-#include <linux/acpi.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/kernel.h>
@@ -138,20 +137,12 @@ static const struct spi_device_id max31722_spi_id[] = {
 	{"max31723", 0},
 	{}
 };
-
-static const struct acpi_device_id __maybe_unused max31722_acpi_id[] = {
-	{"MAX31722", 0},
-	{"MAX31723", 0},
-	{}
-};
-
 MODULE_DEVICE_TABLE(spi, max31722_spi_id);
 
 static struct spi_driver max31722_driver = {
 	.driver = {
 		.name = "max31722",
 		.pm = &max31722_pm_ops,
-		.acpi_match_table = ACPI_PTR(max31722_acpi_id),
 	},
 	.probe =            max31722_probe,
 	.remove =           max31722_remove,
-- 
2.30.2




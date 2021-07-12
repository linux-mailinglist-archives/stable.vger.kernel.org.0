Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1C93C4977
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbhGLGpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237596AbhGLGnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:43:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0176461154;
        Mon, 12 Jul 2021 06:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071962;
        bh=4ZFQWM60tEvQKLbT6TdHu5+XbApjP44VhT8H+V9pRf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9ioXfW+djpivqrWSJ67RaP/iDY2wigDEPHCC7RVVynsuQudwlzdUov8sASMlCVqd
         ICYGtgDQYFeNFlHzu9SeCFvzze464PETUAfKJhHTarlKC2yjy9O4Mo+C6PeI/Xsn0w
         N3GW0lH52I9ZfjUwcAKG3qH0i5g5GSZ36YoY0vLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 252/593] hwmon: (max31722) Remove non-standard ACPI device IDs
Date:   Mon, 12 Jul 2021 08:06:52 +0200
Message-Id: <20210712060910.662239034@linuxfoundation.org>
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
index 062eceb7be0d..613338cbcb17 100644
--- a/drivers/hwmon/max31722.c
+++ b/drivers/hwmon/max31722.c
@@ -6,7 +6,6 @@
  * Copyright (c) 2016, Intel Corporation.
  */
 
-#include <linux/acpi.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/kernel.h>
@@ -133,20 +132,12 @@ static const struct spi_device_id max31722_spi_id[] = {
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




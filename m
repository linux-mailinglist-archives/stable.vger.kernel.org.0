Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD0BBA635
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391514AbfIVSsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391522AbfIVSsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:48:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FBA5208C2;
        Sun, 22 Sep 2019 18:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178098;
        bh=MoJuAFD5H01r8aUKRg6WQ0qWyaX5xkkJmQOMh7mNsM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CK9PpmrmASZEHs1lRI3pFS3s3m9uHshvE542xD+koYXLrCcquOpIrL6K1T1odurVt
         vSI5Lo5vsBgU0C7Qor2GNi8VETpHW8cC/NHBppiQoDXo206ZKQYsZJ6RUwPsiohnd/
         srVunzkHg1yqTcdtRgf+HPz4C3IGmC2zQGvzmLuk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Shenran <shenran268@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 161/203] hwmon: (acpi_power_meter) Change log level for 'unsafe software power cap'
Date:   Sun, 22 Sep 2019 14:43:07 -0400
Message-Id: <20190922184350.30563-161-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Shenran <shenran268@gmail.com>

[ Upstream commit 6e4d91aa071810deac2cd052161aefb376ecf04e ]

At boot time, the acpi_power_meter driver logs the following error level
message: "Ignoring unsafe software power cap". Having read about it from
a few sources, it seems that the error message can be quite misleading.

While the message can imply that Linux is ignoring the fact that the
system is operating in potentially dangerous conditions, the truth is
the driver found an ACPI_PMC object that supports software power
capping. The driver simply decides not to use it, perhaps because it
doesn't support the object.

The best solution is probably changing the log level from error to warning.
All sources I have found, regarding the error, have downplayed its
significance. There is not much of a reason for it to be on error level,
while causing potential confusions or misinterpretations.

Signed-off-by: Wang Shenran <shenran268@gmail.com>
Link: https://lore.kernel.org/r/20190724080110.6952-1-shenran268@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/acpi_power_meter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
index 6ba1a08253f0a..4cf25458f0b95 100644
--- a/drivers/hwmon/acpi_power_meter.c
+++ b/drivers/hwmon/acpi_power_meter.c
@@ -681,8 +681,8 @@ static int setup_attrs(struct acpi_power_meter_resource *resource)
 
 	if (resource->caps.flags & POWER_METER_CAN_CAP) {
 		if (!can_cap_in_hardware()) {
-			dev_err(&resource->acpi_dev->dev,
-				"Ignoring unsafe software power cap!\n");
+			dev_warn(&resource->acpi_dev->dev,
+				 "Ignoring unsafe software power cap!\n");
 			goto skip_unsafe_cap;
 		}
 
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B263E3A857B
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhFOPzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232748AbhFOPxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:53:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2A7961628;
        Tue, 15 Jun 2021 15:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772238;
        bh=wRJuFAUKBN9IqlvNRNlL4iFilXRpZrVKLPOlZFTk0FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXftWo5o97UrdZYywcDN0ApevbV4s46Pe1ofXWhUWbluQMDYZNWsL0BE80IBYUOU4
         DRnWo41oYDOqxBnsS0qMYaUqjI3RTBCp/uE8ckiZZmB/Zo3twjyd6aXoURdSepCpvk
         wXlkvMYNrN8/xMigJ0RxJKpZ6+ZU+kV0IRJivJgO+T2xxsKr8ydCj6wjEUwGCw5wp0
         FhH5rP4vMG54gXC47TPC1Q+ap6PSARTRrEs1jW7accwBSDc9oPjatBcGbRszZ7sNDW
         x6MQaaJctmGF4lgPMQTxcSZkeBcTjUmAayVvmbgJ3JbxpfbexWYl3JXlR6fRWBsc7/
         /8349t8+NlMPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Riwen Lu <luriwen@kylinos.cn>, Xin Chen <chenxin@kylinos.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 8/8] hwmon: (scpi-hwmon) shows the negative temperature properly
Date:   Tue, 15 Jun 2021 11:50:27 -0400
Message-Id: <20210615155027.63048-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615155027.63048-1-sashal@kernel.org>
References: <20210615155027.63048-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riwen Lu <luriwen@kylinos.cn>

[ Upstream commit 78d13552346289bad4a9bf8eabb5eec5e5a321a5 ]

The scpi hwmon shows the sub-zero temperature in an unsigned integer,
which would confuse the users when the machine works in low temperature
environment. This shows the sub-zero temperature in an signed value and
users can get it properly from sensors.

Signed-off-by: Riwen Lu <luriwen@kylinos.cn>
Tested-by: Xin Chen <chenxin@kylinos.cn>
Link: https://lore.kernel.org/r/20210604030959.736379-1-luriwen@kylinos.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/scpi-hwmon.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hwmon/scpi-hwmon.c b/drivers/hwmon/scpi-hwmon.c
index 7e49da50bc69..562f3e287297 100644
--- a/drivers/hwmon/scpi-hwmon.c
+++ b/drivers/hwmon/scpi-hwmon.c
@@ -107,6 +107,15 @@ scpi_show_sensor(struct device *dev, struct device_attribute *attr, char *buf)
 
 	scpi_scale_reading(&value, sensor);
 
+	/*
+	 * Temperature sensor values are treated as signed values based on
+	 * observation even though that is not explicitly specified, and
+	 * because an unsigned u64 temperature does not really make practical
+	 * sense especially when the temperature is below zero degrees Celsius.
+	 */
+	if (sensor->info.class == TEMPERATURE)
+		return sprintf(buf, "%lld\n", (s64)value);
+
 	return sprintf(buf, "%llu\n", value);
 }
 
-- 
2.30.2


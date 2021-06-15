Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539583A84F1
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhFOPwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231992AbhFOPvu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09FFC6148E;
        Tue, 15 Jun 2021 15:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772185;
        bh=4N5XB1kMClR4uHWK6xi+bP3P4je3OwE/wcElNSnGzR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjCg3pDFyFqxulMyHHREhpDhhSEQDs8zRH4ELML63yLVY3n8c2anjmebE2R+O3sLX
         4nkMA3U1LJJ2d45RB2/HABxkG+KLtyIFbBUVw2woBa5jG0+9eAyorP7BZ9EB4+5SC7
         Rv9GjOoydx5SZ5dBM5NeKYakcmFdIa9Fi6rzulchV9mlfnIyYUUR0bO1BtDnqb6ipQ
         gCSEVJiTCgWrksaL83rCe35IYweCKPafEF/zEtwqtAlio32T3IWzsW99FdY2C4NLO5
         j+wACulERn+Hy6ZDXRMIttE8SkDE7qEc6ykMY0bQg49XhSfsseOKnTCWZfDO9UHWaO
         XoARGyuCrXzZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Riwen Lu <luriwen@kylinos.cn>, Xin Chen <chenxin@kylinos.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 29/30] hwmon: (scpi-hwmon) shows the negative temperature properly
Date:   Tue, 15 Jun 2021 11:49:06 -0400
Message-Id: <20210615154908.62388-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154908.62388-1-sashal@kernel.org>
References: <20210615154908.62388-1-sashal@kernel.org>
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
index 25aac40f2764..919877970ae3 100644
--- a/drivers/hwmon/scpi-hwmon.c
+++ b/drivers/hwmon/scpi-hwmon.c
@@ -99,6 +99,15 @@ scpi_show_sensor(struct device *dev, struct device_attribute *attr, char *buf)
 
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


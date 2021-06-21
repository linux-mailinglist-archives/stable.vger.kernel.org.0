Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96C93AEDA9
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhFUQV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231444AbhFUQUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:20:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84FC361206;
        Mon, 21 Jun 2021 16:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292321;
        bh=4N5XB1kMClR4uHWK6xi+bP3P4je3OwE/wcElNSnGzR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1Q5tE8Rv+n8/pTHSpDehC04Z1PPb6Pny/b6lThHh9D9BVYAGsrcx3HLPtYmWo90+
         9NVVUnFXUI3nwP66gb9+rZ9M6MdkkvamsvA7WHxGXwdaJ+dpzk0Qr08pDLI0pGe4yX
         eUgRYHKNjqbKuOvmpMu7PdPWsaAfaORKmjNLCzCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riwen Lu <luriwen@kylinos.cn>,
        Xin Chen <chenxin@kylinos.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 48/90] hwmon: (scpi-hwmon) shows the negative temperature properly
Date:   Mon, 21 Jun 2021 18:15:23 +0200
Message-Id: <20210621154905.760406513@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




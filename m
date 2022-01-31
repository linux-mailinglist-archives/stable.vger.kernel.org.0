Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E595E4A4403
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359713AbiAaLZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:25:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56172 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377819AbiAaLX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:23:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44A5161257;
        Mon, 31 Jan 2022 11:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27224C340E8;
        Mon, 31 Jan 2022 11:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628205;
        bh=02YNfxBTAXGk1kudiryNLknHRfDdaEviTnNWVcDeb3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gIcsMstJ2VHvd6mtRxJRnEpQ5v3htCjmaSreaE1lLSAsv0urXSppQAl6PQCmc5/b5
         2H2W7g1tivP2IYpEuTK2V5At8kDkyrCvel3Kk8GaI8/HNiS7ZIzns/7clTUSovCIW6
         Kio9zqnazAJ89PougbHh0eTB9svACzhlFQ/3lbrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 158/200] hwmon: (lm90) Fix sysfs and udev notifications
Date:   Mon, 31 Jan 2022 11:57:01 +0100
Message-Id: <20220131105238.871005763@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit d379880d9adb9f1ada3f1266aa49ea2561328e08 ]

sysfs and udev notifications need to be sent to the _alarm
attributes, not to the value attributes.

Fixes: 94dbd23ed88c ("hwmon: (lm90) Use hwmon_notify_event()")
Cc: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm90.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index ba01127c1deb1..1c9493c708132 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -1808,22 +1808,22 @@ static bool lm90_is_tripped(struct i2c_client *client, u16 *status)
 
 	if (st & LM90_STATUS_LLOW)
 		hwmon_notify_event(data->hwmon_dev, hwmon_temp,
-				   hwmon_temp_min, 0);
+				   hwmon_temp_min_alarm, 0);
 	if (st & LM90_STATUS_RLOW)
 		hwmon_notify_event(data->hwmon_dev, hwmon_temp,
-				   hwmon_temp_min, 1);
+				   hwmon_temp_min_alarm, 1);
 	if (st2 & MAX6696_STATUS2_R2LOW)
 		hwmon_notify_event(data->hwmon_dev, hwmon_temp,
-				   hwmon_temp_min, 2);
+				   hwmon_temp_min_alarm, 2);
 	if (st & LM90_STATUS_LHIGH)
 		hwmon_notify_event(data->hwmon_dev, hwmon_temp,
-				   hwmon_temp_max, 0);
+				   hwmon_temp_max_alarm, 0);
 	if (st & LM90_STATUS_RHIGH)
 		hwmon_notify_event(data->hwmon_dev, hwmon_temp,
-				   hwmon_temp_max, 1);
+				   hwmon_temp_max_alarm, 1);
 	if (st2 & MAX6696_STATUS2_R2HIGH)
 		hwmon_notify_event(data->hwmon_dev, hwmon_temp,
-				   hwmon_temp_max, 2);
+				   hwmon_temp_max_alarm, 2);
 
 	return true;
 }
-- 
2.34.1




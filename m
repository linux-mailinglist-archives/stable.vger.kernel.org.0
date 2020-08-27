Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB92254BF5
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 19:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgH0RUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 13:20:38 -0400
Received: from lists.gateworks.com ([108.161.130.12]:59087 "EHLO
        lists.gateworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgH0RUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 13:20:37 -0400
Received: from 068-189-091-139.biz.spectrum.com ([68.189.91.139] helo=tharvey.pdc.gateworks.com)
        by lists.gateworks.com with esmtp (Exim 4.82)
        (envelope-from <tharvey@gateworks.com>)
        id 1kBLeK-0002tX-Lt; Thu, 27 Aug 2020 17:25:20 +0000
From:   Tim Harvey <tharvey@gateworks.com>
To:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     Robert Jones <rjones@gateworks.com>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>,
        stable@vger.kernel.org
Subject: [PATCH] hwmon: gsc-hwmon: scale temperature to millidegrees
Date:   Thu, 27 Aug 2020 10:20:24 -0700
Message-Id: <1598548824-16898-1-git-send-email-tharvey@gateworks.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The GSC registers report temperature in decidegrees celcius so we
need to scale it to represent the hwmon sysfs API of millidegrees.

Cc: stable@vger.kernel.org
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 drivers/hwmon/gsc-hwmon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/gsc-hwmon.c b/drivers/hwmon/gsc-hwmon.c
index 3dfe2ca..c6d4567 100644
--- a/drivers/hwmon/gsc-hwmon.c
+++ b/drivers/hwmon/gsc-hwmon.c
@@ -172,6 +172,7 @@ gsc_hwmon_read(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 	case mode_temperature:
 		if (tmp > 0x8000)
 			tmp -= 0xffff;
+		tmp *= 100; /* convert to millidegrees celsius */
 		break;
 	case mode_voltage_raw:
 		tmp = clamp_val(tmp, 0, BIT(GSC_HWMON_RESOLUTION));
-- 
2.7.4


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA33850881
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbfFXKSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729770AbfFXKQ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:16:27 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF272208E3;
        Mon, 24 Jun 2019 10:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371387;
        bh=ZWzPHxVYO6d7ILI+35xWNGfP9V6kWW0cbdaUNlzXlDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjHDuDS5q969CBYr7xVYm6kH6H3AKJQC1ehb8wq3Gi2hejFNlppgwQWS1cuMeM9wM
         DnDbXsOhCne9gVjLVxfg8veoSOPvBXWFZOAXhRuDo5UCtSOxMGx3hjCRl/D+aNivUh
         U2qpDBJl5avr5SUIuXfIpk/t8jclDDHp77rf6KF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-hwmon@vger.kernel.org, Eduardo Valentin <eduval@amazon.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 085/121] hwmon: (core) add thermal sensors only if dev->of_node is present
Date:   Mon, 24 Jun 2019 17:56:57 +0800
Message-Id: <20190624092325.180202592@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c41dd48e21fae3e55b3670ccf2eb562fc1f6a67d ]

Drivers may register to hwmon and request for also registering
with the thermal subsystem (HWMON_C_REGISTER_TZ). However,
some of these driver, e.g. marvell phy, may be probed from
Device Tree or being dynamically allocated, and in the later
case, it will not have a dev->of_node entry.

Registering with hwmon without the dev->of_node may result in
different outcomes depending on the device tree, which may
be a bit misleading. If the device tree blob has no 'thermal-zones'
node, the *hwmon_device_register*() family functions are going
to gracefully succeed, because of-thermal,
*thermal_zone_of_sensor_register() return -ENODEV in this case,
and the hwmon error path handles this error code as success to
cover for the case where CONFIG_THERMAL_OF is not set.
However, if the device tree blob has the 'thermal-zones'
entry, the *hwmon_device_register*() will always fail on callers
with no dev->of_node, propagating -EINVAL.

If dev->of_node is not present, calling of-thermal does not
make sense. For this reason, this patch checks first if the
device has a of_node before going over the process of registering
with the thermal subsystem of-thermal interface. And in this case,
when a caller of *hwmon_device_register*() with HWMON_C_REGISTER_TZ
and no dev->of_node will still register with hwmon, but not with
the thermal subsystem. If all the hwmon part bits are in place,
the registration will succeed.

Fixes: d560168b5d0f ("hwmon: (core) New hwmon registration API")
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: linux-hwmon@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduval@amazon.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index c22dc1e07911..c38883f748a1 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -633,7 +633,7 @@ __hwmon_device_register(struct device *dev, const char *name, void *drvdata,
 	if (err)
 		goto free_hwmon;
 
-	if (dev && chip && chip->ops->read &&
+	if (dev && dev->of_node && chip && chip->ops->read &&
 	    chip->info[0]->type == hwmon_chip &&
 	    (chip->info[0]->config[0] & HWMON_C_REGISTER_TZ)) {
 		const struct hwmon_channel_info **info = chip->info;
-- 
2.20.1




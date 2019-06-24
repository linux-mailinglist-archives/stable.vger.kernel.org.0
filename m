Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8645080F
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbfFXKFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729791AbfFXKFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:05:12 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33540205ED;
        Mon, 24 Jun 2019 10:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370711;
        bh=HTLPW14FV82/Pk42KIxwqTEOtpQcj/hntKth0Q7kJOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySkq3WfM9MuU1Grv8u8HZHDV4AjlY39Lm20iFKDJHGjhlOtOM9eZChi/FBD67auWR
         aDV60dPHIKQt8/2fc/fOlb3KNIrn1SjZje/mnc9Z3EpFFZeWEkt77tEVZoBHpde9iJ
         XjXsaqDTdb1FqQwjad6dBRY/12v/F9mJLhyjacvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-hwmon@vger.kernel.org, Eduardo Valentin <eduval@amazon.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 64/90] hwmon: (core) add thermal sensors only if dev->of_node is present
Date:   Mon, 24 Jun 2019 17:56:54 +0800
Message-Id: <20190624092318.284925383@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
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
index fcdbac4a56e3..6b3559f58b67 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -619,7 +619,7 @@ __hwmon_device_register(struct device *dev, const char *name, void *drvdata,
 	if (err)
 		goto free_hwmon;
 
-	if (dev && chip && chip->ops->read &&
+	if (dev && dev->of_node && chip && chip->ops->read &&
 	    chip->info[0]->type == hwmon_chip &&
 	    (chip->info[0]->config[0] & HWMON_C_REGISTER_TZ)) {
 		const struct hwmon_channel_info **info = chip->info;
-- 
2.20.1




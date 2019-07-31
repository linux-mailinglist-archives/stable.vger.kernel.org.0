Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D98697BC79
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbfGaJCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:02:45 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:38725 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726699AbfGaJCo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 05:02:44 -0400
X-IronPort-AV: E=Sophos;i="5.64,329,1559487600"; 
   d="scan'208";a="22937243"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 31 Jul 2019 18:02:42 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id F4236421A7EC;
        Wed, 31 Jul 2019 18:02:41 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     kishon@ti.com
Cc:     pavel@denx.de, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH] phy: renesas: rcar-gen3-usb2: Fix sysfs interface of "role"
Date:   Wed, 31 Jul 2019 18:01:29 +0900
Message-Id: <1564563689-25863-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the role_store() uses strncmp(), it's possible to refer
out-of-memory if the sysfs data size is smaller than strlen("host").
This patch fixes it by using sysfs_streq() instead of strncmp().

Reported-by: Pavel Machek <pavel@denx.de>
Fixes: 9bb86777fb71 ("phy: rcar-gen3-usb2: add sysfs for usb role swap")
Cc: <stable@vger.kernel.org> # v4.10+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 Just a record. The role_store() doesn't need to check the count because
 the sysfs_streq() checks the first argument is NULL or not.

 On "if (sysfs_streq(buf, "host"))"
  Example 1: echo ho > role
  --> In this case, the count is 3 and the buf has "ho" + NULL.
      So, the third character differs between NULL and 's'.

  Example 2: echo host-is-not-used > role
  --> In this case, the count is 17 and the buf has "host-is-not-used" + NULL.
      So, the fifth character differs between '-' and NULL.

 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 1322185..cc18970 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
+#include <linux/string.h>
 #include <linux/usb/of.h>
 #include <linux/workqueue.h>
 
@@ -317,9 +318,9 @@ static ssize_t role_store(struct device *dev, struct device_attribute *attr,
 	if (!ch->is_otg_channel || !rcar_gen3_is_any_rphy_initialized(ch))
 		return -EIO;
 
-	if (!strncmp(buf, "host", strlen("host")))
+	if (sysfs_streq(buf, "host"))
 		new_mode = PHY_MODE_USB_HOST;
-	else if (!strncmp(buf, "peripheral", strlen("peripheral")))
+	else if (sysfs_streq(buf, "peripheral"))
 		new_mode = PHY_MODE_USB_DEVICE;
 	else
 		return -EINVAL;
-- 
2.7.4


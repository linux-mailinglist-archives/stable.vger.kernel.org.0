Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F663CDCA5
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 09:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfJGHzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 03:55:13 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:34805 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727028AbfJGHzN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 03:55:13 -0400
X-IronPort-AV: E=Sophos;i="5.67,265,1566831600"; 
   d="scan'208";a="28464183"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 07 Oct 2019 16:55:11 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 18114400A107;
        Mon,  7 Oct 2019 16:55:11 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     kishon@ti.com
Cc:     linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v2] phy: renesas: rcar-gen3-usb2: Fix sysfs interface of "role"
Date:   Mon,  7 Oct 2019 16:55:10 +0900
Message-Id: <1570434910-15343-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
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
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Pavel Machek <pavel@denx.de>
---
 Changes from v1:
 - Rebase on v5.4-rc2.
 - Add Reviewed-by and Acked-by tags.
 https://patchwork.kernel.org/patch/11067371/


 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index b7f6b13..6fd1390 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
+#include <linux/string.h>
 #include <linux/usb/of.h>
 #include <linux/workqueue.h>
 
@@ -320,9 +321,9 @@ static ssize_t role_store(struct device *dev, struct device_attribute *attr,
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


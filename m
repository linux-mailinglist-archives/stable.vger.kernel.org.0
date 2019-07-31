Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB9AD7BE29
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 12:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbfGaKQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 06:16:57 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:55334 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725914AbfGaKQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 06:16:57 -0400
X-IronPort-AV: E=Sophos;i="5.64,329,1559487600"; 
   d="scan'208";a="22944828"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 31 Jul 2019 19:16:55 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 59497422844D;
        Wed, 31 Jul 2019 19:16:55 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     balbi@kernel.org
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH] usb: gadget: udc: renesas_usb3: Fix sysfs interface of "role"
Date:   Wed, 31 Jul 2019 19:15:43 +0900
Message-Id: <1564568143-3371-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the role_store() uses strncmp(), it's possible to refer
out-of-memory if the sysfs data size is smaller than strlen("host").
This patch fixes it by using sysfs_streq() instead of strncmp().

Fixes: cc995c9ec118 ("usb: gadget: udc: renesas_usb3: add support for usb role swap")
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/usb/gadget/udc/renesas_usb3.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/renesas_usb3.c b/drivers/usb/gadget/udc/renesas_usb3.c
index 7dc2485..b6eec81 100644
--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -19,6 +19,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/sys_soc.h>
 #include <linux/uaccess.h>
 #include <linux/usb/ch9.h>
@@ -2378,9 +2379,9 @@ static ssize_t role_store(struct device *dev, struct device_attribute *attr,
 	if (usb3->forced_b_device)
 		return -EBUSY;
 
-	if (!strncmp(buf, "host", strlen("host")))
+	if (sysfs_streq(buf, "host"))
 		new_mode_is_host = true;
-	else if (!strncmp(buf, "peripheral", strlen("peripheral")))
+	else if (sysfs_streq(buf, "peripheral"))
 		new_mode_is_host = false;
 	else
 		return -EINVAL;
-- 
2.7.4


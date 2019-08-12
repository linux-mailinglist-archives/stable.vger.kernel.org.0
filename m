Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 000B38A010
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 15:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfHLNuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 09:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbfHLNuU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Aug 2019 09:50:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FE1B20665;
        Mon, 12 Aug 2019 13:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565617819;
        bh=+Ao2T+JW9I6b1V3DbH8L0V6nvIU+r21oCDVsEQiKJlM=;
        h=Subject:To:From:Date:From;
        b=Rrd3OFF7pmHWLHfpWVJVEZYeDtTnyW7556Kd48XuUUQsdpxNaAuPGkIWjXcol/adZ
         T+acpsIeSREmiiKaCUt9c9YFUUiyhoCYAgknTImR9ATlPtapcWShUrG5pSm2b8YGtT
         MuwUvQrH75gLDkr6BrwlwF9BmcQozDegiCgWrpoU=
Subject: patch "usb: gadget: udc: renesas_usb3: Fix sysfs interface of "role"" added to usb-linus
To:     yoshihiro.shimoda.uh@renesas.com, felipe.balbi@linux.intel.com,
        geert+renesas@glider.be, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 12 Aug 2019 15:50:17 +0200
Message-ID: <15656178172162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: udc: renesas_usb3: Fix sysfs interface of "role"

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5dac665cf403967bb79a7aeb8c182a621fe617ff Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Wed, 31 Jul 2019 19:15:43 +0900
Subject: usb: gadget: udc: renesas_usb3: Fix sysfs interface of "role"

Since the role_store() uses strncmp(), it's possible to refer
out-of-memory if the sysfs data size is smaller than strlen("host").
This patch fixes it by using sysfs_streq() instead of strncmp().

Fixes: cc995c9ec118 ("usb: gadget: udc: renesas_usb3: add support for usb role swap")
Cc: <stable@vger.kernel.org> # v4.12+
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/usb/gadget/udc/renesas_usb3.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/renesas_usb3.c b/drivers/usb/gadget/udc/renesas_usb3.c
index 87062d22134d..1f4c3fbd1df8 100644
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
@@ -2450,9 +2451,9 @@ static ssize_t role_store(struct device *dev, struct device_attribute *attr,
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
2.22.0



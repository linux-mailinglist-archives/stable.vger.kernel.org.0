Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD3EF2911
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 09:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfKGI2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 03:28:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbfKGI2H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 03:28:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91A8721D79;
        Thu,  7 Nov 2019 08:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573115285;
        bh=yqaMvMxSMQCzbeOzaUjSweC5ljFECWmDgQalN35zPW0=;
        h=Subject:To:From:Date:From;
        b=Gfk6bok7khB0GTvmCxj/EAH8H3VlUyb5e9k3VnLNqezoXwmn5553SjUZUx0KQQ9ib
         lBfnueptSedDFi3jjp0upW/z8WgYlUmIEwPEHCUk6imOBWb7NOwVsw8s/bFWeBYPZK
         U0McIxXfKhC6FKUjKKt0JjHfmLu40m0Vbx0D3ioc=
Subject: patch "phy: renesas: rcar-gen3-usb2: Fix sysfs interface of "role"" added to char-misc-testing
To:     yoshihiro.shimoda.uh@renesas.com, geert+renesas@glider.be,
        kishon@ti.com, pavel@denx.de, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 07 Nov 2019 09:27:34 +0100
Message-ID: <157311525483191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    phy: renesas: rcar-gen3-usb2: Fix sysfs interface of "role"

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 4bd5ead82d4b877ebe41daf95f28cda53205b039 Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Mon, 7 Oct 2019 16:55:10 +0900
Subject: phy: renesas: rcar-gen3-usb2: Fix sysfs interface of "role"

Since the role_store() uses strncmp(), it's possible to refer
out-of-memory if the sysfs data size is smaller than strlen("host").
This patch fixes it by using sysfs_streq() instead of strncmp().

Reported-by: Pavel Machek <pavel@denx.de>
Fixes: 9bb86777fb71 ("phy: rcar-gen3-usb2: add sysfs for usb role swap")
Cc: <stable@vger.kernel.org> # v4.10+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 49ec67d46ccc..bfb22f868857 100644
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
2.23.0



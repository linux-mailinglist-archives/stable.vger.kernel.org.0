Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C10A5B57C
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 09:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfGAHE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 03:04:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfGAHE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 03:04:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0101C2054F;
        Mon,  1 Jul 2019 07:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561964696;
        bh=mEl2t7JKsYxPGeJoEocGa6M0DuGwS1DH7mC2X5mb6K4=;
        h=Subject:To:From:Date:From;
        b=d0+yEeIUrPZhY0Tn3DioSmz4+Mkw1AUuamy8NBPdgkFysYML2Hf0TeFIXYKAds35G
         OB2OQHj+gzWccN0ONrl7o156yHKt++Br3EBGLyOEtd9H0L3aZVWZabQM46oxWbLn0w
         nXEzdbmC7i+x5TCEK9Or4IsAG1yZ0XuulLC9vqNY=
Subject: patch "staging: wilc1000: fix error path cleanup in wilc_wlan_initialize()" added to staging-testing
To:     ajay.kathat@microchip.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Jul 2019 09:04:37 +0200
Message-ID: <15619646771196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: wilc1000: fix error path cleanup in wilc_wlan_initialize()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 6419f818ababebc1116fb2d0e220bd4fe835d0e3 Mon Sep 17 00:00:00 2001
From: Ajay Singh <ajay.kathat@microchip.com>
Date: Wed, 26 Jun 2019 12:40:48 +0000
Subject: staging: wilc1000: fix error path cleanup in wilc_wlan_initialize()

For the error path in wilc_wlan_initialize(), the resources are not
cleanup in the correct order. Reverted the previous changes and use the
correct order to free during error condition.

Fixes: b46d68825c2d ("staging: wilc1000: remove COMPLEMENT_BOOT")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/wilc1000/wilc_netdev.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_netdev.c b/drivers/staging/wilc1000/wilc_netdev.c
index c4efec277255..0e0a4eec5486 100644
--- a/drivers/staging/wilc1000/wilc_netdev.c
+++ b/drivers/staging/wilc1000/wilc_netdev.c
@@ -530,17 +530,17 @@ static int wilc_wlan_initialize(struct net_device *dev, struct wilc_vif *vif)
 			goto fail_locks;
 		}
 
-		if (wl->gpio_irq && init_irq(dev)) {
-			ret = -EIO;
-			goto fail_locks;
-		}
-
 		ret = wlan_initialize_threads(dev);
 		if (ret < 0) {
 			ret = -EIO;
 			goto fail_wilc_wlan;
 		}
 
+		if (wl->gpio_irq && init_irq(dev)) {
+			ret = -EIO;
+			goto fail_threads;
+		}
+
 		if (!wl->dev_irq_num &&
 		    wl->hif_func->enable_interrupt &&
 		    wl->hif_func->enable_interrupt(wl)) {
@@ -596,7 +596,7 @@ static int wilc_wlan_initialize(struct net_device *dev, struct wilc_vif *vif)
 fail_irq_init:
 		if (wl->dev_irq_num)
 			deinit_irq(dev);
-
+fail_threads:
 		wlan_deinitialize_threads(dev);
 fail_wilc_wlan:
 		wilc_wlan_cleanup(dev);
-- 
2.22.0



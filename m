Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422FB4E2942
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238697AbiCUOEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348900AbiCUODI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:03:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925363E5D5;
        Mon, 21 Mar 2022 06:59:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0826B816E1;
        Mon, 21 Mar 2022 13:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010FDC36AE2;
        Mon, 21 Mar 2022 13:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871193;
        bh=tSiYwyvm2o3VzobvOPnZ0wLmRBeQ9/MJTudx/KFTPdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xNILd0gmiWc+zXiEJ8YeKfBidVSY4Dw6oBV8yqXwc4ZzBoGdhYwEdJP7ptPw4PEF1
         jowDOfmLoakdhJRFfiVz0IxRTwmuMHn0Y30/1xyP+9UibedsEFbDisAYZOdKLXXeiF
         HtoZQPVSMwGDy/vGqvyrog2wS/B4B3Ei8XIInnPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 5.10 28/30] smsc95xx: Ignore -ENODEV errors when device is unplugged
Date:   Mon, 21 Mar 2022 14:52:58 +0100
Message-Id: <20220321133220.461577191@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133219.643490199@linuxfoundation.org>
References: <20220321133219.643490199@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

commit c70c453abcbf3ecbaadd4c3236a5119b8da365cf upstream.

According to Documentation/driver-api/usb/URB.rst when a device
is unplugged usb_submit_urb() returns -ENODEV.

This error code propagates all the way up to usbnet_read_cmd() and
usbnet_write_cmd() calls inside the smsc95xx.c driver during
Ethernet cable unplug, unbind or reboot.

This causes the following errors to be shown on reboot, for example:

ci_hdrc ci_hdrc.1: remove, state 1
usb usb2: USB disconnect, device number 1
usb 2-1: USB disconnect, device number 2
usb 2-1.1: USB disconnect, device number 3
smsc95xx 2-1.1:1.0 eth1: unregister 'smsc95xx' usb-ci_hdrc.1-1.1, smsc95xx USB 2.0 Ethernet
smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
smsc95xx 2-1.1:1.0 eth1: hardware isn't capable of remote wakeup
usb 2-1.4: USB disconnect, device number 4
ci_hdrc ci_hdrc.1: USB bus 2 deregistered
ci_hdrc ci_hdrc.0: remove, state 4
usb usb1: USB disconnect, device number 1
ci_hdrc ci_hdrc.0: USB bus 1 deregistered
imx2-wdt 30280000.watchdog: Device shutdown: Expect reboot!
reboot: Restarting system

Ignore the -ENODEV errors inside __smsc95xx_mdio_read() and
__smsc95xx_phy_wait_not_busy() and do not print error messages
when -ENODEV is returned.

Fixes: a049a30fc27c ("net: usb: Correct PHY handling of smsc95xx")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/smsc95xx.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -84,9 +84,10 @@ static int __must_check __smsc95xx_read_
 	ret = fn(dev, USB_VENDOR_REQUEST_READ_REGISTER, USB_DIR_IN
 		 | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 		 0, index, &buf, 4);
-	if (unlikely(ret < 0)) {
-		netdev_warn(dev->net, "Failed to read reg index 0x%08x: %d\n",
-			    index, ret);
+	if (ret < 0) {
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Failed to read reg index 0x%08x: %d\n",
+				    index, ret);
 		return ret;
 	}
 
@@ -116,7 +117,7 @@ static int __must_check __smsc95xx_write
 	ret = fn(dev, USB_VENDOR_REQUEST_WRITE_REGISTER, USB_DIR_OUT
 		 | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 		 0, index, &buf, 4);
-	if (unlikely(ret < 0))
+	if (ret < 0 && ret != -ENODEV)
 		netdev_warn(dev->net, "Failed to write reg index 0x%08x: %d\n",
 			    index, ret);
 
@@ -159,6 +160,9 @@ static int __must_check __smsc95xx_phy_w
 	do {
 		ret = __smsc95xx_read_reg(dev, MII_ADDR, &val, in_pm);
 		if (ret < 0) {
+			/* Ignore -ENODEV error during disconnect() */
+			if (ret == -ENODEV)
+				return 0;
 			netdev_warn(dev->net, "Error reading MII_ACCESS\n");
 			return ret;
 		}
@@ -194,7 +198,8 @@ static int __smsc95xx_mdio_read(struct u
 	addr = mii_address_cmd(phy_id, idx, MII_READ_ | MII_BUSY_);
 	ret = __smsc95xx_write_reg(dev, MII_ADDR, addr, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "Error writing MII_ADDR\n");
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Error writing MII_ADDR\n");
 		goto done;
 	}
 
@@ -206,7 +211,8 @@ static int __smsc95xx_mdio_read(struct u
 
 	ret = __smsc95xx_read_reg(dev, MII_DATA, &val, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "Error reading MII_DATA\n");
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Error reading MII_DATA\n");
 		goto done;
 	}
 
@@ -214,6 +220,10 @@ static int __smsc95xx_mdio_read(struct u
 
 done:
 	mutex_unlock(&dev->phy_mutex);
+
+	/* Ignore -ENODEV error during disconnect() */
+	if (ret == -ENODEV)
+		return 0;
 	return ret;
 }
 
@@ -235,7 +245,8 @@ static void __smsc95xx_mdio_write(struct
 	val = regval;
 	ret = __smsc95xx_write_reg(dev, MII_DATA, val, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "Error writing MII_DATA\n");
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Error writing MII_DATA\n");
 		goto done;
 	}
 
@@ -243,7 +254,8 @@ static void __smsc95xx_mdio_write(struct
 	addr = mii_address_cmd(phy_id, idx, MII_WRITE_ | MII_BUSY_);
 	ret = __smsc95xx_write_reg(dev, MII_ADDR, addr, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "Error writing MII_ADDR\n");
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Error writing MII_ADDR\n");
 		goto done;
 	}
 



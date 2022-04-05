Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A464F3752
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352742AbiDELMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348963AbiDEJsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5A5A5EBC;
        Tue,  5 Apr 2022 02:38:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74962B818F3;
        Tue,  5 Apr 2022 09:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9032C385A2;
        Tue,  5 Apr 2022 09:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151491;
        bh=AEl70rgRIX6ycKBzAnX8mfWMqz7yCVPj6kI/kOyW0y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mge7iQ8QCyDRIV2jZXfIXupON/tfFweNsMxv2r3lH9d+hTn5Zu5woPNebNoJA5tm4
         0bq2qR45lGi22ZTRpKbYt9UxBGVaZdTTy81kGYkSJv32H4dDXt+U8sf4ssImPUY5BZ
         11kzu9xKO6jQomoO4q4nBijOkfofLZKsc7QOeDW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com
Subject: [PATCH 5.15 434/913] net: asix: add proper error handling of usb read errors
Date:   Tue,  5 Apr 2022 09:24:56 +0200
Message-Id: <20220405070352.854721527@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 920a9fa27e7805499cfe78491b36fed2322c02ec ]

Syzbot once again hit uninit value in asix driver. The problem still the
same -- asix_read_cmd() reads less bytes, than was requested by caller.

Since all read requests are performed via asix_read_cmd() let's catch
usb related error there and add __must_check notation to be sure all
callers actually check return value.

So, this patch adds sanity check inside asix_read_cmd(), that simply
checks if bytes read are not less, than was requested and adds missing
error handling of asix_read_cmd() all across the driver code.

Fixes: d9fe64e51114 ("net: asix: Add in_pm parameter")
Reported-and-tested-by: syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/asix.h         |  4 ++--
 drivers/net/usb/asix_common.c  | 19 +++++++++++++------
 drivers/net/usb/asix_devices.c | 21 ++++++++++++++++++---
 3 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index 2a1e31defe71..4334aafab59a 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -192,8 +192,8 @@ extern const struct driver_info ax88172a_info;
 /* ASIX specific flags */
 #define FLAG_EEPROM_MAC		(1UL << 0)  /* init device MAC from eeprom */
 
-int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
-		  u16 size, void *data, int in_pm);
+int __must_check asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
+			       u16 size, void *data, int in_pm);
 
 int asix_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 		   u16 size, void *data, int in_pm);
diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 9aa92076500a..f39188b7717a 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -11,8 +11,8 @@
 
 #define AX_HOST_EN_RETRIES	30
 
-int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
-		  u16 size, void *data, int in_pm)
+int __must_check asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
+			       u16 size, void *data, int in_pm)
 {
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
@@ -27,9 +27,12 @@ int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 	ret = fn(dev, cmd, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 		 value, index, data, size);
 
-	if (unlikely(ret < 0))
+	if (unlikely(ret < size)) {
+		ret = ret < 0 ? ret : -ENODATA;
+
 		netdev_warn(dev->net, "Failed to read reg index 0x%04x: %d\n",
 			    index, ret);
+	}
 
 	return ret;
 }
@@ -79,7 +82,7 @@ static int asix_check_host_enable(struct usbnet *dev, int in_pm)
 				    0, 0, 1, &smsr, in_pm);
 		if (ret == -ENODEV)
 			break;
-		else if (ret < sizeof(smsr))
+		else if (ret < 0)
 			continue;
 		else if (smsr & AX_HOST_EN)
 			break;
@@ -579,8 +582,12 @@ int asix_mdio_read_nopm(struct net_device *netdev, int phy_id, int loc)
 		return ret;
 	}
 
-	asix_read_cmd(dev, AX_CMD_READ_MII_REG, phy_id,
-		      (__u16)loc, 2, &res, 1);
+	ret = asix_read_cmd(dev, AX_CMD_READ_MII_REG, phy_id,
+			    (__u16)loc, 2, &res, 1);
+	if (ret < 0) {
+		mutex_unlock(&dev->phy_mutex);
+		return ret;
+	}
 	asix_set_hw_mii(dev, 1);
 	mutex_unlock(&dev->phy_mutex);
 
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 30821f6a6d7a..bd8f8619ad6f 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -755,7 +755,12 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 	priv->phy_addr = ret;
 	priv->embd_phy = ((priv->phy_addr & 0x1f) == 0x10);
 
-	asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG, 0, 0, 1, &chipcode, 0);
+	ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG, 0, 0, 1, &chipcode, 0);
+	if (ret < 0) {
+		netdev_dbg(dev->net, "Failed to read STATMNGSTS_REG: %d\n", ret);
+		return ret;
+	}
+
 	chipcode &= AX_CHIPCODE_MASK;
 
 	ret = (chipcode == AX_AX88772_CHIPCODE) ? ax88772_hw_reset(dev, 0) :
@@ -920,11 +925,21 @@ static int ax88178_reset(struct usbnet *dev)
 	int gpio0 = 0;
 	u32 phyid;
 
-	asix_read_cmd(dev, AX_CMD_READ_GPIOS, 0, 0, 1, &status, 0);
+	ret = asix_read_cmd(dev, AX_CMD_READ_GPIOS, 0, 0, 1, &status, 0);
+	if (ret < 0) {
+		netdev_dbg(dev->net, "Failed to read GPIOS: %d\n", ret);
+		return ret;
+	}
+
 	netdev_dbg(dev->net, "GPIO Status: 0x%04x\n", status);
 
 	asix_write_cmd(dev, AX_CMD_WRITE_ENABLE, 0, 0, 0, NULL, 0);
-	asix_read_cmd(dev, AX_CMD_READ_EEPROM, 0x0017, 0, 2, &eeprom, 0);
+	ret = asix_read_cmd(dev, AX_CMD_READ_EEPROM, 0x0017, 0, 2, &eeprom, 0);
+	if (ret < 0) {
+		netdev_dbg(dev->net, "Failed to read EEPROM: %d\n", ret);
+		return ret;
+	}
+
 	asix_write_cmd(dev, AX_CMD_WRITE_DISABLE, 0, 0, 0, NULL, 0);
 
 	netdev_dbg(dev->net, "EEPROM index 0x17 is 0x%04x\n", eeprom);
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC25E3E25AB
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhHFIVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243428AbhHFIUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:20:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A0F66120D;
        Fri,  6 Aug 2021 08:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238018;
        bh=4dGRU6wbGefDj45r4umdl1N8zIxJ1aCI5VWDm0LvqpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zPMB08Y+8yYfVk6zAjFL+iD3nqqeqQQnZrdInEd+0B/VzNJ21W9VpHbEC08zk2t3K
         kHygMTgkRxNmPhQFPaU821ZNBevtJrwaGWUzCHwHEyEzNvbtZkBJxDH/Xe9CU129tM
         0q8MPQkhi7YUp6SRyHU1dPIuEO2jKj3IoRcaoxwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 20/35] r8152: Fix a deadlock by doubly PM resume
Date:   Fri,  6 Aug 2021 10:17:03 +0200
Message-Id: <20210806081114.396738543@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 776ac63a986d211286230c4fd70f85390eabedcd ]

r8152 driver sets up the MAC address at reset-resume, while
rtl8152_set_mac_address() has the temporary autopm get/put.  This may
lead to a deadlock as the PM lock has been already taken for the
execution of the runtime PM callback.

This patch adds the workaround to avoid the superfluous autpm when
called from rtl8152_reset_resume().

Link: https://bugzilla.suse.com/show_bug.cgi?id=1186194
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 8dcc55e4a5bc..2cf763b4ea84 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1550,7 +1550,8 @@ static int
 rtl8152_set_speed(struct r8152 *tp, u8 autoneg, u32 speed, u8 duplex,
 		  u32 advertising);
 
-static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
+static int __rtl8152_set_mac_address(struct net_device *netdev, void *p,
+				     bool in_resume)
 {
 	struct r8152 *tp = netdev_priv(netdev);
 	struct sockaddr *addr = p;
@@ -1559,9 +1560,11 @@ static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		goto out1;
 
-	ret = usb_autopm_get_interface(tp->intf);
-	if (ret < 0)
-		goto out1;
+	if (!in_resume) {
+		ret = usb_autopm_get_interface(tp->intf);
+		if (ret < 0)
+			goto out1;
+	}
 
 	mutex_lock(&tp->control);
 
@@ -1573,11 +1576,17 @@ static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
 
 	mutex_unlock(&tp->control);
 
-	usb_autopm_put_interface(tp->intf);
+	if (!in_resume)
+		usb_autopm_put_interface(tp->intf);
 out1:
 	return ret;
 }
 
+static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
+{
+	return __rtl8152_set_mac_address(netdev, p, false);
+}
+
 /* Devices containing proper chips can support a persistent
  * host system provided MAC address.
  * Examples of this are Dell TB15 and Dell WD15 docks
@@ -1696,7 +1705,7 @@ static int determine_ethernet_addr(struct r8152 *tp, struct sockaddr *sa)
 	return ret;
 }
 
-static int set_ethernet_addr(struct r8152 *tp)
+static int set_ethernet_addr(struct r8152 *tp, bool in_resume)
 {
 	struct net_device *dev = tp->netdev;
 	struct sockaddr sa;
@@ -1709,7 +1718,7 @@ static int set_ethernet_addr(struct r8152 *tp)
 	if (tp->version == RTL_VER_01)
 		ether_addr_copy(dev->dev_addr, sa.sa_data);
 	else
-		ret = rtl8152_set_mac_address(dev, &sa);
+		ret = __rtl8152_set_mac_address(dev, &sa, in_resume);
 
 	return ret;
 }
@@ -8442,7 +8451,7 @@ static int rtl8152_reset_resume(struct usb_interface *intf)
 	clear_bit(SELECTIVE_SUSPEND, &tp->flags);
 	tp->rtl_ops.init(tp);
 	queue_delayed_work(system_long_wq, &tp->hw_phy_work, 0);
-	set_ethernet_addr(tp);
+	set_ethernet_addr(tp, true);
 	return rtl8152_resume(intf);
 }
 
@@ -9562,7 +9571,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 	tp->rtl_fw.retry = true;
 #endif
 	queue_delayed_work(system_long_wq, &tp->hw_phy_work, 0);
-	set_ethernet_addr(tp);
+	set_ethernet_addr(tp, false);
 
 	usb_set_intfdata(intf, tp);
 
-- 
2.30.2




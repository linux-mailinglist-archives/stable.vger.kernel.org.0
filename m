Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E922F265FF2
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 15:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgIKNAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 09:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbgIKM6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:58:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 469FE22250;
        Fri, 11 Sep 2020 12:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828925;
        bh=brcKNu2ORnGKULw+kDsMkGQh6xr/uZBWwy3gj7LfanI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R15wBlCPCeK4eXCSlUrinJuQ7DB5cbCTL7xGOT/vA1OX8NtxQasrLf5U7B2icP5cL
         XBl988WtpUwYiRDkcOrAkFG0+1Hgimpc2VlA4tAkQVKrwbkEutx5tk+OjN5GE3W6Zq
         V652JmDZgSnmpWG1WIOhWMi7Z1RPTLeySO+lEQds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 31/62] net: qmi_wwan: should hold RTNL while changing netdev type
Date:   Fri, 11 Sep 2020 14:46:14 +0200
Message-Id: <20200911122503.945511729@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit 6c730080e663b1d629f8aa89348291fbcdc46cd9 ]

The notifier calls were thrown in as a last-minute fix for an
imagined "this device could be part of a bridge" problem. That
revealed a certain lack of locking.  Not to mention testing...

Avoid this splat:

RTNL: assertion failed at net/core/dev.c (1639)
CPU: 0 PID: 4293 Comm: bash Not tainted 4.4.0-rc3+ #358
Hardware name: LENOVO 2776LEG/2776LEG, BIOS 6EET55WW (3.15 ) 12/19/2011
 0000000000000000 ffff8800ad253d60 ffffffff8122f7cf ffff8800ad253d98
 ffff8800ad253d88 ffffffff813833ab 0000000000000002 ffff880230f48560
 ffff880230a12900 ffff8800ad253da0 ffffffff813833da 0000000000000002
Call Trace:
 [<ffffffff8122f7cf>] dump_stack+0x4b/0x63
 [<ffffffff813833ab>] call_netdevice_notifiers_info+0x3d/0x59
 [<ffffffff813833da>] call_netdevice_notifiers+0x13/0x15
 [<ffffffffa09be227>] raw_ip_store+0x81/0x193 [qmi_wwan]
 [<ffffffff8131e149>] dev_attr_store+0x20/0x22
 [<ffffffff811d858b>] sysfs_kf_write+0x49/0x50
 [<ffffffff811d8027>] kernfs_fop_write+0x10a/0x151
 [<ffffffff8117249a>] __vfs_write+0x26/0xa5
 [<ffffffff81085ed4>] ? percpu_down_read+0x53/0x7f
 [<ffffffff81174c9e>] ? __sb_start_write+0x5f/0xb0
 [<ffffffff81174c9e>] ? __sb_start_write+0x5f/0xb0
 [<ffffffff81172c37>] vfs_write+0xa3/0xe7
 [<ffffffff811734ad>] SyS_write+0x50/0x7e
 [<ffffffff8145c517>] entry_SYSCALL_64_fastpath+0x12/0x6f

Fixes: 32f7adf633b9 ("net: qmi_wwan: support "raw IP" mode")
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index d6ecb3ac25b6c..e75e984483bc5 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -16,6 +16,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <linux/mii.h>
+#include <linux/rtnetlink.h>
 #include <linux/usb.h>
 #include <linux/usb/cdc.h>
 #include <linux/usb/usbnet.h>
@@ -92,7 +93,7 @@ static ssize_t raw_ip_store(struct device *d,  struct device_attribute *attr, co
 	struct usbnet *dev = netdev_priv(to_net_dev(d));
 	struct qmi_wwan_state *info = (void *)&dev->data;
 	bool enable;
-	int err;
+	int ret;
 
 	if (strtobool(buf, &enable))
 		return -EINVAL;
@@ -101,18 +102,22 @@ static ssize_t raw_ip_store(struct device *d,  struct device_attribute *attr, co
 	if (enable == (info->flags & QMI_WWAN_FLAG_RAWIP))
 		return len;
 
+	if (!rtnl_trylock())
+		return restart_syscall();
+
 	/* we don't want to modify a running netdev */
 	if (netif_running(dev->net)) {
 		netdev_err(dev->net, "Cannot change a running device\n");
-		return -EBUSY;
+		ret = -EBUSY;
+		goto err;
 	}
 
 	/* let other drivers deny the change */
-	err = call_netdevice_notifiers(NETDEV_PRE_TYPE_CHANGE, dev->net);
-	err = notifier_to_errno(err);
-	if (err) {
+	ret = call_netdevice_notifiers(NETDEV_PRE_TYPE_CHANGE, dev->net);
+	ret = notifier_to_errno(ret);
+	if (ret) {
 		netdev_err(dev->net, "Type change was refused\n");
-		return err;
+		goto err;
 	}
 
 	if (enable)
@@ -121,7 +126,10 @@ static ssize_t raw_ip_store(struct device *d,  struct device_attribute *attr, co
 		info->flags &= ~QMI_WWAN_FLAG_RAWIP;
 	qmi_wwan_netdev_setup(dev->net);
 	call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE, dev->net);
-	return len;
+	ret = len;
+err:
+	rtnl_unlock();
+	return ret;
 }
 
 static DEVICE_ATTR_RW(raw_ip);
-- 
2.25.1




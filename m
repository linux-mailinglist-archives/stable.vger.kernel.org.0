Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BE326666E
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgIKR1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgIKM6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:58:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2C462220D;
        Fri, 11 Sep 2020 12:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828923;
        bh=ErgS5X/gUlqE1NGx7KCtUCChZKuAqXCDjwsW1zl/zAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbA1Ifgis9lU9+crGon2Ry/XFdfXY8LjkrzzwTpg2keATBlQxhIlTauSaSQAMZ6oS
         GKhId1VEQxMYhSuD1wEUZRl/pIq+iRYG1x0l+SAn8UeAcfOkUqcNwjze/xNOHGkbUk
         DLLSnQNciTOObJtBiVfzd3x8nzVfgB99k+9GVFX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 30/62] net: qmi_wwan: support "raw IP" mode
Date:   Fri, 11 Sep 2020 14:46:13 +0200
Message-Id: <20200911122503.897520687@linuxfoundation.org>
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

[ Upstream commit 32f7adf633b9f99ad5089901bc7ebff57704aaa9 ]

QMI wwan devices have traditionally emulated ethernet devices
by default. But they have always had the capability of operating
without any L2 header at all, transmitting and receiving "raw"
IP packets over the USB link.  This firmware feature used to be
configurable through the QMI management protocol.

Traditionally there was no way to verify the firmware mode
without attempting to change it.  And the firmware would often
disallow changes anyway, i.e. due to a session already being
established.  In some cases, this could be a hidden firmware
internal session, completely outside host control.  For these
reasons, sticking with the "well known" default mode was safest.

But newer generations of QMI hardware and firmware have moved
towards defaulting to "raw IP" mode instead, followed by an
increasing number of bugs in the already buggy "802.3" firmware
implementation. At the same time, the QMI management protocol
gained the ability to detect the current mode.  This has enabled
the userspace QMI management application to verify the current
firmware mode without trying to modify it.

Following this development, the latest QMI hardware and firmware
(the MDM9x30 generation) has dropped support for "802.3" mode
entirely. Support for "raw IP" framing in the driver is therefore
necessary for these devices, and to a certain degree to work
around problems with the previous generation,

This patch adds support for "raw IP" framing for QMI devices,
changing the netdev from an ethernet device to an ARPHRD_NONE
p-t-p device when "raw IP" framing is enabled.

The firmware setup is fully delegated to the QMI userspace
management application, through simple tunneling of the QMI
protocol. The driver will therefore not know which mode has been
"negotiated" between firmware and userspace. Allowing userspace
to inform the driver of the result through a sysfs switch is
considered a better alternative than to change the well established
clean delegation of firmware management to userspace.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 98 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 97 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index b8b15deb94bdb..d6ecb3ac25b6c 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -14,6 +14,7 @@
 #include <linux/netdevice.h>
 #include <linux/ethtool.h>
 #include <linux/etherdevice.h>
+#include <linux/if_arp.h>
 #include <linux/mii.h>
 #include <linux/usb.h>
 #include <linux/usb/cdc.h>
@@ -48,11 +49,93 @@
 struct qmi_wwan_state {
 	struct usb_driver *subdriver;
 	atomic_t pmcount;
-	unsigned long unused;
+	unsigned long flags;
 	struct usb_interface *control;
 	struct usb_interface *data;
 };
 
+enum qmi_wwan_flags {
+	QMI_WWAN_FLAG_RAWIP = 1 << 0,
+};
+
+static void qmi_wwan_netdev_setup(struct net_device *net)
+{
+	struct usbnet *dev = netdev_priv(net);
+	struct qmi_wwan_state *info = (void *)&dev->data;
+
+	if (info->flags & QMI_WWAN_FLAG_RAWIP) {
+		net->header_ops      = NULL;  /* No header */
+		net->type            = ARPHRD_NONE;
+		net->hard_header_len = 0;
+		net->addr_len        = 0;
+		net->flags           = IFF_POINTOPOINT | IFF_NOARP | IFF_MULTICAST;
+		netdev_dbg(net, "mode: raw IP\n");
+	} else if (!net->header_ops) { /* don't bother if already set */
+		ether_setup(net);
+		netdev_dbg(net, "mode: Ethernet\n");
+	}
+
+	/* recalculate buffers after changing hard_header_len */
+	usbnet_change_mtu(net, net->mtu);
+}
+
+static ssize_t raw_ip_show(struct device *d, struct device_attribute *attr, char *buf)
+{
+	struct usbnet *dev = netdev_priv(to_net_dev(d));
+	struct qmi_wwan_state *info = (void *)&dev->data;
+
+	return sprintf(buf, "%c\n", info->flags & QMI_WWAN_FLAG_RAWIP ? 'Y' : 'N');
+}
+
+static ssize_t raw_ip_store(struct device *d,  struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct usbnet *dev = netdev_priv(to_net_dev(d));
+	struct qmi_wwan_state *info = (void *)&dev->data;
+	bool enable;
+	int err;
+
+	if (strtobool(buf, &enable))
+		return -EINVAL;
+
+	/* no change? */
+	if (enable == (info->flags & QMI_WWAN_FLAG_RAWIP))
+		return len;
+
+	/* we don't want to modify a running netdev */
+	if (netif_running(dev->net)) {
+		netdev_err(dev->net, "Cannot change a running device\n");
+		return -EBUSY;
+	}
+
+	/* let other drivers deny the change */
+	err = call_netdevice_notifiers(NETDEV_PRE_TYPE_CHANGE, dev->net);
+	err = notifier_to_errno(err);
+	if (err) {
+		netdev_err(dev->net, "Type change was refused\n");
+		return err;
+	}
+
+	if (enable)
+		info->flags |= QMI_WWAN_FLAG_RAWIP;
+	else
+		info->flags &= ~QMI_WWAN_FLAG_RAWIP;
+	qmi_wwan_netdev_setup(dev->net);
+	call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE, dev->net);
+	return len;
+}
+
+static DEVICE_ATTR_RW(raw_ip);
+
+static struct attribute *qmi_wwan_sysfs_attrs[] = {
+	&dev_attr_raw_ip.attr,
+	NULL,
+};
+
+static struct attribute_group qmi_wwan_sysfs_attr_group = {
+	.name = "qmi",
+	.attrs = qmi_wwan_sysfs_attrs,
+};
+
 /* default ethernet address used by the modem */
 static const u8 default_modem_addr[ETH_ALEN] = {0x02, 0x50, 0xf3};
 
@@ -80,6 +163,8 @@ static const u8 buggy_fw_addr[ETH_ALEN] = {0x00, 0xa0, 0xc6, 0x00, 0x00, 0x00};
  */
 static int qmi_wwan_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
+	struct qmi_wwan_state *info = (void *)&dev->data;
+	bool rawip = info->flags & QMI_WWAN_FLAG_RAWIP;
 	__be16 proto;
 
 	/* This check is no longer done by usbnet */
@@ -94,15 +179,25 @@ static int qmi_wwan_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		proto = htons(ETH_P_IPV6);
 		break;
 	case 0x00:
+		if (rawip)
+			return 0;
 		if (is_multicast_ether_addr(skb->data))
 			return 1;
 		/* possibly bogus destination - rewrite just in case */
 		skb_reset_mac_header(skb);
 		goto fix_dest;
 	default:
+		if (rawip)
+			return 0;
 		/* pass along other packets without modifications */
 		return 1;
 	}
+	if (rawip) {
+		skb->dev = dev->net; /* normally set by eth_type_trans */
+		skb->protocol = proto;
+		return 1;
+	}
+
 	if (skb_headroom(skb) < ETH_HLEN)
 		return 0;
 	skb_push(skb, ETH_HLEN);
@@ -326,6 +421,7 @@ static int qmi_wwan_bind(struct usbnet *dev, struct usb_interface *intf)
 		dev->net->dev_addr[0] &= 0xbf;	/* clear "IP" bit */
 	}
 	dev->net->netdev_ops = &qmi_wwan_netdev_ops;
+	dev->net->sysfs_groups[0] = &qmi_wwan_sysfs_attr_group;
 err:
 	return status;
 }
-- 
2.25.1




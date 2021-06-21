Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24033AEE8D
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhFUQ3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:29:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232280AbhFUQ3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:29:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBAAD613F2;
        Mon, 21 Jun 2021 16:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292635;
        bh=oD2GRo8CVZ7dojdkiYDrX1qfp+tFxkclrdwmYlMdtwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ul4R4X7yITkk5mPRofSmm8XtnmJ7aiBUPNEU2H6RZz4yjkfFx2WXKH1WAdt4A+A4n
         pir/HcBbKufq8nnLKS2xaiwYyL/YTus3ryr+K493yoJA7qYBy8lu7JzExn8aIBukU3
         nuvEhQpJKxCX8ubX6ifsuGVxYVKoTMqnFUhEoEpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/146] net: qualcomm: rmnet: Update rmnet device MTU based on real device
Date:   Mon, 21 Jun 2021 18:14:36 +0200
Message-Id: <20210621154912.855978120@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

[ Upstream commit b7f5eb6ba21b0b54b04918fc9df13309ff3c67b8 ]

Packets sent by rmnet to the real device have variable MAP header
lengths based on the data format configured. This patch adds checks
to ensure that the real device MTU is sufficient to transmit the MAP
packet comprising of the MAP header and the IP packet. This check
is enforced when rmnet devices are created and updated and during
MTU updates of both the rmnet and real device.

Additionally, rmnet devices now have a default MTU configured which
accounts for the real device MTU and the headroom based on the data
format.

Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Tested-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_config.c    | 15 +++-
 .../ethernet/qualcomm/rmnet/rmnet_config.h    |  2 +
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   | 73 ++++++++++++++++++-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |  3 +
 4 files changed, 90 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index fcdecddb2812..8d51b0cb545c 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -26,7 +26,7 @@ static int rmnet_is_real_dev_registered(const struct net_device *real_dev)
 }
 
 /* Needs rtnl lock */
-static struct rmnet_port*
+struct rmnet_port*
 rmnet_get_port_rtnl(const struct net_device *real_dev)
 {
 	return rtnl_dereference(real_dev->rx_handler_data);
@@ -253,7 +253,10 @@ static int rmnet_config_notify_cb(struct notifier_block *nb,
 		netdev_dbg(real_dev, "Kernel unregister\n");
 		rmnet_force_unassociate_device(real_dev);
 		break;
-
+	case NETDEV_CHANGEMTU:
+		if (rmnet_vnd_validate_real_dev_mtu(real_dev))
+			return NOTIFY_BAD;
+		break;
 	default:
 		break;
 	}
@@ -329,9 +332,17 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
 
 	if (data[IFLA_RMNET_FLAGS]) {
 		struct ifla_rmnet_flags *flags;
+		u32 old_data_format;
 
+		old_data_format = port->data_format;
 		flags = nla_data(data[IFLA_RMNET_FLAGS]);
 		port->data_format = flags->flags & flags->mask;
+
+		if (rmnet_vnd_update_dev_mtu(port, real_dev)) {
+			port->data_format = old_data_format;
+			NL_SET_ERR_MSG_MOD(extack, "Invalid MTU on real dev");
+			return -EINVAL;
+		}
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
index be515982d628..8d8d4690a074 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
@@ -73,4 +73,6 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 		     struct netlink_ext_ack *extack);
 int rmnet_del_bridge(struct net_device *rmnet_dev,
 		     struct net_device *slave_dev);
+struct rmnet_port*
+rmnet_get_port_rtnl(const struct net_device *real_dev);
 #endif /* _RMNET_CONFIG_H_ */
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index d58b51d277f1..6cf46f893fb9 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -58,9 +58,30 @@ static netdev_tx_t rmnet_vnd_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static int rmnet_vnd_headroom(struct rmnet_port *port)
+{
+	u32 headroom;
+
+	headroom = sizeof(struct rmnet_map_header);
+
+	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV4)
+		headroom += sizeof(struct rmnet_map_ul_csum_header);
+
+	return headroom;
+}
+
 static int rmnet_vnd_change_mtu(struct net_device *rmnet_dev, int new_mtu)
 {
-	if (new_mtu < 0 || new_mtu > RMNET_MAX_PACKET_SIZE)
+	struct rmnet_priv *priv = netdev_priv(rmnet_dev);
+	struct rmnet_port *port;
+	u32 headroom;
+
+	port = rmnet_get_port_rtnl(priv->real_dev);
+
+	headroom = rmnet_vnd_headroom(port);
+
+	if (new_mtu < 0 || new_mtu > RMNET_MAX_PACKET_SIZE ||
+	    new_mtu > (priv->real_dev->mtu - headroom))
 		return -EINVAL;
 
 	rmnet_dev->mtu = new_mtu;
@@ -229,6 +250,7 @@ int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 
 {
 	struct rmnet_priv *priv = netdev_priv(rmnet_dev);
+	u32 headroom;
 	int rc;
 
 	if (rmnet_get_endpoint(port, id)) {
@@ -242,6 +264,13 @@ int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 
 	priv->real_dev = real_dev;
 
+	headroom = rmnet_vnd_headroom(port);
+
+	if (rmnet_vnd_change_mtu(rmnet_dev, real_dev->mtu - headroom)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid MTU on real dev");
+		return -EINVAL;
+	}
+
 	rc = register_netdevice(rmnet_dev);
 	if (!rc) {
 		ep->egress_dev = rmnet_dev;
@@ -283,3 +312,45 @@ int rmnet_vnd_do_flow_control(struct net_device *rmnet_dev, int enable)
 
 	return 0;
 }
+
+int rmnet_vnd_validate_real_dev_mtu(struct net_device *real_dev)
+{
+	struct hlist_node *tmp_ep;
+	struct rmnet_endpoint *ep;
+	struct rmnet_port *port;
+	unsigned long bkt_ep;
+	u32 headroom;
+
+	port = rmnet_get_port_rtnl(real_dev);
+
+	headroom = rmnet_vnd_headroom(port);
+
+	hash_for_each_safe(port->muxed_ep, bkt_ep, tmp_ep, ep, hlnode) {
+		if (ep->egress_dev->mtu > (real_dev->mtu - headroom))
+			return -1;
+	}
+
+	return 0;
+}
+
+int rmnet_vnd_update_dev_mtu(struct rmnet_port *port,
+			     struct net_device *real_dev)
+{
+	struct hlist_node *tmp_ep;
+	struct rmnet_endpoint *ep;
+	unsigned long bkt_ep;
+	u32 headroom;
+
+	headroom = rmnet_vnd_headroom(port);
+
+	hash_for_each_safe(port->muxed_ep, bkt_ep, tmp_ep, ep, hlnode) {
+		if (ep->egress_dev->mtu <= (real_dev->mtu - headroom))
+			continue;
+
+		if (rmnet_vnd_change_mtu(ep->egress_dev,
+					 real_dev->mtu - headroom))
+			return -1;
+	}
+
+	return 0;
+}
\ No newline at end of file
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
index 4967f3461ed1..dc3a4443ef0a 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
@@ -18,4 +18,7 @@ int rmnet_vnd_dellink(u8 id, struct rmnet_port *port,
 void rmnet_vnd_rx_fixup(struct sk_buff *skb, struct net_device *dev);
 void rmnet_vnd_tx_fixup(struct sk_buff *skb, struct net_device *dev);
 void rmnet_vnd_setup(struct net_device *dev);
+int rmnet_vnd_validate_real_dev_mtu(struct net_device *real_dev);
+int rmnet_vnd_update_dev_mtu(struct rmnet_port *port,
+			     struct net_device *real_dev);
 #endif /* _RMNET_VND_H_ */
-- 
2.30.2




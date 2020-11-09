Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6BB2ABBBD
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgKIN37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:29:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732359AbgKINLa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:11:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F0AF2083B;
        Mon,  9 Nov 2020 13:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927490;
        bh=XG2cEr83jXkpuZpijhJj7hteAs17/Klycw8W2XIeEY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S1ATgIuO2hk0q4/xrTeAWD87UM03HszDJPiEDhiio2K6SwP3F1R3KlCAeCHxulRPU
         iwlXeQeOXzLRsSHVfvPIDaaiyUrThxK5bOb+ZyXb4VJZtK7qfe8kLOPDefljtQZeI8
         xYXdcZLBfY8T72OR1MFtdC+bEvzhN7jlpYdU8uQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaofei Shen <xiaofeis@codeaurora.org>,
        Vinod Koul <vkoul@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 4.19 70/71] net: dsa: read mac address from DT for slave device
Date:   Mon,  9 Nov 2020 13:56:04 +0100
Message-Id: <20201109125023.181816290@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaofei Shen <xiaofeis@codeaurora.org>

commit a2c7023f7075ca9b80f944d3f20f60e6574538e2 upstream.

Before creating a slave netdevice, get the mac address from DTS and
apply in case it is valid.

Signed-off-by: Xiaofei Shen <xiaofeis@codeaurora.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Pali Rohár <pali@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/dsa.h |    1 +
 net/dsa/dsa2.c    |    1 +
 net/dsa/slave.c   |    5 ++++-
 3 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -196,6 +196,7 @@ struct dsa_port {
 	unsigned int		index;
 	const char		*name;
 	const struct dsa_port	*cpu_dp;
+	const char		*mac;
 	struct device_node	*dn;
 	unsigned int		ageing_time;
 	u8			stp_state;
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -261,6 +261,7 @@ static int dsa_port_setup(struct dsa_por
 	int err = 0;
 
 	memset(&dp->devlink_port, 0, sizeof(dp->devlink_port));
+	dp->mac = of_get_mac_address(dp->dn);
 
 	if (dp->type != DSA_PORT_TYPE_UNUSED)
 		err = devlink_port_register(ds->devlink, &dp->devlink_port,
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1313,7 +1313,10 @@ int dsa_slave_create(struct dsa_port *po
 	slave_dev->features = master->vlan_features | NETIF_F_HW_TC;
 	slave_dev->hw_features |= NETIF_F_HW_TC;
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
-	eth_hw_addr_inherit(slave_dev, master);
+	if (port->mac && is_valid_ether_addr(port->mac))
+		ether_addr_copy(slave_dev->dev_addr, port->mac);
+	else
+		eth_hw_addr_inherit(slave_dev, master);
 	slave_dev->priv_flags |= IFF_NO_QUEUE;
 	slave_dev->netdev_ops = &dsa_slave_netdev_ops;
 	slave_dev->switchdev_ops = &dsa_slave_switchdev_ops;



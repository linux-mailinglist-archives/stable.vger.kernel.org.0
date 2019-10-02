Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D21C91AC
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbfJBTKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:10:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35784 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729302AbfJBTIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:15 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyu-000364-EQ; Wed, 02 Oct 2019 20:08:12 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyq-0003gI-94; Wed, 02 Oct 2019 20:08:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jiri Pirko" <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        "Jiri Pirko" <jiri@mellanox.com>,
        "YueHaibing" <yuehaibing@huawei.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.524954219@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 80/87] bonding: Always enable vlan tx offload
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: YueHaibing <yuehaibing@huawei.com>

commit 30d8177e8ac776d89d387fad547af6a0f599210e upstream.

We build vlan on top of bonding interface, which vlan offload
is off, bond mode is 802.3ad (LACP) and xmit_hash_policy is
BOND_XMIT_POLICY_ENCAP34.

Because vlan tx offload is off, vlan tci is cleared and skb push
the vlan header in validate_xmit_vlan() while sending from vlan
devices. Then in bond_xmit_hash, __skb_flow_dissect() fails to
get information from protocol headers encapsulated within vlan,
because 'nhoff' is points to IP header, so bond hashing is based
on layer 2 info, which fails to distribute packets across slaves.

This patch always enable bonding's vlan tx offload, pass the vlan
packets to the slave devices with vlan tci, let them to handle
vlan implementation.

Fixes: 278339a42a1b ("bonding: propogate vlan_features to bonding master")
Suggested-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4038,13 +4038,13 @@ void bond_setup(struct net_device *bond_
 	bond_dev->features |= NETIF_F_NETNS_LOCAL;
 
 	bond_dev->hw_features = BOND_VLAN_FEATURES |
-				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	bond_dev->hw_features &= ~(NETIF_F_ALL_CSUM & ~NETIF_F_HW_CSUM);
 	bond_dev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
 	bond_dev->features |= bond_dev->hw_features;
+	bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
 }
 
 /*


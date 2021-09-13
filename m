Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141A34094D5
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345202AbhIMOgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345863AbhIMOcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:32:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F58561BB6;
        Mon, 13 Sep 2021 13:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541132;
        bh=J6CQ7syME1XN+MCyVZO9YTlAz7zN0MOXoa52UE9kjDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/OFos994jJlHRZ+yIk5Mg/3sgVlh2cLvB+C/VICAWrAWQ8Aj167U9ZwgVnEjeRcA
         a+efWDC0+b0JMkqCzA2ATc8BBLQN2jE4S3K1R7a3kRY+7E9UpQreFRRlgJ7Xf7wK5n
         JYXDy9HXMgJYWOId0Z3g5/qVtweqY4yENcrcT2uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 177/334] net: dsa: stop syncing the bridge mcast_router attribute at join time
Date:   Mon, 13 Sep 2021 15:13:51 +0200
Message-Id: <20210913131119.335833087@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 7df4e7449489d82cee6813dccbb4ae4f3f26ef7b ]

Qingfang points out that when a bridge with the default settings is
created and a port joins it:

ip link add br0 type bridge
ip link set swp0 master br0

DSA calls br_multicast_router() on the bridge to see if the br0 device
is a multicast router port, and if it is, it enables multicast flooding
to the CPU port, otherwise it disables it.

If we look through the multicast_router_show() sysfs or at the
IFLA_BR_MCAST_ROUTER netlink attribute, we see that the default mrouter
attribute for the bridge device is "1" (MDB_RTR_TYPE_TEMP_QUERY).

However, br_multicast_router() will return "0" (MDB_RTR_TYPE_DISABLED),
because an mrouter port in the MDB_RTR_TYPE_TEMP_QUERY state may not be
actually _active_ until it receives an actual IGMP query. So, the
br_multicast_router() function should really have been called
br_multicast_router_active() perhaps.

When/if an IGMP query is received, the bridge device will transition via
br_multicast_mark_router() into the active state until the
ip4_mc_router_timer expires after an multicast_querier_interval.

Of course, this does not happen if the bridge is created with an
mcast_router attribute of "2" (MDB_RTR_TYPE_PERM).

The point is that in lack of any IGMP query messages, and in the default
bridge configuration, unregistered multicast packets will not be able to
reach the CPU port through flooding, and this breaks many use cases
(most obviously, IPv6 ND, with its ICMP6 neighbor solicitation multicast
messages).

Leave the multicast flooding setting towards the CPU port down to a driver
level decision.

Fixes: 010e269f91be ("net: dsa: sync up switchdev objects and port attributes when joining the bridge")
Reported-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/port.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 28b45b7e66df..d9ef2c2fbf88 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -186,10 +186,6 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = dsa_port_mrouter(dp->cpu_dp, br_multicast_router(br), extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
-
 	err = dsa_port_ageing_time(dp, br_get_ageing_time(br));
 	if (err && err != -EOPNOTSUPP)
 		return err;
@@ -272,12 +268,6 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 
 	/* VLAN filtering is handled by dsa_switch_bridge_leave */
 
-	/* Some drivers treat the notification for having a local multicast
-	 * router by allowing multicast to be flooded to the CPU, so we should
-	 * allow this in standalone mode too.
-	 */
-	dsa_port_mrouter(dp->cpu_dp, true, NULL);
-
 	/* Ageing time may be global to the switch chip, so don't change it
 	 * here because we have no good reason (or value) to change it to.
 	 */
-- 
2.30.2




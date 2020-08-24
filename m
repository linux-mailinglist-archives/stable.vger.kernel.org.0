Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBAC24F94D
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgHXJoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:44:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728752AbgHXIni (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:43:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D44E82075B;
        Mon, 24 Aug 2020 08:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258616;
        bh=AmwGl3nbdomZR9X6hN9fQPE1qXogeoBgob+2uxXlRpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwPIFZBKmgi0L1F8C4f9HjVUvHxVz5XuS1ulBFAQerrF9b/gUJX+YAJtAoxSww2pT
         lvu5jy/r/WChwDPydAo+cjdVAj6sYWz92qH+cdECesrd4KwJTWKna09RQJYplSaz8h
         AKUHfoRbhDnZiF8cXqZi5HdHZvmItC6dyAYPPzx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Wiesner <jwiesner@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 110/124] bonding: fix active-backup failover for current ARP slave
Date:   Mon, 24 Aug 2020 10:30:44 +0200
Message-Id: <20200824082414.818405009@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Wiesner <jwiesner@suse.com>

[ Upstream commit 0410d07190961ac526f05085765a8d04d926545b ]

When the ARP monitor is used for link detection, ARP replies are
validated for all slaves (arp_validate=3) and fail_over_mac is set to
active, two slaves of an active-backup bond may get stuck in a state
where both of them are active and pass packets that they receive to
the bond. This state makes IPv6 duplicate address detection fail. The
state is reached thus:
1. The current active slave goes down because the ARP target
   is not reachable.
2. The current ARP slave is chosen and made active.
3. A new slave is enslaved. This new slave becomes the current active
   slave and can reach the ARP target.
As a result, the current ARP slave stays active after the enslave
action has finished and the log is littered with "PROBE BAD" messages:
> bond0: PROBE: c_arp ens10 && cas ens11 BAD
The workaround is to remove the slave with "going back" status from
the bond and re-enslave it. This issue was encountered when DPDK PMD
interfaces were being enslaved to an active-backup bond.

I would be possible to fix the issue in bond_enslave() or
bond_change_active_slave() but the ARP monitor was fixed instead to
keep most of the actions changing the current ARP slave in the ARP
monitor code. The current ARP slave is set as inactive and backup
during the commit phase. A new state, BOND_LINK_FAIL, has been
introduced for slaves in the context of the ARP monitor. This allows
administrators to see how slaves are rotated for sending ARP requests
and attempts are made to find a new active slave.

Fixes: b2220cad583c9 ("bonding: refactor ARP active-backup monitor")
Signed-off-by: Jiri Wiesner <jwiesner@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 02f2428cbc3ba..07624e89b96d6 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2825,6 +2825,9 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 			if (bond_time_in_interval(bond, last_rx, 1)) {
 				bond_propose_link_state(slave, BOND_LINK_UP);
 				commit++;
+			} else if (slave->link == BOND_LINK_BACK) {
+				bond_propose_link_state(slave, BOND_LINK_FAIL);
+				commit++;
 			}
 			continue;
 		}
@@ -2933,6 +2936,19 @@ static void bond_ab_arp_commit(struct bonding *bond)
 
 			continue;
 
+		case BOND_LINK_FAIL:
+			bond_set_slave_link_state(slave, BOND_LINK_FAIL,
+						  BOND_SLAVE_NOTIFY_NOW);
+			bond_set_slave_inactive_flags(slave,
+						      BOND_SLAVE_NOTIFY_NOW);
+
+			/* A slave has just been enslaved and has become
+			 * the current active slave.
+			 */
+			if (rtnl_dereference(bond->curr_active_slave))
+				RCU_INIT_POINTER(bond->current_arp_slave, NULL);
+			continue;
+
 		default:
 			slave_err(bond->dev, slave->dev,
 				  "impossible: link_new_state %d on slave\n",
@@ -2983,8 +2999,6 @@ static bool bond_ab_arp_probe(struct bonding *bond)
 			return should_notify_rtnl;
 	}
 
-	bond_set_slave_inactive_flags(curr_arp_slave, BOND_SLAVE_NOTIFY_LATER);
-
 	bond_for_each_slave_rcu(bond, slave, iter) {
 		if (!found && !before && bond_slave_is_up(slave))
 			before = slave;
-- 
2.25.1




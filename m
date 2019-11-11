Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8E2F7C92
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbfKKSre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:47:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730123AbfKKSrd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:47:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41A0E20674;
        Mon, 11 Nov 2019 18:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498052;
        bh=lcT+y6YLGSdRUPvEk33UfHvQZkeWTRlc2Ig5xmmjAdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=je1r2+lGLsHZ3zekE2tLaCyxbbmIf1H3tz44QGHSAOVtPW8hH3EnNgBCOH9q3k0V3
         oFT1BWZN24DWYg9KDAjZbuUGhcR7vKrGkJalpfJoTekvPsPpj3bCGDjo87fDut2EgZ
         tROZ0AYDDwCWk9a+p7gtTXhRlD+VrskiYdXSTI0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksei Zakharov <zakharov.a.g@yandex.ru>,
        Sha Zhang <zhangsha.zhang@huawei.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 001/193] bonding: fix state transition issue in link monitoring
Date:   Mon, 11 Nov 2019 19:26:23 +0100
Message-Id: <20191111181459.961740450@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jay Vosburgh <jay.vosburgh@canonical.com>

[ Upstream commit 1899bb325149e481de31a4f32b59ea6f24e176ea ]

Since de77ecd4ef02 ("bonding: improve link-status update in
mii-monitoring"), the bonding driver has utilized two separate variables
to indicate the next link state a particular slave should transition to.
Each is used to communicate to a different portion of the link state
change commit logic; one to the bond_miimon_commit function itself, and
another to the state transition logic.

	Unfortunately, the two variables can become unsynchronized,
resulting in incorrect link state transitions within bonding.  This can
cause slaves to become stuck in an incorrect link state until a
subsequent carrier state transition.

	The issue occurs when a special case in bond_slave_netdev_event
sets slave->link directly to BOND_LINK_FAIL.  On the next pass through
bond_miimon_inspect after the slave goes carrier up, the BOND_LINK_FAIL
case will set the proposed next state (link_new_state) to BOND_LINK_UP,
but the new_link to BOND_LINK_DOWN.  The setting of the final link state
from new_link comes after that from link_new_state, and so the slave
will end up incorrectly in _DOWN state.

	Resolve this by combining the two variables into one.

Reported-by: Aleksei Zakharov <zakharov.a.g@yandex.ru>
Reported-by: Sha Zhang <zhangsha.zhang@huawei.com>
Cc: Mahesh Bandewar <maheshb@google.com>
Fixes: de77ecd4ef02 ("bonding: improve link-status update in mii-monitoring")
Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |   44 ++++++++++++++++++++--------------------
 include/net/bonding.h           |    3 --
 2 files changed, 23 insertions(+), 24 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2086,8 +2086,7 @@ static int bond_miimon_inspect(struct bo
 	ignore_updelay = !rcu_dereference(bond->curr_active_slave);
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		slave->new_link = BOND_LINK_NOCHANGE;
-		slave->link_new_state = slave->link;
+		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
 		link_state = bond_check_dev_link(bond, slave->dev, 0);
 
@@ -2121,7 +2120,7 @@ static int bond_miimon_inspect(struct bo
 			}
 
 			if (slave->delay <= 0) {
-				slave->new_link = BOND_LINK_DOWN;
+				bond_propose_link_state(slave, BOND_LINK_DOWN);
 				commit++;
 				continue;
 			}
@@ -2158,7 +2157,7 @@ static int bond_miimon_inspect(struct bo
 				slave->delay = 0;
 
 			if (slave->delay <= 0) {
-				slave->new_link = BOND_LINK_UP;
+				bond_propose_link_state(slave, BOND_LINK_UP);
 				commit++;
 				ignore_updelay = false;
 				continue;
@@ -2196,7 +2195,7 @@ static void bond_miimon_commit(struct bo
 	struct slave *slave, *primary;
 
 	bond_for_each_slave(bond, slave, iter) {
-		switch (slave->new_link) {
+		switch (slave->link_new_state) {
 		case BOND_LINK_NOCHANGE:
 			/* For 802.3ad mode, check current slave speed and
 			 * duplex again in case its port was disabled after
@@ -2268,8 +2267,8 @@ static void bond_miimon_commit(struct bo
 
 		default:
 			slave_err(bond->dev, slave->dev, "invalid new link %d on slave\n",
-				  slave->new_link);
-			slave->new_link = BOND_LINK_NOCHANGE;
+				  slave->link_new_state);
+			bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
 			continue;
 		}
@@ -2677,13 +2676,13 @@ static void bond_loadbalance_arp_mon(str
 	bond_for_each_slave_rcu(bond, slave, iter) {
 		unsigned long trans_start = dev_trans_start(slave->dev);
 
-		slave->new_link = BOND_LINK_NOCHANGE;
+		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 
 		if (slave->link != BOND_LINK_UP) {
 			if (bond_time_in_interval(bond, trans_start, 1) &&
 			    bond_time_in_interval(bond, slave->last_rx, 1)) {
 
-				slave->new_link = BOND_LINK_UP;
+				bond_propose_link_state(slave, BOND_LINK_UP);
 				slave_state_changed = 1;
 
 				/* primary_slave has no meaning in round-robin
@@ -2708,7 +2707,7 @@ static void bond_loadbalance_arp_mon(str
 			if (!bond_time_in_interval(bond, trans_start, 2) ||
 			    !bond_time_in_interval(bond, slave->last_rx, 2)) {
 
-				slave->new_link = BOND_LINK_DOWN;
+				bond_propose_link_state(slave, BOND_LINK_DOWN);
 				slave_state_changed = 1;
 
 				if (slave->link_failure_count < UINT_MAX)
@@ -2739,8 +2738,8 @@ static void bond_loadbalance_arp_mon(str
 			goto re_arm;
 
 		bond_for_each_slave(bond, slave, iter) {
-			if (slave->new_link != BOND_LINK_NOCHANGE)
-				slave->link = slave->new_link;
+			if (slave->link_new_state != BOND_LINK_NOCHANGE)
+				slave->link = slave->link_new_state;
 		}
 
 		if (slave_state_changed) {
@@ -2763,9 +2762,9 @@ re_arm:
 }
 
 /* Called to inspect slaves for active-backup mode ARP monitor link state
- * changes.  Sets new_link in slaves to specify what action should take
- * place for the slave.  Returns 0 if no changes are found, >0 if changes
- * to link states must be committed.
+ * changes.  Sets proposed link state in slaves to specify what action
+ * should take place for the slave.  Returns 0 if no changes are found, >0
+ * if changes to link states must be committed.
  *
  * Called with rcu_read_lock held.
  */
@@ -2777,12 +2776,12 @@ static int bond_ab_arp_inspect(struct bo
 	int commit = 0;
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		slave->new_link = BOND_LINK_NOCHANGE;
+		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
 		last_rx = slave_last_rx(bond, slave);
 
 		if (slave->link != BOND_LINK_UP) {
 			if (bond_time_in_interval(bond, last_rx, 1)) {
-				slave->new_link = BOND_LINK_UP;
+				bond_propose_link_state(slave, BOND_LINK_UP);
 				commit++;
 			}
 			continue;
@@ -2810,7 +2809,7 @@ static int bond_ab_arp_inspect(struct bo
 		if (!bond_is_active_slave(slave) &&
 		    !rcu_access_pointer(bond->current_arp_slave) &&
 		    !bond_time_in_interval(bond, last_rx, 3)) {
-			slave->new_link = BOND_LINK_DOWN;
+			bond_propose_link_state(slave, BOND_LINK_DOWN);
 			commit++;
 		}
 
@@ -2823,7 +2822,7 @@ static int bond_ab_arp_inspect(struct bo
 		if (bond_is_active_slave(slave) &&
 		    (!bond_time_in_interval(bond, trans_start, 2) ||
 		     !bond_time_in_interval(bond, last_rx, 2))) {
-			slave->new_link = BOND_LINK_DOWN;
+			bond_propose_link_state(slave, BOND_LINK_DOWN);
 			commit++;
 		}
 	}
@@ -2843,7 +2842,7 @@ static void bond_ab_arp_commit(struct bo
 	struct slave *slave;
 
 	bond_for_each_slave(bond, slave, iter) {
-		switch (slave->new_link) {
+		switch (slave->link_new_state) {
 		case BOND_LINK_NOCHANGE:
 			continue;
 
@@ -2893,8 +2892,9 @@ static void bond_ab_arp_commit(struct bo
 			continue;
 
 		default:
-			slave_err(bond->dev, slave->dev, "impossible: new_link %d on slave\n",
-				  slave->new_link);
+			slave_err(bond->dev, slave->dev,
+				  "impossible: link_new_state %d on slave\n",
+				  slave->link_new_state);
 			continue;
 		}
 
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -159,7 +159,6 @@ struct slave {
 	unsigned long target_last_arp_rx[BOND_MAX_ARP_TARGETS];
 	s8     link;		/* one of BOND_LINK_XXXX */
 	s8     link_new_state;	/* one of BOND_LINK_XXXX */
-	s8     new_link;
 	u8     backup:1,   /* indicates backup slave. Value corresponds with
 			      BOND_STATE_ACTIVE and BOND_STATE_BACKUP */
 	       inactive:1, /* indicates inactive slave */
@@ -549,7 +548,7 @@ static inline void bond_propose_link_sta
 
 static inline void bond_commit_link_state(struct slave *slave, bool notify)
 {
-	if (slave->link == slave->link_new_state)
+	if (slave->link_new_state == BOND_LINK_NOCHANGE)
 		return;
 
 	slave->link = slave->link_new_state;



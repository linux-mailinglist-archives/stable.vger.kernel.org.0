Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFE3658389
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbiL1Qsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235101AbiL1QsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:48:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507C31EAE4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:43:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9EA8B817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A8DC433D2;
        Wed, 28 Dec 2022 16:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245816;
        bh=IBipz98u+KaI/sK0ROsRFz3iFrOH7XVKK50hifb5WAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xd21FFGgExxkVRXSypBOsTc5LJwrPE7tUQrsgAfCBYi/hoYHTrwLpGH4E2fxKgwzh
         VZJhdRWhi6qAJVmKwneuVIviM759dJAzfXne4NsVk1mXjwYw9RRxxugZeiz+PR2qGZ
         ftbqAzqzQns50exThH892EnNUdfdiWhnnHzkgg1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liang Li <liali@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0890/1146] bonding: do failover when high prio link up
Date:   Wed, 28 Dec 2022 15:40:29 +0100
Message-Id: <20221228144354.356787690@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit e95cc44763a41d5c715ef16742bcb1d8e6524a62 ]

Currently, when a high prio link enslaved, or when current link down,
the high prio port could be selected. But when high prio link up, the
new active slave reselection is not triggered. Fix it by checking link's
prio when getting up. Making the do_failover after looping all slaves as
there may be multi high prio slaves up.

Reported-by: Liang Li <liali@redhat.com>
Fixes: 0a2ff7cc8ad4 ("Bonding: add per-port priority for failover re-selection")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index af35a46994cc..b108f2f4adc2 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2653,8 +2653,9 @@ static void bond_miimon_link_change(struct bonding *bond,
 
 static void bond_miimon_commit(struct bonding *bond)
 {
-	struct list_head *iter;
 	struct slave *slave, *primary;
+	bool do_failover = false;
+	struct list_head *iter;
 
 	bond_for_each_slave(bond, slave, iter) {
 		switch (slave->link_new_state) {
@@ -2698,8 +2699,9 @@ static void bond_miimon_commit(struct bonding *bond)
 
 			bond_miimon_link_change(bond, slave, BOND_LINK_UP);
 
-			if (!rcu_access_pointer(bond->curr_active_slave) || slave == primary)
-				goto do_failover;
+			if (!rcu_access_pointer(bond->curr_active_slave) || slave == primary ||
+			    slave->prio > rcu_dereference(bond->curr_active_slave)->prio)
+				do_failover = true;
 
 			continue;
 
@@ -2720,7 +2722,7 @@ static void bond_miimon_commit(struct bonding *bond)
 			bond_miimon_link_change(bond, slave, BOND_LINK_DOWN);
 
 			if (slave == rcu_access_pointer(bond->curr_active_slave))
-				goto do_failover;
+				do_failover = true;
 
 			continue;
 
@@ -2731,8 +2733,9 @@ static void bond_miimon_commit(struct bonding *bond)
 
 			continue;
 		}
+	}
 
-do_failover:
+	if (do_failover) {
 		block_netpoll_tx();
 		bond_select_active_slave(bond);
 		unblock_netpoll_tx();
@@ -3530,6 +3533,7 @@ static int bond_ab_arp_inspect(struct bonding *bond)
  */
 static void bond_ab_arp_commit(struct bonding *bond)
 {
+	bool do_failover = false;
 	struct list_head *iter;
 	unsigned long last_tx;
 	struct slave *slave;
@@ -3559,8 +3563,9 @@ static void bond_ab_arp_commit(struct bonding *bond)
 				slave_info(bond->dev, slave->dev, "link status definitely up\n");
 
 				if (!rtnl_dereference(bond->curr_active_slave) ||
-				    slave == rtnl_dereference(bond->primary_slave))
-					goto do_failover;
+				    slave == rtnl_dereference(bond->primary_slave) ||
+				    slave->prio > rtnl_dereference(bond->curr_active_slave)->prio)
+					do_failover = true;
 
 			}
 
@@ -3579,7 +3584,7 @@ static void bond_ab_arp_commit(struct bonding *bond)
 
 			if (slave == rtnl_dereference(bond->curr_active_slave)) {
 				RCU_INIT_POINTER(bond->current_arp_slave, NULL);
-				goto do_failover;
+				do_failover = true;
 			}
 
 			continue;
@@ -3603,8 +3608,9 @@ static void bond_ab_arp_commit(struct bonding *bond)
 				  slave->link_new_state);
 			continue;
 		}
+	}
 
-do_failover:
+	if (do_failover) {
 		block_netpoll_tx();
 		bond_select_active_slave(bond);
 		unblock_netpoll_tx();
-- 
2.35.1




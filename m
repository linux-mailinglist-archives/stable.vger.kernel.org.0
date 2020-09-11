Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971CB266125
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 16:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgIKOZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 10:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbgIKNMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:12:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 325C022225;
        Fri, 11 Sep 2020 13:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829225;
        bh=W1ZGXPCPWg4GDwJhPkYdlGLPtpBi+3EawQT0rGrBiAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nftCcjhvIiJ3GXmK4jnsxURVRSFpp9WQm8podGNH1KrQGPc5hSUxoSIi8mYQ0tG8/
         xNrItN4mNwPVgp0eTq2hNknKq3NhYhdDKbVXdipftnmmK+lgcrj7BMOg1W1GYoRvJr
         jP5zpBNKCYozUzxuE1XOzDq6Mp2sGVUhSMuhuAF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 6/8] taprio: Fix using wrong queues in gate mask
Date:   Fri, 11 Sep 2020 14:54:44 +0200
Message-Id: <20200911125420.881569917@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911125420.580564179@linuxfoundation.org>
References: <20200911125420.580564179@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit 09e31cf0c528dac3358a081dc4e773d1b3de1bc9 ]

Since commit 9c66d1564676 ("taprio: Add support for hardware
offloading") there's a bit of inconsistency when offloading schedules
to the hardware:

In software mode, the gate masks are specified in terms of traffic
classes, so if say "sched-entry S 03 20000", it means that the traffic
classes 0 and 1 are open for 20us; when taprio is offloaded to
hardware, the gate masks are specified in terms of hardware queues.

The idea here is to fix hardware offloading, so schedules in hardware
and software mode have the same behavior. What's needed to do is to
map traffic classes to queues when applying the offload to the driver.

Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1177,9 +1177,27 @@ static void taprio_offload_config_change
 	spin_unlock(&q->current_entry_lock);
 }
 
-static void taprio_sched_to_offload(struct taprio_sched *q,
+static u32 tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask)
+{
+	u32 i, queue_mask = 0;
+
+	for (i = 0; i < dev->num_tc; i++) {
+		u32 offset, count;
+
+		if (!(tc_mask & BIT(i)))
+			continue;
+
+		offset = dev->tc_to_txq[i].offset;
+		count = dev->tc_to_txq[i].count;
+
+		queue_mask |= GENMASK(offset + count - 1, offset);
+	}
+
+	return queue_mask;
+}
+
+static void taprio_sched_to_offload(struct net_device *dev,
 				    struct sched_gate_list *sched,
-				    const struct tc_mqprio_qopt *mqprio,
 				    struct tc_taprio_qopt_offload *offload)
 {
 	struct sched_entry *entry;
@@ -1194,7 +1212,8 @@ static void taprio_sched_to_offload(stru
 
 		e->command = entry->command;
 		e->interval = entry->interval;
-		e->gate_mask = entry->gate_mask;
+		e->gate_mask = tc_map_to_queue_mask(dev, entry->gate_mask);
+
 		i++;
 	}
 
@@ -1202,7 +1221,6 @@ static void taprio_sched_to_offload(stru
 }
 
 static int taprio_enable_offload(struct net_device *dev,
-				 struct tc_mqprio_qopt *mqprio,
 				 struct taprio_sched *q,
 				 struct sched_gate_list *sched,
 				 struct netlink_ext_ack *extack)
@@ -1224,7 +1242,7 @@ static int taprio_enable_offload(struct
 		return -ENOMEM;
 	}
 	offload->enable = 1;
-	taprio_sched_to_offload(q, sched, mqprio, offload);
+	taprio_sched_to_offload(dev, sched, offload);
 
 	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
 	if (err < 0) {
@@ -1486,7 +1504,7 @@ static int taprio_change(struct Qdisc *s
 	}
 
 	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
-		err = taprio_enable_offload(dev, mqprio, q, new_admin, extack);
+		err = taprio_enable_offload(dev, q, new_admin, extack);
 	else
 		err = taprio_disable_offload(dev, q, extack);
 	if (err)



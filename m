Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE0A3D6098
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237514AbhGZPXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237513AbhGZPXO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:23:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17E9B60240;
        Mon, 26 Jul 2021 16:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315422;
        bh=BFNhlEZO6+UPnX1sDeZdmiBIyaFaT4PvZeZa4mtd29M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbixW6LmuT+ZRbzMxPZ3VzfVh63itoKLU9pU1YomIBPlMTWWWpxeOmWvYGGQoH0oo
         C2Obp0elFPys6kt9XCbgJ9sDoQeoAw1W+RfxRTYt2y1NlAB5IjvxtEgdh7Zr2ZEYgF
         C4MREqc1KnGcJ0WxabxqQ7kVzfwktUUKB7OViN94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/167] net/sched: act_skbmod: Skip non-Ethernet packets
Date:   Mon, 26 Jul 2021 17:38:43 +0200
Message-Id: <20210726153842.418731889@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

[ Upstream commit 727d6a8b7ef3d25080fad228b2c4a1d4da5999c6 ]

Currently tcf_skbmod_act() assumes that packets use Ethernet as their L2
protocol, which is not always the case.  As an example, for CAN devices:

	$ ip link add dev vcan0 type vcan
	$ ip link set up vcan0
	$ tc qdisc add dev vcan0 root handle 1: htb
	$ tc filter add dev vcan0 parent 1: protocol ip prio 10 \
		matchall action skbmod swap mac

Doing the above silently corrupts all the packets.  Do not perform skbmod
actions for non-Ethernet packets.

Fixes: 86da71b57383 ("net_sched: Introduce skbmod action")
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_skbmod.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index 81a1c67335be..8d17a543cc9f 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -6,6 +6,7 @@
 */
 
 #include <linux/module.h>
+#include <linux/if_arp.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
@@ -33,6 +34,13 @@ static int tcf_skbmod_act(struct sk_buff *skb, const struct tc_action *a,
 	tcf_lastuse_update(&d->tcf_tm);
 	bstats_cpu_update(this_cpu_ptr(d->common.cpu_bstats), skb);
 
+	action = READ_ONCE(d->tcf_action);
+	if (unlikely(action == TC_ACT_SHOT))
+		goto drop;
+
+	if (!skb->dev || skb->dev->type != ARPHRD_ETHER)
+		return action;
+
 	/* XXX: if you are going to edit more fields beyond ethernet header
 	 * (example when you add IP header replacement or vlan swap)
 	 * then MAX_EDIT_LEN needs to change appropriately
@@ -41,10 +49,6 @@ static int tcf_skbmod_act(struct sk_buff *skb, const struct tc_action *a,
 	if (unlikely(err)) /* best policy is to drop on the floor */
 		goto drop;
 
-	action = READ_ONCE(d->tcf_action);
-	if (unlikely(action == TC_ACT_SHOT))
-		goto drop;
-
 	p = rcu_dereference_bh(d->skbmod_p);
 	flags = p->flags;
 	if (flags & SKBMOD_F_DMAC)
-- 
2.30.2




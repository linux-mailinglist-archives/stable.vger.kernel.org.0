Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5718347ADFD
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbhLTO5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:57:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46056 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239160AbhLTOzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:55:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB70F6118E;
        Mon, 20 Dec 2021 14:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB099C36AE8;
        Mon, 20 Dec 2021 14:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012106;
        bh=7S8GTWI9TtBNw6257IU10WQ051ZwfZ7r2RdBX/UO4ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UeHzclDA74jMIlpFkCi5YxWWe33DrE65RovQftc3pKf40ivW9Wz0AQt38XDYe36bt
         whf/tRf7CDwAOAgAxSQoV8miyu7zZqI8x5bWDiQwmhrCb+0CPUQLv3dtCwvAWmCJ/v
         fLfEvJtD9BYJIMlvjlQ65VAXiZCzxIibyYlXCHvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/177] net: stmmac: fix tc flower deletion for VLAN priority Rx steering
Date:   Mon, 20 Dec 2021 15:33:53 +0100
Message-Id: <20211220143042.891717289@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

[ Upstream commit aeb7c75cb77478fdbf821628e9c95c4baa9adc63 ]

To replicate the issue:-

1) Add 1 flower filter for VLAN Priority based frame steering:-
$ IFDEVNAME=eth0
$ tc qdisc add dev $IFDEVNAME ingress
$ tc qdisc add dev $IFDEVNAME root mqprio num_tc 8 \
   map 0 1 2 3 4 5 6 7 0 0 0 0 0 0 0 0 \
   queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0
$ tc filter add dev $IFDEVNAME parent ffff: protocol 802.1Q \
   flower vlan_prio 0 hw_tc 0

2) Get the 'pref' id
$ tc filter show dev $IFDEVNAME ingress

3) Delete a specific tc flower record (say pref 49151)
$ tc filter del dev $IFDEVNAME parent ffff: pref 49151

>From dmesg, we will observe kernel NULL pointer ooops

[  197.170464] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  197.171367] #PF: supervisor read access in kernel mode
[  197.171367] #PF: error_code(0x0000) - not-present page
[  197.171367] PGD 0 P4D 0
[  197.171367] Oops: 0000 [#1] PREEMPT SMP NOPTI

<snip>

[  197.171367] RIP: 0010:tc_setup_cls+0x20b/0x4a0 [stmmac]

<snip>

[  197.171367] Call Trace:
[  197.171367]  <TASK>
[  197.171367]  ? __stmmac_disable_all_queues+0xa8/0xe0 [stmmac]
[  197.171367]  stmmac_setup_tc_block_cb+0x70/0x110 [stmmac]
[  197.171367]  tc_setup_cb_destroy+0xb3/0x180
[  197.171367]  fl_hw_destroy_filter+0x94/0xc0 [cls_flower]

The above issue is due to previous incorrect implementation of
tc_del_vlan_flow(), shown below, that uses flow_cls_offload_flow_rule()
to get struct flow_rule *rule which is no longer valid for tc filter
delete operation.

  struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
  struct flow_dissector *dissector = rule->match.dissector;

So, to ensure tc_del_vlan_flow() deletes the right VLAN cls record for
earlier configured RX queue (configured by hw_tc) in tc_add_vlan_flow(),
this patch introduces stmmac_rfs_entry as driver-side flow_cls_offload
record for 'RX frame steering' tc flower, currently used for VLAN
priority. The implementation has taken consideration for future extension
to include other type RX frame steering such as EtherType based.

v2:
 - Clean up overly extensive backtrace and rewrite git message to better
   explain the kernel NULL pointer issue.

Fixes: 0e039f5cf86c ("net: stmmac: add RX frame steering based on VLAN priority in tc flower")
Tested-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  | 17 ++++
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 86 ++++++++++++++++---
 2 files changed, 90 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 5f129733aabd2..873b9e3e5da25 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -172,6 +172,19 @@ struct stmmac_flow_entry {
 	int is_l4;
 };
 
+/* Rx Frame Steering */
+enum stmmac_rfs_type {
+	STMMAC_RFS_T_VLAN,
+	STMMAC_RFS_T_MAX,
+};
+
+struct stmmac_rfs_entry {
+	unsigned long cookie;
+	int in_use;
+	int type;
+	int tc;
+};
+
 struct stmmac_priv {
 	/* Frequently used values are kept adjacent for cache effect */
 	u32 tx_coal_frames[MTL_MAX_TX_QUEUES];
@@ -289,6 +302,10 @@ struct stmmac_priv {
 	struct stmmac_tc_entry *tc_entries;
 	unsigned int flow_entries_max;
 	struct stmmac_flow_entry *flow_entries;
+	unsigned int rfs_entries_max[STMMAC_RFS_T_MAX];
+	unsigned int rfs_entries_cnt[STMMAC_RFS_T_MAX];
+	unsigned int rfs_entries_total;
+	struct stmmac_rfs_entry *rfs_entries;
 
 	/* Pulse Per Second output */
 	struct stmmac_pps_cfg pps[STMMAC_PPS_MAX];
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 1c4ea0b1b845b..d0a2b289f4603 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -232,11 +232,33 @@ static int tc_setup_cls_u32(struct stmmac_priv *priv,
 	}
 }
 
+static int tc_rfs_init(struct stmmac_priv *priv)
+{
+	int i;
+
+	priv->rfs_entries_max[STMMAC_RFS_T_VLAN] = 8;
+
+	for (i = 0; i < STMMAC_RFS_T_MAX; i++)
+		priv->rfs_entries_total += priv->rfs_entries_max[i];
+
+	priv->rfs_entries = devm_kcalloc(priv->device,
+					 priv->rfs_entries_total,
+					 sizeof(*priv->rfs_entries),
+					 GFP_KERNEL);
+	if (!priv->rfs_entries)
+		return -ENOMEM;
+
+	dev_info(priv->device, "Enabled RFS Flow TC (entries=%d)\n",
+		 priv->rfs_entries_total);
+
+	return 0;
+}
+
 static int tc_init(struct stmmac_priv *priv)
 {
 	struct dma_features *dma_cap = &priv->dma_cap;
 	unsigned int count;
-	int i;
+	int ret, i;
 
 	if (dma_cap->l3l4fnum) {
 		priv->flow_entries_max = dma_cap->l3l4fnum;
@@ -250,10 +272,14 @@ static int tc_init(struct stmmac_priv *priv)
 		for (i = 0; i < priv->flow_entries_max; i++)
 			priv->flow_entries[i].idx = i;
 
-		dev_info(priv->device, "Enabled Flow TC (entries=%d)\n",
+		dev_info(priv->device, "Enabled L3L4 Flow TC (entries=%d)\n",
 			 priv->flow_entries_max);
 	}
 
+	ret = tc_rfs_init(priv);
+	if (ret)
+		return -ENOMEM;
+
 	if (!priv->plat->fpe_cfg) {
 		priv->plat->fpe_cfg = devm_kzalloc(priv->device,
 						   sizeof(*priv->plat->fpe_cfg),
@@ -607,16 +633,45 @@ static int tc_del_flow(struct stmmac_priv *priv,
 	return ret;
 }
 
+static struct stmmac_rfs_entry *tc_find_rfs(struct stmmac_priv *priv,
+					    struct flow_cls_offload *cls,
+					    bool get_free)
+{
+	int i;
+
+	for (i = 0; i < priv->rfs_entries_total; i++) {
+		struct stmmac_rfs_entry *entry = &priv->rfs_entries[i];
+
+		if (entry->cookie == cls->cookie)
+			return entry;
+		if (get_free && entry->in_use == false)
+			return entry;
+	}
+
+	return NULL;
+}
+
 #define VLAN_PRIO_FULL_MASK (0x07)
 
 static int tc_add_vlan_flow(struct stmmac_priv *priv,
 			    struct flow_cls_offload *cls)
 {
+	struct stmmac_rfs_entry *entry = tc_find_rfs(priv, cls, false);
 	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
 	struct flow_dissector *dissector = rule->match.dissector;
 	int tc = tc_classid_to_hwtc(priv->dev, cls->classid);
 	struct flow_match_vlan match;
 
+	if (!entry) {
+		entry = tc_find_rfs(priv, cls, true);
+		if (!entry)
+			return -ENOENT;
+	}
+
+	if (priv->rfs_entries_cnt[STMMAC_RFS_T_VLAN] >=
+	    priv->rfs_entries_max[STMMAC_RFS_T_VLAN])
+		return -ENOENT;
+
 	/* Nothing to do here */
 	if (!dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_VLAN))
 		return -EINVAL;
@@ -638,6 +693,12 @@ static int tc_add_vlan_flow(struct stmmac_priv *priv,
 
 		prio = BIT(match.key->vlan_priority);
 		stmmac_rx_queue_prio(priv, priv->hw, prio, tc);
+
+		entry->in_use = true;
+		entry->cookie = cls->cookie;
+		entry->tc = tc;
+		entry->type = STMMAC_RFS_T_VLAN;
+		priv->rfs_entries_cnt[STMMAC_RFS_T_VLAN]++;
 	}
 
 	return 0;
@@ -646,20 +707,19 @@ static int tc_add_vlan_flow(struct stmmac_priv *priv,
 static int tc_del_vlan_flow(struct stmmac_priv *priv,
 			    struct flow_cls_offload *cls)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
-	struct flow_dissector *dissector = rule->match.dissector;
-	int tc = tc_classid_to_hwtc(priv->dev, cls->classid);
+	struct stmmac_rfs_entry *entry = tc_find_rfs(priv, cls, false);
 
-	/* Nothing to do here */
-	if (!dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_VLAN))
-		return -EINVAL;
+	if (!entry || !entry->in_use || entry->type != STMMAC_RFS_T_VLAN)
+		return -ENOENT;
 
-	if (tc < 0) {
-		netdev_err(priv->dev, "Invalid traffic class\n");
-		return -EINVAL;
-	}
+	stmmac_rx_queue_prio(priv, priv->hw, 0, entry->tc);
+
+	entry->in_use = false;
+	entry->cookie = 0;
+	entry->tc = 0;
+	entry->type = 0;
 
-	stmmac_rx_queue_prio(priv, priv->hw, 0, tc);
+	priv->rfs_entries_cnt[STMMAC_RFS_T_VLAN]--;
 
 	return 0;
 }
-- 
2.33.0




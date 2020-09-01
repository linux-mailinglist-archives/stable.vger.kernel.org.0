Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FBD2596E9
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731352AbgIAQIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:08:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731454AbgIAPjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:39:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A45C1215A4;
        Tue,  1 Sep 2020 15:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974754;
        bh=rHpYPZN8zKFda+Wgttqg7RRIoWbptNBBTFiJ9g8isT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WG9oqrHnL2Ek0wy3PG7NNsHcrur5HF9jgQ86EX2asyWCTJESfbGIF6srkKG3cVjSJ
         Xt9uoIDBbry4sRpUFeqQ7KBf/YqV9YYiPHSl/a8NRiBWRepT1lW5LIt4t8iGCLAN5P
         iAXddA+tlYpCoQD9bFq8JGcITAh3QA0pXAgqQ92w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Johan=20Kn=C3=B6=C3=B6s?= <jknoos@google.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 078/255] net: openvswitch: introduce common code for flushing flows
Date:   Tue,  1 Sep 2020 17:08:54 +0200
Message-Id: <20200901151004.470266181@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

[ Upstream commit 1f3a090b9033f69de380c03db3ea1a1015c850cf ]

To avoid some issues, for example RCU usage warning and double free,
we should flush the flows under ovs_lock. This patch refactors
table_instance_destroy and introduces table_instance_flow_flush
which can be invoked by __dp_destroy or ovs_flow_tbl_flush.

Fixes: 50b0e61b32ee ("net: openvswitch: fix possible memleak on destroy flow-table")
Reported-by: Johan Knöös <jknoos@google.com>
Reported-at: https://mail.openvswitch.org/pipermail/ovs-discuss/2020-August/050489.html
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c   | 10 +++++++++-
 net/openvswitch/flow_table.c | 35 +++++++++++++++--------------------
 net/openvswitch/flow_table.h |  3 +++
 3 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 94b024534987a..03b81aa99975b 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1736,6 +1736,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 /* Called with ovs_mutex. */
 static void __dp_destroy(struct datapath *dp)
 {
+	struct flow_table *table = &dp->table;
 	int i;
 
 	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++) {
@@ -1754,7 +1755,14 @@ static void __dp_destroy(struct datapath *dp)
 	 */
 	ovs_dp_detach_port(ovs_vport_ovsl(dp, OVSP_LOCAL));
 
-	/* RCU destroy the flow table */
+	/* Flush sw_flow in the tables. RCU cb only releases resource
+	 * such as dp, ports and tables. That may avoid some issues
+	 * such as RCU usage warning.
+	 */
+	table_instance_flow_flush(table, ovsl_dereference(table->ti),
+				  ovsl_dereference(table->ufid_ti));
+
+	/* RCU destroy the ports, meters and flow tables. */
 	call_rcu(&dp->rcu, destroy_dp_rcu);
 }
 
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 2398d72383005..f198bbb0c517a 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -345,19 +345,15 @@ static void table_instance_flow_free(struct flow_table *table,
 	flow_mask_remove(table, flow->mask);
 }
 
-static void table_instance_destroy(struct flow_table *table,
-				   struct table_instance *ti,
-				   struct table_instance *ufid_ti,
-				   bool deferred)
+/* Must be called with OVS mutex held. */
+void table_instance_flow_flush(struct flow_table *table,
+			       struct table_instance *ti,
+			       struct table_instance *ufid_ti)
 {
 	int i;
 
-	if (!ti)
-		return;
-
-	BUG_ON(!ufid_ti);
 	if (ti->keep_flows)
-		goto skip_flows;
+		return;
 
 	for (i = 0; i < ti->n_buckets; i++) {
 		struct sw_flow *flow;
@@ -369,18 +365,16 @@ static void table_instance_destroy(struct flow_table *table,
 
 			table_instance_flow_free(table, ti, ufid_ti,
 						 flow, false);
-			ovs_flow_free(flow, deferred);
+			ovs_flow_free(flow, true);
 		}
 	}
+}
 
-skip_flows:
-	if (deferred) {
-		call_rcu(&ti->rcu, flow_tbl_destroy_rcu_cb);
-		call_rcu(&ufid_ti->rcu, flow_tbl_destroy_rcu_cb);
-	} else {
-		__table_instance_destroy(ti);
-		__table_instance_destroy(ufid_ti);
-	}
+static void table_instance_destroy(struct table_instance *ti,
+				   struct table_instance *ufid_ti)
+{
+	call_rcu(&ti->rcu, flow_tbl_destroy_rcu_cb);
+	call_rcu(&ufid_ti->rcu, flow_tbl_destroy_rcu_cb);
 }
 
 /* No need for locking this function is called from RCU callback or
@@ -393,7 +387,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
 
 	free_percpu(table->mask_cache);
 	kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
-	table_instance_destroy(table, ti, ufid_ti, false);
+	table_instance_destroy(ti, ufid_ti);
 }
 
 struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *ti,
@@ -511,7 +505,8 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
 	flow_table->count = 0;
 	flow_table->ufid_count = 0;
 
-	table_instance_destroy(flow_table, old_ti, old_ufid_ti, true);
+	table_instance_flow_flush(flow_table, old_ti, old_ufid_ti);
+	table_instance_destroy(old_ti, old_ufid_ti);
 	return 0;
 
 err_free_ti:
diff --git a/net/openvswitch/flow_table.h b/net/openvswitch/flow_table.h
index 8a5cea6ae1116..8ea8fc9573776 100644
--- a/net/openvswitch/flow_table.h
+++ b/net/openvswitch/flow_table.h
@@ -86,4 +86,7 @@ bool ovs_flow_cmp(const struct sw_flow *, const struct sw_flow_match *);
 
 void ovs_flow_mask_key(struct sw_flow_key *dst, const struct sw_flow_key *src,
 		       bool full, const struct sw_flow_mask *mask);
+void table_instance_flow_flush(struct flow_table *table,
+			       struct table_instance *ti,
+			       struct table_instance *ufid_ti);
 #endif /* flow_table.h */
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596AD869AE
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405117AbfHHTJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404325AbfHHTJl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:09:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D31E521743;
        Thu,  8 Aug 2019 19:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291380;
        bh=NLA8uB4IkB5BZV/dvjoMFgolmyyf+jZGSpTIoXzWwj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbFFCzZsm8DFFks/F4bipGt88dm1G/RTwzfUdOOvMovaF1GMeTAEoSYTEctaKeaRx
         ko8MTkrbhAg26FWUsVtu8DpqXbmM9/FO6hUwcHINPzOKUwligvWUh7afZ5cW/d8ELd
         Gvt95jEaXA2vRee1NjsQmr8Dh+v19BtcQf7kz2to=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Levkovich <lariel@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 37/45] net/mlx5e: Prevent encap flow counter update async to user query
Date:   Thu,  8 Aug 2019 21:05:23 +0200
Message-Id: <20190808190455.919986465@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

[ Upstream commit 90bb769291161cf25a818d69cf608c181654473e ]

This patch prevents a race between user invoked cached counters
query and a neighbor last usage updater.

The cached flow counter stats can be queried by calling
"mlx5_fc_query_cached" which provides the number of bytes and
packets that passed via this flow since the last time this counter
was queried.
It does so by reducting the last saved stats from the current, cached
stats and then updating the last saved stats with the cached stats.
It also provide the lastuse value for that flow.

Since "mlx5e_tc_update_neigh_used_value" needs to retrieve the
last usage time of encapsulation flows, it calls the flow counter
query method periodically and async to user queries of the flow counter
using cls_flower.
This call is causing the driver to update the last reported bytes and
packets from the cache and therefore, future user queries of the flow
stats will return lower than expected number for bytes and packets
since the last saved stats in the driver was updated async to the last
saved stats in cls_flower.

This causes wrong stats presentation of encapsulation flows to user.

Since the neighbor usage updater only needs the lastuse stats from the
cached counter, the fix is to use a dedicated lastuse query call that
returns the lastuse value without synching between the cached stats and
the last saved stats.

Fixes: f6dfb4c3f216 ("net/mlx5e: Update neighbour 'used' state using HW flow rules counters")
Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c       |    4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c |    5 +++++
 include/linux/mlx5/fs.h                               |    1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -992,13 +992,13 @@ void mlx5e_tc_encap_flows_del(struct mlx
 void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe)
 {
 	struct mlx5e_neigh *m_neigh = &nhe->m_neigh;
-	u64 bytes, packets, lastuse = 0;
 	struct mlx5e_tc_flow *flow;
 	struct mlx5e_encap_entry *e;
 	struct mlx5_fc *counter;
 	struct neigh_table *tbl;
 	bool neigh_used = false;
 	struct neighbour *n;
+	u64 lastuse;
 
 	if (m_neigh->family == AF_INET)
 		tbl = &arp_tbl;
@@ -1015,7 +1015,7 @@ void mlx5e_tc_update_neigh_used_value(st
 		list_for_each_entry(flow, &e->flows, encap) {
 			if (flow->flags & MLX5E_TC_FLOW_OFFLOADED) {
 				counter = mlx5_flow_rule_counter(flow->rule[0]);
-				mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
+				lastuse = mlx5_fc_query_lastuse(counter);
 				if (time_after((unsigned long)lastuse, nhe->reported_lastuse)) {
 					neigh_used = true;
 					break;
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -321,6 +321,11 @@ int mlx5_fc_query(struct mlx5_core_dev *
 }
 EXPORT_SYMBOL(mlx5_fc_query);
 
+u64 mlx5_fc_query_lastuse(struct mlx5_fc *counter)
+{
+	return counter->cache.lastuse;
+}
+
 void mlx5_fc_query_cached(struct mlx5_fc *counter,
 			  u64 *bytes, u64 *packets, u64 *lastuse)
 {
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -188,6 +188,7 @@ int mlx5_modify_rule_destination(struct
 struct mlx5_fc *mlx5_flow_rule_counter(struct mlx5_flow_handle *handler);
 struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *dev, bool aging);
 void mlx5_fc_destroy(struct mlx5_core_dev *dev, struct mlx5_fc *counter);
+u64 mlx5_fc_query_lastuse(struct mlx5_fc *counter);
 void mlx5_fc_query_cached(struct mlx5_fc *counter,
 			  u64 *bytes, u64 *packets, u64 *lastuse);
 int mlx5_fc_query(struct mlx5_core_dev *dev, struct mlx5_fc *counter,



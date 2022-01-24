Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D32C49A05E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1843880AbiAXXGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842521AbiAXXCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:02:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581AAC0F056A;
        Mon, 24 Jan 2022 13:14:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E6A4B8121C;
        Mon, 24 Jan 2022 21:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8D4C340E5;
        Mon, 24 Jan 2022 21:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058853;
        bh=OGsdVaPezskp5mjEzTrgfcvbp3YBX8bYP96/p792fYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JFrxbz8YkMS9Ol77eGSzCIi+z6N7W7KKHQkbmLEtvhXLTR7E8n2Hy22ALDA23UqJ6
         EPLPFWBfPgEcbDHsTkdLG280xnPAhXdbm0/kkNqlEQPU46G978q7s2LsHVi8+uw6gp
         pskIPPda9GdAwV1PNX0iUUneElgsRv2Rf0YOITYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0406/1039] net/mlx5e: Fix nullptr on deleting mirroring rule
Date:   Mon, 24 Jan 2022 19:36:35 +0100
Message-Id: <20220124184138.959724358@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

[ Upstream commit de31854ece175e12ff3c35d07f340988823aed34 ]

Deleting a Tc rule with multiple outputs, one of which is internal port,
like this one:

  tc filter del dev enp8s0f0_0 ingress protocol ip pref 5 flower \
      dst_mac 0c:42:a1:d1:d0:88 \
      src_mac e4:ea:09:08:00:02 \
      action tunnel_key  set \
          src_ip 0.0.0.0 \
          dst_ip 7.7.7.8 \
          id 8 \
          dst_port 4789 \
      action mirred egress mirror dev vxlan_sys_4789 pipe \
      action mirred egress redirect dev enp8s0f0_1

Triggers a call trace:

  BUG: kernel NULL pointer dereference, address: 0000000000000230
  RIP: 0010:del_sw_hw_rule+0x2b/0x1f0 [mlx5_core]
  Call Trace:
   tree_remove_node+0x16/0x30 [mlx5_core]
   mlx5_del_flow_rules+0x51/0x160 [mlx5_core]
   __mlx5_eswitch_del_rule+0x4b/0x170 [mlx5_core]
   mlx5e_tc_del_fdb_flow+0x295/0x550 [mlx5_core]
   mlx5e_flow_put+0x1f/0x70 [mlx5_core]
   mlx5e_delete_flower+0x286/0x390 [mlx5_core]
   tc_setup_cb_destroy+0xac/0x170
   fl_hw_destroy_filter+0x94/0xc0 [cls_flower]
   __fl_delete+0x15e/0x170 [cls_flower]
   fl_delete+0x36/0x80 [cls_flower]
   tc_del_tfilter+0x3a6/0x6e0
   rtnetlink_rcv_msg+0xe5/0x360
   ? rtnl_calcit.isra.0+0x110/0x110
   netlink_rcv_skb+0x46/0x110
   netlink_unicast+0x16b/0x200
   netlink_sendmsg+0x202/0x3d0
   sock_sendmsg+0x33/0x40
   ____sys_sendmsg+0x1c3/0x200
   ? copy_msghdr_from_user+0xd6/0x150
   ___sys_sendmsg+0x88/0xd0
   ? ___sys_recvmsg+0x88/0xc0
   ? do_futex+0x10c/0x460
   __sys_sendmsg+0x59/0xa0
   do_syscall_64+0x48/0x140
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix by disabling offloading for flows matching
esw_is_chain_src_port_rewrite() which have more than one output.

Fixes: 10742efc20a4 ("net/mlx5e: VF tunnel TX traffic offloading")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 28 ++++++++++---------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 32bc08a399256..ccb66428aeb5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -295,26 +295,28 @@ esw_setup_chain_src_port_rewrite(struct mlx5_flow_destination *dest,
 				 int *i)
 {
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
-	int j, err;
+	int err;
 
 	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SRC_REWRITE))
 		return -EOPNOTSUPP;
 
-	for (j = esw_attr->split_count; j < esw_attr->out_count; j++, (*i)++) {
-		err = esw_setup_chain_dest(dest, flow_act, chains, attr->dest_chain, 1, 0, *i);
-		if (err)
-			goto err_setup_chain;
+	/* flow steering cannot handle more than one dest with the same ft
+	 * in a single flow
+	 */
+	if (esw_attr->out_count - esw_attr->split_count > 1)
+		return -EOPNOTSUPP;
 
-		if (esw_attr->dests[j].pkt_reformat) {
-			flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
-			flow_act->pkt_reformat = esw_attr->dests[j].pkt_reformat;
-		}
+	err = esw_setup_chain_dest(dest, flow_act, chains, attr->dest_chain, 1, 0, *i);
+	if (err)
+		return err;
+
+	if (esw_attr->dests[esw_attr->split_count].pkt_reformat) {
+		flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+		flow_act->pkt_reformat = esw_attr->dests[esw_attr->split_count].pkt_reformat;
 	}
-	return 0;
+	(*i)++;
 
-err_setup_chain:
-	esw_put_dest_tables_loop(esw, attr, esw_attr->split_count, j);
-	return err;
+	return 0;
 }
 
 static void esw_cleanup_chain_src_port_rewrite(struct mlx5_eswitch *esw,
-- 
2.34.1




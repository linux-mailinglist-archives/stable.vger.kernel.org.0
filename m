Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F0930C060
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbhBBN4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:56:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233213AbhBBNyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:54:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5424364FD4;
        Tue,  2 Feb 2021 13:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273471;
        bh=x+wDE0fwjFkU079h0WsF+Ba3kj6o356Fl0qq9z21m7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3W5fGfHrMH69oy2FIz3/we0mpun3IxSWUCexxaeof0D5zl+FEptMnMUGMiAdGxJX
         5Q2i8OWrgOHwctpNfHGSNTX5VzSR3VazbX6bcl2aqevx5H13KScYcMt5TlyC+Vcbut
         fi1T+R9ALWujY+yoqWxzQRB98MMAw7btTl+PSetM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/142] net/mlx5e: Fix CT rule + encap slow path offload and deletion
Date:   Tue,  2 Feb 2021 14:38:03 +0100
Message-Id: <20210202133002.661037364@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

[ Upstream commit 89e394675818bde8e30e135611c506455fa03fb7 ]

Currently, if a neighbour isn't valid when offloading tunnel encap rules,
we offload the original match and replace the original action with
"goto slow path" action. For this we use a temporary flow attribute based
on the original flow attribute and then change the action. Flow flags,
which among those is the CT flag, are still shared for the slow path rule
offload, so we end up parsing this flow as a CT + goto slow path rule.

Besides being unnecessary, CT action offload saves extra information in
the passed flow attribute, such as created ct_flow and mod_hdr, which
is lost onces the temporary flow attribute is freed.

When a neigh is updated and is valid, we offload the original CT rule
with original CT action, which again creates a ct_flow and mod_hdr
and saves it in the flow's original attribute. Then we delete the slow
path rule with a temporary flow attribute based on original updated
flow attribute, and we free the relevant ct_flow and mod_hdr.

Then when tc deletes this flow, we try to free the ct_flow and mod_hdr
on the flow's attribute again.

To fix the issue, skip all furture proccesing (CT/Sample/Split rules)
in offload/unoffload of slow path rules.

Call trace:
[  758.850525] Unable to handle kernel NULL pointer dereference at virtual =
address 0000000000000218
[  758.952987] Internal error: Oops: 96000005 [#1] PREEMPT SMP
[  758.964170] Modules linked in: act_csum(E) act_pedit(E) act_tunnel_key(E=
) act_ct(E) nf_flow_table(E) xt_nat(E) ip6table_filter(E) ip6table_nat(E) x=
t_comment(E) ip6_tables(E) xt_conntrack(E) xt_MASQUERADE(E) nf_conntrack_ne=
tlink(E) xt_addrtype(E) iptable_filter(E) iptable_nat(E) bpfilter(E) br_net=
filter(E) bridge(E) stp(E) llc(E) xfrm_user(E) overlay(E) act_mirred(E) act=
_skbedit(E) rdma_ucm(OE) rdma_cm(OE) iw_cm(OE) ib_ipoib(OE) ib_cm(OE) ib_um=
ad(OE) esp6_offload(E) esp6(E) esp4_offload(E) esp4(E) xfrm_algo(E) mlx5_ib=
(OE) ib_uverbs(OE) geneve(E) ip6_udp_tunnel(E) udp_tunnel(E) nfnetlink_ctti=
meout(E) nfnetlink(E) mlx5_core(OE) act_gact(E) cls_flower(E) sch_ingress(E=
) openvswitch(E) nsh(E) nf_conncount(E) nf_nat(E) mlxfw(OE) psample(E) nf_c=
onntrack(E) nf_defrag_ipv4(E) vfio_mdev(E) mdev(E) ib_core(OE) mlx_compat(O=
E) crct10dif_ce(E) uio_pdrv_genirq(E) uio(E) i2c_mlx(E) mlxbf_pmc(E) sbsa_g=
wdt(E) mlxbf_gige(E) gpio_mlxbf2(E) mlxbf_pka(E) mlx_trio(E) mlx_bootctl(E)=
 bluefield_edac(E) knem(O)
[  758.964225]  ip_tables(E) mlxbf_tmfifo(E) ipv6(E) crc_ccitt(E) nf_defrag=
_ipv6(E)
[  759.154186] CPU: 5 PID: 122 Comm: kworker/u16:1 Tainted: G           OE =
    5.4.60-mlnx.52.gde81e85 #1
[  759.172870] Hardware name: https://www.mellanox.com BlueField SoC/BlueFi=
eld SoC, BIOS BlueField:3.5.0-2-gc1b5d64 Jan  4 2021
[  759.195466] Workqueue: mlx5e mlx5e_rep_neigh_update [mlx5_core]
[  759.207344] pstate: a0000005 (NzCv daif -PAN -UAO)
[  759.217003] pc : mlx5_del_flow_rules+0x5c/0x160 [mlx5_core]
[  759.228229] lr : mlx5_del_flow_rules+0x34/0x160 [mlx5_core]
[  759.405858] Call trace:
[  759.410804]  mlx5_del_flow_rules+0x5c/0x160 [mlx5_core]
[  759.421337]  __mlx5_eswitch_del_rule.isra.43+0x5c/0x1c8 [mlx5_core]
[  759.433963]  mlx5_eswitch_del_offloaded_rule_ct+0x34/0x40 [mlx5_core]
[  759.446942]  mlx5_tc_rule_delete_ct+0x68/0x74 [mlx5_core]
[  759.457821]  mlx5_tc_ct_delete_flow+0x160/0x21c [mlx5_core]
[  759.469051]  mlx5e_tc_unoffload_fdb_rules+0x158/0x168 [mlx5_core]
[  759.481325]  mlx5e_tc_encap_flows_del+0x140/0x26c [mlx5_core]
[  759.492901]  mlx5e_rep_update_flows+0x11c/0x1ec [mlx5_core]
[  759.504127]  mlx5e_rep_neigh_update+0x160/0x200 [mlx5_core]
[  759.515314]  process_one_work+0x178/0x400
[  759.523350]  worker_thread+0x58/0x3e8
[  759.530685]  kthread+0x100/0x12c
[  759.537152]  ret_from_fork+0x10/0x18
[  759.544320] Code: 97ffef55 51000673 3100067f 54ffff41 (b9421ab3)
[  759.556548] ---[ end trace fab818bb1085832d ]---

Fixes: 4c3844d9e97e ("net/mlx5e: CT: Introduce connection tracking")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 3be34b1128731..4b8a442f09cd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1165,6 +1165,9 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts;
 	struct mlx5_flow_handle *rule;
=20
+	if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)
+		return mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
+
 	if (flow_flag_test(flow, CT)) {
 		mod_hdr_acts =3D &attr->parse_attr->mod_hdr_acts;
=20
@@ -1195,6 +1198,9 @@ mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 {
 	flow_flag_clear(flow, OFFLOADED);
=20
+	if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)
+		goto offload_rule_0;
+
 	if (flow_flag_test(flow, CT)) {
 		mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), flow, attr);
 		return;
@@ -1203,6 +1209,7 @@ mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 	if (attr->esw_attr->split_count)
 		mlx5_eswitch_del_fwd_rule(esw, flow->rule[1], attr);
=20
+offload_rule_0:
 	mlx5_eswitch_del_offloaded_rule(esw, flow->rule[0], attr);
 }
=20
--=20
2.27.0




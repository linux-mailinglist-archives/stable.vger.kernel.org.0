Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5EB16C18DE
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbjCTP2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbjCTP1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:27:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0407637F28
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:20:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C9EAB80EC4
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7286DC433D2;
        Mon, 20 Mar 2023 15:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325654;
        bh=j9JQ7MKoQW35uuvaBnhBuugdbkwyTkuQTEK0AH1WmRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXbop+/EoFIEWf28EYg8a4l3ZbdcJ8IxyT1e57ffbv/viOu5c/OnXaPMdKhdrKkWg
         cOPMBfnNedV5JRS51nXNXKYvJkkWM6KDvbwQoOTaiEovG5IDvI30i+k6rZnUDJKT9z
         /p46otrtXR9K6a+2Rynpy5Y2Fv7rrfl04YfzpMaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Blakey <paulb@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 077/211] net/mlx5e: Fix cleanup null-ptr deref on encap lock
Date:   Mon, 20 Mar 2023 15:53:32 +0100
Message-Id: <20230320145516.502146267@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

[ Upstream commit c9668f0b1d28570327dbba189f2c61f6f9e43ae7 ]

During module is unloaded while a peer tc flow is still offloaded,
first the peer uplink rep profile is changed to a nic profile, and so
neigh encap lock is destroyed. Next during unload, the VF reps netdevs
are unregistered which causes the original non-peer tc flow to be deleted,
which deletes the peer flow. The peer flow deletion detaches the encap
entry and try to take the already destroyed encap lock, causing the
below trace.

Fix this by clearing peer flows during tc eswitch cleanup
(mlx5e_tc_esw_cleanup()).

Relevant trace:
[ 4316.837128] BUG: kernel NULL pointer dereference, address: 00000000000001d8
[ 4316.842239] RIP: 0010:__mutex_lock+0xb5/0xc40
[ 4316.851897] Call Trace:
[ 4316.852481]  <TASK>
[ 4316.857214]  mlx5e_rep_neigh_entry_release+0x93/0x790 [mlx5_core]
[ 4316.858258]  mlx5e_rep_encap_entry_detach+0xa7/0xf0 [mlx5_core]
[ 4316.859134]  mlx5e_encap_dealloc+0xa3/0xf0 [mlx5_core]
[ 4316.859867]  clean_encap_dests.part.0+0x5c/0xe0 [mlx5_core]
[ 4316.860605]  mlx5e_tc_del_fdb_flow+0x32a/0x810 [mlx5_core]
[ 4316.862609]  __mlx5e_tc_del_fdb_peer_flow+0x1a2/0x250 [mlx5_core]
[ 4316.863394]  mlx5e_tc_del_flow+0x(/0x630 [mlx5_core]
[ 4316.864090]  mlx5e_flow_put+0x5f/0x100 [mlx5_core]
[ 4316.864771]  mlx5e_delete_flower+0x4de/0xa40 [mlx5_core]
[ 4316.865486]  tc_setup_cb_reoffload+0x20/0x80
[ 4316.865905]  fl_reoffload+0x47c/0x510 [cls_flower]
[ 4316.869181]  tcf_block_playback_offloads+0x91/0x1d0
[ 4316.869649]  tcf_block_unbind+0xe7/0x1b0
[ 4316.870049]  tcf_block_offload_cmd.isra.0+0x1ee/0x270
[ 4316.879266]  tcf_block_offload_unbind+0x61/0xa0
[ 4316.879711]  __tcf_block_put+0xa4/0x310

Fixes: 04de7dda7394 ("net/mlx5e: Infrastructure for duplicated offloading of TC flows")
Fixes: 1418ddd96afd ("net/mlx5e: Duplicate offloaded TC eswitch rules under uplink LAG")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 6a07242b5d5ef..c209e89ba9abe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5374,6 +5374,16 @@ int mlx5e_tc_esw_init(struct mlx5_rep_uplink_priv *uplink_priv)
 
 void mlx5e_tc_esw_cleanup(struct mlx5_rep_uplink_priv *uplink_priv)
 {
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5_eswitch *esw;
+	struct mlx5e_priv *priv;
+
+	rpriv = container_of(uplink_priv, struct mlx5e_rep_priv, uplink_priv);
+	priv = netdev_priv(rpriv->netdev);
+	esw = priv->mdev->priv.eswitch;
+
+	mlx5e_tc_clean_fdb_peer_flows(esw);
+
 	mlx5e_tc_tun_cleanup(uplink_priv->encap);
 
 	mapping_destroy(uplink_priv->tunnel_enc_opts_mapping);
-- 
2.39.2




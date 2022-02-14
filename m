Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8294B4705
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244654AbiBNJmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:42:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244982AbiBNJlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:41:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D3AA180;
        Mon, 14 Feb 2022 01:36:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7160FB80DC1;
        Mon, 14 Feb 2022 09:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD08C340E9;
        Mon, 14 Feb 2022 09:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831402;
        bh=58gI0e6D4njHp3OsvDHgFB/2Mhd52nJk97S2CzjoBQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRV2aoTnjuxcw9fjNosb1MAtTW/TD57ybUSv9b3DR9L0QgwHKhV4klZZboDoovOzs
         +P6KDHy9ADiccAitFlmYLGKhOiFOiyL5KRM0knmj8TgUsuIeeKtF9rJnAIulhXIWEr
         usAJjq+o8OH4CzjchBfgl3VZj+C0YIM/Rt4wuCz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 43/71] nfp: flower: fix ida_idx not being released
Date:   Mon, 14 Feb 2022 10:26:11 +0100
Message-Id: <20220214092453.497160787@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

[ Upstream commit 7db788ad627aabff2b74d4f1a3b68516d0fee0d7 ]

When looking for a global mac index the extra NFP_TUN_PRE_TUN_IDX_BIT
that gets set if nfp_flower_is_supported_bridge is true is not taken
into account. Consequently the path that should release the ida_index
in cleanup is never triggered, causing messages like:

    nfp 0000:02:00.0: nfp: Failed to offload MAC on br-ex.
    nfp 0000:02:00.0: nfp: Failed to offload MAC on br-ex.
    nfp 0000:02:00.0: nfp: Failed to offload MAC on br-ex.

after NFP_MAX_MAC_INDEX number of reconfigs. Ultimately this lead to
new tunnel flows not being offloaded.

Fix this by unsetting the NFP_TUN_PRE_TUN_IDX_BIT before checking if
the port is of type OTHER.

Fixes: 2e0bc7f3cb55 ("nfp: flower: encode mac indexes with pre-tunnel rule check")
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20220208101453.321949-1-simon.horman@corigine.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/netronome/nfp/flower/tunnel_conf.c  | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 2600ce476d6b2..f8c8451919cb6 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -677,6 +677,7 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 	struct nfp_flower_repr_priv *repr_priv;
 	struct nfp_tun_offloaded_mac *entry;
 	struct nfp_repr *repr;
+	u16 nfp_mac_idx;
 	int ida_idx;
 
 	entry = nfp_tunnel_lookup_offloaded_macs(app, mac);
@@ -695,8 +696,6 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 		entry->bridge_count--;
 
 		if (!entry->bridge_count && entry->ref_count) {
-			u16 nfp_mac_idx;
-
 			nfp_mac_idx = entry->index & ~NFP_TUN_PRE_TUN_IDX_BIT;
 			if (__nfp_tunnel_offload_mac(app, mac, nfp_mac_idx,
 						     false)) {
@@ -712,7 +711,6 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 
 	/* If MAC is now used by 1 repr set the offloaded MAC index to port. */
 	if (entry->ref_count == 1 && list_is_singular(&entry->repr_list)) {
-		u16 nfp_mac_idx;
 		int port, err;
 
 		repr_priv = list_first_entry(&entry->repr_list,
@@ -740,8 +738,14 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 	WARN_ON_ONCE(rhashtable_remove_fast(&priv->tun.offloaded_macs,
 					    &entry->ht_node,
 					    offloaded_macs_params));
+
+	if (nfp_flower_is_supported_bridge(netdev))
+		nfp_mac_idx = entry->index & ~NFP_TUN_PRE_TUN_IDX_BIT;
+	else
+		nfp_mac_idx = entry->index;
+
 	/* If MAC has global ID then extract and free the ida entry. */
-	if (nfp_tunnel_is_mac_idx_global(entry->index)) {
+	if (nfp_tunnel_is_mac_idx_global(nfp_mac_idx)) {
 		ida_idx = nfp_tunnel_get_ida_from_global_mac_idx(entry->index);
 		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
 	}
-- 
2.34.1




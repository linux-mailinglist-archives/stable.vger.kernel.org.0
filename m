Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4240B34C8A7
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhC2IXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233923AbhC2IWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:22:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA43A61554;
        Mon, 29 Mar 2021 08:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006156;
        bh=gPcEVq23ZcHljHYJI94dgaVJ7RvY85qJGeXSIOVsoOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cgyts4gmh71KsbHLzTaka3Uv2DyJt78sSdClNTPOfjsO0OcvkNqwtmZf6OHvrD7B5
         SXl1xnAbSVt34jymqGZRxZri82b/b4kYjjFmgJdzY2G0btziUPjgUVPMV9q1TffDxX
         PbB8ZuWosVdaB6fDXGWvhD58Wv4OihHY3poV00RY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/221] nfp: flower: add ipv6 bit to pre_tunnel control message
Date:   Mon, 29 Mar 2021 09:57:48 +0200
Message-Id: <20210329075633.753358228@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

[ Upstream commit 5c4f5e19d6a8e159127b9d653bb67e0dc7a28047 ]

Differentiate between ipv4 and ipv6 flows when configuring the pre_tunnel
table to prevent them trampling each other in the table.

Fixes: 783461604f7e ("nfp: flower: update flow merge code to support IPv6 tunnels")
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/netronome/nfp/flower/tunnel_conf.c   | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 7248d248f604..d19c02e99114 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -16,8 +16,9 @@
 #define NFP_FL_MAX_ROUTES               32
 
 #define NFP_TUN_PRE_TUN_RULE_LIMIT	32
-#define NFP_TUN_PRE_TUN_RULE_DEL	0x1
-#define NFP_TUN_PRE_TUN_IDX_BIT		0x8
+#define NFP_TUN_PRE_TUN_RULE_DEL	BIT(0)
+#define NFP_TUN_PRE_TUN_IDX_BIT		BIT(3)
+#define NFP_TUN_PRE_TUN_IPV6_BIT	BIT(7)
 
 /**
  * struct nfp_tun_pre_run_rule - rule matched before decap
@@ -1268,6 +1269,7 @@ int nfp_flower_xmit_pre_tun_flow(struct nfp_app *app,
 {
 	struct nfp_flower_priv *app_priv = app->priv;
 	struct nfp_tun_offloaded_mac *mac_entry;
+	struct nfp_flower_meta_tci *key_meta;
 	struct nfp_tun_pre_tun_rule payload;
 	struct net_device *internal_dev;
 	int err;
@@ -1290,6 +1292,15 @@ int nfp_flower_xmit_pre_tun_flow(struct nfp_app *app,
 	if (!mac_entry)
 		return -ENOENT;
 
+	/* Set/clear IPV6 bit. cpu_to_be16() swap will lead to MSB being
+	 * set/clear for port_idx.
+	 */
+	key_meta = (struct nfp_flower_meta_tci *)flow->unmasked_data;
+	if (key_meta->nfp_flow_key_layer & NFP_FLOWER_LAYER_IPV6)
+		mac_entry->index |= NFP_TUN_PRE_TUN_IPV6_BIT;
+	else
+		mac_entry->index &= ~NFP_TUN_PRE_TUN_IPV6_BIT;
+
 	payload.port_idx = cpu_to_be16(mac_entry->index);
 
 	/* Copy mac id and vlan to flow - dev may not exist at delete time. */
-- 
2.30.1




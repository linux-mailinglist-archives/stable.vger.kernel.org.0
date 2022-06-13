Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF3B548795
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359542AbiFMNNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359589AbiFMNKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:10:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8A53AA58;
        Mon, 13 Jun 2022 04:21:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2D5ADCE1171;
        Mon, 13 Jun 2022 11:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45884C341D3;
        Mon, 13 Jun 2022 11:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119267;
        bh=vpAiBeDXWQczzpom4u48tQbqC1+qGpXGcbN52ULIeBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FCgmtspiNtHW7hLDH1GEnCK/NjMUxT7F0+678+RvoeLfgCXerOdqqMj6bhpnOy7mn
         VCCtDGMh+ZRj8Nbf0uBorwL9KpGC6nY8giw0PaV9XFIHE2kuj6Q17LLxiPeav4k19k
         CTvJduo4p3AaVsadDenRhxLTY64I8pzcrsnPm10Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Etienne van der Linde <etienne.vanderlinde@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/247] nfp: flower: restructure flow-key for gre+vlan combination
Date:   Mon, 13 Jun 2022 12:11:05 +0200
Message-Id: <20220613094927.901747433@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Etienne van der Linde <etienne.vanderlinde@corigine.com>

[ Upstream commit a0b843340dae704e17c1ddfad0f85c583c36757f ]

Swap around the GRE and VLAN parts in the flow-key offloaded by
the driver to fit in with other tunnel types and the firmware.
Without this change used cases with GRE+VLAN on the outer header
does not get offloaded as the flow-key mismatches what the
firmware expect.

Fixes: 0d630f58989a ("nfp: flower: add support to offload QinQ match")
Fixes: 5a2b93041646 ("nfp: flower-ct: compile match sections of flow_payload")
Signed-off-by: Etienne van der Linde <etienne.vanderlinde@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 32 +++++++++----------
 .../net/ethernet/netronome/nfp/flower/match.c | 16 +++++-----
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index bfd7d1c35076..7e9fcc16286e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -442,6 +442,11 @@ nfp_fl_calc_key_layers_sz(struct nfp_fl_key_ls in_key_ls, uint16_t *map)
 		key_size += sizeof(struct nfp_flower_ipv6);
 	}
 
+	if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_QINQ) {
+		map[FLOW_PAY_QINQ] = key_size;
+		key_size += sizeof(struct nfp_flower_vlan);
+	}
+
 	if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_GRE) {
 		map[FLOW_PAY_GRE] = key_size;
 		if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6)
@@ -450,11 +455,6 @@ nfp_fl_calc_key_layers_sz(struct nfp_fl_key_ls in_key_ls, uint16_t *map)
 			key_size += sizeof(struct nfp_flower_ipv4_gre_tun);
 	}
 
-	if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_QINQ) {
-		map[FLOW_PAY_QINQ] = key_size;
-		key_size += sizeof(struct nfp_flower_vlan);
-	}
-
 	if ((in_key_ls.key_layer & NFP_FLOWER_LAYER_VXLAN) ||
 	    (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_GENEVE)) {
 		map[FLOW_PAY_UDP_TUN] = key_size;
@@ -693,6 +693,17 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 		}
 	}
 
+	if (NFP_FLOWER_LAYER2_QINQ & key_layer.key_layer_two) {
+		offset = key_map[FLOW_PAY_QINQ];
+		key = kdata + offset;
+		msk = mdata + offset;
+		for (i = 0; i < _CT_TYPE_MAX; i++) {
+			nfp_flower_compile_vlan((struct nfp_flower_vlan *)key,
+						(struct nfp_flower_vlan *)msk,
+						rules[i]);
+		}
+	}
+
 	if (key_layer.key_layer_two & NFP_FLOWER_LAYER2_GRE) {
 		offset = key_map[FLOW_PAY_GRE];
 		key = kdata + offset;
@@ -733,17 +744,6 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 		}
 	}
 
-	if (NFP_FLOWER_LAYER2_QINQ & key_layer.key_layer_two) {
-		offset = key_map[FLOW_PAY_QINQ];
-		key = kdata + offset;
-		msk = mdata + offset;
-		for (i = 0; i < _CT_TYPE_MAX; i++) {
-			nfp_flower_compile_vlan((struct nfp_flower_vlan *)key,
-						(struct nfp_flower_vlan *)msk,
-						rules[i]);
-		}
-	}
-
 	if (key_layer.key_layer & NFP_FLOWER_LAYER_VXLAN ||
 	    key_layer.key_layer_two & NFP_FLOWER_LAYER2_GENEVE) {
 		offset = key_map[FLOW_PAY_UDP_TUN];
diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index 9d86eea4dc16..fb8bd2135c63 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -602,6 +602,14 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 		msk += sizeof(struct nfp_flower_ipv6);
 	}
 
+	if (NFP_FLOWER_LAYER2_QINQ & key_ls->key_layer_two) {
+		nfp_flower_compile_vlan((struct nfp_flower_vlan *)ext,
+					(struct nfp_flower_vlan *)msk,
+					rule);
+		ext += sizeof(struct nfp_flower_vlan);
+		msk += sizeof(struct nfp_flower_vlan);
+	}
+
 	if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_GRE) {
 		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6) {
 			struct nfp_flower_ipv6_gre_tun *gre_match;
@@ -637,14 +645,6 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 		}
 	}
 
-	if (NFP_FLOWER_LAYER2_QINQ & key_ls->key_layer_two) {
-		nfp_flower_compile_vlan((struct nfp_flower_vlan *)ext,
-					(struct nfp_flower_vlan *)msk,
-					rule);
-		ext += sizeof(struct nfp_flower_vlan);
-		msk += sizeof(struct nfp_flower_vlan);
-	}
-
 	if (key_ls->key_layer & NFP_FLOWER_LAYER_VXLAN ||
 	    key_ls->key_layer_two & NFP_FLOWER_LAYER2_GENEVE) {
 		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6) {
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15C337CE82
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344966AbhELRF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239537AbhELQpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:45:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 320D960FD9;
        Wed, 12 May 2021 16:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836069;
        bh=yMQZhlX4dWqu9jmbp5K1wfn5gFNBNWmXu20lJFC9VzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7MDiisnOcFddOcUo3jC9S22B7CQlIFyhaF2FKOmaM5q9+QoL23dzJo5q72qmzzBu
         MAXQWzCBsPreFm/GNf2ZZWDn8b4aAkScbb6TXHauuhVWtTGDHg+lXAHHt6gIWM66YD
         UB5IqU66tZmgpfLVtvY+LmZmNleIG56Kc2sdSzxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 596/677] netfilter: nft_payload: fix C-VLAN offload support
Date:   Wed, 12 May 2021 16:50:42 +0200
Message-Id: <20210512144857.175888484@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 14c20643ef9457679cc6934d77adc24296505214 ]

- add another struct flow_dissector_key_vlan for C-VLAN
- update layer 3 dependency to allow to match on IPv4/IPv6

Fixes: 89d8fd44abfb ("netfilter: nft_payload: add C-VLAN offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables_offload.h | 1 +
 net/netfilter/nft_payload.c               | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 1d34fe154fe0..b4d080061399 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -45,6 +45,7 @@ struct nft_flow_key {
 	struct flow_dissector_key_ports			tp;
 	struct flow_dissector_key_ip			ip;
 	struct flow_dissector_key_vlan			vlan;
+	struct flow_dissector_key_vlan			cvlan;
 	struct flow_dissector_key_eth_addrs		eth_addrs;
 	struct flow_dissector_key_meta			meta;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index cb1c8c231880..a990f37e0a60 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -241,7 +241,7 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
-		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, vlan,
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, cvlan,
 				  vlan_tci, sizeof(__be16), reg);
 		break;
 	case offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto) +
@@ -249,8 +249,9 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
-		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, vlan,
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, cvlan,
 				  vlan_tpid, sizeof(__be16), reg);
+		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_NETWORK);
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65627548D74
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359208AbiFMNMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359241AbiFMNJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:09:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903C438D9D;
        Mon, 13 Jun 2022 04:19:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41798B80D3A;
        Mon, 13 Jun 2022 11:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A24C34114;
        Mon, 13 Jun 2022 11:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119175;
        bh=Kl2cQXD6MH1wMqc3KYtkdQI0IpPb9iAE6Fo4dSkB0U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6APEznenkr4UDxD6QLcceqp74rP1HbsmZtQvxb64hbjEXaYcnwuSXO/Kz9ozT6+t
         M4/e9Nrus/7Ror4KvXi1Cz0CF0qDdAqcZkf4O57ps4nnY2CrDofCZFawXRnCamLmHR
         UeXoC5vbu9K6wSz1GsuNHBtl9JuRKtGAR+MNYqqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/247] netfilter: nf_tables: bail out early if hardware offload is not supported
Date:   Mon, 13 Jun 2022 12:10:43 +0200
Message-Id: <20220613094927.232000525@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 3a41c64d9c1185a2f3a184015e2a9b78bfc99c71 ]

If user requests for NFT_CHAIN_HW_OFFLOAD, then check if either device
provides the .ndo_setup_tc interface or there is an indirect flow block
that has been registered. Otherwise, bail out early from the preparation
phase. Moreover, validate that family == NFPROTO_NETDEV and hook is
NF_NETDEV_INGRESS.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/flow_offload.h                |  1 +
 include/net/netfilter/nf_tables_offload.h |  2 +-
 net/core/flow_offload.c                   |  6 ++++++
 net/netfilter/nf_tables_api.c             |  2 +-
 net/netfilter/nf_tables_offload.c         | 23 ++++++++++++++++++++++-
 5 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 3961461d9c8b..7a2b0223a02c 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -575,5 +575,6 @@ int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
 				enum tc_setup_type type, void *data,
 				struct flow_block_offload *bo,
 				void (*cleanup)(struct flow_block_cb *block_cb));
+bool flow_indr_dev_exists(void);
 
 #endif /* _NET_FLOW_OFFLOAD_H */
diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 797147843958..3568b6a2f5f0 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -92,7 +92,7 @@ int nft_flow_rule_offload_commit(struct net *net);
 	NFT_OFFLOAD_MATCH(__key, __base, __field, __len, __reg)		\
 	memset(&(__reg)->mask, 0xff, (__reg)->len);
 
-int nft_chain_offload_priority(struct nft_base_chain *basechain);
+bool nft_chain_offload_support(const struct nft_base_chain *basechain);
 
 int nft_offload_init(void);
 void nft_offload_exit(void);
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 6beaea13564a..fb11103fa8af 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -565,3 +565,9 @@ int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
 	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
 }
 EXPORT_SYMBOL(flow_indr_dev_setup_offload);
+
+bool flow_indr_dev_exists(void)
+{
+	return !list_empty(&flow_block_indr_dev_list);
+}
+EXPORT_SYMBOL(flow_indr_dev_exists);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1528620df34c..1b4bc588f8d6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2072,7 +2072,7 @@ static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
 	chain->flags |= NFT_CHAIN_BASE | flags;
 	basechain->policy = NF_ACCEPT;
 	if (chain->flags & NFT_CHAIN_HW_OFFLOAD &&
-	    nft_chain_offload_priority(basechain) < 0)
+	    !nft_chain_offload_support(basechain))
 		return -EOPNOTSUPP;
 
 	flow_block_init(&basechain->flow_block);
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 2d36952b1392..910ef881c3b8 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -208,7 +208,7 @@ static int nft_setup_cb_call(enum tc_setup_type type, void *type_data,
 	return 0;
 }
 
-int nft_chain_offload_priority(struct nft_base_chain *basechain)
+static int nft_chain_offload_priority(const struct nft_base_chain *basechain)
 {
 	if (basechain->ops.priority <= 0 ||
 	    basechain->ops.priority > USHRT_MAX)
@@ -217,6 +217,27 @@ int nft_chain_offload_priority(struct nft_base_chain *basechain)
 	return 0;
 }
 
+bool nft_chain_offload_support(const struct nft_base_chain *basechain)
+{
+	struct net_device *dev;
+	struct nft_hook *hook;
+
+	if (nft_chain_offload_priority(basechain) < 0)
+		return false;
+
+	list_for_each_entry(hook, &basechain->hook_list, list) {
+		if (hook->ops.pf != NFPROTO_NETDEV ||
+		    hook->ops.hooknum != NF_NETDEV_INGRESS)
+			return false;
+
+		dev = hook->ops.dev;
+		if (!dev->netdev_ops->ndo_setup_tc && !flow_indr_dev_exists())
+			return false;
+	}
+
+	return true;
+}
+
 static void nft_flow_cls_offload_setup(struct flow_cls_offload *cls_flow,
 				       const struct nft_base_chain *basechain,
 				       const struct nft_rule *rule,
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B5F59E34A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354351AbiHWMSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359547AbiHWMPz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:15:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D87D6CD2B;
        Tue, 23 Aug 2022 02:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B032612D6;
        Tue, 23 Aug 2022 09:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104BAC433C1;
        Tue, 23 Aug 2022 09:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247643;
        bh=g3c+k0+yoeMxlfx1q/ulX8puF4nvn4+xvIvmP+adnF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gkl/SbQm6xO2DIDYZ0kiUigFuI1wtQYFVr2SIp7YeGyCFmhylyhNgx4UCJZd/MUII
         cCjm4NllSD/29sKd5tE2WzQbce3JofgqXq6ZMbnPe/YyrF0bhdmSEGNmIGgogCENt5
         hmfoZyXv282iMXPUDXQBKSpOgX91WhOxLTo9XlsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/158] netfilter: nftables: add helper function to set the base sequence number
Date:   Tue, 23 Aug 2022 10:27:11 +0200
Message-Id: <20220823080050.031334162@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 802b805162a1b7d8391c40ac8a878e9e63287aff ]

This patch adds a helper function to calculate the base sequence number
field that is stored in the nfnetlink header. Use the helper function
whenever possible.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 507d3d24a347..2ed8ccb9c8c1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -683,6 +683,11 @@ nf_tables_chain_type_lookup(struct net *net, const struct nlattr *nla,
 	return ERR_PTR(-ENOENT);
 }
 
+static __be16 nft_base_seq(const struct net *net)
+{
+	return htons(net->nft.base_seq & 0xffff);
+}
+
 static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
 	[NFTA_TABLE_NAME]	= { .type = NLA_STRING,
 				    .len = NFT_TABLE_MAXNAMELEN - 1 },
@@ -707,7 +712,7 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_TABLE_NAME, table->name) ||
 	    nla_put_be32(skb, NFTA_TABLE_FLAGS, htonl(table->flags)) ||
@@ -1448,7 +1453,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_CHAIN_TABLE, table->name))
 		goto nla_put_failure;
@@ -2810,7 +2815,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_RULE_TABLE, table->name))
 		goto nla_put_failure;
@@ -3801,7 +3806,7 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= ctx->family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(ctx->net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(ctx->net);
 
 	if (nla_put_string(skb, NFTA_SET_TABLE, ctx->table->name))
 		goto nla_put_failure;
@@ -4751,7 +4756,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family = table->family;
 	nfmsg->version      = NFNETLINK_V0;
-	nfmsg->res_id	    = htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id	    = nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_SET_ELEM_LIST_TABLE, table->name))
 		goto nla_put_failure;
@@ -4823,7 +4828,7 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= ctx->family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(ctx->net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(ctx->net);
 
 	if (nla_put_string(skb, NFTA_SET_TABLE, ctx->table->name))
 		goto nla_put_failure;
@@ -6092,7 +6097,7 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_OBJ_TABLE, table->name) ||
 	    nla_put_string(skb, NFTA_OBJ_NAME, obj->key.name) ||
@@ -7004,7 +7009,7 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_FLOWTABLE_TABLE, flowtable->table->name) ||
 	    nla_put_string(skb, NFTA_FLOWTABLE_NAME, flowtable->name) ||
@@ -7249,7 +7254,7 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= AF_UNSPEC;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_be32(skb, NFTA_GEN_ID, htonl(net->nft.base_seq)) ||
 	    nla_put_be32(skb, NFTA_GEN_PROC_PID, htonl(task_pid_nr(current))) ||
-- 
2.35.1




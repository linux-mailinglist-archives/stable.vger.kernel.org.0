Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A75E58DCC2
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 19:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245375AbiHIRE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 13:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245376AbiHIREY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 13:04:24 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0D319D;
        Tue,  9 Aug 2022 10:04:16 -0700 (PDT)
Received: from localhost.localdomain (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 00B0541585;
        Tue,  9 Aug 2022 17:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660064655;
        bh=fU7+zhClFg37OR4eE/gFUTqdpOmCpYEVn2+ffs3HbXc=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=C3OlE/TQQR21zkLAxDCHe11Je7m9b4/gVjED7dNzbz3+j2wJhkqkBeefPtfzGB7Qj
         qdh9cZ9kY8nZUzWVtSqymwKSdoSos2dGyZ0aN0aH1bpw56biJJmXBbNDiSCs0x2hJg
         MzawGIWzP+bE83XR4rjkvjZfLNCy/R66j2dvPRijb1YtVUK/VSKAHuKZ6lrsQ1aDbn
         VeLpQNBhyk70DvxEbpBaBpzhZMqfKKRAjZc4/DKK+McgDHeLIfPxbmBqd2Pt7amzzo
         BvaBLIOoXaPIFB/H2xjt2ULpXzF7MfSYcFlat+hY24yS5NwY/tsKeIkpO8ulUmRwtS
         TF270dQ+sz+ZQ==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] netfilter: nf_tables: do not allow RULE_ID to refer to another chain
Date:   Tue,  9 Aug 2022 14:01:48 -0300
Message-Id: <20220809170148.164591-3-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220809170148.164591-1-cascardo@canonical.com>
References: <20220809170148.164591-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When doing lookups for rules on the same batch by using its ID, a rule from
a different chain can be used. If a rule is added to a chain but tries to
be positioned next to a rule from a different chain, it will be linked to
chain2, but the use counter on chain1 would be the one to be incremented.

When looking for rules by ID, use the chain that was used for the lookup by
name. The chain used in the context copied to the transaction needs to
match that same chain. That way, struct nft_rule does not need to get
enlarged with another member.

Fixes: 1a94e38d254b ("netfilter: nf_tables: add NFTA_RULE_ID attribute")
Fixes: 75dd48e2e420 ("netfilter: nf_tables: Support RULE_ID reference in new rule")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: <stable@vger.kernel.org>
---
 net/netfilter/nf_tables_api.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ae59784db9aa..d98c153a80e9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3373,6 +3373,7 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 }
 
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
+					     const struct nft_chain *chain,
 					     const struct nlattr *nla);
 
 #define NFT_RULE_MAXEXPRS	128
@@ -3461,7 +3462,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 				return PTR_ERR(old_rule);
 			}
 		} else if (nla[NFTA_RULE_POSITION_ID]) {
-			old_rule = nft_rule_lookup_byid(net, nla[NFTA_RULE_POSITION_ID]);
+			old_rule = nft_rule_lookup_byid(net, chain, nla[NFTA_RULE_POSITION_ID]);
 			if (IS_ERR(old_rule)) {
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_POSITION_ID]);
 				return PTR_ERR(old_rule);
@@ -3606,6 +3607,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 }
 
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
+					     const struct nft_chain *chain,
 					     const struct nlattr *nla)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -3616,6 +3618,7 @@ static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 		struct nft_rule *rule = nft_trans_rule(trans);
 
 		if (trans->msg_type == NFT_MSG_NEWRULE &&
+		    trans->ctx.chain == chain &&
 		    id == nft_trans_rule_id(trans))
 			return rule;
 	}
@@ -3665,7 +3668,7 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 			err = nft_delrule(&ctx, rule);
 		} else if (nla[NFTA_RULE_ID]) {
-			rule = nft_rule_lookup_byid(net, nla[NFTA_RULE_ID]);
+			rule = nft_rule_lookup_byid(net, chain, nla[NFTA_RULE_ID]);
 			if (IS_ERR(rule)) {
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_ID]);
 				return PTR_ERR(rule);
-- 
2.34.1


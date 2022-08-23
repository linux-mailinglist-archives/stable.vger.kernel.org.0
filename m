Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83FE59E239
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244290AbiHWLNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356991AbiHWLL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:11:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187F8B8A40;
        Tue, 23 Aug 2022 02:17:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B055E60F85;
        Tue, 23 Aug 2022 09:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3608C433C1;
        Tue, 23 Aug 2022 09:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246251;
        bh=kgKP/YTrcy57Lra+i8zRNd9GuMwxzB7uk+VRgOzxf5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIb23L5jKsbpN+urA94iNJXhtQF5voLSBFZhk5TNYGs9OY+JbljABdJlD13UqW7Mb
         Mo9E6joCutfyNdj9hO7ECnx0LSjDCrrIcy8cuZcBJFCQAnY9n8CV++OR8dVhvm0kPH
         ari5QflBXrPITXK7U3H6eVT3QzVsNu2ZtAHJCliU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 049/389] netfilter: nf_tables: do not allow RULE_ID to refer to another chain
Date:   Tue, 23 Aug 2022 10:22:07 +0200
Message-Id: <20220823080117.663235265@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit 36d5b2913219ac853908b0f1c664345e04313856 upstream.

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2713,6 +2713,7 @@ static int nft_table_validate(struct net
 }
 
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
+					     const struct nft_chain *chain,
 					     const struct nlattr *nla);
 
 #define NFT_RULE_MAXEXPRS	128
@@ -2786,7 +2787,7 @@ static int nf_tables_newrule(struct net
 				return PTR_ERR(old_rule);
 			}
 		} else if (nla[NFTA_RULE_POSITION_ID]) {
-			old_rule = nft_rule_lookup_byid(net, nla[NFTA_RULE_POSITION_ID]);
+			old_rule = nft_rule_lookup_byid(net, chain, nla[NFTA_RULE_POSITION_ID]);
 			if (IS_ERR(old_rule)) {
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_POSITION_ID]);
 				return PTR_ERR(old_rule);
@@ -2921,6 +2922,7 @@ err1:
 }
 
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
+					     const struct nft_chain *chain,
 					     const struct nlattr *nla)
 {
 	u32 id = ntohl(nla_get_be32(nla));
@@ -2930,6 +2932,7 @@ static struct nft_rule *nft_rule_lookup_
 		struct nft_rule *rule = nft_trans_rule(trans);
 
 		if (trans->msg_type == NFT_MSG_NEWRULE &&
+		    trans->ctx.chain == chain &&
 		    id == nft_trans_rule_id(trans))
 			return rule;
 	}
@@ -2976,7 +2979,7 @@ static int nf_tables_delrule(struct net
 
 			err = nft_delrule(&ctx, rule);
 		} else if (nla[NFTA_RULE_ID]) {
-			rule = nft_rule_lookup_byid(net, nla[NFTA_RULE_ID]);
+			rule = nft_rule_lookup_byid(net, chain, nla[NFTA_RULE_ID]);
 			if (IS_ERR(rule)) {
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_ID]);
 				return PTR_ERR(rule);



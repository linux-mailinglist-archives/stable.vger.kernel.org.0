Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447F1593594
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241602AbiHOS1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbiHOSZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:25:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5322A1571B;
        Mon, 15 Aug 2022 11:18:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1C1DB81077;
        Mon, 15 Aug 2022 18:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3880C433D6;
        Mon, 15 Aug 2022 18:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587514;
        bh=NjQPoxHwTrsneS3IuPBx0bmFi8CQW1N40CwpddqCxyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bqgmv8RT5HhjzNKben5k4PRl0O3LY6oQMnGaWKDh0MdHRlamoqFlYT2A572SaTRwy
         MAYxxvjwgumpHH7dt0J4cd+jGGGtToD2iMzsySR7pxPBvwg1R+gCNWW34Xk8MzFJoo
         IywLfFQCK+L1XgSgdu0eh3urPKWpZakKSKF+6fSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 108/779] netfilter: nf_tables: do not allow RULE_ID to refer to another chain
Date:   Mon, 15 Aug 2022 19:55:52 +0200
Message-Id: <20220815180341.942721612@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
@@ -3276,6 +3276,7 @@ static int nft_table_validate(struct net
 }
 
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
+					     const struct nft_chain *chain,
 					     const struct nlattr *nla);
 
 #define NFT_RULE_MAXEXPRS	128
@@ -3364,7 +3365,7 @@ static int nf_tables_newrule(struct sk_b
 				return PTR_ERR(old_rule);
 			}
 		} else if (nla[NFTA_RULE_POSITION_ID]) {
-			old_rule = nft_rule_lookup_byid(net, nla[NFTA_RULE_POSITION_ID]);
+			old_rule = nft_rule_lookup_byid(net, chain, nla[NFTA_RULE_POSITION_ID]);
 			if (IS_ERR(old_rule)) {
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_POSITION_ID]);
 				return PTR_ERR(old_rule);
@@ -3509,6 +3510,7 @@ err_release_expr:
 }
 
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
+					     const struct nft_chain *chain,
 					     const struct nlattr *nla)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -3519,6 +3521,7 @@ static struct nft_rule *nft_rule_lookup_
 		struct nft_rule *rule = nft_trans_rule(trans);
 
 		if (trans->msg_type == NFT_MSG_NEWRULE &&
+		    trans->ctx.chain == chain &&
 		    id == nft_trans_rule_id(trans))
 			return rule;
 	}
@@ -3568,7 +3571,7 @@ static int nf_tables_delrule(struct sk_b
 
 			err = nft_delrule(&ctx, rule);
 		} else if (nla[NFTA_RULE_ID]) {
-			rule = nft_rule_lookup_byid(net, nla[NFTA_RULE_ID]);
+			rule = nft_rule_lookup_byid(net, chain, nla[NFTA_RULE_ID]);
 			if (IS_ERR(rule)) {
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_ID]);
 				return PTR_ERR(rule);



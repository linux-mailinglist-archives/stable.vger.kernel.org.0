Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDAF594536
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348674AbiHOWYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347762AbiHOWWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:22:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD927124F7A;
        Mon, 15 Aug 2022 12:44:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B48AB80EB2;
        Mon, 15 Aug 2022 19:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758B7C43470;
        Mon, 15 Aug 2022 19:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592638;
        bh=q3vg4sFHpr8OQHoNrI0kfchaXIRIA0O/tgiOkVCgces=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PD8eMpU4iRHIvoGFzDuZVYcWLowJXOjhlFiF0TstqbSKpmDJypYDi7T4BIq6B2qBg
         /6E4LE5m6eKaZxio8HGW+G5F6TboCWp5YVZuR0DNB31UJmV4lpH4elgH3VtOqKHbX9
         v6q+DlX7ma2n2aX02uYWDRiKneWTJOxlD2xEoAjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.19 0141/1157] netfilter: nf_tables: do not allow CHAIN_ID to refer to another table
Date:   Mon, 15 Aug 2022 19:51:37 +0200
Message-Id: <20220815180445.270777201@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

commit 95f466d22364a33d183509629d0879885b4f547e upstream.

When doing lookups for chains on the same batch by using its ID, a chain
from a different table can be used. If a rule is added to a table but
refers to a chain in a different table, it will be linked to the chain in
table2, but would have expressions referring to objects in table1.

Then, when table1 is removed, the rule will not be removed as its linked to
a chain in table2. When expressions in the rule are processed or removed,
that will lead to a use-after-free.

When looking for chains by ID, use the table that was used for the lookup
by name, and only return chains belonging to that same table.

Fixes: 837830a4b439 ("netfilter: nf_tables: add NFTA_RULE_CHAIN_ID attribute")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2472,6 +2472,7 @@ err:
 }
 
 static struct nft_chain *nft_chain_lookup_byid(const struct net *net,
+					       const struct nft_table *table,
 					       const struct nlattr *nla)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -2482,6 +2483,7 @@ static struct nft_chain *nft_chain_looku
 		struct nft_chain *chain = trans->ctx.chain;
 
 		if (trans->msg_type == NFT_MSG_NEWCHAIN &&
+		    chain->table == table &&
 		    id == nft_trans_chain_id(trans))
 			return chain;
 	}
@@ -3417,7 +3419,7 @@ static int nf_tables_newrule(struct sk_b
 			return -EOPNOTSUPP;
 
 	} else if (nla[NFTA_RULE_CHAIN_ID]) {
-		chain = nft_chain_lookup_byid(net, nla[NFTA_RULE_CHAIN_ID]);
+		chain = nft_chain_lookup_byid(net, table, nla[NFTA_RULE_CHAIN_ID]);
 		if (IS_ERR(chain)) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_CHAIN_ID]);
 			return PTR_ERR(chain);
@@ -9607,7 +9609,7 @@ static int nft_verdict_init(const struct
 						 tb[NFTA_VERDICT_CHAIN],
 						 genmask);
 		} else if (tb[NFTA_VERDICT_CHAIN_ID]) {
-			chain = nft_chain_lookup_byid(ctx->net,
+			chain = nft_chain_lookup_byid(ctx->net, ctx->table,
 						      tb[NFTA_VERDICT_CHAIN_ID]);
 			if (IS_ERR(chain))
 				return PTR_ERR(chain);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6BB548918
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354664AbiFMLiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355060AbiFMLhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:37:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EC945064;
        Mon, 13 Jun 2022 03:48:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E82860FDB;
        Mon, 13 Jun 2022 10:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D39CC34114;
        Mon, 13 Jun 2022 10:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117295;
        bh=6kkjtfCyfPoYBDHlyShtWXsEIIe4ji9MKuIrYfI44CM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OnS37yOBHeDzU4vqAM77QCifXmtc5GsOMJzkkuGZL9tAx+RrGMtAna4VPpfTmC4fK
         CGUsahPLZjir+yBnSSSyTtIn//RUOkFfZ5roqSi9JUe4ksGdArydrvAqRbAIF++GHd
         KNYuDSWIwdMQ6ypU2wwzcY9SeTOQyhvcvFpeV+FU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 350/411] netfilter: nf_tables: memleak flow rule from commit path
Date:   Mon, 13 Jun 2022 12:10:23 +0200
Message-Id: <20220613094939.199850634@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

[ Upstream commit 9dd732e0bdf538b1b76dc7c157e2b5e560ff30d3 ]

Abort path release flow rule object, however, commit path does not.
Update code to destroy these objects before releasing the transaction.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b51c192105fc..58a7d89719b1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6570,6 +6570,9 @@ static void nft_commit_release(struct nft_trans *trans)
 		nf_tables_chain_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_DELRULE:
+		if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+			nft_flow_rule_destroy(nft_trans_flow_rule(trans));
+
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_DELSET:
@@ -6891,6 +6894,9 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nf_tables_rule_notify(&trans->ctx,
 					      nft_trans_rule(trans),
 					      NFT_MSG_NEWRULE);
+			if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
+
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELRULE:
-- 
2.35.1




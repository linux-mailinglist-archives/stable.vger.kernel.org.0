Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3058D429027
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhJKOFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239812AbhJKODb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:03:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E50B611C2;
        Mon, 11 Oct 2021 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960710;
        bh=wSMmznRAzE6MCbEsYPxD5vk7l6kM6U3hyPLNPIMK4D8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMbmAfbKCcyer5MGa8tDjdINZnwnPg9IxnIJkkRgtgcDfY0vbc8dNZrpreHSdrIH/
         TRjqsosywNT3rnbLRGhtdR3QE3xWL7+Ogt+aHj6TGWsY4FOClUkvrexrdBaqjtTTcD
         3B28Zi9808P6+7s1IFYe/p+R3U5Qz5vZJMINUTXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 054/151] netfilter: nf_tables: reverse order in rule replacement expansion
Date:   Mon, 11 Oct 2021 15:45:26 +0200
Message-Id: <20211011134519.596403852@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 2c964c558641a3bddaee5719c9e6d8805f777812 ]

Deactivate old rule first, then append the new rule, so rule replacement
notification via netlink first reports the deletion of the old rule with
handle X in first place, then it adds the new rule (reusing the handle X
of the replaced old rule).

Note that the abort path releases the transaction that has been created
by nft_delrule() on error.

Fixes: ca08987885a1 ("netfilter: nf_tables: deactivate expressions in rule replecement routine")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 085783b14075..c8acd26c7201 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3419,17 +3419,15 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (info->nlh->nlmsg_flags & NLM_F_REPLACE) {
+		err = nft_delrule(&ctx, old_rule);
+		if (err < 0)
+			goto err_destroy_flow_rule;
+
 		trans = nft_trans_rule_add(&ctx, NFT_MSG_NEWRULE, rule);
 		if (trans == NULL) {
 			err = -ENOMEM;
 			goto err_destroy_flow_rule;
 		}
-		err = nft_delrule(&ctx, old_rule);
-		if (err < 0) {
-			nft_trans_destroy(trans);
-			goto err_destroy_flow_rule;
-		}
-
 		list_add_tail_rcu(&rule->list, &old_rule->list);
 	} else {
 		trans = nft_trans_rule_add(&ctx, NFT_MSG_NEWRULE, rule);
-- 
2.33.0




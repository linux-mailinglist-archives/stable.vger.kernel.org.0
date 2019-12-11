Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C27F11B004
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732153AbfLKPSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:18:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732148AbfLKPSo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 883BF2073D;
        Wed, 11 Dec 2019 15:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077524;
        bh=0Km0hqA+o6jePpaYFJIfYnahtjVcCr5z9KjPvtXxgzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QX/sgV7J9fVADx5J3f/fkw+c89RopfDka3hjxuYYShcCRn8w4vIUGEoKD0ZQMcp/4
         IB29DV0+ksvHT+7mU3y62xUwy0Aw51TJ4xC8MtzwTDV0hpoXZhlh1oIV5w9qa2PCiS
         DPot9o+mpewMzwjuCSmqtyrG0qWQk5oEszU9Qp4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 034/243] netfilter: nf_tables: dont use position attribute on rule replacement
Date:   Wed, 11 Dec 2019 16:03:16 +0100
Message-Id: <20191211150341.560986622@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 447750f281abef547be44fdcfe3bc4447b3115a8 ]

Its possible to set both HANDLE and POSITION when replacing a rule.
In this case, the rule at POSITION gets replaced using the
userspace-provided handle.  Rule handles are supposed to be generated
by the kernel only.

Duplicate handles should be harmless, however better disable this "feature"
by only checking for the POSITION attribute on insert operations.

Fixes: 5e94846686d0 ("netfilter: nf_tables: add insert operation")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ec0f8b5bde0aa..0e1b1f7f4745e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2610,17 +2610,14 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 
 		if (chain->use == UINT_MAX)
 			return -EOVERFLOW;
-	}
-
-	if (nla[NFTA_RULE_POSITION]) {
-		if (!(nlh->nlmsg_flags & NLM_F_CREATE))
-			return -EOPNOTSUPP;
 
-		pos_handle = be64_to_cpu(nla_get_be64(nla[NFTA_RULE_POSITION]));
-		old_rule = __nft_rule_lookup(chain, pos_handle);
-		if (IS_ERR(old_rule)) {
-			NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_POSITION]);
-			return PTR_ERR(old_rule);
+		if (nla[NFTA_RULE_POSITION]) {
+			pos_handle = be64_to_cpu(nla_get_be64(nla[NFTA_RULE_POSITION]));
+			old_rule = __nft_rule_lookup(chain, pos_handle);
+			if (IS_ERR(old_rule)) {
+				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_POSITION]);
+				return PTR_ERR(old_rule);
+			}
 		}
 	}
 
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09C7664AFC
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239468AbjAJSiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239484AbjAJShs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:37:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A042974B3
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:33:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF3386183C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C98C433EF;
        Tue, 10 Jan 2023 18:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375579;
        bh=tc2rzu8BOPXG3P8iI+iprA2Nd3k5wjbaFt1ZbcegTq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOExn9oE/OzTutaICYdKP/3XaIx7aKPUAtMJ21YC3K9eVOmXgRaoYt01rK9QZQCqi
         cz2xRSZ3t4BMgQAgxOejt9DHbGI0LSDW7PxEco3Gd+ogfTWiRn+EuZP8nNGnDjZprO
         8CWphSGV8mwlnM9lR25uvbrS5EBCGWhkSkedLmqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 203/290] netfilter: nf_tables: perform type checking for existing sets
Date:   Tue, 10 Jan 2023 19:04:55 +0100
Message-Id: <20230110180038.975050224@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit f6594c372afd5cec8b1e9ee9ea8f8819d59c6fb1 ]

If a ruleset declares a set name that matches an existing set in the
kernel, then validate that this declaration really refers to the same
set, otherwise bail out with EEXIST.

Currently, the kernel reports success when adding a set that already
exists in the kernel. This usually results in EINVAL errors at a later
stage, when the user adds elements to the set, if the set declaration
mismatches the existing set representation in the kernel.

Add a new function to check that the set declaration really refers to
the same existing set in the kernel.

Fixes: 96518518cc41 ("netfilter: add nftables")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 36 ++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f892a926fb58..82fe54b64714 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4296,6 +4296,34 @@ static int nft_set_expr_alloc(struct nft_ctx *ctx, struct nft_set *set,
 	return err;
 }
 
+static bool nft_set_is_same(const struct nft_set *set,
+			    const struct nft_set_desc *desc,
+			    struct nft_expr *exprs[], u32 num_exprs, u32 flags)
+{
+	int i;
+
+	if (set->ktype != desc->ktype ||
+	    set->dtype != desc->dtype ||
+	    set->flags != flags ||
+	    set->klen != desc->klen ||
+	    set->dlen != desc->dlen ||
+	    set->field_count != desc->field_count ||
+	    set->num_exprs != num_exprs)
+		return false;
+
+	for (i = 0; i < desc->field_count; i++) {
+		if (set->field_len[i] != desc->field_len[i])
+			return false;
+	}
+
+	for (i = 0; i < num_exprs; i++) {
+		if (set->exprs[i]->ops != exprs[i]->ops)
+			return false;
+	}
+
+	return true;
+}
+
 static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
@@ -4450,10 +4478,16 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (err < 0)
 			return err;
 
+		err = 0;
+		if (!nft_set_is_same(set, &desc, exprs, num_exprs, flags)) {
+			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_NAME]);
+			err = -EEXIST;
+		}
+
 		for (i = 0; i < num_exprs; i++)
 			nft_expr_destroy(&ctx, exprs[i]);
 
-		return 0;
+		return err;
 	}
 
 	if (!(info->nlh->nlmsg_flags & NLM_F_CREATE))
-- 
2.35.1




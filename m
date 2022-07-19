Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88E4579DF8
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242204AbiGSM4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242330AbiGSM4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:56:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27F75A457;
        Tue, 19 Jul 2022 05:22:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DEF7B81B1A;
        Tue, 19 Jul 2022 12:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9408CC341C6;
        Tue, 19 Jul 2022 12:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233336;
        bh=tzshCxwzXuBU3xSWhussqWtJL4nPf/azbQZqFal6iSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkDMjG1xLB9h7WYZ4g3d1MEgwlFVBN50ZVTNt2trebD/e5ed9cZzC/4RywoerY4wV
         mkgf2XPpGDBzWMCHjG9g9bhpezx6hqgNOhEUu6IjQmGu5SraogqHIhVPwx7jf6zKo1
         Rjm0OcJVd4adgOoqZVlYNcybv/LZL+4pDkzqrSxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 061/231] netfilter: conntrack: split inner loop of list dumping to own function
Date:   Tue, 19 Jul 2022 13:52:26 +0200
Message-Id: <20220719114719.297878934@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 49001a2e83a80f6d9c4287c46ffa41a03667bbd1 ]

This allows code re-use in the followup patch.
No functional changes intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 68 ++++++++++++++++++----------
 1 file changed, 43 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1ea2ad732d57..924d766e6c53 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1708,6 +1708,47 @@ static int ctnetlink_done_list(struct netlink_callback *cb)
 	return 0;
 }
 
+static int ctnetlink_dump_one_entry(struct sk_buff *skb,
+				    struct netlink_callback *cb,
+				    struct nf_conn *ct,
+				    bool dying)
+{
+	struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;
+	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
+	u8 l3proto = nfmsg->nfgen_family;
+	int res;
+
+	if (l3proto && nf_ct_l3num(ct) != l3proto)
+		return 0;
+
+	if (ctx->last) {
+		if (ct != ctx->last)
+			return 0;
+
+		ctx->last = NULL;
+	}
+
+	/* We can't dump extension info for the unconfirmed
+	 * list because unconfirmed conntracks can have
+	 * ct->ext reallocated (and thus freed).
+	 *
+	 * In the dying list case ct->ext can't be free'd
+	 * until after we drop pcpu->lock.
+	 */
+	res = ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
+				  cb->nlh->nlmsg_seq,
+				  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
+				  ct, dying, 0);
+	if (res < 0) {
+		if (!refcount_inc_not_zero(&ct->ct_general.use))
+			return 0;
+
+		ctx->last = ct;
+	}
+
+	return res;
+}
+
 static int
 ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying)
 {
@@ -1715,12 +1756,9 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 	struct nf_conn *ct, *last;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
-	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	u_int8_t l3proto = nfmsg->nfgen_family;
-	int res;
-	int cpu;
 	struct hlist_nulls_head *list;
 	struct net *net = sock_net(skb->sk);
+	int res, cpu;
 
 	if (ctx->done)
 		return 0;
@@ -1739,30 +1777,10 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 restart:
 		hlist_nulls_for_each_entry(h, n, list, hnnode) {
 			ct = nf_ct_tuplehash_to_ctrack(h);
-			if (l3proto && nf_ct_l3num(ct) != l3proto)
-				continue;
-			if (ctx->last) {
-				if (ct != last)
-					continue;
-				ctx->last = NULL;
-			}
 
-			/* We can't dump extension info for the unconfirmed
-			 * list because unconfirmed conntracks can have
-			 * ct->ext reallocated (and thus freed).
-			 *
-			 * In the dying list case ct->ext can't be free'd
-			 * until after we drop pcpu->lock.
-			 */
-			res = ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
-						  cb->nlh->nlmsg_seq,
-						  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
-						  ct, dying, 0);
+			res = ctnetlink_dump_one_entry(skb, cb, ct, dying);
 			if (res < 0) {
-				if (!refcount_inc_not_zero(&ct->ct_general.use))
-					continue;
 				ctx->cpu = cpu;
-				ctx->last = ct;
 				spin_unlock_bh(&pcpu->lock);
 				goto out;
 			}
-- 
2.35.1




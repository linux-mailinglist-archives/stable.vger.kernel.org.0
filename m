Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546BA6895A7
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjBCKVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbjBCKVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:21:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3728B7E6
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:21:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D82BFB82A5F
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165F6C4339B;
        Fri,  3 Feb 2023 10:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419651;
        bh=KTsOGgZg/N52JsjP5wNGo/1nNIZVhjKXumN3kZlzkyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XX3gRJnNONcDfpXrN6w1qCTyOK6nJb8vZfH52+8R1bkKdQ2K40hnvddq/9zT+cS/Z
         t+cQXygXOH022Wy2ysp1vGqRRYo1fxiz1ah1AeIQoEpWfdflEHUwi3Qt0tsOT7zE+Y
         5LSZtWLwn5rJsKImwXcXGtKb6vIp8KhlnhED1V5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 46/80] netfilter: nft_set_rbtree: skip elements in transaction from garbage collection
Date:   Fri,  3 Feb 2023 11:12:40 +0100
Message-Id: <20230203101017.187596011@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 5d235d6ce75c12a7fdee375eb211e4116f7ab01b ]

Skip interference with an ongoing transaction, do not perform garbage
collection on inactive elements. Reset annotated previous end interval
if the expired element is marked as busy (control plane removed the
element right before expiration).

Fixes: 8d8540c4f5e0 ("netfilter: nft_set_rbtree: add timeout support")
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 84d317418d18..78a0f4283787 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -375,23 +375,37 @@ static void nft_rbtree_gc(struct work_struct *work)
 	struct nft_rbtree *priv;
 	struct rb_node *node;
 	struct nft_set *set;
+	struct net *net;
+	u8 genmask;
 
 	priv = container_of(work, struct nft_rbtree, gc_work.work);
 	set  = nft_set_container_of(priv);
+	net  = read_pnet(&set->net);
+	genmask = nft_genmask_cur(net);
 
 	write_lock_bh(&priv->lock);
 	write_seqcount_begin(&priv->count);
 	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
 
+		if (!nft_set_elem_active(&rbe->ext, genmask))
+			continue;
+
+		/* elements are reversed in the rbtree for historical reasons,
+		 * from highest to lowest value, that is why end element is
+		 * always visited before the start element.
+		 */
 		if (nft_rbtree_interval_end(rbe)) {
 			rbe_end = rbe;
 			continue;
 		}
 		if (!nft_set_elem_expired(&rbe->ext))
 			continue;
-		if (nft_set_elem_mark_busy(&rbe->ext))
+
+		if (nft_set_elem_mark_busy(&rbe->ext)) {
+			rbe_end = NULL;
 			continue;
+		}
 
 		if (rbe_prev) {
 			rb_erase(&rbe_prev->node, &priv->root);
-- 
2.39.0




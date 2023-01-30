Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18616810D5
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237105AbjA3OHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237107AbjA3OHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:07:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947213B661
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:07:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DBEE61084
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6F3C433D2;
        Mon, 30 Jan 2023 14:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087631;
        bh=xYmaA+wONafaHmY7s1tEfwKwVF4wo4/dWHD+JYFlK3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sm9kO3lny8ttRRdB4b/AxGe3uRUj5NXfKlcn42JXOqBKMRCfKwHdLfCSeHtW2TPzG
         3jUzhI0SfGKXE8upkKHze8zdyQtkvEzp/1n5bIVVfzckjkWci02ZPKZEuawq/wG4T+
         TxJYGtN0rVw7XIv3mGFCeW5JTLAR5Nchlia9axPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 265/313] netfilter: nft_set_rbtree: skip elements in transaction from garbage collection
Date:   Mon, 30 Jan 2023 14:51:40 +0100
Message-Id: <20230130134349.083730967@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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
index 217225e13faf..19ea4d3c3553 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -563,23 +563,37 @@ static void nft_rbtree_gc(struct work_struct *work)
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9D7531C33
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240811AbiEWR3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241965AbiEWR1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BC07980E;
        Mon, 23 May 2022 10:22:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C235CB81201;
        Mon, 23 May 2022 17:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A80DC385A9;
        Mon, 23 May 2022 17:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326507;
        bh=jMIzHqt1QTdiyQEd3y75sOxgA5an0wZmedRi1HIY8/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zyaIX/JUoyhzOoykZIY4+aSFe7AbNrcTyoaNRU8jXjzc/dp0irpoi2awiZnDkfph3
         WItKM7WEoTSC7dmn39MMGmXcRCvsI0xqiEqnTlrujneBqqGm5iDg8FFgt5NlYm9Wgl
         Q4zO6f0hTB+E9j0QpbYSO+HEn1ZDCP3tYp0/0a/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/132] netfilter: flowtable: pass flowtable to nf_flow_table_iterate()
Date:   Mon, 23 May 2022 19:05:11 +0200
Message-Id: <20220523165840.354963658@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 217cff36e885627c41a14e803fc44f9cbc945767 ]

The flowtable object is already passed as argument to
nf_flow_table_iterate(), do use not data pointer to pass flowtable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 58f3f77b3eb2..de783c9094d7 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -382,7 +382,8 @@ EXPORT_SYMBOL_GPL(flow_offload_lookup);
 
 static int
 nf_flow_table_iterate(struct nf_flowtable *flow_table,
-		      void (*iter)(struct flow_offload *flow, void *data),
+		      void (*iter)(struct nf_flowtable *flowtable,
+				   struct flow_offload *flow, void *data),
 		      void *data)
 {
 	struct flow_offload_tuple_rhash *tuplehash;
@@ -406,7 +407,7 @@ nf_flow_table_iterate(struct nf_flowtable *flow_table,
 
 		flow = container_of(tuplehash, struct flow_offload, tuplehash[0]);
 
-		iter(flow, data);
+		iter(flow_table, flow, data);
 	}
 	rhashtable_walk_stop(&hti);
 	rhashtable_walk_exit(&hti);
@@ -434,10 +435,9 @@ static bool nf_flow_has_stale_dst(struct flow_offload *flow)
 	       flow_offload_stale_dst(&flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple);
 }
 
-static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
+static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
+				    struct flow_offload *flow, void *data)
 {
-	struct nf_flowtable *flow_table = data;
-
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
 	    nf_flow_has_stale_dst(flow))
@@ -462,7 +462,7 @@ static void nf_flow_offload_work_gc(struct work_struct *work)
 	struct nf_flowtable *flow_table;
 
 	flow_table = container_of(work, struct nf_flowtable, gc_work.work);
-	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
+	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
 	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
 }
 
@@ -578,7 +578,8 @@ int nf_flow_table_init(struct nf_flowtable *flowtable)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_init);
 
-static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
+static void nf_flow_table_do_cleanup(struct nf_flowtable *flow_table,
+				     struct flow_offload *flow, void *data)
 {
 	struct net_device *dev = data;
 
@@ -620,11 +621,10 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
-	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
+	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
 	nf_flow_table_offload_flush(flow_table);
 	if (nf_flowtable_hw_offload(flow_table))
-		nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step,
-				      flow_table);
+		nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
 	rhashtable_destroy(&flow_table->rhashtable);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
-- 
2.35.1




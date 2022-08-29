Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64915A489B
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiH2LM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiH2LMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:12:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2D06527D;
        Mon, 29 Aug 2022 04:08:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F8C1611F8;
        Mon, 29 Aug 2022 11:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EE5C433C1;
        Mon, 29 Aug 2022 11:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771326;
        bh=xxGal8kxyFaU7CxMVOW1CsvMWc0gKMHoAm0Felxim4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZ6klp+WwZ68Gkq7tpA+/pEEFRvzevizjsyHRdqGpILIwigoucR8da+89D808o8EP
         EF6TuNDVd1S0eCAvja4yBh1wo0ZQJ2nnJyPrv6ECvO9mvPzBxkGJQqM7lYwkMP8tlI
         VlFbTtPuahlTMTZRPts8S1ADZHK9s+/FuWkI4vGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/136] netfilter: flowtable: add function to invoke garbage collection immediately
Date:   Mon, 29 Aug 2022 12:58:55 +0200
Message-Id: <20220829105807.426680734@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 759eebbcfafcefa23b59e912396306543764bd3c ]

Expose nf_flow_table_gc_run() to force a garbage collector run from the
offload infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_core.c    | 12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 9f927c44087de..f337041dcc352 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -266,6 +266,7 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 
 struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
 						     struct flow_offload_tuple *tuple);
+void nf_flow_table_gc_run(struct nf_flowtable *flow_table);
 void nf_flow_table_gc_cleanup(struct nf_flowtable *flowtable,
 			      struct net_device *dev);
 void nf_flow_table_cleanup(struct net_device *dev);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9fb407084c506..95ff1284d3d89 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -436,12 +436,17 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 	}
 }
 
+void nf_flow_table_gc_run(struct nf_flowtable *flow_table)
+{
+	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
+}
+
 static void nf_flow_offload_work_gc(struct work_struct *work)
 {
 	struct nf_flowtable *flow_table;
 
 	flow_table = container_of(work, struct nf_flowtable, gc_work.work);
-	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
+	nf_flow_table_gc_run(flow_table);
 	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
 }
 
@@ -600,10 +605,11 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
-	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
+	nf_flow_table_gc_run(flow_table);
 	nf_flow_table_offload_flush(flow_table);
 	if (nf_flowtable_hw_offload(flow_table))
-		nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
+		nf_flow_table_gc_run(flow_table);
+
 	rhashtable_destroy(&flow_table->rhashtable);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
-- 
2.35.1




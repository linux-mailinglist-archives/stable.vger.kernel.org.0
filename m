Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2CD5A4963
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiH2LYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiH2LXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:23:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2051D21B0;
        Mon, 29 Aug 2022 04:14:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C66BB80FAF;
        Mon, 29 Aug 2022 11:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E3EC433D6;
        Mon, 29 Aug 2022 11:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771685;
        bh=DB3AT2IlIwSAIYhJM/lAlW92OBQo093rsc1IbSXg7mY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4zo4AzbNvO0XdmzT/M9rsMYoWs7Nu9iPb5iKzlSsd88lazycSH/gNeVNbtYNtN03
         3kI6tp6hkbZhIiukkabZkNvmKhm5BLervgek2h1J5n+ejeaScbHeKenEhr8KKtti3A
         FmQGDrPoLhxu0zwkJRzQkWO7CO0wTbPXv6pNB5lU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 063/158] netfilter: flowtable: add function to invoke garbage collection immediately
Date:   Mon, 29 Aug 2022 12:58:33 +0200
Message-Id: <20220829105811.360293628@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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
index 64daafd1fc41c..32c25122ab184 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -270,6 +270,7 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 
 struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
 						     struct flow_offload_tuple *tuple);
+void nf_flow_table_gc_run(struct nf_flowtable *flow_table);
 void nf_flow_table_gc_cleanup(struct nf_flowtable *flowtable,
 			      struct net_device *dev);
 void nf_flow_table_cleanup(struct net_device *dev);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index f2def06d10709..18453fa25199c 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -442,12 +442,17 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
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
 
@@ -606,10 +611,11 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 
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




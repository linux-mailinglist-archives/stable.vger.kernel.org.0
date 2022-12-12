Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE7E64A1A9
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbiLLNn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbiLLNne (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:43:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897442DD8
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:42:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37993B80D4F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D12C433D2;
        Mon, 12 Dec 2022 13:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852565;
        bh=dvUMe7KsiRzwecvOlo+urXQTfBPcvebejCE/zS1lCxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8YSo0kpBQOu6rcZwFG45b3ugP+HAnN1pjPg1iopzTRnM3H/rQwSkT1GC23IIU41E
         VuKchK19El0DLgnKyZqoccjTZ4uRt22dO5IRWvkIBnFBCef6iY+oAurk+FEDeRjWJN
         1SVlpnayhV3u+MNSYiva5Jq2yxudLFkx6fD/6kvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xin Long <lucien.xin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 089/157] netfilter: flowtable_offload: fix using __this_cpu_add in preemptible
Date:   Mon, 12 Dec 2022 14:17:17 +0100
Message-Id: <20221212130938.387639092@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit a81047154e7ce4eb8769d5d21adcbc9693542a79 ]

flow_offload_queue_work() can be called in workqueue without
bh disabled, like the call trace showed in my act_ct testing,
calling NF_FLOW_TABLE_STAT_INC() there would cause a call
trace:

  BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u4:0/138560
  caller is flow_offload_queue_work+0xec/0x1b0 [nf_flow_table]
  Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work [act_ct]
  Call Trace:
   <TASK>
   dump_stack_lvl+0x33/0x46
   check_preemption_disabled+0xc3/0xf0
   flow_offload_queue_work+0xec/0x1b0 [nf_flow_table]
   nf_flow_table_iterate+0x138/0x170 [nf_flow_table]
   nf_flow_table_free+0x140/0x1a0 [nf_flow_table]
   tcf_ct_flow_table_cleanup_work+0x2f/0x2b0 [act_ct]
   process_one_work+0x6a3/0x1030
   worker_thread+0x8a/0xdf0

This patch fixes it by using NF_FLOW_TABLE_STAT_INC_ATOMIC()
instead in flow_offload_queue_work().

Note that for FLOW_CLS_REPLACE branch in flow_offload_queue_work(),
it may not be called in preemptible path, but it's good to use
NF_FLOW_TABLE_STAT_INC_ATOMIC() for all cases in
flow_offload_queue_work().

Fixes: b038177636f8 ("netfilter: nf_flow_table: count pending offload workqueue tasks")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_offload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 00b522890d77..0fdcdb2c9ae4 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -997,13 +997,13 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
 	struct net *net = read_pnet(&offload->flowtable->net);
 
 	if (offload->cmd == FLOW_CLS_REPLACE) {
-		NF_FLOW_TABLE_STAT_INC(net, count_wq_add);
+		NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_wq_add);
 		queue_work(nf_flow_offload_add_wq, &offload->work);
 	} else if (offload->cmd == FLOW_CLS_DESTROY) {
-		NF_FLOW_TABLE_STAT_INC(net, count_wq_del);
+		NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_wq_del);
 		queue_work(nf_flow_offload_del_wq, &offload->work);
 	} else {
-		NF_FLOW_TABLE_STAT_INC(net, count_wq_stats);
+		NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_wq_stats);
 		queue_work(nf_flow_offload_stats_wq, &offload->work);
 	}
 }
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D395A48B6
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiH2LO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiH2LNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:13:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B056FA31;
        Mon, 29 Aug 2022 04:09:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59F90B80F4B;
        Mon, 29 Aug 2022 11:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7ABFC433C1;
        Mon, 29 Aug 2022 11:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771356;
        bh=+p0Snfphy0GGK9I2VZywekC1v65rjRfTzJwBIllpX+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yrih4rm7wb29zuGccftOP4QD2Jeaa7YXaLUmqaCEMpo/5V2hXmCcNlE0uOVtyJaqW
         3C2pW2+vKdCC5iImqnTE1VQYeFHYgsOr1DB1HYb0Rz0PvievSO711fRZJbebUTpfJ+
         7rLCxheG37nDRuUvx+4OtAcEXcm0BBnskVf7Rzq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/136] netfilter: flowtable: fix stuck flows on cleanup due to pending work
Date:   Mon, 29 Aug 2022 12:58:56 +0200
Message-Id: <20220829105807.463390071@linuxfoundation.org>
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

[ Upstream commit 9afb4b27349a499483ae0134282cefd0c90f480f ]

To clear the flow table on flow table free, the following sequence
normally happens in order:

  1) gc_step work is stopped to disable any further stats/del requests.
  2) All flow table entries are set to teardown state.
  3) Run gc_step which will queue HW del work for each flow table entry.
  4) Waiting for the above del work to finish (flush).
  5) Run gc_step again, deleting all entries from the flow table.
  6) Flow table is freed.

But if a flow table entry already has pending HW stats or HW add work
step 3 will not queue HW del work (it will be skipped), step 4 will wait
for the pending add/stats to finish, and step 5 will queue HW del work
which might execute after freeing of the flow table.

To fix the above, this patch flushes the pending work, then it sets the
teardown flag to all flows in the flowtable and it forces a garbage
collector run to queue work to remove the flows from hardware, then it
flushes this new pending work and (finally) it forces another garbage
collector run to remove the entry from the software flowtable.

Stack trace:
[47773.882335] BUG: KASAN: use-after-free in down_read+0x99/0x460
[47773.883634] Write of size 8 at addr ffff888103b45aa8 by task kworker/u20:6/543704
[47773.885634] CPU: 3 PID: 543704 Comm: kworker/u20:6 Not tainted 5.12.0-rc7+ #2
[47773.886745] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)
[47773.888438] Workqueue: nf_ft_offload_del flow_offload_work_handler [nf_flow_table]
[47773.889727] Call Trace:
[47773.890214]  dump_stack+0xbb/0x107
[47773.890818]  print_address_description.constprop.0+0x18/0x140
[47773.892990]  kasan_report.cold+0x7c/0xd8
[47773.894459]  kasan_check_range+0x145/0x1a0
[47773.895174]  down_read+0x99/0x460
[47773.899706]  nf_flow_offload_tuple+0x24f/0x3c0 [nf_flow_table]
[47773.907137]  flow_offload_work_handler+0x72d/0xbe0 [nf_flow_table]
[47773.913372]  process_one_work+0x8ac/0x14e0
[47773.921325]
[47773.921325] Allocated by task 592159:
[47773.922031]  kasan_save_stack+0x1b/0x40
[47773.922730]  __kasan_kmalloc+0x7a/0x90
[47773.923411]  tcf_ct_flow_table_get+0x3cb/0x1230 [act_ct]
[47773.924363]  tcf_ct_init+0x71c/0x1156 [act_ct]
[47773.925207]  tcf_action_init_1+0x45b/0x700
[47773.925987]  tcf_action_init+0x453/0x6b0
[47773.926692]  tcf_exts_validate+0x3d0/0x600
[47773.927419]  fl_change+0x757/0x4a51 [cls_flower]
[47773.928227]  tc_new_tfilter+0x89a/0x2070
[47773.936652]
[47773.936652] Freed by task 543704:
[47773.937303]  kasan_save_stack+0x1b/0x40
[47773.938039]  kasan_set_track+0x1c/0x30
[47773.938731]  kasan_set_free_info+0x20/0x30
[47773.939467]  __kasan_slab_free+0xe7/0x120
[47773.940194]  slab_free_freelist_hook+0x86/0x190
[47773.941038]  kfree+0xce/0x3a0
[47773.941644]  tcf_ct_flow_table_cleanup_work

Original patch description and stack trace by Paul Blakey.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Reported-by: Paul Blakey <paulb@nvidia.com>
Tested-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_flow_table.h | 2 ++
 net/netfilter/nf_flow_table_core.c    | 7 +++----
 net/netfilter/nf_flow_table_offload.c | 8 ++++++++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f337041dcc352..aaa518e777e9e 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -303,6 +303,8 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 			   struct flow_offload *flow);
 
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable);
+void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
+
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
 				enum flow_block_command cmd);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 95ff1284d3d89..4f61eb1282834 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -604,12 +604,11 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	mutex_unlock(&flowtable_lock);
 
 	cancel_delayed_work_sync(&flow_table->gc_work);
+	nf_flow_table_offload_flush(flow_table);
+	/* ... no more pending work after this stage ... */
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
 	nf_flow_table_gc_run(flow_table);
-	nf_flow_table_offload_flush(flow_table);
-	if (nf_flowtable_hw_offload(flow_table))
-		nf_flow_table_gc_run(flow_table);
-
+	nf_flow_table_offload_flush_cleanup(flow_table);
 	rhashtable_destroy(&flow_table->rhashtable);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b561e0a44a45f..c4559fae8acd5 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1050,6 +1050,14 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 	flow_offload_queue_work(offload);
 }
 
+void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable)
+{
+	if (nf_flowtable_hw_offload(flowtable)) {
+		flush_workqueue(nf_flow_offload_del_wq);
+		nf_flow_table_gc_run(flowtable);
+	}
+}
+
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
 {
 	if (nf_flowtable_hw_offload(flowtable)) {
-- 
2.35.1




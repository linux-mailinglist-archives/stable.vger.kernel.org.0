Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63AA45EA2FF
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237631AbiIZLR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbiIZLQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:16:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCBE63F35;
        Mon, 26 Sep 2022 03:37:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85B2860C8E;
        Mon, 26 Sep 2022 10:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AB9C433D6;
        Mon, 26 Sep 2022 10:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188655;
        bh=BZfPRIWoeGzi/oHpfpQnFPSeDCql6EZMgdNhQrWC0hU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WFTy57uL/Dmfjq2EkGDZVSKUy/Qatwz4KgfmiKNN/uG+DZqqrpM4It3Cd6ip7ZZCJ
         aOQg0l/92Wi6kJCYLKXADEwmyM6f1U5pBUc2b/nhgKPbpExf7d1ULs4YgaJzz0VaJa
         GCY/EtnhzrX7vvcu+Ur7pstgluLCEUpMS+NWEn5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 5.15 051/148] mm: slub: fix flush_cpu_slab()/__free_slab() invocations in task context.
Date:   Mon, 26 Sep 2022 12:11:25 +0200
Message-Id: <20220926100757.943420252@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

commit e45cc288724f0cfd497bb5920bcfa60caa335729 upstream.

Commit 5a836bf6b09f ("mm: slub: move flush_cpu_slab() invocations
__free_slab() invocations out of IRQ context") moved all flush_cpu_slab()
invocations to the global workqueue to avoid a problem related
with deactivate_slab()/__free_slab() being called from an IRQ context
on PREEMPT_RT kernels.

When the flush_all_cpu_locked() function is called from a task context
it may happen that a workqueue with WQ_MEM_RECLAIM bit set ends up
flushing the global workqueue, this will cause a dependency issue.

 workqueue: WQ_MEM_RECLAIM nvme-delete-wq:nvme_delete_ctrl_work [nvme_core]
   is flushing !WQ_MEM_RECLAIM events:flush_cpu_slab
 WARNING: CPU: 37 PID: 410 at kernel/workqueue.c:2637
   check_flush_dependency+0x10a/0x120
 Workqueue: nvme-delete-wq nvme_delete_ctrl_work [nvme_core]
 RIP: 0010:check_flush_dependency+0x10a/0x120[  453.262125] Call Trace:
 __flush_work.isra.0+0xbf/0x220
 ? __queue_work+0x1dc/0x420
 flush_all_cpus_locked+0xfb/0x120
 __kmem_cache_shutdown+0x2b/0x320
 kmem_cache_destroy+0x49/0x100
 bioset_exit+0x143/0x190
 blk_release_queue+0xb9/0x100
 kobject_cleanup+0x37/0x130
 nvme_fc_ctrl_free+0xc6/0x150 [nvme_fc]
 nvme_free_ctrl+0x1ac/0x2b0 [nvme_core]

Fix this bug by creating a workqueue for the flush operation with
the WQ_MEM_RECLAIM bit set.

Fixes: 5a836bf6b09f ("mm: slub: move flush_cpu_slab() invocations __free_slab() invocations out of IRQ context")
Cc: <stable@vger.kernel.org>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -308,6 +308,11 @@ static inline void stat(const struct kme
  */
 static nodemask_t slab_nodes;
 
+/*
+ * Workqueue used for flush_cpu_slab().
+ */
+static struct workqueue_struct *flushwq;
+
 /********************************************************************
  * 			Core slab cache functions
  *******************************************************************/
@@ -2688,7 +2693,7 @@ static void flush_all_cpus_locked(struct
 		INIT_WORK(&sfw->work, flush_cpu_slab);
 		sfw->skip = false;
 		sfw->s = s;
-		schedule_work_on(cpu, &sfw->work);
+		queue_work_on(cpu, flushwq, &sfw->work);
 	}
 
 	for_each_online_cpu(cpu) {
@@ -4850,6 +4855,8 @@ void __init kmem_cache_init(void)
 
 void __init kmem_cache_init_late(void)
 {
+	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM, 0);
+	WARN_ON(!flushwq);
 }
 
 struct kmem_cache *



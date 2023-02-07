Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67DE68E0E8
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 20:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbjBGTKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 14:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbjBGTKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 14:10:17 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE1F30281
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 11:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675797014; x=1707333014;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5kK8aQq300R9m7QNbmXPcfZTWsnqsdY6sb7IFlocdEM=;
  b=S7qLritd8DSVitOK/BpIgigby6dmZT9LbpDeM4ZW7/2xX0ehdxttX1es
   vZvMu0Uye5ULOzxjHkIgIePpc0RRmayiNEY5OwBW8TyB6/RM/a9SeMexQ
   W58w6DK+iNLm0t1f5r+yJIEOyPqtTC2iSX7QCgSTNnrBQ/kDSc719jBF0
   c=;
X-IronPort-AV: E=Sophos;i="5.97,278,1669075200"; 
   d="scan'208";a="294483891"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-fad5e78e.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 19:10:13 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-fad5e78e.us-west-2.amazon.com (Postfix) with ESMTPS id C61FFA0905;
        Tue,  7 Feb 2023 19:10:11 +0000 (UTC)
Received: from EX19D046UWB004.ant.amazon.com (10.13.139.164) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 7 Feb 2023 19:10:10 +0000
Received: from dev-dsk-shaoyi-2b-b6ac9e9c.us-west-2.amazon.com (10.43.161.198)
 by EX19D046UWB004.ant.amazon.com (10.13.139.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.24; Tue, 7 Feb 2023 19:10:11 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <abuehaze@amazon.com>, <peterz@infradead.org>,
        <longman@redhat.com>, Davidlohr Bueso <dbueso@suse.de>,
        Shaoying Xu <shaoyi@amazon.com>
Subject: [PATCH stable 5.10 5/7] locking/rwsem: Prevent potential lock starvation
Date:   Tue, 7 Feb 2023 19:09:51 +0000
Message-ID: <20230207190953.31403-1-shaoyi@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230207190135.25258-1-shaoyi@amazon.com>
References: <20230207190135.25258-1-shaoyi@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.198]
X-ClientProxiedBy: EX13D34UWC001.ant.amazon.com (10.43.162.112) To
 EX19D046UWB004.ant.amazon.com (10.13.139.164)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit 2f06f702925b512a95b95dca3855549c047eef58 upstream

The lock handoff bit is added in commit 4f23dbc1e657 ("locking/rwsem:
Implement lock handoff to prevent lock starvation") to avoid lock
starvation. However, allowing readers to do optimistic spinning does
introduce an unlikely scenario where lock starvation can happen.

The lock handoff bit may only be set when a waiter is being woken up.
In the case of reader unlock, wakeup happens only when the reader count
reaches 0. If there is a continuous stream of incoming readers acquiring
read lock via optimistic spinning, it is possible that the reader count
may never reach 0 and so the handoff bit will never be asserted.

One way to prevent this scenario from happening is to disallow optimistic
spinning if the rwsem is currently owned by readers. If the previous
or current owner is a writer, optimistic spinning will be allowed.

If the previous owner is a reader but the reader count has reached 0
before, a wakeup should have been issued. So the handoff mechanism
will be kicked in to prevent lock starvation. As a result, it should
be OK to do optimistic spinning in this case.

This patch may have some impact on reader performance as it reduces
reader optimistic spinning especially if the lock critical sections
are short the number of contending readers are small.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Link: https://lkml.kernel.org/r/20201121041416.12285-3-longman@redhat.com
Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
---
 kernel/locking/rwsem.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 94d0fa715214..029a832f725e 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1010,16 +1010,27 @@ rwsem_spin_on_owner(struct rw_semaphore *sem, unsigned long nonspinnable)
 static struct rw_semaphore __sched *
 rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, int state)
 {
-	long adjustment = -RWSEM_READER_BIAS;
+	long owner, adjustment = -RWSEM_READER_BIAS;
+	long rcnt = (count >> RWSEM_READER_SHIFT);
 	struct rwsem_waiter waiter;
 	DEFINE_WAKE_Q(wake_q);
 	bool wake = false;
 
+	/*
+	 * To prevent a constant stream of readers from starving a sleeping
+	 * waiter, don't attempt optimistic spinning if the lock is currently
+	 * owned by readers.
+	 */
+	owner = atomic_long_read(&sem->owner);
+	if ((owner & RWSEM_READER_OWNED) && (rcnt > 1) &&
+	   !(count & RWSEM_WRITER_LOCKED))
+		goto queue;
+
 	/*
 	 * Save the current read-owner of rwsem, if available, and the
 	 * reader nonspinnable bit.
 	 */
-	waiter.last_rowner = atomic_long_read(&sem->owner);
+	waiter.last_rowner = owner;
 	if (!(waiter.last_rowner & RWSEM_READER_OWNED))
 		waiter.last_rowner &= RWSEM_RD_NONSPINNABLE;
 
-- 
2.38.1


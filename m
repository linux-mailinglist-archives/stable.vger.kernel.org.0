Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C64768E0E9
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 20:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjBGTKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 14:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjBGTKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 14:10:21 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBA32331E
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 11:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675797020; x=1707333020;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HkTr8XBQ9HYwfybbfHZPCOP1g95jzPCQOTfMzjybaYg=;
  b=PMaWlQG2bzB0ky8kt3W19HT5K9x/Z0XoIiAQVmoRCFJ5RYOwnP+yRzU+
   t66qmXZ4F7tLBl8o6uZecuRBBWnEZYwM+XlnJdqLN3gxT95XdblRFcFnv
   aLSofSYlyNWa69Lk9htkQC5uIXLu+D9oqScoq7AciynznJXbAOQYA5nYD
   E=;
X-IronPort-AV: E=Sophos;i="5.97,278,1669075200"; 
   d="scan'208";a="296317539"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-44b6fc51.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 19:10:18 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-44b6fc51.us-west-2.amazon.com (Postfix) with ESMTPS id 386E2A2945;
        Tue,  7 Feb 2023 19:10:17 +0000 (UTC)
Received: from EX19D046UWB004.ant.amazon.com (10.13.139.164) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 7 Feb 2023 19:10:16 +0000
Received: from dev-dsk-shaoyi-2b-b6ac9e9c.us-west-2.amazon.com (10.43.161.198)
 by EX19D046UWB004.ant.amazon.com (10.13.139.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.24; Tue, 7 Feb 2023 19:10:16 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <abuehaze@amazon.com>, <peterz@infradead.org>,
        <longman@redhat.com>, Davidlohr Bueso <dbueso@suse.de>,
        Shaoying Xu <shaoyi@amazon.com>
Subject: [PATCH stable 5.10 6/7] locking/rwsem: Enable reader optimistic lock stealing
Date:   Tue, 7 Feb 2023 19:09:52 +0000
Message-ID: <20230207190953.31403-2-shaoyi@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230207190953.31403-1-shaoyi@amazon.com>
References: <20230207190135.25258-1-shaoyi@amazon.com>
 <20230207190953.31403-1-shaoyi@amazon.com>
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

commit 1a728dff855a318bb58bcc1259b1826a7ad9f0bd upstream

If the optimistic spinning queue is empty and the rwsem does not have
the handoff or write-lock bits set, it is actually not necessary to
call rwsem_optimistic_spin() to spin on it. Instead, it can steal the
lock directly as its reader bias is in the count already.  If it is
the first reader in this state, it will try to wake up other readers
in the wait queue.

With this patch applied, the following were the lock event counts
after rebooting a 2-socket system and a "make -j96" kernel rebuild.

  rwsem_opt_rlock=4437
  rwsem_rlock=29
  rwsem_rlock_steal=19

So lock stealing represents about 0.4% of all the read locks acquired
in the slow path.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Link: https://lkml.kernel.org/r/20201121041416.12285-4-longman@redhat.com
Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
---
 kernel/locking/lock_events_list.h |  1 +
 kernel/locking/rwsem.c            | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/kernel/locking/lock_events_list.h b/kernel/locking/lock_events_list.h
index 239039d0ce21..270a0d351932 100644
--- a/kernel/locking/lock_events_list.h
+++ b/kernel/locking/lock_events_list.h
@@ -63,6 +63,7 @@ LOCK_EVENT(rwsem_opt_nospin)	/* # of disabled optspins		*/
 LOCK_EVENT(rwsem_opt_norspin)	/* # of disabled reader-only optspins	*/
 LOCK_EVENT(rwsem_opt_rlock2)	/* # of opt-acquired 2ndary read locks	*/
 LOCK_EVENT(rwsem_rlock)		/* # of read locks acquired		*/
+LOCK_EVENT(rwsem_rlock_steal)	/* # of read locks by lock stealing	*/
 LOCK_EVENT(rwsem_rlock_fast)	/* # of fast read locks acquired	*/
 LOCK_EVENT(rwsem_rlock_fail)	/* # of failed read lock acquisitions	*/
 LOCK_EVENT(rwsem_rlock_handoff)	/* # of read lock handoffs		*/
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 029a832f725e..c2e176e96499 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -976,6 +976,12 @@ static inline bool rwsem_reader_phase_trylock(struct rw_semaphore *sem,
 	}
 	return false;
 }
+
+static inline bool rwsem_no_spinners(struct rw_semaphore *sem)
+{
+	return !osq_is_locked(&sem->osq);
+}
+
 #else
 static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem,
 					   unsigned long nonspinnable)
@@ -996,6 +1002,11 @@ static inline bool rwsem_reader_phase_trylock(struct rw_semaphore *sem,
 	return false;
 }
 
+static inline bool rwsem_no_spinners(sem)
+{
+	return false;
+}
+
 static inline int
 rwsem_spin_on_owner(struct rw_semaphore *sem, unsigned long nonspinnable)
 {
@@ -1026,6 +1037,22 @@ rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, int state)
 	   !(count & RWSEM_WRITER_LOCKED))
 		goto queue;
 
+	/*
+	 * Reader optimistic lock stealing
+	 *
+	 * We can take the read lock directly without doing
+	 * rwsem_optimistic_spin() if the conditions are right.
+	 * Also wake up other readers if it is the first reader.
+	 */
+	if (!(count & (RWSEM_WRITER_LOCKED | RWSEM_FLAG_HANDOFF)) &&
+	    rwsem_no_spinners(sem)) {
+		rwsem_set_reader_owned(sem);
+		lockevent_inc(rwsem_rlock_steal);
+		if (rcnt == 1)
+			goto wake_readers;
+		return sem;
+	}
+
 	/*
 	 * Save the current read-owner of rwsem, if available, and the
 	 * reader nonspinnable bit.
@@ -1048,6 +1075,7 @@ rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, int state)
 		 * Wake up other readers in the wait list if the front
 		 * waiter is a reader.
 		 */
+wake_readers:
 		if ((atomic_long_read(&sem->count) & RWSEM_FLAG_WAITERS)) {
 			raw_spin_lock_irq(&sem->wait_lock);
 			if (!list_empty(&sem->wait_list))
-- 
2.38.1


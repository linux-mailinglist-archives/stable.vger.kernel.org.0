Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A521468E0C5
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 20:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjBGTCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 14:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbjBGTCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 14:02:22 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03F210E1
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 11:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675796541; x=1707332541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rV3Uo1lEBVXdpGklpUULHQ1xohYWc6CaKyEa43kdF7I=;
  b=j9uRXiMEOX3zy8JxKNEYdsxmKOwLvDGlPz41MypmjVZLLU/eNhWmV6pn
   Ui1JD80jh+jbxNH5Un7X7AQWYTNWzVW0+MYkQ+a52WvU4FmfaxXstKjh/
   RKeFisD2zp0Rp+iKzd9+7hbSun8n/pND/yEoeJtNmBbijAYUcKe+U/QrC
   c=;
X-IronPort-AV: E=Sophos;i="5.97,278,1669075200"; 
   d="scan'208";a="179436008"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 19:02:20 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com (Postfix) with ESMTPS id CCBBA81833;
        Tue,  7 Feb 2023 19:02:18 +0000 (UTC)
Received: from EX19D046UWB004.ant.amazon.com (10.13.139.164) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 7 Feb 2023 19:02:17 +0000
Received: from dev-dsk-shaoyi-2b-b6ac9e9c.us-west-2.amazon.com (10.43.160.120)
 by EX19D046UWB004.ant.amazon.com (10.13.139.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.24; Tue, 7 Feb 2023 19:02:17 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <abuehaze@amazon.com>, <peterz@infradead.org>,
        <longman@redhat.com>, Davidlohr Bueso <dbueso@suse.de>,
        Shaoying Xu <shaoyi@amazon.com>
Subject: [PATCH stable 5.10 4/7] locking/rwsem: Pass the current atomic count to rwsem_down_read_slowpath()
Date:   Tue, 7 Feb 2023 19:01:32 +0000
Message-ID: <20230207190135.25258-5-shaoyi@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230207190135.25258-1-shaoyi@amazon.com>
References: <20230207190135.25258-1-shaoyi@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D30UWB002.ant.amazon.com (10.43.161.110) To
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

commit c8fe8b0564388f41147326f31e4587171aacccd4 upstream

The atomic count value right after reader count increment can be useful
to determine the rwsem state at trylock time. So the count value is
passed down to rwsem_down_read_slowpath() to be used when appropriate.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Link: https://lkml.kernel.org/r/20201121041416.12285-2-longman@redhat.com
Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
---
 kernel/locking/rwsem.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 46f308a01045..94d0fa715214 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -270,14 +270,14 @@ static inline void rwsem_set_nonspinnable(struct rw_semaphore *sem)
 					  owner | RWSEM_NONSPINNABLE));
 }
 
-static inline bool rwsem_read_trylock(struct rw_semaphore *sem)
+static inline bool rwsem_read_trylock(struct rw_semaphore *sem, long *cntp)
 {
-	long cnt = atomic_long_add_return_acquire(RWSEM_READER_BIAS, &sem->count);
+	*cntp = atomic_long_add_return_acquire(RWSEM_READER_BIAS, &sem->count);
 
-	if (WARN_ON_ONCE(cnt < 0))
+	if (WARN_ON_ONCE(*cntp < 0))
 		rwsem_set_nonspinnable(sem);
 
-	if (!(cnt & RWSEM_READ_FAILED_MASK)) {
+	if (!(*cntp & RWSEM_READ_FAILED_MASK)) {
 		rwsem_set_reader_owned(sem);
 		return true;
 	}
@@ -1008,9 +1008,9 @@ rwsem_spin_on_owner(struct rw_semaphore *sem, unsigned long nonspinnable)
  * Wait for the read lock to be granted
  */
 static struct rw_semaphore __sched *
-rwsem_down_read_slowpath(struct rw_semaphore *sem, int state)
+rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, int state)
 {
-	long count, adjustment = -RWSEM_READER_BIAS;
+	long adjustment = -RWSEM_READER_BIAS;
 	struct rwsem_waiter waiter;
 	DEFINE_WAKE_Q(wake_q);
 	bool wake = false;
@@ -1356,8 +1356,10 @@ static struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
  */
 static inline int __down_read_common(struct rw_semaphore *sem, int state)
 {
-	if (!rwsem_read_trylock(sem)) {
-		if (IS_ERR(rwsem_down_read_slowpath(sem, state)))
+	long count;
+
+	if (!rwsem_read_trylock(sem, &count)) {
+		if (IS_ERR(rwsem_down_read_slowpath(sem, count, state)))
 			return -EINTR;
 		DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
 	}
-- 
2.38.1


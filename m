Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC60868E0C2
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 20:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbjBGTCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 14:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbjBGTCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 14:02:14 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3927D92
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 11:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675796533; x=1707332533;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J1Hb+eBwqUwFvWgiM6SsScqplnLYPcQrHgb+HsLOxgw=;
  b=bg+Bs94iIHtFQ4Bb4pbrPSz1rwvMBwj0dq+iNWJUPbl40YVfB9Ygc5OK
   ZdSFyGsHctdq0AYqwg+OkdgM8GJTckS7CJ72eZDa8tbHx2G5L+LcgOYPz
   3nJZ1w0L/jtTSoCileiWsFlnbxTtjWPXgULm8w8o37GiYD7WeK/v43jQ+
   A=;
X-IronPort-AV: E=Sophos;i="5.97,278,1669075200"; 
   d="scan'208";a="296314564"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1box-1dm6-7f722725.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 19:02:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1box-1dm6-7f722725.us-east-1.amazon.com (Postfix) with ESMTPS id 0931293A98;
        Tue,  7 Feb 2023 19:02:10 +0000 (UTC)
Received: from EX19D046UWB004.ant.amazon.com (10.13.139.164) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 7 Feb 2023 19:02:09 +0000
Received: from dev-dsk-shaoyi-2b-b6ac9e9c.us-west-2.amazon.com (10.43.160.120)
 by EX19D046UWB004.ant.amazon.com (10.13.139.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.24; Tue, 7 Feb 2023 19:02:10 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <abuehaze@amazon.com>, <peterz@infradead.org>,
        <longman@redhat.com>, Shaoying Xu <shaoyi@amazon.com>
Subject: [PATCH stable 5.10 2/7] locking/rwsem: Introduce rwsem_write_trylock()
Date:   Tue, 7 Feb 2023 19:01:30 +0000
Message-ID: <20230207190135.25258-3-shaoyi@amazon.com>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 285c61aedf6bc5d81b37e4dc48c19012e8ff9836 upstream

One copy of this logic is better than three.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201207090243.GE3040@hirez.programming.kicks-ass.net
Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
---
 kernel/locking/rwsem.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 7bf45b0a1b1d..6b62654eb0a8 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -285,6 +285,18 @@ static inline bool rwsem_read_trylock(struct rw_semaphore *sem)
 	return false;
 }
 
+static inline bool rwsem_write_trylock(struct rw_semaphore *sem)
+{
+	long tmp = RWSEM_UNLOCKED_VALUE;
+
+	if (atomic_long_try_cmpxchg_acquire(&sem->count, &tmp, RWSEM_WRITER_LOCKED)) {
+		rwsem_set_owner(sem);
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Return just the real task structure pointer of the owner
  */
@@ -1395,42 +1407,24 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
  */
 static inline void __down_write(struct rw_semaphore *sem)
 {
-	long tmp = RWSEM_UNLOCKED_VALUE;
-
-	if (unlikely(!atomic_long_try_cmpxchg_acquire(&sem->count, &tmp,
-						      RWSEM_WRITER_LOCKED)))
+	if (unlikely(!rwsem_write_trylock(sem)))
 		rwsem_down_write_slowpath(sem, TASK_UNINTERRUPTIBLE);
-	else
-		rwsem_set_owner(sem);
 }
 
 static inline int __down_write_killable(struct rw_semaphore *sem)
 {
-	long tmp = RWSEM_UNLOCKED_VALUE;
-
-	if (unlikely(!atomic_long_try_cmpxchg_acquire(&sem->count, &tmp,
-						      RWSEM_WRITER_LOCKED))) {
+	if (unlikely(!rwsem_write_trylock(sem))) {
 		if (IS_ERR(rwsem_down_write_slowpath(sem, TASK_KILLABLE)))
 			return -EINTR;
-	} else {
-		rwsem_set_owner(sem);
 	}
+
 	return 0;
 }
 
 static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
-	long tmp;
-
 	DEBUG_RWSEMS_WARN_ON(sem->magic != sem, sem);
-
-	tmp  = RWSEM_UNLOCKED_VALUE;
-	if (atomic_long_try_cmpxchg_acquire(&sem->count, &tmp,
-					    RWSEM_WRITER_LOCKED)) {
-		rwsem_set_owner(sem);
-		return true;
-	}
-	return false;
+	return rwsem_write_trylock(sem);
 }
 
 /*
-- 
2.38.1


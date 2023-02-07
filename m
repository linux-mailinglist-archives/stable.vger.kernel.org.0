Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D81C68E0C1
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 20:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbjBGTCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 14:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbjBGTCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 14:02:04 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5188083D6
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 11:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675796522; x=1707332522;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FYfJVHYsKVodJULm5xqfZMlyGWwt3tGFqVUZI/xCbi4=;
  b=ayyw6r5yaaLEHGy8vtpp353VNo6TMUHIw/ui6XseUQVmeFbQ7zJcH2Bv
   s94v8H3vF3QSFkumCY8xr5XDFTDs/heX1r1h87mAV5Jh3nQ1vUza3a23+
   ep3MF91DMScCdkgff9fpXGpNsouZ1CRUK7jmUmUzHnLwmm+mFrPAG9gXA
   I=;
X-IronPort-AV: E=Sophos;i="5.97,278,1669075200"; 
   d="scan'208";a="308532439"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-8a14c045.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 19:02:02 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-8a14c045.us-west-2.amazon.com (Postfix) with ESMTPS id 93D4083045;
        Tue,  7 Feb 2023 19:02:01 +0000 (UTC)
Received: from EX19D046UWB004.ant.amazon.com (10.13.139.164) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 7 Feb 2023 19:02:00 +0000
Received: from dev-dsk-shaoyi-2b-b6ac9e9c.us-west-2.amazon.com (10.43.160.120)
 by EX19D046UWB004.ant.amazon.com (10.13.139.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.24; Tue, 7 Feb 2023 19:02:00 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <abuehaze@amazon.com>, <peterz@infradead.org>,
        <longman@redhat.com>, Shaoying Xu <shaoyi@amazon.com>
Subject: [PATCH stable 5.10 1/7] locking/rwsem: Better collate rwsem_read_trylock()
Date:   Tue, 7 Feb 2023 19:01:29 +0000
Message-ID: <20230207190135.25258-2-shaoyi@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230207190135.25258-1-shaoyi@amazon.com>
References: <20230207190135.25258-1-shaoyi@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D30UWB002.ant.amazon.com (10.43.161.110) To
 EX19D046UWB004.ant.amazon.com (10.13.139.164)
X-Spam-Status: No, score=-10.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 3379116a0ca965b00e6522c7ea3f16c9dbd8f9f9 upstream

All users of rwsem_read_trylock() do rwsem_set_reader_owned(sem) on
success, move it into rwsem_read_trylock() proper.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201207090243.GE3040@hirez.programming.kicks-ass.net
Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
---
 kernel/locking/rwsem.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index cc5cc889b5b7..7bf45b0a1b1d 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -273,9 +273,16 @@ static inline void rwsem_set_nonspinnable(struct rw_semaphore *sem)
 static inline bool rwsem_read_trylock(struct rw_semaphore *sem)
 {
 	long cnt = atomic_long_add_return_acquire(RWSEM_READER_BIAS, &sem->count);
+
 	if (WARN_ON_ONCE(cnt < 0))
 		rwsem_set_nonspinnable(sem);
-	return !(cnt & RWSEM_READ_FAILED_MASK);
+
+	if (!(cnt & RWSEM_READ_FAILED_MASK)) {
+		rwsem_set_reader_owned(sem);
+		return true;
+	}
+
+	return false;
 }
 
 /*
@@ -1340,8 +1347,6 @@ static inline void __down_read(struct rw_semaphore *sem)
 	if (!rwsem_read_trylock(sem)) {
 		rwsem_down_read_slowpath(sem, TASK_UNINTERRUPTIBLE);
 		DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
-	} else {
-		rwsem_set_reader_owned(sem);
 	}
 }
 
@@ -1351,8 +1356,6 @@ static inline int __down_read_interruptible(struct rw_semaphore *sem)
 		if (IS_ERR(rwsem_down_read_slowpath(sem, TASK_INTERRUPTIBLE)))
 			return -EINTR;
 		DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
-	} else {
-		rwsem_set_reader_owned(sem);
 	}
 	return 0;
 }
@@ -1363,8 +1366,6 @@ static inline int __down_read_killable(struct rw_semaphore *sem)
 		if (IS_ERR(rwsem_down_read_slowpath(sem, TASK_KILLABLE)))
 			return -EINTR;
 		DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
-	} else {
-		rwsem_set_reader_owned(sem);
 	}
 	return 0;
 }
-- 
2.38.1


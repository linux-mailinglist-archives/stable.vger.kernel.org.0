Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6060468E0C3
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 20:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbjBGTCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 14:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbjBGTCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 14:02:19 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5D1126D4
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 11:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675796539; x=1707332539;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y/EmygwLMR806z07bvbRZnyzROHiIdWslOPqRWhs8yk=;
  b=mKbmQnpzX+VUuTPM1XCqgT+OGFuyJW4IWFW5Tj39LGAzRmJgf16/c0Za
   I6gVD5xMrX2ypKoQwsFXJWTdfYlFdczn2s9fZwi/QJjoanAKlFxzdmtBa
   xJo06eBuE/5E9HsbRpbpQMaklAlk6L+tQQb/oXQu4mAsS0fcP/H3TuDZU
   0=;
X-IronPort-AV: E=Sophos;i="5.97,278,1669075200"; 
   d="scan'208";a="179435987"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 19:02:18 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com (Postfix) with ESMTPS id 3552E82383;
        Tue,  7 Feb 2023 19:02:16 +0000 (UTC)
Received: from EX19D046UWB004.ant.amazon.com (10.13.139.164) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 7 Feb 2023 19:02:16 +0000
Received: from dev-dsk-shaoyi-2b-b6ac9e9c.us-west-2.amazon.com (10.43.160.120)
 by EX19D046UWB004.ant.amazon.com (10.13.139.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.24; Tue, 7 Feb 2023 19:02:16 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <abuehaze@amazon.com>, <peterz@infradead.org>,
        <longman@redhat.com>, Shaoying Xu <shaoyi@amazon.com>
Subject: [PATCH stable 5.10 3/7] locking/rwsem: Fold __down_{read,write}*()
Date:   Tue, 7 Feb 2023 19:01:31 +0000
Message-ID: <20230207190135.25258-4-shaoyi@amazon.com>
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

commit c995e638ccbbc65a76d1713c4fdcf927e7e2cb83 upstream

There's a lot needless duplication in __down_{read,write}*(), cure
that with a helper.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201207090243.GE3040@hirez.programming.kicks-ass.net
Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
---
 kernel/locking/rwsem.c | 45 +++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 6b62654eb0a8..46f308a01045 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1354,32 +1354,29 @@ static struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 /*
  * lock for reading
  */
-static inline void __down_read(struct rw_semaphore *sem)
+static inline int __down_read_common(struct rw_semaphore *sem, int state)
 {
 	if (!rwsem_read_trylock(sem)) {
-		rwsem_down_read_slowpath(sem, TASK_UNINTERRUPTIBLE);
+		if (IS_ERR(rwsem_down_read_slowpath(sem, state)))
+			return -EINTR;
 		DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
 	}
+	return 0;
+}
+
+static inline void __down_read(struct rw_semaphore *sem)
+{
+	__down_read_common(sem, TASK_UNINTERRUPTIBLE);
 }
 
 static inline int __down_read_interruptible(struct rw_semaphore *sem)
 {
-	if (!rwsem_read_trylock(sem)) {
-		if (IS_ERR(rwsem_down_read_slowpath(sem, TASK_INTERRUPTIBLE)))
-			return -EINTR;
-		DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
-	}
-	return 0;
+	return __down_read_common(sem, TASK_INTERRUPTIBLE);
 }
 
 static inline int __down_read_killable(struct rw_semaphore *sem)
 {
-	if (!rwsem_read_trylock(sem)) {
-		if (IS_ERR(rwsem_down_read_slowpath(sem, TASK_KILLABLE)))
-			return -EINTR;
-		DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
-	}
-	return 0;
+	return __down_read_common(sem, TASK_KILLABLE);
 }
 
 static inline int __down_read_trylock(struct rw_semaphore *sem)
@@ -1405,22 +1402,26 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 /*
  * lock for writing
  */
-static inline void __down_write(struct rw_semaphore *sem)
-{
-	if (unlikely(!rwsem_write_trylock(sem)))
-		rwsem_down_write_slowpath(sem, TASK_UNINTERRUPTIBLE);
-}
-
-static inline int __down_write_killable(struct rw_semaphore *sem)
+static inline int __down_write_common(struct rw_semaphore *sem, int state)
 {
 	if (unlikely(!rwsem_write_trylock(sem))) {
-		if (IS_ERR(rwsem_down_write_slowpath(sem, TASK_KILLABLE)))
+		if (IS_ERR(rwsem_down_write_slowpath(sem, state)))
 			return -EINTR;
 	}
 
 	return 0;
 }
 
+static inline void __down_write(struct rw_semaphore *sem)
+{
+	__down_write_common(sem, TASK_UNINTERRUPTIBLE);
+}
+
+static inline int __down_write_killable(struct rw_semaphore *sem)
+{
+	return __down_write_common(sem, TASK_KILLABLE);
+}
+
 static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
 	DEBUG_RWSEMS_WARN_ON(sem->magic != sem, sem);
-- 
2.38.1


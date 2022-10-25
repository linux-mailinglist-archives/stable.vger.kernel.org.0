Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305AD60BF1A
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 01:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiJXXzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 19:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiJXXza (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 19:55:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EBD33D67C
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 15:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666649538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jqegOKwKp0b5k01538L+8elHQKTxwvJermmvNJSeQ8I=;
        b=LWkNnUJDr7VmwoMGUA/aJs0CjN12Ro0pD/81EAbZCMxYHjLn54hKKZ5PW1SRxt1CZJiFFt
        Oo7oJiqErgK0leAHOR+EVi4z1bqA5gqvd1T4ZKBbXRvrhq6pOQhyjOvmuemuvBifICEvOY
        SFzill305smREWD/ayEZ//Rik2Lz9eI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-O_QEXEtDO8y_40DJ98iRpw-1; Mon, 24 Oct 2022 13:44:51 -0400
X-MC-Unique: O_QEXEtDO8y_40DJ98iRpw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B99B8027FD;
        Mon, 24 Oct 2022 17:44:50 +0000 (UTC)
Received: from llong.com (dhcp-17-153.bos.redhat.com [10.18.17.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40FAA492B0F;
        Mon, 24 Oct 2022 17:44:50 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>
Cc:     linux-kernel@vger.kernel.org, john.p.donnelly@oracle.com,
        Hillf Danton <hdanton@sina.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        =?UTF-8?q?Ting11=20Wang=20=E7=8E=8B=E5=A9=B7?= 
        <wangting11@xiaomi.com>, Waiman Long <longman@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH v4 1/5] locking/rwsem: Prevent non-first waiter from spinning in down_write() slowpath
Date:   Mon, 24 Oct 2022 13:44:14 -0400
Message-Id: <20221024174418.796468-2-longman@redhat.com>
In-Reply-To: <20221024174418.796468-1-longman@redhat.com>
References: <20221024174418.796468-1-longman@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A non-first waiter can potentially spin in the for loop of
rwsem_down_write_slowpath() without sleeping but fail to acquire the
lock even if the rwsem is free if the following sequence happens:

  Non-first RT waiter    First waiter      Lock holder
  -------------------    ------------      -----------
  Acquire wait_lock
  rwsem_try_write_lock():
    Set handoff bit if RT or
      wait too long
    Set waiter->handoff_set
  Release wait_lock
                         Acquire wait_lock
                         Inherit waiter->handoff_set
                         Release wait_lock
					   Clear owner
                                           Release lock
  if (waiter.handoff_set) {
    rwsem_spin_on_owner(();
    if (OWNER_NULL)
      goto trylock_again;
  }
  trylock_again:
  Acquire wait_lock
  rwsem_try_write_lock():
     if (first->handoff_set && (waiter != first))
     	return false;
  Release wait_lock

A non-first waiter cannot really acquire the rwsem even if it mistakenly
believes that it can spin on OWNER_NULL value. If that waiter happens
to be an RT task running on the same CPU as the first waiter, it can
block the first waiter from acquiring the rwsem leading to live lock.
Fix this problem by making sure that a non-first waiter cannot spin in
the slowpath loop without sleeping.

Fixes: d257cc8cb8d5 ("locking/rwsem: Make handoff bit handling more consistent")
Reviewed-and-tested-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/locking/rwsem.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 44873594de03..be2df9ea7c30 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -624,18 +624,16 @@ static inline bool rwsem_try_write_lock(struct rw_semaphore *sem,
 			 */
 			if (first->handoff_set && (waiter != first))
 				return false;
-
-			/*
-			 * First waiter can inherit a previously set handoff
-			 * bit and spin on rwsem if lock acquisition fails.
-			 */
-			if (waiter == first)
-				waiter->handoff_set = true;
 		}
 
 		new = count;
 
 		if (count & RWSEM_LOCK_MASK) {
+			/*
+			 * A waiter (first or not) can set the handoff bit
+			 * if it is an RT task or wait in the wait queue
+			 * for too long.
+			 */
 			if (has_handoff || (!rt_task(waiter->task) &&
 					    !time_after(jiffies, waiter->timeout)))
 				return false;
@@ -651,11 +649,12 @@ static inline bool rwsem_try_write_lock(struct rw_semaphore *sem,
 	} while (!atomic_long_try_cmpxchg_acquire(&sem->count, &count, new));
 
 	/*
-	 * We have either acquired the lock with handoff bit cleared or
-	 * set the handoff bit.
+	 * We have either acquired the lock with handoff bit cleared or set
+	 * the handoff bit. Only the first waiter can have its handoff_set
+	 * set here to enable optimistic spinning in slowpath loop.
 	 */
 	if (new & RWSEM_FLAG_HANDOFF) {
-		waiter->handoff_set = true;
+		first->handoff_set = true;
 		lockevent_inc(rwsem_wlock_handoff);
 		return false;
 	}
-- 
2.31.1


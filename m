Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC49E6AEC22
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjCGRwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbjCGRwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:52:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B0BA54C6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:46:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A5AFB819BE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74008C433EF;
        Tue,  7 Mar 2023 17:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211198;
        bh=T64YGB/WbSmo844IPhN5Qg5+GnKYfnMKflw+A6LaWMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2llJX3+NgT17GMcJKEbeV38daURWDAsY38vluprn+zUi8Rqu0lMpT/dZ8SQxNf9Z
         P3AzJM1QkIflJtGdpcyQeYIHRUkOpp19HXzeYGsT2s1lllfgJ4aOMvZieIE3Btcnjk
         8Dssv8XpgLU53eVg3/+d/H+1l6uk4dwgpZJKcF0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Waiman Long <longman@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mukesh Ojha <quic_mojha@quicinc.com>
Subject: [PATCH 6.2 0784/1001] locking/rwsem: Prevent non-first waiter from spinning in down_write() slowpath
Date:   Tue,  7 Mar 2023 17:59:16 +0100
Message-Id: <20230307170055.764799066@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit b613c7f31476c44316bfac1af7cac714b7d6bef9 upstream.

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
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Mukesh Ojha <quic_mojha@quicinc.com>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230126003628.365092-2-longman@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/rwsem.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -624,18 +624,16 @@ static inline bool rwsem_try_write_lock(
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
@@ -651,11 +649,12 @@ static inline bool rwsem_try_write_lock(
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



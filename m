Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D75644233
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 12:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbiLFLeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 06:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiLFLeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 06:34:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18D12BC0
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 03:33:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8166760FB8
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 11:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96202C433C1;
        Tue,  6 Dec 2022 11:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670326439;
        bh=/CyhRuK6ACMQ1iYFKcJVCcO3Na5ogRgaCjXZqCNZyac=;
        h=Subject:To:Cc:From:Date:From;
        b=nIPdYbsAnyJPsVOW5BGOe9VckbCXr+4SjqsxDSh6lWTyvfOuHbr2zy0yG6gaEdzLo
         YT4zmhJGH+y2UyQGipzWqcE/BEEj9xcLm5akbb2dixHD/lggLwA+KnjlvQd2CHfxHl
         d1ammokOtz24FB30Xb7tiKbcH3d3zv9yn3QHi3xw=
Subject: FAILED: patch "[PATCH] ipc/sem: Fix dangling sem_array access in semtimedop race" failed to apply to 4.19-stable tree
To:     jannh@google.com, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Dec 2022 12:33:52 +0100
Message-ID: <1670326432198164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:



thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b52be557e24c47286738276121177a41f54e3b83 Mon Sep 17 00:00:00 2001
From: Jann Horn <jannh@google.com>
Date: Mon, 5 Dec 2022 17:59:27 +0100
Subject: [PATCH] ipc/sem: Fix dangling sem_array access in semtimedop race

When __do_semtimedop() goes to sleep because it has to wait for a
semaphore value becoming zero or becoming bigger than some threshold, it
links the on-stack sem_queue to the sem_array, then goes to sleep
without holding a reference on the sem_array.

When __do_semtimedop() comes back out of sleep, one of two things must
happen:

 a) We prove that the on-stack sem_queue has been disconnected from the
    (possibly freed) sem_array, making it safe to return from the stack
    frame that the sem_queue exists in.

 b) We stabilize our reference to the sem_array, lock the sem_array, and
    detach the sem_queue from the sem_array ourselves.

sem_array has RCU lifetime, so for case (b), the reference can be
stabilized inside an RCU read-side critical section by locklessly
checking whether the sem_queue is still connected to the sem_array.

However, the current code does the lockless check on sem_queue before
starting an RCU read-side critical section, so the result of the
lockless check immediately becomes useless.

Fix it by doing rcu_read_lock() before the lockless check.  Now RCU
ensures that if we observe the object being on our queue, the object
can't be freed until rcu_read_unlock().

This bug is only hittable on kernel builds with full preemption support
(either CONFIG_PREEMPT or PREEMPT_DYNAMIC with preempt=full).

Fixes: 370b262c896e ("ipc/sem: avoid idr tree lookup for interrupted semop")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/ipc/sem.c b/ipc/sem.c
index c8496f98b139..00f88aa01ac5 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -2179,14 +2179,15 @@ long __do_semtimedop(int semid, struct sembuf *sops,
 		 * scenarios where we were awakened externally, during the
 		 * window between wake_q_add() and wake_up_q().
 		 */
+		rcu_read_lock();
 		error = READ_ONCE(queue.status);
 		if (error != -EINTR) {
 			/* see SEM_BARRIER_2 for purpose/pairing */
 			smp_acquire__after_ctrl_dep();
+			rcu_read_unlock();
 			goto out;
 		}
 
-		rcu_read_lock();
 		locknum = sem_lock(sma, sops, nsops);
 
 		if (!ipc_valid_object(&sma->sem_perm))


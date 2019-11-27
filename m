Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD3310BBD1
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732295AbfK0VOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:14:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:47478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbfK0VOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:14:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBCE22154A;
        Wed, 27 Nov 2019 21:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889251;
        bh=fNOxtLZkX+s9IeFk8i0BIYgH7UJFXVSCQwZTeYSIfDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sf2QA7sdKO7c6AozcvBYtk3yrDfr/RlWHM48fIVoiGNe229FW00zdsY8LTfTw/Vi9
         O89bXAUJZDOdKu6VZPNxXlbKHTWSpRPhXzKbwQuFqFBwdwRYpQC04PzTUiafxv8IVp
         GYCvIq4xgL9ENQFqLolLWjyTa4vwN+QgAHjGKJuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 45/66] futex: Provide distinct return value when owner is exiting
Date:   Wed, 27 Nov 2019 21:32:40 +0100
Message-Id: <20191127202726.854316427@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit ac31c7ff8624409ba3c4901df9237a616c187a5d upstream.

attach_to_pi_owner() returns -EAGAIN for various cases:

 - Owner task is exiting
 - Futex value has changed

The caller drops the held locks (hash bucket, mmap_sem) and retries the
operation. In case of the owner task exiting this can result in a live
lock.

As a preparatory step for seperating those cases, provide a distinct return
value (EBUSY) for the owner exiting case.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.935606117@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/futex.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1182,11 +1182,11 @@ static int handle_exit_race(u32 __user *
 	u32 uval2;
 
 	/*
-	 * If the futex exit state is not yet FUTEX_STATE_DEAD, wait
-	 * for it to finish.
+	 * If the futex exit state is not yet FUTEX_STATE_DEAD, tell the
+	 * caller that the alleged owner is busy.
 	 */
 	if (tsk && tsk->futex_state != FUTEX_STATE_DEAD)
-		return -EAGAIN;
+		return -EBUSY;
 
 	/*
 	 * Reread the user space value to handle the following situation:
@@ -2092,12 +2092,13 @@ retry_private:
 			if (!ret)
 				goto retry;
 			goto out;
+		case -EBUSY:
 		case -EAGAIN:
 			/*
 			 * Two reasons for this:
-			 * - Owner is exiting and we just wait for the
+			 * - EBUSY: Owner is exiting and we just wait for the
 			 *   exit to complete.
-			 * - The user space value changed.
+			 * - EAGAIN: The user space value changed.
 			 */
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
@@ -2843,12 +2844,13 @@ retry_private:
 			goto out_unlock_put_key;
 		case -EFAULT:
 			goto uaddr_faulted;
+		case -EBUSY:
 		case -EAGAIN:
 			/*
 			 * Two reasons for this:
-			 * - Task is exiting and we just wait for the
+			 * - EBUSY: Task is exiting and we just wait for the
 			 *   exit to complete.
-			 * - The user space value changed.
+			 * - EAGAIN: The user space value changed.
 			 */
 			queue_unlock(hb);
 			put_futex_key(&q.key);



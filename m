Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F77330C98F
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238465AbhBBSWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:22:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233656AbhBBOGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:06:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B00D86501C;
        Tue,  2 Feb 2021 13:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273752;
        bh=5Kc68jgGpp2v6m5yFO3qY47FpUvQ3a1gekEUHnUOkD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLm9HeeehJzEeUT2DQwc7tV8QgzrrNr5qsw4JReAY84hx7SgninxIGmrQGZDPzslw
         lbQNlQlffCaKzQ6TKlr0HIRIoAwHA9kbLk/OAgj2+k1l4r8eviXjt5g1LnoUaHlcYA
         Ltd8Cc4u6DiTu2Om2yz93XdIEhDqn944Y+IhBotM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 17/28] futex: Provide distinct return value when owner is exiting
Date:   Tue,  2 Feb 2021 14:38:37 +0100
Message-Id: <20210202132941.878964984@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132941.180062901@linuxfoundation.org>
References: <20210202132941.180062901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1909,12 +1909,13 @@ retry_private:
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
 			free_pi_state(pi_state);
 			pi_state = NULL;
@@ -2580,12 +2581,13 @@ retry_private:
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



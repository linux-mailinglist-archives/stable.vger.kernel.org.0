Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F20534C5EC
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhC2ID6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:03:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232026AbhC2IDV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:03:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5319861981;
        Mon, 29 Mar 2021 08:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005001;
        bh=lmEPBLVgIU6iXSGIJhGttAIrGiQ3KcEsOLjkepM9wZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxoQhzZya+Myn5mH/dopFw8LzwbY0olrlsUF7kKfa3lsgEFF2FG/7iGlGhSENlCQd
         4auetahzkINyzff0gw1x9bFZQp/tlZy/NAFPq3I+da4gIbckLCFoY/k+7XAMZ9Z7RX
         la3ozXXTWHqCIcvIz2r5jvueLQRG8IubwpbCxZ4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 44/53] futex: Fix (possible) missed wakeup
Date:   Mon, 29 Mar 2021 09:58:19 +0200
Message-Id: <20210329075608.956552582@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit b061c38bef43406df8e73c5be06cbfacad5ee6ad upstream.

We must not rely on wake_q_add() to delay the wakeup; in particular
commit:

  1d0dcb3ad9d3 ("futex: Implement lockless wakeups")

moved wake_q_add() before smp_store_release(&q->lock_ptr, NULL), which
could result in futex_wait() waking before observing ->lock_ptr ==
NULL and going back to sleep again.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 1d0dcb3ad9d3 ("futex: Implement lockless wakeups")
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1553,11 +1553,7 @@ static void mark_wake_futex(struct wake_
 	if (WARN(q->pi_state || q->rt_waiter, "refusing to wake PI futex\n"))
 		return;
 
-	/*
-	 * Queue the task for later wakeup for after we've released
-	 * the hb->lock. wake_q_add() grabs reference to p.
-	 */
-	wake_q_add(wake_q, p);
+	get_task_struct(p);
 	__unqueue_futex(q);
 	/*
 	 * The waiting task can free the futex_q as soon as
@@ -1566,6 +1562,13 @@ static void mark_wake_futex(struct wake_
 	 * store to lock_ptr from getting ahead of the plist_del.
 	 */
 	smp_store_release(&q->lock_ptr, NULL);
+
+	/*
+	 * Queue the task for later wakeup for after we've released
+	 * the hb->lock. wake_q_add() grabs reference to p.
+	 */
+	wake_q_add(wake_q, p);
+	put_task_struct(p);
 }
 
 /*



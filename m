Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07C0345CC3
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 12:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhCWLZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 07:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbhCWLZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 07:25:20 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56486C061574;
        Tue, 23 Mar 2021 04:25:19 -0700 (PDT)
Date:   Tue, 23 Mar 2021 11:25:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616498715;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/vK4WN04PkUTWxXvZnuNhvdYsXH2PU2ekGlCOBoEtgs=;
        b=iM6SC+v8YUYgv0VQa21EQF83kEdJ+1bsMMeHlJzcPTmvfPpAGVat9eamKwrIcOyMexTG9L
        /yBAC6ZKHPUThhrpJyEZv9EXDpEGCUhJZCUd2Z9bkmVmIJ4qtxdV71fSqkyIjDjiszKxne
        uZXUd9ByzAqs7LWvN9S16AZ2WIS3F9M79lQLmpOKVrxHrNetiV9wIULG8G3mT0h5wyGdJD
        kGPO5T4VBxbSadqsrDAEpHUfBSJzquNTKe5xOMY5FTj9G7pdXmEUt8oL3YIOxtWVE8dwc9
        S9M+qQJ9TXXW5Y6GRVCIKeA5ecGY0uqVwdjr+2lyVFRUwFulPYj0mrVwGNkdAQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616498715;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/vK4WN04PkUTWxXvZnuNhvdYsXH2PU2ekGlCOBoEtgs=;
        b=BkoqVRwmyh6T51wN56VsvytzmLvPj4LR+4eyOoK+rED9eFmOF5T6SBHjdLU+EUVvpow6Lx
        az7MH0CKxmDrhuCw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/urgent] locking/mutex: Fix non debug version of
 mutex_lock_io_nested()
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <878s6fshii.fsf@nanos.tec.linutronix.de>
References: <878s6fshii.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <161649871428.398.9633106540793047465.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/urgent branch of tip:

Commit-ID:     291da9d4a9eb3a1cb0610b7f4480f5b52b1825e7
Gitweb:        https://git.kernel.org/tip/291da9d4a9eb3a1cb0610b7f4480f5b52b1825e7
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Mon, 22 Mar 2021 09:46:13 +01:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Tue, 23 Mar 2021 12:20:23 +01:00

locking/mutex: Fix non debug version of mutex_lock_io_nested()

If CONFIG_DEBUG_LOCK_ALLOC=n then mutex_lock_io_nested() maps to
mutex_lock() which is clearly wrong because mutex_lock() lacks the
io_schedule_prepare()/finish() invocations.

Map it to mutex_lock_io().

Fixes: f21860bac05b ("locking/mutex, sched/wait: Fix the mutex_lock_io_nested() define")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/878s6fshii.fsf@nanos.tec.linutronix.de
---
 include/linux/mutex.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 0cd631a..515cff7 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -185,7 +185,7 @@ extern void mutex_lock_io(struct mutex *lock);
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
 # define mutex_lock_killable_nested(lock, subclass) mutex_lock_killable(lock)
 # define mutex_lock_nest_lock(lock, nest_lock) mutex_lock(lock)
-# define mutex_lock_io_nested(lock, subclass) mutex_lock(lock)
+# define mutex_lock_io_nested(lock, subclass) mutex_lock_io(lock)
 #endif
 
 /*

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4993345979
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 09:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCWIQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 04:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhCWIQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 04:16:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5560C061574;
        Tue, 23 Mar 2021 01:16:08 -0700 (PDT)
Date:   Tue, 23 Mar 2021 08:16:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616487366;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yhoobA2pk+Id/6J8DrRnPV+Dkp/cGA5TRmh32KLuHZU=;
        b=UhR8alkiIw101KtVF1A04/FAYP9xpgrCVt4XZqrJbiqk/NuYR0kI5MMAzlbm6onGuxBV5h
        qX5TX0/HI1HDrJ9g0Hres2UuXqS9oij5V+c7GKylIOIOdLizKPDhjoHOj9rZkeP4U87fdJ
        1JPrn1ry97kWhGOgPXGnI3eS8t7G80rVJHEuylpW2+gsZwA98Wy9hbIB4UZfQbkpDaB62t
        5QHvyFrZLoQDMLUZDE0uLdhZJS6qatW9yeVac0n8yZ/t7FcwqTNJeK7TEItEx6+mdpADNz
        eaB2Z+1f1E4XF1ls91wuKGbcfYpriw6GO3uYptonQH3FIKijtRG3ByHyMSK/oA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616487366;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yhoobA2pk+Id/6J8DrRnPV+Dkp/cGA5TRmh32KLuHZU=;
        b=sNJxJ6NLXKvpD+KTFzGNzuOjluPOAmPo2toBoLTbIpRxcRpqA1xmOjnavoWSMYOXyYMMya
        M+DoyPtm7Xjq8hDg==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/core] locking/mutex: Fix non debug version of
 mutex_lock_io_nested()
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <878s6fshii.fsf@nanos.tec.linutronix.de>
References: <878s6fshii.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <161648736505.398.2737771760695327055.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/core branch of tip:

Commit-ID:     ebdbd41bf2536ac57bf315ce9690245e08c5e506
Gitweb:        https://git.kernel.org/tip/ebdbd41bf2536ac57bf315ce9690245e08c5e506
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Mon, 22 Mar 2021 09:46:13 +01:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Mon, 22 Mar 2021 21:43:57 +01:00

locking/mutex: Fix non debug version of mutex_lock_io_nested()

If CONFIG_DEBUG_LOCK_ALLOC=n then mutex_lock_io_nested() maps to
mutex_lock() which is clearly wrong because mutex_lock() lacks the
io_schedule_prepare()/finish() invocations.

Map it to mutex_lock_io().

Fixes: f21860bac05b ("locking/mutex, sched/wait: Fix the mutex_lock_io_nested() define")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
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

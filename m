Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D17338CB23
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 18:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237571AbhEUQhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 12:37:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58180 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234855AbhEUQhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 12:37:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621614939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HZlyA2fykG9/ItrhE3JKOBw8IERquxE+qww/yqJgdxs=;
        b=EVfldzmQF9/pbQH14Jf0HlPngBLovtyTmD8ZCgV8811pFuiY8pkBHboHU9+9fcekdnWDto
        i3jdznWHjri4+wbb4zSmxx937rk0oQ8aFwqDGO/bkqMq36eMT0ZKFKfRqdN25zFMJ+9OPA
        e7/FZT8q/3Q78vF+G/9AjASkq5Gjl2M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-nriD3aWLNDK0n9nMY9sEnA-1; Fri, 21 May 2021 12:35:35 -0400
X-MC-Unique: nriD3aWLNDK0n9nMY9sEnA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96A621020C3A;
        Fri, 21 May 2021 16:35:33 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.49])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9143E6A03D;
        Fri, 21 May 2021 16:35:28 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Fri, 21 May 2021 18:35:33 +0200 (CEST)
Date:   Fri, 21 May 2021 18:35:27 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     akpm@linux-foundation.org
Cc:     bp@suse.de, davidchao@google.com, jenhaochen@google.com,
        jkosina@suse.cz, josh@joshtriplett.org, liumartin@google.com,
        mhocko@suse.cz, mingo@redhat.com, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org, pmladek@suse.com,
        rostedt@goodmis.org, stable@vger.kernel.org, tglx@linutronix.de,
        tj@kernel.org, vbabka@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: +
 kthread-fix-kthread_mod_delayed_work-vs-kthread_cancel_delayed_work_sync-race.patch
 added to -mm tree
Message-ID: <20210521163526.GA17916@redhat.com>
References: <20210520214737.MrGGKbPrJ%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520214737.MrGGKbPrJ%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/20, Andrew Morton wrote:
>
> --- a/kernel/kthread.c~kthread-fix-kthread_mod_delayed_work-vs-kthread_cancel_delayed_work_sync-race
> +++ a/kernel/kthread.c
> @@ -1181,6 +1181,19 @@ bool kthread_mod_delayed_work(struct kth
>  		goto out;
>
>  	ret = __kthread_cancel_work(work, true, &flags);
> +
> +	/*
> +	 * Canceling could run in parallel from kthread_cancel_delayed_work_sync
> +	 * and change work's canceling count as the spinlock is released and regain
> +	 * in __kthread_cancel_work so we need to check the count again. Otherwise,
> +	 * we might incorrectly queue the dwork and further cause
> +	 * cancel_delayed_work_sync thread waiting for flush dwork endlessly.
> +	 */
> +	if (work->canceling) {
> +		ret = false;
> +		goto out;
> +	}
> +
>  fast_queue:
>  	__kthread_queue_delayed_work(worker, dwork, delay);

Never looked at this code before, can't review...

but note that another caller of __kthread_queue_delayed_work() needs to
check work->canceling too. So perhaps we should simply add queuing_blocked()
into __kthread_queue_delayed_work() ?

Something like below, uncompiled/untested, most probably incorrect.

Either way, this comment

	 * Return: %true if @dwork was pending and its timer was modified,
	 * %false otherwise.

above kthread_mod_delayed_work looks obviously wrong. Currently it returns
true if this work was pending. With your patch it returns true if it was
pending and not canceling.

With the patch below it returns true if the work was (re)queued successfully,
and this makes more sense to me. But again, I can easily misread this code.

In any case, even if my patch is correct, I won't insist, your fix is
much simpler.

Oleg.

--- x/kernel/kthread.c
+++ x/kernel/kthread.c
@@ -977,7 +977,7 @@ void kthread_delayed_work_timer_fn(struc
 }
 EXPORT_SYMBOL(kthread_delayed_work_timer_fn);
 
-static void __kthread_queue_delayed_work(struct kthread_worker *worker,
+static bool __kthread_queue_delayed_work(struct kthread_worker *worker,
 					 struct kthread_delayed_work *dwork,
 					 unsigned long delay)
 {
@@ -987,6 +987,9 @@ static void __kthread_queue_delayed_work
 	WARN_ON_FUNCTION_MISMATCH(timer->function,
 				  kthread_delayed_work_timer_fn);
 
+	if (queuing_blocked(worker, work))
+		return false;
+
 	/*
 	 * If @delay is 0, queue @dwork->work immediately.  This is for
 	 * both optimization and correctness.  The earliest @timer can
@@ -995,7 +998,7 @@ static void __kthread_queue_delayed_work
 	 */
 	if (!delay) {
 		kthread_insert_work(worker, work, &worker->work_list);
-		return;
+		return true;
 	}
 
 	/* Be paranoid and try to detect possible races already now. */
@@ -1005,6 +1008,7 @@ static void __kthread_queue_delayed_work
 	work->worker = worker;
 	timer->expires = jiffies + delay;
 	add_timer(timer);
+	return true;
 }
 
 /**
@@ -1028,16 +1032,12 @@ bool kthread_queue_delayed_work(struct k
 {
 	struct kthread_work *work = &dwork->work;
 	unsigned long flags;
-	bool ret = false;
+	bool ret;
 
 	raw_spin_lock_irqsave(&worker->lock, flags);
-
-	if (!queuing_blocked(worker, work)) {
-		__kthread_queue_delayed_work(worker, dwork, delay);
-		ret = true;
-	}
-
+	ret = __kthread_queue_delayed_work(worker, dwork, delay);
 	raw_spin_unlock_irqrestore(&worker->lock, flags);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(kthread_queue_delayed_work);
@@ -1180,9 +1180,9 @@ bool kthread_mod_delayed_work(struct kth
 	if (work->canceling)
 		goto out;
 
-	ret = __kthread_cancel_work(work, true, &flags);
+	__kthread_cancel_work(work, true, &flags);
 fast_queue:
-	__kthread_queue_delayed_work(worker, dwork, delay);
+	ret = __kthread_queue_delayed_work(worker, dwork, delay);
 out:
 	raw_spin_unlock_irqrestore(&worker->lock, flags);
 	return ret;


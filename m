Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A24B3C23D4
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 14:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhGINAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbhGINAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 09:00:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF309C0613DD;
        Fri,  9 Jul 2021 05:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5bd4qn+scWk8VisRiVDNRZRKBRgO9V3WOaL1s+tjaOY=; b=lWhvRhWdikgKWxo1oVU+qnU9dy
        9z3lGM7dPCl4sYtVFTnuvthjncZ4OiH9eMW3lilnSKuAuvcbq+DxLM9fxiau2uyIGbBRTMY48Uw4W
        OTbZgWRDgh3c7Fj/QZIB+3evu2nIo94Jy/6E7AwwAbpZZlUGO5/7uHfsuklIhL+QgiD8yY6CrVm4f
        dcAE5Yn7foNyiod+QngZHWkmftiyaswyMmkogAv/DOPrj1KSOQ6HCRwsjlCxqZWsIb8ACSyiigU+n
        VhsY5s63zodxNXOgJFSQaQsHRCI20NcwEc+ZnSy4JZBuU03AC2iPs0AZPvXX2MgNM3Q/Tr3JPMTLG
        7+t5D0Rw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m1q47-00EVwD-V2; Fri, 09 Jul 2021 12:57:17 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BE29D30007E;
        Fri,  9 Jul 2021 14:57:10 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id ABF17200E7BC9; Fri,  9 Jul 2021 14:57:10 +0200 (CEST)
Date:   Fri, 9 Jul 2021 14:57:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Phil Auld <pauld@redhat.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Waiman Long <longman@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] sched: Fix nr_uninterruptible race causing increasing
 load average
Message-ID: <YOhHphFWGbfAVODd@hirez.programming.kicks-ass.net>
References: <20210707190457.60521-1-pauld@redhat.com>
 <YOaoomJAS2FzXi7I@hirez.programming.kicks-ass.net>
 <YOatszHNZc9XRbYB@hirez.programming.kicks-ass.net>
 <YOavHgRUBM6cc95s@hirez.programming.kicks-ass.net>
 <YOcRwhF6XkYWPjvV@lorien.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOcRwhF6XkYWPjvV@lorien.usersys.redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 08, 2021 at 10:54:58AM -0400, Phil Auld wrote:
> Sorry... I don't have a nice diagram. I'm still looking at what all those
> macros actually mean on the various architectures.

Don't worry about other architectures, lets focus on Power, because
that's the case where you can reprouce funnies. Now Power only has 2
barrier ops (not quite true, but close enough for all this):

 - SYNC is the full barrier

 - LWSYNC is a TSO like barrier

Pretty much everything (LOAD-ACQUIRE, STORE-RELEASE, WMB, RMB) uses
LWSYNC. Only MB result in SYNC.

Power is 'funny' because their spinlocks are weaker than everybody
else's, but AFAICT that doesn't seem relevant here.

> Using what you have above I get the same thing. It looks like it should be
> ordered but in practice it's not, and ordering it "more" as I did in the
> patch, fixes it.

And you're running Linus' tree, not some franken-kernel from RHT, right?
As asked in that other email, can you try with just the WMB added? I
really don't believe that RMB you added can make a difference.

Also, can you try with TTWU_QUEUE disabled (without any additional
barriers added), that simplifies the wakeup path a lot.

> Is it possible that the bit field is causing some of the assumptions about
> ordering in those various macros to be off?

*should* not matter...

	prev->sched_contributes_to_load = X;

	smp_store_release(&prev->on_cpu, 0);
	  asm("LWSYNC" : : : "memory");
	  WRITE_ONCE(prev->on_cpu, 0);

due to that memory clobber, the compiler must emit whatever stores are
required for the bitfield prior to the LWSYNC.

> I notice in all the comments about smp_mb__after_spinlock etc, it's always
> WRITE_ONCE/READ_ONCE on the variables in question but we can't do that with
> the bit field.

Yeah, but both ->on_rq and ->sched_contributes_to_load are 'normal'
stores. That said, given that ttwu() does a READ_ONCE() on ->on_rq, we
should match that with WRITE_ONCE()...

So I think we should do the below, but I don't believe it'll make a
difference. Let me stare more.

---
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ca9a523c9a6c..da93551b298d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1973,12 +1973,12 @@ void activate_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	enqueue_task(rq, p, flags);
 
-	p->on_rq = TASK_ON_RQ_QUEUED;
+	WRITE_ONCE(p->on_rq, TASK_ON_RQ_QUEUED);
 }
 
 void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 {
-	p->on_rq = (flags & DEQUEUE_SLEEP) ? 0 : TASK_ON_RQ_MIGRATING;
+	WRITE_ONCE(p->on_rq, (flags & DEQUEUE_SLEEP) ? 0 : TASK_ON_RQ_MIGRATING);
 
 	dequeue_task(rq, p, flags);
 }
@@ -5662,11 +5662,11 @@ static bool try_steal_cookie(int this, int that)
 		if (p->core_occupation > dst->idle->core_occupation)
 			goto next;
 
-		p->on_rq = TASK_ON_RQ_MIGRATING;
+		WRITE_ONCE(p->on_rq, TASK_ON_RQ_MIGRATING);
 		deactivate_task(src, p, 0);
 		set_task_cpu(p, this);
 		activate_task(dst, p, 0);
-		p->on_rq = TASK_ON_RQ_QUEUED;
+		WRITE_ONCE(p->on_rq, TASK_ON_RQ_QUEUED);
 
 		resched_curr(dst);
 

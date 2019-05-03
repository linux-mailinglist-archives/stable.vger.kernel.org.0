Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C3D12D26
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 14:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbfECMHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 08:07:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35426 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfECMHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 08:07:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CTcaPLZ71PMebh0OE9aB0nMDKUdLSjYGJPD8noFJpHs=; b=s7hQthgdrLLLSgubM3yGeWq01
        a6Uq3MQ3MUiA+pcNM0MCld5sqz5aJkYrpUpMsk45qF6rXOKjH4ViqqV3vHTzIYtv65tZmJ5ZucrYt
        LJKQKx+n8dN/7EEg2tf/r4c/aUI9KFY7bF0Dyb460CqRXvKRpTWXfD3CVircEAo2X+GOuTDb4akIM
        kOJRNswIVs4RmRaQqpixxsc5cxI28d0NJCtSSP8zfIDnEiCo4jkzmF4aV5Ezfg8SmaorJubKmRRck
        h9HDleR4aSIHxxCIw/Cj38A+u7jj3AAcf6dgVOL0yxbmIPHlS5lBO62OfUoSOLcrZuy4lLHW5Qg7y
        czXsKzK0w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hMWxw-000520-Oi; Fri, 03 May 2019 12:07:01 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 39DBA29B65EA3; Fri,  3 May 2019 14:06:56 +0200 (CEST)
Date:   Fri, 3 May 2019 14:06:56 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Waiman Long <longman@redhat.com>
Cc:     Ingo Molnar <mingo@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH-tip v7 01/20] locking/rwsem: Prevent decrement of reader
 count before increment
Message-ID: <20190503120656.GD2623@hirez.programming.kicks-ass.net>
References: <20190428212557.13482-1-longman@redhat.com>
 <20190428212557.13482-2-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190428212557.13482-2-longman@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 28, 2019 at 05:25:38PM -0400, Waiman Long wrote:
> During my rwsem testing, it was found that after a down_read(), the
> reader count may occasionally become 0 or even negative. Consequently,
> a writer may steal the lock at that time and execute with the reader
> in parallel thus breaking the mutual exclusion guarantee of the write
> lock. In other words, both readers and writer can become rwsem owners
> simultaneously.
> 
> The current reader wakeup code does it in one pass to clear waiter->task
> and put them into wake_q before fully incrementing the reader count.
> Once waiter->task is cleared, the corresponding reader may see it,
> finish the critical section and do unlock to decrement the count before
> the count is incremented. This is not a problem if there is only one
> reader to wake up as the count has been pre-incremented by 1.  It is
> a problem if there are more than one readers to be woken up and writer
> can steal the lock.
> 
> The wakeup was actually done in 2 passes before the v4.9 commit
> 70800c3c0cc5 ("locking/rwsem: Scan the wait_list for readers only
> once"). To fix this problem, the wakeup is now done in two passes
> again. In the first pass, we collect the readers and count them. The
> reader count is then fully incremented. In the second pass, the
> waiter->task is then cleared and they are put into wake_q to be woken
> up later.
> 
> Fixes: 70800c3c0cc5 ("locking/rwsem: Scan the wait_list for readers only once")

It is effectively a revert of that patch, right? Just written more
clever.


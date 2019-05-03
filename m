Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6F812F3E
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 15:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbfECNch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 09:32:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfECNch (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 09:32:37 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 05DD0328C8A1;
        Fri,  3 May 2019 13:32:37 +0000 (UTC)
Received: from llong.remote.csb (dhcp-17-85.bos.redhat.com [10.18.17.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B60DE60BF7;
        Fri,  3 May 2019 13:32:35 +0000 (UTC)
Subject: Re: [PATCH-tip v7 01/20] locking/rwsem: Prevent decrement of reader
 count before increment
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        stable@vger.kernel.org
References: <20190428212557.13482-1-longman@redhat.com>
 <20190428212557.13482-2-longman@redhat.com>
 <20190503120656.GD2623@hirez.programming.kicks-ass.net>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <66a295a1-86ca-5e3c-a41a-ec335ab35b78@redhat.com>
Date:   Fri, 3 May 2019 09:32:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503120656.GD2623@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 03 May 2019 13:32:37 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/3/19 8:06 AM, Peter Zijlstra wrote:
> On Sun, Apr 28, 2019 at 05:25:38PM -0400, Waiman Long wrote:
>> During my rwsem testing, it was found that after a down_read(), the
>> reader count may occasionally become 0 or even negative. Consequently,
>> a writer may steal the lock at that time and execute with the reader
>> in parallel thus breaking the mutual exclusion guarantee of the write
>> lock. In other words, both readers and writer can become rwsem owners
>> simultaneously.
>>
>> The current reader wakeup code does it in one pass to clear waiter->task
>> and put them into wake_q before fully incrementing the reader count.
>> Once waiter->task is cleared, the corresponding reader may see it,
>> finish the critical section and do unlock to decrement the count before
>> the count is incremented. This is not a problem if there is only one
>> reader to wake up as the count has been pre-incremented by 1.  It is
>> a problem if there are more than one readers to be woken up and writer
>> can steal the lock.
>>
>> The wakeup was actually done in 2 passes before the v4.9 commit
>> 70800c3c0cc5 ("locking/rwsem: Scan the wait_list for readers only
>> once"). To fix this problem, the wakeup is now done in two passes
>> again. In the first pass, we collect the readers and count them. The
>> reader count is then fully incremented. In the second pass, the
>> waiter->task is then cleared and they are put into wake_q to be woken
>> up later.
>>
>> Fixes: 70800c3c0cc5 ("locking/rwsem: Scan the wait_list for readers only once")
> It is effectively a revert of that patch, right? Just written more
> clever.
>
Yes, it is essentially a revert.

Cheers,
Longman


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4351BE150
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 16:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgD2Oiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 10:38:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:39534 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgD2Oiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Apr 2020 10:38:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D2AD3ABCC;
        Wed, 29 Apr 2020 14:38:46 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 29 Apr 2020 16:38:47 +0200
From:   Roman Penyaev <rpenyaev@suse.de>
To:     Jason Baron <jbaron@akamai.com>
Cc:     Khazhismel Kumykov <khazhy@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Heiher <r@hev.cc>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] eventpoll: fix missing wakeup for ovflist in
 ep_poll_callback
In-Reply-To: <6fa9b33c-b661-f0f6-1965-e379c7201172@akamai.com>
References: <20200424025057.118641-1-khazhy@google.com>
 <20200424190039.192373-1-khazhy@google.com>
 <66f26e74-6c7b-28c2-8b3f-faf8ea5229d4@akamai.com>
 <CACGdZYLD9ZqJNVktHUVe6N4t28VKy-Z76ZcCdsAOJHZRXaYGSA@mail.gmail.com>
 <a2f22c3c-c25a-4bda-8339-a7bdaf17849e@akamai.com>
 <c365a245574d4a4ed8a922018bcf4f45@suse.de>
 <6fa9b33c-b661-f0f6-1965-e379c7201172@akamai.com>
Message-ID: <ec0acbcbbe2ee562e0f23f8fdf6daac5@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-04-29 06:12, Jason Baron wrote:
> On 4/28/20 2:10 PM, Roman Penyaev wrote:
>> On 2020-04-27 22:38, Jason Baron wrote:
>>> On 4/25/20 4:59 PM, Khazhismel Kumykov wrote:
>>>> On Sat, Apr 25, 2020 at 9:17 AM Jason Baron <jbaron@akamai.com> 
>>>> wrote:
>>>>> 
>>>>> 
>>>>> 
>>>>> On 4/24/20 3:00 PM, Khazhismel Kumykov wrote:
>>>>>> In the event that we add to ovflist, before 339ddb53d373 we would 
>>>>>> be
>>>>>> woken up by ep_scan_ready_list, and did no wakeup in 
>>>>>> ep_poll_callback.
>>>>>> With that wakeup removed, if we add to ovflist here, we may never 
>>>>>> wake
>>>>>> up. Rather than adding back the ep_scan_ready_list wakeup - which 
>>>>>> was
>>>>>> resulting in unnecessary wakeups, trigger a wake-up in 
>>>>>> ep_poll_callback.
>>>>> 
>>>>> I'm just curious which 'wakeup' we are talking about here? There 
>>>>> is:
>>>>> wake_up(&ep->wq) for the 'ep' and then there is the nested one via:
>>>>> ep_poll_safewake(ep, epi). It seems to me that its only about the 
>>>>> later
>>>>> one being missing not both? Is your workload using nested epoll?
>>>>> 
>>>>> If so, it might make sense to just do the later, since the point of
>>>>> the original patch was to minimize unnecessary wakeups.
>>>> 
>>>> The missing wake-ups were when we added to ovflist instead of 
>>>> rdllist.
>>>> Both are "the ready list" together - so I'd think we'd want the same
>>>> wakeups regardless of which specific list we added to.
>>>> ep_poll_callback isn't nested specific?
>>>> 
>>> 
>>> So I was thinking that ep_poll() would see these events on the
>>> ovflist without an explicit wakeup, b/c the overflow list being 
>>> active
>>> implies that the ep_poll() path would add them to the rdllist in
>>> ep_scan_read_list(). Thus, it will see the events either in the
>>> current ep_poll() context or via a subsequent syscall to 
>>> epoll_wait().
>>> 
>>> However, there are other paths that can call ep_scan_ready_list() 
>>> thus
>>> I agree with you that both wakeups here are necessary.
>>> 
>>> I do think are are still (smaller) potential races in 
>>> ep_scan_ready_list()
>>> where we have:
>>> 
>>>         write_lock_irq(&ep->lock);
>>>         list_splice_init(&ep->rdllist, &txlist);
>>>         WRITE_ONCE(ep->ovflist, NULL);
>>>         write_unlock_irq(&ep->lock);
>>> 
>>> And in the ep_poll path we have:
>>> 
>>> static inline int ep_events_available(struct eventpoll *ep)
>>> {
>>>         return !list_empty_careful(&ep->rdllist) ||
>>>                 READ_ONCE(ep->ovflist) != EP_UNACTIVE_PTR;
>>> }
>>> 
>>> 
>>> Seems to me that first bit needs to be the following, since
>>> ep_events_available() is now checked in a lockless way:
>>> 
>>> 
>>>         write_lock_irq(&ep->lock);
>>>     WRITE_ONCE(ep->ovflist, NULL);
>>>     smp_wmb();
>>>         list_splice_init(&ep->rdllist, &txlist);
>>>         write_unlock_irq(&ep->lock);
>> 
>> 
>> Hi Jason,
>> 
>> For the first chunk you refer the order seems irrelevant.
>> Either you see something not empty, you go take the lock
>> and then check lists under the lock, either you see all
>> lists are empty.
>> 
> 
> Hi Roman,
> 
> It does matter. Let's say we have:
> 
> epfd1->epfd2->socket. And thread a is doing an
> epoll_wait() on epfd1, and thread b is doing
> epoll_wait on epfd2. then:
> 
> 1) data comes in on socket
> 
> ep_poll_callback() wakes up threads a and b
> 
> 2) thread a runs
> 
> ep_poll()
>  ep_scan_ready_list()
>   ep_send_events_proc()
>    ep_item_poll()
>      ep_scan_ready_list()
>        list_splice_init(&ep->rdllist, &txlist);
> 
> 3) now thread b is running
> 
> ep_poll()
>  ep_events_available()
>    returns false
>  schedule_hrtimeout_range()
> 
> Thus, thread c has missed a wakeup and will never
> get it.
> 
> 
> Similarly, for the second chunk I referenced.

Hi Jason,

Yes, that makes sense.

>>> 
>>> And also this bit:
>>> 
>>>         WRITE_ONCE(ep->ovflist, EP_UNACTIVE_PTR)>>
>>>         /*
>>>          * Quickly re-inject items left on "txlist".
>>>          */
>>>         list_splice(&txlist, &ep->rdllist);
>>> 
>>> Should I think better be reversed as well to:
>>> 
>>> list_splice(&txlist, &ep->rdllist);
>>> smp_wmb();
>>> WRITE_ONCE(ep->ovflist, EP_UNACTIVE_PTR);
>> 
>> But this one is much more interesting.  I understand what you
>> are trying to achieve: we can't leave both lists empty for the
>> short period of time, if there is something left the caller
>> of ep_events_available() should be able to see one of the lists
>> is not empty, otherwise it can be too late.
>> 
>> But the problem you've spotted is much worse. Some remains
>> can be in the txlist (this can happen if caller of epoll_wait
>> wants to harvest only 1 event, but there are more in the ->rdlist).
>> And we again get the lost wakeup.
>> 
>> Problem is reproduced by the test below.  The idea is simple:
>> we have 10 threads and 10 event fds. Each thread can harvest
>> only 1 event. 1 producer fires all 10 events at once and waits
>> that all 10 events will be observed by 10 threads.
>> 
>> The fix is basically a revert of 339ddb53d373 with 1 major
>> exception: we do wakeups from ep_scan_ready_list() but
>> if txlist is not empty && if ep_scan_ready_list() is called
>> from the routine, which sends events, not reads it
>> (thus we protect ourselves from repeated wake ups)
>> 
>> I will send the code a bit later.
> 
> This was discussed as part of the original discussion around
> 339ddb53d373: https://lkml.org/lkml/2019/10/7/905

True! This is the exact scenario which is covered by the
test from my previous email. And the test fails. I forgot
about this discussion.

> The context was more a performance difference rather than
> a semantic difference, but as I pointed out I believe that
> behavior pre-dates the above commit and goes back to:
> 86c0517 fs/epoll: deal with wait_queue only once
> 
> There, since the thread is left on the waitqueue over the
> ep_scan_ready_list() thus the ep_wakeup() (that was removed
> in 339ddb53d373), would no longer wakeup other potential
> waiters.
> 
> So since I think this behavior change goes back to 5.0 and there
> really haven't been any reports, I don't think there are
> too many apps relying on these semantics that your test
> case is showing. It would be interesting to confirm that
> your test does indeed succeed/fail before/after that patch.

The main problem is that two sequential wakeups can hit the
same thread, while the wait queue entry is still in the list.
You also described this in https://lkml.org/lkml/2019/10/7/905

If we wakeup only from ep_poll_callback (current code state)
we have to be sure each wakeup hits new wait queue entry.
This behavior can be achieved with autoremove_wake_function,
which should be also good performance-wise, since after
an explicit wakeup you don't need to remove the wait entry
from the list under the lock.

At the end it turns out like this:

1. either we need to wakeup additionally from ep_scan_ready_list(),
    this is what we had prior 339ddb53d373.

2. either we wait with autoremove_wake_function, thus we
    guarantee, that each new wakeup hits new thread.


I'm testing both variants using the last test I sent yesterday,
works so far.

I personally tend to the second variant, I really don't like
"we-wakeup-from-all-the-places" solution.

Could you please take a look on the patch below? It probably
needs some tweaks, but the idea should be clear.

> Also, as part of that original discussion, you had a patch
> that I think addresses this. I would be ok with that, in
> addition to a patch to address the ordering issue I pointed
> out. I can post a patch for the former, if you think this
> plan makes sense?

Go ahead with you reordering findings! That is correct for
a single wakeup, which we have in the ep_poll_callback().

--
Roman


diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index d6ba0e52439b..1057598cd299 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1822,7 +1822,6 @@ static int ep_poll(struct eventpoll *ep, struct 
epoll_event __user *events,
  {
         int res = 0, eavail, timed_out = 0;
         u64 slack = 0;
-       bool waiter = false;
         wait_queue_entry_t wait;
         ktime_t expires, *to = NULL;

@@ -1867,21 +1866,12 @@ static int ep_poll(struct eventpoll *ep, struct 
epoll_event __user *events,
          */
         ep_reset_busy_poll_napi_id(ep);

-       /*
-        * We don't have any available event to return to the caller.  
We need
-        * to sleep here, and we will be woken by ep_poll_callback() 
when events
-        * become available.
-        */
-       if (!waiter) {
-               waiter = true;
-               init_waitqueue_entry(&wait, current);
-
+       do {
+               init_wait(&wait);
                 write_lock_irq(&ep->lock);
                 __add_wait_queue_exclusive(&ep->wq, &wait);
                 write_unlock_irq(&ep->lock);
-       }

-       for (;;) {
                 /*
                  * We don't want to sleep if the ep_poll_callback() 
sends us
                  * a wakeup in between. That's why we set the task state
@@ -1911,6 +1901,16 @@ static int ep_poll(struct eventpoll *ep, struct 
epoll_event __user *events,
                         timed_out = 1;
                         break;
                 }
+
+               /* We were woken up, thus go and try to harvest some 
events */
+               eavail = 1;
+
+       } while (0);
+
+       if (!list_empty_careful(&wait.entry)) {
+               write_lock_irq(&ep->lock);
+               __remove_wait_queue(&ep->wq, &wait);
+               write_unlock_irq(&ep->lock);
         }
         __set_current_state(TASK_RUNNING);
@@ -1925,12 +1925,6 @@ static int ep_poll(struct eventpoll *ep, struct 
epoll_event __user *events,
             !(res = ep_send_events(ep, events, maxevents)) && 
!timed_out)
                 goto fetch_events;

-       if (waiter) {
-               write_lock_irq(&ep->lock);
-               __remove_wait_queue(&ep->wq, &wait);
-               write_unlock_irq(&ep->lock);
-       }
-
         return res;
  }




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA471C35E9
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 11:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgEDJkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 05:40:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:58304 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgEDJkv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 05:40:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 350A2AE53;
        Mon,  4 May 2020 09:40:50 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 04 May 2020 11:40:47 +0200
From:   Roman Penyaev <rpenyaev@suse.de>
To:     Jason Baron <jbaron@akamai.com>
Cc:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Heiher <r@hev.cc>,
        Khazhismel Kumykov <khazhy@google.com>,
        Davidlohr Bueso <dbueso@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH] epoll: ensure ep_poll() doesn't miss wakeup events
In-Reply-To: <8632df62-7475-3328-4a38-95462fbc410d@akamai.com>
References: <1588360533-11828-1-git-send-email-jbaron@akamai.com>
 <930c565705249d2b6264a31f1be6529e@suse.de>
 <81612721-9448-83fa-4efe-603996d56b9a@akamai.com>
 <f3c2e63ec34a611ec256785ebfd39270@suse.de>
 <842aa331-b650-bf99-8ea9-b5d3e0866054@akamai.com>
 <8632df62-7475-3328-4a38-95462fbc410d@akamai.com>
Message-ID: <6a89e6eea469ece264e656970ad7be98@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-05-04 06:59, Jason Baron wrote:
> On 5/4/20 12:29 AM, Jason Baron wrote:
>> 
>> 
>> On 5/3/20 6:24 AM, Roman Penyaev wrote:
>>> On 2020-05-02 00:09, Jason Baron wrote:
>>>> On 5/1/20 5:02 PM, Roman Penyaev wrote:
>>>>> Hi Jason,
>>>>> 
>>>>> That is indeed a nice catch.
>>>>> Seems we need smp_rmb() pair between 
>>>>> list_empty_careful(&rp->rdllist) and
>>>>> READ_ONCE(ep->ovflist) for ep_events_available(), do we?
>>>>> 
>>>> 
>>>> Hi Roman,
>>>> 
>>>> Good point, even if we order those reads its still racy, since the
>>>> read of the ready list could come after its been cleared and the
>>>> read of the overflow could again come after its been cleared.
>>> 
>>> You mean the second chunk? True. Sigh.
>>> 
>>>> So I'm afraid we might need instead something like this to make
>>>> sure they are read together:
>>> 
>>> No, impossible, I can't believe in that :) We can't give up.
>>> 
>>> All we need is to keep a mark, that ep->rdllist is not empty,
>>> even we've just spliced it.  ep_poll_callback() always takes
>>> the ->ovflist path, if ->ovflist is not EP_UNACTIVE_PTR, but
>>> ep_events_available() does not need to observe ->ovflist at
>>> all, just a ->rdllist.
>>> 
>>> Take a look at that, do I miss something? :
>>> 
>>> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
>>> index aba03ee749f8..a8770f9a917e 100644
>>> --- a/fs/eventpoll.c
>>> +++ b/fs/eventpoll.c
>>> @@ -376,8 +376,7 @@ static void ep_nested_calls_init(struct 
>>> nested_calls *ncalls)
>>>   */
>>>  static inline int ep_events_available(struct eventpoll *ep)
>>>  {
>>> -       return !list_empty_careful(&ep->rdllist) ||
>>> -               READ_ONCE(ep->ovflist) != EP_UNACTIVE_PTR;
>>> +       return !list_empty_careful(&ep->rdllist);
>>>  }
>>> 
>>>  #ifdef CONFIG_NET_RX_BUSY_POLL
>>> @@ -683,7 +682,8 @@ static __poll_t ep_scan_ready_list(struct 
>>> eventpoll *ep,
>>>  {
>>>         __poll_t res;
>>>         struct epitem *epi, *nepi;
>>> -       LIST_HEAD(txlist);
>>> +       LIST_HEAD(rdllist);
>>> +       LIST_HEAD(ovflist);
>>> 
>>>         lockdep_assert_irqs_enabled();
>>> 
>>> @@ -704,14 +704,22 @@ static __poll_t ep_scan_ready_list(struct 
>>> eventpoll *ep,
>>>          * in a lockless way.
>>>          */
>>>         write_lock_irq(&ep->lock);
>>> -       list_splice_init(&ep->rdllist, &txlist);
>>> +       /*
>>> +        * We do not call list_splice_init() because for lockless
>>> +        * ep_events_available() ->rdllist is still "not empty".
>>> +        * Otherwise the feature that there is something left in
>>> +        * the list can be lost which causes missed wakeup.
>>> +        */
>>> +       list_splice(&ep->rdllist, &rdllist);
>>> +       /*
>>> +        * If ->rdllist was empty we should pretend it was not,
>>> +        * because after the unlock ->ovflist comes into play,
>>> +        * which is invisible for lockless ep_events_available().
>>> +        */
>>> +       ep->rdllist.next = LIST_POISON1;
>>>         WRITE_ONCE(ep->ovflist, NULL);
>>>         write_unlock_irq(&ep->lock);
>>> 
>>>         /*
>>>          * Now call the callback function.
>>>          */
>>> -       res = (*sproc)(ep, &txlist, priv);
>>> +       res = (*sproc)(ep, &rdllist, priv);
>>> 
>>>         write_lock_irq(&ep->lock);
>>>         /*
>>> @@ -724,7 +732,7 @@ static __poll_t ep_scan_ready_list(struct 
>>> eventpoll *ep,
>>>                 /*
>>>                  * We need to check if the item is already in the 
>>> list.
>>>                  * During the "sproc" callback execution time, items 
>>> are
>>> -                * queued into ->ovflist but the "txlist" might 
>>> already
>>> +                * queued into ->ovflist but the "rdllist" might 
>>> already
>>>                  * contain them, and the list_splice() below takes 
>>> care of them.
>>>                  */
>>>                 if (!ep_is_linked(epi)) {
>>> @@ -732,7 +740,7 @@ static __poll_t ep_scan_ready_list(struct 
>>> eventpoll *ep,
>>>                          * ->ovflist is LIFO, so we have to reverse 
>>> it in order
>>>                          * to keep in FIFO.
>>>                          */
>>> -                       list_add(&epi->rdllink, &ep->rdllist);
>>> +                       list_add(&epi->rdllink, &ovflist);
>>>                         ep_pm_stay_awake(epi);
>>>                 }
>>>         }
>>> @@ -743,10 +751,11 @@ static __poll_t ep_scan_ready_list(struct 
>>> eventpoll *ep,
>>>          */
>>>         WRITE_ONCE(ep->ovflist, EP_UNACTIVE_PTR);
>>> 
>>> -       /*
>>> -        * Quickly re-inject items left on "txlist".
>>> -        */
>>> -       list_splice(&txlist, &ep->rdllist);
>>> +       /* Events from ->ovflist happened later, thus splice to the 
>>> tail */
>>> +       list_splice_tail(&ovflist, &rdllist);
>>> +       /* Just replace list */
>>> +       list_replace(&rdllist, &ep->rdllist);
>>> +
>>>         __pm_relax(ep->ws);
>>>         write_unlock_irq(&ep->lock);
>>> 
>>> @@ -1763,13 +1772,13 @@ static __poll_t ep_send_events_proc(struct 
>>> eventpoll *ep, struct list_head *head
>>>                          * Trigger mode, we need to insert back 
>>> inside
>>>                          * the ready list, so that the next call to
>>>                          * epoll_wait() will check again the events
>>> -                        * availability. At this point, no one can 
>>> insert
>>> -                        * into ep->rdllist besides us. The 
>>> epoll_ctl()
>>> -                        * callers are locked out by
>>> -                        * ep_scan_ready_list() holding "mtx" and the
>>> -                        * poll callback will queue them in 
>>> ep->ovflist.
>>> +                        * availability. What we do here is simply
>>> +                        * return the epi to the same position where
>>> +                        * it was, the ep_scan_ready_list() will
>>> +                        * re-inject the leftovers to the ->rdllist
>>> +                        * under the proper lock.
>>>                          */
>>> -                       list_add_tail(&epi->rdllink, &ep->rdllist);
>>> +                       list_add_tail(&epi->rdllink, &tmp->rdllink);
>>>                         ep_pm_stay_awake(epi);
>>>                 }
>>>         }
>>> 
>>> 
>>> --
>>> Roman
>>> 
>> 
>> 
>> Hi Roman,
>> 
>> I think this misses an important case - the initial ep_poll_callback()
>> may queue to the overflow list. In this case ep_poll has no visibility
>> into the event since its only checking ep->rdllist.
> 
> Ok, my mistake - I see it sets: ep->rdllist.next = LIST_POISON1; for 
> that
> case. Ok I think this approach makes sense then.

Hi Jason,

I want also to emphasize, that the original behavior should not be 
changed
(correct me if I'm wrong): callers of ep_events_available() will get 
false
positive (something is available, but under the lock when ->ovflist is
resolved, it turns out to be no events to harvest). This was always like
that and this is fine, since the final decision is made under the proper
lock.

(I speak it out loud to accurately cover all the cases).

I will take couple of days for testing and then send out a patch.
No objections on that?

--
Roman


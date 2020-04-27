Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405DF1BAF9B
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 22:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgD0UiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 16:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726205AbgD0UiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 16:38:09 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4D5C0610D5;
        Mon, 27 Apr 2020 13:38:09 -0700 (PDT)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 03RKUOYG027508;
        Mon, 27 Apr 2020 21:38:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=Xk6H3qlPs8/T+MwYn7e+lTfgfR06gunAjHmC1efrlFs=;
 b=NWGr6wbtj/iYC0XKPgUu9Js14hkTLXe2cMaFbA4vjpO+wH2k+znzefbvTqXMkRn1KNcm
 ca5BuWhVVhdLgjvkxl0yH15agPjxNm9Z4+itvHZajKRzYLApyaAyrKcqVbC4osPaj867
 EuwfHEQZxWQbSAD8KQQ088Bco9Bu7n1UouBdyC6ywTbW0wAaGBxCxH4TcVx+DzS8S3o5
 XpIXdDoQbIDjFLFoWrSw7+ji0tDK85Pui+BndZirKS1Ab9E7N6Cf3nHB+Vi2eJHY+E0o
 hx56/TzSA9gaeKppEakkWMxCKfcrFqo7m+F5o6hAUVaQg6U9vWUL0q3SG7drfKcPfQkQ Sw== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 30mdm9hw6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 21:38:04 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.27/8.16.0.27) with SMTP id 03RKXvNq004182;
        Mon, 27 Apr 2020 16:38:03 -0400
Received: from prod-mail-relay14.akamai.com ([172.27.17.39])
        by prod-mail-ppoint6.akamai.com with ESMTP id 30mghv92f2-1;
        Mon, 27 Apr 2020 16:38:03 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay14.akamai.com (Postfix) with ESMTP id 6C51485B92;
        Mon, 27 Apr 2020 20:38:02 +0000 (GMT)
Subject: Re: [PATCH v2] eventpoll: fix missing wakeup for ovflist in
 ep_poll_callback
To:     Khazhismel Kumykov <khazhy@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Penyaev <rpenyaev@suse.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Heiher <r@hev.cc>,
        stable@vger.kernel.org
References: <20200424025057.118641-1-khazhy@google.com>
 <20200424190039.192373-1-khazhy@google.com>
 <66f26e74-6c7b-28c2-8b3f-faf8ea5229d4@akamai.com>
 <CACGdZYLD9ZqJNVktHUVe6N4t28VKy-Z76ZcCdsAOJHZRXaYGSA@mail.gmail.com>
From:   Jason Baron <jbaron@akamai.com>
Message-ID: <a2f22c3c-c25a-4bda-8339-a7bdaf17849e@akamai.com>
Date:   Mon, 27 Apr 2020 16:38:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CACGdZYLD9ZqJNVktHUVe6N4t28VKy-Z76ZcCdsAOJHZRXaYGSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_16:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=940
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2002250000 definitions=main-2004270167
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 suspectscore=0
 mlxlogscore=944 impostorscore=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270167
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/25/20 4:59 PM, Khazhismel Kumykov wrote:
> On Sat, Apr 25, 2020 at 9:17 AM Jason Baron <jbaron@akamai.com> wrote:
>>
>>
>>
>> On 4/24/20 3:00 PM, Khazhismel Kumykov wrote:
>>> In the event that we add to ovflist, before 339ddb53d373 we would be
>>> woken up by ep_scan_ready_list, and did no wakeup in ep_poll_callback.
>>> With that wakeup removed, if we add to ovflist here, we may never wake
>>> up. Rather than adding back the ep_scan_ready_list wakeup - which was
>>> resulting in unnecessary wakeups, trigger a wake-up in ep_poll_callback.
>>
>> I'm just curious which 'wakeup' we are talking about here? There is:
>> wake_up(&ep->wq) for the 'ep' and then there is the nested one via:
>> ep_poll_safewake(ep, epi). It seems to me that its only about the later
>> one being missing not both? Is your workload using nested epoll?
>>
>> If so, it might make sense to just do the later, since the point of
>> the original patch was to minimize unnecessary wakeups.
> 
> The missing wake-ups were when we added to ovflist instead of rdllist.
> Both are "the ready list" together - so I'd think we'd want the same
> wakeups regardless of which specific list we added to.
> ep_poll_callback isn't nested specific?
>

So I was thinking that ep_poll() would see these events on the
ovflist without an explicit wakeup, b/c the overflow list being active
implies that the ep_poll() path would add them to the rdllist in
ep_scan_read_list(). Thus, it will see the events either in the
current ep_poll() context or via a subsequent syscall to epoll_wait().

However, there are other paths that can call ep_scan_ready_list() thus
I agree with you that both wakeups here are necessary.

I do think are are still (smaller) potential races in ep_scan_ready_list()
where we have:

        write_lock_irq(&ep->lock);
        list_splice_init(&ep->rdllist, &txlist);
        WRITE_ONCE(ep->ovflist, NULL);
        write_unlock_irq(&ep->lock);

And in the ep_poll path we have:

static inline int ep_events_available(struct eventpoll *ep)
{
        return !list_empty_careful(&ep->rdllist) ||
                READ_ONCE(ep->ovflist) != EP_UNACTIVE_PTR;
}


Seems to me that first bit needs to be the following, since
ep_events_available() is now checked in a lockless way:


        write_lock_irq(&ep->lock);
	WRITE_ONCE(ep->ovflist, NULL);
	smp_wmb();
        list_splice_init(&ep->rdllist, &txlist);
        write_unlock_irq(&ep->lock);


And also this bit:

        WRITE_ONCE(ep->ovflist, EP_UNACTIVE_PTR);

        /*
         * Quickly re-inject items left on "txlist".
         */
        list_splice(&txlist, &ep->rdllist);

Should I think better be reversed as well to:

list_splice(&txlist, &ep->rdllist);
smp_wmb();
WRITE_ONCE(ep->ovflist, EP_UNACTIVE_PTR);


I can send those as a separate patch followup.

Thanks,

-Jason


>>> We noticed that one of our workloads was missing wakeups starting with
>>> 339ddb53d373 and upon manual inspection, this wakeup seemed missing to
>>> me. With this patch added, we no longer see missing wakeups. I haven't
>>> yet tried to make a small reproducer, but the existing kselftests in
>>> filesystem/epoll passed for me with this patch.
>>>
>>> Fixes: 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")
>>>
>>> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
>>> Reviewed-by: Roman Penyaev <rpenyaev@suse.de>
>>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>>> Cc: Heiher <r@hev.cc>
>>> Cc: Jason Baron <jbaron@akamai.com>
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>> v2: use if/elif instead of goto + cleanup suggested by Roman
>>>  fs/eventpoll.c | 18 +++++++++---------
>>>  1 file changed, 9 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
>>> index 8c596641a72b..d6ba0e52439b 100644
>>> --- a/fs/eventpoll.c
>>> +++ b/fs/eventpoll.c
>>> @@ -1171,6 +1171,10 @@ static inline bool chain_epi_lockless(struct epitem *epi)
>>>  {
>>>       struct eventpoll *ep = epi->ep;
>>>
>>> +     /* Fast preliminary check */
>>> +     if (epi->next != EP_UNACTIVE_PTR)
>>> +             return false;
>>> +
>>>       /* Check that the same epi has not been just chained from another CPU */
>>>       if (cmpxchg(&epi->next, EP_UNACTIVE_PTR, NULL) != EP_UNACTIVE_PTR)
>>>               return false;
>>> @@ -1237,16 +1241,12 @@ static int ep_poll_callback(wait_queue_entry_t *wait, unsigned mode, int sync, v
>>>        * chained in ep->ovflist and requeued later on.
>>>        */
>>>       if (READ_ONCE(ep->ovflist) != EP_UNACTIVE_PTR) {
>>> -             if (epi->next == EP_UNACTIVE_PTR &&
>>> -                 chain_epi_lockless(epi))
>>> +             if (chain_epi_lockless(epi))
>>> +                     ep_pm_stay_awake_rcu(epi);
>>> +     } else if (!ep_is_linked(epi)) {
>>> +             /* In the usual case, add event to ready list. */
>>> +             if (list_add_tail_lockless(&epi->rdllink, &ep->rdllist))
>>>                       ep_pm_stay_awake_rcu(epi);
>>> -             goto out_unlock;
>>> -     }
>>> -
>>> -     /* If this file is already in the ready list we exit soon */
>>> -     if (!ep_is_linked(epi) &&
>>> -         list_add_tail_lockless(&epi->rdllink, &ep->rdllist)) {
>>> -             ep_pm_stay_awake_rcu(epi);
>>>       }
>>>
>>>       /*
>>>

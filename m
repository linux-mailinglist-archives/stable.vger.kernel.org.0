Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAAF1C3204
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 07:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgEDFAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 01:00:32 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:13652 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725859AbgEDFAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 01:00:31 -0400
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 0444wakD003458;
        Mon, 4 May 2020 05:59:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=fmpig0yn0d2DMHi1ULj0wEL9TmtVthnvE+yUNwWMGJk=;
 b=UMUyvbIM0p5qqHL4U0JnKbcSSqKk+bVZ6jNe/Gkp0gTfI48jgnDCBGS6WvI9Jvghx8q3
 wuEWukcK3kYzvHNC3WxBQSiGu5ijr/Jmu7OXVdc4igAUy4frdI0pT9ZfQ6O6kbEM2uVt
 pdlprazMjtdOO3YoV2D4InfVOJJH0iss7y/TbjUEjdMuAyyclQLGZvJ/Ly00ihS3ymV7
 TNHOiqCPL+76CS6ieiNQTxkXhz71Zonsu8sio9H2RDtFJpNzrjgyLzqIu4s+pqrEWvXT
 x5cYq6zwxsMe2XDEEfJ8/2u0EYrWBj+IQ6m248mUrx87vfW+sDTjXiZPlo8i1bWjW3WQ 0g== 
Received: from prod-mail-ppoint7 (a72-247-45-33.deploy.static.akamaitechnologies.com [72.247.45.33] (may be forged))
        by m0050095.ppops.net-00190b01. with ESMTP id 30s0d6j3x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 05:59:27 +0100
Received: from pps.filterd (prod-mail-ppoint7.akamai.com [127.0.0.1])
        by prod-mail-ppoint7.akamai.com (8.16.0.27/8.16.0.27) with SMTP id 0444lcji031818;
        Mon, 4 May 2020 00:59:26 -0400
Received: from prod-mail-relay15.akamai.com ([172.27.17.40])
        by prod-mail-ppoint7.akamai.com with ESMTP id 30t9u5gy17-1;
        Mon, 04 May 2020 00:59:25 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay15.akamai.com (Postfix) with ESMTP id 329B9230B2;
        Mon,  4 May 2020 04:59:25 +0000 (GMT)
Subject: Re: [PATCH] epoll: ensure ep_poll() doesn't miss wakeup events
From:   Jason Baron <jbaron@akamai.com>
To:     Roman Penyaev <rpenyaev@suse.de>
Cc:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Heiher <r@hev.cc>,
        Khazhismel Kumykov <khazhy@google.com>,
        Davidlohr Bueso <dbueso@suse.de>, stable@vger.kernel.org
References: <1588360533-11828-1-git-send-email-jbaron@akamai.com>
 <930c565705249d2b6264a31f1be6529e@suse.de>
 <81612721-9448-83fa-4efe-603996d56b9a@akamai.com>
 <f3c2e63ec34a611ec256785ebfd39270@suse.de>
 <842aa331-b650-bf99-8ea9-b5d3e0866054@akamai.com>
Message-ID: <8632df62-7475-3328-4a38-95462fbc410d@akamai.com>
Date:   Mon, 4 May 2020 00:59:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <842aa331-b650-bf99-8ea9-b5d3e0866054@akamai.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_02:2020-05-01,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2002250000 definitions=main-2005040040
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_02:2020-05-01,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 spamscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040041
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/4/20 12:29 AM, Jason Baron wrote:
> 
> 
> On 5/3/20 6:24 AM, Roman Penyaev wrote:
>> On 2020-05-02 00:09, Jason Baron wrote:
>>> On 5/1/20 5:02 PM, Roman Penyaev wrote:
>>>> Hi Jason,
>>>>
>>>> That is indeed a nice catch.
>>>> Seems we need smp_rmb() pair between list_empty_careful(&rp->rdllist) and
>>>> READ_ONCE(ep->ovflist) for ep_events_available(), do we?
>>>>
>>>
>>> Hi Roman,
>>>
>>> Good point, even if we order those reads its still racy, since the
>>> read of the ready list could come after its been cleared and the
>>> read of the overflow could again come after its been cleared.
>>
>> You mean the second chunk? True. Sigh.
>>
>>> So I'm afraid we might need instead something like this to make
>>> sure they are read together:
>>
>> No, impossible, I can't believe in that :) We can't give up.
>>
>> All we need is to keep a mark, that ep->rdllist is not empty,
>> even we've just spliced it.  ep_poll_callback() always takes
>> the ->ovflist path, if ->ovflist is not EP_UNACTIVE_PTR, but
>> ep_events_available() does not need to observe ->ovflist at
>> all, just a ->rdllist.
>>
>> Take a look at that, do I miss something? :
>>
>> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
>> index aba03ee749f8..a8770f9a917e 100644
>> --- a/fs/eventpoll.c
>> +++ b/fs/eventpoll.c
>> @@ -376,8 +376,7 @@ static void ep_nested_calls_init(struct nested_calls *ncalls)
>>   */
>>  static inline int ep_events_available(struct eventpoll *ep)
>>  {
>> -       return !list_empty_careful(&ep->rdllist) ||
>> -               READ_ONCE(ep->ovflist) != EP_UNACTIVE_PTR;
>> +       return !list_empty_careful(&ep->rdllist);
>>  }
>>
>>  #ifdef CONFIG_NET_RX_BUSY_POLL
>> @@ -683,7 +682,8 @@ static __poll_t ep_scan_ready_list(struct eventpoll *ep,
>>  {
>>         __poll_t res;
>>         struct epitem *epi, *nepi;
>> -       LIST_HEAD(txlist);
>> +       LIST_HEAD(rdllist);
>> +       LIST_HEAD(ovflist);
>>
>>         lockdep_assert_irqs_enabled();
>>
>> @@ -704,14 +704,22 @@ static __poll_t ep_scan_ready_list(struct eventpoll *ep,
>>          * in a lockless way.
>>          */
>>         write_lock_irq(&ep->lock);
>> -       list_splice_init(&ep->rdllist, &txlist);
>> +       /*
>> +        * We do not call list_splice_init() because for lockless
>> +        * ep_events_available() ->rdllist is still "not empty".
>> +        * Otherwise the feature that there is something left in
>> +        * the list can be lost which causes missed wakeup.
>> +        */
>> +       list_splice(&ep->rdllist, &rdllist);
>> +       /*
>> +        * If ->rdllist was empty we should pretend it was not,
>> +        * because after the unlock ->ovflist comes into play,
>> +        * which is invisible for lockless ep_events_available().
>> +        */
>> +       ep->rdllist.next = LIST_POISON1;
>>         WRITE_ONCE(ep->ovflist, NULL);
>>         write_unlock_irq(&ep->lock);
>>
>>         /*
>>          * Now call the callback function.
>>          */
>> -       res = (*sproc)(ep, &txlist, priv);
>> +       res = (*sproc)(ep, &rdllist, priv);
>>
>>         write_lock_irq(&ep->lock);
>>         /*
>> @@ -724,7 +732,7 @@ static __poll_t ep_scan_ready_list(struct eventpoll *ep,
>>                 /*
>>                  * We need to check if the item is already in the list.
>>                  * During the "sproc" callback execution time, items are
>> -                * queued into ->ovflist but the "txlist" might already
>> +                * queued into ->ovflist but the "rdllist" might already
>>                  * contain them, and the list_splice() below takes care of them.
>>                  */
>>                 if (!ep_is_linked(epi)) {
>> @@ -732,7 +740,7 @@ static __poll_t ep_scan_ready_list(struct eventpoll *ep,
>>                          * ->ovflist is LIFO, so we have to reverse it in order
>>                          * to keep in FIFO.
>>                          */
>> -                       list_add(&epi->rdllink, &ep->rdllist);
>> +                       list_add(&epi->rdllink, &ovflist);
>>                         ep_pm_stay_awake(epi);
>>                 }
>>         }
>> @@ -743,10 +751,11 @@ static __poll_t ep_scan_ready_list(struct eventpoll *ep,
>>          */
>>         WRITE_ONCE(ep->ovflist, EP_UNACTIVE_PTR);
>>
>> -       /*
>> -        * Quickly re-inject items left on "txlist".
>> -        */
>> -       list_splice(&txlist, &ep->rdllist);
>> +       /* Events from ->ovflist happened later, thus splice to the tail */
>> +       list_splice_tail(&ovflist, &rdllist);
>> +       /* Just replace list */
>> +       list_replace(&rdllist, &ep->rdllist);
>> +
>>         __pm_relax(ep->ws);
>>         write_unlock_irq(&ep->lock);
>>
>> @@ -1763,13 +1772,13 @@ static __poll_t ep_send_events_proc(struct eventpoll *ep, struct list_head *head
>>                          * Trigger mode, we need to insert back inside
>>                          * the ready list, so that the next call to
>>                          * epoll_wait() will check again the events
>> -                        * availability. At this point, no one can insert
>> -                        * into ep->rdllist besides us. The epoll_ctl()
>> -                        * callers are locked out by
>> -                        * ep_scan_ready_list() holding "mtx" and the
>> -                        * poll callback will queue them in ep->ovflist.
>> +                        * availability. What we do here is simply
>> +                        * return the epi to the same position where
>> +                        * it was, the ep_scan_ready_list() will
>> +                        * re-inject the leftovers to the ->rdllist
>> +                        * under the proper lock.
>>                          */
>> -                       list_add_tail(&epi->rdllink, &ep->rdllist);
>> +                       list_add_tail(&epi->rdllink, &tmp->rdllink);
>>                         ep_pm_stay_awake(epi);
>>                 }
>>         }
>>
>>
>> -- 
>> Roman
>>
> 
> 
> Hi Roman,
> 
> I think this misses an important case - the initial ep_poll_callback()
> may queue to the overflow list. In this case ep_poll has no visibility
> into the event since its only checking ep->rdllist.

Ok, my mistake - I see it sets: ep->rdllist.next = LIST_POISON1; for that
case. Ok I think this approach makes sense then.

Thanks,

-Jason

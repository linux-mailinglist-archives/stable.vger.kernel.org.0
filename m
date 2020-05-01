Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5C31C2063
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 00:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgEAWK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 18:10:59 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:12616 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726272AbgEAWK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 18:10:58 -0400
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 041Lvsjh029204;
        Fri, 1 May 2020 23:09:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=AmbDaqkJACrgjFztMfPQrRG1srRjV7OVgQHq59mCXjM=;
 b=fkUYzdqcL1Fl0jlN8nwOTpS6yhyNOs1mb8Hmzlag/Y0v3IrBXqGOizOlcmSGR+lAMfMW
 wFO9ffG63hoyBQN7KSQfJx+GErUq/R7vopcrItx6RLSrTbBU6r/XBQV7iQuNSao1Qlej
 AAJ26G5IfX0Ypz2BxkgHxlAZHHoXcQxBHsl5X1XHSHu3NdhxFyPC+zuyXQWfTgpgHfPc
 4rK6+TFmVxQ8gHN4u4rJxjgDLMuQsNJzox4+h5q1+bnTdhpk1rsZ5mDPVX/42BuE8kRK
 G22CbNddz0GxW6j+jY9AluQFKXBNeWHXo8eVL80FXNGydyBd8mEqn7i2bfTHXh+ZTa3d Ig== 
Received: from prod-mail-ppoint8 (a72-247-45-34.deploy.static.akamaitechnologies.com [72.247.45.34] (may be forged))
        by m0050095.ppops.net-00190b01. with ESMTP id 30r7j1nbpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 23:09:53 +0100
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.16.0.27/8.16.0.27) with SMTP id 041M2xXG006599;
        Fri, 1 May 2020 18:09:53 -0400
Received: from prod-mail-relay14.akamai.com ([172.27.17.39])
        by prod-mail-ppoint8.akamai.com with ESMTP id 30rupc8885-1;
        Fri, 01 May 2020 18:09:52 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay14.akamai.com (Postfix) with ESMTP id 1CD9385C86;
        Fri,  1 May 2020 22:09:52 +0000 (GMT)
Subject: Re: [PATCH] epoll: ensure ep_poll() doesn't miss wakeup events
To:     Roman Penyaev <rpenyaev@suse.de>
Cc:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Heiher <r@hev.cc>,
        Khazhismel Kumykov <khazhy@google.com>,
        Davidlohr Bueso <dbueso@suse.de>, stable@vger.kernel.org
References: <1588360533-11828-1-git-send-email-jbaron@akamai.com>
 <930c565705249d2b6264a31f1be6529e@suse.de>
From:   Jason Baron <jbaron@akamai.com>
Message-ID: <81612721-9448-83fa-4efe-603996d56b9a@akamai.com>
Date:   Fri, 1 May 2020 18:09:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <930c565705249d2b6264a31f1be6529e@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_16:2020-05-01,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2002250000 definitions=main-2005010154
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_16:2020-05-01,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010154
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/1/20 5:02 PM, Roman Penyaev wrote:
> Hi Jason,
> 
> That is indeed a nice catch.
> Seems we need smp_rmb() pair between list_empty_careful(&rp->rdllist) and
> READ_ONCE(ep->ovflist) for ep_events_available(), do we?
> 

Hi Roman,

Good point, even if we order those reads its still racy, since the
read of the ready list could come after its been cleared and the
read of the overflow could again come after its been cleared.

So I'm afraid we might need instead something like this to make
sure they are read together:

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index d6ba0e5..31c5f14 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1899,7 +1899,9 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
                        break;
                }

+               write_lock_irq(&ep->lock);
                eavail = ep_events_available(ep);
+               write_unlock_irq(&ep->lock);
                if (eavail)
                        break;
                if (signal_pending(current)) {


Thanks,

-Jason



> Other than that:
> 
> Reviewed-by: Roman Penyaev <rpenyaev@suse.de>
> 
> -- 
> Roman
> 
> On 2020-05-01 21:15, Jason Baron wrote:
>> Now that the ep_events_available() check is done in a lockless way, and
>> we no longer perform wakeups from ep_scan_ready_list(), we need to ensure
>> that either ep->rdllist has items or the overflow list is active. Prior to:
>> commit 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested
>> epoll"), we did wake_up(&ep->wq) after manipulating the ep->rdllist and the
>> overflow list. Thus, any waiters would observe the correct state. However,
>> with that wake_up() now removed we need to be more careful to ensure that
>> condition.
>>
>> Here's an example of what could go wrong:
>>
>> We have epoll fds: epfd1, epfd2. And epfd1 is added to epfd2 and epfd2 is
>> added to a socket: epfd1->epfd2->socket. Thread a is doing epoll_wait() on
>> epfd1, and thread b is doing epoll_wait on epfd2. Then:
>>
>> 1) data comes in on socket
>>
>> ep_poll_callback() wakes up threads a and b
>>
>> 2) thread a runs
>>
>> ep_poll()
>>  ep_scan_ready_list()
>>   ep_send_events_proc()
>>    ep_item_poll()
>>      ep_scan_ready_list()
>>        list_splice_init(&ep->rdllist, &txlist);
>>
>> 3) now thread b is running
>>
>> ep_poll()
>>  ep_events_available()
>>    returns false
>>  schedule_hrtimeout_range()
>>
>> Thus, thread b has now scheduled and missed the wakeup.
>>
>> Fixes: 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")
>> Signed-off-by: Jason Baron <jbaron@akamai.com>
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: Heiher <r@hev.cc>
>> Cc: Roman Penyaev <rpenyaev@suse.de>
>> Cc: Khazhismel Kumykov <khazhy@google.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Davidlohr Bueso <dbueso@suse.de>
>> Cc: <stable@vger.kernel.org>
>> ---
>>  fs/eventpoll.c | 23 +++++++++++++++++------
>>  1 file changed, 17 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
>> index aba03ee749f8..4af2d020f548 100644
>> --- a/fs/eventpoll.c
>> +++ b/fs/eventpoll.c
>> @@ -704,8 +704,14 @@ static __poll_t ep_scan_ready_list(struct eventpoll *ep,
>>       * in a lockless way.
>>       */
>>      write_lock_irq(&ep->lock);
>> -    list_splice_init(&ep->rdllist, &txlist);
>>      WRITE_ONCE(ep->ovflist, NULL);
>> +    /*
>> +     * In ep_poll() we use ep_events_available() in a lockless way to decide
>> +     * if events are available. So we need to preserve that either
>> +     * ep->oflist != EP_UNACTIVE_PTR or there are events on the ep->rdllist.
>> +     */
>> +    smp_wmb();
>> +    list_splice_init(&ep->rdllist, &txlist);
>>      write_unlock_irq(&ep->lock);
>>
>>      /*
>> @@ -737,16 +743,21 @@ static __poll_t ep_scan_ready_list(struct eventpoll *ep,
>>          }
>>      }
>>      /*
>> +     * Quickly re-inject items left on "txlist".
>> +     */
>> +    list_splice(&txlist, &ep->rdllist);
>> +    /*
>> +     * In ep_poll() we use ep_events_available() in a lockless way to decide
>> +     * if events are available. So we need to preserve that either
>> +     * ep->oflist != EP_UNACTIVE_PTR or there are events on the ep->rdllist.
>> +     */
>> +    smp_wmb();
>> +    /*
>>       * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
>>       * releasing the lock, events will be queued in the normal way inside
>>       * ep->rdllist.
>>       */
>>      WRITE_ONCE(ep->ovflist, EP_UNACTIVE_PTR);
>> -
>> -    /*
>> -     * Quickly re-inject items left on "txlist".
>> -     */
>> -    list_splice(&txlist, &ep->rdllist);
>>      __pm_relax(ep->ws);
>>      write_unlock_irq(&ep->lock);
> 

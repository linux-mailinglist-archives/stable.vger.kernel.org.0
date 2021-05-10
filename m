Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD7E3779A1
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 03:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhEJBMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 21:12:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:34484 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhEJBMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 May 2021 21:12:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8656EAE63;
        Mon, 10 May 2021 01:10:58 +0000 (UTC)
MIME-Version: 1.0
Date:   Sun, 09 May 2021 18:10:57 -0700
From:   Davidlohr Bueso <dbueso@suse.de>
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     Varad Gautam <varad.gautam@suse.com>, linux-kernel@vger.kernel.org,
        Matthias von Faber <matthias.vonfaber@aox-tech.de>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jamorris@linux.microsoft.com>,
        Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH v3] ipc/mqueue: Avoid relying on a stack reference past
 its expiry
In-Reply-To: <71c74711-75d6-494e-6ff7-2be49b274477@colorfullife.com>
References: <20210507133805.11678-1-varad.gautam@suse.com>
 <71c74711-75d6-494e-6ff7-2be49b274477@colorfullife.com>
User-Agent: Roundcube Webmail
Message-ID: <6d36d89bc8f299a76efe8fce9c07e7b5@suse.de>
X-Sender: dbueso@suse.de
Organization: SUSE Labs
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-05-08 12:23, Manfred Spraul wrote:
> Hi Varad,
> 
> On 5/7/21 3:38 PM, Varad Gautam wrote:
>> @@ -1005,11 +1022,9 @@ static inline void __pipelined_op(struct 
>> wake_q_head *wake_q,
>>   				  struct ext_wait_queue *this)
>>   {
>>   	list_del(&this->list);
>> -	get_task_struct(this->task);
>> -
>> +	wake_q_add(wake_q, this->task);
>>   	/* see MQ_BARRIER for purpose/pairing */
>>   	smp_store_release(&this->state, STATE_READY);
>> -	wake_q_add_safe(wake_q, this->task);
>>   }
>>     /* pipelined_send() - send a message directly to the task waiting 
>> in
> 
> First, I was too fast: I had assumed that wake_q_add() before
> smp_store_release() would be a potential lost wakeup.

Yeah you need wake_up_q() to actually wake anything up.

> 
> As __pipelined_op() is called within spin_lock(&info->lock), and as
> wq_sleep() will reread this->state after acquiring
> spin_lock(&info->lock), I do not see a bug anymore.

Right, and when I proposed this version of the fix I was mostly focusing 
on STATE_READY
being set as the last operation, but the fact of the matter is we had 
moved to the
wake_q_add_safe() version for two reasons:

(1) Ensuring the ->state = STATE_READY is done after the reference count 
and avoid
racing with exit. In mqueue's original use of wake_q we were relying on 
the call's
implied barrier from wake_q_add() in order to avoid reordering of 
setting the state.
But this turned out to be insufficient hence the explicit 
smp_store_release().

(2) In order to prevent a potential lost wakeup when the blocked task is 
already queued
for wakeup by another task (the failed cmpxchg case in wake_q_add), and 
therefore we need
to set the return condition (->state = STATE_READY) before adding the 
task to the wake_q.

But I'm not seeing how race (2) can happen in mqueue. The race was 
always theoretical to
begin with, with the exception of rwsems[1] in which actually the wakee 
task could end up in
the waker's wake_q without actually blocking.

So all in all I now agree that we should keep the order of how we 
currently have things,
just to be on the safer side, if nothing else.

[1] 
https://lore.kernel.org/lkml/1543495830-2644-1-git-send-email-xieyongji@baidu.com

Thanks,
Davidlohr

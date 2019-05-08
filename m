Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 200A517FB7
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 20:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbfEHSSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 14:18:47 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:44726 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727352AbfEHSSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 14:18:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=wuyihao@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0TRCTQGt_1557339523;
Received: from ali-186590dcce93-2.local(mailfrom:wuyihao@linux.alibaba.com fp:SMTPD_---0TRCTQGt_1557339523)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 May 2019 02:18:44 +0800
Subject: Re: [PATCH 1/2] NFSv4.1: Again fix a race where CB_NOTIFY_LOCK fails
 to wake a waiter
To:     Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>
Cc:     stable@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
        caspar@linux.alibaba.com
References: <d0b6fc01-0a73-e4f7-b393-3ecc9aacffb0@linux.alibaba.com>
 <2a1cebca-1efb-1686-475b-a581e50e61b4@linux.alibaba.com>
 <84addb90fc41372ad723d469a00bbb4cce2c9c55.camel@kernel.org>
From:   Yihao Wu <wuyihao@linux.alibaba.com>
Message-ID: <0f965495-9bb7-e35e-696b-5115f561366c@linux.alibaba.com>
Date:   Thu, 9 May 2019 02:18:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <84addb90fc41372ad723d469a00bbb4cce2c9c55.camel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019/5/8 8:24 PM, Jeff Layton wrote:
> On Wed, 2019-05-08 at 17:13 +0800, Yihao Wu wrote:
>> Commit b7dbcc0e433f ""NFSv4.1: Fix a race where CB_NOTIFY_LOCK fails
>> to wake a waiter" found this bug. However it didn't fix it. This can
>> be fixed by adding memory barrier pair.
>>
>> Specifically, if any CB_NOTIFY_LOCK should be handled between unlocking
>> the wait queue and freezable_schedule_timeout, only two cases are
>> possible. So CB_NOTIFY_LOCK will not be dropped unexpectly.
>>
>> 1. The callback thread marks the NFS client as waked. Then NFS client
>> noticed that itself is waked, so it don't goes to sleep. And it cleans
>> its wake mark.
>>
>> 2. The NFS client noticed that itself is not waked yet, so it goes to
>> sleep. No modification will ever happen to the wake mark in between.
>>
> 
> It's not clear to me what you mean by "wake mark" here. Do you mean the
> "notified" flag? This could use a better description.

Yes. I mean "notified flag" by "wake mark". I will clear these ambiguities.

Thanks

> 
>> Fixes: a1d617d ("nfs: allow blocking locks to be awoken by lock callbacks")
>> Signed-off-by: Yihao Wu <wuyihao@linux.alibaba.com>
>> ---
>>  fs/nfs/nfs4proc.c | 21 +++++----------------
>>  1 file changed, 5 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
>> index 741ff8c..f13ea09 100644
>> --- a/fs/nfs/nfs4proc.c
>> +++ b/fs/nfs/nfs4proc.c
>> @@ -6867,7 +6867,6 @@ struct nfs4_lock_waiter {
>>  	struct task_struct	*task;
>>  	struct inode		*inode;
>>  	struct nfs_lowner	*owner;
>> -	bool			notified;
>>  };
>>  
>>  static int
>> @@ -6889,13 +6888,13 @@ struct nfs4_lock_waiter {
>>  		/* Make sure it's for the right inode */
>>  		if (nfs_compare_fh(NFS_FH(waiter->inode), &cbnl->cbnl_fh))
>>  			return 0;
>> -
>> -		waiter->notified = true;
>>  	}
>>  
>>  	/* override "private" so we can use default_wake_function */
>>  	wait->private = waiter->task;
>> -	ret = autoremove_wake_function(wait, mode, flags, key);
>> +	ret = woken_wake_function(wait, mode, flags, key);
>> +	if (ret)
>> +		list_del_init(&wait->entry);
>>  	wait->private = waiter;
>>  	return ret;
>>  }
>> @@ -6914,8 +6913,7 @@ struct nfs4_lock_waiter {
>>  				    .s_dev = server->s_dev };
>>  	struct nfs4_lock_waiter waiter = { .task  = current,
>>  					   .inode = state->inode,
>> -					   .owner = &owner,
>> -					   .notified = false };
>> +					   .owner = &owner};
>>  	wait_queue_entry_t wait;
>>  
>>  	/* Don't bother with waitqueue if we don't expect a callback */
>> @@ -6928,21 +6926,12 @@ struct nfs4_lock_waiter {
>>  	add_wait_queue(q, &wait);
>>  
>>  	while(!signalled()) {
>> -		waiter.notified = false;
>>  		status = nfs4_proc_setlk(state, cmd, request);
>>  		if ((status != -EAGAIN) || IS_SETLK(cmd))
>>  			break;
>>  
>>  		status = -ERESTARTSYS;
>> -		spin_lock_irqsave(&q->lock, flags);
>> -		if (waiter.notified) {
>> -			spin_unlock_irqrestore(&q->lock, flags);
>> -			continue;
>> -		}
>> -		set_current_state(TASK_INTERRUPTIBLE);
>> -		spin_unlock_irqrestore(&q->lock, flags);
>> -
>> -		freezable_schedule_timeout(NFS4_LOCK_MAXTIMEOUT);
>> +		wait_woken(&wait, TASK_INTERRUPTIBLE, NFS4_LOCK_MAXTIMEOUT);
> 
> This seems to have dropped the "freezable" part above, such that waiting
> on a file lock will prevent (e.g.) a laptop from suspending. I think
> that needs to be in here as those waits can be quite long.
> 

You're right. I overlooked this. This will be fixed.

Thanks

>>  	}
>>  
>>  	finish_wait(q, &wait);
> 


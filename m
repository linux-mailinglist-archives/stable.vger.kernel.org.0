Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE286760DA
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 23:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjATW7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 17:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjATW7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 17:59:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186F3EB6F
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 14:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674255524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d4gRjwN8IcU1hE11oQ9CRKTMuTDHKqN5/qJ3lZJ7j6g=;
        b=Wo9gtjW6cmnjkpmZ7MDVQ6cZaBobERgKHrvpNd/fcrm+z/DCazFP4ej4i896cmzXMD4r7p
        It1vIjKOYH272NlSyT3fIElSuOBY4Dcj1XKApGF3ChGqwxVJpZbXCnY4dTv0Ta0SJdZ3P3
        qiBEXUY2LnckhyxEluDCTP7cgL7fseo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-K3cnIppKOeKI5DI8dbk0eA-1; Fri, 20 Jan 2023 17:58:37 -0500
X-MC-Unique: K3cnIppKOeKI5DI8dbk0eA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8B3B801779;
        Fri, 20 Jan 2023 22:58:36 +0000 (UTC)
Received: from [10.22.17.220] (unknown [10.22.17.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 220032026D68;
        Fri, 20 Jan 2023 22:58:36 +0000 (UTC)
Message-ID: <61d1f75b-b6bd-b1bc-86c3-94b47d5e7318@redhat.com>
Date:   Fri, 20 Jan 2023 17:58:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v6 1/6] locking/rwsem: Prevent non-first waiter from
 spinning in down_write() slowpath
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>
Cc:     linux-kernel@vger.kernel.org, john.p.donnelly@oracle.com,
        Hillf Danton <hdanton@sina.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        =?UTF-8?B?VGluZzExIFdhbmcg546L5am3?= <wangting11@xiaomi.com>,
        stable@vger.kernel.org
References: <20221118022016.462070-1-longman@redhat.com>
 <20221118022016.462070-2-longman@redhat.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <20221118022016.462070-2-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/17/22 21:20, Waiman Long wrote:
> A non-first waiter can potentially spin in the for loop of
> rwsem_down_write_slowpath() without sleeping but fail to acquire the
> lock even if the rwsem is free if the following sequence happens:
>
>    Non-first RT waiter    First waiter      Lock holder
>    -------------------    ------------      -----------
>    Acquire wait_lock
>    rwsem_try_write_lock():
>      Set handoff bit if RT or
>        wait too long
>      Set waiter->handoff_set
>    Release wait_lock
>                           Acquire wait_lock
>                           Inherit waiter->handoff_set
>                           Release wait_lock
> 					   Clear owner
>                                             Release lock
>    if (waiter.handoff_set) {
>      rwsem_spin_on_owner(();
>      if (OWNER_NULL)
>        goto trylock_again;
>    }
>    trylock_again:
>    Acquire wait_lock
>    rwsem_try_write_lock():
>       if (first->handoff_set && (waiter != first))
>       	return false;
>    Release wait_lock
>
> A non-first waiter cannot really acquire the rwsem even if it mistakenly
> believes that it can spin on OWNER_NULL value. If that waiter happens
> to be an RT task running on the same CPU as the first waiter, it can
> block the first waiter from acquiring the rwsem leading to live lock.
> Fix this problem by making sure that a non-first waiter cannot spin in
> the slowpath loop without sleeping.
>
> Fixes: d257cc8cb8d5 ("locking/rwsem: Make handoff bit handling more consistent")
> Reviewed-and-tested-by: Mukesh Ojha <quic_mojha@quicinc.com>
> Signed-off-by: Waiman Long <longman@redhat.com>
> Cc: stable@vger.kernel.org
> ---
>   kernel/locking/rwsem.c | 19 +++++++++----------
>   1 file changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
> index 44873594de03..be2df9ea7c30 100644
> --- a/kernel/locking/rwsem.c
> +++ b/kernel/locking/rwsem.c
> @@ -624,18 +624,16 @@ static inline bool rwsem_try_write_lock(struct rw_semaphore *sem,
>   			 */
>   			if (first->handoff_set && (waiter != first))
>   				return false;
> -
> -			/*
> -			 * First waiter can inherit a previously set handoff
> -			 * bit and spin on rwsem if lock acquisition fails.
> -			 */
> -			if (waiter == first)
> -				waiter->handoff_set = true;
>   		}
>   
>   		new = count;
>   
>   		if (count & RWSEM_LOCK_MASK) {
> +			/*
> +			 * A waiter (first or not) can set the handoff bit
> +			 * if it is an RT task or wait in the wait queue
> +			 * for too long.
> +			 */
>   			if (has_handoff || (!rt_task(waiter->task) &&
>   					    !time_after(jiffies, waiter->timeout)))
>   				return false;
> @@ -651,11 +649,12 @@ static inline bool rwsem_try_write_lock(struct rw_semaphore *sem,
>   	} while (!atomic_long_try_cmpxchg_acquire(&sem->count, &count, new));
>   
>   	/*
> -	 * We have either acquired the lock with handoff bit cleared or
> -	 * set the handoff bit.
> +	 * We have either acquired the lock with handoff bit cleared or set
> +	 * the handoff bit. Only the first waiter can have its handoff_set
> +	 * set here to enable optimistic spinning in slowpath loop.
>   	 */
>   	if (new & RWSEM_FLAG_HANDOFF) {
> -		waiter->handoff_set = true;
> +		first->handoff_set = true;
>   		lockevent_inc(rwsem_wlock_handoff);
>   		return false;
>   	}

Peter,

I would really like to get this fix patch merged as soon as possible if 
you don't see any problem with it. For the rests of the series, you can 
take your time.

Cheers,
Longman


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8128067DB68
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 02:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjA0Brl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 20:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjA0Brk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 20:47:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7838741086
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 17:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674784013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RCGLuOvzRoUJJHbOD/FbK9RJ/iyqcYrpGwcs0dzbqAg=;
        b=Ymigw03Pc0Gc20AvAgjXJu1MB5jeWuiotOFneFVHPRDWRakSe8CCROgdRIJiOXzY+V2Ffe
        jq7F/HmW4nx6/Naz3fhHID5c/VTr/0V5AN5idEP/B7I06evfniMslkNaJFRWFGk+HwyV1/
        wdSMMjPmW0olEGwMEW0b+ig8uAYNjoI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-_ldfS5dMO7yh5-fhU-3OpA-1; Thu, 26 Jan 2023 20:46:48 -0500
X-MC-Unique: _ldfS5dMO7yh5-fhU-3OpA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC1682801E54;
        Fri, 27 Jan 2023 01:46:47 +0000 (UTC)
Received: from [10.22.33.13] (unknown [10.22.33.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D361B2166B26;
        Fri, 27 Jan 2023 01:46:45 +0000 (UTC)
Message-ID: <4122ef0d-1508-8ce2-df80-874565a612ce@redhat.com>
Date:   Thu, 26 Jan 2023 20:46:45 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] Fix data race in mark_rt_mutex_waiters
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        'Hernan Ponce de Leon' <hernan.poncedeleon@huaweicloud.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "paulmck@kernel.org" <paulmck@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>,
        "akpm@osdl.org" <akpm@osdl.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "joel@joelfernandes.org" <joel@joelfernandes.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "diogo.behrens@huawei.com" <diogo.behrens@huawei.com>,
        "jonas.oberhauser@huawei.com" <jonas.oberhauser@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hernan Ponce de Leon <hernanl.leon@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
 <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
 <20230120155439.GI2948950@paulmck-ThinkPad-P17-Gen-1>
 <9a1c7959-4b8c-94df-a3e2-e69be72bfd7d@huaweicloud.com>
 <20230123164014.GN2948950@paulmck-ThinkPad-P17-Gen-1>
 <f17dcce0-d510-a112-3127-984e8e73f480@huaweicloud.com>
 <d1e28124-b7a7-ae19-87ec-b1dcd3701b61@redhat.com>
 <Y8/+2YBRD4rFySjh@hirez.programming.kicks-ass.net>
 <ae90e931-df19-9d60-610c-57dc34494d8e@redhat.com>
 <c300747a-cf81-0e2d-77ec-f861421291f9@huaweicloud.com>
 <Y9Jv9yL8x7/TAq/X@hirez.programming.kicks-ass.net>
 <9da70674-42e0-9aaa-edab-c606ca8dd2e8@huaweicloud.com>
 <004045af7a2b4abaa5f4d9840371da60@AcuMS.aculab.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <004045af7a2b4abaa5f4d9840371da60@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 1/26/23 17:10, David Laight wrote:
> From: Hernan Ponce de Leon
>> Sent: 26 January 2023 21:07
> ...
>>    static __always_inline void rt_mutex_clear_owner(struct rt_mutex_base
>> *lock)
>> @@ -232,12 +232,7 @@ static __always_inline bool
>> rt_mutex_cmpxchg_release(struct rt_mutex_base *lock,
>>     */
>>    static __always_inline void mark_rt_mutex_waiters(struct rt_mutex_base
>> *lock)
>>    {
>> -	unsigned long owner, *p = (unsigned long *) &lock->owner;
>> -
>> -	do {
>> -		owner = *p;
>> -	} while (cmpxchg_relaxed(p, owner,
>> -				 owner | RT_MUTEX_HAS_WAITERS) != owner);
>> +	atomic_long_or(RT_MUTEX_HAS_WAITERS, (atomic_long_t *)&lock->owner);
> These *(int_type *)&foo accesses (quite often just plain wrong)
> made me look up the definitions.
>
> All one big accident waiting to happen...
> RT_MUTEX_HAS_WAITERS is defined in a different header to the structure.
> The explanatory comment is in a 3rd file.
>
> It would all be safer if lock->owner were atomic_long_t with a comment
> that it was the waiting task_struct | RT_MUTEX_HAS_WAITERS.
>
> Given the actual definition is rt_mutex_base_is_locked() even correct?

It is arguable if it should be considered locked if a waiter is waiting 
but the lock is at an unlock state at the moment. Mutex has a narrower 
definition of locked while others have a broader one.

Cheers,
Longman


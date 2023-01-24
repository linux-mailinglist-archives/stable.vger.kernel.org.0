Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1E9679DCB
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 16:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbjAXPno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 10:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbjAXPnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 10:43:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E474B75E
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 07:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674574952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XgNWZKzEAVfMhQwxbccXuuNkJcR/zVuKuBglg9QVv/s=;
        b=AqVXDOsbqBEW8sF06kQ72ei9ldQFk7Hc6hPFVRIGLmKUKlfRtHsqwnc7h67eAZ2AjpxFGU
        YrMMNx6I5pY2Uh7bg+XEmP4PZql2TtemmDwgu/uhYfWomDU5mDt9I5omH7H7sIdk1fJYEq
        CSUyJTGVM7QvEPsAymFQUZ9iEDd2M5E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-zoVg3GfuPx6IYsU_6JPvRw-1; Tue, 24 Jan 2023 10:42:27 -0500
X-MC-Unique: zoVg3GfuPx6IYsU_6JPvRw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B49382802E2B;
        Tue, 24 Jan 2023 15:42:26 +0000 (UTC)
Received: from [10.22.10.191] (unknown [10.22.10.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5E5C492B00;
        Tue, 24 Jan 2023 15:42:25 +0000 (UTC)
Message-ID: <d1e28124-b7a7-ae19-87ec-b1dcd3701b61@redhat.com>
Date:   Tue, 24 Jan 2023 10:42:24 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] Fix data race in mark_rt_mutex_waiters
Content-Language: en-US
To:     Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>,
        paulmck@kernel.org
Cc:     Arjan van de Ven <arjan@linux.intel.com>, peterz@infradead.org,
        mingo@redhat.com, will@kernel.org, boqun.feng@gmail.com,
        akpm@osdl.org, tglx@linutronix.de, joel@joelfernandes.org,
        stern@rowland.harvard.edu, diogo.behrens@huawei.com,
        jonas.oberhauser@huawei.com, linux-kernel@vger.kernel.org,
        Hernan Ponce de Leon <hernanl.leon@huawei.com>,
        stable@vger.kernel.org
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
 <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
 <20230120155439.GI2948950@paulmck-ThinkPad-P17-Gen-1>
 <9a1c7959-4b8c-94df-a3e2-e69be72bfd7d@huaweicloud.com>
 <20230123164014.GN2948950@paulmck-ThinkPad-P17-Gen-1>
 <f17dcce0-d510-a112-3127-984e8e73f480@huaweicloud.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <f17dcce0-d510-a112-3127-984e8e73f480@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 1/24/23 09:57, Hernan Ponce de Leon wrote:
>> In the case, the value read is passed into cmpxchg_relaxed(), which
>> checks the value against memory.  In this case, as Arjan noted, the only
>> compiler-and-silicon difference between data_race() and READ_ONCE()
>> is that use of data_race() might allow the compiler to do things like
>> tear the load, thus forcing the occasional spurious cmpxchg_relaxed()
>> failure.  In contrast, LKMM (by design) throws up its hands when it sees
>> a data race.  Something about not being eager to track the 
>> idiosyncrasies
>> of many compiler versions.
>>
>> My approach in my own code is to use *_ONCE() unless it causes a visible
>> performance regression or if it confuses KCSAN.  An example of the 
>> latter
>> can be debug code, in which case use of data_race() avoids suppressing
>> KCSAN warnings (and also false positives, depending).
>
> I understand that *_ONCE() might avoid some compiler optimization and 
> reduce performance in the general case. However, if I understand your 
> first paragraph correctly, in this particular case data_race() could 
> allow the CAS to fail more often, resulting in more spinning 
> iterations and degraded performance. Am I right?
>
>>
>> Except that your other email seems to also be arguing that additional
>> ordering is required.  So is https://lkml.org/lkml/2023/1/20/702 really
>> sufficient just by itself, or is additional ordering required?
>
> I do not claim that we need to mark the read to add the ordering that 
> is needed for correctness (mutual exclusion). What I claim in this 
> patch is that there is a data race, and since it can affect ordering 
> constrains in subtle ways, I consider it harmful and thus I want to 
> fix it.
>
> What I explain in the other email is that if we fix the data race, 
> either the fence or the acquire store might be relaxed (because 
> marking the read gives us some extra ordering guarantees). If the race 
> is not fixed, both the fence and the acquire are needed according to 
> LKMM. The situation is different wrt hardware models. In that case the 
> tool cannot find any violation even if we don't fix the race and we 
> relax the store / remove the fence.

I would suggest to do it as suggested by PeterZ. Instead of set_bit(), 
however, it is probably better to use atomic_long_or() like

atomic_long_or_relaxed(RT_MUTEX_HAS_WAITERS, (atomic_long_t *)&lock->owner)

The mutex code stores the lock owner as atomic_long_t. So it is natural 
to treat &lock->owner as atomic_long_t here too.

Cheers,
Longman



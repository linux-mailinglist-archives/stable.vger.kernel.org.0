Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580CE4FE67D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 19:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357963AbiDLRGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 13:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353730AbiDLRGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 13:06:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABB6213E33
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 10:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649783052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xpx5QoqOcS07n9zZphQssxqx1W+y0kEDrzg6PwOcRqo=;
        b=ibYMN+L+t64UP47PgMghzxNs1lCySjK5lSFnCRm7ZviZaXwgZEJfG8L5VPLC/gXF2DkqE6
        FdmG7Bj2T5c7eLBSRSc8w7AFk2mRTmp5Xf2wgjBXmxhR6MJYvAH9yWZiPhShqmFJ85T7Xc
        mRcOorHDG+6ij4mnNBnUk4EPjZRXqm4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-p_-pdPW4OgmCHztSd49Pbw-1; Tue, 12 Apr 2022 13:04:07 -0400
X-MC-Unique: p_-pdPW4OgmCHztSd49Pbw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0107803D77;
        Tue, 12 Apr 2022 17:04:06 +0000 (UTC)
Received: from [10.22.19.27] (unknown [10.22.19.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E77D840470ED;
        Tue, 12 Apr 2022 17:04:05 +0000 (UTC)
Message-ID: <b3620b7b-c66a-65f8-b10b-c3669b2f82ec@redhat.com>
Date:   Tue, 12 Apr 2022 13:04:05 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5] locking/rwsem: Make handoff bit handling more
 consistent
Content-Language: en-US
To:     john.p.donnelly@oracle.com,
        chenguanyou <chenguanyou9338@gmail.com>,
        gregkh@linuxfoundation.org
Cc:     dave@stgolabs.net, hdanton@sina.com, linux-kernel@vger.kernel.org,
        mazhenhua@xiaomi.com, mingo@redhat.com, peterz@infradead.org,
        quic_aiquny@quicinc.com, will@kernel.org, sashal@kernel.org,
        stable@vger.kernel.org
References: <20211116012912.723980-1-longman@redhat.com>
 <20220214154741.12399-1-chenguanyou@xiaomi.com>
 <3f02975c-1a9d-be20-32cf-f1d8e3dfafcc@oracle.com>
 <e873727e-22db-3330-015d-bd6581a2937a@redhat.com>
 <31178c33-e25c-c3e8-35e2-776b5211200c@oracle.com>
 <161c2e25-3d26-4dd7-d378-d1741f7bcca8@redhat.com>
 <2b6ed542-b3e0-1a87-33ac-d52fc0e0339c@oracle.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <2b6ed542-b3e0-1a87-33ac-d52fc0e0339c@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/22 12:28, john.p.donnelly@oracle.com wrote:
> On 4/11/22 4:07 PM, Waiman Long wrote:
>>
>> On 4/11/22 17:03, john.p.donnelly@oracle.com wrote:
>>>
>>>>>
>>>>> I have reached out to Waiman and he suggested this for our next 
>>>>> test pass:
>>>>>
>>>>>
>>>>> 1ee326196c6658 locking/rwsem: Always try to wake waiters in 
>>>>> out_nolock path
>>>>
>>>> Does this commit help to avoid the lockup problem?
>>>>
>>>> Commit 1ee326196c6658 fixes a potential missed wakeup problem when 
>>>> a reader first in the wait queue is interrupted out without 
>>>> acquiring the lock. It is actually not a fix for commit 
>>>> d257cc8cb8d5. However, this commit changes the out_nolock path 
>>>> behavior of writers by leaving the handoff bit set when the wait 
>>>> queue isn't empty. That likely makes the missed wakeup problem 
>>>> easier to reproduce.
>>>>
>>>> Cheers,
>>>> Longman
>>>>
>>>
>>> Hi,
>>>
>>>
>>> We are testing now
>>>
>>> ETA for fio soak test completion is  ~15hr from now.
>>>
>>> I wanted to share the stack traces for future reference + occurrences.
>>>
>> I am looking forward to your testing results tomorrow.
>>
>> Cheers,
>> Longman
>>
> Hi
>
>  Our 24hr fio soak test with :
>
>  1ee326196c6658 locking/rwsem: Always try to wake waiters in 
> out_nolock path
>
>
>  applied to 5.15.30  passed.
>
>  I suggest you append  1ee326196c6658 with :
>
>
>  cc: stable
>
>   Fixes: d257cc8cb8d5 ("locking/rwsem: Make handoff bit handling more 
> consistent")
>
>
> I'll leave the implementation details up to the core maintainers how 
> to do that ;-)

Thanks for the test.

The patch has already been in the tip tree. It may not be easy to add a 
Fixes tag to it. Anyway, I will encourage stable tree maintainer to take 
it as it does fix a problem as shown in your test.

Cheers,
Longman


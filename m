Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CD164B900
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 16:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbiLMPze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 10:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236124AbiLMPzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 10:55:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F5519004
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 07:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670946884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=le5VOhgAJo7w8+98IyRq0qg/O2EwJ6fbgWW2g/QrJps=;
        b=Pyz3SzJRTeUi4qEzWNd4/glwcguEyDWz2V6acuWokXtx/wqLcdguENzPAa0JRsQtu7xSnW
        iwf0Yld7+2ksrzAoplbrZKQQzmkpdDeqZA7IuaGa8BEO+aNxaToz+IOFmHnavo6mKiczzU
        tb9y9+qI/BJx3BbgNmYrvtHjc5lsiRg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-HpUQz0CAPHKoJ8luzCTZZA-1; Tue, 13 Dec 2022 10:54:41 -0500
X-MC-Unique: HpUQz0CAPHKoJ8luzCTZZA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1ED9858F17;
        Tue, 13 Dec 2022 15:54:40 +0000 (UTC)
Received: from [10.22.32.205] (unknown [10.22.32.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9065492C18;
        Tue, 13 Dec 2022 15:54:39 +0000 (UTC)
Message-ID: <da5bc530-5075-e17f-aed4-7a4b1f86932f@redhat.com>
Date:   Tue, 13 Dec 2022 10:54:37 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH-tip] sched: Fix use-after-free bug in dup_user_cpus_ptr()
Content-Language: en-US
To:     Will Deacon <will@kernel.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Phil Auld <pauld@redhat.com>,
        Wenjie Li <wenjieli@qti.qualcomm.com>,
        =?UTF-8?B?RGF2aWQgV2FuZyDnjovmoIc=?= <wangbiao3@xiaomi.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221128014441.1264867-1-longman@redhat.com>
 <20221201134445.GC28489@willie-the-truck>
 <330989bf-0015-6d4c-9317-bfc9dba30b65@redhat.com>
 <20221202101835.GA29522@willie-the-truck>
 <e9c7a920-4801-59fd-2429-361c54523d8e@redhat.com>
 <20221213125404.GD5719@willie-the-truck>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <20221213125404.GD5719@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/22 07:54, Will Deacon wrote:
> On Fri, Dec 02, 2022 at 09:30:56AM -0500, Waiman Long wrote:
>> On 12/2/22 05:18, Will Deacon wrote:
>>> On Thu, Dec 01, 2022 at 12:03:39PM -0500, Waiman Long wrote:
>>>> On 12/1/22 08:44, Will Deacon wrote:
>>>>> On Sun, Nov 27, 2022 at 08:44:41PM -0500, Waiman Long wrote:
>>>>>> Since commit 07ec77a1d4e8 ("sched: Allow task CPU affinity to be
>>>>>> restricted on asymmetric systems"), the setting and clearing of
>>>>>> user_cpus_ptr are done under pi_lock for arm64 architecture. However,
>>>>>> dup_user_cpus_ptr() accesses user_cpus_ptr without any lock
>>>>>> protection. When racing with the clearing of user_cpus_ptr in
>>>>>> __set_cpus_allowed_ptr_locked(), it can lead to user-after-free and
>>>>>> double-free in arm64 kernel.
>>>>>>
>>>>>> Commit 8f9ea86fdf99 ("sched: Always preserve the user requested
>>>>>> cpumask") fixes this problem as user_cpus_ptr, once set, will never
>>>>>> be cleared in a task's lifetime. However, this bug was re-introduced
>>>>>> in commit 851a723e45d1 ("sched: Always clear user_cpus_ptr in
>>>>>> do_set_cpus_allowed()") which allows the clearing of user_cpus_ptr in
>>>>>> do_set_cpus_allowed(). This time, it will affect all arches.
>>>>>>
>>>>>> Fix this bug by always clearing the user_cpus_ptr of the newly
>>>>>> cloned/forked task before the copying process starts and check the
>>>>>> user_cpus_ptr state of the source task under pi_lock.
>>>>>>
>>>>>> Note to stable, this patch won't be applicable to stable releases.
>>>>>> Just copy the new dup_user_cpus_ptr() function over.
>>>>>>
>>>>>> Fixes: 07ec77a1d4e8 ("sched: Allow task CPU affinity to be restricted on asymmetric systems")
>>>>>> Fixes: 851a723e45d1 ("sched: Always clear user_cpus_ptr in do_set_cpus_allowed()")
>>>>>> CC: stable@vger.kernel.org
>>>>>> Reported-by: David Wang 王标 <wangbiao3@xiaomi.com>
>>>>>> Signed-off-by: Waiman Long <longman@redhat.com>
>>>>>> ---
>>>>>>     kernel/sched/core.c | 32 ++++++++++++++++++++++++++++----
>>>>>>     1 file changed, 28 insertions(+), 4 deletions(-)
>>>>> As per my comments on the previous version of this patch:
>>>>>
>>>>> https://lore.kernel.org/lkml/20221201133602.GB28489@willie-the-truck/T/#t
>>>>>
>>>>> I think there are other issues to fix when racing affinity changes with
>>>>> fork() too.
>>>> It is certainly possible that there are other bugs hiding somewhere:-)
>>> Right, but I actually took the time to hit the same race for the other
>>> affinity mask field so it seems a bit narrow-minded for us just to fix the
>>> one issue.
>> I focused on this particular one because of a double-free bug report from
>> David. What other fields have you found to be subjected to data race?
> See my other report linked above where we race on 'task_struct::cpus_mask'.

So you are referring to the fact a task structure may be changed while 
it is being copied to a child process at the same time. I think it is a 
hard problem to fix as I am not aware of a way to freeze the content of 
the task structure while the copying is in progress. There are just too 
many fields in the task structures that can be changed in many different 
contexts from different CPUs.

Anyway, this dup_user_cpus_ptr() bug is not related to racing in this 
copying process, it is caused by a race after that. I think it may be 
worthwhile to put a note about possible race in the dup_task_struct() 
process but I can't think of a good way to fix it.

Cheers,
Longman


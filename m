Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D6B66B5D0
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 04:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjAPDCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Jan 2023 22:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbjAPDCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Jan 2023 22:02:02 -0500
Received: from hyperium.qtmlabs.xyz (hyperium.qtmlabs.xyz [194.163.182.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B492B35AC;
        Sun, 15 Jan 2023 19:02:00 -0800 (PST)
Received: from dong.kernal.eu (unknown [14.231.159.199])
        by hyperium.qtmlabs.xyz (Postfix) with ESMTPSA id CEA1C820055;
        Mon, 16 Jan 2023 04:01:28 +0100 (CET)
Received: from [172.20.10.3] (unknown [27.68.139.212])
        by dong.kernal.eu (Postfix) with ESMTPSA id 3374444496AC;
        Mon, 16 Jan 2023 10:01:23 +0700 (+07)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qtmlabs.xyz; s=syka;
        t=1673838083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nJYHac5AChke1DkAzu8cXLP62bYEgDJ3tC5JwbRm06c=;
        b=KSnOIsDrOro5wSid/Rt33wKhfEbQ5raXLhJ6M2msG0BT7cmhxKXgiThqorrGBnz3zhYQQa
        LzUPj087bWcwqRUgkUpvnTTy52oIj/1+8Yyz9oLX8eKMYKQhpUYt6N/HPAcfd4sS+BrVeR
        YFCJ5EGRCjMtA+fmVyw1pf9FrbiD9ZzOEU51YY7kJvXC8vpqHqR28bSbon9za739MGT9E1
        6GN2OYSTjyOic4TZmlOR1MkKfXgnvyL444WX0sWyQLzdcByq2GxJ2egVg4vBBVKuqsqrqn
        nCnJtgdRoBUJIYHz0PRPcDl+nYq77bNY2CO/HYH2i7B6SimHp+0VZ5B1caeFyw==
Message-ID: <03a081aa-2e6a-2a28-0444-eecf50364bc0@qtmlabs.xyz>
Date:   Mon, 16 Jan 2023 10:01:17 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2] mm: do not try to migrate lru_gen if it's not
 associated with a memcg
Content-Language: en-US
To:     Yu Zhao <yuzhao@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20230115133330.28420-1-msizanoen@qtmlabs.xyz>
 <20230115134651.30028-1-msizanoen@qtmlabs.xyz>
 <CAOUHufahcS0G_GApTdmzE4_Nb_70LGaCkgV0NR_xJuWN2NdJVg@mail.gmail.com>
From:   msizanoen <msizanoen@qtmlabs.xyz>
In-Reply-To: <CAOUHufahcS0G_GApTdmzE4_Nb_70LGaCkgV0NR_xJuWN2NdJVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,T_PDS_OTHER_BAD_TLD,URIBL_BLACK
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 1/16/23 06:13, Yu Zhao wrote:
> On Sun, Jan 15, 2023 at 6:47 AM msizanoen1 <msizanoen@qtmlabs.xyz> wrote:
>> In some cases, memory cgroup migration can be initiated by userspace
>> right after a process was created and right before `lru_gen_add_mm()` is
>> called (e.g. by some program watching a cgroup and moving away any
>> processes it detects[1]), which results in the following sequence of
>> WARNs followed by an Oops as the kernel attempts to perform a
>> `lru_gen_add_mm()` twice on the same `mm`:
> ...
>
>> Fix this by simply leaving the lru_gen alone if it has not been
>> associated with a memcg yet, as it should eventually be assigned to the
>> right cgroup anyway.
>>
>> [1]: https://gitlab.freedesktop.org/benzea/uresourced/-/blob/master/cgroupify/cgroupify.c
>>
>> v2:
>>          Added stable cc tags
>>
>> Signed-off-by: N/A (patch should not be copyrightable)
>> Cc: stable@vger.kernel.org
> Thanks for the fix.  Cc'ing stable is the right thing to do. The
> commit message and the comment styles could be easily adjusted to
> align with the guidelines.
>
> I don't think the N/A is acceptible though. I fully respect it if you
> wish to remain anonymous -- I can send a similar fix crediting you
> as the "anonymous user <msizanoen@qtmlabs.xyz>" who reported this bug.
Sure, just add my email in the `Reported-by: ` and `Tested-by: ` lines 
and git-send-email should automatically add me to the Cc list.
>
> A bit of background on how I broke it: an old version I have on 4.15
> calls lru_gen_add_mm() before cgroup_post_fork(), which excludes
> cgroup migrations by cgroup_threadgroup_rwsem. When I rebased it, I
> made lru_gen_add_mm() depend on task_lock for the synchronization with
> cgroup migrations -- the decoupling seemed (still seems) to make it
> less complicated -- but this is not safe unless we have the check below.
>
>
>
>
>> ---
>>   mm/vmscan.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index bd6637fcd8f9..0cac40e7484c 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -3323,13 +3323,19 @@ void lru_gen_migrate_mm(struct mm_struct *mm)
>>          if (mem_cgroup_disabled())
>>                  return;
>>
>> +       /* This could happen if cgroup migration is invoked before the process
>> +        * lru_gen is associated with a memcg (e.g. during process creation).
>> +        * Simply ignore it in this case as the lru_gen will get assigned the
>> +        * right cgroup later. */
>> +       if (!mm->lru_gen.memcg)
>> +               return;
>> +
>>          rcu_read_lock();
>>          memcg = mem_cgroup_from_task(task);
>>          rcu_read_unlock();
>>          if (memcg == mm->lru_gen.memcg)
>>                  return;
>>
>> -       VM_WARN_ON_ONCE(!mm->lru_gen.memcg);
>>          VM_WARN_ON_ONCE(list_empty(&mm->lru_gen.list));
>>
>>          lru_gen_del_mm(mm);

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1DF4DB2FB
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356582AbiCPOWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356894AbiCPOWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:22:30 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62176BDCE;
        Wed, 16 Mar 2022 07:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1647440388; x=1678976388;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yZ12FZ/N5m0qimsh4k++dJBxGP/L7/rgi9F835wYwuA=;
  b=ndEJRu2igqH+nOTk4L+kVQuib9gV1E6BjyJ7SuY/SVXYADuLmKhMwdDV
   6Cr91HnFZDN8Hvvopmykzd6Zmtw3KRTaGVjUGff7w2+naOy43D44Fnp6O
   OWZ8PHVFYPeXWDJkmEq6V4dfbnH7PUxBzgY6yBqzTj1OvhuYdYl5OyX9f
   E=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 16 Mar 2022 07:19:48 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 07:19:47 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 16 Mar 2022 07:19:47 -0700
Received: from [10.216.32.215] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 16 Mar
 2022 07:19:42 -0700
Message-ID: <5428f192-1537-fa03-8e9c-4a8322772546@quicinc.com>
Date:   Wed, 16 Mar 2022 19:49:38 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH V2,2/2] mm: madvise: skip unmapped vma holes passed to
 process_madvise
Content-Language: en-US
To:     Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     <surenb@google.com>, <vbabka@suse.cz>, <rientjes@google.com>,
        <sfr@canb.auug.org.au>, <edgararriaga@google.com>,
        <nadav.amit@gmail.com>, <mhocko@suse.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        "# 5 . 10+" <stable@vger.kernel.org>
References: <cover.1647008754.git.quic_charante@quicinc.com>
 <4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com>
 <YjEaFBWterxc3Nzf@google.com>
 <20220315164807.7a9cf1694ee2db8709a8597c@linux-foundation.org>
 <YjFAzuLKWw5eadtf@google.com>
From:   Charan Teja Kalla <quic_charante@quicinc.com>
In-Reply-To: <YjFAzuLKWw5eadtf@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Andrew and Minchan.

On 3/16/2022 7:13 AM, Minchan Kim wrote:
> On Tue, Mar 15, 2022 at 04:48:07PM -0700, Andrew Morton wrote:
>> On Tue, 15 Mar 2022 15:58:28 -0700 Minchan Kim <minchan@kernel.org> wrote:
>>
>>> On Fri, Mar 11, 2022 at 08:59:06PM +0530, Charan Teja Kalla wrote:
>>>> The process_madvise() system call is expected to skip holes in vma
>>>> passed through 'struct iovec' vector list. But do_madvise, which
>>>> process_madvise() calls for each vma, returns ENOMEM in case of unmapped
>>>> holes, despite the VMA is processed.
>>>> Thus process_madvise() should treat ENOMEM as expected and consider the
>>>> VMA passed to as processed and continue processing other vma's in the
>>>> vector list. Returning -ENOMEM to user, despite the VMA is processed,
>>>> will be unable to figure out where to start the next madvise.
>>>> Fixes: ecb8ac8b1f14("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
>>>> Cc: <stable@vger.kernel.org> # 5.10+
>>>
>>> Hmm, not sure whether it's stable material since it changes semantic of
>>> API. It would be better to change the semantic from 5.19 with man page
>>> update to specify the change.
>>
>> It's a very desirable change and it makes the code match the manpage
>> and it's cc:stable.  I think we should just absorb any transitory
>> damage which this causes people.  I doubt if there will be much - if
>> anyone was affected by this they would have already told us that it's
>> broken?
> 
> 
> process_madvise fails to return exact processed bytes at several cases
> if it encounters the error, such as, -EINVAL, -EINTR, -ENOMEM in the
> middle of processing vmas. And now we are trying to make exception for
> change for only hole?
I think EINTR will never return in the middle of processing VMA's for
the behaviours supported by process_madvise().

It can return EINTR when:
-------------------------
1) PTRACE_MODE_READ is being checked in mm_access() where it is waiting
on task->signal->exec_update_lock. EINTR returned from here guarantees
that process_madvise() didn't event start processing.
https://elixir.bootlin.com/linux/v5.16.14/source/mm/madvise.c#L1264 -->
https://elixir.bootlin.com/linux/v5.16.14/source/kernel/fork.c#L1318

2) The process_madvise() started processing VMA's but the required
behavior on a VMA needs mmap_write_lock_killable(), from where EINTR is
returned. The current behaviours supported by process_madvise(),
MADV_COLD, PAGEOUT, WILLNEED, just need read lock here.
https://elixir.bootlin.com/linux/v5.16.14/source/mm/madvise.c#L1164
 **Thus I think no way for EINTR can be returned by process_madvise() in
the middle of processing.** . No?

for EINVAL:
-----------
The only case, I can think of,  where EINVAL can be returned in the
middle of processing is in examples like, given range contains VMA's
with a hole in between and one of the VMA contains the pages that fails
can_madv_lru_vma() condition.
So, it's a limitation that this returns -EINVAL though some bytes are
processed.
	OR
Since there exists still some invalid bytes processed it is valid to
return -EINVAL here and user has to check the address range sent?

for ENOMEM:
----------
Though complete range is processed still returns ENOMEM. IMO, This
shouldn't be treated as error which the patch is targeted for. Then
there is limitation case that you mentioned below where it returns
positive processes bytes even though it didn't process anything if it
couldn't find any vma for the first iteration in madvise_walk_vmas

I think the above limitations with EINVAL and ENOMEM are arising because
we are relying on do_madvise() functionality which madvise() call uses
to process a single VMA. When 'struct iovec' vector processing interface
is given in a system call, it is the expectation by the caller that this
system call should return the correct bytes processed to help the user
to take the correct decisions. Please correct me If i am wrong here.

So, should we add the new function say do_process_madvise(), which take
cares of above limitations? or any alternative suggestions here please?

> IMO, it's worth to note in man page.
> 

Or the current patch for just ENOMEM is sufficient here and we just have
to update the man page?

> In addition, this change returns positive processes bytes even though
> it didn't process anything if it couldn't find any vma for the first
> iteration in madvise_walk_vmas.

Thanks,
Charan


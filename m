Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5DB32F26A
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 19:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229465AbhCESXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 13:23:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31530 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229848AbhCESXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 13:23:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614968590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UBlr5iwi3txToIZalk7mH8mEF/smQnuT6Yz6L+zX5F0=;
        b=P0GG2hK9nPvuQsXt6EP9Fhz/ASvCDVDKTexXCfnNEqFP4tW9t+b89ro0zGLIOsXDuBgGGS
        oCWgfRTPFeTosZ/KTMBxWdwWjajFnPV/XcIHJ0CDA6/OzZm3G2M8v5eblV6JvROxgKNy/H
        LxHLQo4YNcLYiMVXhUQouPaXE2vV9E0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-uLxmRfCJN8O63EK29dBDng-1; Fri, 05 Mar 2021 13:23:07 -0500
X-MC-Unique: uLxmRfCJN8O63EK29dBDng-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03696108BD07;
        Fri,  5 Mar 2021 18:23:04 +0000 (UTC)
Received: from [10.36.112.194] (ovpn-112-194.ams2.redhat.com [10.36.112.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12A3D1001B2C;
        Fri,  5 Mar 2021 18:22:56 +0000 (UTC)
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        Minchan Kim <minchan@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>,
        =?UTF-8?Q?Edgar_Arriaga_Garc=c3=ada?= <edgararriaga@google.com>,
        Tim Murray <timmurray@google.com>,
        Florian Weimer <fweimer@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        James Morris <jmorris@namei.org>,
        Linux MM <linux-mm@kvack.org>,
        SElinux list <selinux@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@android.com>
References: <20210303185807.2160264-1-surenb@google.com>
 <CALvZod73Uem8jzP3QQdQ6waXbx80UUOTJQS7WBwnmaCdq++8xw@mail.gmail.com>
 <CAJuCfpFgDRezmQMjCajXzBp86UbMLMJbqEaeo0_J+pneZ5XOgg@mail.gmail.com>
 <CALvZod4nZ6W05N-4ostUEz5EbCuEvuBpc4LRYfAFgwQU-wb9dQ@mail.gmail.com>
 <b45d9599-b917-10c3-6b86-6ecd8db16d43@redhat.com>
 <CALvZod6b8H-=N6WVrgMVLE3=pm-ELWerjAO5v5KHSH-ih337+g@mail.gmail.com>
 <c234a564-a052-b586-2a32-8580aaf8ca5d@redhat.com>
 <CAJuCfpHmks2Lxu8j0LaU+yhS3yO62=4qo=Jinr3mK0Km7yguAQ@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Subject: Re: [PATCH v3 1/1] mm/madvise: replace ptrace attach requirement for
 process_madvise
Message-ID: <3dfb7545-3545-cdbe-d643-8d76fc77a30f@redhat.com>
Date:   Fri, 5 Mar 2021 19:22:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CAJuCfpHmks2Lxu8j0LaU+yhS3yO62=4qo=Jinr3mK0Km7yguAQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05.03.21 19:08, Suren Baghdasaryan wrote:
> On Fri, Mar 5, 2021 at 9:52 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 05.03.21 18:45, Shakeel Butt wrote:
>>> On Fri, Mar 5, 2021 at 9:37 AM David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>> On 04.03.21 01:03, Shakeel Butt wrote:
>>>>> On Wed, Mar 3, 2021 at 3:34 PM Suren Baghdasaryan <surenb@google.com> wrote:
>>>>>>
>>>>>> On Wed, Mar 3, 2021 at 3:17 PM Shakeel Butt <shakeelb@google.com> wrote:
>>>>>>>
>>>>>>> On Wed, Mar 3, 2021 at 10:58 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>>>>>>>
>>>>>>>> process_madvise currently requires ptrace attach capability.
>>>>>>>> PTRACE_MODE_ATTACH gives one process complete control over another
>>>>>>>> process. It effectively removes the security boundary between the
>>>>>>>> two processes (in one direction). Granting ptrace attach capability
>>>>>>>> even to a system process is considered dangerous since it creates an
>>>>>>>> attack surface. This severely limits the usage of this API.
>>>>>>>> The operations process_madvise can perform do not affect the correctness
>>>>>>>> of the operation of the target process; they only affect where the data
>>>>>>>> is physically located (and therefore, how fast it can be accessed).
>>>>>>>> What we want is the ability for one process to influence another process
>>>>>>>> in order to optimize performance across the entire system while leaving
>>>>>>>> the security boundary intact.
>>>>>>>> Replace PTRACE_MODE_ATTACH with a combination of PTRACE_MODE_READ
>>>>>>>> and CAP_SYS_NICE. PTRACE_MODE_READ to prevent leaking ASLR metadata
>>>>>>>> and CAP_SYS_NICE for influencing process performance.
>>>>>>>>
>>>>>>>> Cc: stable@vger.kernel.org # 5.10+
>>>>>>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>>>>>>>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>>>>>>> Acked-by: Minchan Kim <minchan@kernel.org>
>>>>>>>> Acked-by: David Rientjes <rientjes@google.com>
>>>>>>>> ---
>>>>>>>> changes in v3
>>>>>>>> - Added Reviewed-by: Kees Cook <keescook@chromium.org>
>>>>>>>> - Created man page for process_madvise per Andrew's request: https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/commit/?id=a144f458bad476a3358e3a45023789cb7bb9f993
>>>>>>>> - cc'ed stable@vger.kernel.org # 5.10+ per Andrew's request
>>>>>>>> - cc'ed linux-security-module@vger.kernel.org per James Morris's request
>>>>>>>>
>>>>>>>>     mm/madvise.c | 13 ++++++++++++-
>>>>>>>>     1 file changed, 12 insertions(+), 1 deletion(-)
>>>>>>>>
>>>>>>>> diff --git a/mm/madvise.c b/mm/madvise.c
>>>>>>>> index df692d2e35d4..01fef79ac761 100644
>>>>>>>> --- a/mm/madvise.c
>>>>>>>> +++ b/mm/madvise.c
>>>>>>>> @@ -1198,12 +1198,22 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
>>>>>>>>                    goto release_task;
>>>>>>>>            }
>>>>>>>>
>>>>>>>> -       mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
>>>>>>>> +       /* Require PTRACE_MODE_READ to avoid leaking ASLR metadata. */
>>>>>>>> +       mm = mm_access(task, PTRACE_MODE_READ_FSCREDS);
>>>>>>>>            if (IS_ERR_OR_NULL(mm)) {
>>>>>>>>                    ret = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
>>>>>>>>                    goto release_task;
>>>>>>>>            }
>>>>>>>>
>>>>>>>> +       /*
>>>>>>>> +        * Require CAP_SYS_NICE for influencing process performance. Note that
>>>>>>>> +        * only non-destructive hints are currently supported.
>>>>>>>
>>>>>>> How is non-destructive defined? Is MADV_DONTNEED non-destructive?
>>>>>>
>>>>>> Non-destructive in this context means the data is not lost and can be
>>>>>> recovered. I follow the logic described in
>>>>>> https://lwn.net/Articles/794704/ where Minchan was introducing
>>>>>> MADV_COLD and MADV_PAGEOUT as non-destructive versions of MADV_FREE
>>>>>> and MADV_DONTNEED. Following that logic, MADV_FREE and MADV_DONTNEED
>>>>>> would be considered destructive hints.
>>>>>> Note that process_madvise_behavior_valid() allows only MADV_COLD and
>>>>>> MADV_PAGEOUT at the moment, which are both non-destructive.
>>>>>>
>>>>>
>>>>> There is a plan to support MADV_DONTNEED for this syscall. Do we need
>>>>> to change these access checks again with that support?
>>>>
>>>> Eh, I absolutely don't think letting another process discard memory in
>>>> another process' address space is a good idea. The target process can
>>>> observe that easily and might even run into real issues.
>>>>
>>>> What's the use case?
>>>>
>>>
>>> Userspace oom reaper. Please look at
>>> https://lore.kernel.org/linux-api/20201014183943.GA1489464@google.com/T/
>>>
>>
>> Thanks, somehow I missed that (not that it really changed my opinion on
>> the approach while skimming over the discussion :) will have a more
>> detailed look)
> 
> The latest version of that patchset is:
> https://lore.kernel.org/patchwork/patch/1344419/
> Yeah, memory reaping is a special case when we are operating on a
> dying process to speed up the release of its memory. I don't know if
> for that particular case we need to make the checks stricter. It's a
> dying process anyway and the data is being destroyed. Allowing to
> speed up that process probably can still use CAP_SYS_NICE.

I know, unrelated discussion (sorry, I don't have above thread in my 
archive anymore due to automatic cleanups ...) , but introducing 
MADV_DONTEED on a remote processes, having to tweak range logic because 
we always want to apply it to the whole MM, just to speed up memory 
reaping sounds like completely abusing madvise()/process_madvise() to me.

You want different semantics than MADV_DONTNEED. You want different 
semantics than madvise.

Simple example: mlock()ed pages in the target process. MADV_DONTNEED 
would choke on that. For the use case of reaping, you certainly don't care.

I am not sure if process_madvise() is the right interface to enforce 
discarding of all target memory.


Not to mention that MADV_FREE doesn't make any sense IMHO for memory 
reaping ... no to mention exposing this via process_madvise().

-- 
Thanks,

David / dhildenb


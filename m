Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93E832F167
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 18:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhCERi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 12:38:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20320 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229591AbhCERhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 12:37:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614965874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1pstCskjGQYab2elD3CQ/iN4ZZd067qESB40Q5CZz10=;
        b=jVm0kN0JFfhjsH/rglUwZL9unkF0e1dWxF2h3gI8t12Ny0RRot7Vo4siBAtY513iU1bj4X
        Fwg2abVdZxi/GkO1Tj1wFwBnInBl1WYPx4lpfS7d1quorA+2UYCH1sFp7tro10nWHVYseJ
        3GurQoMVuADONoQ49RVIKrYUZ3B4Azs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-radlGuQOOnS2d24bRP3Fgw-1; Fri, 05 Mar 2021 12:37:50 -0500
X-MC-Unique: radlGuQOOnS2d24bRP3Fgw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5AE6881276;
        Fri,  5 Mar 2021 17:37:47 +0000 (UTC)
Received: from [10.36.112.194] (ovpn-112-194.ams2.redhat.com [10.36.112.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 613526B8DC;
        Fri,  5 Mar 2021 17:37:40 +0000 (UTC)
Subject: Re: [PATCH v3 1/1] mm/madvise: replace ptrace attach requirement for
 process_madvise
To:     Shakeel Butt <shakeelb@google.com>,
        Suren Baghdasaryan <surenb@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <b45d9599-b917-10c3-6b86-6ecd8db16d43@redhat.com>
Date:   Fri, 5 Mar 2021 18:37:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CALvZod4nZ6W05N-4ostUEz5EbCuEvuBpc4LRYfAFgwQU-wb9dQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04.03.21 01:03, Shakeel Butt wrote:
> On Wed, Mar 3, 2021 at 3:34 PM Suren Baghdasaryan <surenb@google.com> wrote:
>>
>> On Wed, Mar 3, 2021 at 3:17 PM Shakeel Butt <shakeelb@google.com> wrote:
>>>
>>> On Wed, Mar 3, 2021 at 10:58 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>>>
>>>> process_madvise currently requires ptrace attach capability.
>>>> PTRACE_MODE_ATTACH gives one process complete control over another
>>>> process. It effectively removes the security boundary between the
>>>> two processes (in one direction). Granting ptrace attach capability
>>>> even to a system process is considered dangerous since it creates an
>>>> attack surface. This severely limits the usage of this API.
>>>> The operations process_madvise can perform do not affect the correctness
>>>> of the operation of the target process; they only affect where the data
>>>> is physically located (and therefore, how fast it can be accessed).
>>>> What we want is the ability for one process to influence another process
>>>> in order to optimize performance across the entire system while leaving
>>>> the security boundary intact.
>>>> Replace PTRACE_MODE_ATTACH with a combination of PTRACE_MODE_READ
>>>> and CAP_SYS_NICE. PTRACE_MODE_READ to prevent leaking ASLR metadata
>>>> and CAP_SYS_NICE for influencing process performance.
>>>>
>>>> Cc: stable@vger.kernel.org # 5.10+
>>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>>>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>>> Acked-by: Minchan Kim <minchan@kernel.org>
>>>> Acked-by: David Rientjes <rientjes@google.com>
>>>> ---
>>>> changes in v3
>>>> - Added Reviewed-by: Kees Cook <keescook@chromium.org>
>>>> - Created man page for process_madvise per Andrew's request: https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/commit/?id=a144f458bad476a3358e3a45023789cb7bb9f993
>>>> - cc'ed stable@vger.kernel.org # 5.10+ per Andrew's request
>>>> - cc'ed linux-security-module@vger.kernel.org per James Morris's request
>>>>
>>>>   mm/madvise.c | 13 ++++++++++++-
>>>>   1 file changed, 12 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/madvise.c b/mm/madvise.c
>>>> index df692d2e35d4..01fef79ac761 100644
>>>> --- a/mm/madvise.c
>>>> +++ b/mm/madvise.c
>>>> @@ -1198,12 +1198,22 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
>>>>                  goto release_task;
>>>>          }
>>>>
>>>> -       mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
>>>> +       /* Require PTRACE_MODE_READ to avoid leaking ASLR metadata. */
>>>> +       mm = mm_access(task, PTRACE_MODE_READ_FSCREDS);
>>>>          if (IS_ERR_OR_NULL(mm)) {
>>>>                  ret = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
>>>>                  goto release_task;
>>>>          }
>>>>
>>>> +       /*
>>>> +        * Require CAP_SYS_NICE for influencing process performance. Note that
>>>> +        * only non-destructive hints are currently supported.
>>>
>>> How is non-destructive defined? Is MADV_DONTNEED non-destructive?
>>
>> Non-destructive in this context means the data is not lost and can be
>> recovered. I follow the logic described in
>> https://lwn.net/Articles/794704/ where Minchan was introducing
>> MADV_COLD and MADV_PAGEOUT as non-destructive versions of MADV_FREE
>> and MADV_DONTNEED. Following that logic, MADV_FREE and MADV_DONTNEED
>> would be considered destructive hints.
>> Note that process_madvise_behavior_valid() allows only MADV_COLD and
>> MADV_PAGEOUT at the moment, which are both non-destructive.
>>
> 
> There is a plan to support MADV_DONTNEED for this syscall. Do we need
> to change these access checks again with that support?

Eh, I absolutely don't think letting another process discard memory in 
another process' address space is a good idea. The target process can 
observe that easily and might even run into real issues.

What's the use case?

-- 
Thanks,

David / dhildenb


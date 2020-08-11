Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975B3241489
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 03:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgHKBZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 21:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbgHKBZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 21:25:15 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22B4C061756
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 18:25:14 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t11so6018614plr.5
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 18:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PCpfFhVUaRaWr6RthgpF9Kzm/HJjZsLLuTqDdDfEeJo=;
        b=GRRaih/uF2Fj9QRRqaeXSp060VJRmf2HUVA8kO0fyrDYKrIihfJF+m4bcqOqPa7I4c
         N/BOmFlWoX05vnCiy+fAHnFHcFJmFXIUZSSUp/zW8bF+JFrrVLnKTHNG0d3QKHM+X6lD
         QlGq1oYnxCJFRPduCya2O0WaIRD+yj0kEELEILn80M+OdjPzah+Nhc4Nvf52aUqhvDt9
         RT62beivdIo+oVDq2FL6Hf1ta23uWA+a3+sKDS5CsMD68nBEs2wOOyKClrKOIkvWnXmm
         fWG20RvZrAwwULAKhsShjrEEYGHCeVxtAItPY7+puTuH1dC0NDY12vtjWY9o3MkkOXcP
         y0Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PCpfFhVUaRaWr6RthgpF9Kzm/HJjZsLLuTqDdDfEeJo=;
        b=uhB+p4LPdTFYJK65jmBe3uD4UAZP8qg2ZyAMMuTXDXmErWwQIgUTjnBYc96EumQSCC
         fSVXywfxI5qkekVALtWKrs/uGtYNhnKC6i1Q2RsvG1RLK5o26S+6TfSDIGdf3o+OjqZk
         okGy6WjCVDdmG5OCGuhot3XHx85bv7mfBsohP1rFUAacZIQGkxQ9rq41tM0w8CMOEjzt
         Ku8fgu68djmV0N79O+MDjfp6vMrhUrx/KV1PC1CQ49g/zQ/yXBoXnBlmp0ODxHYc6tJj
         zx4Nn14eoTOfmSABqdr8lJFNpdN9rPn60mzvHJhVtbERT4eFE3Hk8eumG0G7k6vTZgoI
         lTew==
X-Gm-Message-State: AOAM532maWg70/QsvsEW7iPfvdmwBBseceVd6H7lF9niauOiBx/xmTHu
        HZ8Xn4GgWW6xl7GNoeVXPDUOZZM/Nvw=
X-Google-Smtp-Source: ABdhPJy6ZRX599Qb4c20ndcyS+2w/BW3ofi9VGW/qu9/wIua4zCGR63q5jRXQzMcdH29G9kgmwSXDA==
X-Received: by 2002:a17:902:9683:: with SMTP id n3mr26229324plp.65.1597109114159;
        Mon, 10 Aug 2020 18:25:14 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a26sm19410236pgm.20.2020.08.10.18.25.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 18:25:13 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
To:     Jann Horn <jannh@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net>
 <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
 <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk>
 <20200810201213.GB3982@worktop.programming.kicks-ass.net>
 <4a8fa719-330f-d380-522f-15d79c74ca9a@kernel.dk>
 <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
 <CAG48ez0+=+Q0tjdFxjbbZbZJNkimYL9Bd5odr0T9oWwty6qgoQ@mail.gmail.com>
 <03c0e282-5317-ea45-8760-2c3f56eec0c0@kernel.dk>
 <20200810211057.GG3982@worktop.programming.kicks-ass.net>
 <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk>
 <CAG48ez2dEyxe_ioQaDC3JTdSyLsdOiFKZvk6LGP00ELSfSvhvg@mail.gmail.com>
 <1629f8a9-cee0-75f1-810a-af32968c4055@kernel.dk>
 <dfc3bf88-39a3-bd38-b7b6-5435262013d5@kernel.dk>
 <CAG48ez2EzOpWZbhnuBxVBXjRbLZULJJeeTBsdbL6Hzh9-1YYhA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bdfb29ff-1a17-0813-9bed-21f2583d971e@kernel.dk>
Date:   Mon, 10 Aug 2020 19:25:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez2EzOpWZbhnuBxVBXjRbLZULJJeeTBsdbL6Hzh9-1YYhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/20 4:41 PM, Jann Horn wrote:
> On Tue, Aug 11, 2020 at 12:01 AM Jens Axboe <axboe@kernel.dk> wrote:
>> On 8/10/20 3:28 PM, Jens Axboe wrote:
>>> On 8/10/20 3:26 PM, Jann Horn wrote:
>>>> On Mon, Aug 10, 2020 at 11:12 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>> On 8/10/20 3:10 PM, Peter Zijlstra wrote:
>>>>>> On Mon, Aug 10, 2020 at 03:06:49PM -0600, Jens Axboe wrote:
>>>>>>
>>>>>>> should work as far as I can tell, but I don't even know if there's a
>>>>>>> reliable way to do task_in_kernel().
>>>>>>
>>>>>> Only on NOHZ_FULL, and tracking that is one of the things that makes it
>>>>>> so horribly expensive.
>>>>>
>>>>> Probably no other way than to bite the bullet and just use TWA_SIGNAL
>>>>> unconditionally...
>>>>
>>>> Why are you trying to avoid using TWA_SIGNAL? Is there a specific part
>>>> of handling it that's particularly slow?
>>>
>>> Not particularly slow, but it's definitely heavier than TWA_RESUME. And
>>> as we're driving any pollable async IO through this, just trying to
>>> ensure it's as light as possible.
>>>
>>> It's not a functional thing, just efficiency.
>>
>> Ran some quick testing in a vm, which is worst case for this kind of
>> thing as any kind of mucking with interrupts is really slow. And the hit
>> is substantial. Though with the below, we're basically at parity again.
>> Just for discussion...
>>
>>
>> diff --git a/kernel/task_work.c b/kernel/task_work.c
>> index 5c0848ca1287..ea2c683c8563 100644
>> --- a/kernel/task_work.c
>> +++ b/kernel/task_work.c
>> @@ -42,7 +42,8 @@ task_work_add(struct task_struct *task, struct callback_head *work, int notify)
>>                 set_notify_resume(task);
>>                 break;
>>         case TWA_SIGNAL:
>> -               if (lock_task_sighand(task, &flags)) {
>> +               if (!(task->jobctl & JOBCTL_TASK_WORK) &&
>> +                   lock_task_sighand(task, &flags)) {
>>                         task->jobctl |= JOBCTL_TASK_WORK;
>>                         signal_wake_up(task, 0);
>>                         unlock_task_sighand(task, &flags);
> 
> I think that should work in theory, but if you want to be able to do a
> proper unlocked read of task->jobctl here, then I think you'd have to
> use READ_ONCE() here and make all existing writes to ->jobctl use
> WRITE_ONCE().
> 
> Also, I think that to make this work, stuff like get_signal() will
> need to use memory barriers to ensure that reads from ->task_works are
> ordered after ->jobctl has been cleared - ideally written such that on
> the fastpath, the memory barrier doesn't execute.

I wonder if it's possible to just make it safe for the io_uring case,
since a bigger change would make this performance regression persistent
in this release... Would still require the split add/notification patch,
but that one is trivial.

-- 
Jens Axboe


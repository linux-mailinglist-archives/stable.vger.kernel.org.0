Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5D2476342
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 21:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbhLOU1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 15:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235943AbhLOU1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 15:27:39 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30594C06173F
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 12:27:39 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id m15so21042655pgu.11
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 12:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=aE16Ssev0R3Q0ozi7skL6Cwz7O3Mts6BMgT8usCXa9g=;
        b=hhyRh/Fi5pUZwZtqb9iOEO7Su2F46hg7qQa8cA2wOH7PpRCGWIluis5BV5nZYuvvKL
         jikxNd+5TYThteRoHJ3In943yYAXy4XfHPSAtqp+DA6omeHgPpckwf8gmu+jIYpevk0x
         cII/iPsShb3dss1KOkmhPfgJWqIh01TMHqIBxjdY8tBV0k5MrX5fVudgkvNC+IUXFGjU
         wB49KOhNgiaeuzeZsRqvmGx3mwPYwjLCTWeuu5o1A8WH0UYFAapCIjiSm0J4FuFCOvTE
         6sVbToGXsTe1rBwuDNauTnJYY0typNW2kQ6MEYLL8N6N2rLJ0myFKZhAPRpkxsac/MxC
         LRXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=aE16Ssev0R3Q0ozi7skL6Cwz7O3Mts6BMgT8usCXa9g=;
        b=VQMdLzwbv4TO07f4KlESxes4RE61FD1yKJG8P84Kvr4bIMt3LjLyMicLJk8Q9FC7ht
         8ZbYU/PdAaFxO2rrBauSmXV9StJM3n72kNhsgF7ZHbpkOLo1ENAs1wcg3jVQUWst77hU
         4UbEVGnXxUpsCllqpk1PZ31hQRYZrqrmZ+PEtTAB6Asz6zZLxzA+UO7wDVmNsRQQsxHB
         5MGFMr2Z+zAFG1rtZEIiC+6NAUiupd9/g8QKizS9CDg8Q/Q63rAOY7T5utvtvPBuJNYp
         gMmAjHnOjD02UVIUsIbnICG33gbrLLHT06gjdm52v76LLdCeQUDNJmdo/QeLG84i6E44
         V6DA==
X-Gm-Message-State: AOAM531MrJpnABAovxMmbankY1QZJsbxZBuZvnlnX4o18PBQvTfTuoCD
        nUjOs0BTtovn/CmA+P34h4Ptnw==
X-Google-Smtp-Source: ABdhPJwHZJT+dWs9l1mfZOWrpDuFV6ttBbBlmCJ32uyq29Yx8dw1z9DEi7NrlFpjab6ra/mTVp9Auw==
X-Received: by 2002:a63:5518:: with SMTP id j24mr9070570pgb.401.1639600058655;
        Wed, 15 Dec 2021 12:27:38 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id b1sm3636253pfl.101.2021.12.15.12.27.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 12:27:38 -0800 (PST)
Message-ID: <2cd473d4-734d-95e2-4f3f-d793d065c449@linaro.org>
Date:   Wed, 15 Dec 2021 12:27:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] io_uring: prevent io_put_identity() from freeing a static
 identity
Content-Language: en-US
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+6055980d041c8ac23307@syzkaller.appspotmail.com
References: <20211104012120.729261-1-tadeusz.struk@linaro.org>
 <dd53f11a-ae6f-79af-2ea2-8091d1c4f15e@linaro.org>
In-Reply-To: <dd53f11a-ae6f-79af-2ea2-8091d1c4f15e@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/21 08:38, Tadeusz Struk wrote:
> On 11/3/21 18:21, Tadeusz Struk wrote:
>> Note: this applies to 5.10 stable only. It doesn't trigger on anything
>> above 5.10 as the code there has been substantially reworked. This also
>> doesn't apply to any stable kernel below 5.10 afaict.
>>
>> Syzbot found a bug: KASAN: invalid-free in io_dismantle_req
>> https://syzkaller.appspot.com/bug?id=123d9a852fc88ba573ffcb2dbcf4f9576c3b0559
>>
>> The test submits bunch of io_uring writes and exits, which then triggers
>> uring_task_cancel() and io_put_identity(), which in some corner cases,
>> tries to free a static identity. This causes a panic as shown in the
>> trace below:
>>
>>   BUG: KASAN: double-free or invalid-free in kfree+0xd5/0x310
>>   CPU: 0 PID: 4618 Comm: repro Not tainted 5.10.76-05281-g4944ec82ebb9-dirty #17
>>   Call Trace:
>>    dump_stack_lvl+0x1b2/0x21b
>>    print_address_description+0x8d/0x3b0
>>    kasan_report_invalid_free+0x58/0x130
>>    ____kasan_slab_free+0x14b/0x170
>>    __kasan_slab_free+0x11/0x20
>>    slab_free_freelist_hook+0xcc/0x1a0
>>    kfree+0xd5/0x310
>>    io_dismantle_req+0x9b0/0xd90
>>    io_do_iopoll+0x13a4/0x23e0
>>    io_iopoll_try_reap_events+0x116/0x290
>>    io_uring_cancel_task_requests+0x197d/0x1ee0
>>    io_uring_flush+0x170/0x6d0
>>    filp_close+0xb0/0x150
>>    put_files_struct+0x1d4/0x350
>>    exit_files+0x80/0xa0
>>    do_exit+0x6d9/0x2390
>>    do_group_exit+0x16a/0x2d0
>>    get_signal+0x133e/0x1f80
>>    arch_do_signal+0x7b/0x610
>>    exit_to_user_mode_prepare+0xaa/0xe0
>>    syscall_exit_to_user_mode+0x24/0x40
>>    do_syscall_64+0x3d/0x70
>>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>>   Allocated by task 4611:
>>    ____kasan_kmalloc+0xcd/0x100
>>    __kasan_kmalloc+0x9/0x10
>>    kmem_cache_alloc_trace+0x208/0x390
>>    io_uring_alloc_task_context+0x57/0x550
>>    io_uring_add_task_file+0x1f7/0x290
>>    io_uring_create+0x2195/0x3490
>>    __x64_sys_io_uring_setup+0x1bf/0x280
>>    do_syscall_64+0x31/0x70
>>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>>   The buggy address belongs to the object at ffff88810732b500
>>    which belongs to the cache kmalloc-192 of size 192
>>   The buggy address is located 88 bytes inside of
>>    192-byte region [ffff88810732b500, ffff88810732b5c0)
>>   Kernel panic - not syncing: panic_on_warn set ...
>>
>> This issue bisected to this commit:
>> commit 186725a80c4e ("io_uring: fix skipping disabling sqo on exec")
>>
>> Simple reverting the offending commit doesn't work as it hits some
>> other, related issues like:
>>
>> /* sqo_dead check is for when this happens after cancellation */
>> WARN_ON_ONCE(ctx->sqo_task == current && !ctx->sqo_dead &&
>>          !xa_load(&tctx->xa, (unsigned long)file));
>>
>>   ------------[ cut here ]------------
>>   WARNING: CPU: 1 PID: 5622 at fs/io_uring.c:8960 io_uring_flush+0x5bc/0x6d0
>>   Modules linked in:
>>   CPU: 1 PID: 5622 Comm: repro Not tainted 5.10.76-05281-g4944ec82ebb9-dirty #16
>>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-6.fc35 
>> 04/01/2014
>>   RIP: 0010:io_uring_flush+0x5bc/0x6d0
>>   Call Trace:
>>   filp_close+0xb0/0x150
>>   put_files_struct+0x1d4/0x350
>>   reset_files_struct+0x88/0xa0
>>   bprm_execve+0x7f2/0x9f0
>>   do_execveat_common+0x46f/0x5d0
>>   __x64_sys_execve+0x92/0xb0
>>   do_syscall_64+0x31/0x70
>>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> Changing __io_uring_task_cancel() to call io_disable_sqo_submit() directly,
>> as the comment suggests, only if __io_uring_files_cancel() is not executed
>> seems to fix the issue.
>>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: <io-uring@vger.kernel.org>
>> Cc: <linux-fsdevel@vger.kernel.org>
>> Cc: <linux-kernel@vger.kernel.org>
>> Cc: <stable@vger.kernel.org>
>> Reported-by: syzbot+6055980d041c8ac23307@syzkaller.appspotmail.com
>> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
>> ---
>>   fs/io_uring.c | 21 +++++++++++++++++----
>>   1 file changed, 17 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 0736487165da..fcf9ffe9b209 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -8882,20 +8882,18 @@ void __io_uring_task_cancel(void)
>>       struct io_uring_task *tctx = current->io_uring;
>>       DEFINE_WAIT(wait);
>>       s64 inflight;
>> +    int canceled = 0;
>>       /* make sure overflow events are dropped */
>>       atomic_inc(&tctx->in_idle);
>> -    /* trigger io_disable_sqo_submit() */
>> -    if (tctx->sqpoll)
>> -        __io_uring_files_cancel(NULL);
>> -
>>       do {
>>           /* read completions before cancelations */
>>           inflight = tctx_inflight(tctx);
>>           if (!inflight)
>>               break;
>>           __io_uring_files_cancel(NULL);
>> +        canceled = 1;
>>           prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
>> @@ -8909,6 +8907,21 @@ void __io_uring_task_cancel(void)
>>           finish_wait(&tctx->wait, &wait);
>>       } while (1);
>> +    /*
>> +     * trigger io_disable_sqo_submit()
>> +     * if not already done by __io_uring_files_cancel()
>> +     */
>> +    if (tctx->sqpoll && !canceled) {
>> +        struct file *file;
>> +        unsigned long index;
>> +
>> +        xa_for_each(&tctx->xa, index, file) {
>> +            struct io_ring_ctx *ctx = file->private_data;
>> +
>> +            io_disable_sqo_submit(ctx);
>> +        }
>> +    }
>> +
>>       atomic_dec(&tctx->in_idle);
>>       io_uring_remove_task_files(tctx);
>>
> 
> Hi,
> Any comments on this one? It needs to be ACK'ed by the maintainer before
> it is applied to 5.10 stable.
> 

This still triggers on 5.10.85. Anyone want to have a look?

-- 
Thanks,
Tadeusz

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47D12412B0
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 00:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgHJWBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 18:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgHJWBc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 18:01:32 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB4EC061756
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 15:01:31 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id c10so568287pjn.1
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 15:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cM4OjjEWcbHbY0GVY5VnUR1v3kBwoBaqCgoeYNEMoT8=;
        b=cSb81jVjKS4HQMZeAyGv4xyrSmXyrzgGp0s5Uv0kRAhf1EpAlrMWxP41CKCUFtVUq9
         xB7UPOWeoUftWkUrwWsq2VIsza2i/c8XcFyJtzmpo3WsxaqvhRArpgfCZHOKBmZDk1jn
         SQGxkFXVhk1mlK4zNDhYUd2SByJbEc20cY+lWO7FXcxqIEnRHOOqkkgS6JEbgq9hVwJU
         rvdTlR5JppXvteK51LOmTvXu6CKvgGIqyPTYuj0wpI5UQ5zw3ex75/0IUdZokjmdNbsA
         MbIZoVylg0ZB/tR6FDG5WXjuJOUMKYjAlDRUPXPQ9kZ30EDyMjXq+lVaCD3jeJyjkwrv
         sQTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cM4OjjEWcbHbY0GVY5VnUR1v3kBwoBaqCgoeYNEMoT8=;
        b=OtlPCBe/lHlKh365ZTtAcZxBNS5Ie6Kchc/HJ+hPYFeGlfAS8X95EfIyUGw3k6MI5F
         yZ/nPLt8lToKLPFfS6sQ/i19fT5l3JTeZlpxfY6YV1NxyubNgdyXzU0gH5MwlyAEvCJj
         VOd1VHEz4rGA0RkD8k1wSttx8FYGH6nDsC6IuZbqL7Ma2xz77qyiVDw6U2gGHPnnG7N+
         /xuuUDJyTx/KBVmyFUwBiceBStDcAAWsj7tHvr1qxf4SMl+UTYIIaJe2ZC3NEYvhpuQg
         5QJ+6n/Rop8GchpHh8+dBfTpNl3klPeABce35nC2ofLX88JC6/hoQR9kCvVopJ6QA8sU
         TOFw==
X-Gm-Message-State: AOAM533iUyelCmOz6ipydD3vplsxkOaDNnduQ+cPrT2vjwUo+ckhyZtg
        jzuyOxPMYIjNVjVO8eUP8eWHLQ==
X-Google-Smtp-Source: ABdhPJyL5UFgdpvCNi6WXlbRPP+C4AW6Drsbnpij0+MvXZvbVEd5B7tr9A4epbfxVSN/v7l1JJShZA==
X-Received: by 2002:a17:90a:a511:: with SMTP id a17mr1390162pjq.23.1597096890499;
        Mon, 10 Aug 2020 15:01:30 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u29sm25965520pfl.180.2020.08.10.15.01.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 15:01:29 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
From:   Jens Axboe <axboe@kernel.dk>
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
Message-ID: <dfc3bf88-39a3-bd38-b7b6-5435262013d5@kernel.dk>
Date:   Mon, 10 Aug 2020 16:01:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1629f8a9-cee0-75f1-810a-af32968c4055@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/20 3:28 PM, Jens Axboe wrote:
> On 8/10/20 3:26 PM, Jann Horn wrote:
>> On Mon, Aug 10, 2020 at 11:12 PM Jens Axboe <axboe@kernel.dk> wrote:
>>> On 8/10/20 3:10 PM, Peter Zijlstra wrote:
>>>> On Mon, Aug 10, 2020 at 03:06:49PM -0600, Jens Axboe wrote:
>>>>
>>>>> should work as far as I can tell, but I don't even know if there's a
>>>>> reliable way to do task_in_kernel().
>>>>
>>>> Only on NOHZ_FULL, and tracking that is one of the things that makes it
>>>> so horribly expensive.
>>>
>>> Probably no other way than to bite the bullet and just use TWA_SIGNAL
>>> unconditionally...
>>
>> Why are you trying to avoid using TWA_SIGNAL? Is there a specific part
>> of handling it that's particularly slow?
> 
> Not particularly slow, but it's definitely heavier than TWA_RESUME. And
> as we're driving any pollable async IO through this, just trying to
> ensure it's as light as possible.
> 
> It's not a functional thing, just efficiency.

Ran some quick testing in a vm, which is worst case for this kind of
thing as any kind of mucking with interrupts is really slow. And the hit
is substantial. Though with the below, we're basically at parity again.
Just for discussion...


diff --git a/kernel/task_work.c b/kernel/task_work.c
index 5c0848ca1287..ea2c683c8563 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -42,7 +42,8 @@ task_work_add(struct task_struct *task, struct callback_head *work, int notify)
 		set_notify_resume(task);
 		break;
 	case TWA_SIGNAL:
-		if (lock_task_sighand(task, &flags)) {
+		if (!(task->jobctl & JOBCTL_TASK_WORK) &&
+		    lock_task_sighand(task, &flags)) {
 			task->jobctl |= JOBCTL_TASK_WORK;
 			signal_wake_up(task, 0);
 			unlock_task_sighand(task, &flags);

-- 
Jens Axboe


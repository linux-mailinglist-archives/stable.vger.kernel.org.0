Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69C9241195
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 22:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgHJUQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 16:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgHJUQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 16:16:39 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F078BC061787
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 13:16:39 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id l60so643855pjb.3
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 13:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0arKLvml0m+DT+Vh3G9XF/qsgSjLN36L2lo966JcA2k=;
        b=uO92z1Cc+VMQDCMVrvmfaWD+1TgmM2ebbClnJ1HM5ZHIdUyYzDr+DbBj2T3/t4tscT
         zkE5IiSaS85RcoFxmlrCgi0cjT+556JTQ1eEsWiGkN5JiQ4xHUa4rCXGkoGDiT9fQt61
         Yom3fdpmHVnrZkCPHC4/+MYGEdE2/E4cDrSn2wGLXfXlHvolT6hsQinFOx9yJ8zP7omq
         qVHVYK++775Tx5Geqo/njAy9b8FunD2D2l3Qt9c8EcjWGkeVQznEhkBHfN/u15TQJg/r
         OC5qxrEFCQtxxQSvtOFh+i4WZ+gYWiK83Epb25LgI5jnjJ7DLGv7aBG5nLcm8oDv7VlL
         i3OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0arKLvml0m+DT+Vh3G9XF/qsgSjLN36L2lo966JcA2k=;
        b=W2T3VQC4FAviH2wJqL3epyr0cNeT+j8I6BqLUwTZx8p9PQbht/Ui+03/kcYl99Mvus
         O0mo+Y3y2+wpgamL9stO6GyPUa2vKIe1usGQIvmnD8/t24NFjlSoyxW8pXtwA3tRM0Sw
         NdlhQMcysrxx2bvH8r0yWaFNw0U2S2vqVBw3rNSqciA9ln6ZxzfKMB45dYgcxvwOC+n7
         e8TNiz5SLyN+OtMdjHyGH5hBqMbqhgfBhiM84aSVZVLhzPkbGaESAKK9gtcC+/Szgplr
         fp6NXe4VlFZewu33nZPFY7czmnpNDvINLYWpCzXHaGZshOYrIsDcC8M1fnN+dxz/np3c
         932Q==
X-Gm-Message-State: AOAM533jcAi/HxFashxdW3UKaZ2vyfAxHo/SWOfbSu+bEfyrq1mta9uN
        t/dCxPynp03vGlKkZHewGwGQwQ==
X-Google-Smtp-Source: ABdhPJzOTmqu/HeKYrR9DpvzQvZNZ88Rw6YZayzvUt3wOSIB/AII0XpqnRR2CW8QH7+4Zr3XgU9QHw==
X-Received: by 2002:a17:902:a418:: with SMTP id p24mr26748875plq.55.1597090599428;
        Mon, 10 Aug 2020 13:16:39 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y29sm22981976pfr.11.2020.08.10.13.16.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 13:16:38 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org,
        Josef <josef.grieb@gmail.com>, Oleg Nesterov <oleg@redhat.com>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net>
 <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
 <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk>
 <20200810201213.GB3982@worktop.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1b2d9682-b53c-2e28-4b74-81039ac3a6bc@kernel.dk>
Date:   Mon, 10 Aug 2020 14:16:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200810201213.GB3982@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/20 2:12 PM, Peter Zijlstra wrote:
> On Mon, Aug 10, 2020 at 01:21:48PM -0600, Jens Axboe wrote:
> 
>>>> Wait.. so the only change here is that you look at tsk->state, _after_
>>>> doing __task_work_add(), but nothing, not the Changelog nor the comment
>>>> explains this.
>>>>
>>>> So you're relying on __task_work_add() being an smp_mb() vs the add, and
>>>> you order this against the smp_mb() in set_current_state() ?
>>>>
>>>> This really needs spelling out.
>>>
>>> I'll update the changelog, it suffers a bit from having been reused from
>>> the earlier versions. Thanks for checking!
>>
>> I failed to convince myself that the existing construct was safe, so
>> here's an incremental on top of that. Basically we re-check the task
>> state _after_ the initial notification, to protect ourselves from the
>> case where we initially find the task running, but between that check
>> and when we do the notification, it's now gone to sleep. Should be
>> pretty slim, but I think it's there.
>>
>> Hence do a loop around it, if we're using TWA_RESUME.
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 44ac103483b6..a4ecb6c7e2b0 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1780,12 +1780,27 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
>>  	 * to ensure that the issuing task processes task_work. TWA_SIGNAL
>>  	 * is needed for that.
>>  	 */
>> -	if (ctx->flags & IORING_SETUP_SQPOLL)
>> +	if (ctx->flags & IORING_SETUP_SQPOLL) {
>>  		notify = 0;
>> -	else if (READ_ONCE(tsk->state) != TASK_RUNNING)
>> -		notify = TWA_SIGNAL;
>> +	} else {
>> +		bool notified = false;
>>  
>> -	__task_work_notify(tsk, notify);
>> +		/*
>> +		 * If the task is running, TWA_RESUME notify is enough. Make
>> +		 * sure to re-check after we've sent the notification, as not
> 
> Could we get a clue as to why TWA_RESUME is enough when it's running? I
> presume it is because we'll do task_work_run() somewhere before we
> block, but having an explicit reference here might help someone new to
> this make sense of it all.

Right, it's because we're sure to run task_work in that case. I'll
update the comment.

-- 
Jens Axboe


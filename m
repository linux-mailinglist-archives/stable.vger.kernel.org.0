Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A793F241189
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 22:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgHJUNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 16:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgHJUNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 16:13:15 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67213C061787
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 13:13:15 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id h12so5560954pgm.7
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 13:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cVMQ8g3SCerSphZvzyir1ZlhBkHMU3rkUgZOamEcMx8=;
        b=mZoQI4/u+JxzP6jCOLero52fI9EqkS5rEuIu4XflTfotzQqCr8CynCETKb5U8OellB
         uDWGJyUsPs/PVJHoMgZSMHxHzzC72utThHkIVNjlVtHF5IBtOIey90OYQPcMAjZrgpve
         vKgRbUzYa/uTkVv020ncDqwYQlSzAI9hqrWgXnH3Ri6sMGfLvmgSPhcjes3sFbQ5YGzP
         x69G5bu2tWVo/RRaLGoCd6xyEoTsNeFv7gXBq1d+8pKfm3BgurrWmVDWie4/aIy7LFrF
         D43kU4BFBQCGct3qP/CeulETeKH9t75u1uvZiEkyDnSbkMk/8DfG1QedyxOv8ziJMAvq
         OgXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cVMQ8g3SCerSphZvzyir1ZlhBkHMU3rkUgZOamEcMx8=;
        b=M7QCPZTWIi7OyTcTPumrO/mph6Y7+kA8dVu0zoJ3qLidSMFVj7+GUdrMY1HvjXMSb7
         mV4HYQjaSMGaB/PK4bosnACMBmRv/nHO8n6EVqCRjKwEtqxI54qoz5zNQajfVEoTEJlV
         6sTqNZbiO2cjaU1FNbYC1mfXVUpldcKmflFrcfM/kYmsyhuJVDnLZdoU2kUMNn7Zbfa4
         DqexqCOxpHm4hGcyhUIa1nLIjfRyhChmBIOTrRoXRV2rLj7ylzbq/I9aAM4UrQEtfSy3
         Dc3av3gLbmEaMScoQ6YBJa1YVWj2u/XX5YZ+YK6reJi0KliWuY7cx2iR9RmLVEfoki5X
         DAbQ==
X-Gm-Message-State: AOAM533n7xiJfSqPiEaP+cPJjX2y+Zt2JQ9sGqq6X47wWbFgxaTm3b2O
        08gT+V7MzCUeR6Qyv4wfE/43HA==
X-Google-Smtp-Source: ABdhPJzdBHPY2D9W9vBeoeJ2rKw5KG42XKN9xqsyQu6JlvZbqLt6fVTxb5gGF3uTBwoYu6ZR3ibdIw==
X-Received: by 2002:a63:5b07:: with SMTP id p7mr22664877pgb.250.1597090394853;
        Mon, 10 Aug 2020 13:13:14 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id ez7sm359786pjb.10.2020.08.10.13.13.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 13:13:14 -0700 (PDT)
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
Message-ID: <4a8fa719-330f-d380-522f-15d79c74ca9a@kernel.dk>
Date:   Mon, 10 Aug 2020 14:13:12 -0600
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
> 
>> +		 * to have a race between the check and the notification. This
>> +		 * only applies for TWA_RESUME, as TWA_SIGNAL is safe with a
>> +		 * sleeping task
>> +		 */
>> +		do {
>> +			if (READ_ONCE(tsk->state) != TASK_RUNNING)
>> +				notify = TWA_SIGNAL;
>> +			else if (notified)
>> +				break;
>> +			__task_work_notify(tsk, notify);
>> +			notified = true;
>> +		} while (notify != TWA_SIGNAL);
>> +	}
>>  	wake_up_process(tsk);
>>  	return 0;
>>  }
> 
> Would it be clearer to write it like so perhaps?
> 
> 	/*
> 	 * Optimization; when the task is RUNNING we can do with a
> 	 * cheaper TWA_RESUME notification because,... <reason goes
> 	 * here>. Otherwise do the more expensive, but always correct
> 	 * TWA_SIGNAL.
> 	 */
> 	if (READ_ONCE(tsk->state) == TASK_RUNNING) {
> 		__task_work_notify(tsk, TWA_RESUME);
> 		if (READ_ONCE(tsk->state) == TASK_RUNNING)
> 			return;
> 	}
> 	__task_work_notify(tsk, TWA_SIGNAL);
> 	wake_up_process(tsk);

Yeah that is easier to read, wasn't a huge fan of the loop since it's
only a single retry kind of condition. I'll adopt this suggestion,
thanks!

-- 
Jens Axboe


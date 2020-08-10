Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C676A240F5F
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbgHJTVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730342AbgHJTVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 15:21:51 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032F3C061787
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 12:21:50 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id l60so527767pjb.3
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 12:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zhBrPzLrgwSOK6IoThnZRHLRdVzRJupy+N07FBv6wjw=;
        b=cC/bCU5qRxyU4ouap8na9urRs4istEWMjsiXWRBpwhLf0EpBtb/nIAxsIGnS8xuKmm
         JwBL9wpRUONGi+ptiIoa8A46xMK/4fIwNQWOC+LfTYXobMvqQHv98/KI8vTz3frNCTjN
         T1rg4Cax+ODFEyZ8fBcKPwZZ9Hi5t8HTlteA2hcin//8Bgnj6tDd/PQlF+vH1hxGtX2z
         xckeYobZ+wVh045t/97BKjwaW9v8HJTdappc7/XCqKIXTo4bKo1+1+Uji77kdnAoc7Dd
         CPILIlloIuLMDIGP/01fnfQT/LuXKjYnBydQens18Fb0c6Z8xXDGDV3vuDgEsrbIKSSf
         MsJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zhBrPzLrgwSOK6IoThnZRHLRdVzRJupy+N07FBv6wjw=;
        b=uQBp5uUuiMcnGShAnrIAQ6vw4qPoHQygUwTHf3i0oxasizKru1sO4i+190WLlc53Q/
         d1a8UL35hEK5QWyTyY2zgdgwE0qXxEP0xsImAJAy3cXa5wRa2hErNIirkoyqn65XU/Np
         H9sAata36wI6E4ehQ1jkfnT9ziPD1p4iCUKLcSTWVJB8rnTPEdfNzPDIK6DLpCL74Wbu
         s9bS1SovKa/L6DJL4dps7u3glerWhTLMWnzZa9cmgo1PSZBJzNy3iBCGn2IvtuUvQoY7
         faZ7r52b+RBDfzuh5ZPlQp+ZUkGxI7VSO44cOvNJTEwWXG95QnXb2h+ZEpWSlD4/3WNV
         iO9w==
X-Gm-Message-State: AOAM5313l1JlZ1IxrEuIvF4vpfHbJa1GC7Ktc1ocngISRpI/rf4IhG8x
        baifif1T5mApkmS4d906f8pBiw==
X-Google-Smtp-Source: ABdhPJwz9ir8ZqL6iUQ2SoOy3rN46uQ4ZKDt39g1cc4HeRcEIV6GR02w8sXqEyssN6JQdXT0bzZ6MQ==
X-Received: by 2002:a17:90a:148:: with SMTP id z8mr806295pje.197.1597087310205;
        Mon, 10 Aug 2020 12:21:50 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l17sm24959777pff.126.2020.08.10.12.21.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 12:21:49 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
From:   Jens Axboe <axboe@kernel.dk>
To:     peterz@infradead.org
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org,
        Josef <josef.grieb@gmail.com>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net>
 <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
Message-ID: <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk>
Date:   Mon, 10 Aug 2020 13:21:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/20 9:02 AM, Jens Axboe wrote:
> On 8/10/20 5:42 AM, peterz@infradead.org wrote:
>> On Sat, Aug 08, 2020 at 12:34:39PM -0600, Jens Axboe wrote:
>>> An earlier commit:
>>>
>>> b7db41c9e03b ("io_uring: fix regression with always ignoring signals in io_cqring_wait()")
>>>
>>> ensured that we didn't get stuck waiting for eventfd reads when it's
>>> registered with the io_uring ring for event notification, but we still
>>> have a gap where the task can be waiting on other events in the kernel
>>> and need a bigger nudge to make forward progress.
>>>
>>> Ensure that we use signaled notifications for a task that isn't currently
>>> running, to be certain the work is seen and processed immediately.
>>>
>>> Cc: stable@vger.kernel.org # v5.7+
>>> Reported-by: Josef <josef.grieb@gmail.com>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>  fs/io_uring.c | 22 ++++++++++++++--------
>>>  1 file changed, 14 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index e9b27cdaa735..443eecdfeda9 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -1712,21 +1712,27 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
>>>  	struct io_ring_ctx *ctx = req->ctx;
>>>  	int ret, notify = TWA_RESUME;
>>>  
>>> +	ret = __task_work_add(tsk, cb);
>>> +	if (unlikely(ret))
>>> +		return ret;
>>> +
>>>  	/*
>>>  	 * SQPOLL kernel thread doesn't need notification, just a wakeup.
>>> -	 * If we're not using an eventfd, then TWA_RESUME is always fine,
>>> -	 * as we won't have dependencies between request completions for
>>> -	 * other kernel wait conditions.
>>> +	 * For any other work, use signaled wakeups if the task isn't
>>> +	 * running to avoid dependencies between tasks or threads. If
>>> +	 * the issuing task is currently waiting in the kernel on a thread,
>>> +	 * and same thread is waiting for a completion event, then we need
>>> +	 * to ensure that the issuing task processes task_work. TWA_SIGNAL
>>> +	 * is needed for that.
>>>  	 */
>>>  	if (ctx->flags & IORING_SETUP_SQPOLL)
>>>  		notify = 0;
>>> -	else if (ctx->cq_ev_fd)
>>> +	else if (READ_ONCE(tsk->state) != TASK_RUNNING)
>>>  		notify = TWA_SIGNAL;
>>>  
>>> -	ret = task_work_add(tsk, cb, notify);
>>> -	if (!ret)
>>> -		wake_up_process(tsk);
>>> -	return ret;
>>> +	__task_work_notify(tsk, notify);
>>> +	wake_up_process(tsk);
>>> +	return 0;
>>>  }
>>
>> Wait.. so the only change here is that you look at tsk->state, _after_
>> doing __task_work_add(), but nothing, not the Changelog nor the comment
>> explains this.
>>
>> So you're relying on __task_work_add() being an smp_mb() vs the add, and
>> you order this against the smp_mb() in set_current_state() ?
>>
>> This really needs spelling out.
> 
> I'll update the changelog, it suffers a bit from having been reused from
> the earlier versions. Thanks for checking!

I failed to convince myself that the existing construct was safe, so
here's an incremental on top of that. Basically we re-check the task
state _after_ the initial notification, to protect ourselves from the
case where we initially find the task running, but between that check
and when we do the notification, it's now gone to sleep. Should be
pretty slim, but I think it's there.

Hence do a loop around it, if we're using TWA_RESUME.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 44ac103483b6..a4ecb6c7e2b0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1780,12 +1780,27 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
 	 * to ensure that the issuing task processes task_work. TWA_SIGNAL
 	 * is needed for that.
 	 */
-	if (ctx->flags & IORING_SETUP_SQPOLL)
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		notify = 0;
-	else if (READ_ONCE(tsk->state) != TASK_RUNNING)
-		notify = TWA_SIGNAL;
+	} else {
+		bool notified = false;
 
-	__task_work_notify(tsk, notify);
+		/*
+		 * If the task is running, TWA_RESUME notify is enough. Make
+		 * sure to re-check after we've sent the notification, as not
+		 * to have a race between the check and the notification. This
+		 * only applies for TWA_RESUME, as TWA_SIGNAL is safe with a
+		 * sleeping task
+		 */
+		do {
+			if (READ_ONCE(tsk->state) != TASK_RUNNING)
+				notify = TWA_SIGNAL;
+			else if (notified)
+				break;
+			__task_work_notify(tsk, notify);
+			notified = true;
+		} while (notify != TWA_SIGNAL);
+	}
 	wake_up_process(tsk);
 	return 0;
 }

and I've folded it in here:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=8d685b56f80b16516be9ce2eb1aee5adcfba13ff

-- 
Jens Axboe


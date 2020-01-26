Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 577CA149BF2
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 17:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgAZQ5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 11:57:33 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41253 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgAZQ5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 11:57:33 -0500
Received: by mail-pl1-f194.google.com with SMTP id t14so2871943plr.8
        for <stable@vger.kernel.org>; Sun, 26 Jan 2020 08:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7zqZazIrLW3UMe+DEg8Ims5Vma+2yCeGVjU7l0hDaFI=;
        b=FmXnlEHSap/erSDUtHgbLZKvNXoyQp7mGEL9OB4HWUDrPGQ+y+gu6hEwu1M1AikPli
         Y7nyUsM/YtgdC3/6V00wRNkgkG0l08K1eX+UKID6MEYiQiul4kDlCJLfax24Fms64Cdq
         kghBW/392UqzwkI6gE/disn1tK6WgdJIlUc3/KOX3f6beRwWYR0+zRDZNI6pjv6GRU3y
         szxPlgY8vf9C3Kaqw43G3ozp6Ix8/1XkYcraGg5AkO1jYS0Sq9ogD0JOzmjPmfl9enWB
         fu7dCaO08I3YCzI/THbHAP5rRUIrND/QyOfKXPXHT7N82uF06hgM+iuQSPEI8MWD6FvS
         iOeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7zqZazIrLW3UMe+DEg8Ims5Vma+2yCeGVjU7l0hDaFI=;
        b=BDlKAAfn4l5gmjByDQMXreDgpvs8NDNi7ZOGWM2LuXCQhmPomJyhpAxWScGHKZuEMu
         /ltN4xBhfyclyTEcSoQPoerrJQdnN8qy3WTXextDIcjAdpHfHGfZDTZkH7ZueiWIDPQq
         czlZ652T338jGdBBkBRBaUMjH6rFKv2DinV6vXaqd6GijC6hHVStOYvTY3yFCI1L3MlJ
         3L2pd6cKfsV/trayPWCsQCJVuRgK9Gh9KbduuboPl5J6vJgr0F6qNIlPxMqHT69GHs4w
         Kf0h3le51jfUkdFn1hGCA2/n8hrsjfVyqIbUuWop/ZkM3lwwH32ZQiqCu4cvUD5nQOuQ
         WkGw==
X-Gm-Message-State: APjAAAXaM1v77Hm1wrgALEvyOaMqyOqajMj2mX1nUuBiRBrRc8zwN7Zy
        9ZX3y0ssugLDRISR8ASFux0QUw==
X-Google-Smtp-Source: APXvYqx4rWV7nx2DHaapCpgosWizbCCBCsXwyBHP8fEaGjZ94AtWJvkTA6aleGx1vap8iMDtXG8New==
X-Received: by 2002:a17:90b:8ce:: with SMTP id ds14mr10296557pjb.57.1580057852072;
        Sun, 26 Jan 2020 08:57:32 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u26sm12381726pfn.46.2020.01.26.08.57.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 08:57:31 -0800 (PST)
Subject: Re: [PATCH 5.4 033/222] io_uring: only allow submit from owning task
To:     Andres Freund <andres@anarazel.de>,
        Stefan Metzmacher <metze@samba.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>
References: <20200122092833.339495161@linuxfoundation.org>
 <20200122092835.852416399@linuxfoundation.org>
 <1b4a79c1-6cda-12a8-219b-0c1c146faeff@samba.org>
 <20200126055457.5w4f5jyhkic7cixu@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c52a3b63-731b-95f2-ae97-0ad153e7698b@kernel.dk>
Date:   Sun, 26 Jan 2020 09:57:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200126055457.5w4f5jyhkic7cixu@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/25/20 10:54 PM, Andres Freund wrote:
> Hi,
> 
> On 2020-01-24 11:38:02 +0100, Stefan Metzmacher wrote:
>> Am 22.01.20 um 10:26 schrieb Greg Kroah-Hartman:
>>> From: Jens Axboe <axboe@kernel.dk>
>>>
>>> commit 44d282796f81eb1debc1d7cb53245b4cb3214cb5 upstream.
>>>
>>> If the credentials or the mm doesn't match, don't allow the task to
>>> submit anything on behalf of this ring. The task that owns the ring can
>>> pass the file descriptor to another task, but we don't want to allow
>>> that task to submit an SQE that then assumes the ring mm and creds if
>>> it needs to go async.
>>>
>>> Cc: stable@vger.kernel.org
>>> Suggested-by: Stefan Metzmacher <metze@samba.org>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>>
>>> ---
>>>  fs/io_uring.c |    6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -3716,6 +3716,12 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned
>>>  			wake_up(&ctx->sqo_wait);
>>>  		submitted = to_submit;
>>>  	} else if (to_submit) {
>>> +		if (current->mm != ctx->sqo_mm ||
>>> +		    current_cred() != ctx->creds) {
>>> +			ret = -EPERM;
>>> +			goto out;
>>> +		}
>>> +
>>
>> I thought about this a bit more.
>>
>> I'm not sure if this is actually to restrictive,
>> because it means applications like Samba won't
>> be able to use io-uring at all.
> 
> Yea, I think it is too restrictive. In fact, it broke my WIP branch to
> make postgres use io_uring.
> 
> 
> Postgres uses a forked process model, with all sub-processes forked off
> one parent process ("postmaster"), sharing MAP_ANONYMOUS|MAP_SHARED
> memory (buffer pool, locks, and lots of other IPC). My WIP branch so far
> has postmaster create a number of io_urings that then the different
> processes can use (with locking if necessary).
> 
> In plenty of the cases it's fairly important for performance to not
> require an additional context switch initiate IO, therefore we cannot
> delegate submitting to an io_uring to separate process. But it's not
> feasible to have one (or even two) urings for each process either: For
> one, that's just about guaranteed to bring us over the default
> RLIMIT_MEMLOCK limit, and requiring root only config changes is not an
> option for many (nor user friendly).
> 
> 
> Not sharing queues makes it basically impossible to rely on io_uring
> ordering properties when operation interlock is needed. E.g. to
> guarantee that the journal is flushed before some data buffer can be
> written back, being able to make use of links and drains is great - but
> there's one journal for all processes. To be able to guarantee anything,
> all the interlocked writes need to go through one io_uring. I've not yet
> implemented this, so I don't have numbers, but I expect pretty
> significant savings.
> 
> 
> Not being able to share urings also makes it harder to resolve
> deadlocks:
> 
> As we call into both library and user defined code, we cannot guarantee
> that a specific backend process will promptly (or at all, when waiting
> for some locks) process cqes. There's also sections where we don't want
> to constantly check for ready events, for performance reasons.  But
> operations initiated by a process might be blocking other connections:
> 
> E.g. process #1 might have initiated transferring a number of blocks
> into postgres' buffer pool via io_uring , and now is busy processing the
> first block that completed. But now process #2 might need one of the
> buffers that had IO queued, but didn't complete in time for #1 to see
> the results.  The way I have it set up right now, #2 simply can process
> pending cqes in the relevant queue. Which, in this example, would mark
> the pg buffer pool entry as valid, allowing #2 to continue.
> 
> Now, completions can still be read by all processes, so I could continue
> to do the above: But that'd require all potentially needed io_urings to
> be set up in postmaster, before the first fork, and all processes to
> keep all those FDs open (commonly several hundred). Not an attractive
> option either, imo.
> 
> Obviously we could solve this by having a sqe result processing thread
> running within each process - but that'd be a very significant new
> overhead. And it'd require making some non-threadsafe code threadsafe,
> which I do not relish tackling as a side-effect of io_uring adoption.
> 
> 
> It also turns out to be nice from a performance / context-switch rate
> angle to be able to process cqes for submissions by other
> processes. Saves an expensive context switch, and often enough it really
> doesn't matter which process processes the completion (especially for
> readahead). And in other cases it's cheap to just schedule the
> subsequent work from the cqe processor, e.g. initiating readahead of a
> few more blocks into the pg buffer pool.  Similarly, there are a few
> cases where it's useful for several processes to submit IO into a uring
> primarily drained by one specific process, to offload the subsequent
> action, if that's expensive
> 
> 
> Now, I think there's a valid argument to be made that postgres should
> just use threads, and not be hampered by any of this. But a) that's not
> going to happen all that soon, it's a large change, b) it's far from
> free from problems either, especially scalability on larger machines,
> and robustness.
> 
> 
>> As even if current_cred() and ctx->creds describe the same
>> set of uid,gids the != won't ever match again and
>> makes the whole ring unuseable.
> 
> Indeed.  It also seems weird that a sqpoll now basically has different
> semantics, allowing the io_uring to be used by multiple processes - a
> task with a different mm can still wake the sqpoll thread up, even.
> 
> Since the different processes attached still can still write to the
> io_uring mmaped memory, they can still queue sqes, they just can't
> initiate the processing. But the next time the creator of the uring
> submits, they will still be - and thus it seems that the kernel needs to
> handle this safely. So I really don't get what this actually achieves?
> Am I missing something here?

Thanks for your detailed reported, I'm going to revert this change for
5.5.

-- 
Jens Axboe


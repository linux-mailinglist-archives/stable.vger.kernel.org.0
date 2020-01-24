Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D231014904B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 22:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgAXVlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 16:41:44 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:34495 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728984AbgAXVlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 16:41:44 -0500
Received: by mail-il1-f195.google.com with SMTP id l4so2780735ilj.1
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 13:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HDVPrh9iJxJQ8bOLJxHZkUXlGRmda9MUCxj388b9fsw=;
        b=S02nL1hU4YEt50qPyBYSgo7yAha6h5JEeQEE6fRcR7aThKJYhBW3kXMmgf3Sv/kU9+
         r9pcuxJMUfDluyAQRy6PYCYkXqM882+xzwIeWtjMy4sXbG8rAAuw/67NPoHkQklEfcj3
         y+yJzkJaO2TcZUw+bvJTxT0b/UR2IKWUVSBrz4NC28h8ONdnfmo6jGobH/CiS0q5f66Q
         Df2S/Q3WrR37qHsjjPeme8ZwM5/0VtoBNWD5W6h0TzPXPqu1fAIONi3r6ccqP62CegCI
         PAUwU2bmKY3RnR4pcnEkxUgSfFsA8V8lWiR8usnxoSyxnAphcVuoA6BiyoadfKqm1747
         sfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HDVPrh9iJxJQ8bOLJxHZkUXlGRmda9MUCxj388b9fsw=;
        b=PVEXXtJ4w7eBG7BaIIcYe7Lb1HyvTq1BIc0HDQHJ++cjDTW3otrUttsj1zteat5PLq
         QNeGBYL+m8UO/k49akfgBIELm81R6XQZHeeueXf8c7hjLVU3VmpuRaszj30KbTz7kPzV
         xuf6QCmk73t1eV6je7oUfszY7ZpmwBEbYXk0tm2K3qks+5whZV7WVe1Q/625uN9bT/5b
         4341LJ/+3dHiebfitamhFXOY5HjnRiSjvoq9ijOVzF4imaTsarwRl+tUTwnwZig6mnD2
         qGFh0lk33r9e35Cry5ZxtXfIgw0cue0ZO6hCbRCB2YKxXxyoUoJZsDZmlHAwWPVWQjW0
         Az2Q==
X-Gm-Message-State: APjAAAXD4GjLYUj5iaDFBv5a/bl73iVBDZGoBsNjOOHfXjOvqdc1SHfs
        saDNZmF2gptTdQV2OsEpwbXxQw==
X-Google-Smtp-Source: APXvYqxeescu0vp/RpejkdNtDe7G8ulCXCuTHMWEThr/fn4hCdhi8mXCxVduQMsf0Q3ZtPQnKjg98w==
X-Received: by 2002:a92:d642:: with SMTP id x2mr5004490ilp.169.1579902103475;
        Fri, 24 Jan 2020 13:41:43 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v7sm1444336iom.58.2020.01.24.13.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 13:41:43 -0800 (PST)
Subject: Re: [PATCH 5.4 033/222] io_uring: only allow submit from owning task
To:     Stefan Metzmacher <metze@samba.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
References: <20200122092833.339495161@linuxfoundation.org>
 <20200122092835.852416399@linuxfoundation.org>
 <1b4a79c1-6cda-12a8-219b-0c1c146faeff@samba.org>
 <b8fd1a53-8f75-e9cd-9df5-a79541b9fa14@kernel.dk>
 <cc42cd7c-0d22-74e2-5163-17310466f9b1@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <70b6d983-0883-5462-45a4-2305cb92cf88@kernel.dk>
Date:   Fri, 24 Jan 2020 14:41:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cc42cd7c-0d22-74e2-5163-17310466f9b1@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/20 12:11 PM, Stefan Metzmacher wrote:
> Am 24.01.20 um 17:58 schrieb Jens Axboe:
>> On 1/24/20 3:38 AM, Stefan Metzmacher wrote:
>>> Am 22.01.20 um 10:26 schrieb Greg Kroah-Hartman:
>>>> From: Jens Axboe <axboe@kernel.dk>
>>>>
>>>> commit 44d282796f81eb1debc1d7cb53245b4cb3214cb5 upstream.
>>>>
>>>> If the credentials or the mm doesn't match, don't allow the task to
>>>> submit anything on behalf of this ring. The task that owns the ring can
>>>> pass the file descriptor to another task, but we don't want to allow
>>>> that task to submit an SQE that then assumes the ring mm and creds if
>>>> it needs to go async.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Suggested-by: Stefan Metzmacher <metze@samba.org>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>
>>>>
>>>> ---
>>>>  fs/io_uring.c |    6 ++++++
>>>>  1 file changed, 6 insertions(+)
>>>>
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -3716,6 +3716,12 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned
>>>>  			wake_up(&ctx->sqo_wait);
>>>>  		submitted = to_submit;
>>>>  	} else if (to_submit) {
>>>> +		if (current->mm != ctx->sqo_mm ||
>>>> +		    current_cred() != ctx->creds) {
>>>> +			ret = -EPERM;
>>>> +			goto out;
>>>> +		}
>>>> +
>>>
>>> I thought about this a bit more.
>>>
>>> I'm not sure if this is actually to restrictive,
>>> because it means applications like Samba won't
>>> be able to use io-uring at all.
>>>
>>> As even if current_cred() and ctx->creds describe the same
>>> set of uid,gids the != won't ever match again and
>>> makes the whole ring unuseable.
>>>
>>> I'm not sure about what the best short term solution could be...
>>>
>>> 1. May just doing the check for path based operations?
>>>   and fail individual requests with EPERM.
>>>
>>> 2. Or force REQ_F_FORCE_ASYNC for path based operations,
>>>   so that they're always executed from within the workqueue
>>>   with were ctx->creds is active.
>>>
>>> 3. Or (as proposed earlier) do the override_creds/revert_creds dance
>>>   (and similar for mm) if needed.
>>>
>>> To summaries the problem again:
>>>
>>> For path based operations like:
>>> - IORING_OP_CONNECT (maybe also - IORING_OP_ACCEPT???)
>>> - IORING_OP_SEND*, IORING_OP_RECV* on DGRAM sockets
>>> - IORING_OP_OPENAT, IORING_OP_STATX, IORING_OP_OPENAT2
>>> it's important under which current_cred they are called.
>>>
>>> Are IORING_OP_MADVISE, IORING_OP_FADVISE and IORING_OP_FALLOCATE
>>> are only bound to the credentials of the passed fd they operate on?
>>>
>>> The current assumption is that the io_uring_setup() syscall captures
>>> the current_cred() to ctx->cred and all operations on the ring
>>> are executed under the context of ctx->cred.
>>> Therefore all helper threads do the override_creds/revert_creds dance.
>>
>> But it doesn't - we're expecting them to match, and with this change,
>> we assert that it's the case or return -EPERM.
>>
>>> But the possible non-blocking line execution of operations in
>>> the io_uring_enter() syscall doesn't do the override_creds/revert_creds
>>> dance and execute the operations under current_cred().
>>>
>>> This means it's random depending on filled cached under what
>>> credentials an operation is executed.
>>>
>>> In order to prevent security problems the current patch is enough,
>>> but as outlined above it will make io-uring complete unuseable
>>> for applications using any syscall that changes current_cred().
>>>
>>> Change 1. would be a little bit better, but still not really useful.
>>>
>>> I'd actually prefer solution 3. as it's still possible to make
>>> use of non-blocking operations, while the security is the
>>> same as solution 2.
>>
>> For your situation, we need to extend it anyway, and provide a way
>> to swap between personalities. So yeah it won't work as-is for your
>> use case, but we can work on making that the case.
> 
> That's only for the OPENAT2 case, which we might want to use in future,
> but there's a lot of work required to have async opens in Samba.
> 
> But I have a experimental module that, just use READV, WRITEV and FSYNC
> with io-uring in order to avoid our userspace helper threads.
> 
> And that won't work anymore with the change as Samba change
> current_cred() very often switch between (at least) 2 identities
> root and the user. That will change the pointer of current_cred() each time.
> 
> I mean I could work around the check by using IORING_SETUP_SQPOLL,
> but I'd like to avoid that.

It's easy enough to support the current creds from io_uring_enter(),
where we need a bit of plumbing is if we have to go async for that
particular operation. We currently have that static as well, which is
why the current patch is needed.

What I'm trying to say is that'll we'll need code changes to support
this in any case, even just reverting that change isn't going to make
the problem go away for you.

Hence we just need to decide on what the best way to do this would be!

-- 
Jens Axboe


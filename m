Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A921E298549
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 02:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421125AbgJZBW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 21:22:28 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37772 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1421124AbgJZBW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Oct 2020 21:22:28 -0400
Received: by mail-pg1-f194.google.com with SMTP id h6so5175207pgk.4
        for <stable@vger.kernel.org>; Sun, 25 Oct 2020 18:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lg/7cmH9t/EtA8Y3evt0da551l81VTzyMivTHLJCtQ4=;
        b=oGo7XQxQrviQgAmxENev3VKsKVqEtjIMSVvGJNT3/tuYNNE3bbavh4UqWaXlJ+Wkm6
         w7Toomp2wr/GUc8NCWk0WO5vXG/R/jTnAPSWA6CEze2K/0l0o6Ppc0ZPBCKTZewUqL0y
         DycA4hdHwUwcgg57S00nmIgS9nrwB5ZQJzugHIBhGTyUoA/rnB6d2LDa4ry8WMPTxm4a
         aafsDrwwJ4bZl1U3w3Jl38K4FamYJtmYmPlv2y0JcnleE/M8kLZpnxrJyxWKzj6Kh6pM
         /ZJUQI6GlqCZKZ40IXJuFf3efitdiLH6haAbVeydMqEFONBUr+lKUTsWdr8eX02E6ulg
         goLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lg/7cmH9t/EtA8Y3evt0da551l81VTzyMivTHLJCtQ4=;
        b=WXZvjmc1KTE5k0XjTHrUdP5z5Pb4Lq1LHgBGz292FvEgo83kV8hdTS+PP3AxhPSssG
         jxm+F9ecglvHVtGUX6Kw2mW2MmL0AJcmYmMPQNYrs9FzUHW6Nbs7SItXkgAtzv2bubTV
         onw/rhnxOnLvkCCJCMGU+F4xFD8QwUunxwShhKzbeyx+yEkc8oZHZs52nQq5yViL3MBA
         c1ODzB5IGm87owFDfZBenM8guPvRZLXXKBL2hpWbmuwwBKviMjrEXtTkLC8dg5SwrRP5
         KPjcz2zJctLMTMy8cd1AgVwIGELPqe4328lDptAcDZ/8kp1CgiKRjoXxoivREGf7W3A3
         15dw==
X-Gm-Message-State: AOAM533txkMFRUu7bfSam7uR3LvLTw29PfZ+B1T1LiY9vcpqTnyMMnkw
        BPhInqVj5z8w3vcV8HN69zEtuBFr/bJ/eg==
X-Google-Smtp-Source: ABdhPJwkJkIYsQE2mDvyG+b1+iako9UEQ7FwS9GIIV9tqiEGRyUbk1zcHvv7UR1JA0tkrgLs5k89rQ==
X-Received: by 2002:a63:eb4f:: with SMTP id b15mr11752761pgk.127.1603675347275;
        Sun, 25 Oct 2020 18:22:27 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 15sm6127463pfj.179.2020.10.25.18.22.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2020 18:22:26 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix invalid handler for double apoll
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <1bf1093730a68f8939bfd7e6747add7af37ad321.1603635991.git.asml.silence@gmail.com>
 <1ea94ec7-d80a-527b-5366-b91815496f4a@kernel.dk>
 <2022677d-6783-468d-6e77-43208a91edba@gmail.com>
 <83e9fd0e-9136-0ca7-5eb9-01f8da6bd212@kernel.dk>
 <94e07136-2be5-2981-79ae-d4f714803143@gmail.com>
 <a2e5105f-88e3-c6aa-1d91-cfd604a848e7@kernel.dk>
 <923cecfe-6d0e-515f-3237-99884053b7f0@gmail.com>
 <07ce7445-e4bf-b8f0-b666-51730ec1ef80@kernel.dk>
 <7f453b21-f0a2-88c5-a73e-02a9f52b7387@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3699d590-6685-0692-ab50-22a5648d73b8@kernel.dk>
Date:   Sun, 25 Oct 2020 19:22:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7f453b21-f0a2-88c5-a73e-02a9f52b7387@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/20 1:54 PM, Pavel Begunkov wrote:
> On 25/10/2020 19:44, Jens Axboe wrote:
>> On 10/25/20 1:32 PM, Pavel Begunkov wrote:
>>> On 25/10/2020 19:18, Jens Axboe wrote:
>>>> On 10/25/20 1:01 PM, Pavel Begunkov wrote:
>>>>> On 25/10/2020 18:42, Jens Axboe wrote:
>>>>>> On 10/25/20 10:24 AM, Pavel Begunkov wrote:
>>>>>>> On 25/10/2020 15:53, Jens Axboe wrote:
>>>>>>>> On 10/25/20 8:26 AM, Pavel Begunkov wrote:
>>>>>>>>> io_poll_double_wake() is called for both: poll requests and as apoll
>>>>>>>>> (internal poll to make rw and other requests), hence when it calls
>>>>>>>>> __io_async_wake() it should use a right callback depending on the
>>>>>>>>> current poll type.
>>>>>>>>
>>>>>>>> Can we do something like this instead? Untested...
>>>>>>>
>>>>>>> It should work, but looks less comprehensible. Though, it'll need
>>>>>>
>>>>>> Not sure I agree, with a comment it'd be nicer im ho:
>>>>>
>>>>> I don't really care enough to start a bikeshedding, let's get yours
>>>>> tested and merged.
>>>>
>>>> Not really bikeshedding I think, we're not debating names of
>>>> functions :-)
>>>
>>> It's just not so important, and it even may get removed in a month,
>>> who knows.
>>
>> Well it might not or it might take longer, still nice to have the
>> simplest fix...
> 
> Ok, then TLDR: my reasoning is that with poll->wait.func(), a person
> who reads it needs to
> a) go look up what's poll (assigned depending on the opcode),
> b) then find out which wait.func callback it set. And it's not
> as easy to associate __io_arm_poll_handler() call sites with cases
> if you haven't seen this code before.
> c) then go through io_{async,poll}_wake to finally find out that they
> do almost the same thing, that's calling __io_async_wake().
> 
> I'm familiar with the code structure, but IMHO it's harder to
> understand, if I'd be looking for the first time.

I guess we'll just have to agree to disagree on that one. Yes, you'd
have to find where it's assigned to see what happens, which is a
downside. The benefit would be that even if these things change in the
future, the callback func would always be right, so you'd never have to
touch that code again. c) is the same for both.

-- 
Jens Axboe


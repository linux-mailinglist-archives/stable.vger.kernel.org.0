Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762AB29836A
	for <lists+stable@lfdr.de>; Sun, 25 Oct 2020 20:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418610AbgJYTo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 15:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1418608AbgJYTo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Oct 2020 15:44:28 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0B9C061755
        for <stable@vger.kernel.org>; Sun, 25 Oct 2020 12:44:28 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id e7so4922884pfn.12
        for <stable@vger.kernel.org>; Sun, 25 Oct 2020 12:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vmJ9GPaXK5vaftAxJ3iiQ2AzHKA2knlnsf84Niun6Ps=;
        b=MgXyAmeDlQTFeEHGsW7AuBsZbjbBujOL7SQZIH7/xwpeC1qYv5qmYrW3Q5Ot5xXkdP
         50GtMDfnfp6N0ZMB+E6g9K2ThsuYPX8Zwux34mhyOmJLpY8phuLG2tBSG5q8yZCx4m4d
         6vUoL6rGUnzUrmBIbnv7NDs7cGANmIfNvYRncW41qh+nZeC5DvZCt0yI7C9Zc/DIKCfF
         2IxDJWcWeXJ3YX2Pnd5ODoLVW6M4yQCAU7TPyRsMGS7/FoPT5HdMSWhDqsTZzB3wo6kR
         fTTCyrfcM3GWGFKrez8hnedROTf0zmQiwZnDW7PnSXNkIwe9tciuY2wznam1aB+nXGpB
         yrLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vmJ9GPaXK5vaftAxJ3iiQ2AzHKA2knlnsf84Niun6Ps=;
        b=PRSCU9GUBU3D90CMhGrkX4P62jk79L61bo+IIK1BCLSqjj2VPYV7uvNNEhoBvoC6aO
         pB+bdnUvCVvdNs2k/SSs1pjg9Pip7yUEiY9/94SIIGIhmnJBmS7mIWmzQQ1Y70pVWgDY
         1pJY/vJekIF8xvPfy4kHOkikzB4oC1+hOg5hDn0Bd6vvleieEigcscYTYjt0V8IApcRG
         vIM9W2Sd0KVNRtiDZvUv+J8uSRWrnbjMdOs6XCyOoTvA6iOYkpYSdK7b2Ipvh+1oYZWd
         hfXYdrrZ6V3jg99zkpcq6oA3f6KoIAJpxC0iwvjyovPr/cfbwdu5+ULu65LjLYLlIjFP
         6VWA==
X-Gm-Message-State: AOAM5300z9wOu0zgKfJcweRpVrWy3X16pVzao/MR32dsdtXR9806LJcW
        RRNMfnFg9SmLAWpc6F+cr9wfzMHE3XOf5g==
X-Google-Smtp-Source: ABdhPJzd401/P+uvp+guAaSWZpTXz/jVcm47kXGQtaYcKvEYMdvix+HFPsxYQFX1l8Q1Sw4KAApk8g==
X-Received: by 2002:aa7:9486:0:b029:160:b820:4856 with SMTP id z6-20020aa794860000b0290160b8204856mr6109974pfk.14.1603655067268;
        Sun, 25 Oct 2020 12:44:27 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e7sm8796909pgj.19.2020.10.25.12.44.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2020 12:44:26 -0700 (PDT)
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <07ce7445-e4bf-b8f0-b666-51730ec1ef80@kernel.dk>
Date:   Sun, 25 Oct 2020 13:44:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <923cecfe-6d0e-515f-3237-99884053b7f0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/20 1:32 PM, Pavel Begunkov wrote:
> On 25/10/2020 19:18, Jens Axboe wrote:
>> On 10/25/20 1:01 PM, Pavel Begunkov wrote:
>>> On 25/10/2020 18:42, Jens Axboe wrote:
>>>> On 10/25/20 10:24 AM, Pavel Begunkov wrote:
>>>>> On 25/10/2020 15:53, Jens Axboe wrote:
>>>>>> On 10/25/20 8:26 AM, Pavel Begunkov wrote:
>>>>>>> io_poll_double_wake() is called for both: poll requests and as apoll
>>>>>>> (internal poll to make rw and other requests), hence when it calls
>>>>>>> __io_async_wake() it should use a right callback depending on the
>>>>>>> current poll type.
>>>>>>
>>>>>> Can we do something like this instead? Untested...
>>>>>
>>>>> It should work, but looks less comprehensible. Though, it'll need
>>>>
>>>> Not sure I agree, with a comment it'd be nicer im ho:
>>>
>>> I don't really care enough to start a bikeshedding, let's get yours
>>> tested and merged.
>>
>> Not really bikeshedding I think, we're not debating names of
>> functions :-)
> 
> It's just not so important, and it even may get removed in a month,
> who knows.

Well it might not or it might take longer, still nice to have the
simplest fix...

>> My approach would need conditional clearing of ->private as well,
>> as far as I can tell. I'll give it a spin.
> 
> Maybe
> 
> - poll->wait.func(wait, mode, sync, key);
> + poll->wait.func(&poll->wait, mode, sync, key);

Ah yeah, that looks better.

-- 
Jens Axboe


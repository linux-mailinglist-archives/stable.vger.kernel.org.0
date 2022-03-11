Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6034D56CB
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 01:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbiCKAhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 19:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiCKAhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 19:37:48 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2530B1A1295
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 16:36:46 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id b8so6742490pjb.4
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 16:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QO2AOSdbHlirGRsew57XG+cWDo7ps1WnIH6tM2WM5rQ=;
        b=pCn3Qj7egqSlPRMxmJKDflDq9gFcqfSTjvuD9JhwT8vSfu5tswCG/E+cvtp1LwpXWZ
         Rd/EJFZtpoMoHE1/59MiWy8WySvcroYbHVqBDZb1P8Qijin+4SpMztNhBZ0nhN1Jf9kW
         c1yNpGxjE8qr+B5IfZvypdFdsKDQPva7t++dfOtd+UWMycKpW3A6fjyZYBPPARQeF5NC
         Kv8Xgu9yg5vb/JKM2iau5/joepL5IAAP2AtIiIF24BGsVNRH1+icFsDbD+cjTXLpxkF1
         6NHRTWBDmCIzuH6/mbsklfgTY8z4PoqaY7kHCxQOLGE8bi7Tv7yEy0N1KkGNYGD1NGYG
         pN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QO2AOSdbHlirGRsew57XG+cWDo7ps1WnIH6tM2WM5rQ=;
        b=RDmau16CWcdwmqPJBOdpgNRy3EwfO954F/h2BNRKkjSo+1fjIaocIHKmUBD3b66wPh
         NQiPFO4R/PrT3PJQZmdEPmWYn9xLMEvMLbz45jcg7epA6wofFyG5V5aIfLPt88TOtf+6
         IfhA8NsAXLslrckL4dphBFUFLIsAk0UOwo3GPp5aujIE+49C5F3LJ/6vTRd5J+iCSyr0
         GDe002jPGVGl5tfORLQV9XGzPwncOwlgKdg3oVzsFOGnWTA4hDKPsFJJdn4+8isaXlS5
         cocGLGBQOM//f4Zv4y6LtO+Y/xKWZvqqKGGjHWnsbqkxa0I6XSkIEcWCIN6dyE0vI8f7
         eqmQ==
X-Gm-Message-State: AOAM531lsl25mDwL3vL+dYjeMpjPENjGEiY0F7fJUCb8jIi4JikbomEF
        K8bBiM0b98xptCB6/ZMYkN8bNN37puBHVdG4
X-Google-Smtp-Source: ABdhPJwe7QGV/ICE+7pGJFJRqtebkw9gRMyN7W/d94y/T2pr4cVfCP+7gL+MuFjBCOLzqLa3cnE5uA==
X-Received: by 2002:a17:903:1d1:b0:153:1e35:5a7c with SMTP id e17-20020a17090301d100b001531e355a7cmr6074492plh.0.1646959005520;
        Thu, 10 Mar 2022 16:36:45 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x15-20020a056a00188f00b004f7675962d5sm5485440pfh.175.2022.03.10.16.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 16:36:45 -0800 (PST)
Message-ID: <40ae10bd-6839-2246-c2d7-aa11e671d7d4@kernel.dk>
Date:   Thu, 10 Mar 2022 17:36:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Content-Language: en-US
To:     Song Liu <song@kernel.org>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, stable@vger.kernel.org,
        Larkin Lowrey <llowrey@nuclearwinter.com>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
References: <20220309064209.4169303-1-song@kernel.org>
 <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
 <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk>
 <CAPhsuW7zdYZqxaJ7SOWdnVOx-cASSoXS4OwtWVbms_jOHNh=Kw@mail.gmail.com>
 <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk>
 <CAPhsuW6ueGM_DZuAWvMbaB4PNftA5_MaqzMiY8_Bz7Bqy-ahZA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAPhsuW6ueGM_DZuAWvMbaB4PNftA5_MaqzMiY8_Bz7Bqy-ahZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/22 5:31 PM, Song Liu wrote:
> On Thu, Mar 10, 2022 at 4:07 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/10/22 4:33 PM, Song Liu wrote:
>>> On Thu, Mar 10, 2022 at 3:02 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 3/10/22 3:37 PM, Song Liu wrote:
>>>>> On Thu, Mar 10, 2022 at 2:15 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>> On 3/8/22 11:42 PM, Song Liu wrote:
>>>>>>> RAID arrays check/repair operations benefit a lot from merging requests.
>>>>>>> If we only check the previous entry for merge attempt, many merge will be
>>>>>>> missed. As a result, significant regression is observed for RAID check
>>>>>>> and repair.
>>>>>>>
>>>>>>> Fix this by checking more than just the previous entry when
>>>>>>> plug->multiple_queues == true.
>>>>>>>
>>>>>>> This improves the check/repair speed of a 20-HDD raid6 from 19 MB/s to
>>>>>>> 103 MB/s.
>>>>>>
>>>>>> Do the underlying disks not have an IO scheduler attached? Curious why
>>>>>> the merges aren't being done there, would be trivial when the list is
>>>>>> flushed out. Because if the perf difference is that big, then other
>>>>>> workloads would be suffering they are that sensitive to being within a
>>>>>> plug worth of IO.
>>>>>
>>>>> The disks have mq-deadline by default. I also tried kyber, the result
>>>>> is the same. Raid repair work sends IOs to all the HDDs in a
>>>>> round-robin manner. If we only check the previous request, there isn't
>>>>> much opportunity for merge. I guess other workloads may have different
>>>>> behavior?
>>>>
>>>> Round robin one at the time? I feel like there's something odd or
>>>> suboptimal with the raid rebuild, if it's that sensitive to plug
>>>> merging.
>>>
>>> It is not one request at a time, but more like (for raid456):
>>>    read 4kB from HDD1, HDD2, HDD3...,
>>>    then read another 4kB from HDD1, HDD2, HDD3, ...
>>
>> Ehm, that very much looks like one-at-the-time from each drive, which is
>> pretty much the worst way to do it :-)
>>
>> Is there a reason for that? Why isn't it using 64k chunks or something
>> like that? You could still do that as a kind of read-ahead, even if
>> you're still processing in chunks of 4k.
> 
> raid456 handles logic in the granularity of stripe. Each stripe is 4kB from
> every HDD in the array. AFAICT, we need some non-trivial change to
> enable the read ahead.

Right, you'd need to stick some sort of caching in between so instead of
reading 4k directly, you ask the cache for 4k and that can manage
read-ahead.

>>>> Plug merging is mainly meant to reduce the overhead of merging,
>>>> complement what the scheduler would do. If there's a big drop in
>>>> performance just by not getting as efficient merging on the plug side,
>>>> that points to an issue with something else.
>>>
>>> We introduced blk_plug_max_rq_count() to give md more opportunities to
>>> merge at plug side, so I guess the behavior has been like this for a
>>> long time. I will take a look at the scheduler side and see whether we
>>> can just merge later, but I am not very optimistic about it.
>>
>> Yeah I remember, and that also kind of felt like a work-around for some
>> underlying issue. Maybe there's something about how the IO is issued
>> that makes it go straight to disk and we never get any merging? Is it
>> because they are sync reads?
>>
>> In any case, just doing larger reads would likely help quite a bit, but
>> would still be nice to get to the bottom of why we're not seeing the
>> level of merging we expect.
> 
> Let me look more into this. Maybe we messed something up in the
> scheduler.

I'm assuming you have a plug setup for doing the reads, which is why you
see the big difference (or there would be none). But
blk_mq_flush_plug_list() should really take care of this when the plug
is flushed, requests should be merged at that point. And from your
description, doesn't sound like they are at all.

-- 
Jens Axboe


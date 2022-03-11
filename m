Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842884D574B
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 02:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245648AbiCKBWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 20:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240140AbiCKBWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 20:22:38 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363DBE3C67
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 17:21:36 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id lj8-20020a17090b344800b001bfaa46bca3so6646787pjb.2
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 17:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4YP7HX7B+792VQ/8nZaHNfysWT0zA6R0F1BtN8rB0Jk=;
        b=xONIYRWCdCXoQajGzdvwfnpLO/HaxwgV8e4qPGnR770moMOBRO6MdHuf7BPXcYlgOG
         F9jDeBpp5XFFUFDOKiUqlitFmxBxxyat7+878II7UK+e3eBJwZbz7bhu7D0YojCMmJHQ
         k96wH8S6rBTioJs+2OMf3jhDoPKZ7HwN8MMsmYBhci+xG5HxA5NlH1HM4uRBSea3l4py
         Snz0X20t9fs0AbfsgUVggzUY2TfsNolVTU7tjZOkJtftd6mjzNw5foKE0mwk/JFAphIE
         VGNGxpAWMU1Cy+WR30XzzpWxGkkoa2Y4DYGJyZbrYRvcHhiUYq3M0oXq1KmdpWFd0X2J
         jaqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4YP7HX7B+792VQ/8nZaHNfysWT0zA6R0F1BtN8rB0Jk=;
        b=5izw/sTmAdsvZsAN+LZfTd1ptqg8/S+5tI4M4f3vDV0wH86Vdqau/6FUPAD9YzAIu8
         QBvRnorOrCGxG9Gbs8o/JpC6OSTesMr35tmFCv7B9nlNntaS7ISAgTpxtyiG0IodiPYP
         Sgvt+llnlwbMdpi3agGFz2jpGgR7XJ9SXJSdjA/YT4t0vhzIubkWrM0fBRsX/KOJB8YV
         2jzv4/mGnX+vkawVFxVFj9yADkeYLTkQ55Wb6+6cRcP0TiEIsZGhV0+Xb3gnle/XweZa
         7Hr8nAjnUZENcgsLyhi6JJKiEIa3Ykt3jZdkv+/9fmKK7BlnfWomzUFzRGoe90XHGSVh
         CSlA==
X-Gm-Message-State: AOAM533mRgIVcjtC/b4HPjmEhMPVKK7EuWQL1yCbjKuRNc25mIIgcYBs
        9KeJ16YGZgsSHT+P7VtR1AluLQ==
X-Google-Smtp-Source: ABdhPJx2fbVn8xFbkCA40lCIMlcyKTuPdrVYI7ZYotiXQRB1ueDYCowdVRkm7+0HIkYQdaUHWZV2IQ==
X-Received: by 2002:a17:90a:6393:b0:1bf:70e7:27d2 with SMTP id f19-20020a17090a639300b001bf70e727d2mr19005803pjj.1.1646961695644;
        Thu, 10 Mar 2022 17:21:35 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m4-20020a17090a7f8400b001bef3fc3938sm7039901pjl.49.2022.03.10.17.21.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 17:21:35 -0800 (PST)
Message-ID: <0d7bb070-11a3-74b1-22d5-86001818018b@kernel.dk>
Date:   Thu, 10 Mar 2022 18:21:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Song Liu <song@kernel.org>, linux-block@vger.kernel.org,
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
 <40ae10bd-6839-2246-c2d7-aa11e671d7d4@kernel.dk> <Yiqijd9S6Y92DnBu@T590>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Yiqijd9S6Y92DnBu@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/22 6:14 PM, Ming Lei wrote:
> On Thu, Mar 10, 2022 at 05:36:44PM -0700, Jens Axboe wrote:
>> On 3/10/22 5:31 PM, Song Liu wrote:
>>> On Thu, Mar 10, 2022 at 4:07 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 3/10/22 4:33 PM, Song Liu wrote:
>>>>> On Thu, Mar 10, 2022 at 3:02 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>> On 3/10/22 3:37 PM, Song Liu wrote:
>>>>>>> On Thu, Mar 10, 2022 at 2:15 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>
>>>>>>>> On 3/8/22 11:42 PM, Song Liu wrote:
>>>>>>>>> RAID arrays check/repair operations benefit a lot from merging requests.
>>>>>>>>> If we only check the previous entry for merge attempt, many merge will be
>>>>>>>>> missed. As a result, significant regression is observed for RAID check
>>>>>>>>> and repair.
>>>>>>>>>
>>>>>>>>> Fix this by checking more than just the previous entry when
>>>>>>>>> plug->multiple_queues == true.
>>>>>>>>>
>>>>>>>>> This improves the check/repair speed of a 20-HDD raid6 from 19 MB/s to
>>>>>>>>> 103 MB/s.
>>>>>>>>
>>>>>>>> Do the underlying disks not have an IO scheduler attached? Curious why
>>>>>>>> the merges aren't being done there, would be trivial when the list is
>>>>>>>> flushed out. Because if the perf difference is that big, then other
>>>>>>>> workloads would be suffering they are that sensitive to being within a
>>>>>>>> plug worth of IO.
>>>>>>>
>>>>>>> The disks have mq-deadline by default. I also tried kyber, the result
>>>>>>> is the same. Raid repair work sends IOs to all the HDDs in a
>>>>>>> round-robin manner. If we only check the previous request, there isn't
>>>>>>> much opportunity for merge. I guess other workloads may have different
>>>>>>> behavior?
>>>>>>
>>>>>> Round robin one at the time? I feel like there's something odd or
>>>>>> suboptimal with the raid rebuild, if it's that sensitive to plug
>>>>>> merging.
>>>>>
>>>>> It is not one request at a time, but more like (for raid456):
>>>>>    read 4kB from HDD1, HDD2, HDD3...,
>>>>>    then read another 4kB from HDD1, HDD2, HDD3, ...
>>>>
>>>> Ehm, that very much looks like one-at-the-time from each drive, which is
>>>> pretty much the worst way to do it :-)
>>>>
>>>> Is there a reason for that? Why isn't it using 64k chunks or something
>>>> like that? You could still do that as a kind of read-ahead, even if
>>>> you're still processing in chunks of 4k.
>>>
>>> raid456 handles logic in the granularity of stripe. Each stripe is 4kB from
>>> every HDD in the array. AFAICT, we need some non-trivial change to
>>> enable the read ahead.
>>
>> Right, you'd need to stick some sort of caching in between so instead of
>> reading 4k directly, you ask the cache for 4k and that can manage
>> read-ahead.
>>
>>>>>> Plug merging is mainly meant to reduce the overhead of merging,
>>>>>> complement what the scheduler would do. If there's a big drop in
>>>>>> performance just by not getting as efficient merging on the plug side,
>>>>>> that points to an issue with something else.
>>>>>
>>>>> We introduced blk_plug_max_rq_count() to give md more opportunities to
>>>>> merge at plug side, so I guess the behavior has been like this for a
>>>>> long time. I will take a look at the scheduler side and see whether we
>>>>> can just merge later, but I am not very optimistic about it.
>>>>
>>>> Yeah I remember, and that also kind of felt like a work-around for some
>>>> underlying issue. Maybe there's something about how the IO is issued
>>>> that makes it go straight to disk and we never get any merging? Is it
>>>> because they are sync reads?
>>>>
>>>> In any case, just doing larger reads would likely help quite a bit, but
>>>> would still be nice to get to the bottom of why we're not seeing the
>>>> level of merging we expect.
>>>
>>> Let me look more into this. Maybe we messed something up in the
>>> scheduler.
>>
>> I'm assuming you have a plug setup for doing the reads, which is why you
>> see the big difference (or there would be none). But
>> blk_mq_flush_plug_list() should really take care of this when the plug
>> is flushed, requests should be merged at that point. And from your
>> description, doesn't sound like they are at all.
> 
> requests are shared, when running out of request, plug list will be
> flushed early.

That is true, but I don't think that's the problem here with the round
robin approach. Seems like it'd drive a pretty low queue depth, even
considering SATA.

> Maybe we can just put bios into plug list directly, then handle them
> all in blk_mq_flush_plug_list.

That might not be a bad idea regardless. And should be trivial now, with
the plug list being singly linked anyway.

-- 
Jens Axboe


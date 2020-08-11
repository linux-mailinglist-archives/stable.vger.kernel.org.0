Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D868241C20
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 16:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgHKOM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 10:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728491AbgHKOM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 10:12:27 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82CCC06174A
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 07:12:27 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mw10so1942754pjb.2
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 07:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OOlZ+ATYXp0embk0Xt0D7/zojHK+eypmET3/SJQqP3Q=;
        b=sY4W60GQgss5PGDlEi0PP5sQjeZSO3iLmw8XGvV1kJUYz2oJe5Hz5Yr2NHhY9Nzgqv
         OljIi/qatKO7Wwa83fSKC+uSZXzkEHHyA/qjY/IHRInj2tQZVvysxtIbO1ohvpR3UB8C
         6xM3TiQHp1rI55Kw5YfEWrXoDgrODPfZi6VjT9qU3+ytjKqqPbJooOGYiNzb/PeKTmZu
         NPl1rbFBj1UbDJZUdJrRObyKeWJbHVpztJimro6g2KzDOzTPC5tMhtieN6U7a17ZxEkF
         I10ceLErgH0vqWjlIzV+gzRKn9LgQTSn3sSYhPucrkn+sBMtGeB+zTq5V3QEvpG2LcyH
         Y9Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OOlZ+ATYXp0embk0Xt0D7/zojHK+eypmET3/SJQqP3Q=;
        b=HW9+rOpk5zk3nq/H7mM2plkxReDUlYarVNwkxb5agpoopmX8dTo4yTvx7jpn2+k5aF
         ulB7XPPu6JV7EN5qc/KMTmyx7vXuuHVltOtUqmGcGKumOwOtY9Lq8owuWwbDuYuijsHy
         Oi87aJyTkQ428575OQ6cM6VIq95Sa3M9AADnU4YP1Rk0G7TPdf7sDsmUNrA4ji2DEqeZ
         V3N2YI30Jvl/qi2HhCZjKZqXI+DfGJpTZLyE4EYzriFgPLcZq3vBTC0Yy7EwbTQzMdcr
         hoRox4PVIhe4tppYiok5QmPLp2KfsNygxV+RQ0JeN/zvIDlsIOaIHKECSaE9qSfx9Kj/
         Z7LQ==
X-Gm-Message-State: AOAM530uNHcRQQF7Va9/NcgSmzztN/STCtQSIXR5kPbE3nxyqwSwzXbO
        DJRZqNSej5iJbGgNJjVNHcPo94Hj+RE=
X-Google-Smtp-Source: ABdhPJxxjtY+Kp4EiPt+PSXYh8asEW33CoEBH2K4kvELJ2y3apqudwX2y0SeNMSQkeA1CMpoyt7T8A==
X-Received: by 2002:a17:90b:784:: with SMTP id l4mr1191498pjz.96.1597155147453;
        Tue, 11 Aug 2020 07:12:27 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id lk16sm2860632pjb.13.2020.08.11.07.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 07:12:26 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jann Horn <jannh@google.com>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>
References: <CAG48ez2dEyxe_ioQaDC3JTdSyLsdOiFKZvk6LGP00ELSfSvhvg@mail.gmail.com>
 <1629f8a9-cee0-75f1-810a-af32968c4055@kernel.dk>
 <dfc3bf88-39a3-bd38-b7b6-5435262013d5@kernel.dk>
 <CAG48ez2EzOpWZbhnuBxVBXjRbLZULJJeeTBsdbL6Hzh9-1YYhA@mail.gmail.com>
 <20200811064516.GA21797@redhat.com>
 <20200811065659.GQ3982@worktop.programming.kicks-ass.net>
 <20200811071401.GB21797@redhat.com>
 <20200811074538.GS3982@worktop.programming.kicks-ass.net>
 <20200811081033.GD21797@redhat.com>
 <efc48e5e-d4fc-bbaf-467c-24210eb77d9b@kernel.dk>
 <20200811140525.GE21797@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0790382f-46d0-0520-443a-cbedb37900f8@kernel.dk>
Date:   Tue, 11 Aug 2020 08:12:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200811140525.GE21797@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/11/20 8:05 AM, Oleg Nesterov wrote:
> On 08/11, Jens Axboe wrote:
>>
>> I'd really like to get this done at the same time as the io_uring
>> change. Are you open to doing the READ_ONCE() based JOBCTL_TASK_WORK
>> addition for 5.9?
> 
> Yes, the patch looks fine to me. In fact I was going to add this
> optimization from the very beginning, but then decided to make that
> patch as simple as possible.

OK great, I'll send that out separately.

> And in any case I personally like this change much more than 1/2 +
> 2/2 which I honestly don't understand ;)

Yes, in retrospect, me too :-)

-- 
Jens Axboe


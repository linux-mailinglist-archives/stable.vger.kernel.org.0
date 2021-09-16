Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630EB40ED60
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 00:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240671AbhIPWdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 18:33:41 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50640 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240613AbhIPWdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 18:33:40 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1631831538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DT+9pVxDdkzVajA69BUNZ64MrcJ23eaOZGo/IfmeHxU=;
        b=iqzNPQls+JtFXwLkJqm8voGlsofPMJce9A2mnjKb5sA+9TN+u0x2zHMLsmneu2Yj2FfOo/
        5NPEwShS/yOmclGt5uOmcUpyHmYX+WkLW8nsVjajUiqTwbkRfc4OtGR0JaUMLhdC+7Mr+n
        hsEiVSdugNVSOIPcOPShPqBFozDPKZ7sPj4xI4YKIsz4j+u9REJU+EtOS8YUWLYCw0D+uD
        RWqjODz7cSb9/g0wj6FefQXBrOFs/D8ZKJHUhl8oT1aFA/fxGViFic1PhWoez6G7i7GHdM
        J4qdsSATFhc2rUV5/QtPmaWVo3hiuvOyuXMNjWlTE5uyObKREMl756bT7j6G6A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1631831538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DT+9pVxDdkzVajA69BUNZ64MrcJ23eaOZGo/IfmeHxU=;
        b=X21Tc/gKbpt6oYyQC/HQ7oMy/sxDmBaqYHFgwpmhX7fGdAzSChXPir3luUiWn9TKgPxXYW
        Gb2dHl53yDqj8zAQ==
To:     Arnd Bergmann <arnd@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>
Subject: Re: [PATCH 5.14 298/334] time: Handle negative seconds correctly in
 timespec64_to_ns()
In-Reply-To: <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com>
References: <20210913131113.390368911@linuxfoundation.org>
 <20210913131123.500712780@linuxfoundation.org>
 <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com>
Date:   Fri, 17 Sep 2021 00:32:17 +0200
Message-ID: <874kak9moe.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Arnd,

On Wed, Sep 15 2021 at 21:00, Arnd Bergmann wrote:
> On Tue, Sep 14, 2021 at 1:22 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>  /*
>>   * Limits for settimeofday():
>> @@ -124,10 +126,13 @@ static inline bool timespec64_valid_sett
>>   */
>>  static inline s64 timespec64_to_ns(const struct timespec64 *ts)
>>  {
>> -       /* Prevent multiplication overflow */
>> -       if ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX)
>> +       /* Prevent multiplication overflow / underflow */
>> +       if (ts->tv_sec >= KTIME_SEC_MAX)
>>                 return KTIME_MAX;
>>
>> +       if (ts->tv_sec <= KTIME_SEC_MIN)
>> +               return KTIME_MIN;
>> +
>
> I just saw this get merged for the stable kernels, and had not seen this when
> Thomas originally merged it.
>
> I can see how this helps the ptp_clock_adjtime() users, but I just
> double-checked
> what other callers exist, and I think it introduces a regression in setitimer(),
> which does
>
>         nval = timespec64_to_ns(&value->it_value);
>         ninterval = timespec64_to_ns(&value->it_interval);
>
> without any further range checking that I could find. Setting timers
> with negative intervals sounds like a bad idea, and interpreting negative
> it_value as a past time instead of KTIME_SEC_MAX sounds like an
> unintended interface change.
>
> I haven't done any proper analysis of the changes, so maybe it's all
> good, but I think we need to double-check this, and possibly revert
> it from the stable kernels until a final conclusion.

I have done the analysis. setitimer() does not have any problem with
that simply because it already checks at the call site that the seconds
value is > 0 and so do all the other user visible interfaces. See
get_itimerval() ...

Granted  that the kernel internal interfaces do not have those checks,
but they already have other safety nets in place to prevent this and I
could not identify any callsite which has trouble with that change.

If I failed to spot one then what the heck is the problem? It was broken
before that change already!

I usually spend quite some time on tagging patches for stable and it's
annoying me that this patch got reverted while stuff which I explicitely
did not tag for stable got backported for whatever reason and completely
against the stable rules:

  627ef5ae2df8 ("hrtimer: Avoid double reprogramming in __hrtimer_start_range_ns()")

What the heck qualifies this to be backported?

 1) It's hot of the press and just got merged in the 5.15-rc1 merge
    window and is not tagged for stable

 2) https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

    clearly states the rules but obviously our new fangled "AI" driven
    approach to select patches for stable is blissfully ignorant of
    these rules. I assume that AI stands for "Artifical Ignorance' here.

I already got a private bug report vs. that on 5.10.65. Annoyingly
5.10.5 does not have the issue despite the fact that the resulting diff
between those two versions in hrtimer.c is just in comments.

Bah!

Thanks,

        tglx




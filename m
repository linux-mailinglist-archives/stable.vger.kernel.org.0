Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D9245614F
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 18:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhKRRUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 12:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbhKRRUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 12:20:08 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E221C06173E
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 09:17:08 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id h24so5670867pjq.2
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 09:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AdNT/e8pWXEGx8y2cLNzuIqObGx1yOxX/rki3SqI27w=;
        b=MzTqRS09IIUcxWl66e1N7K7IoW9LHDC2F49Jzm7N7j1I2b0puAw8fiVyiEVrEuWvnf
         9tDhXaxNBb6fRjmFnxmmjF0rB1qECOcxQFw9jwxVEEF1zCXpIpg1HdzSywathMEU6O06
         mOzoAzahrTv+Vfrb6K7uqj27+8J9baKgZuirI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AdNT/e8pWXEGx8y2cLNzuIqObGx1yOxX/rki3SqI27w=;
        b=foXrhKnc5NTfMpJnUGt2rMORjjvKqSWZBb9wwjLq1tnoRX9llhITsjEsxpl2+bv9Nb
         kK9ttL6CGFfW/msM9cAGA8QJt00oQFxhgWspShRMyeu3vTBxZ6tzJpmtPfKhCRZd5aYM
         LGGVF3Uf2XFbimBHxWZRK1DeZ6IazyWKBpg6brCq56mRbrFqBit4ltnud3T4O2V3jqdz
         hcmfMB8jG+0HVRqPtUchSn0lEBwRoOGEzq7zGgs1/JPZAVauqqwY4Ut5v+T+GkOm0B86
         r4fw6raIOamJVgu0uUNpkkkMOelmk5Oy6+J02vFibp8/XvLhvhiDM0rLCBa3iZcmwkcP
         FonQ==
X-Gm-Message-State: AOAM531qhd5KGPGuivtyXWebZT3ni/kcYHqiJjHF/mE+odmpTaTztKUV
        c+1sMHpraJaH2b2ySWuM3Gk+Rw==
X-Google-Smtp-Source: ABdhPJxv5htguG5dAaQZenD+5ssUM5X/WV7alFh5ZEYdsEe8SMjBS2O4lsEoq9SmDTw7delwgAsoiA==
X-Received: by 2002:a17:90a:1a55:: with SMTP id 21mr11950889pjl.240.1637255825349;
        Thu, 18 Nov 2021 09:17:05 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o7sm195449pgq.59.2021.11.18.09.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 09:17:04 -0800 (PST)
Date:   Thu, 18 Nov 2021 09:17:04 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@vger.kernel.org>,
        Wang Yugui <wangyugui@e16-tech.com>,
        =?iso-8859-1?Q?Fran=E7ois?= Guerraz <kubrick@fgv6.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
Message-ID: <202111180912.356B342@keescook>
References: <20211117101657.463560063@linuxfoundation.org>
 <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <202111171609.56F12BD@keescook>
 <YZYLC9D6zpUneYtn@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZYLC9D6zpUneYtn@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 09:12:59AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Nov 17, 2021 at 04:16:51PM -0800, Kees Cook wrote:
> > On Wed, Nov 17, 2021 at 03:50:17PM -0800, Linus Torvalds wrote:
> > > Sorry for top-posting and quoting this all, but the actual people
> > > involved with the wchan changes don't seem to be on the participant
> > > list.
> > 
> > Adding more folks from a private report and
> > https://bugzilla.kernel.org/show_bug.cgi?id=215031
> > 
> > and for the new people, here's a lore link for this thread:
> > https://lore.kernel.org/stable/YZV02RCRVHIa144u@fedora64.linuxtx.org/
> > 
> > 
> > FWIW, earlier bisection pointed to the stable backport of
> > 5d1ceb3969b6b2e47e2df6d17790a7c5a20fcbb4 being the primary culprit.
> > At first glance it seems to me that the problem with -stable is that an
> > unvetted subset of the wchan refactoring series landed in -stable.
> 
> What would be the vetted subset?  :)

The ones with "Cc: stable" ;)

> Anyway, I have now dropped the following patches that were in the
> 5.15.3-rc tree:
> 	bc9bbb81730e ("x86: Fix get_wchan() to support the ORC unwinder")
> 	42a20f86dc19 ("sched: Add wrapper for get_wchan() to keep task blocked")
> 	5d1ceb3969b6 ("x86: Fix __get_wchan() for !STACKTRACE")
> 
> And will push out another -rc release to let people test.
> 
> If there are any other commits I should have also dropped, please let me
> know.

That looks right to me. These three were part of Peter's much larger
wchan refactoring (of which 42a20f86dc19 was a core part).

Thanks!

-- 
Kees Cook

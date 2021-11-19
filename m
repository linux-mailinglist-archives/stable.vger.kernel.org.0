Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F2545767F
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 19:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbhKSSiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 13:38:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52505 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235196AbhKSSix (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 13:38:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637346950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HgWP6xNa+jpQwS6DkS1zn+lf6uHsgWR6k/PugODvNqA=;
        b=aAHDGREJzsFGbAqYnlc0jlEwQ4o7nxBsC8d+impW2K1Jf1Tj5LjXSs3hNEi48h2+M4XF4x
        peaAPxOcVnV23yhQHKsPnl1gqdsSgs5aEiwXHUmQtFF2s5FPVTfBXYM5QzqUrVS6Whtv2f
        tnbX0uTN5QXEtOVljmVCmCRA1ohJTZI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-188-chWqiy1ZN6Kwuwi2jMls9Q-1; Fri, 19 Nov 2021 13:35:49 -0500
X-MC-Unique: chWqiy1ZN6Kwuwi2jMls9Q-1
Received: by mail-qv1-f69.google.com with SMTP id kk1-20020a056214508100b003a9d1b987caso9732064qvb.4
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 10:35:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HgWP6xNa+jpQwS6DkS1zn+lf6uHsgWR6k/PugODvNqA=;
        b=E7D/nfYOaP0eXo8/EcvSuMgtK5gjg9RDqRXiETEZiOLyR9urSpkmgc1i5IEm3atHwL
         RV+i7HMsxUPDvIYjCF0hIRw3t2bEfgYTWg7zWF0uKbOvNWbny/XJvu3EpEzY3ELX8l2f
         yT8cpuh6e/KmfFgVkV9OHJxGNIs3s763QsvnZxeA9l6cJv0jiBY3XLxyWaL19koZ51kZ
         8dWzDdEhWh8jAR6FuKxd/rjkFU7ptt0UiplxYa2sq7qohq8OR99zfUCkU9sPYd1xzFey
         znYZcrsaPYkGht1vQllyBe/5UexmYt1SkAaGag2KLq+7SSlf0U98ixqXx/WUYFun9CUg
         nSvA==
X-Gm-Message-State: AOAM530QYZtSLJCUYMWK5ZSZewKkVHB5lnZ/8NeXGY3YeojorQi69iKq
        IPXFWny5iKshrZ9B5qNvNY+Q0r12g+FetZ34xgg7YAXr19EQS1I0zoWHbaSwTnWleWgpKTTRNZL
        mT1L03xwZa51O7vp3
X-Received: by 2002:a05:6214:2a8b:: with SMTP id jr11mr75820799qvb.19.1637346948945;
        Fri, 19 Nov 2021 10:35:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxjEgRwHrPBoLnCBZW6+Lj1tMIFlecHbiuJPj8EtAzjeBf5w4PMRBUWYgLB68yXc97jPRjXTQ==
X-Received: by 2002:a05:6214:2a8b:: with SMTP id jr11mr75820748qvb.19.1637346948672;
        Fri, 19 Nov 2021 10:35:48 -0800 (PST)
Received: from treble ([2600:1700:6e32:6c00::35])
        by smtp.gmail.com with ESMTPSA id q20sm259237qkl.53.2021.11.19.10.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 10:35:48 -0800 (PST)
Date:   Fri, 19 Nov 2021 10:35:44 -0800
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Holger Hoffst??tte <holger@applied-asynchrony.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] x86: Pin task-stack in __get_wchan()
Message-ID: <20211119183544.sragh42cn2liu3pw@treble>
References: <20211117101657.463560063@linuxfoundation.org>
 <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <20211118080627.GH174703@worktop.programming.kicks-ass.net>
 <20211118081852.GM174730@worktop.programming.kicks-ass.net>
 <YZYfYOcqNqOyZ8Yo@hirez.programming.kicks-ass.net>
 <YZZC3Shc0XA/gHK9@hirez.programming.kicks-ass.net>
 <20211119020427.2y5esq2czquwmvwc@treble>
 <YZduix64h64cDa7R@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YZduix64h64cDa7R@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 10:29:47AM +0100, Peter Zijlstra wrote:
> On Thu, Nov 18, 2021 at 06:04:27PM -0800, Josh Poimboeuf wrote:
> > On Thu, Nov 18, 2021 at 01:11:09PM +0100, Peter Zijlstra wrote:
> 
> > > I now have the below, the only thing missing is that there's a
> > > user_mode() call on a stack based regs. Now on x86_64 we can
> > > __get_kernel_nofault() regs->cs and call it a day, but on i386 we have
> > > to also fetch regs->flags.
> > > 
> > > Is this really the way to go?
> > 
> > Please no.  Can we just add a check in unwind_start() to ensure the
> > caller did try_get_task_stack()?
> 
> I tried; but at best it's fundamentally racy and in practise its worse
> because init_task doesn't seem to believe in refcounts and kthreads are
> odd for some raisin. Now those are fixable, but given the fundamental
> races, I don't see how it's ever going to be reliable.

I'm probably out of the loop here, but I wonder what races you're
referring to.

And I assume 'stack_refcount > 0' only needs to be asserted when
unwinding other tasks, not current.  So it shouldn't affect unwinds
during boot, or oopses.

Yes, the unwinder has to be rock solid, but if the caller can't even
ensure the given task's memory exists, it sounds like a bug in the
caller that needs a warning.

-- 
Josh


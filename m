Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789EC4567CF
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 03:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhKSCHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 21:07:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232627AbhKSCHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 21:07:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637287473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AGSOSbx9KHQS8zqvecKfdTvOeLPt7uvQMecFRR7horI=;
        b=bbDWT5e+tycB/WXU9BvRrHLSmmBrPl/Tle9hZjZ3uZ7ZyXg/1+kiZuOS8OGGBcEgCKrLU7
        8wDn6QmKU6DbzGoEL9WQhpZ48wSDEo7vRHEUPCA2Bp3UNtPmBObOtvOj4mA2XDLJIyhCVX
        O9Cn2MLG+1j38eqlJV2w7yLv4Q4Kssw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-DFV6SrAxPCGShDyyQF7RLg-1; Thu, 18 Nov 2021 21:04:32 -0500
X-MC-Unique: DFV6SrAxPCGShDyyQF7RLg-1
Received: by mail-qt1-f198.google.com with SMTP id o12-20020a05622a008c00b002aff5552c89so5693367qtw.23
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 18:04:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AGSOSbx9KHQS8zqvecKfdTvOeLPt7uvQMecFRR7horI=;
        b=phdWVHHWAbo3raleqkj68azdtyssknViqhGtiOQpGj1WWv8wcfJlwrKALgrBzWoWVu
         lTH4uFPBXPRGdDMCLL+tLoDT0RlS5jiM1/jxEPhubQUA0EFOVCxbZTiHAtiteE9mCYFk
         UcmG04KB3R0YAgTNlJpD7ujdQI+KJHnTF8UwAHvFZenTlZxv86LLnM742z3H3GMl97af
         9YETquFX1IPilGH0aquSp4pCgv2E0pBgCRveJgxNGf5N1JdQxadBFSFJcwvpAext3F36
         dF0OBF9UuK0sGjcW6HB55R19hFxu4bHLn2SJ6cCapgykqqdZl07DKVBbp5lkNQ+TvIWg
         SDWw==
X-Gm-Message-State: AOAM533VyeR7zx4Vagw54F06vEYfkg5xg0JxK5kmHY9byKLdc7ZZ/jDk
        45+lgISl0oWQ+FX20g4EbrzzDgDUqBxBgbMxeMQYsiWCiXI9C1LDnwKYeQW9I3xPZaMkNkgnRvO
        a5gG/I7Rh4crSNj1a
X-Received: by 2002:a05:620a:bd6:: with SMTP id s22mr25531281qki.306.1637287471818;
        Thu, 18 Nov 2021 18:04:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxuCUqQL54jg/D75F3PqUIH6vspq7qRyOaik1SrsMas8wVNJJ8wVqJFn1+vXReR5poHB6M+1g==
X-Received: by 2002:a05:620a:bd6:: with SMTP id s22mr25531253qki.306.1637287471523;
        Thu, 18 Nov 2021 18:04:31 -0800 (PST)
Received: from treble ([2600:1700:6e32:6c00::35])
        by smtp.gmail.com with ESMTPSA id 139sm841883qkn.37.2021.11.18.18.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 18:04:30 -0800 (PST)
Date:   Thu, 18 Nov 2021 18:04:27 -0800
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Holger =?utf-8?Q?Hoffst=C3=A4tte?= 
        <holger@applied-asynchrony.com>,
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
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
Message-ID: <20211119020427.2y5esq2czquwmvwc@treble>
References: <20211117101657.463560063@linuxfoundation.org>
 <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <20211118080627.GH174703@worktop.programming.kicks-ass.net>
 <20211118081852.GM174730@worktop.programming.kicks-ass.net>
 <YZYfYOcqNqOyZ8Yo@hirez.programming.kicks-ass.net>
 <YZZC3Shc0XA/gHK9@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YZZC3Shc0XA/gHK9@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 01:11:09PM +0100, Peter Zijlstra wrote:
> On Thu, Nov 18, 2021 at 10:39:44AM +0100, Peter Zijlstra wrote:
> > On Thu, Nov 18, 2021 at 09:18:52AM +0100, Peter Zijlstra wrote:
> > > On Thu, Nov 18, 2021 at 09:06:27AM +0100, Peter Zijlstra wrote:
> > > > On Wed, Nov 17, 2021 at 03:50:17PM -0800, Linus Torvalds wrote:
> > > > 
> > > > > I really don't think the WCHAN code should use unwinders at all. It's
> > > > > too damn fragile, and it's too easily triggered from user space.
> > > > 
> > > > On x86, esp. with ORC, it pretty much has to. The thing is, the ORC
> > > > unwinder has been very stable so far. I'm guessing there's some really
> > > > stupid thing going on, like for example trying to unwind a freed stack.
> > > > 
> > > > I *just* managed to reproduce, so let me go have a poke.
> > > 
> > > Confirmed, with the below it no longer reproduces. Now, let me go undo
> > > that and fix the unwinder to not explode while trying to unwind nothing.
> > 
> > OK, so the bug is firmly with 5d1ceb3969b6 ("x86: Fix __get_wchan() for
> > !STACKTRACE") which lost the try_get_task_stack() that stack_trace_*()
> > does.
> > 
> > We can ofc trivially re-instate that, but I'm now running with the
> > below which I suppose is a better fix, hmm?
> > 
> > (obv I still need to look a the other two unwinders)
> 
> I now have the below, the only thing missing is that there's a
> user_mode() call on a stack based regs. Now on x86_64 we can
> __get_kernel_nofault() regs->cs and call it a day, but on i386 we have
> to also fetch regs->flags.
> 
> Is this really the way to go?

Please no.  Can we just add a check in unwind_start() to ensure the
caller did try_get_task_stack()?

-- 
Josh


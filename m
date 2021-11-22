Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4F34592CE
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 17:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239362AbhKVQRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 11:17:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44270 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232010AbhKVQRc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 11:17:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637597665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oDqfdIbFIdXooJZfUJt+6LBfPzQdTcBW//aerVYbmM8=;
        b=cgc5d+RDos2KNuhNSXru0Bsqvh0hQTD4pO3jFeDfXszsSYDJj4jXJz/rDmwGhzTX+ExsBK
        NYebJ5X+QYMPLIVVUzcz8TeD8lhkjOiYvtc7ABB0DGgQZ18zmPtnC79dtfpJ1uH8lZv3ek
        8BRET+Gf1F6VCI/sWYN7TcnUAoTTUU0=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-X5EaVY7tOXaMlkozDlBm0w-1; Mon, 22 Nov 2021 11:14:23 -0500
X-MC-Unique: X5EaVY7tOXaMlkozDlBm0w-1
Received: by mail-oo1-f72.google.com with SMTP id s12-20020a4ae48c000000b002bc4787a242so10843258oov.1
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 08:14:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oDqfdIbFIdXooJZfUJt+6LBfPzQdTcBW//aerVYbmM8=;
        b=0xs+H+6BCCojoLawExaU+Oad404vOZjfRhTYBSY3cUcweTLUQUsLf9dgjvq3rYhDlo
         kp2ERhKybiznRedOC5Q3NKNrDPBvLei7pjvHM/k0jL0CLJT6FMO8p0jjrcuJiI5kbVsM
         9XHrGJnptsf8l9W+8wiyv2JtvEpAcumfeussY35mPAXqNrdLnr8aFmRJKnFCQr5/vjXl
         WqfFYRHr9gGULHi0E7U5EObDnZXjj+ANEbIp/GC8YM9ROIe469vjuy4rdUDFFPrOpCwt
         lajdOjoUG8s8HGnvtWsG2aOekPikRskCglh2JApXju1m5qIQvQ2n4ztySkn9ebEDgnfh
         UwVw==
X-Gm-Message-State: AOAM533KEs04ELz4OwUYMd8+WQ0VjvUwuvJo1PGltTW0eiZ5ME/gvYGD
        /ZhElarR18r3nD3TfVPBiCKDpQ1c7CVBsDMft+VXu6yaeXNEp1jOpVj1uVQv0G8E6gWYLDel/fG
        HTJ/0NyMHFQ/u4SLj
X-Received: by 2002:a9d:7601:: with SMTP id k1mr25983691otl.356.1637597662228;
        Mon, 22 Nov 2021 08:14:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNn/JqyNoAjBIUZE9V4zkBZkxe3Q7h92hvai17oMl48w0ykwgLNgn4Hjv/oGLto3z69Uf7TA==
X-Received: by 2002:a9d:7601:: with SMTP id k1mr25983660otl.356.1637597662009;
        Mon, 22 Nov 2021 08:14:22 -0800 (PST)
Received: from treble ([2600:1700:6e32:6c00::35])
        by smtp.gmail.com with ESMTPSA id bl33sm2000920oib.47.2021.11.22.08.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 08:14:20 -0800 (PST)
Date:   Mon, 22 Nov 2021 08:14:17 -0800
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
Message-ID: <20211122161417.p3yopenukxbts4gm@treble>
References: <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <20211118080627.GH174703@worktop.programming.kicks-ass.net>
 <20211118081852.GM174730@worktop.programming.kicks-ass.net>
 <YZYfYOcqNqOyZ8Yo@hirez.programming.kicks-ass.net>
 <YZZC3Shc0XA/gHK9@hirez.programming.kicks-ass.net>
 <20211119020427.2y5esq2czquwmvwc@treble>
 <YZduix64h64cDa7R@hirez.programming.kicks-ass.net>
 <20211119183544.sragh42cn2liu3pw@treble>
 <YZtjsPXjEsxOU0Zv@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YZtjsPXjEsxOU0Zv@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 22, 2021 at 10:32:32AM +0100, Peter Zijlstra wrote:
> On Fri, Nov 19, 2021 at 10:35:44AM -0800, Josh Poimboeuf wrote:
> > On Fri, Nov 19, 2021 at 10:29:47AM +0100, Peter Zijlstra wrote:
> > > On Thu, Nov 18, 2021 at 06:04:27PM -0800, Josh Poimboeuf wrote:
> > > > On Thu, Nov 18, 2021 at 01:11:09PM +0100, Peter Zijlstra wrote:
> > > 
> > > > > I now have the below, the only thing missing is that there's a
> > > > > user_mode() call on a stack based regs. Now on x86_64 we can
> > > > > __get_kernel_nofault() regs->cs and call it a day, but on i386 we have
> > > > > to also fetch regs->flags.
> > > > > 
> > > > > Is this really the way to go?
> > > > 
> > > > Please no.  Can we just add a check in unwind_start() to ensure the
> > > > caller did try_get_task_stack()?
> > > 
> > > I tried; but at best it's fundamentally racy and in practise its worse
> > > because init_task doesn't seem to believe in refcounts and kthreads are
> > > odd for some raisin. Now those are fixable, but given the fundamental
> > > races, I don't see how it's ever going to be reliable.
> > 
> > I'm probably out of the loop here, but I wonder what races you're
> > referring to.
> 
> We can do the warn as you suggest, however, it can become 0 right after
> we test and then still make the unwder explode.
> 
> That is, the test is not sufficient.

Realistically there are a limited number of callers to the unwinder.  If
anybody calls with refcount < 2 then we can WARN() and root them out.

It would have found this bug far before any weird races would have been
found.

True, it's not bulletproof, but task unwinder usage is (to some degree)
less critical than oopses.

Now I'm off to disappear for turkey week.  Cheers.

-- 
Josh


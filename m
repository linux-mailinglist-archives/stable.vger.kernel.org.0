Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA2D458BA1
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 10:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238918AbhKVJgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 04:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238829AbhKVJgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 04:36:06 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E191C061574;
        Mon, 22 Nov 2021 01:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Fp26s5uppIFd2Zv4jQ0yfaWneL1VX3WxkQs03CTdqkU=; b=H38Cef7CAspj9z8pOoghO0oMpH
        3Mkjm7+M59OaJ86VowlLqGvGv7LNEBgbkRlvAYV61NVGviRs5L1dtyZdCG9VK3CAdCdU087qQxS/I
        gwnK2yHpfIPPPqnImsPVMVBaEMhSJoEobEfikQVJ6UspAWlNaadpR9jShApOK8bzJrz7AMW61uwvI
        QDKdKOrI664kTIxeADVIrWj492gB/ZpmHHM47UygaC4QuK8sxrp8w6umJp8ker4tADE2vE7qYO7x0
        UhqlIMgiCiaK3phwlzIy3yetjvBqoli3ixzm0M02JFxY9dRa9oLcektdRaE2RzqFnV7Kcdt/q84lF
        H/niIMUQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp5gh-00HSx6-KW; Mon, 22 Nov 2021 09:32:35 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5064130043C;
        Mon, 22 Nov 2021 10:32:33 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E263F203218D5; Mon, 22 Nov 2021 10:32:32 +0100 (CET)
Date:   Mon, 22 Nov 2021 10:32:32 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
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
Message-ID: <YZtjsPXjEsxOU0Zv@hirez.programming.kicks-ass.net>
References: <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <20211118080627.GH174703@worktop.programming.kicks-ass.net>
 <20211118081852.GM174730@worktop.programming.kicks-ass.net>
 <YZYfYOcqNqOyZ8Yo@hirez.programming.kicks-ass.net>
 <YZZC3Shc0XA/gHK9@hirez.programming.kicks-ass.net>
 <20211119020427.2y5esq2czquwmvwc@treble>
 <YZduix64h64cDa7R@hirez.programming.kicks-ass.net>
 <20211119183544.sragh42cn2liu3pw@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119183544.sragh42cn2liu3pw@treble>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 10:35:44AM -0800, Josh Poimboeuf wrote:
> On Fri, Nov 19, 2021 at 10:29:47AM +0100, Peter Zijlstra wrote:
> > On Thu, Nov 18, 2021 at 06:04:27PM -0800, Josh Poimboeuf wrote:
> > > On Thu, Nov 18, 2021 at 01:11:09PM +0100, Peter Zijlstra wrote:
> > 
> > > > I now have the below, the only thing missing is that there's a
> > > > user_mode() call on a stack based regs. Now on x86_64 we can
> > > > __get_kernel_nofault() regs->cs and call it a day, but on i386 we have
> > > > to also fetch regs->flags.
> > > > 
> > > > Is this really the way to go?
> > > 
> > > Please no.  Can we just add a check in unwind_start() to ensure the
> > > caller did try_get_task_stack()?
> > 
> > I tried; but at best it's fundamentally racy and in practise its worse
> > because init_task doesn't seem to believe in refcounts and kthreads are
> > odd for some raisin. Now those are fixable, but given the fundamental
> > races, I don't see how it's ever going to be reliable.
> 
> I'm probably out of the loop here, but I wonder what races you're
> referring to.

We can do the warn as you suggest, however, it can become 0 right after
we test and then still make the unwder explode.

That is, the test is not sufficient.

> And I assume 'stack_refcount > 0' only needs to be asserted when
> unwinding other tasks, not current.  So it shouldn't affect unwinds
> during boot, or oopses.
> 
> Yes, the unwinder has to be rock solid, but if the caller can't even
> ensure the given task's memory exists, it sounds like a bug in the
> caller that needs a warning.

Well, yes. Still it would be nice if the unwinder would not itself burn
the house, even in that case.

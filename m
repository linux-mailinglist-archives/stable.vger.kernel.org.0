Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDB7456D32
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 11:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbhKSK02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 05:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbhKSK02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 05:26:28 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47ABC061574;
        Fri, 19 Nov 2021 02:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gvdXTg/W2n3kKbuv3dIGKinzbO87/pI65V1In1bjrsM=; b=KdaE+z6SbZ935E8lO4NM5utHGv
        UsEYEvPWBYYvqGkj+Q3LxJTAfoxrH5w4Rxn0XwaQhkxKtLVlFh8ptyxG+ZflDJTyHjGf/1pRhEdUL
        BrN0uwUEI5YUsVjHSN7ZtWWF/hMTfnLclgMXlTKZLH63iefadLKm4eZbnU3DgM+sV7rFfZOWXnX4V
        W6IAFdffjS+ffsXJpbiid/jpm78LVb+2facCvmTn9rHX3SjuDlo/elkNFLp6mu5dymTv5Zjs0yRNc
        iuoXWyrcpnycu1wiUDa7RvgM1lG36MQ+eReEgJZy3MfzwQaPgduLtM68jsoq1BliaKr/XBtXRqmNw
        dpvBf58g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mo12h-00GsQM-4O; Fri, 19 Nov 2021 10:22:52 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2415930001B;
        Fri, 19 Nov 2021 11:22:49 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D724C30AF36F8; Fri, 19 Nov 2021 11:22:49 +0100 (CET)
Date:   Fri, 19 Nov 2021 11:22:49 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Qi Zheng <zhengqi.arch@bytedance.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Holger Hoffst??tte <holger@applied-asynchrony.com>,
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
Message-ID: <YZd6+SFZVzTeX45f@hirez.programming.kicks-ass.net>
References: <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <20211118080627.GH174703@worktop.programming.kicks-ass.net>
 <20211118081852.GM174730@worktop.programming.kicks-ass.net>
 <YZYfYOcqNqOyZ8Yo@hirez.programming.kicks-ass.net>
 <YZZC3Shc0XA/gHK9@hirez.programming.kicks-ass.net>
 <20211119020427.2y5esq2czquwmvwc@treble>
 <YZduix64h64cDa7R@hirez.programming.kicks-ass.net>
 <759cd319-990f-af23-2f1c-aba55d0768b8@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <759cd319-990f-af23-2f1c-aba55d0768b8@bytedance.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 06:02:50PM +0800, Qi Zheng wrote:

> This implementation is very similar to stack_trace_save_tsk(), maybe we
> can just move stack_trace_save_tsk() out of CONFIG_STACKTRACE and reuse
> it.

No, we want to move away from the stack_trace_*() API because it has
very unclear semantics and various arch implementations differ in
details.

There's a patch that untangles arch_stack_walk*() from CONFIG_STACKTRACE
and we can eventually use that.

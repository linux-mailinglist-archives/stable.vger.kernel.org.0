Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95B2DEC4DF
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 15:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfKAOk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 10:40:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59211 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfKAOk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 10:40:26 -0400
Received: from [91.217.168.176] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iQY6B-00083i-4c; Fri, 01 Nov 2019 14:40:23 +0000
Date:   Fri, 1 Nov 2019 15:40:22 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Florian Weimer <fweimer@redhat.com>,
        GNU C Library <libc-alpha@sourceware.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-api@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] clone3: validate stack arguments
Message-ID: <20191101144021.p6dh7utlvqecuhua@wittgenstein>
References: <20191031113608.20713-1-christian.brauner@ubuntu.com>
 <20191031164653.GA24629@redhat.com>
 <20191101110639.icbfihw3fk2nzz4o@wittgenstein>
 <20191101123257.GA508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191101123257.GA508@redhat.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 01, 2019 at 01:32:57PM +0100, Oleg Nesterov wrote:
> On 11/01, Christian Brauner wrote:
> >
> > On Thu, Oct 31, 2019 at 05:46:53PM +0100, Oleg Nesterov wrote:
> > > On 10/31, Christian Brauner wrote:
> > > >
> > > > --- a/include/uapi/linux/sched.h
> > > > +++ b/include/uapi/linux/sched.h
> > > > @@ -51,6 +51,10 @@
> > > >   *               sent when the child exits.
> > > >   * @stack:       Specify the location of the stack for the
> > > >   *               child process.
> > > > + *               Note, @stack is expected to point to the
> > > > + *               lowest address. The stack direction will be
> > > > + *               determined by the kernel and set up
> > > > + *               appropriately based on @stack_size.
> > >
> > > I can't review this patch, I have no idea what does stack_size mean
> > > if !arch/x86.
> >
> > In short: nothing at all if it weren't for ia64 (and maybe parisc).
> > But let me provide some (hopefully useful) context.
> 
> Thanks...
> 
> > (Probably most of
> > that is well-know,
> 
> Certainly not to me ;) Thanks.
> 
> > > > +static inline bool clone3_stack_valid(struct kernel_clone_args *kargs)
> > > > +{
> > > > +	if (kargs->stack == 0) {
> > > > +		if (kargs->stack_size > 0)
> > > > +			return false;
> > > > +	} else {
> > > > +		if (kargs->stack_size == 0)
> > > > +			return false;
> > >
> > > So to implement clone3_wrapper(void *bottom_of_stack) you need to do
> > >
> > > 	clone3_wrapper(void *bottom_of_stack)
> > > 	{
> > > 		struct clone_args args = {
> > > 			...
> > > 			// make clone3_stack_valid() happy
> > > 			.stack = bottom_of_stack - 1,
> > > 			.stack_size = 1,
> > > 		};
> > > 	}
> > >
> > > looks a bit strange. OK, I agree, this example is very artificial.
> > > But why do you think clone3() should nack stack_size == 0 ?
> >
> > In short, consistency.
> 
> And in my opinion this stack_size == 0 check destroys the consistency,
> see below.
> 
> But just in case, let me say that overall I personally like this change.
> 
> > The best thing imho, is to clearly communicate to userspace that stack
> > needs to point to the lowest address and stack_size to the initial range
> > of the stack pointer
> 
> Agreed.
> 
> But the kernel can't verify that "stack" actually points to the lowest
> address and stack_size is actually the stack size. Consider another
> artificial

Sure, but that's the similar to other structs that are passed via a
pointer and come with a size. You could pass:

setxattr(..., ..., value - size, size, ...);

and the kernel would be confused as well.

> 
>     	clone3_wrapper(void *bottom_of_stack, unsigned long offs)
>     	{
>     		struct clone_args args = {
>     			...
>     			// make clone3_stack_valid() happy
>     			.stack = bottom_of_stack - offs,
>     			.stack_size = offs,
>     		};
>     		sys_clone3(args);
>     	}
> 	
> Now,
> 
> 	clone3_wrapper(bottom_of_stack, offs);
> 
> is same thing for _any_ offs except offs == 0 will fail. Why? To me this
> is not consistent, I think the "stack_size == 0" check buys nothing and
> only adds some confusion.

I disagree. It's a very easy contract: pass a stack and a size or
request copy-on-write by passing both as 0.
Sure, you can flaunt that contract but that's true of every other
pointer + size api. The point is: the api we endorse should be simple
and stack + stack_size is very simple.

> 
> Say, stack_size == 1 is "obviously wrong" too, this certainly means that
> "stack" doesn't point to the lowest address (or the child will corrupt the
> memory), but it works.
> 
> OK, I won't insist. Perhaps it can help to detect the case when a user
> forgets to pass the correct stack size.
> 
> > > > +		if (!access_ok((void __user *)kargs->stack, kargs->stack_size))
> > > > +			return false;
> > >
> > > Why?
> >
> > It's nice of us to tell userspace _before_ we have created a thread that
> > it messed up its parameters instead of starting a thread that then
> > immediately crashes.
> 
> Heh. Then why this code doesn't verify that at least stack + stack_size is
> properly mmaped with PROT_READ|WRITE?

access_ok() is uncomplicated.
The other check makes a lot more assumptions. Theare are users that might
want to have a PROT_NONE part of their stack as their own "private"
guard page (Jann just made that point) and there are other corner cases.

Christian

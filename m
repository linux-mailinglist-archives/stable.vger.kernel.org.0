Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1F7EC18C
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 12:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfKALGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 07:06:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54392 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727561AbfKALGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 07:06:43 -0400
Received: from [91.217.168.176] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iQUlN-0007Zu-7r; Fri, 01 Nov 2019 11:06:41 +0000
Date:   Fri, 1 Nov 2019 12:06:40 +0100
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
Message-ID: <20191101110639.icbfihw3fk2nzz4o@wittgenstein>
References: <20191031113608.20713-1-christian.brauner@ubuntu.com>
 <20191031164653.GA24629@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191031164653.GA24629@redhat.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 31, 2019 at 05:46:53PM +0100, Oleg Nesterov wrote:
> On 10/31, Christian Brauner wrote:
> >
> > --- a/include/uapi/linux/sched.h
> > +++ b/include/uapi/linux/sched.h
> > @@ -51,6 +51,10 @@
> >   *               sent when the child exits.
> >   * @stack:       Specify the location of the stack for the
> >   *               child process.
> > + *               Note, @stack is expected to point to the
> > + *               lowest address. The stack direction will be
> > + *               determined by the kernel and set up
> > + *               appropriately based on @stack_size.
> 
> I can't review this patch, I have no idea what does stack_size mean
> if !arch/x86.

In short: nothing at all if it weren't for ia64 (and maybe parisc).
But let me provide some (hopefully useful) context. (Probably most of
that is well-know, so sorry for superflous info. :))

The stack and stack_size argument are used in copy_thread_tls() and in
copy_thread(). What the arch will end up calling depends on
CONFIG_HAVE_COPY_THREAD. Afaict, mips, powerpc, s390, and x86
call copy_thread_tls(). The other arches call copy_thread().
On all arches _except_ IA64 copy_thread{_tls}() just assigns "stack" to
the right register and is done with it.
On all arches _except_ parisc "stack" needs to point to the highest
address. On parisc it needs to point to the lowest
(CONFIG_STACK_GROWSUP).
IA64 has a downwards growing stack like all the other architectures but
it expects "stack" to poin to the _lowest_ address nonetheless. In
contrast to all the other arches it does:

	child_ptregs->r12 = user_stack_base + user_stack_size - 16;

so ia64 sets up the stack pointer itself.

So now we have:
 parisc ->   upwards growing stack, stack_size _unused_ for user stacks
!parisc -> downwards growing stack, stack_size _unused_ for user stacks
   ia64 -> downwards growing stack, stack_size   _used_ for user stacks

Now it gets more confusing since the clone() syscall layout is arch
dependent as well. Let's ignore the case of arches that have a clone
syscall version with switched flags and stack argument and only focus on
arches with an _additional_ stack_size argument:

microblaze -> clone(stack, stack_size)

Then there's clone2() for ia64 which is a _separate_ syscall with an
additional stack_size argument:

ia64       -> clone2(stack, stack_size)

Now, contrary to what you'd expect, microblaze ignores the stack_size
argument.

So the stack_size argument _would_ be completely meaningless if it
weren't for ia64 and parisc.

> 
> x86 doesn't use stack_size unless a kthread does kernel_thread(), so
> this change is probably fine...
> 
> Hmm. Off-topic question, why did 7f192e3cd3 ("fork: add clone3") add
> "& ~CSIGNAL" in kernel_thread() ? This looks pointless and confusing
> to me...

(Can we discuss this over a patch that removes this restriction if we
think this is pointless?)

> 
> > +static inline bool clone3_stack_valid(struct kernel_clone_args *kargs)
> > +{
> > +	if (kargs->stack == 0) {
> > +		if (kargs->stack_size > 0)
> > +			return false;
> > +	} else {
> > +		if (kargs->stack_size == 0)
> > +			return false;
> 
> So to implement clone3_wrapper(void *bottom_of_stack) you need to do
> 
> 	clone3_wrapper(void *bottom_of_stack)
> 	{
> 		struct clone_args args = {
> 			...
> 			// make clone3_stack_valid() happy
> 			.stack = bottom_of_stack - 1,
> 			.stack_size = 1,
> 		};
> 	}
> 
> looks a bit strange. OK, I agree, this example is very artificial.
> But why do you think clone3() should nack stack_size == 0 ?

In short, consistency.
I think prior clone() versions (on accident) have exposed the stack
direction as an implementation detail to userspace. Userspace clone()
code wrapping code is _wild_ and buggy partially because of that.

The best thing imho, is to clearly communicate to userspace that stack
needs to point to the lowest address and stack_size to the initial range
of the stack pointer or both are 0.

The alternative is to let userspace either give us a stack pointer that
we expect to be setup correctly by userspace or a stack pointer to the
lowest address and a stack_size argument. That's just an invitation for
more confusion and we have proof with legacy clone that this is not a
good idea.

> 
> > +		if (!access_ok((void __user *)kargs->stack, kargs->stack_size))
> > +			return false;
> 
> Why?

It's nice of us to tell userspace _before_ we have created a thread that
it messed up its parameters instead of starting a thread that then
immediately crashes.

Christian

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26DFEEC566
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 16:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbfKAPKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 11:10:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60008 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbfKAPKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 11:10:21 -0400
Received: from [91.217.168.176] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iQYZ5-0001ct-CM; Fri, 01 Nov 2019 15:10:15 +0000
Date:   Fri, 1 Nov 2019 16:10:14 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
        Florian Weimer <fweimer@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GNU C Library <libc-alpha@sourceware.org>, nd <nd@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] clone3: validate stack arguments
Message-ID: <20191101151014.75jfcdc3hrwt6ssv@wittgenstein>
References: <20191031113608.20713-1-christian.brauner@ubuntu.com>
 <f51d97a2-8130-0ba2-c591-638b7fd6b14d@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f51d97a2-8130-0ba2-c591-638b7fd6b14d@arm.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 01, 2019 at 02:57:10PM +0000, Szabolcs Nagy wrote:
> On 31/10/2019 11:36, Christian Brauner wrote:
> > diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> > index 99335e1f4a27..25b4fa00bad1 100644
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
> >   * @stack_size:  The size of the stack for the child process.
> >   * @tls:         If CLONE_SETTLS is set, the tls descriptor
> >   *               is set to tls.
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index bcdf53125210..55af6931c6ec 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -2561,7 +2561,35 @@ noinline static int copy_clone_args_from_user(struct kernel_clone_args *kargs,
> >  	return 0;
> >  }
> >  
> > -static bool clone3_args_valid(const struct kernel_clone_args *kargs)
> > +/**
> > + * clone3_stack_valid - check and prepare stack
> > + * @kargs: kernel clone args
> > + *
> > + * Verify that the stack arguments userspace gave us are sane.
> > + * In addition, set the stack direction for userspace since it's easy for us to
> > + * determine.
> > + */
> > +static inline bool clone3_stack_valid(struct kernel_clone_args *kargs)
> > +{
> > +	if (kargs->stack == 0) {
> > +		if (kargs->stack_size > 0)
> > +			return false;
> > +	} else {
> > +		if (kargs->stack_size == 0)
> > +			return false;
> > +
> > +		if (!access_ok((void __user *)kargs->stack, kargs->stack_size))
> > +			return false;
> > +
> > +#if !defined(CONFIG_STACK_GROWSUP) && !defined(CONFIG_IA64)
> > +		kargs->stack += kargs->stack_size;
> > +#endif
> > +	}
> 
> from the description it is not clear whose
> responsibility it is to guarantee the alignment
> of sp on entry.

Userspace.

> 
> i think 0 stack size may work if signals are
> blocked and then prohibiting it might not be
> the right thing.

Note that stack size 0 is allowed:

struct clone_args args = {
	.exit_signal = SIGCHLD,
};

clone3(&args, sizeof(args));

will just work fine.

> 
> it's not clear how libc should deal with v5.3
> kernels which don't have the stack+=stack_size
> logic.

stable is already Cced and the change will be backported to v5.3.
Nearly all distros track pull in stable updates.

Florian, thoughts on this?

Christian

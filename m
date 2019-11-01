Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B57EC2BA
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 13:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbfKAMeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 08:34:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43084 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726229AbfKAMeb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 08:34:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572611669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Blgz1QDlbrX4CFcoZXAgNrnij3Ts9PT2qjsZuUJOKd4=;
        b=h5jt6mcDjNTwbhcAyyQzxKrkGelqnJ37+5m7Yrh8KXdlw9++RfBNUR3iYtZVZViIf5WK3y
        URmgjd799Z4DxjbdCW8lC5+lUENKRh4hjXL3n8yGRG93GQQ+zBZNaT+KRlPQn2RzPvrbIx
        D/NbN1Xm+P828GUQxUoFRy0mRQxKXEk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-QADGKEzYOKOPHVxH7fQt-A-1; Fri, 01 Nov 2019 08:33:05 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86BE9800683;
        Fri,  1 Nov 2019 12:33:02 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.44])
        by smtp.corp.redhat.com (Postfix) with SMTP id 113F75D9CD;
        Fri,  1 Nov 2019 12:32:59 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Fri,  1 Nov 2019 13:33:00 +0100 (CET)
Date:   Fri, 1 Nov 2019 13:32:57 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
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
Message-ID: <20191101123257.GA508@redhat.com>
References: <20191031113608.20713-1-christian.brauner@ubuntu.com>
 <20191031164653.GA24629@redhat.com>
 <20191101110639.icbfihw3fk2nzz4o@wittgenstein>
MIME-Version: 1.0
In-Reply-To: <20191101110639.icbfihw3fk2nzz4o@wittgenstein>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: QADGKEzYOKOPHVxH7fQt-A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/01, Christian Brauner wrote:
>
> On Thu, Oct 31, 2019 at 05:46:53PM +0100, Oleg Nesterov wrote:
> > On 10/31, Christian Brauner wrote:
> > >
> > > --- a/include/uapi/linux/sched.h
> > > +++ b/include/uapi/linux/sched.h
> > > @@ -51,6 +51,10 @@
> > >   *               sent when the child exits.
> > >   * @stack:       Specify the location of the stack for the
> > >   *               child process.
> > > + *               Note, @stack is expected to point to the
> > > + *               lowest address. The stack direction will be
> > > + *               determined by the kernel and set up
> > > + *               appropriately based on @stack_size.
> >
> > I can't review this patch, I have no idea what does stack_size mean
> > if !arch/x86.
>
> In short: nothing at all if it weren't for ia64 (and maybe parisc).
> But let me provide some (hopefully useful) context.

Thanks...

> (Probably most of
> that is well-know,

Certainly not to me ;) Thanks.

> > > +static inline bool clone3_stack_valid(struct kernel_clone_args *karg=
s)
> > > +{
> > > +=09if (kargs->stack =3D=3D 0) {
> > > +=09=09if (kargs->stack_size > 0)
> > > +=09=09=09return false;
> > > +=09} else {
> > > +=09=09if (kargs->stack_size =3D=3D 0)
> > > +=09=09=09return false;
> >
> > So to implement clone3_wrapper(void *bottom_of_stack) you need to do
> >
> > =09clone3_wrapper(void *bottom_of_stack)
> > =09{
> > =09=09struct clone_args args =3D {
> > =09=09=09...
> > =09=09=09// make clone3_stack_valid() happy
> > =09=09=09.stack =3D bottom_of_stack - 1,
> > =09=09=09.stack_size =3D 1,
> > =09=09};
> > =09}
> >
> > looks a bit strange. OK, I agree, this example is very artificial.
> > But why do you think clone3() should nack stack_size =3D=3D 0 ?
>
> In short, consistency.

And in my opinion this stack_size =3D=3D 0 check destroys the consistency,
see below.

But just in case, let me say that overall I personally like this change.

> The best thing imho, is to clearly communicate to userspace that stack
> needs to point to the lowest address and stack_size to the initial range
> of the stack pointer

Agreed.

But the kernel can't verify that "stack" actually points to the lowest
address and stack_size is actually the stack size. Consider another
artificial

    =09clone3_wrapper(void *bottom_of_stack, unsigned long offs)
    =09{
    =09=09struct clone_args args =3D {
    =09=09=09...
    =09=09=09// make clone3_stack_valid() happy
    =09=09=09.stack =3D bottom_of_stack - offs,
    =09=09=09.stack_size =3D offs,
    =09=09};
    =09=09sys_clone3(args);
    =09}
=09
Now,

=09clone3_wrapper(bottom_of_stack, offs);

is same thing for _any_ offs except offs =3D=3D 0 will fail. Why? To me thi=
s
is not consistent, I think the "stack_size =3D=3D 0" check buys nothing and
only adds some confusion.

Say, stack_size =3D=3D 1 is "obviously wrong" too, this certainly means tha=
t
"stack" doesn't point to the lowest address (or the child will corrupt the
memory), but it works.

OK, I won't insist. Perhaps it can help to detect the case when a user
forgets to pass the correct stack size.

> > > +=09=09if (!access_ok((void __user *)kargs->stack, kargs->stack_size)=
)
> > > +=09=09=09return false;
> >
> > Why?
>
> It's nice of us to tell userspace _before_ we have created a thread that
> it messed up its parameters instead of starting a thread that then
> immediately crashes.

Heh. Then why this code doesn't verify that at least stack + stack_size is
properly mmaped with PROT_READ|WRITE?

Oleg.


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC3D3A1FEA
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 00:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhFIWUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 18:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhFIWUx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 18:20:53 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A13C61184;
        Wed,  9 Jun 2021 22:18:57 +0000 (UTC)
Date:   Wed, 9 Jun 2021 18:18:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     James Wang <jnwang@linux.alibaba.com>,
        Liangyan <liangyan.peng@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Xunlei Pang <xlpang@linux.alibaba.com>,
        yinbinbin@alibabacloud.com, wetp <wetp.zy@linux.alibaba.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] tracing: Correct the length check which causes memory
 corruption
Message-ID: <20210609181855.7aeab6eb@oasis.local.home>
In-Reply-To: <CAHk-=wiGWjxs7EVUpccZEi6esvjpHJdgHQ=vtUeJ5crL62hx9A@mail.gmail.com>
References: <20210607125734.1770447-1-liangyan.peng@linux.alibaba.com>
        <71fa2e69-a60b-0795-5fef-31658f89591a@linux.alibaba.com>
        <CAHk-=whKbJkuVmzb0hD3N6q7veprUrSpiBHRxVY=AffWZPtxmg@mail.gmail.com>
        <20210609165154.3eab1749@oasis.local.home>
        <CAHk-=wiGWjxs7EVUpccZEi6esvjpHJdgHQ=vtUeJ5crL62hx9A@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 9 Jun 2021 14:43:51 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Jun 9, 2021 at 1:52 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > That "sizeof(*entry)" is clearly wrong, because it doesn't take the
> > > unsized array into account.  
> >
> > Correct. That's because I forgot that the structure has that empty array :-(  
> 
> Note that 'sparse' does have the option to warn about odd flexible
> array uses. Including 'sizeof()'.
> 
> You can do something like
> 
>     CF='-Wflexible-array-sizeof' make C=2 kernel/trace/trace.o
> 
> and you'll see
> 
>   kernel/trace/trace.c:1022:17: warning: using sizeof on a flexible structure

	alloc = sizeof(*entry) + size + 2; /* possible \n added */

Entry is created via a macro. But I guess that too could use a struct_size().

>   kernel/trace/trace.c:2645:17: warning: using sizeof on a flexible structure

		memset(event, 0, sizeof(*event));

Hah, this is the part that is clearing the first part of the
ring_buffer_event structure of that temp buffer. Where it's setting
"type_len" to zero. It doesn't care about the extended portion here.

>   kernel/trace/trace.c:2739:41: warning: using sizeof on a flexible structure

This is the code we are talking about now.

>   kernel/trace/trace.c:3290:16: warning: using sizeof on a flexible structure

This is like the first one. A macro created the structure, but probably
could be switched over.

>   kernel/trace/trace.c:3350:16: warning: using sizeof on a flexible structure

Same as the first occurrence.

>   kernel/trace/trace.c:6989:16: warning: using sizeof on a flexible structure

Also the same as the first.

>   kernel/trace/trace.c:7070:16: warning: using sizeof on a flexible structure

And same as the first.

> 
> and I suspect every single one of those should be using
> 'struct_size()' instead for a sizeof() on the base structure plus some
> manual arithmetic (or, as in the case of this bug, _without_ the extra
> arithmetic).

Most of the above are for structures that hold dynamic size strings.
But I have no problem converting them to struct_size. But since they
are created by FTRACE_ENTRY*() macros in kernel/trace/trace_entries.h,
we need to be careful in picking the field to use.

> 
> And yeah, it isn't just the tracing code that does this. We have it
> all over, so that sparse check isn't on by default. Sparse is pretty
> darn noisy even without it, but it can be worth using that
> CF='-Wflexible-array-sizeof' on individual files that you want to
> check.

Could be a task for an intern to do?

-- Steve

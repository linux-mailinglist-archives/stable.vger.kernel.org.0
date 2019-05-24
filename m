Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8879299C9
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 16:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404010AbfEXOLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 10:11:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403895AbfEXOLB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 10:11:01 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 96E3281126;
        Fri, 24 May 2019 14:11:00 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 8E55B1835C;
        Fri, 24 May 2019 14:10:55 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Fri, 24 May 2019 16:11:00 +0200 (CEST)
Date:   Fri, 24 May 2019 16:10:54 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Deepa Dinamani <deepa.kernel@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "dbueso@suse.de" <dbueso@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] signal: Adjust error codes according to
 restore_user_sigmask()
Message-ID: <20190524141054.GB2655@redhat.com>
References: <20190522150505.GA4915@redhat.com>
 <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
 <20190522161407.GB4915@redhat.com>
 <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com>
 <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com>
 <20190523163604.GE23070@redhat.com>
 <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com>
 <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 24 May 2019 14:11:00 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/23, Deepa Dinamani wrote:
>
> Ok, since there has been quite a bit of argument here, I will
> backtrack a little bit and maybe it will help us understand what's
> happening here.
> There are many scenarios being discussed on this thread:
> a. State of code before 854a6ed56839a

I think everything was correct,

> b. State after 854a6ed56839a

obviously buggy,

> c. Proposed fix as per the patchset in question.

Nack, sorry. I'll try to finish my patch on Monday. It will restore the state
before 854a6ed56839a and (imo) cleanup/simplify this code.

At leat this is what I think right now. May be I will have to change my mind
after this discussion. But in any case I can't believe I will ever agree with
your fix ;)

> These are particularly meant for a scenario(d) such as below:
>
> 1. block the signals you don't care about.
> 2. syscall()
> 3. unblock the signals blocked in 1.
>
> The problem here is that if there is a signal that is not blocked by 1
> and such a signal is delivered between 1 and 2(since they are not
> atomic), the syscall in 2 might block forever as it never found out
> about the signal.

and that is why we have pselect/etc to make this sequence "atomic".

> As per [a] and let's consider the case of epoll_pwait only first for simplicity.
>
> As I said before, ep_poll() is what checks for signal_pending() and is
> responsible for setting errno to -EINTR when there is a signal.

To clarify, if do_epoll_wait() return -EINTR then signal_pending() is true,
right?

> So if a signal is received after ep_poll() and ep_poll() returns
> success, it is never noticed by the syscall during execution.

What you are saying looks very confusing to me, I will assume that you
meant something like

	- a signal SIG_XXX was blocked before sys_epoll_pwait() was called

	- sys_epoll_pwait(sigmask) unblocks SIG_XXX according to sigmask

	- sys_epoll_pwait() calls do_epoll_wait() which returns success

	- SIG_XXX comes after that and it is "never noticed"

Yes. Everything is correct. And see my reply to David, SIG_XXX can even
come _before_ sys_epoll_pwait() was called.

> So the question is does the userspace have to know about this signal
> or not.

If userspace needs to know about SIG_XXX it should not block it, that is all.

> What [b] does is to move the signal check closer to the restoration of
> the signal.

FOR NO REASON, afaics (to simplify, lets forget the problem with the wrong
return value you are trying to fix).

And even if there were ANY reason to do this, note that (with or without this
fix) the signal_pending() check inside restore_user_sigmask() can NOT help,
simply because SIG_XXX can come right after this check.

Oleg.


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA592FFB6
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 17:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfE3P5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 11:57:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52440 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfE3P5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 11:57:45 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ABA9830C1FEB;
        Thu, 30 May 2019 15:57:22 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4847E7A026;
        Thu, 30 May 2019 15:57:17 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 30 May 2019 17:57:22 +0200 (CEST)
Date:   Thu, 30 May 2019 17:57:16 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Deepa Dinamani <deepa.kernel@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        arnd@arndb.de, dbueso@suse.de, axboe@kernel.dk, dave@stgolabs.net,
        e@80x24.org, jbaron@akamai.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, omar.kilani@gmail.com, tglx@linutronix.de,
        stable@vger.kernel.org
Subject: Re: pselect/etc semantics
Message-ID: <20190530155715.GH22536@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
 <87woi8rt96.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87woi8rt96.fsf@xmission.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 30 May 2019 15:57:45 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/30, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > Al, Linus, Eric, please help.
> >
> > The previous discussion was very confusing, we simply can not understand each
> > other.
> >
> > To me everything looks very simple and clear, but perhaps I missed something
> > obvious? Please correct me.
>
> If I have read this thread correctly the core issue is that ther is a
> program that used to work and that fails now.  The question is why.

I didn't even try to investigate, I wasn't cc'ed initially and I then I had
enough confusion when I started to look at the patch.

However, 854a6ed56839a40f6 obviously introduced the user-visible change so
I am not surprised it breaks something. And yes, personally I think this
change is not right.

> Which means I believe we have a semantically valid change in behavior
> that is causing a regression.

See below,

> void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
> {
>
> 	if (!usigmask)
> 		return;
> 	/*
> 	 * When signals are pending, do not restore them here.
> 	 * Restoring sigmask here can lead to delivering signals that the above
> 	 * syscalls are intended to block because of the sigmask passed in.
> 	 */
> 	if (signal_pending(current)) {
> 		current->saved_sigmask = *sigsaved;
> 		set_restore_sigmask();
> 		return;
> 	}
>
> 	/*
> 	 * This is needed because the fast syscall return path does not restore
> 	 * saved_sigmask when signals are not pending.
> 	 */
> 	set_current_blocked(sigsaved);
> }
>
> Which has been reported results in a return value of 0,

0 or success

> and a signal
> delivered, where previously that did not happen.

Yes.

And to me this doesn't look right. OK, OK, probably this is because I never
read the docs, only the source code in fs/select.c. But to me pselect() should
either return success/timeout or deliver a signal. Not both. Even if the signal
was already pending before pselect() was called.

To clarify, "a signal" means a signal which was blocked before pselect(sigmask)
and temporary unblocked in this syscall.

And even if this doesn't violate posix, I see no reason to change the historic
behaviour. And this regression probably means we can't ;)

Oleg.


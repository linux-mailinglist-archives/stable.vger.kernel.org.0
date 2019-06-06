Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B61F437184
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 12:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbfFFKWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 06:22:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60226 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbfFFKWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 06:22:24 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4E50F30872D2;
        Thu,  6 Jun 2019 10:22:13 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id B97096918F;
        Thu,  6 Jun 2019 10:22:05 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu,  6 Jun 2019 12:22:11 +0200 (CEST)
Date:   Thu, 6 Jun 2019 12:22:03 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Davidlohr Bueso <dbueso@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, e@80x24.org,
        Jason Baron <jbaron@akamai.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, omar.kilani@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH -mm 0/1] signal: simplify
 set_user_sigmask/restore_user_sigmask
Message-ID: <20190606102203.GA31870@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
 <20190604134117.GA29963@redhat.com>
 <20190605155801.GA25165@redhat.com>
 <CAHk-=wjkNx8u4Mcm5dfSQKYQmLQAv1Z1yGLDZvty7BVSj4eqBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjkNx8u4Mcm5dfSQKYQmLQAv1Z1yGLDZvty7BVSj4eqBA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 06 Jun 2019 10:22:24 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/05, Linus Torvalds wrote:
>
> On Wed, Jun 5, 2019 at 8:58 AM Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > To simplify the review, please see the code with this patch applied.
> > I am using epoll_pwait() as an example because it looks very simple.
>
> I like it.
>
> However.
>
> I think I'd like it even more if we just said "we don't need
> restore_saved_sigmask AT ALL".
  ^^^^^^^^^^^^^^^^^^^^^

Did you mean restore_saved_sigmask_unless() introduced by this patch?

If yes:

> Which would be fairly easy to do with something like the attached...

I don't think so,

> --- a/arch/x86/entry/common.c
> +++ b/arch/x86/entry/common.c
> @@ -160,7 +160,7 @@ static void exit_to_usermode_loop(struct pt_regs *regs, u32 cached_flags)
>  			klp_update_patch_state(current);
>
>  		/* deal with pending signal delivery */
> -		if (cached_flags & _TIF_SIGPENDING)
> +		if (cached_flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
>  			do_signal(regs);

...

> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2877,6 +2877,7 @@ int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
>
>  	*oldset = current->blocked;
>  	set_current_blocked(set);
> +	set_thread_flag(TIF_RESTORE_SIGMASK);

This will re-introduce the problem fixed by the previous patch.

Yes, do_signal() does restore_saved_sigmask() at the end, but only if
get_signal() returns false.

This means that restore_saved_sigmask()->set_current_blocked(saved_mask) should
restore ->blocked (and may be clear TIF_SIGPENDING) before ret-from-syscall.

Or I misunderstood?

Oleg.


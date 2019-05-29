Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B952E2A3
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 18:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfE2Q5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 12:57:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39402 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbfE2Q5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 12:57:24 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0B2E885538;
        Wed, 29 May 2019 16:57:23 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id D39945C1A1;
        Wed, 29 May 2019 16:57:18 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Wed, 29 May 2019 18:57:22 +0200 (CEST)
Date:   Wed, 29 May 2019 18:57:18 +0200
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
Message-ID: <20190529165717.GC27659@redhat.com>
References: <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com>
 <20190523163604.GE23070@redhat.com>
 <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com>
 <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
 <20190524141054.GB2655@redhat.com>
 <CABeXuvqSzy+v=3Y5NnMmfob7bvuNkafmdDqoex8BVENN3atqZA@mail.gmail.com>
 <20190524163310.GG2655@redhat.com>
 <CABeXuvrUKZnECj+NgLdpe5uhKBEmSynrakD-3q9XHqk8Aef5UQ@mail.gmail.com>
 <20190527150409.GA8961@redhat.com>
 <CABeXuvouBzZuNarmNcd9JgZgvonL1N_p21gat=O_x0-1hMx=6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABeXuvouBzZuNarmNcd9JgZgvonL1N_p21gat=O_x0-1hMx=6A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 29 May 2019 16:57:24 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/28, Deepa Dinamani wrote:
>
> I agree that signal handller being called and return value not being
> altered is an issue with other syscalls also. I was just wondering if
> some userspace code assumption would be assuming this. This is not a
> kernel bug.
>
> But, I do not think we have an understanding of what was wrong in
> 854a6ed56839a anymore since you pointed out that my assumption was not
> correct that the signal handler being called without errno being set
> is wrong.

Deepa, sorry, I simply can't parse the above... most probably because of
my bad English.

> One open question: this part of epoll_pwait was already broken before
> 854a6ed56839a. Do you agree?
>
> if (err == -EINTR) {
>                    memcpy(&current->saved_sigmask, &sigsaved,
>                           sizeof(sigsaved));
>                     set_restore_sigmask();
>   } else
>                    set_current_blocked(&sigsaved);

I do not understand why do you think this part was broken :/

> Or, I could revert the signal_pending() check and provide a fix
> something like below(not a complete patch)

...

> -void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
> +int restore_user_sigmask(const void __user *usigmask, sigset_t
> *sigsaved, int sig_pending)
>  {
> 
>         if (!usigmask)
>                return;
> 
>         /*
>          * When signals are pending, do not restore them here.
>          * Restoring sigmask here can lead to delivering signals that the above
>          * syscalls are intended to block because of the sigmask passed in.
>          */
> +       if (sig_pending) {
>                 current->saved_sigmask = *sigsaved;
>                 set_restore_sigmask();
>                return;
>            }
> 
> @@ -2330,7 +2330,8 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct
> epoll_event __user *, events,
> 
>         error = do_epoll_wait(epfd, events, maxevents, timeout);
> 
> -       restore_user_sigmask(sigmask, &sigsaved);
> +       signal_detected = restore_user_sigmask(sigmask, &sigsaved,
> error == -EINTR);

I fail to understand this pseudo-code, sorry. In particular, do not understand
why restore_user_sigmask() needs to return a boolean.

The only thing I _seem to_ understand is the "sig_pending" flag passed by the
caller which replaces the signal_pending() check. Yes, this is what I think we
should do, and this is what I tried to propose from the very beginning in my
1st email in this thread.

Oleg.


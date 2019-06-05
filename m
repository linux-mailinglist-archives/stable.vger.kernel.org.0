Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1875F3599E
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 11:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfFEJZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 05:25:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54579 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbfFEJZc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jun 2019 05:25:32 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AAA2283F51;
        Wed,  5 Jun 2019 09:25:27 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id F0156600CC;
        Wed,  5 Jun 2019 09:25:18 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Wed,  5 Jun 2019 11:25:26 +0200 (CEST)
Date:   Wed, 5 Jun 2019 11:25:17 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Linus Torvalds' <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Davidlohr Bueso <dbueso@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "e@80x24.org" <e@80x24.org>, Jason Baron <jbaron@akamai.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "omar.kilani@gmail.com" <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] signal: remove the wrong signal_pending() check in
 restore_user_sigmask()
Message-ID: <20190605092516.GC32406@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
 <20190604134117.GA29963@redhat.com>
 <CAHk-=wjSOh5zmApq2qsNjmY-GMn4CWe9YwdcKPjT+nVoGiDKOQ@mail.gmail.com>
 <263d0e478ee447d9aa10baab0d8673a5@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <263d0e478ee447d9aa10baab0d8673a5@AcuMS.aculab.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 05 Jun 2019 09:25:32 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/05, David Laight wrote:
>
> epoll() would have:
> 	if (restore_user_sigmask(xxx.sigmask, &sigsaved, !ret || ret == -EINTR))
> 		ret = -EINTR;

I don't think so but lets discuss this later.

> I also think it could be simplified if code that loaded the 'user sigmask'
> saved the old one in 'current->saved_sigmask' (and saved that it had done it).
> You'd not need 'sigsaved' nor pass the user sigmask address into
> the restore function.

Heh. apparently you do not read my emails ;)

This is what I proposed in my very 1st email, and I even showed the patch
and the code with the patch applied twice. Let me do this again.

Let me show the code with the patch applied. I am using epoll_pwait() as an
example because it looks very simple.


	static inline void set_restore_sigmask(void)
	{
// WARN_ON(!TIF_SIGPENDING) was removed by this patch
		current->restore_sigmask = true;
	}

	int set_xxx(const sigset_t __user *umask, size_t sigsetsize)
	{
		sigset_t *kmask;

		if (!umask)
			return 0;
		if (sigsetsize != sizeof(sigset_t))
			return -EINVAL;
		if (copy_from_user(kmask, umask, sizeof(sigset_t)))
			return -EFAULT;

// we can safely modify ->saved_sigmask/restore_sigmask, they has no meaning
// until the syscall returns.
		set_restore_sigmask();
		current->saved_sigmask = current->blocked;
		set_current_blocked(kmask);

		return 0;
	}


	void update_xxx(bool interrupted)
	{
// the main reason for this helper is WARN_ON(!TIF_SIGPENDING) which was "moved"
// from set_restore_sigmask() above.
		if (interrupted)
			WARN_ON(!test_thread_flag(TIF_SIGPENDING));
		else
			restore_saved_sigmask();
	}

	SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
			int, maxevents, int, timeout, const sigset_t __user *, sigmask,
			size_t, sigsetsize)
	{
		int error;

		error = set_xxx(sigmask, sigsetsize);
		if (error)
			return error;

		error = do_epoll_wait(epfd, events, maxevents, timeout);
		update_xxx(error == -EINTR);

		return error;
	}

Oleg.


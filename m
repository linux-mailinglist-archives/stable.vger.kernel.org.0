Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8588934C48
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 17:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbfFDPbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 11:31:55 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34542 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728030AbfFDPbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 11:31:55 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hYBPj-0002XI-4f; Tue, 04 Jun 2019 09:31:51 -0600
Received: from ip72-206-97-68.om.om.cox.net ([72.206.97.68] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hYBPh-0007V2-Fr; Tue, 04 Jun 2019 09:31:50 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, arnd@arndb.de, dbueso@suse.de,
        axboe@kernel.dk, dave@stgolabs.net, e@80x24.org, jbaron@akamai.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        omar.kilani@gmail.com, tglx@linutronix.de, stable@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Laight <David.Laight@ACULAB.COM>,
        <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
        <20190529161157.GA27659@redhat.com>
        <20190604134117.GA29963@redhat.com>
Date:   Tue, 04 Jun 2019 10:31:41 -0500
In-Reply-To: <20190604134117.GA29963@redhat.com> (Oleg Nesterov's message of
        "Tue, 4 Jun 2019 15:41:17 +0200")
Message-ID: <87tvd5nz8i.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hYBPh-0007V2-Fr;;;mid=<87tvd5nz8i.fsf@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=72.206.97.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18JqAu4Gol4nYpDPJY9T1kkLCifzkJMxgQ=
X-SA-Exim-Connect-IP: 72.206.97.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_XMDrugObfuBody_08,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  1.0 T_XMDrugObfuBody_08 obfuscated drug references
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1133 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 13 (1.1%), b_tie_ro: 1.79 (0.2%), parse: 2.1
        (0.2%), extract_message_metadata: 24 (2.1%), get_uri_detail_list: 7
        (0.6%), tests_pri_-1000: 24 (2.1%), tests_pri_-950: 1.74 (0.2%),
        tests_pri_-900: 1.35 (0.1%), tests_pri_-90: 53 (4.7%), check_bayes: 51
        (4.5%), b_tokenize: 23 (2.0%), b_tok_get_all: 13 (1.1%), b_comp_prob:
        6 (0.5%), b_tok_touch_all: 6 (0.5%), b_finish: 1.01 (0.1%),
        tests_pri_0: 997 (88.0%), check_dkim_signature: 1.10 (0.1%),
        check_dkim_adsp: 2.5 (0.2%), poll_dns_idle: 0.36 (0.0%), tests_pri_10:
        2.3 (0.2%), tests_pri_500: 10 (0.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] signal: remove the wrong signal_pending() check in restore_user_sigmask()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> This is the minimal fix for stable, I'll send cleanups later.
>
> The commit 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal: Add
> restore_user_sigmask()") introduced the visible change which breaks
> user-space: a signal temporary unblocked by set_user_sigmask() can
> be delivered even if the caller returns success or timeout.
>
> Change restore_user_sigmask() to accept the additional "interrupted"
> argument which should be used instead of signal_pending() check, and
> update the callers.
>
> Reported-by: Eric Wong <e@80x24.org>
> Fixes: 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal: Add restore_user_sigmask()")
> cc: stable@vger.kernel.org (v5.0+)
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

I have read through the patch and it looks good.

For clarity.  I don't think this is required by posix, or fundamentally
to remove the races in select.  It is what linux has always done and
we have applications who care so I agree this fix is needed.

Further in any case where the semantic change that this patch rolls back
(aka where allowing a signal to be delivered and the select like call to
complete) would be advantage we can do as well if not better by using
signalfd.

Michael is there any chance we can get this guarantee of the linux
implementation of pselect and friends clearly documented.  The guarantee
that if the system call completes successfully we are guaranteed that
no signal that is unblocked by using sigmask will be delivered?

Eric

> ---
>  fs/aio.c               | 28 ++++++++++++++++++++--------
>  fs/eventpoll.c         |  4 ++--
>  fs/io_uring.c          |  7 ++++---
>  fs/select.c            | 18 ++++++------------
>  include/linux/signal.h |  2 +-
>  kernel/signal.c        |  5 +++--
>  6 files changed, 36 insertions(+), 28 deletions(-)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 3490d1f..c1e581d 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -2095,6 +2095,7 @@ SYSCALL_DEFINE6(io_pgetevents,
>  	struct __aio_sigset	ksig = { NULL, };
>  	sigset_t		ksigmask, sigsaved;
>  	struct timespec64	ts;
> +	bool interrupted;
>  	int ret;
>  
>  	if (timeout && unlikely(get_timespec64(&ts, timeout)))
> @@ -2108,8 +2109,10 @@ SYSCALL_DEFINE6(io_pgetevents,
>  		return ret;
>  
>  	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
> -	restore_user_sigmask(ksig.sigmask, &sigsaved);
> -	if (signal_pending(current) && !ret)
> +
> +	interrupted = signal_pending(current);
> +	restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
> +	if (interrupted && !ret)
>  		ret = -ERESTARTNOHAND;
>  
>  	return ret;
> @@ -2128,6 +2131,7 @@ SYSCALL_DEFINE6(io_pgetevents_time32,
>  	struct __aio_sigset	ksig = { NULL, };
>  	sigset_t		ksigmask, sigsaved;
>  	struct timespec64	ts;
> +	bool interrupted;
>  	int ret;
>  
>  	if (timeout && unlikely(get_old_timespec32(&ts, timeout)))
> @@ -2142,8 +2146,10 @@ SYSCALL_DEFINE6(io_pgetevents_time32,
>  		return ret;
>  
>  	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
> -	restore_user_sigmask(ksig.sigmask, &sigsaved);
> -	if (signal_pending(current) && !ret)
> +
> +	interrupted = signal_pending(current);
> +	restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
> +	if (interrupted && !ret)
>  		ret = -ERESTARTNOHAND;
>  
>  	return ret;
> @@ -2193,6 +2199,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
>  	struct __compat_aio_sigset ksig = { NULL, };
>  	sigset_t ksigmask, sigsaved;
>  	struct timespec64 t;
> +	bool interrupted;
>  	int ret;
>  
>  	if (timeout && get_old_timespec32(&t, timeout))
> @@ -2206,8 +2213,10 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
>  		return ret;
>  
>  	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
> -	restore_user_sigmask(ksig.sigmask, &sigsaved);
> -	if (signal_pending(current) && !ret)
> +
> +	interrupted = signal_pending(current);
> +	restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
> +	if (interrupted && !ret)
>  		ret = -ERESTARTNOHAND;
>  
>  	return ret;
> @@ -2226,6 +2235,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
>  	struct __compat_aio_sigset ksig = { NULL, };
>  	sigset_t ksigmask, sigsaved;
>  	struct timespec64 t;
> +	bool interrupted;
>  	int ret;
>  
>  	if (timeout && get_timespec64(&t, timeout))
> @@ -2239,8 +2249,10 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
>  		return ret;
>  
>  	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
> -	restore_user_sigmask(ksig.sigmask, &sigsaved);
> -	if (signal_pending(current) && !ret)
> +
> +	interrupted = signal_pending(current);
> +	restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
> +	if (interrupted && !ret)
>  		ret = -ERESTARTNOHAND;
>  
>  	return ret;
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index c6f5131..4c74c76 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -2325,7 +2325,7 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
>  
>  	error = do_epoll_wait(epfd, events, maxevents, timeout);
>  
> -	restore_user_sigmask(sigmask, &sigsaved);
> +	restore_user_sigmask(sigmask, &sigsaved, error == -EINTR);
>  
>  	return error;
>  }
> @@ -2350,7 +2350,7 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
>  
>  	err = do_epoll_wait(epfd, events, maxevents, timeout);
>  
> -	restore_user_sigmask(sigmask, &sigsaved);
> +	restore_user_sigmask(sigmask, &sigsaved, err == -EINTR);
>  
>  	return err;
>  }
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 0fbb486..1147c5d 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2201,11 +2201,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  	}
>  
>  	ret = wait_event_interruptible(ctx->wait, io_cqring_events(ring) >= min_events);
> -	if (ret == -ERESTARTSYS)
> -		ret = -EINTR;
>  
>  	if (sig)
> -		restore_user_sigmask(sig, &sigsaved);
> +		restore_user_sigmask(sig, &sigsaved, ret == -ERESTARTSYS);
> +
> +	if (ret == -ERESTARTSYS)
> +		ret = -EINTR;
>  
>  	return READ_ONCE(ring->r.head) == READ_ONCE(ring->r.tail) ? ret : 0;
>  }
> diff --git a/fs/select.c b/fs/select.c
> index 6cbc9ff..a4d8f6e 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -758,10 +758,9 @@ static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
>  		return ret;
>  
>  	ret = core_sys_select(n, inp, outp, exp, to);
> +	restore_user_sigmask(sigmask, &sigsaved, ret == -ERESTARTNOHAND);
>  	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
>  
> -	restore_user_sigmask(sigmask, &sigsaved);
> -
>  	return ret;
>  }
>  
> @@ -1106,8 +1105,7 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
>  
>  	ret = do_sys_poll(ufds, nfds, to);
>  
> -	restore_user_sigmask(sigmask, &sigsaved);
> -
> +	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
>  	/* We can restart this syscall, usually */
>  	if (ret == -EINTR)
>  		ret = -ERESTARTNOHAND;
> @@ -1142,8 +1140,7 @@ SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds, unsigned int, nfds,
>  
>  	ret = do_sys_poll(ufds, nfds, to);
>  
> -	restore_user_sigmask(sigmask, &sigsaved);
> -
> +	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
>  	/* We can restart this syscall, usually */
>  	if (ret == -EINTR)
>  		ret = -ERESTARTNOHAND;
> @@ -1350,10 +1347,9 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
>  		return ret;
>  
>  	ret = compat_core_sys_select(n, inp, outp, exp, to);
> +	restore_user_sigmask(sigmask, &sigsaved, ret == -ERESTARTNOHAND);
>  	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
>  
> -	restore_user_sigmask(sigmask, &sigsaved);
> -
>  	return ret;
>  }
>  
> @@ -1425,8 +1421,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds,
>  
>  	ret = do_sys_poll(ufds, nfds, to);
>  
> -	restore_user_sigmask(sigmask, &sigsaved);
> -
> +	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
>  	/* We can restart this syscall, usually */
>  	if (ret == -EINTR)
>  		ret = -ERESTARTNOHAND;
> @@ -1461,8 +1456,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time64, struct pollfd __user *, ufds,
>  
>  	ret = do_sys_poll(ufds, nfds, to);
>  
> -	restore_user_sigmask(sigmask, &sigsaved);
> -
> +	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
>  	/* We can restart this syscall, usually */
>  	if (ret == -EINTR)
>  		ret = -ERESTARTNOHAND;
> diff --git a/include/linux/signal.h b/include/linux/signal.h
> index 9702016..78c2bb3 100644
> --- a/include/linux/signal.h
> +++ b/include/linux/signal.h
> @@ -276,7 +276,7 @@ extern int sigprocmask(int, sigset_t *, sigset_t *);
>  extern int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
>  	sigset_t *oldset, size_t sigsetsize);
>  extern void restore_user_sigmask(const void __user *usigmask,
> -				 sigset_t *sigsaved);
> +				 sigset_t *sigsaved, bool interrupted);
>  extern void set_current_blocked(sigset_t *);
>  extern void __set_current_blocked(const sigset_t *);
>  extern int show_unhandled_signals;
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 328a01e..aa6a6f1 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2912,7 +2912,8 @@ EXPORT_SYMBOL(set_compat_user_sigmask);
>   * This is useful for syscalls such as ppoll, pselect, io_pgetevents and
>   * epoll_pwait where a new sigmask is passed in from userland for the syscalls.
>   */
> -void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
> +void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved,
> +				bool interrupted)
>  {
>  
>  	if (!usigmask)
> @@ -2922,7 +2923,7 @@ void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
>  	 * Restoring sigmask here can lead to delivering signals that the above
>  	 * syscalls are intended to block because of the sigmask passed in.
>  	 */
> -	if (signal_pending(current)) {
> +	if (interrupted) {
>  		current->saved_sigmask = *sigsaved;
>  		set_restore_sigmask();
>  		return;

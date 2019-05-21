Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF6324B6A
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 11:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfEUJZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 05:25:53 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:51100 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbfEUJZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 05:25:53 -0400
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 7773F1F462;
        Tue, 21 May 2019 09:25:51 +0000 (UTC)
Date:   Tue, 21 May 2019 09:25:51 +0000
From:   Eric Wong <e@80x24.org>
To:     Deepa Dinamani <deepa.kernel@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        arnd@arndb.de, dbueso@suse.de, axboe@kernel.dk, dave@stgolabs.net,
        jbaron@akamai.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, omar.kilani@gmail.com, tglx@linutronix.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] signal: Adjust error codes according to
 restore_user_sigmask()
Message-ID: <20190521092551.fwtb6recko3tahwj@dcvr>
References: <20190507043954.9020-1-deepa.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190507043954.9020-1-deepa.kernel@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's been 2 weeks and this fix hasn't appeared in mmots / mmotm.
I also noticed it's missing Cc: for stable@ (below)

Deepa Dinamani <deepa.kernel@gmail.com> wrote:
> For all the syscalls that receive a sigmask from the userland,
> the user sigmask is to be in effect through the syscall execution.
> At the end of syscall, sigmask of the current process is restored
> to what it was before the switch over to user sigmask.
> But, for this to be true in practice, the sigmask should be restored
> only at the the point we change the saved_sigmask. Anything before
> that loses signals. And, anything after is just pointless as the
> signal is already lost by restoring the sigmask.
> 
> The inherent issue was detected because of a regression caused by
> 854a6ed56839a.
> The patch moved the signal_pending() check closer to restoring of the
> user sigmask. But, it failed to update the error code accordingly.
> 
> Detailed issue discussion permalink:
> https://lore.kernel.org/linux-fsdevel/20190427093319.sgicqik2oqkez3wk@dcvr/
> 
> Note that the patch returns interrupted errors (EINTR, ERESTARTNOHAND,
> etc) only when there is no other error. If there is a signal and an error
> like EINVAL, the syscalls return -EINVAL rather than the interrupted
> error codes.
> 
> The sys_io_uring_enter() seems to be returning success when there is
> a signal and the queue is not empty. This seems to be a bug. I will
> follow up with a separate patch for that.
> 
> Reported-by: Eric Wong <e@80x24.org>
> Fixes: 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal: Add restore_user_sigmask()")
> Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
> Reviewed-by: Davidlohr Bueso <dbueso@suse.de>

Cc: <stable@vger.kernel.org> # 5.0.x
Cc: <stable@vger.kernel.org> # 5.1.x

> ---
> 
>  fs/aio.c               | 24 ++++++++++++------------
>  fs/eventpoll.c         | 14 ++++++++++----
>  fs/io_uring.c          |  9 ++++++---
>  fs/select.c            | 37 +++++++++++++++++++++----------------
>  include/linux/signal.h |  2 +-
>  kernel/signal.c        | 13 ++++++++++---
>  6 files changed, 60 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 3490d1fa0e16..ebd2b1980161 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -2095,7 +2095,7 @@ SYSCALL_DEFINE6(io_pgetevents,
>  	struct __aio_sigset	ksig = { NULL, };
>  	sigset_t		ksigmask, sigsaved;
>  	struct timespec64	ts;
> -	int ret;
> +	int ret, signal_detected;
>  
>  	if (timeout && unlikely(get_timespec64(&ts, timeout)))
>  		return -EFAULT;
> @@ -2108,8 +2108,8 @@ SYSCALL_DEFINE6(io_pgetevents,
>  		return ret;
>  
>  	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
> -	restore_user_sigmask(ksig.sigmask, &sigsaved);
> -	if (signal_pending(current) && !ret)
> +	signal_detected = restore_user_sigmask(ksig.sigmask, &sigsaved);
> +	if (signal_detected && !ret)
>  		ret = -ERESTARTNOHAND;
>  
>  	return ret;
> @@ -2128,7 +2128,7 @@ SYSCALL_DEFINE6(io_pgetevents_time32,
>  	struct __aio_sigset	ksig = { NULL, };
>  	sigset_t		ksigmask, sigsaved;
>  	struct timespec64	ts;
> -	int ret;
> +	int ret, signal_detected;
>  
>  	if (timeout && unlikely(get_old_timespec32(&ts, timeout)))
>  		return -EFAULT;
> @@ -2142,8 +2142,8 @@ SYSCALL_DEFINE6(io_pgetevents_time32,
>  		return ret;
>  
>  	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
> -	restore_user_sigmask(ksig.sigmask, &sigsaved);
> -	if (signal_pending(current) && !ret)
> +	signal_detected = restore_user_sigmask(ksig.sigmask, &sigsaved);
> +	if (signal_detected && !ret)
>  		ret = -ERESTARTNOHAND;
>  
>  	return ret;
> @@ -2193,7 +2193,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
>  	struct __compat_aio_sigset ksig = { NULL, };
>  	sigset_t ksigmask, sigsaved;
>  	struct timespec64 t;
> -	int ret;
> +	int ret, signal_detected;
>  
>  	if (timeout && get_old_timespec32(&t, timeout))
>  		return -EFAULT;
> @@ -2206,8 +2206,8 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
>  		return ret;
>  
>  	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
> -	restore_user_sigmask(ksig.sigmask, &sigsaved);
> -	if (signal_pending(current) && !ret)
> +	signal_detected = restore_user_sigmask(ksig.sigmask, &sigsaved);
> +	if (signal_detected && !ret)
>  		ret = -ERESTARTNOHAND;
>  
>  	return ret;
> @@ -2226,7 +2226,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
>  	struct __compat_aio_sigset ksig = { NULL, };
>  	sigset_t ksigmask, sigsaved;
>  	struct timespec64 t;
> -	int ret;
> +	int ret, signal_detected;
>  
>  	if (timeout && get_timespec64(&t, timeout))
>  		return -EFAULT;
> @@ -2239,8 +2239,8 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
>  		return ret;
>  
>  	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
> -	restore_user_sigmask(ksig.sigmask, &sigsaved);
> -	if (signal_pending(current) && !ret)
> +	signal_detected = restore_user_sigmask(ksig.sigmask, &sigsaved);
> +	if (signal_detected && !ret)
>  		ret = -ERESTARTNOHAND;
>  
>  	return ret;
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 4a0e98d87fcc..fe5a0724b417 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -2317,7 +2317,7 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
>  		int, maxevents, int, timeout, const sigset_t __user *, sigmask,
>  		size_t, sigsetsize)
>  {
> -	int error;
> +	int error, signal_detected;
>  	sigset_t ksigmask, sigsaved;
>  
>  	/*
> @@ -2330,7 +2330,10 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
>  
>  	error = do_epoll_wait(epfd, events, maxevents, timeout);
>  
> -	restore_user_sigmask(sigmask, &sigsaved);
> +	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
> +
> +	if (signal_detected && !error)
> +		error = -EINTR;
>  
>  	return error;
>  }
> @@ -2342,7 +2345,7 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
>  			const compat_sigset_t __user *, sigmask,
>  			compat_size_t, sigsetsize)
>  {
> -	long err;
> +	long err, signal_detected;
>  	sigset_t ksigmask, sigsaved;
>  
>  	/*
> @@ -2355,7 +2358,10 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
>  
>  	err = do_epoll_wait(epfd, events, maxevents, timeout);
>  
> -	restore_user_sigmask(sigmask, &sigsaved);
> +	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
> +
> +	if (signal_detected && !err)
> +		err = -EINTR;
>  
>  	return err;
>  }
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 452e35357865..8fd4710f371d 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2195,7 +2195,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  	struct io_cq_ring *ring = ctx->cq_ring;
>  	sigset_t ksigmask, sigsaved;
>  	DEFINE_WAIT(wait);
> -	int ret;
> +	int ret, signal_detected;
>  
>  	/* See comment at the top of this file */
>  	smp_rmb();
> @@ -2234,8 +2234,11 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  
>  	finish_wait(&ctx->wait, &wait);
>  
> -	if (sig)
> -		restore_user_sigmask(sig, &sigsaved);
> +	if (sig) {
> +		signal_detected = restore_user_sigmask(sig, &sigsaved);
> +		if (signal_detected && !ret)
> +			ret  = -EINTR;
> +	}
>  
>  	return READ_ONCE(ring->r.head) == READ_ONCE(ring->r.tail) ? ret : 0;
>  }
> diff --git a/fs/select.c b/fs/select.c
> index 6cbc9ff56ba0..da9cfea35159 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -732,7 +732,7 @@ static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
>  {
>  	sigset_t ksigmask, sigsaved;
>  	struct timespec64 ts, end_time, *to = NULL;
> -	int ret;
> +	int ret, signal_detected;
>  
>  	if (tsp) {
>  		switch (type) {
> @@ -760,7 +760,9 @@ static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
>  	ret = core_sys_select(n, inp, outp, exp, to);
>  	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
>  
> -	restore_user_sigmask(sigmask, &sigsaved);
> +	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
> +	if (signal_detected && !ret)
> +		ret = -EINTR;
>  
>  	return ret;
>  }
> @@ -1089,7 +1091,7 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
>  {
>  	sigset_t ksigmask, sigsaved;
>  	struct timespec64 ts, end_time, *to = NULL;
> -	int ret;
> +	int ret, signal_detected;
>  
>  	if (tsp) {
>  		if (get_timespec64(&ts, tsp))
> @@ -1106,10 +1108,10 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
>  
>  	ret = do_sys_poll(ufds, nfds, to);
>  
> -	restore_user_sigmask(sigmask, &sigsaved);
> +	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
>  
>  	/* We can restart this syscall, usually */
> -	if (ret == -EINTR)
> +	if (ret == -EINTR || (signal_detected && !ret))
>  		ret = -ERESTARTNOHAND;
>  
>  	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
> @@ -1125,7 +1127,7 @@ SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds, unsigned int, nfds,
>  {
>  	sigset_t ksigmask, sigsaved;
>  	struct timespec64 ts, end_time, *to = NULL;
> -	int ret;
> +	int ret, signal_detected;
>  
>  	if (tsp) {
>  		if (get_old_timespec32(&ts, tsp))
> @@ -1142,10 +1144,10 @@ SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds, unsigned int, nfds,
>  
>  	ret = do_sys_poll(ufds, nfds, to);
>  
> -	restore_user_sigmask(sigmask, &sigsaved);
> +	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
>  
>  	/* We can restart this syscall, usually */
> -	if (ret == -EINTR)
> +	if (ret == -EINTR || (signal_detected && !ret))
>  		ret = -ERESTARTNOHAND;
>  
>  	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
> @@ -1324,7 +1326,7 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
>  {
>  	sigset_t ksigmask, sigsaved;
>  	struct timespec64 ts, end_time, *to = NULL;
> -	int ret;
> +	int ret, signal_detected;
>  
>  	if (tsp) {
>  		switch (type) {
> @@ -1352,7 +1354,10 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
>  	ret = compat_core_sys_select(n, inp, outp, exp, to);
>  	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
>  
> -	restore_user_sigmask(sigmask, &sigsaved);
> +	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
> +
> +	if (signal_detected && !ret)
> +		ret = -EINTR;
>  
>  	return ret;
>  }
> @@ -1408,7 +1413,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds,
>  {
>  	sigset_t ksigmask, sigsaved;
>  	struct timespec64 ts, end_time, *to = NULL;
> -	int ret;
> +	int ret, signal_detected;
>  
>  	if (tsp) {
>  		if (get_old_timespec32(&ts, tsp))
> @@ -1425,10 +1430,10 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds,
>  
>  	ret = do_sys_poll(ufds, nfds, to);
>  
> -	restore_user_sigmask(sigmask, &sigsaved);
> +	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
>  
>  	/* We can restart this syscall, usually */
> -	if (ret == -EINTR)
> +	if (ret == -EINTR || (signal_detected && !ret))
>  		ret = -ERESTARTNOHAND;
>  
>  	ret = poll_select_copy_remaining(&end_time, tsp, PT_OLD_TIMESPEC, ret);
> @@ -1444,7 +1449,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time64, struct pollfd __user *, ufds,
>  {
>  	sigset_t ksigmask, sigsaved;
>  	struct timespec64 ts, end_time, *to = NULL;
> -	int ret;
> +	int ret, signal_detected;
>  
>  	if (tsp) {
>  		if (get_timespec64(&ts, tsp))
> @@ -1461,10 +1466,10 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time64, struct pollfd __user *, ufds,
>  
>  	ret = do_sys_poll(ufds, nfds, to);
>  
> -	restore_user_sigmask(sigmask, &sigsaved);
> +	signal_detected = restore_user_sigmask(sigmask, &sigsaved);
>  
>  	/* We can restart this syscall, usually */
> -	if (ret == -EINTR)
> +	if (ret == -EINTR || (signal_detected && !ret))
>  		ret = -ERESTARTNOHAND;
>  
>  	ret = poll_select_copy_remaining(&end_time, tsp, PT_TIMESPEC, ret);
> diff --git a/include/linux/signal.h b/include/linux/signal.h
> index 9702016734b1..1d36e8629edf 100644
> --- a/include/linux/signal.h
> +++ b/include/linux/signal.h
> @@ -275,7 +275,7 @@ extern int __group_send_sig_info(int, struct kernel_siginfo *, struct task_struc
>  extern int sigprocmask(int, sigset_t *, sigset_t *);
>  extern int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
>  	sigset_t *oldset, size_t sigsetsize);
> -extern void restore_user_sigmask(const void __user *usigmask,
> +extern int restore_user_sigmask(const void __user *usigmask,
>  				 sigset_t *sigsaved);
>  extern void set_current_blocked(sigset_t *);
>  extern void __set_current_blocked(const sigset_t *);
> diff --git a/kernel/signal.c b/kernel/signal.c
> index e46d527ff467..ea0321b70315 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2906,15 +2906,21 @@ EXPORT_SYMBOL(set_compat_user_sigmask);
>   * usigmask: sigmask passed in from userland.
>   * sigsaved: saved sigmask when the syscall started and changed the sigmask to
>   *           usigmask.
> + * returns 1 in case a pending signal is detected.
> + *
> + * Users of the api need to adjust their return values based on whether the
> + * signal was detected here. If a signal is detected, it is delivered to the
> + * userspace. So without an error like -EINTR, userspace might fail to
> + * adjust the flow of execution.
>   *
>   * This is useful for syscalls such as ppoll, pselect, io_pgetevents and
>   * epoll_pwait where a new sigmask is passed in from userland for the syscalls.
>   */
> -void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
> +int restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
>  {
>  
>  	if (!usigmask)
> -		return;
> +		return 0;
>  	/*
>  	 * When signals are pending, do not restore them here.
>  	 * Restoring sigmask here can lead to delivering signals that the above
> @@ -2923,7 +2929,7 @@ void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
>  	if (signal_pending(current)) {
>  		current->saved_sigmask = *sigsaved;
>  		set_restore_sigmask();
> -		return;
> +		return 1;
>  	}
>  
>  	/*
> @@ -2931,6 +2937,7 @@ void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
>  	 * saved_sigmask when signals are not pending.
>  	 */
>  	set_current_blocked(sigsaved);
> +	return 0;
>  }
>  EXPORT_SYMBOL(restore_user_sigmask);
>  
> -- 
> 2.17.1

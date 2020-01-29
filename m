Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A59E314C972
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 12:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgA2LSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 06:18:53 -0500
Received: from er-systems.de ([148.251.68.21]:36454 "EHLO er-systems.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgA2LSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jan 2020 06:18:53 -0500
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jan 2020 06:18:51 EST
Received: from localhost.localdomain (localhost [127.0.0.1])
        by er-systems.de (Postfix) with ESMTP id 195F0D60074;
        Wed, 29 Jan 2020 12:10:48 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on er-systems.de
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by er-systems.de (Postfix) with ESMTPS id ECFBAD60071;
        Wed, 29 Jan 2020 12:10:47 +0100 (CET)
Date:   Wed, 29 Jan 2020 12:10:47 +0100 (CET)
From:   Thomas Voegtle <tv@lio96.de>
X-X-Sender: thomas@er-systems.de
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        =?ISO-8859-15?Q?Christoph_B=F6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Steve French <smfrench@gmail.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        David Laight <David.Laight@ACULAB.COM>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 183/271] signal: Allow cifs and drbd to receive their
 terminating signals
In-Reply-To: <20200128135906.176803329@linuxfoundation.org>
Message-ID: <alpine.LSU.2.21.2001291201030.14408@er-systems.de>
References: <20200128135852.449088278@linuxfoundation.org> <20200128135906.176803329@linuxfoundation.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-74181308-696423667-1580296247=:14408"
X-Virus-Status: No
X-Virus-Checker-Version: clamassassin 1.2.4 with clamdscan / ClamAV 0.102.1/25709/Tue Jan 28 12:49:39 2020 signatures .
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---74181308-696423667-1580296247=:14408
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 28 Jan 2020, Greg Kroah-Hartman wrote:

> From: Eric W. Biederman <ebiederm@xmission.com>
>
> [ Upstream commit 33da8e7c814f77310250bb54a9db36a44c5de784 ]
>
> My recent to change to only use force_sig for a synchronous events
> wound up breaking signal reception cifs and drbd.  I had overlooked
> the fact that by default kthreads start out with all signals set to
> SIG_IGN.  So a change I thought was safe turned out to have made it
> impossible for those kernel thread to catch their signals.
>
> Reverting the work on force_sig is a bad idea because what the code
> was doing was very much a misuse of force_sig.  As the way force_sig
> ultimately allowed the signal to happen was to change the signal
> handler to SIG_DFL.  Which after the first signal will allow userspace
> to send signals to these kernel threads.  At least for
> wake_ack_receiver in drbd that does not appear actively wrong.
>
> So correct this problem by adding allow_kernel_signal that will allow
> signals whose siginfo reports they were sent by the kernel through,
> but will not allow userspace generated signals, and update cifs and
> drbd to call allow_kernel_signal in an appropriate place so that their
> thread can receive this signal.
>
> Fixing things this way ensures that userspace won't be able to send
> signals and cause problems, that it is clear which signals the
> threads are expecting to receive, and it guarantees that nothing
> else in the system will be affected.
>
> This change was partly inspired by similar cifs and drbd patches that
> added allow_signal.
>
> Reported-by: ronnie sahlberg <ronniesahlberg@gmail.com>
> Reported-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
> Tested-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Philipp Reisner <philipp.reisner@linbit.com>
> Cc: David Laight <David.Laight@ACULAB.COM>
> Fixes: 247bc9470b1e ("cifs: fix rmmod regression in cifs.ko caused by force_sig changes")
> Fixes: 72abe3bcf091 ("signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig")

These two commits come with that release, but...

> Fixes: fee109901f39 ("signal/drbd: Use send_sig not force_sig")
> Fixes: 3cf5d076fb4d ("signal: Remove task parameter from force_sig")

...these two commits not and were never added to 4.9.y.

Are these both really not needed?


     Thomas



> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> drivers/block/drbd/drbd_main.c |  2 ++
> fs/cifs/connect.c              |  2 +-
> include/linux/signal.h         | 15 ++++++++++++++-
> kernel/signal.c                |  5 +++++
> 4 files changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
> index f5c24459fc5c1..daa9cef96ec66 100644
> --- a/drivers/block/drbd/drbd_main.c
> +++ b/drivers/block/drbd/drbd_main.c
> @@ -332,6 +332,8 @@ static int drbd_thread_setup(void *arg)
> 		 thi->name[0],
> 		 resource->name);
>
> +	allow_kernel_signal(DRBD_SIGKILL);
> +	allow_kernel_signal(SIGXCPU);
> restart:
> 	retval = thi->function(thi);
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 7d46025d5e899..751bdde6515d5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -885,7 +885,7 @@ cifs_demultiplex_thread(void *p)
> 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
>
> 	set_freezable();
> -	allow_signal(SIGKILL);
> +	allow_kernel_signal(SIGKILL);
> 	while (server->tcpStatus != CifsExiting) {
> 		if (try_to_freeze())
> 			continue;
> diff --git a/include/linux/signal.h b/include/linux/signal.h
> index 5308304993bea..ffa58ff53e225 100644
> --- a/include/linux/signal.h
> +++ b/include/linux/signal.h
> @@ -313,6 +313,9 @@ extern void signal_setup_done(int failed, struct ksignal *ksig, int stepping);
> extern void exit_signals(struct task_struct *tsk);
> extern void kernel_sigaction(int, __sighandler_t);
>
> +#define SIG_KTHREAD ((__force __sighandler_t)2)
> +#define SIG_KTHREAD_KERNEL ((__force __sighandler_t)3)
> +
> static inline void allow_signal(int sig)
> {
> 	/*
> @@ -320,7 +323,17 @@ static inline void allow_signal(int sig)
> 	 * know it'll be handled, so that they don't get converted to
> 	 * SIGKILL or just silently dropped.
> 	 */
> -	kernel_sigaction(sig, (__force __sighandler_t)2);
> +	kernel_sigaction(sig, SIG_KTHREAD);
> +}
> +
> +static inline void allow_kernel_signal(int sig)
> +{
> +	/*
> +	 * Kernel threads handle their own signals. Let the signal code
> +	 * know signals sent by the kernel will be handled, so that they
> +	 * don't get silently dropped.
> +	 */
> +	kernel_sigaction(sig, SIG_KTHREAD_KERNEL);
> }
>
> static inline void disallow_signal(int sig)
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 30914b3c76b21..57fadbe69c2e6 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -79,6 +79,11 @@ static int sig_task_ignored(struct task_struct *t, int sig, bool force)
> 	    handler == SIG_DFL && !(force && sig_kernel_only(sig)))
> 		return 1;
>
> +	/* Only allow kernel generated signals to this kthread */
> +	if (unlikely((t->flags & PF_KTHREAD) &&
> +		     (handler == SIG_KTHREAD_KERNEL) && !force))
> +		return true;
> +
> 	return sig_handler_ignored(handler, sig);
> }
>
>
---74181308-696423667-1580296247=:14408--


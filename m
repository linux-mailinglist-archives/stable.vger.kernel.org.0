Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C5C2E4C7
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 20:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfE2SuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 14:50:13 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:59246 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbfE2SuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 14:50:13 -0400
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 645D01F462;
        Wed, 29 May 2019 18:50:12 +0000 (UTC)
Date:   Wed, 29 May 2019 18:50:12 +0000
From:   Eric Wong <e@80x24.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Oleg Nesterov' <oleg@redhat.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "dbueso@suse.de" <dbueso@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "dave@stgolabs.net" <dave@stgolabs.net>,
        "jbaron@akamai.com" <jbaron@akamai.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "omar.kilani@gmail.com" <omar.kilani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: pselect/etc semantics (Was: [PATCH v2] signal: Adjust error
 codes according to restore_user_sigmask())
Message-ID: <20190529185012.qqeqq4fsolprknrz@dcvr>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
 <b05cec7f9e8f457281e689576a7a360f@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b05cec7f9e8f457281e689576a7a360f@AcuMS.aculab.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

David Laight <David.Laight@ACULAB.COM> wrote:
> From: Oleg Nesterov
> > Sent: 29 May 2019 17:12
> > Al, Linus, Eric, please help.
> > 
> > The previous discussion was very confusing, we simply can not understand each
> > other.
> > 
> > To me everything looks very simple and clear, but perhaps I missed something
> > obvious? Please correct me.
> > 
> > I think that the following code is correct
> > 
> > 	int interrupted = 0;
> > 
> > 	void sigint_handler(int sig)
> > 	{
> > 		interrupted = 1;
> > 	}
> > 
> > 	int main(void)
> > 	{
> > 		sigset_t sigint, empty;
> > 
> > 		sigemptyset(&sigint);
> > 		sigaddset(&sigint, SIGINT);
> > 		sigprocmask(SIG_BLOCK, &sigint, NULL);
> > 
> > 		signal(SIGINT, sigint_handler);
> > 
> > 		sigemptyset(&empty);	// so pselect() unblocks SIGINT
> > 
> > 		ret = pselect(..., &empty);
>                                 ^^^^^ sigint
> > 
> > 		if (ret >= 0)		// sucess or timeout
> > 			assert(!interrupted);
> > 
> > 		if (interrupted)
> > 			assert(ret == -EINTR);
> > 	}
> > 
> > IOW, if pselect(sigmask) temporary unblocks SIGINT according to sigmask, this
> > signal should not be delivered if a ready fd was found or timeout. The signal
> > handle should only run if ret == -EINTR.
> 
> Personally I think that is wrong.
> Given code like the above that has:
> 		while (!interrupted) {
> 			pselect(..., &sigint);
> 			// process available data
> 		}
> 
> You want the signal handler to be executed even if one of the fds
> always has available data.
> Otherwise you can't interrupt a process that is always busy.

Agreed...  I believe cmogstored has always had a bug in the way
it uses epoll_pwait because it failed to check interrupts if:

a) an FD is ready + interrupt
b) epoll_pwait returns 0 on interrupt

The bug remains in userspace for a), which I will fix by adding
an interrupt check when an FD is ready.  The window is very
small for a) and difficult to trigger, and also in a rare code
path.

The b) case is the kernel bug introduced in 854a6ed56839a40f
("signal: Add restore_user_sigmask()").

I don't think there's any disagreement that b) is a kernel bug.

So the confusion is for a), and POSIX is not clear w.r.t. how
pselect/poll works when there's both FD readiness and an
interrupt.

Thus I'm inclined to believe *select/*poll/epoll_*wait should
follow POSIX read() semantics:

       If a read() is interrupted by a signal before it reads any data, it shall
       return −1 with errno set to [EINTR].

       If  a  read()  is  interrupted by a signal after it has successfully read
       some data, it shall return the number of bytes read.

> One option is to return -EINTR if a signal is pending when the mask
> is updated - before even looking at anything else.
>
> Signals that happen later on (eg after a timeout) need not be reported
> (until the next time around the loop).

I'm not sure that's necessary and it would cause delays in
signal handling.

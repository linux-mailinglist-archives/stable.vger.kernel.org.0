Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6182E298
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 18:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfE2Qyr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 29 May 2019 12:54:47 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:49303 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726373AbfE2Qyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 12:54:46 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-148-Bqtj4QOpPZGUSdn79nts1w-1; Wed, 29 May 2019 17:54:41 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 29 May 2019 17:54:40 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 29 May 2019 17:54:40 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Oleg Nesterov' <oleg@redhat.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "dbueso@suse.de" <dbueso@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "dave@stgolabs.net" <dave@stgolabs.net>,
        "e@80x24.org" <e@80x24.org>,
        "jbaron@akamai.com" <jbaron@akamai.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "omar.kilani@gmail.com" <omar.kilani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: pselect/etc semantics (Was: [PATCH v2] signal: Adjust error codes
 according to restore_user_sigmask())
Thread-Topic: pselect/etc semantics (Was: [PATCH v2] signal: Adjust error
 codes according to restore_user_sigmask())
Thread-Index: AQHVFjlRjDlHH6TU60ajIVKPNNmjrqaCR7xw
Date:   Wed, 29 May 2019 16:54:40 +0000
Message-ID: <b05cec7f9e8f457281e689576a7a360f@AcuMS.aculab.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
In-Reply-To: <20190529161157.GA27659@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: Bqtj4QOpPZGUSdn79nts1w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov
> Sent: 29 May 2019 17:12
> Al, Linus, Eric, please help.
> 
> The previous discussion was very confusing, we simply can not understand each
> other.
> 
> To me everything looks very simple and clear, but perhaps I missed something
> obvious? Please correct me.
> 
> I think that the following code is correct
> 
> 	int interrupted = 0;
> 
> 	void sigint_handler(int sig)
> 	{
> 		interrupted = 1;
> 	}
> 
> 	int main(void)
> 	{
> 		sigset_t sigint, empty;
> 
> 		sigemptyset(&sigint);
> 		sigaddset(&sigint, SIGINT);
> 		sigprocmask(SIG_BLOCK, &sigint, NULL);
> 
> 		signal(SIGINT, sigint_handler);
> 
> 		sigemptyset(&empty);	// so pselect() unblocks SIGINT
> 
> 		ret = pselect(..., &empty);
                                ^^^^^ sigint
> 
> 		if (ret >= 0)		// sucess or timeout
> 			assert(!interrupted);
> 
> 		if (interrupted)
> 			assert(ret == -EINTR);
> 	}
> 
> IOW, if pselect(sigmask) temporary unblocks SIGINT according to sigmask, this
> signal should not be delivered if a ready fd was found or timeout. The signal
> handle should only run if ret == -EINTR.

Personally I think that is wrong.
Given code like the above that has:
		while (!interrupted) {
			pselect(..., &sigint);
			// process available data
		}

You want the signal handler to be executed even if one of the fds
always has available data.
Otherwise you can't interrupt a process that is always busy.

One option is to return -EINTR if a signal is pending when the mask
is updated - before even looking at anything else.
Signals that happen later on (eg after a timeout) need not be reported
(until the next time around the loop).

> (pselect() can be interrupted by any other signal which has a handler. In this
>  case the handler can be called even if ret >= 0. This is correct, I fail to
>  understand why some people think this is wrong, and in any case we simply can't
>  avoid this).

You mean any signal that isn't blocked when pselect() is called....

> This was true until 854a6ed56839a ("signal: Add restore_user_sigmask()"),
> now this is broken by the signal_pending() check in restore_user_sigmask().
> 
> This patch https://lore.kernel.org/lkml/20190522032144.10995-1-deepa.kernel@gmail.com/
> turns 0 into -EINTR if signal_pending(), but I think we should simply restore
> the old behaviour and simplify the code.
> 
> See the compile-tested patch at the end. Of course, the new _xxx() helpers
> should be renamed somehow. fs/aio.c doesn't look right with or without this
> patch, but iiuc this is what it did before 854a6ed56839a.
> 
> Let me show the code with the patch applied. I am using epoll_pwait() as an
> example because it looks very simple.
> 
> 
> 	static inline void set_restore_sigmask(void)
> 	{
> // WARN_ON(!TIF_SIGPENDING) was removed by this patch
> 		current->restore_sigmask = true;
> 	}
> 
> 	int set_xxx(const sigset_t __user *umask, size_t sigsetsize)
> 	{
> 		sigset_t *kmask;
                     ^ no '*' here, add & before uses.
> 
> 		if (!umask)
> 			return 0;
> 		if (sigsetsize != sizeof(sigset_t))
> 			return -EINVAL;
> 		if (copy_from_user(kmask, umask, sizeof(sigset_t)))
> 			return -EFAULT;
> 
> // we can safely modify ->saved_sigmask/restore_sigmask, they has no meaning
> // until the syscall returns.
> 		set_restore_sigmask();
> 		current->saved_sigmask = current->blocked;
> 		set_current_blocked(kmask);
> 
> 		return 0;
> 	}
> 
> 
> 	void update_xxx(bool interrupted)
> 	{
> // the main reason for this helper is WARN_ON(!TIF_SIGPENDING) which was "moved"
> // from set_restore_sigmask() above.
> 		if (interrupted)
> 			WARN_ON(!test_thread_flag(TIF_SIGPENDING));
> 		else
> 			restore_saved_sigmask();
> 	}

I looked at the code earlier, but failed to find the code that actually
delivers the signals.
It may be 'racy' with update_xxx() regardless of whether that is
looking for -EINTR or just a pending signal.

I assume that TIF_SIGPENGING is used to (not) short-circuit the
system call return path so that signals get delivered.
So that it is important that update_xxx() calls restore_saved_sigmask()
if there is no signal pending.
(Although a signal can happen after the test - which can/will be ignored
until the signal is enabled again.)

restore_saved_sigmask() must itself be able to set TIF_SIGPENDING
(the inner sigmask could be more restrictive!).

If restore_saved_sigmask() isn't called here, the syscall return
path must do it after calling all the handlers and after clearing
TIF_SIGPENDING, and then call unmasked handlers again.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


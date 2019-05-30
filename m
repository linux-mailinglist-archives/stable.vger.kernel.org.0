Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F22A2FF47
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 17:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbfE3PS1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 30 May 2019 11:18:27 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:37508 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726106AbfE3PS0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 11:18:26 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-82-RoxVEz8lP36untm5FoSrBA-1; Thu, 30 May 2019 16:18:22 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 30 May 2019 16:18:21 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 30 May 2019 16:18:21 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Eric W. Biederman'" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
CC:     Deepa Dinamani <deepa.kernel@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Subject: RE: pselect/etc semantics
Thread-Topic: pselect/etc semantics
Thread-Index: AQHVFufSWpjj98PrdUiaI6VbWN/dmKaDr0MA
Date:   Thu, 30 May 2019 15:18:21 +0000
Message-ID: <9150b8cb8123426492a82e193f45229e@AcuMS.aculab.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
        <20190529161157.GA27659@redhat.com> <87woi8rt96.fsf@xmission.com>
In-Reply-To: <87woi8rt96.fsf@xmission.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: RoxVEz8lP36untm5FoSrBA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman
> Sent: 30 May 2019 14:01
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
> 
> There are two ways the semantics for a sigmask changing system call
> can be defined.  The naive way and by reading posix.  I will pick
> on pselect.
> 
> The naive way:
> int pselect(int nfds, fd_set *readfds, fd_set *writefds,
>             fd_set *exceptfds, const struct timespec *timeout,
>             const sigset_t *sigmask)
> {
>     sigset_t oldmask;
> 	int ret;
> 
>     if (sigmask)
> 		sigprocmask(SIG_SETMASK, sigmask, &oldmask);
> 
> 	ret = select(nfds, readfds, writefds, exceptfds, timeout);
> 
> 	if (sigmask)
> 		sigprocmask(SIG_SETMASK, &oldmask, NULL);
> 
>     return ret;
> }
> 
> The standard for pselect behavior at
> https://pubs.opengroup.org/onlinepubs/009695399/functions/pselect.html
> says:
> > If sigmask is not a null pointer, then the pselect() function shall
> > replace the signal mask of the caller by the set of signals pointed to
> > by sigmask before examining the descriptors, and shall restore the
> > signal mask of the calling thread before returning.

Right, but that bit says nothing about when signals are 'delivered'.
Section 2.4 of http://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html 
isn't very enlightening either - well, pretty impenetrable really. 
But since the ToG specs don't require a user-kernel boundary I believe
that the signal handler is expected to be called as soon as it is unmasked.

Now, for async signals, the kernel can always pretend that they happened
slightly later than they actually did.
So signal delivery is delayed until 'return to user'.
In some cases system calls are restarted to make the whole thing transparent.

For pselect() etc I think this means:

1) Signal handlers can only be called if EINTR is returned.
2) If a signal is deliverable after the mask is changed
   then the signal hander must be called.
   This means EINTR must be returned.
   ie this must be detected before checking anything else.
3) A signal that is raised after the wait completes can be
   'deemed' to have happened after the mask is restored
   and left masked until the applications next pselect() call.
4) As an optimisation a signal that arrives after the timer
   expires, but before the mask is restored can be 'deemed'
   to have happened before the timeout expired and EINTR
   returned.

Now not all system calls that use a temporary mask may want to
work that way.
In particular they may want to return 'success' and have the
signal handlers called.

So maybe the set_xxx() function that installs to user's mask
should return:
   -ve:   errno value
     0:   no signal pending
     1:   signal pending.

And the update_xxx() function that restores the saved mask
should take a parameter to indicate whether signal handlers
should be called maybe 'bool call_handlers' and return 0/1
depending on whether signals were pending.

pselect() then contains:
	rval = set_xxx();
	if (rval) {
		if (rval < 0)
			return rval;
		update_xxx(true);
		return -EINTR:
	}

	rval = wait....();

#if 0  // don't report late signals
	update_xxx(rval == -EINTR);
#else  // report signals after timeout
	if (update_xxx(!rval || rval == -EINTR))
		rval == -EINTR;
#endif

	return rval;
}

    David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


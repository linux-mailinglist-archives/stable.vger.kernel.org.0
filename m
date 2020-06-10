Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC721F508C
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 10:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgFJIsw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 10 Jun 2020 04:48:52 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:37621 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726931AbgFJIsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 04:48:50 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-161-0yN4TplFM4ieG9IIs6KTcQ-2; Wed, 10 Jun 2020 09:48:46 +0100
X-MC-Unique: 0yN4TplFM4ieG9IIs6KTcQ-2
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 10 Jun 2020 09:48:45 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 10 Jun 2020 09:48:45 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Sargun Dhillon' <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>
CC:     Christian Brauner <christian.brauner@ubuntu.com>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Robert Sesek <rsesek@google.com>,
        Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Denton <mpdenton@google.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Thread-Topic: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Thread-Index: AQHWPv7tCi14oegu0U6J73sUpcDiU6jRh/3w
Date:   Wed, 10 Jun 2020 08:48:45 +0000
Message-ID: <40d76a9a4525414a8c9809cd29a7ba8e@AcuMS.aculab.com>
References: <20200603011044.7972-2-sargun@sargun.me>
 <20200604012452.vh33nufblowuxfed@wittgenstein>
 <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
 <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
In-Reply-To: <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sargun Dhillon
> Sent: 10 June 2020 09:13
> 
> On Tue, Jun 09, 2020 at 10:27:54PM -0700, Kees Cook wrote:
> > On Tue, Jun 09, 2020 at 11:27:30PM +0200, Christian Brauner wrote:
> > > On June 9, 2020 10:55:42 PM GMT+02:00, Kees Cook <keescook@chromium.org> wrote:
> > > >LOL. And while we were debating this, hch just went and cleaned stuff up:
> > > >
> > > >2618d530dd8b ("net/scm: cleanup scm_detach_fds")
> > > >
> > > >So, um, yeah, now my proposal is actually even closer to what we already
> > > >have there. We just add the replace_fd() logic to __scm_install_fd() and
> > > >we're done with it.
> > >
> > > Cool, you have a link? :)
> >
> > How about this:
> >
> Thank you.
> >
> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=devel/seccomp/addfd/v3.1&id=b
> b94586b9e7cc88e915536c2e9fb991a97b62416
> >
> > --
> > Kees Cook
> 
> +		if (ufd) {
> +			error = put_user(new_fd, ufd);
> +			if (error) {
> +				put_unused_fd(new_fd);
> +				return error;
> +			}
> + 		}
> I'm fairly sure this introduces a bug[1] if the user does:
> 
> struct msghdr msg = {};
> struct cmsghdr *cmsg;
> struct iovec io = {
> 	.iov_base = &c,
> 	.iov_len = 1,
> };
> 
> msg.msg_iov = &io;
> msg.msg_iovlen = 1;
> msg.msg_control = NULL;
> msg.msg_controllen = sizeof(buf);
> 
> recvmsg(sock, &msg, 0);
> 
> They will have the FD installed, no error message, but FD number wont be written
> to memory AFAICT. If two FDs are passed, you will get an efault. They will both
> be installed, but memory wont be written to. Maybe instead of 0, make it a
> poison pointer, or -1 instead?

IMHO if the buffer isn't big enough the nothing should happen.
(or maybe a few of the fds be returned and the others left for later.)

OTOH if the user passed an invalid address then installing the fd
and returning EFAULT (and hence SIGSEGV) seems reasonable.
Properly written apps just don't do that.

In essence the 'copy_to_user' is done by the wrapper code.
The code filling in the CMSG buffer can be considered to be
writing a kernel buffer.

IIRC other kernels (eg NetBSD) do the copies for ioctl() requests
in the ioctl syscall wrapper.
The IOW/IOR/IOWR flags have to be right.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


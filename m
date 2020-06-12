Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B4F1F755F
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 10:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgFLIgK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 12 Jun 2020 04:36:10 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:44277 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726361AbgFLIgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 04:36:10 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-254-37IQVLyONZaErv1-cO8eWQ-1; Fri, 12 Jun 2020 09:36:04 +0100
X-MC-Unique: 37IQVLyONZaErv1-cO8eWQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 12 Jun 2020 09:36:03 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 12 Jun 2020 09:36:03 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kees Cook' <keescook@chromium.org>
CC:     'Sargun Dhillon' <sargun@sargun.me>,
        Christian Brauner <christian.brauner@ubuntu.com>,
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
Thread-Index: AQHWP+BcCi14oegu0U6J73sUpcDiU6jTfHDAgACI+YCAAKH2YA==
Date:   Fri, 12 Jun 2020 08:36:03 +0000
Message-ID: <94407449bedd4ba58d85446401ff0a42@AcuMS.aculab.com>
References: <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <202006101953.899EFB53@keescook>
 <20200611100114.awdjswsd7fdm2uzr@wittgenstein>
 <20200611110630.GB30103@ircssh-2.c.rugged-nimbus-611.internal>
 <067f494d55c14753a31657f958cb0a6e@AcuMS.aculab.com>
 <202006111634.8237E6A5C6@keescook>
In-Reply-To: <202006111634.8237E6A5C6@keescook>
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

From: Kees Cook
> Sent: 12 June 2020 00:50
> > From: Sargun Dhillon
> > > Sent: 11 June 2020 12:07
> > > Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to move fds across
> processes
> > >
> > > On Thu, Jun 11, 2020 at 12:01:14PM +0200, Christian Brauner wrote:
> > > > On Wed, Jun 10, 2020 at 07:59:55PM -0700, Kees Cook wrote:
> > > > > On Wed, Jun 10, 2020 at 08:12:38AM +0000, Sargun Dhillon wrote:
> > > > > > As an aside, all of this junk should be dropped:
> > > > > > +	ret = get_user(size, &uaddfd->size);
> > > > > > +	if (ret)
> > > > > > +		return ret;
> > > > > > +
> > > > > > +	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> > > > > > +	if (ret)
> > > > > > +		return ret;
> > > > > >
> > > > > > and the size member of the seccomp_notif_addfd struct. I brought this up
> > > > > > off-list with Tycho that ioctls have the size of the struct embedded in them. We
> > > > > > should just use that. The ioctl definition is based on this[2]:
> > > > > > #define _IOC(dir,type,nr,size) \
> > > > > > 	(((dir)  << _IOC_DIRSHIFT) | \
> > > > > > 	 ((type) << _IOC_TYPESHIFT) | \
> > > > > > 	 ((nr)   << _IOC_NRSHIFT) | \
> > > > > > 	 ((size) << _IOC_SIZESHIFT))
> > > > > >
> > > > > >
> > > > > > We should just use copy_from_user for now. In the future, we can either
> > > > > > introduce new ioctl names for new structs, or extract the size dynamically from
> > > > > > the ioctl (and mask it out on the switch statement in seccomp_notify_ioctl.
> > > > >
> > > > > Yeah, that seems reasonable. Here's the diff for that part:
> > > >
> > > > Why does it matter that the ioctl() has the size of the struct embedded
> > > > within? Afaik, the kernel itself doesn't do anything with that size. It
> > > > merely checks that the size is not pathological and it does so at
> > > > compile time.
> > > >
> > > > #ifdef __CHECKER__
> > > > #define _IOC_TYPECHECK(t) (sizeof(t))
> > > > #else
> > > > /* provoke compile error for invalid uses of size argument */
> > > > extern unsigned int __invalid_size_argument_for_IOC;
> > > > #define _IOC_TYPECHECK(t) \
> > > > 	((sizeof(t) == sizeof(t[1]) && \
> > > > 	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
> > > > 	  sizeof(t) : __invalid_size_argument_for_IOC)
> > > > #endif
> > > >
> > > > The size itself is not verified at runtime. copy_struct_from_user()
> > > > still makes sense at least if we're going to allow expanding the struct
> > > > in the future.
> > > Right, but if we simply change our headers and extend the struct, it will break
> > > all existing programs compiled against those headers. In order to avoid that, if
> > > we intend on extending this struct by appending to it, we need to have a
> > > backwards compatibility mechanism. Just having copy_struct_from_user isn't
> > > enough. The data structure either must be fixed size, or we need a way to handle
> > > multiple ioctl numbers derived from headers with different sized struct arguments
> > >
> > > The two approaches I see are:
> > > 1. use more indirection. This has previous art in drm[1]. That's look
> > > something like this:
> > >
> > > struct seccomp_notif_addfd_ptr {
> > > 	__u64 size;
> > > 	__u64 addr;
> > > }
> > >
> > > ... And then it'd be up to us to dereference the addr and copy struct from user.
> >
> > Do not go down that route. It isn't worth the pain.
> >
> > You should also assume that userspace might have a compile-time check
> > on the buffer length (I've written one - not hard) and that the kernel
> > might (in the future - or on a BSD kernel) be doing the user copies
> > for you.
> >
> > Also, if you change the structure you almost certainly need to
> > change the name of the ioctl cmd as well as its value.
> > Otherwise a recompiled program will pass the new cmd value (and
> > hopefully the right sized buffer) but it won't have initialised
> > the buffer properly.
> > This is likely to lead to unexpected behaviour.
> 
> Hmmm.
> 
> So, while initially I thought Sargun's observation about ioctl's fixed
> struct size was right, I think I've been swayed to Christian's view
> (which is supported by the long tail of struct size pain we've seen in
> other APIs).
> 
> Doing a separate ioctl for each structure version seems like the "old
> solution" now that we've got EA syscalls. So, I'd like to keep the size
> and copy_struct_from_user().

If the size is variable then why not get the application to fill
in the size of the structure it is sending at the time of the ioctl.

So you'd have:
#define xxx_IOCTL_17(param) _IOCW('X', 17, sizeof *(param))

The application code would then do:
	ioctl(fd, xxx_IOCTL_17(arg), arg);

The kernel code can either choose to have specific 'case'
for each size, or mask off the length bits and do the
length check later.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD95D1F7B25
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 17:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgFLPzU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 12 Jun 2020 11:55:20 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:52113 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbgFLPzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 11:55:19 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-256-WF26PnyoMeW0bYbJgCCLOA-1; Fri, 12 Jun 2020 16:55:15 +0100
X-MC-Unique: WF26PnyoMeW0bYbJgCCLOA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 12 Jun 2020 16:55:15 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 12 Jun 2020 16:55:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kees Cook' <keescook@chromium.org>,
        Sargun Dhillon <sargun@sargun.me>
CC:     Christian Brauner <christian.brauner@ubuntu.com>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Robert Sesek <rsesek@google.com>,
        Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Denton <mpdenton@google.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Thread-Topic: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Thread-Index: AQHWP+BcCi14oegu0U6J73sUpcDiU6jTfHDAgACI+YCAAKH2YIAAcPLvgAAKH6A=
Date:   Fri, 12 Jun 2020 15:55:14 +0000
Message-ID: <b598484958d140fc9f523e200490b942@AcuMS.aculab.com>
References: <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <202006101953.899EFB53@keescook>
 <20200611100114.awdjswsd7fdm2uzr@wittgenstein>
 <20200611110630.GB30103@ircssh-2.c.rugged-nimbus-611.internal>
 <067f494d55c14753a31657f958cb0a6e@AcuMS.aculab.com>
 <202006111634.8237E6A5C6@keescook>
 <94407449bedd4ba58d85446401ff0a42@AcuMS.aculab.com>
 <20200612104629.GA15814@ircssh-2.c.rugged-nimbus-611.internal>
 <202006120806.E770867EF@keescook>
In-Reply-To: <202006120806.E770867EF@keescook>
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
> Sent: 12 June 2020 16:13
...
> > 	/* Fixed size ioctls. Can be converted later on? */
> > 	switch (cmd) {
> > 	case SECCOMP_IOCTL_NOTIF_RECV:
> > 		return seccomp_notify_recv(filter, buf);
> > 	case SECCOMP_IOCTL_NOTIF_SEND:
> > 		return seccomp_notify_send(filter, buf);
> > 	case SECCOMP_IOCTL_NOTIF_ID_VALID:
> > 		return seccomp_notify_id_valid(filter, buf);
> > 	}
> >
> > 	/* Probably should make some nicer macros here */
> > 	switch (SIZE_MASK(DIR_MASK(cmd))) {
> > 	case SIZE_MASK(DIR_MASK(SECCOMP_IOCTL_NOTIF_ADDFD)):
> 
> Ah yeah, I like this because of what you mention below: it's forward
> compat too. (I'd just use the ioctl masks directly...)
> 
> 	switch (cmd & ~(_IOC_SIZEMASK | _IOC_DIRMASK))

Since you need the same mask on the case labels I think
I'd define a helper just across the switch statement:

#define M(cmd) ((cmd & ~(_IOC_SIZEMASK | _IOC_DIRMASK))
	switch (M(cmd)) {
	case M(SECCOMP_IOCTL_NOTIF_RECV):
	...
	}
#undef M

It is probably wrong to mask off DIRMASK.
But you might need to add extra case labels for
the broken one(s).

Prior to worries about indirect jumps you could
get a dense set of case label and faster code.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


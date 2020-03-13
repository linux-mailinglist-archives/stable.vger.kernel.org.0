Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7DA2184593
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 12:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgCMLGr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 13 Mar 2020 07:06:47 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:23301 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726426AbgCMLGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 07:06:46 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-80-gv2f1hCOODeqrgtDqydigQ-1; Fri, 13 Mar 2020 11:06:42 +0000
X-MC-Unique: gv2f1hCOODeqrgtDqydigQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 13 Mar 2020 11:06:42 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 13 Mar 2020 11:06:42 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Bruno Meneguele' <bmeneg@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "sergey.senozhatsky@gmail.com" <sergey.senozhatsky@gmail.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: RE: [PATCH] kernel/printk: add kmsg SEEK_CUR handling
Thread-Topic: [PATCH] kernel/printk: add kmsg SEEK_CUR handling
Thread-Index: AQHV+SbtOwT0X58SokiO9wU0er7wyahGXCjQ
Date:   Fri, 13 Mar 2020 11:06:42 +0000
Message-ID: <b9427c068f3f4af9bf2bd290d88f84b9@AcuMS.aculab.com>
References: <20200313003533.2203429-1-bmeneg@redhat.com>
 <20200313073425.GA219881@google.com> <20200313110229.GI13406@glitch>
In-Reply-To: <20200313110229.GI13406@glitch>
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

From: Bruno Meneguele
> Sent: 13 March 2020 11:02
> On Fri, Mar 13, 2020 at 04:34:25PM +0900, Sergey Senozhatsky wrote:
> > On (20/03/12 21:35), Bruno Meneguele wrote:
> > >
> > > Userspace libraries, e.g. glibc's dprintf(), expect the default return value
> > > for invalid seek situations: -ESPIPE, but when the IO was over /dev/kmsg the
> > > current state of kernel code was returning the generic case of an -EINVAL.
> > > Hence, userspace programs were not behaving as expected or documented.
> > >
> >
> > Hmm. I don't think I see ESPIPE in documentation [0], [1], [2]
> >
> > [0] https://pubs.opengroup.org/onlinepubs/9699919799/functions/fprintf.html
> > [1] http://man7.org/linux/man-pages/man3/dprintf.3p.html
> > [2] http://man7.org/linux/man-pages/man3/fprintf.3p.html
> >
> > 	-ss
> >
> 
> Ok, I poorly expressed the notion of "documentantion". The userspace
> doesn't tell about returning -ESPIPE, but to the functions work properly
> they watch for -ESPIPE returning from the syscall. For instance, gblic
> dprintf() implementation:
> 
> dprintf:
>   __vdprintf_internal:
>     _IO_new_file_attach:
> 
>   if (_IO_SEEKOFF (fp, (off64_t)0, _IO_seek_cur, _IOS_INPUT|_IOS_OUTPUT)
>       == _IO_pos_BAD && errno != ESPIPE)
>     return NULL;

Someone explain why it is doing an explicit seek to the current position?
The only reason to do that is to get the current offset.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


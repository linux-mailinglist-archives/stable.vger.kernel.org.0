Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93014362FA3
	for <lists+stable@lfdr.de>; Sat, 17 Apr 2021 13:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbhDQLj7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 17 Apr 2021 07:39:59 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:56945 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236078AbhDQLj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Apr 2021 07:39:58 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-286-5uilHBoVOxeAFJZU7Wda9w-1; Sat, 17 Apr 2021 12:39:29 +0100
X-MC-Unique: 5uilHBoVOxeAFJZU7Wda9w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Sat, 17 Apr 2021 12:39:29 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Sat, 17 Apr 2021 12:39:29 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Maciej W. Rozycki'" <macro@orcam.me.uk>,
        Joe Perches <joe@perches.com>
CC:     Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/5] scsi: BusLogic: Fix missing `pr_cont' use
Thread-Topic: [PATCH 1/5] scsi: BusLogic: Fix missing `pr_cont' use
Thread-Index: AQHXMq4Y+WsIhBBiNEu36L38d+a4baq4klBA
Date:   Sat, 17 Apr 2021 11:39:28 +0000
Message-ID: <6679310a77984cc0af9f48f5616b840c@AcuMS.aculab.com>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
  <alpine.DEB.2.21.2104141419040.44318@angie.orcam.me.uk>
 <787aae5540612555a8bf92de2083c8fa74e52ce9.camel@perches.com>
 <alpine.DEB.2.21.2104161224300.44318@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2104161224300.44318@angie.orcam.me.uk>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki
> Sent: 16 April 2021 11:49
> 
> On Thu, 15 Apr 2021, Joe Perches wrote:
> 
> > In patch 2, vscnprintf should probably be used to make sure it's
> > 0 terminated.
> 
>  Why?  C99 has this[1]:
> 
> "The vsnprintf function is equivalent to snprintf, with the variable
> argument list replaced by arg, which shall have been initialized by the
> va_start macro (and possibly subsequent va_arg calls)."

vscnprintf() is normally the function you want (not vsnprintf())
because the return value is the number of characters actually
put into the buffer, not the number that would have been written
had the buffer been long enough.
Return values larger than the buffer size are almost never
allowed for - and are probably a set of 'buffer overflow' bugs.

While probably justified by saying that it lets you malloc()
a big enough buffer and try again, the return value is almost
certainly just historic.

The original sprintf() libc code allocated a FILE structure on
stack set to fully-buffered with the current buffer pointer set
to the caller's buffer and a buffer length of MAXINT.
It then just called vprintf() to do the work.

snprintf() was done the same way, except the buffer length was
set and the 'write character' (or 'flush buffer') function
intercepted to avoid writes beyond the buffer end.
(Possibly by re-routing the writes to a global buffer.)
The return value from vprintf() gets returned to the user.

The Unix versions have always '\0' terminated the buffer.
Only Microsoft has ever released an snprintf() that doesn't
'\0' terminate the output - another source of bugs.

Personally I think bounded string functions should
return the buffer size on overflow.
This means sequences of:
	offset += xxx(buf + offset, sizeof buf - offset, ...);
are safe and the overflow can be detected right at the end.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1933EC378F
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 16:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388925AbfJAOgO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 1 Oct 2019 10:36:14 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:40099 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387781AbfJAOgN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 10:36:13 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-217-OO_eyhEkOW2W7nALFS7WXw-1; Tue, 01 Oct 2019 15:36:10 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 1 Oct 2019 15:36:09 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 1 Oct 2019 15:36:09 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Dan Carpenter' <dan.carpenter@oracle.com>,
        Denis Efremov <efremov@linux.com>
CC:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: RE: [PATCH] staging: rtl8723bs: hal: Fix memcpy calls
Thread-Topic: [PATCH] staging: rtl8723bs: hal: Fix memcpy calls
Thread-Index: AQHVd36LU5ikVLKK6EuvH5wLNYQtMKdEMyLwgAGeKE+AAAh2kA==
Date:   Tue, 1 Oct 2019 14:36:09 +0000
Message-ID: <8d2e8196cae74ec4ae20e9c23e898207@AcuMS.aculab.com>
References: <20190930110141.29271-1-efremov@linux.com>
 <37b195b700394e95aa8329afc9f60431@AcuMS.aculab.com>
 <e4051dcb-10dc-ff17-ec0b-6f51dccdb5bf@linux.com>
 <20191001135649.GH22609@kadam>
In-Reply-To: <20191001135649.GH22609@kadam>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: OO_eyhEkOW2W7nALFS7WXw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Dan Carpenter
> Sent: 01 October 2019 14:57
> Subject: Re: [PATCH] staging: rtl8723bs: hal: Fix memcpy calls
...
> That's true for glibc memcpy() but not for the kernel memcpy().  In the
> kernel there are lots of places which do a zero size memcpy().

And probably from NULL (or even garbage) pointers.

After all a pointer to the end of an array (a + ARRAY_SIZE(a)) is valid
but must not be dereferenced - so memcpy() can't dereference it's
source address when the length is zero.

> The glibc attitude is "the standard allows us to put knives here" so
> let's put knives everywhere in the path.  And the GCC attitude is let's
> silently remove NULL checks instead of just printing a warning that the
> NULL check isn't required...  It could really make someone despondent.

gcc is the one that add knives...

This reminds me of me of a compiler that decided to optimise away
checks for function addresses being NULL.
At almost exactly the same time that ELF allowed for undefined weak symbols.
Checking whether a function was actually present was non-trivial.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


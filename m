Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6867530F7F9
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 17:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238083AbhBDQao convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 4 Feb 2021 11:30:44 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:39417 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237958AbhBDQaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 11:30:07 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-194-TSeX4CFXOvyRP8G_g9_k_g-1; Thu, 04 Feb 2021 16:28:21 +0000
X-MC-Unique: TSeX4CFXOvyRP8G_g9_k_g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 4 Feb 2021 16:28:19 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 4 Feb 2021 16:28:19 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jiri Slaby' <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Jari Ruusu <jariruusu@protonmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>
Subject: RE: Kernel version numbers after 4.9.255 and 4.4.255
Thread-Topic: Kernel version numbers after 4.9.255 and 4.4.255
Thread-Index: AQHW+uViVyzcoeH5bki3CmwTgHKEKKpIK/bQ
Date:   Thu, 4 Feb 2021 16:28:19 +0000
Message-ID: <b17b4c3b2e4b45f9b10206b276b7d831@AcuMS.aculab.com>
References: <7pR0YCctzN9phpuEChlL7_SS6auHOM80bZBcGBTZPuMkc6XjKw7HUXf9vZUPi-IaV2gTtsRVXgywQbja8xpzjGRDGWJsVYSGQN5sNuX1yaQ=@protonmail.com>
 <YBuSJqIG+AeqDuMl@kroah.com>
 <78ada91b-21ee-563f-9f75-3cbaeffafad4@kernel.org>
 <YBu1d0+nfbWGfMtj@kroah.com>
 <a85b7749-38b2-8ce9-c15a-8acb9a54c5b5@kernel.org>
In-Reply-To: <a85b7749-38b2-8ce9-c15a-8acb9a54c5b5@kernel.org>
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

From: Jiri Slaby
> Sent: 04 February 2021 11:01
> 
> On 04. 02. 21, 9:51, Greg Kroah-Hartman wrote:
> >> It might work somewhere, but there are a lot of (X * 65536 + Y * 256 + Z)
> >> assumptions all around the world. So this doesn't look like a good idea.
> >
> > Ok, so what happens if we "wrap"?  What will break with that?  At first
> > glance, I can't see anything as we keep the padding the same, and our
> > build scripts seem to pick the number up from the Makefile and treat it
> > like a string.
> >
> > It's only the crazy out-of-tree kernel stuff that wants to do minor
> > version checks that might go boom.  And frankly, I'm not all that
> > concerned if they have problems :)
> 
> Agreed. But currently, sublevel won't "wrap", it will "overflow" to
> patchlevel. And that might be a problem. So we might need to update the
> header generation using e.g. "sublevel & 0xff" (wrap around) or
> "sublevel > 255 : 255 : sublevel" (be monotonic and get stuck at 255).
> 
> In both LINUX_VERSION_CODE generation and KERNEL_VERSION proper.

A full wrap might catch checks for less than (say) 4.4.2 which
might be present to avoid very early versions.
So sticking at 255 or wrapping onto (say) 128 to 255 might be better.

I'm actually intrigued about how often you expect people to update
systems running these LTS kernels.
At a release every week it takes 5 years to run out of sublevels.
No one is going to reboot a server anywhere near that often.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


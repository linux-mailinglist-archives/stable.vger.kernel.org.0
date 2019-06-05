Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3363D35A06
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 11:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfFEJ6a convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 5 Jun 2019 05:58:30 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:32244 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727012AbfFEJ6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 05:58:30 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-7-CFkA386iP16q3G7kxRKBCw-1;
 Wed, 05 Jun 2019 10:58:25 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Wed,
 5 Jun 2019 10:58:25 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 5 Jun 2019 10:58:25 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Oleg Nesterov' <oleg@redhat.com>
CC:     'Linus Torvalds' <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        "Linux List Kernel Mailing" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Davidlohr Bueso <dbueso@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "e@80x24.org" <e@80x24.org>, Jason Baron <jbaron@akamai.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "omar.kilani@gmail.com" <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: RE: [PATCH] signal: remove the wrong signal_pending() check in
 restore_user_sigmask()
Thread-Topic: [PATCH] signal: remove the wrong signal_pending() check in
 restore_user_sigmask()
Thread-Index: AQHVGxwzwFf0q/qAAkiR7PRGfFAGAqaMwPEw///5P4CAABTbsA==
Date:   Wed, 5 Jun 2019 09:58:25 +0000
Message-ID: <29dd2937475b4407b617e2516f9cdd05@AcuMS.aculab.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com> <20190604134117.GA29963@redhat.com>
 <CAHk-=wjSOh5zmApq2qsNjmY-GMn4CWe9YwdcKPjT+nVoGiDKOQ@mail.gmail.com>
 <263d0e478ee447d9aa10baab0d8673a5@AcuMS.aculab.com>
 <20190605092516.GC32406@redhat.com>
In-Reply-To: <20190605092516.GC32406@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: CFkA386iP16q3G7kxRKBCw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov [mailto:oleg@redhat.com]
> Sent: 05 June 2019 10:25
> On 06/05, David Laight wrote:
> >
> > epoll() would have:
> > 	if (restore_user_sigmask(xxx.sigmask, &sigsaved, !ret || ret == -EINTR))
> > 		ret = -EINTR;
> 
> I don't think so but lets discuss this later.

I certainly think there should be some comments at least
about when/whether signal handlers get called and that
being separate from the return value.

The system call restart stuff does seem strange.
ISTR that was originally added for SIG_SUSPEND (^Z) so that those
signals wouldn't be seen by the appication.
But that makes it a property of the signal, not the system call.

> > I also think it could be simplified if code that loaded the 'user sigmask'
> > saved the old one in 'current->saved_sigmask' (and saved that it had done it).
> > You'd not need 'sigsaved' nor pass the user sigmask address into
> > the restore function.
> 
> Heh. apparently you do not read my emails ;)
> 
> This is what I proposed in my very 1st email, and I even showed the patch
> and the code with the patch applied twice. Let me do this again.

I did read that one, I've even quoted it in the past :-)
It's just not been mentioned recently.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


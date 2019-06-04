Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3532734CB5
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 17:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbfFDP5q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 4 Jun 2019 11:57:46 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:30564 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728161AbfFDP5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 11:57:46 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-51-Mt3WHCfVPUCuA7Ovoyd_7A-1; Tue, 04 Jun 2019 16:57:42 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 4 Jun 2019 16:57:41 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 4 Jun 2019 16:57:41 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Eric W. Biederman'" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "dbueso@suse.de" <dbueso@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "dave@stgolabs.net" <dave@stgolabs.net>,
        "e@80x24.org" <e@80x24.org>,
        "jbaron@akamai.com" <jbaron@akamai.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "omar.kilani@gmail.com" <omar.kilani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Al Viro" <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: RE: [PATCH] signal: remove the wrong signal_pending() check in
 restore_user_sigmask()
Thread-Topic: [PATCH] signal: remove the wrong signal_pending() check in
 restore_user_sigmask()
Thread-Index: AQHVGuqlwFf0q/qAAkiR7PRGfFAGAqaLofdg
Date:   Tue, 4 Jun 2019 15:57:41 +0000
Message-ID: <3b68788ea9114d08bdfdab575c8c29bb@AcuMS.aculab.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
        <20190529161157.GA27659@redhat.com>     <20190604134117.GA29963@redhat.com>
 <87tvd5nz8i.fsf@xmission.com>
In-Reply-To: <87tvd5nz8i.fsf@xmission.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: Mt3WHCfVPUCuA7Ovoyd_7A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman
> Sent: 04 June 2019 16:32
...
> Michael is there any chance we can get this guarantee of the linux
> implementation of pselect and friends clearly documented.  The guarantee
> that if the system call completes successfully we are guaranteed that
> no signal that is unblocked by using sigmask will be delivered?

The behaviour certainly needs documenting - the ToG docs are unclear.
I think you need stronger statement that the one above.

Maybe "signals will only be delivered (ie the handler called) if
the system call has to wait and the wait is interrupted by a signal.
(Even then pselect might find ready fd and return success.)

There is also the 'issue' of ERESTARTNOHAND.
Some of the system calls will return EINTR if the wait is interrupted
by a signal that doesn't have a handler, others get restarted.
I'm not at all sure about why there is a difference.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


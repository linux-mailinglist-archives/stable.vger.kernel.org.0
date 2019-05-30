Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4452330021
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 18:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfE3QWq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 30 May 2019 12:22:46 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:46837 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727158AbfE3QWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 12:22:39 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-178-hOyN1okSMISZ_H4QMpI_WQ-1; Thu, 30 May 2019 17:22:36 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 30 May 2019 17:22:35 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 30 May 2019 17:22:35 +0100
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
Thread-Index: AQHVFv20Wpjj98PrdUiaI6VbWN/dmKaD1ZRg
Date:   Thu, 30 May 2019 16:22:35 +0000
Message-ID: <21c751a08bae4f7ea25b0ba278594336@AcuMS.aculab.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
        <20190529161157.GA27659@redhat.com> <87woi8rt96.fsf@xmission.com>
 <871s0grlzo.fsf@xmission.com>
In-Reply-To: <871s0grlzo.fsf@xmission.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: hOyN1okSMISZ_H4QMpI_WQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman
> Sent: 30 May 2019 16:38
> ebiederm@xmission.com (Eric W. Biederman) writes:
> 
> > Which means I believe we have a semantically valid change in behavior
> > that is causing a regression.
> 
> I haven't made a survey of all of the functions yet but
> fucntions return -ENORESTARTNOHAND will never return -EINTR and are
> immune from this problem.

Eh?
ERESTARTNOHAND just makes the system call restart if there is no
signal handler, EINTR should still be returned if there is a handler.

All the functions that have a temporary signal mask are likely
to be expected to work the same way and thus have the same bugs.

http://pubs.opengroup.org/onlinepubs/9699919799/functions/pselect.html#
isn't overly helpful.
But I think it should return EINTR even if there is no handler unless
SA_RESTART is set:

[EINTR]
    The function was interrupted while blocked waiting for any of the selected descriptors to become ready and before the timeout interval expired.

    If SA_RESTART has been set for the interrupting signal, it is implementation-defined whether the function restarts or returns with [EINTR].

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


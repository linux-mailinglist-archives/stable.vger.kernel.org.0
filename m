Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3DA58E1A4
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 23:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiHIVQ3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 9 Aug 2022 17:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiHIVQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 17:16:21 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0197D4C61A
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 14:16:19 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-15-SVGnQXmVON2x51L-BKgQXQ-1; Tue, 09 Aug 2022 22:16:17 +0100
X-MC-Unique: SVGnQXmVON2x51L-BKgQXQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Tue, 9 Aug 2022 22:16:15 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Tue, 9 Aug 2022 22:16:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jason Gunthorpe' <jgg@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC:     David Hildenbrand <david@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>,
        "Hugh Dickins" <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Matthew Wilcox" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>
Subject: RE: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove
 FOLL_COW
Thread-Topic: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove
 FOLL_COW
Thread-Index: AQHYrCRe/fPaEDNbYU+8sVbKwVGyX62nEPVw
Date:   Tue, 9 Aug 2022 21:16:15 +0000
Message-ID: <09715a42c73a499f9c90cbe3e2714389@AcuMS.aculab.com>
References: <20220808073232.8808-1-david@redhat.com>
 <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
 <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com>
 <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
 <YvKwhrjnFQJ7trT1@nvidia.com>
In-Reply-To: <YvKwhrjnFQJ7trT1@nvidia.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe
> Sent: 09 August 2022 20:08
> 
> On Tue, Aug 09, 2022 at 11:59:45AM -0700, Linus Torvalds wrote:
> 
> > But as a very good approximation, the rule is "absolutely no new
> > BUG_ON() calls _ever_". Because I really cannot see a single case
> > where "proper error handling and WARN_ON_ONCE()" isn't the right
> > thing.
> 
> Parallel to this discussion I've had ones where people more or less
> say
> 
>  Since BUG_ON crashes the machine and Linus says that crashing the
>  machine is bad, WARN_ON will also crash the machine if you set the
>  panic_on_warn parameter, so it is also bad, thus we shouldn't use
>  anything.
> 
> I've generally maintained that people who set the panic_on_warn *want*
> these crashes, because that is the entire point of it. So we should
> use WARN_ON with an error recovery for "can't happen" assertions like
> these. I think it is what you are saying here.

They don't necessarily want the crashes, it is more the people who
built the distribution think they want the crashes.

I have had issues with a customer system (with our drivers) randomly
locking up.
Someone had decided that 'PANIC_ON_OOPS' was a good idea but hadn't
enabled anything to actually take the dump.

So instead of a diagnosable problem (and a 'doh' moment) you
get several weeks of head scratching and a very annoyed user.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


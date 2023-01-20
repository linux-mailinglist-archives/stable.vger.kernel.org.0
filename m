Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A855675A97
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 17:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjATQ62 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 20 Jan 2023 11:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjATQ61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 11:58:27 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4620C61BA
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 08:58:26 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-141-EJZeUxsUNoylJYguLyIYjA-1; Fri, 20 Jan 2023 16:58:23 +0000
X-MC-Unique: EJZeUxsUNoylJYguLyIYjA-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 20 Jan
 2023 16:58:20 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Fri, 20 Jan 2023 16:58:20 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Peter Zijlstra' <peterz@infradead.org>,
        Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>
CC:     "mingo@redhat.com" <mingo@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "longman@redhat.com" <longman@redhat.com>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>,
        "akpm@osdl.org" <akpm@osdl.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "joel@joelfernandes.org" <joel@joelfernandes.org>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "diogo.behrens@huawei.com" <diogo.behrens@huawei.com>,
        "jonas.oberhauser@huawei.com" <jonas.oberhauser@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hernan Ponce de Leon" <hernanl.leon@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] Fix data race in mark_rt_mutex_waiters
Thread-Topic: [PATCH] Fix data race in mark_rt_mutex_waiters
Thread-Index: AQHZLOuXmFFanV4GpkyO0ZW7VUnI7K6nhS4Q
Date:   Fri, 20 Jan 2023 16:58:20 +0000
Message-ID: <dc361d8a262b4872acf750f7c8935a28@AcuMS.aculab.com>
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
 <Y8q/5hgXrvOp6vku@hirez.programming.kicks-ass.net>
In-Reply-To: <Y8q/5hgXrvOp6vku@hirez.programming.kicks-ass.net>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra
> Sent: 20 January 2023 16:23
...
> >  	do {
> > -		owner = *p;
> > +		owner = READ_ONCE(*p);
> >  	} while (cmpxchg_relaxed(p, owner,
> >  				 owner | RT_MUTEX_HAS_WAITERS) != owner);
> >
> 
> Can't we replace the whole of that function with:
> 
> 	set_bit(0, (unsigned long *)&lock->owner);
> 
> ?

If you need the cast then probably not...

There really ought to be a compile-time test (somehow)
that set_bit() is only used on large bit arrays.

OTOH atomic_or32/64() and atomic_and32/64() might use
usable in many places.

On x86 I doubt it makes much difference whether you use
'bis' or 'lock or'.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


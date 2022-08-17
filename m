Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C3A596B46
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 10:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbiHQIUP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 17 Aug 2022 04:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235094AbiHQIUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 04:20:14 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816AD58DC1
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 01:20:11 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-186-_ZDhN8jUN4OlHtEkOqfydg-1; Wed, 17 Aug 2022 09:20:09 +0100
X-MC-Unique: _ZDhN8jUN4OlHtEkOqfydg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.38; Wed, 17 Aug 2022 09:20:08 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.040; Wed, 17 Aug 2022 09:20:08 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Hector Martin' <marcan@marcan.st>, Will Deacon <will@kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>
CC:     Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        "Daniel Lustig" <dlustig@nvidia.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Neukum <oneukum@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Asahi Linux <asahi@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] locking/atomic: Make test_and_*_bit() ordered on failure
Thread-Topic: [PATCH] locking/atomic: Make test_and_*_bit() ordered on failure
Thread-Index: AQHYsU4vfwz5idsf402HoI6nUKdp962yvvCA
Date:   Wed, 17 Aug 2022 08:20:08 +0000
Message-ID: <1135281ad4e84cc5ac0147772aa83787@AcuMS.aculab.com>
References: <20220816070311.89186-1-marcan@marcan.st>
In-Reply-To: <20220816070311.89186-1-marcan@marcan.st>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

...
>  	p += BIT_WORD(nr);
> -	if (READ_ONCE(*p) & mask)
> -		return 1;
> -
>  	old = arch_atomic_long_fetch_or(mask, (atomic_long_t *)p);
>  	return !!(old & mask);
>  }

This looks like the same pattern (attempting to avoid a
locked bus cycle) that caused the qdisc code to sit on
transmit packets (even on x86).
That had some barriers in it (possibly nops on x86) that
didn't help - although the comments suggested otherwise.

I wonder if the pattern has been used anywhere else?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


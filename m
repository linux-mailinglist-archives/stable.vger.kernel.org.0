Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD60DEB2A5
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 15:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfJaO1j convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 31 Oct 2019 10:27:39 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:28018 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726741AbfJaO1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Oct 2019 10:27:39 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-70-YU6WXDc2PrG1nexM6IIzbw-1; Thu, 31 Oct 2019 14:27:31 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 31 Oct 2019 14:27:30 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 31 Oct 2019 14:27:30 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christian Brauner' <christian.brauner@ubuntu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        GNU C Library <libc-alpha@sourceware.org>
CC:     Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
        "Jann Horn" <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] clone3: validate stack arguments
Thread-Topic: [PATCH] clone3: validate stack arguments
Thread-Index: AQHVj99vS5K32QXnq0iIRbo0zlqhOad0zlFw
Date:   Thu, 31 Oct 2019 14:27:30 +0000
Message-ID: <7f59e7e573aa40f08cb0e465d8d0150e@AcuMS.aculab.com>
References: <20191031113608.20713-1-christian.brauner@ubuntu.com>
In-Reply-To: <20191031113608.20713-1-christian.brauner@ubuntu.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: YU6WXDc2PrG1nexM6IIzbw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From Christian Brauner
> Sent: 31 October 2019 11:36
> 
> Validate the stack arguments and setup the stack depening on whether or not
> it is growing down or up.
> 
...
> -static bool clone3_args_valid(const struct kernel_clone_args *kargs)
> +/**
> + * clone3_stack_valid - check and prepare stack
> + * @kargs: kernel clone args
> + *
> + * Verify that the stack arguments userspace gave us are sane.
> + * In addition, set the stack direction for userspace since it's easy for us to
> + * determine.
> + */
> +static inline bool clone3_stack_valid(struct kernel_clone_args *kargs)
> +{
> +	if (kargs->stack == 0) {
> +		if (kargs->stack_size > 0)
> +			return false;
> +	} else {
> +		if (kargs->stack_size == 0)
> +			return false;
> +
> +		if (!access_ok((void __user *)kargs->stack, kargs->stack_size))
> +			return false;

Does access_ok() do anything useful here?
It only verifies that the buffer isn't in kernel space.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


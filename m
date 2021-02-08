Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3A6312CF9
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 10:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhBHJNB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 8 Feb 2021 04:13:01 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:29242 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231364AbhBHJLN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 04:11:13 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-211-2Qlbkk45NXqH2etaL8K-mg-1; Mon, 08 Feb 2021 09:09:32 +0000
X-MC-Unique: 2Qlbkk45NXqH2etaL8K-mg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 8 Feb 2021 09:09:32 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 8 Feb 2021 09:09:32 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willy Tarreau' <w@1wt.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "lwn@lwn.net" <lwn@lwn.net>, "jslaby@suse.cz" <jslaby@suse.cz>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>
Subject: RE: Linux 4.4.256
Thread-Topic: Linux 4.4.256
Thread-Index: AQHW/It+/rP1vSf8XEWqgVFokkPLWqpN9+Rw
Date:   Mon, 8 Feb 2021 09:09:32 +0000
Message-ID: <54e88e8d1ba1487ba43eb36ddfec4e5a@AcuMS.aculab.com>
References: <1612534196241236@kroah.com>
 <20210205205658.GA136925@roeck-us.net> <YB6S612pwLbQJf4u@kroah.com>
 <20210206131113.GB7312@1wt.eu> <20210206132239.GC7312@1wt.eu>
In-Reply-To: <20210206132239.GC7312@1wt.eu>
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

From: Willy Tarreau
> Sent: 06 February 2021 13:23
> 
> On Sat, Feb 06, 2021 at 02:11:13PM +0100, Willy Tarreau wrote:
> > Something like this looks more robust to me, it will use SUBLEVEL for
> > values 0 to 255 and 255 for any larger value:
> 
> diff --git a/Makefile b/Makefile
> index 7d86ad6ad36c..9b91b8815b40 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1252,7 +1252,7 @@ endef
> 
>  define filechk_version.h
>  	echo \#define LINUX_VERSION_CODE $(shell                         \
> -	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
> +	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255 \* \( 0$(SUBLEVEL) \> 255 \) +
> 0$(SUBLEVEL) \* \( 0$(SUBLEVEL) \<= 255 \) ); \
>  	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))'
>  endef

Why not:
	$(shell echo $$(($(VERSION)<<16 + $(PATCHLEVEL)<<8 + ($(SUBVERSION) < 255 ? $(SUBVERSION) : 255))))
Untested, but I think only the one $ needs any kind of escape.
The extra leading zeros do have to go - $((...)) does octal :-(

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


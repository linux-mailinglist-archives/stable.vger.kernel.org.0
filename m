Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749C84A590A
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 10:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiBAJRz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 1 Feb 2022 04:17:55 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:39334 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230264AbiBAJRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 04:17:54 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-140-GeVL98cmMJWo6_nFsA2gAQ-1; Tue, 01 Feb 2022 09:17:48 +0000
X-MC-Unique: GeVL98cmMJWo6_nFsA2gAQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Tue, 1 Feb 2022 09:17:47 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Tue, 1 Feb 2022 09:17:47 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kees Cook' <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     Ariadne Conill <ariadne@dereferenced.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Christian Brauner" <brauner@kernel.org>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH] exec: Force single empty string when argv is empty
Thread-Topic: [PATCH] exec: Force single empty string when argv is empty
Thread-Index: AQHYFwALh17Nc4lWIEewOStTbNpbHKx+aiLA
Date:   Tue, 1 Feb 2022 09:17:47 +0000
Message-ID: <78959c88715049a4be00fc75bb333d3a@AcuMS.aculab.com>
References: <20220201000947.2453721-1-keescook@chromium.org>
In-Reply-To: <20220201000947.2453721-1-keescook@chromium.org>
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

From: Kees Cook
> Sent: 01 February 2022 00:10
...
> While the initial code searches[6][7] turned up what appeared to be
> mostly corner case tests, trying to that just reject argv == NULL
> (or an immediately terminated pointer list) quickly started tripping[8]
> existing userspace programs.
> 
> The next best approach is forcing a single empty string into argv and
> adjusting argc to match. The number of programs depending on argc == 0
> seems a smaller set than those calling execve with a NULL argv.

Has anyone considered using the pathname for argv[0]?
So converting:
	execl(path, NULL);
into:
	execl(path, path, NULL);

I've not spotted any such suggestion.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


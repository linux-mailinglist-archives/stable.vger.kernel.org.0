Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F87039B4D7
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 10:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhFDI3W convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 4 Jun 2021 04:29:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:21477 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230073AbhFDI3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 04:29:21 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-230-Ui8ma5gYO-inG2DxsBorfg-1; Fri, 04 Jun 2021 09:27:33 +0100
X-MC-Unique: Ui8ma5gYO-inG2DxsBorfg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.18; Fri, 4 Jun 2021 09:27:32 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Fri, 4 Jun 2021 09:27:32 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jaegeuk Kim' <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
CC:     Daniel Rosenberg <drosen@google.com>, Chao Yu <chao@kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] f2fs: Advertise encrypted casefolding in sysfs
Thread-Topic: [PATCH v2 2/2] f2fs: Advertise encrypted casefolding in sysfs
Thread-Index: AQHXWPxv6htlFlDG3kih+WsZuRk5JqsDg75Q
Date:   Fri, 4 Jun 2021 08:27:32 +0000
Message-ID: <4f56f2781fac4b8bac1a78b0fecc318d@AcuMS.aculab.com>
References: <20210603095038.314949-1-drosen@google.com>
 <20210603095038.314949-3-drosen@google.com>
 <YLlj+h4RiT6FvyK6@sol.localdomain> <YLmv5Ykb3QUzDOlL@google.com>
In-Reply-To: <YLmv5Ykb3QUzDOlL@google.com>
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

From: Jaegeuk Kim
> Sent: 04 June 2021 05:45
...
> > > @@ -161,6 +161,9 @@ static ssize_t features_show(struct f2fs_attr *a,
> > >  	if (f2fs_sb_has_compression(sbi))
> > >  		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
> > >  				len ? ", " : "", "compression");
> > > +	if (f2fs_sb_has_casefold(sbi) && f2fs_sb_has_encrypt(sbi))
> > > +		len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
> > > +				len ? ", " : "", "encrypted_casefold");
> > >  	len += scnprintf(buf + len, PAGE_SIZE - len, "%s%s",
> > >  				len ? ", " : "", "pin_file");
> > >  	len += scnprintf(buf + len, PAGE_SIZE - len, "\n");

Looking at that pattern, why don't you just append "tag, "
each time and then replace the final ", " with "\n" at the end.

Although if I wanted to quickly parse that in (say) a shell
script I wouldn't really want the ",".
OTOH it is too late to change that.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D313F28CA
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 11:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhHTJD1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 20 Aug 2021 05:03:27 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:56163 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233561AbhHTJD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 05:03:27 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-211-zYbF-yKXOiadlD96bB7S2A-1; Fri, 20 Aug 2021 10:02:47 +0100
X-MC-Unique: zYbF-yKXOiadlD96bB7S2A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Fri, 20 Aug 2021 10:02:46 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Fri, 20 Aug 2021 10:02:46 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Joerg Roedel' <joro@8bytes.org>
CC:     "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>, Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Uros Bizjak <ubizjak@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] x86/efi: Restore Firmware IDT in before
 ExitBootServices()
Thread-Topic: [PATCH] x86/efi: Restore Firmware IDT in before
 ExitBootServices()
Thread-Index: AQHXlZXa+jtHdymQB0W1fhKjcUB7Wqt8EPPg///0gwCAABNdkA==
Date:   Fri, 20 Aug 2021 09:02:46 +0000
Message-ID: <f68a175362984e4abbb0a1da2004c936@AcuMS.aculab.com>
References: <20210820073429.19457-1-joro@8bytes.org>
 <e43eb0d137164270bf16258e6d11879e@AcuMS.aculab.com>
 <YR9tSuLyX8QHV5Pv@8bytes.org>
In-Reply-To: <YR9tSuLyX8QHV5Pv@8bytes.org>
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

From: 'Joerg Roedel'
> Sent: 20 August 2021 09:52
> 
> On Fri, Aug 20, 2021 at 08:43:47AM +0000, David Laight wrote:
> > Hmmm...
> > If Linux needs its own IDT then temporarily substituting the old IDT
> > prior to a UEFI call will cause 'grief' if a 'Linux' interrupt
> > happens during the UEFI call.
> 
> This is neede only during very early boot before Linux called
> ExitBootServices(). Nothing that causes IRQs is set up by Linux yet. Of
> course the Firmware could have set something up, but Linux runs with
> IRQs disabled when on its own IDT at that stage.

So allocate and initialise the Linux IDT - so entries can be added.
But don't execute 'lidt' until later on.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


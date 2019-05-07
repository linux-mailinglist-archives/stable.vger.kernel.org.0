Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA5D161FD
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 12:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfEGKbc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 7 May 2019 06:31:32 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:50406 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726547AbfEGKbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 06:31:32 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-135-fQiddA3kMDSw-qG7Exz2OQ-1; Tue, 07 May 2019 11:31:29 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue,
 7 May 2019 11:31:28 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 7 May 2019 11:31:28 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jiri Kosina' <jikos@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC:     Andy Lutomirski <luto@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@surriel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Ard Biesheuvel" <ard.biesheuvel@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Nicolai Stange <nstange@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] x86/fpu: Remove the _GPL from the kernel_fpu_begin/end()
 export
Thread-Topic: [PATCH] x86/fpu: Remove the _GPL from the kernel_fpu_begin/end()
 export
Thread-Index: AQHVAkq0vUiV5g3MjEetDYjdoqqHvaZfXF+Q
Date:   Tue, 7 May 2019 10:31:28 +0000
Message-ID: <957b01f742ed47d1ac9e0ea1277d155b@AcuMS.aculab.com>
References: <761345df6285930339aced868ebf8ec459091383.1556807897.git.luto@kernel.org>
 <20190502154043.gfv4iplcvzjz3mc6@linutronix.de>
 <nycvar.YFH.7.76.1905032044250.10635@cbobk.fhfr.pm>
 <nycvar.YFH.7.76.1905040849370.17054@cbobk.fhfr.pm>
In-Reply-To: <nycvar.YFH.7.76.1905040849370.17054@cbobk.fhfr.pm>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: fQiddA3kMDSw-qG7Exz2OQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

...
> So I don't really see a problem with Andy's patch. If we want to annoy
> external non-GPL modules as much as possible, sure, that's for a separate
> discussion though (and I am sure many people would agree to that).
> Proposal to get rid of EXPORT_SYMBOL in favor of EXPORT_SYMBOL_GPL would
> be a good start I guess :)

As a writer on an external non-GPL module I'd point out:
1 - Even if we wanted to 'upstream' our code it is very specific
    and wouldn't really be wanted/accepted.
    Even if accepted it would always be excluded from builds.
2 - It would take man-years to make it meet the kernel code guidelines
    and to make it portable (from x86).
    It also contains conditionals because it gets build for windows.
    I don't like a lot of it.
3 - Almost all the calls to kernel functions are through a 'wrapper'
    file that is compiled on the target system.
    About the only functions that are directly called are ones like memcpy().
4 - It wouldn't be that hard, and would still be GPLv2 if we built
    two loadable modules, one GPL and one non-GPL and put all our
    wrapper functions in the GPL one.
    We'd still need a small wrapper for the non-GPL module, but while
    Non-GPL modules are supported at all it wouldn't be much work.
5 - The continual tweaks for new kernel versions keep us in a job!

Some of the _GPL exports are a PITA:
- we can't reference count network namespaces (without creating a socket).
- we can't reference count 'pid' structures making sending signals tricky.
- I thing the PCIe error handling functions that we ought to be using
  are GPL.

At the moment we've not needed the fpu :-)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


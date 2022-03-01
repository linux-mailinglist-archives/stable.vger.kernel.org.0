Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668D24C8891
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 10:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbiCAJyy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 1 Mar 2022 04:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbiCAJyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 04:54:53 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 536638BF1E
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 01:54:11 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-17-WIsvEzCdOj6XxcsfQ7uUIw-1; Tue, 01 Mar 2022 09:54:08 +0000
X-MC-Unique: WIsvEzCdOj6XxcsfQ7uUIw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Tue, 1 Mar 2022 09:54:07 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Tue, 1 Mar 2022 09:54:07 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Ammar Faizi' <ammarfaizi2@gnuweeb.org>,
        Borislav Petkov <bp@alien8.de>
CC:     Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gwml@vger.gnuweeb.org" <gwml@vger.gnuweeb.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Alviro Iskandar Setiawan" <alviro.iskandar@gnuweeb.org>,
        Jiri Hladky <hladky.jiri@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: RE: [PATCH v4 1/2] x86/delay: Fix the wrong asm constraint in
 `delay_loop()`
Thread-Topic: [PATCH v4 1/2] x86/delay: Fix the wrong asm constraint in
 `delay_loop()`
Thread-Index: AQHYLVFHQzUkKsf/ZkuVhNGB2yFzFqyqSHaQ
Date:   Tue, 1 Mar 2022 09:54:07 +0000
Message-ID: <0642444da1844f8dae2dc98b34b8ab74@AcuMS.aculab.com>
References: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
 <20220301094608.118879-2-ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220301094608.118879-2-ammarfaizi2@gnuweeb.org>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ammar Faizi
> Sent: 01 March 2022 09:46
> 
> The asm constraint does not reflect that the asm statement can modify
> the value of @loops. But the asm statement in delay_loop() does change
> the @loops.
> 
> If by any chance the compiler inlines this function, it may clobber
> random stuff (e.g. local variable, important temporary value in reg,
> etc.).
> 
> Fortunately, delay_loop() is only called indirectly (so it can't
> inline), and then the register it clobbers is %rax (which is by the
> nature of the calling convention, it's a caller saved register), so it
> didn't yield any bug.

Both the function pointers in that code need killing.
They only have two options (each) so conditional branches
will almost certainly always have been better.

I also wonder how well the comment
   The additional jump magic is needed to get the timing stable
   on all the CPU' we have to worry about.
applies to any modern cpu!
The code is unchanged since (at least) 2.6.27.
(It might have been moved from another file.)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


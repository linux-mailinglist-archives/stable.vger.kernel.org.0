Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09835584EFC
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 12:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbiG2Kk1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 29 Jul 2022 06:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiG2Kk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 06:40:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 592EE19C1F
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 03:40:25 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-55-5dMw4K_ePdyLrUnYWn3eJw-1; Fri, 29 Jul 2022 11:40:22 +0100
X-MC-Unique: 5dMw4K_ePdyLrUnYWn3eJw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Fri, 29 Jul 2022 11:40:20 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Fri, 29 Jul 2022 11:40:20 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Pawan Gupta' <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
CC:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "antonio.gomez.iglesias@linux.intel.com" 
        <antonio.gomez.iglesias@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Subject: RE: [RESEND RFC PATCH] x86/bugs: Add "unknown" reporting for MMIO
 Stale Data
Thread-Topic: [RESEND RFC PATCH] x86/bugs: Add "unknown" reporting for MMIO
 Stale Data
Thread-Index: AQHYovL4+baeEq2rDkCp4WwQq32ghq2VJ0xw
Date:   Fri, 29 Jul 2022 10:40:20 +0000
Message-ID: <e7ba00885fca4ec9849d8525cbc46f7b@AcuMS.aculab.com>
References: <a932c154772f2121794a5f2eded1a11013114711.1657846269.git.pawan.kumar.gupta@linux.intel.com>
 <YuJ6TQpSTIeXLNfB@zn.tnic> <20220729022851.mdj3wuevkztspodh@desk>
In-Reply-To: <20220729022851.mdj3wuevkztspodh@desk>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta
> Sent: 29 July 2022 03:29
> 
> On Thu, Jul 28, 2022 at 02:00:13PM +0200, Borislav Petkov wrote:
> > On Thu, Jul 14, 2022 at 06:30:18PM -0700, Pawan Gupta wrote:
> > > Older CPUs beyond its Servicing period are not listed in the affected
> > > processor list for MMIO Stale Data vulnerabilities. These CPUs currently
> > > report "Not affected" in sysfs, which may not be correct.

I looked this up....

The mitigations seem to rely on unprivileged code not being able
to do MMIO accesses.
That isn't true, device drivers can mmap PCIe addresses directly
into user program address space.
While unlikely, there is no reason this can't be supported for
non-root processes.
So if the underlying hardware doesn't correctly validate the
byte enables then stale data can be read.

It has to be said that I can't actually imagine getting anything
useful unless you have co-operating processes using it as a
security bypass side channel.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67D3914DDAF
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 16:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbgA3PVO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 30 Jan 2020 10:21:14 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:25486 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727224AbgA3PVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 10:21:14 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-41-bGG4hDvvOfmWYjQy5O4gVw-1; Thu, 30 Jan 2020 15:21:09 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 30 Jan 2020 15:21:09 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 30 Jan 2020 15:21:09 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Peter Zijlstra' <peterz@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>
CC:     Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vipul Kumar <vipulk0511@gmail.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Len Brown <len.brown@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 3/3] x86/tsc_msr: Make MSR derived TSC frequency more
 accurate
Thread-Topic: [PATCH 3/3] x86/tsc_msr: Make MSR derived TSC frequency more
 accurate
Thread-Index: AQHV13M/Jf366MsxW0K0cA6JkRCOwKgDUdtg
Date:   Thu, 30 Jan 2020 15:21:08 +0000
Message-ID: <e0926d9a7bc3461a9157d24210c679df@AcuMS.aculab.com>
References: <20200130115255.20840-1-hdegoede@redhat.com>
 <20200130115255.20840-3-hdegoede@redhat.com>
 <20200130134310.GX14914@hirez.programming.kicks-ass.net>
In-Reply-To: <20200130134310.GX14914@hirez.programming.kicks-ass.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: bGG4hDvvOfmWYjQy5O4gVw-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra
> Sent: 30 January 2020 13:43
...
> > + * Bay Trail SDM MSR_FSB_FREQ frequencies simplified PLL model:
> > + *  000:   100 *  5 /  6  =  83.3333 MHz
> > + *  001:   100 *  1 /  1  = 100.0000 MHz
> > + *  010:   100 *  4 /  3  = 133.3333 MHz
> > + *  011:   100 *  7 /  6  = 116.6667 MHz
> > + *  100:   100 *  4 /  5  =  80.0000 MHz
> 
> > + * Cherry Trail SDM MSR_FSB_FREQ frequencies simplified PLL model:
> > + * 0000:   100 *  5 /  6  =  83.3333 MHz
> > + * 0001:   100 *  1 /  1  = 100.0000 MHz
> > + * 0010:   100 *  4 /  3  = 133.3333 MHz
> > + * 0011:   100 *  7 /  6  = 116.6667 MHz
> > + * 0100:   100 *  4 /  5  =  80.0000 MHz
> > + * 0101:   100 * 14 / 15  =  93.3333 MHz
> > + * 0110:   100 *  9 / 10  =  90.0000 MHz
> > + * 0111:   100 *  8 /  9  =  88.8889 MHz
> > + * 1000:   100 *  7 /  8  =  87.5000 MHz
> 
> > + * Merriefield (BYT MID) SDM MSR_FSB_FREQ frequencies simplified PLL model:
> > + * 0001:   100 *  1 /  1  = 100.0000 MHz
> > + * 0010:   100 *  4 /  3  = 133.3333 MHz
> 
> > + * Moorefield (CHT MID) SDM MSR_FSB_FREQ frequencies simplified PLL model:
> > + * 0000:   100 *  5 /  6  =  83.3333 MHz
> > + * 0001:   100 *  1 /  1  = 100.0000 MHz
> > + * 0010:   100 *  4 /  3  = 133.3333 MHz
> > + * 0011:   100 *  1 /  1  = 100.0000 MHz
> 
> Unless I'm going cross-eyed, that's 4 times the exact same table.

Apart from the very last line which duplicates 100MHz.
And the fact that some entries are missing (presumed invalid?)
for certain cpu.

If the tables are ever used for setting the frequency
then the valid range (and values?) would need to be known.

I did wonder if the 'mask' was necessary?
Are the unused bits reserved and zero?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


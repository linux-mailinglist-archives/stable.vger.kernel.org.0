Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C353F14DE4F
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 17:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgA3QCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 11:02:36 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:46600 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727186AbgA3QCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 11:02:36 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-107-IaITlwqSNMiNq9NHtqF3bw-1; Thu, 30 Jan 2020 16:02:31 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 30 Jan 2020 16:02:30 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 30 Jan 2020 16:02:30 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Hans de Goede' <hdegoede@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
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
Thread-Index: AQHV14WrJf366MsxW0K0cA6JkRCOwKgDXckw
Date:   Thu, 30 Jan 2020 16:02:30 +0000
Message-ID: <01feee20ee5d4b83ab218c14fc35accb@AcuMS.aculab.com>
References: <20200130115255.20840-1-hdegoede@redhat.com>
 <20200130115255.20840-3-hdegoede@redhat.com>
 <20200130134310.GX14914@hirez.programming.kicks-ass.net>
 <b77be8c0-7107-bece-5947-a625e556e129@redhat.com>
In-Reply-To: <b77be8c0-7107-bece-5947-a625e556e129@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: IaITlwqSNMiNq9NHtqF3bw-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogSGFucyBkZSBHb2VkZQ0KPiBTZW50OiAzMCBKYW51YXJ5IDIwMjAgMTU6NTUNCi4uLg0K
PiA+PiArICogTW9vcmVmaWVsZCAoQ0hUIE1JRCkgU0RNIE1TUl9GU0JfRlJFUSBmcmVxdWVuY2ll
cyBzaW1wbGlmaWVkIFBMTCBtb2RlbDoNCj4gPj4gKyAqIDAwMDA6ICAgMTAwICogIDUgLyAgNiAg
PSAgODMuMzMzMyBNSHoNCj4gPj4gKyAqIDAwMDE6ICAgMTAwICogIDEgLyAgMSAgPSAxMDAuMDAw
MCBNSHoNCj4gPj4gKyAqIDAwMTA6ICAgMTAwICogIDQgLyAgMyAgPSAxMzMuMzMzMyBNSHoNCj4g
Pj4gKyAqIDAwMTE6ICAgMTAwICogIDEgLyAgMSAgPSAxMDAuMDAwMCBNSHoNCj4gPg0KPiA+IFVu
bGVzcyBJJ20gZ29pbmcgY3Jvc3MtZXllZCwgdGhhdCdzIDQgdGltZXMgdGhlIGV4YWN0IHNhbWUg
dGFibGUuDQo+IA0KPiBDb3JyZWN0LCBleGNlcHQgdGhhdCB0aGUgbm90IGxpc3RlZCB2YWx1ZXMg
b24gdGhlIG5vbmUgQ2hlcnJ5IFRyYWlsDQo+IHRhYmxlIGFyZSB1bmRlZmluZWQgaW4gdGhlIFNE
TSwgc28gd2Ugc2hvdWxkIHByb2JhYmx5IGRlbnkgdGhlbQ0KPiAob3IgYXMgdGhlIG9sZCBjb2Rl
IHdhcyBkb2luZyBzaW1wbHkgcmV0dXJuIDApLg0KPiANCj4gQW5kIGF0IGxlYXN0IHRoZSBNb29y
ZWZpZWxkIChDSFQgTUlEKSB0YWJsZSBpcyBkaWZmZXJlbnQgZm9yIDAwMTEsIHRoYXQNCj4gaXMg
YWdhaW4gMTAwIE1IeiBsaWtlIDAwMDEgaW5zdGVhZCBvZiAxMTYuNjY2NyBhcyBpdCBpcyBmb3Ig
QllUIGFuZCBDSFQuDQo+IA0KPiBOb3RlIHRoYXQgdGhlIE1lcnJpZWZpZWxkIChCWVQgTUlEKSBh
bmQgTW9vcmVmaWVsZCAoQ0hUIE1JRCkgdmFsdWVzIGFyZQ0KPiBiYXNlZCBvbiB0aGUgb2xkIGNv
ZGUgSSd2ZSBub3Qgc2VlbiB0aG9zZSB2YWx1ZXMgaW4gdGhlIGN1cnJlbnQgbGF0ZXN0DQo+IHZl
cnNpb24gb2YgdGhlIFNETS4NCg0KSSB3b25kZXIgaWYgTW9vcmVmaWVsZDoxMSBpcyBhbiBvbGQg
dHlwbz8NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxl
eSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0
aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==


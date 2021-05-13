Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94B237F5B9
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 12:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhEMKho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 06:37:44 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:48209 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231477AbhEMKhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 06:37:41 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-224-rC7ecZ6kMiy0NzftmwzKAQ-1; Thu, 13 May 2021 11:36:29 +0100
X-MC-Unique: rC7ecZ6kMiy0NzftmwzKAQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Thu, 13 May 2021 11:36:27 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Thu, 13 May 2021 11:36:27 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Maximilian Luz' <luzmaximilian@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
CC:     "H. Peter Anvin" <hpa@zytor.com>, Sachi King <nakato@nakato.io>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] x86/i8259: Work around buggy legacy PIC
Thread-Topic: [PATCH] x86/i8259: Work around buggy legacy PIC
Thread-Index: AQHXR3+B5Hf0DG1T80+Lb/Y+9zG7TarhDftggAATCoCAABWukA==
Date:   Thu, 13 May 2021 10:36:27 +0000
Message-ID: <e43d9a823c9e44bab0cdbf32a000c373@AcuMS.aculab.com>
References: <20210512210459.1983026-1-luzmaximilian@gmail.com>
 <9b70d8113c084848b8d9293c4428d71b@AcuMS.aculab.com>
 <e7dbd4d1-f23f-42f0-e912-032ba32f9ec8@gmail.com>
In-Reply-To: <e7dbd4d1-f23f-42f0-e912-032ba32f9ec8@gmail.com>
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
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWF4aW1pbGlhbiBMdXog
PGx1em1heGltaWxpYW5AZ21haWwuY29tPg0KPiBTZW50OiAxMyBNYXkgMjAyMSAxMToxMg0KPiBU
bzogRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWlnaHRAQUNVTEFCLkNPTT47IFRob21hcyBHbGVpeG5l
ciA8dGdseEBsaW51dHJvbml4LmRlPjsgSW5nbyBNb2xuYXINCj4gPG1pbmdvQHJlZGhhdC5jb20+
OyBCb3Jpc2xhdiBQZXRrb3YgPGJwQGFsaWVuOC5kZT4NCj4gQ2M6IEguIFBldGVyIEFudmluIDxo
cGFAenl0b3IuY29tPjsgU2FjaGkgS2luZyA8bmFrYXRvQG5ha2F0by5pbz47IHg4NkBrZXJuZWwu
b3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZzsgc3RhYmxlQHZnZXIua2VybmVs
Lm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSB4ODYvaTgyNTk6IFdvcmsgYXJvdW5kIGJ1Z2d5
IGxlZ2FjeSBQSUMNCj4gDQo+IE9uIDUvMTMvMjEgMTA6MTAgQU0sIERhdmlkIExhaWdodCB3cm90
ZToNCj4gPiBGcm9tOiBNYXhpbWlsaWFuIEx1eg0KPiA+PiBTZW50OiAxMiBNYXkgMjAyMSAyMjow
NQ0KPiA+Pg0KPiA+PiBUaGUgbGVnYWN5IFBJQyBvbiB0aGUgQU1EIHZhcmlhbnQgb2YgdGhlIE1p
Y3Jvc29mdCBTdXJmYWNlIExhcHRvcCA0IGhhcw0KPiA+PiBzb21lIHByb2JsZW1zIG9uIGJvb3Qu
IEZvciBzb21lIHJlYXNvbiBpdCBjb25zaXN0ZW50bHkgZG9lcyBub3QgcmVzcG9uZA0KPiA+PiBv
biB0aGUgZmlyc3QgdHJ5LCByZXF1aXJpbmcgYSBjb3VwbGUgbW9yZSB0cmllcyBiZWZvcmUgaXQg
ZmluYWxseQ0KPiA+PiByZXNwb25kcy4NCj4gPg0KPiA+IFRoYXQgc2VlbXMgdmVyeSBzdHJhbmdl
LCBzb21ldGhpbmcgZWxzZSBtdXN0IGJlIGdvaW5nIG9uIHRoYXQgY2F1c2VzIHRoZSBncmllZi4N
Cj4gPiBUaGUgODI1OSB3aWxsIGJlIGJ1aWx0IGludG8gdG8gdGhlIG9uZSBvZiB0aGUgY3B1IHN1
cHBvcnQgY2hpcHMuDQo+ID4gSSBjYW4ndCBpbWFnaW5lIHRoYXQgcmVxdWlyZXMgYW55dGhpbmcg
c3BlY2lhbC4NCj4gDQo+IFJpZ2h0LCBpdCdzIGRlZmluaXRlbHkgc3RyYW5nZS4gQm90aCBTYWNo
aSAoSSBpbWFnaW5lKSBhbmQgSSBkb24ndCBrbm93DQo+IG11Y2ggYWJvdXQgdGhlc2UgZGV2aWNl
cywgc28gd2UncmUgb3BlbiBmb3Igc3VnZ2VzdGlvbnMuDQoNCkkgZm91bmQgYSBjb3B5IG9mIHRo
ZSBkYXRhc2hlZXQgKEkgZG9uJ3Qgc2VlbSB0byBoYXZlIHRoZSBibGFjayBib29rKToNCg0KaHR0
cHM6Ly9wZG9zLmNzYWlsLm1pdC5lZHUvNi44MjgvMjAxMC9yZWFkaW5ncy9oYXJkd2FyZS84MjU5
QS5wZGYNCg0KVGhlIFBDIGhhcmR3YXJlIGhhcyB0d28gODI1OSBpbiBjYXNjYWRlIG1vZGUuDQoo
Q2FzY2FkZWQgdXNpbmcgYW4gaW50ZXJydXB0IHRoYXQgd2Fzbid0IHJlYWxseSB1c2luZyBpbiB0
aGUgb3JpZ2luYWwNCjgwODggUEMgd2hpY2ggb25seSBoYWQgb25lIDgyNTkuKQ0KDQpJIHdvbmRl
ciBpZiB0aGUgYmlvcyBoYXMgYWN0dWFsbHkgaW5pdGlhbGlzZWQgaXMgcHJvcGVybHkuDQpTb21l
IGluaXRpYWxpc2F0aW9uIHdyaXRlcyBoYXZlIHRvIGJlIGRvbmUgdG8gc2V0IGV2ZXJ5dGhpbmcg
dXAuDQoNCkl0IGlzIGFsc28gd29ydGggbm90aW5nIHRoYXQgdGhlIHByb2JlIGNvZGUgaXMgc3Bl
Y3RhY3VsYXJseSBjcmFwLg0KSXQgd3JpdGVzIDB4ZmYgYW5kIHRoZW4gY2hlY2tzIHRoYXQgMHhm
ZiBpcyByZWFkIGJhY2suDQpBbG1vc3QgYW55dGhpbmcgKGluY2x1ZGluZyBhIGZhaWxlZCBQQ0ll
IHJlYWQgdG8gdGhlIElTQSBicmlkZ2UpDQp3aWxsIHJldHVybiAweGZmIGFuZCBtYWtlIHRoZSB0
ZXN0IHBhc3MuDQoNCkl0J3MgYWJvdXQgMzUgeWVhcnMgc2luY2UgSSBsYXN0IHdyb3RlIHRoZSBj
b2RlIHRvIGluaXRpYWxpc2UgYW4gODI1OS4NClRoZSBtZW1vcnkgY2VsbHMgYXJlIGZvZ2d5Lg0K
DQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQs
IE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86
IDEzOTczODYgKFdhbGVzKQ0K


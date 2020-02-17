Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F04161123
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 12:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgBQLaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 06:30:23 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:40775 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727370AbgBQLaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 06:30:23 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-217-f6On0xLzP7ennhodhfUe9Q-1; Mon, 17 Feb 2020 11:30:18 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 17 Feb 2020 11:30:18 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 17 Feb 2020 11:30:18 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Schrempf Frieder' <frieder.schrempf@kontron.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>
CC:     Boris Brezillon <bbrezillon@kernel.org>,
        Jeff Kletsky <git-commits@allycomm.com>,
        liaoweixiong <liaoweixiong@allwinnertech.com>,
        Peter Pan <peterpandong@micron.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Richard Weinberger <richard@nod.at>
Subject: RE: [PATCH 3/3] mtd: spinand: Wait for the erase op to finish before
 writing a bad block marker
Thread-Topic: [PATCH 3/3] mtd: spinand: Wait for the erase op to finish before
 writing a bad block marker
Thread-Index: AQHV4PlTblnHiLQcV0asTsn4OWAZ0KgfKk6AgAALNICAABFVsA==
Date:   Mon, 17 Feb 2020 11:30:18 +0000
Message-ID: <73f3002b3a5245dbbde064e1c0b1af92@AcuMS.aculab.com>
References: <20200211163452.25442-1-frieder.schrempf@kontron.de>
 <20200211163452.25442-4-frieder.schrempf@kontron.de>
 <20200217113919.0508acc4@xps13>
 <cbec4c2f-64f3-3353-b237-83345321d7a7@kontron.de>
In-Reply-To: <cbec4c2f-64f3-3353-b237-83345321d7a7@kontron.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: f6On0xLzP7ennhodhfUe9Q-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogU2NocmVtcGYgRnJpZWRlcg0KPiBTZW50OiAxNyBGZWJydWFyeSAyMDIwIDExOjE5DQo+
ID4gU2NocmVtcGYgRnJpZWRlciA8ZnJpZWRlci5zY2hyZW1wZkBrb250cm9uLmRlPiB3cm90ZSBv
biBUdWUsIDExIEZlYg0KPiA+IDIwMjAgMTY6MzU6NTMgKzAwMDA6DQo+ID4NCj4gPj4gRnJvbTog
RnJpZWRlciBTY2hyZW1wZiA8ZnJpZWRlci5zY2hyZW1wZkBrb250cm9uLmRlPg0KPiA+Pg0KPiA+
PiBDdXJyZW50bHkgd2hlbiBtYXJraW5nIGEgYmxvY2ssIHdlIHVzZSBzcGluYW5kX2VyYXNlX29w
KCkgdG8gZXJhc2UNCj4gPj4gdGhlIGJsb2NrIGJlZm9yZSB3cml0aW5nIHRoZSBtYXJrZXIgdG8g
dGhlIE9PQiBhcmVhIHdpdGhvdXQgd2FpdGluZw0KPiA+PiBmb3IgdGhlIG9wZXJhdGlvbiB0byBz
dWNjZWVkLiBUaGlzIGNhbiBsZWFkIHRvIHRoZSBtYXJraW5nIGZhaWxpbmcNCj4gPj4gc2lsZW50
bHkgYW5kIG5vIGJhZCBibG9jayBtYXJrZXIgYmVpbmcgd3JpdHRlbiB0byB0aGUgZmxhc2guDQo+
ID4+DQo+ID4+IFRvIGZpeCB0aGlzIHdlIHJldXNlIHRoZSBzcGluYW5kX2VyYXNlKCkgZnVuY3Rp
b24sIHRoYXQgYWxyZWFkeSBkb2VzDQo+ID4+IGV2ZXJ5dGhpbmcgd2UgbmVlZCB0byBkbyBiZWZv
cmUgYWN0dWFsbHkgd3JpdGluZyB0aGUgbWFya2VyLg0KPiA+Pg0KPiA+DQo+ID4gVGhhbmtzIGEg
bG90IGZvciB0aGlzIHNlcmllcyENCj4gPg0KPiA+IFlldCBJIGRvbid0IHJlYWxseSB1bmRlcnN0
YW5kIHRoZSBwb2ludCBvZiB3YWl0aW5nIGZvciB0aGUgZXJhc3VyZSBpZg0KPiA+IGl0IGZhaWxl
ZDogd2UgZG9uJ3QgcmVhbGx5IGNhcmUgYXMgcHJvZ3JhbW1pbmcgKDEgLT4gMCkgY2VsbHMgaXMg
YWx3YXlzDQo+ID4gcG9zc2libGUuIEFyZSB5b3Ugc3VyZSB0aGlzIGxlYWQgdG8gYW4gZXJyb3I/
DQo+IA0KPiBXZSBkb24ndCBjYXJlIGFib3V0IHRoZSByZXN1bHQgb2YgdGhlIGVyYXNlIG9wZXJh
dGlvbiwgYnV0IEkgdGhpbmsgd2UNCj4gc3RpbGwgbmVlZCB0byB3YWl0IGZvciBpdCB0byBiZSBk
b25lIGFuZCB0aGUgU1RBVFVTX0JVU1kgYml0IHRvIGJlDQo+IGNsZWFyZWQuIE90aGVyd2lzZSBp
dCBzZWVtcyBsaWtlIHRoZSBwcm9ncmFtIG9wZXJhdGlvbiB0byBzZXQgdGhlIG1hcmtlcg0KPiBj
YW4gZ2V0IGlnbm9yZWQgYnkgdGhlIGNoaXAuIEF0IGxlYXN0IHRoYXQncyBteSBleHBsYW5hdGlv
biBmb3IgdGhlDQo+IGJlaGF2aW9yIEkgd2FzIG9ic2VydmluZy4NCg0KU2VyaWFsIGZsYXNoIGRl
dmljZXMgd29uJ3QgYWxsb3cgYW55IGFjY2Vzc2VzIHdoaWxlIGFuIGVyYXNlIG9yIHdyaXRlDQpp
biBpbiBwcm9ncmVzcy4NClNvIHdoaWxlIHlvdSBkb24ndCBuZWVkIHRvIHdhaXQgZm9yIGVpdGhl
ciB0byBmaW5pc2gsIHlvdSBkbyBuZWVkDQp0byByZW1lbWJlciB0aGF0IG9uZSBpcyAncGVuZGlu
ZycgYW5kIHdhaXQgZm9yIGl0IHRvIGZpbmlzaA0KYmVmb3JlIGFueSBmdXJ0aGVyIGFjY2Vzc2Vz
IChhcGFydCBmcm9tIHJlYWRzIG9mIHRoZSBzdGF0dXMgcmVnaXN0ZXIpLg0KDQpIb3cgbWFueSB3
cml0ZXMgeW91IGNhbiBkbyB0byBhbiBhcmVhICh0aGF0IGNsZWFyIDFzKSBhbmQgdGhlIHNpemUN
Cm9mIHRoZSBhcmVhIHdpbGwgYmUgZGV2aWNlIGRlcGVuZGFudC4NCklJUkMgb25lIGRldmljZSBJ
J3ZlIHVzZWQgYWxsb3dzIDIgd3JpdGVzIHRvIGVhY2ggMTZiaXQgd29yZC4NClRoaXMgYWxsb3dz
IGVpdGhlciB0d28gc2VwYXJhdGUgYnl0ZSB3cml0ZXMgb3Igb25lIHdyaXRlIG9mDQphIDE2Yml0
IChvciAzMmJpdCkgdmFsdWUgZm9sbG93ZWQgYnkgYSBzZWNvbmQgd3JpdGUgb2YgYWxsIDBzDQp0
aGUgJ2VyYXNlJyB0aGUgdmFsdWUgd2l0aG91dCBkb2luZyBhIGVyYXNlLXJld3JpdGUgY3ljbGUu
DQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9h
ZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBO
bzogMTM5NzM4NiAoV2FsZXMpDQo=


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6357268198
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 00:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgIMWDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Sep 2020 18:03:51 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:51071 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgIMWDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Sep 2020 18:03:51 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 337FE891B2;
        Mon, 14 Sep 2020 10:03:48 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1600034628;
        bh=0vTSBRn5WHx7qRnHEBgCpmmxaWmG9AHFklQJK9CNxGo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=SF8O7cSl1ocr6+OhWS+vS23ABoJSWyVCnQvk6PDIGORpHGtwTyQ78AGg2csUwR+Ao
         Q0/w30RLmAy914O+vAjvBJOrQMUcCc46uR+5qrOkyfFEMjK2YO5MhyiKmSqlIPqRt0
         BENaZRZpV3Tii3o2siH3vo2GuOWWYNKP7+wSLTdMLyg8w0DLmWZEzbhZWLdASRcjZu
         AUJIY1TmIGy8yvfo1XrCW665mV8mBbzQoUZtIXk2medGOQjl3JLDIPd5rmqLUiU/dA
         FmjKzUaZtCXpGYsnvtXfHA06LLxV1/j9YbeVaqR6RlvYBpoxYN39JDekTxrvygu1ta
         dWlw/3MdvKH2Q==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f5e97440000>; Mon, 14 Sep 2020 10:03:48 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Mon, 14 Sep 2020 10:03:45 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Mon, 14 Sep 2020 10:03:45 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "broonie@kernel.org" <broonie@kernel.org>,
        "npiggin@gmail.com" <npiggin@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "Joakim Tjernlund" <Joakim.Tjernlund@infinera.com>
CC:     "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] spi: fsl-espi: Only process interrupts for expected
 events
Thread-Topic: [PATCH] spi: fsl-espi: Only process interrupts for expected
 events
Thread-Index: AQHWglJIf7HpaAEB10myzqnWl8w4galmZa8A
Date:   Sun, 13 Sep 2020 22:03:45 +0000
Message-ID: <ecedc71d-100a-7d7a-ff7f-ef1a3086dd74@alliedtelesis.co.nz>
References: <20200904002812.7300-1-chris.packham@alliedtelesis.co.nz>
In-Reply-To: <20200904002812.7300-1-chris.packham@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DDA2418B87C5D64287296F4E4A41AD37@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgQWxsLA0KDQpPbiA0LzA5LzIwIDEyOjI4IHBtLCBDaHJpcyBQYWNraGFtIHdyb3RlOg0KPiBU
aGUgU1BJRSByZWdpc3RlciBjb250YWlucyBjb3VudHMgZm9yIHRoZSBUWCBGSUZPIHNvIGFueSB0
aW1lIHRoZSBpcnENCj4gaGFuZGxlciB3YXMgaW52b2tlZCB3ZSB3b3VsZCBhdHRlbXB0IHRvIHBy
b2Nlc3MgdGhlIFJYL1RYIGZpZm9zLiBVc2UgdGhlDQo+IFNQSU0gdmFsdWUgdG8gbWFzayB0aGUg
ZXZlbnRzIHNvIHRoYXQgd2Ugb25seSBwcm9jZXNzIGludGVycnVwdHMgdGhhdA0KPiB3ZXJlIGV4
cGVjdGVkLg0KPg0KPiBUaGlzIHdhcyBhIGxhdGVudCBpc3N1ZSBleHBvc2VkIGJ5IGNvbW1pdCAz
MjgyYTNkYTI1YmQgKCJwb3dlcnBjLzY0Og0KPiBJbXBsZW1lbnQgc29mdCBpbnRlcnJ1cHQgcmVw
bGF5IGluIEMiKS4NCj4NCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXMgUGFja2hhbSA8Y2hyaXMucGFj
a2hhbUBhbGxpZWR0ZWxlc2lzLmNvLm56Pg0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0K
PiAtLS0NCnBpbmc/DQo+DQo+IE5vdGVzOg0KPiAgICAgIEkndmUgdGVzdGVkIHRoaXMgb24gYSBU
MjA4MFJEQiBhbmQgYSBjdXN0b20gYm9hcmQgdXNpbmcgdGhlIFQyMDgxIFNvQy4gV2l0aA0KPiAg
ICAgIHRoaXMgY2hhbmdlIEkgZG9uJ3Qgc2VlIGFueSBzcHVyaW91cyBpbnN0YW5jZXMgb2YgdGhl
ICJUcmFuc2ZlciBkb25lIGJ1dA0KPiAgICAgIFNQSUVfRE9OIGlzbid0IHNldCEiIG9yICJUcmFu
c2ZlciBkb25lIGJ1dCByeC90eCBmaWZvJ3MgYXJlbid0IGVtcHR5ISIgbWVzc2FnZXMNCj4gICAg
ICBhbmQgdGhlIHVwZGF0ZXMgdG8gc3BpIGZsYXNoIGFyZSBzdWNjZXNzZnVsLg0KPiAgICAgIA0K
PiAgICAgIEkgdGhpbmsgdGhpcyBzaG91bGQgZ28gaW50byB0aGUgc3RhYmxlIHRyZWVzIHRoYXQg
Y29udGFpbiAzMjgyYTNkYTI1YmQgYnV0IEkNCj4gICAgICBoYXZlbid0IGFkZGVkIGEgRml4ZXM6
IHRhZyBiZWNhdXNlIEkgdGhpbmsgMzI4MmEzZGEyNWJkIGV4cG9zZWQgdGhlIGlzc3VlIGFzDQo+
ICAgICAgb3Bwb3NlZCB0byBjYXVzaW5nIGl0Lg0KPg0KPiAgIGRyaXZlcnMvc3BpL3NwaS1mc2wt
ZXNwaS5jIHwgNSArKystLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3NwaS9zcGktZnNsLWVzcGku
YyBiL2RyaXZlcnMvc3BpL3NwaS1mc2wtZXNwaS5jDQo+IGluZGV4IDdlN2M5MmNhZmRiYi4uY2Ix
MjBiNjhjMGUyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3NwaS9zcGktZnNsLWVzcGkuYw0KPiAr
KysgYi9kcml2ZXJzL3NwaS9zcGktZnNsLWVzcGkuYw0KPiBAQCAtNTc0LDEzICs1NzQsMTQgQEAg
c3RhdGljIHZvaWQgZnNsX2VzcGlfY3B1X2lycShzdHJ1Y3QgZnNsX2VzcGkgKmVzcGksIHUzMiBl
dmVudHMpDQo+ICAgc3RhdGljIGlycXJldHVybl90IGZzbF9lc3BpX2lycShzMzIgaXJxLCB2b2lk
ICpjb250ZXh0X2RhdGEpDQo+ICAgew0KPiAgIAlzdHJ1Y3QgZnNsX2VzcGkgKmVzcGkgPSBjb250
ZXh0X2RhdGE7DQo+IC0JdTMyIGV2ZW50czsNCj4gKwl1MzIgZXZlbnRzLCBtYXNrOw0KPiAgIA0K
PiAgIAlzcGluX2xvY2soJmVzcGktPmxvY2spOw0KPiAgIA0KPiAgIAkvKiBHZXQgaW50ZXJydXB0
IGV2ZW50cyh0eC9yeCkgKi8NCj4gICAJZXZlbnRzID0gZnNsX2VzcGlfcmVhZF9yZWcoZXNwaSwg
RVNQSV9TUElFKTsNCj4gLQlpZiAoIWV2ZW50cykgew0KPiArCW1hc2sgPSBmc2xfZXNwaV9yZWFk
X3JlZyhlc3BpLCBFU1BJX1NQSU0pOw0KPiArCWlmICghKGV2ZW50cyAmIG1hc2spKSB7DQo+ICAg
CQlzcGluX3VubG9jaygmZXNwaS0+bG9jayk7DQo+ICAgCQlyZXR1cm4gSVJRX05PTkU7DQo+ICAg
CX0=

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9697B1BA665
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 16:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgD0OaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 10:30:04 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:22856 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727848AbgD0OaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 10:30:03 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-23-AKHUs2ulObCffgz2Mb-tuA-1; Mon, 27 Apr 2020 15:28:25 +0100
X-MC-Unique: AKHUs2ulObCffgz2Mb-tuA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 27 Apr 2020 15:28:24 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 27 Apr 2020 15:28:24 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Roberto Sassu' <roberto.sassu@huawei.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "rgoldwyn@suse.de" <rgoldwyn@suse.de>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        Krzysztof Struczynski <krzysztof.struczynski@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 3/6] ima: Fix ima digest hash table key calculation
Thread-Topic: [PATCH v2 3/6] ima: Fix ima digest hash table key calculation
Thread-Index: AQHWHH8SDZUC+XMi6UOqF9nBthnXX6iMzGEggAAOugCAACgi8A==
Date:   Mon, 27 Apr 2020 14:28:24 +0000
Message-ID: <5786ad88cd184e5791bc285d5cac6ecc@AcuMS.aculab.com>
References: <20200427102900.18887-1-roberto.sassu@huawei.com>
 <20200427102900.18887-3-roberto.sassu@huawei.com>
 <84ecd8f2576849b29876448df66824fc@AcuMS.aculab.com>
 <90e19242fd8445cf93728c0946c03c19@huawei.com>
In-Reply-To: <90e19242fd8445cf93728c0946c03c19@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogUm9iZXJ0byBTYXNzdQ0KPiBTZW50OiAyNyBBcHJpbCAyMDIwIDEzOjUxDQouLi4NCj4g
PiA+IC1zdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgaW1hX2hhc2hfa2V5KHU4ICpkaWdlc3Qp
DQo+ID4gPiArc3RhdGljIGlubGluZSB1bnNpZ25lZCBpbnQgaW1hX2hhc2hfa2V5KHU4ICpkaWdl
c3QpDQo+ID4gPiAgew0KPiA+ID4gLQlyZXR1cm4gaGFzaF9sb25nKCpkaWdlc3QsIElNQV9IQVNI
X0JJVFMpOw0KPiA+ID4gKwlyZXR1cm4gKCoodW5zaWduZWQgaW50ICopZGlnZXN0ICUgSU1BX01F
QVNVUkVfSFRBQkxFX1NJWkUpOw0KPiA+DQo+ID4gVGhhdCBhbG1vc3QgY2VydGFpbmx5IGlzbid0
IHJpZ2h0Lg0KPiA+IEl0IGZhbGxzIGZvdWwgb2YgdGhlICooaW50ZWdlcl90eXBlICopcHRyIGJl
aW5nIGFsbW9zdCBhbHdheXMgd3JvbmcuDQo+IA0KPiBJIGRpZG4ndCBmaW5kIHRoZSBwcm9ibGVt
LiBDYW4geW91IHBsZWFzZSBleHBsYWluPw0KDQpUaGUgZ2VuZXJhbCBwcm9ibGVtIHdpdGggKihp
bnRfdHlwZSAqKXB0ciBpcyB0aGF0IGl0IGRvZXMgY29tcGxldGVseQ0KdGhlIHdyb25nIHRoaW5n
IGlmICdwdHInIGlzIHRoZSBhZGRyZXNzIG9mIGEgbGFyZ2VyIGludGVnZXIgdHlwZSBvbg0KYSBi
aWctZW5kaWFuIHN5c3RlbS4NCllvdSBtYXkgYWxzbyBnZXQgYSBtaXNhbGlnbmVkIGFjY2VzcyB0
cmFwLg0KDQpJbiB0aGlzIGNhc2UgSSBndWVzcyB0aGF0IGRpZ2VzdCBpcyBhY3R1YWxseSB1OFtT
SEExX0RJR0VTVF9TSVpFXS4NCk1heWJlIHdoYXQgeW91IHNob3VsZCByZXR1cm4gaXM6DQoJKGRp
Z2VzdFswXSB8IGRpZ2VzdFsxXSA8PCA4KSAlIElNQV9NRUFTVVJFX0hUQUJMRV9TSVpFOw0KYW5k
IGNvbW1lbnQgdGhhdCB0aGVyZSBpcyBubyBwb2ludCB0YWtpbmcgYSBoYXNoIG9mIHBhcnQgb2YN
CmEgU0hBMSBkaWdlc3QuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNp
ZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsN
ClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=


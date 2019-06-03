Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3292933288
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 16:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbfFCOoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 10:44:12 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:6537 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729362AbfFCOoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 10:44:12 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id ABDE473F26C1B62FBD33;
        Mon,  3 Jun 2019 22:44:06 +0800 (CST)
Received: from dggeme704-chm.china.huawei.com (10.1.199.100) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 3 Jun 2019 22:44:05 +0800
Received: from dggeme762-chm.china.huawei.com (10.3.19.108) by
 dggeme704-chm.china.huawei.com (10.1.199.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Mon, 3 Jun 2019 22:44:05 +0800
Received: from dggeme762-chm.china.huawei.com ([10.8.68.53]) by
 dggeme762-chm.china.huawei.com ([10.8.68.53]) with mapi id 15.01.1591.008;
 Mon, 3 Jun 2019 22:44:05 +0800
From:   gaoyongliang <gaoyongliang@huawei.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "punitagrawal@gmail.com" <punitagrawal@gmail.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Chenjie (K)" <chenjie6@huawei.com>,
        Nixiaoming <nixiaoming@huawei.com>,
        Zengweilin <zengweilin@huawei.com>,
        Shiwenlu <shiwenlu@huawei.com>
Subject: Re: [PATCH] arm: fix using smp_processor_id() in preemptible context
Thread-Topic: [PATCH] arm: fix using smp_processor_id() in preemptible context
Thread-Index: AdUaGpxZgkuQtJQ9aUeV34E/V29yBQ==
Date:   Mon, 3 Jun 2019 14:44:05 +0000
Message-ID: <d003bd4642aa44e1a51b83cd0bf1f04e@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.63.153.231]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgTWFyYywNCg0KT24gMjAxOS82LzMgMTg6MTcsIE1hcmMgWnluZ2llciB3cm90ZToNCj4gT24g
MjcvMDUvMjAxOSAxMDozOSwgWW9uZ2xpYW5nIEdhbyB3cm90ZToNCj4+IGhhcmRlbl9icmFuY2hf
cHJlZGljdG9yKCkgY2FsbCBzbXBfcHJvY2Vzc29yX2lkKCkgaW4gcHJlZW1wdGlibGUNCj4+IGNv
bnRleHQsIHRoaXMgd291bGQgY2F1c2UgYSBidWcgbWVzc2FnZXMuDQo+Pg0KPj4gVGhlIGJ1ZyBt
ZXNzYWdlcyBpcyBhcyBmb2xsb3dzOg0KPj4gQlVHOiB1c2luZyBzbXBfcHJvY2Vzc29yX2lkKCkg
aW4gcHJlZW1wdGlibGUgWzAwMDAwMDAwXSBjb2RlOiBzeXotZXhlY3V0b3IwLzE3OTkyDQo+PiBj
YWxsZXIgaXMgaGFyZGVuX2JyYW5jaF9wcmVkaWN0b3IgYXJjaC9hcm0vaW5jbHVkZS9hc20vc3lz
dGVtX21pc2MuaDoyNyBbaW5saW5lXQ0KPj4gY2FsbGVyIGlzIF9fZG9fdXNlcl9mYXVsdCsweDM0
LzB4MTE0IGFyY2gvYXJtL21tL2ZhdWx0LmM6MjAwDQo+PiBDUFU6IDEgUElEOiAxNzk5MiBDb21t
OiBzeXotZXhlY3V0b3IwIFRhaW50ZWQ6IEcgTyA0LjQuMTc2ICMxDQo+PiBIYXJkd2FyZSBuYW1l
OiBIaXNpbGljb24gQTkNCj4+IFs8YzAxMTRhZTQ+XSAodW53aW5kX2JhY2t0cmFjZSkgZnJvbSBb
PGMwMTBlNmZjPl0gKHNob3dfc3RhY2srMHgxOC8weDFjKQ0KPj4gWzxjMDEwZTZmYz5dIChzaG93
X3N0YWNrKSBmcm9tIFs8YzAzNzk1MTQ+XSAoZHVtcF9zdGFjaysweGM4LzB4MTE4KQ0KPj4gWzxj
MDM3OTUxND5dIChkdW1wX3N0YWNrKSBmcm9tIFs8YzAzOWI1YTA+XSAoY2hlY2tfcHJlZW1wdGlv
bl9kaXNhYmxlZCsweGY0LzB4MTM4KQ0KPj4gWzxjMDM5YjVhMD5dIChjaGVja19wcmVlbXB0aW9u
X2Rpc2FibGVkKSBmcm9tIFs8YzAxMWFiZTQ+XSAoX19kb191c2VyX2ZhdWx0KzB4MzQvMHgxMTQp
DQo+PiBbPGMwMTFhYmU0Pl0gKF9fZG9fdXNlcl9mYXVsdCkgZnJvbSBbPGMwNTNiMGQwPl0gKGRv
X3BhZ2VfZmF1bHQrMHgzYjQvMHgzZDgpDQo+PiBbPGMwNTNiMGQwPl0gKGRvX3BhZ2VfZmF1bHQp
IGZyb20gWzxjMDEwMTNkYz5dIChkb19EYXRhQWJvcnQrMHg1OC8weGY4KQ0KPj4gWzxjMDEwMTNk
Yz5dIChkb19EYXRhQWJvcnQpIGZyb20gWzxjMDUzYTg4MD5dIChfX2RhYnRfdXNyKzB4NDAvMHg2
MCkNCj4+DQo+PiBSZXBvcnRlZC1ieTogSmluZ3dlbiBRaXUgPHFpdWppbmd3ZW5AaHVhd2VpLmNv
bT4NCj4+IFNpZ25lZC1vZmYtYnk6IFlvbmdsaWFuZyBHYW8gPGdhb3lvbmdsaWFuZ0BodWF3ZWku
Y29tPg0KPj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPj4gLS0tDQo+PiAgYXJjaC9h
cm0vaW5jbHVkZS9hc20vc3lzdGVtX21pc2MuaCB8IDMgKystDQo+PiAgMSBmaWxlIGNoYW5nZWQs
IDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9hcmNo
L2FybS9pbmNsdWRlL2FzbS9zeXN0ZW1fbWlzYy5oIGIvYXJjaC9hcm0vaW5jbHVkZS9hc20vc3lz
dGVtX21pc2MuaA0KPj4gaW5kZXggNjZmNmEzYS4uNGE1NWNmYiAxMDA2NDQNCj4+IC0tLSBhL2Fy
Y2gvYXJtL2luY2x1ZGUvYXNtL3N5c3RlbV9taXNjLmgNCj4+ICsrKyBiL2FyY2gvYXJtL2luY2x1
ZGUvYXNtL3N5c3RlbV9taXNjLmgNCj4+IEBAIC0yMiw5ICsyMiwxMCBAQA0KPj4gIHN0YXRpYyBp
bmxpbmUgdm9pZCBoYXJkZW5fYnJhbmNoX3ByZWRpY3Rvcih2b2lkKQ0KPj4gIHsNCj4+ICAJaGFy
ZGVuX2JyYW5jaF9wcmVkaWN0b3JfZm5fdCBmbiA9IHBlcl9jcHUoaGFyZGVuX2JyYW5jaF9wcmVk
aWN0b3JfZm4sDQo+PiAtCQkJCQkJICBzbXBfcHJvY2Vzc29yX2lkKCkpOw0KPj4gKwkJCQkJCSAg
Z2V0X2NwdSgpKTsNCj4+ICAJaWYgKGZuKQ0KPj4gIAkJZm4oKTsNCj4+ICsJcHV0X2NwdSgpOw0K
Pj4gIH0NCj4+ICAjZWxzZQ0KPj4gICNkZWZpbmUgaGFyZGVuX2JyYW5jaF9wcmVkaWN0b3IoKSBk
byB7IH0gd2hpbGUgKDApDQo+Pg0KPiANCj4gVGhpcyBkb2Vzbid0IGxvb2sgbGlrZSB0aGUgcmln
aHQgZml4LiBJZiB3ZSdyZSBpbiBhIHByZWVtcHRpYmxlIGNvbnRleHQsDQo+IHRoZW4gd2UgY291
bGQgaW52YWxpZGF0ZSB0aGUgYnJhbmNoIHByZWRpY3RvciBvbiB0aGUgd3JvbmcgQ1BVLg0KDQpT
b3JyeSwgbXkgYmFkLCB0aGFua3MgYSBsb3QgZm9yIHRoZSBnb29kIGNhdGNoLg0KDQo+IA0KPiBU
aGUgcmlnaHQgZml4IHdvdWxkIGJlIHRvIG1vdmUgdGhlIGNhbGwgdG8gYSBwb2ludCB3aGVyZSB3
ZSBoYXZlbid0DQo+IGVuYWJsZWQgcHJlZW1wdGlvbiB5ZXQuDQoNCkkgdG9vayBhIGxvb2sgYXQg
dGhlIGNvZGUsIGFuZCBmaW5kIG91dCB0aGF0IHRoZSBjYWxsZXIgb2YNCmhhcmRlbl9icmFuY2hf
cHJlZGljdG9yKCksIF9fZG9fdXNlcl9mYXVsdCgpLCBpcyBjYWxsZWQgYnkgZG9fcGFnZV9mYXVs
dCgpDQphbmQgZG9fYmFkX2FyZWEoKSwgdGhvc2UgdHdvIGZ1bmN0aW9uJ3MgY29udGV4dCBhcmUg
Ym90aCBydW5uaW5nIHdpdGgNCnByZWVtcHRpb24gZW5hYmxlZCwgc28gSSBkaWRuJ3QgZmluZCBh
IGdvb2QgcGxhY2UgdG8gbW92ZSB0aGUgY2FsbCwNCmNvdWxkIHlvdSBwbGVhc2UgZ2l2ZSBzb21l
IHN1Z2dlc3Rpb24gZm9yIG15IG5leHQgc3RlcD8NCg0KQmVzdCBSZWdhcmRzDQpZb25nbGlhbmcN
Cg==

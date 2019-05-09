Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 305B819489
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 23:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfEIVVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 17:21:42 -0400
Received: from mail-eopbgr800074.outbound.protection.outlook.com ([40.107.80.74]:53471
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726682AbfEIVVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 17:21:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3uR7HRLZE1AAqz9VCIR4SL1BD4Igne+yoNtHXMu3t6s=;
 b=BayIfWjWGds+5ehDm+E3QNBMjkoaLsMHNzXjge6At0s+vUIcal9XTbXvJVxKZsxoLn4qGeN6WasRDP8O6kFQhWJO+sw09RKDaLE253t28XDUxEORMnpyENsNkvfydpQRFsYjwzaFy1evLFqyPanXXMeK81WaRTiu9TXBGOpeCeU=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB4711.namprd05.prod.outlook.com (52.135.233.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.17; Thu, 9 May 2019 21:21:35 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::b057:917a:f098:6098]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::b057:917a:f098:6098%7]) with mapi id 15.20.1900.006; Thu, 9 May 2019
 21:21:35 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Yang Shi <yang.shi@linux.alibaba.com>,
        "jstancek@redhat.com" <jstancek@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Nick Piggin <npiggin@gmail.com>, Nadav Amit <namit@vmware.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Thread-Topic: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Thread-Index: AQHVBlNcdgyGQHvMg0ymTH6Y7O8srKZjDs8AgAANcoCAAAcZgIAABfcAgAAkYwA=
Date:   Thu, 9 May 2019 21:21:35 +0000
Message-ID: <7DA60772-3EE3-4882-B26F-2A900690DA15@vmware.com>
References: <1557264889-109594-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190509083726.GA2209@brain-police>
 <20190509103813.GP2589@hirez.programming.kicks-ass.net>
 <F22533A7-016F-4506-809A-7E86BAF24D5A@vmware.com>
 <20190509182435.GA2623@hirez.programming.kicks-ass.net>
 <04668E51-FD87-4D53-A066-5A35ABC3A0D6@vmware.com>
 <20190509191120.GD2623@hirez.programming.kicks-ass.net>
In-Reply-To: <20190509191120.GD2623@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2810e6c4-675e-4fc1-1aa3-08d6d4c450db
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR05MB4711;
x-ms-traffictypediagnostic: BYAPR05MB4711:
x-microsoft-antispam-prvs: <BYAPR05MB471114BC0825CCAB9BBD74BFD0330@BYAPR05MB4711.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 003245E729
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(366004)(376002)(346002)(51444003)(199004)(189003)(6916009)(2906002)(81166006)(81156014)(6512007)(82746002)(4326008)(8936002)(53936002)(478600001)(7416002)(6246003)(83716004)(7736002)(6436002)(305945005)(54906003)(6486002)(68736007)(229853002)(14454004)(14444005)(256004)(8676002)(6116002)(3846002)(33656002)(6506007)(102836004)(86362001)(25786009)(2616005)(316002)(476003)(66066001)(11346002)(486006)(53546011)(99286004)(36756003)(5660300002)(446003)(186003)(76176011)(66446008)(76116006)(73956011)(66946007)(26005)(66476007)(66556008)(64756008)(71190400001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4711;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: c3R+O4MqUzDTikTMFffNmxOnPyDUZBlAn0A1vCHn35I1/OKLr9Wl3n+58PzRQUdQOwVmWrQReUS9j551U1BPA1tOWKszTSLbaoAahzoKBQjj2AJxhMxW2vi4CXi8d/uT6FmSdl3UohBfcFYE8C7lKnZDIh6pbpK5mh9FZSAcu8iOZ/2YU+EDrnWVKxpR83px8YXxzWa3pzKfMmhH+n/hTQnKSis5PoLD6WAAJlymiwTx/OhfFlLaB/GDaeLANg2dj4kmJE+yBCL+/MFa+JkJFlSwPKOfBUidU9rdSL405hFue5j5bqXS+TtUk8LUwqVUI1KmH2mPYKqOq/21nT2D1MlYjvsWFzZYWrVlnbebVIROgVk6wJfGLqFtni0rG4qse+f+BDMO6CzV9yQ++QvorbRKqGBNVGnCqTlVgRN+Bzg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <37B461CEAAF13447B2A08CEACA55FAE5@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2810e6c4-675e-4fc1-1aa3-08d6d4c450db
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2019 21:21:35.3619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4711
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

WyBSZXN0b3JpbmcgdGhlIHJlY2lwaWVudHMgYWZ0ZXIgbWlzdGFrZW5seSBwcmVzc2luZyByZXBs
eSBpbnN0ZWFkIG9mDQpyZXBseS1hbGwgXQ0KDQo+IE9uIE1heSA5LCAyMDE5LCBhdCAxMjoxMSBQ
TSwgUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZyYWRlYWQub3JnPiB3cm90ZToNCj4gDQo+IE9u
IFRodSwgTWF5IDA5LCAyMDE5IGF0IDA2OjUwOjAwUE0gKzAwMDAsIE5hZGF2IEFtaXQgd3JvdGU6
DQo+Pj4gT24gTWF5IDksIDIwMTksIGF0IDExOjI0IEFNLCBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6
QGluZnJhZGVhZC5vcmc+IHdyb3RlOg0KPj4+IA0KPj4+IE9uIFRodSwgTWF5IDA5LCAyMDE5IGF0
IDA1OjM2OjI5UE0gKzAwMDAsIE5hZGF2IEFtaXQgd3JvdGU6DQo+IA0KPj4+PiBBcyBhIHNpbXBs
ZSBvcHRpbWl6YXRpb24sIEkgdGhpbmsgaXQgaXMgcG9zc2libGUgdG8gaG9sZCBtdWx0aXBsZSBu
ZXN0aW5nDQo+Pj4+IGNvdW50ZXJzIGluIHRoZSBtbSwgc2ltaWxhciB0byB0bGJfZmx1c2hfcGVu
ZGluZywgZm9yIGZyZWVkX3RhYmxlcywNCj4+Pj4gY2xlYXJlZF9wdGVzLCBldGMuDQo+Pj4+IA0K
Pj4+PiBUaGUgZmlyc3QgdGltZSB5b3Ugc2V0IHRsYi0+ZnJlZWRfdGFibGVzLCB5b3UgYWxzbyBh
dG9taWNhbGx5IGluY3JlYXNlDQo+Pj4+IG1tLT50bGJfZmx1c2hfZnJlZWRfdGFibGVzLiBUaGVu
LCBpbiB0bGJfZmx1c2hfbW11KCksIHlvdSBqdXN0IHVzZQ0KPj4+PiBtbS0+dGxiX2ZsdXNoX2Zy
ZWVkX3RhYmxlcyBpbnN0ZWFkIG9mIHRsYi0+ZnJlZWRfdGFibGVzLg0KPj4+IA0KPj4+IFRoYXQg
c291bmRzIGZyYXVnaHQgd2l0aCByYWNlcyBhbmQgZXhwZW5zaXZlOyBJIHdvdWxkIG11Y2ggcHJl
ZmVyIHRvIG5vdA0KPj4+IGdvIHRoZXJlIGZvciB0aGlzIGFyZ3VhYmx5IHJhcmUgY2FzZS4NCj4+
PiANCj4+PiBDb25zaWRlciBzdWNoIGZ1biBjYXNlcyBhcyB3aGVyZSBDUFUtMCBzZWVzIGFuZCBj
bGVhcnMgYSBQVEUsIENQVS0xDQo+Pj4gcmFjZXMgYW5kIGRvZXNuJ3Qgc2VlIHRoYXQgUFRFLiBU
aGVyZWZvcmUgQ1BVLTAgc2V0cyBhbmQgY291bnRzDQo+Pj4gY2xlYXJlZF9wdGVzLiBUaGVuIGlm
IENQVS0xIGZsdXNoZXMgd2hpbGUgQ1BVLTAgaXMgc3RpbGwgaW4gbW11X2dhdGhlciwNCj4+PiBp
dCB3aWxsIHNlZSBjbGVhcmVkX3B0ZXMgY291bnQgaW5jcmVhc2VkIGFuZCBmbHVzaCB0aGF0IGdy
YW51bGFyaXR5LA0KPj4+IE9UT0ggaWYgQ1BVLTEgZmx1c2hlcyBhZnRlciBDUFUtMCBjb21wbGV0
ZXMsIGl0IHdpbGwgbm90IGFuZCBwb3RlbnRpYWxsDQo+Pj4gbWlzcyBhbiBpbnZhbGlkYXRlIGl0
IHNob3VsZCBoYXZlIGhhZC4NCj4+IA0KPj4gQ1BVLTAgd291bGQgc2VuZCBhIFRMQiBzaG9vdGRv
d24gcmVxdWVzdCB0byBDUFUtMSB3aGVuIGl0IGlzIGRvbmUsIHNvIEkNCj4+IGRvbuKAmXQgc2Vl
IHRoZSBwcm9ibGVtLiBUaGUgVExCIHNob290ZG93biBtZWNoYW5pc20gaXMgaW5kZXBlbmRlbnQg
b2YgdGhlDQo+PiBtbXVfZ2F0aGVyIGZvciB0aGUgbWF0dGVyLg0KPiANCj4gRHVoLi4gSSBzdGls
bCBkb24ndCBsaWtlIHRob3NlIHVuY29uZGl0aW9uYWwgbW0gd2lkZSBhdG9taWMgY291bnRlcnMu
DQo+IA0KPj4+IFRoaXMgd2hvbGUgY29uY3VycmVudCBtbXVfZ2F0aGVyIHN0dWZmIGlzIGhvcnJp
YmxlLg0KPj4+IA0KPj4+IC9tZSBwb25kZXJzIG1vcmUuLi4uDQo+Pj4gDQo+Pj4gU28gSSB0aGlu
ayB0aGUgZnVuZGFtZW50YWwgcmFjZSBoZXJlIGlzIHRoaXM6DQo+Pj4gDQo+Pj4gCUNQVS0wCQkJ
CUNQVS0xDQo+Pj4gDQo+Pj4gCXRsYl9nYXRoZXJfbW11KC5zdGFydD0xLAl0bGJfZ2F0aGVyX21t
dSguc3RhcnQ9MiwNCj4+PiAJCSAgICAgICAuZW5kPTMpOwkJCSAgICAgICAuZW5kPTQpOw0KPj4+
IA0KPj4+IAlwdGVwX2dldF9hbmRfY2xlYXJfZnVsbCgyKQ0KPj4+IAl0bGJfcmVtb3ZlX3RsYl9l
bnRyeSgyKTsNCj4+PiAJX190bGJfcmVtb3ZlX3BhZ2UoKTsNCj4+PiAJCQkJCWlmIChwdGVfcHJl
c2VudCgyKSkgLy8gbm9wZQ0KPj4+IA0KPj4+IAkJCQkJdGxiX2ZpbmlzaF9tbXUoKTsNCj4+PiAN
Cj4+PiAJCQkJCS8vIGNvbnRpbnVlIHdpdGhvdXQgVExCSSgyKQ0KPj4+IAkJCQkJLy8gd2hvb3Bz
aWUNCj4+PiANCj4+PiAJdGxiX2ZpbmlzaF9tbXUoKTsNCj4+PiAJICB0bGJfZmx1c2goKQkJLT4J
VExCSSgyKQ0KPj4+IA0KPj4+IA0KPj4+IEFuZCB3ZSBjYW4gZml4IHRoYXQgYnkgaGF2aW5nIHRs
Yl9maW5pc2hfbW11KCkgc3luYyB1cC4gTmV2ZXIgbGV0IGENCj4+PiBjb25jdXJyZW50IHRsYl9m
aW5pc2hfbW11KCkgY29tcGxldGUgdW50aWwgYWxsIGNvbmN1cnJlbmN0IG1tdV9nYXRoZXJzDQo+
Pj4gaGF2ZSBjb21wbGV0ZWQuDQo+Pj4gDQo+Pj4gVGhpcyBzaG91bGQgbm90IGJlIHRvbyBoYXJk
IHRvIG1ha2UgaGFwcGVuLg0KPj4gDQo+PiBUaGlzIHN5bmNocm9uaXphdGlvbiBzb3VuZHMgbXVj
aCBtb3JlIGV4cGVuc2l2ZSB0aGFuIHdoYXQgSSBwcm9wb3NlZC4gQnV0IEkNCj4+IGFncmVlIHRo
YXQgY2FjaGUtbGluZXMgdGhhdCBtb3ZlIGZyb20gb25lIENQVSB0byBhbm90aGVyIG1pZ2h0IGJl
Y29tZSBhbg0KPj4gaXNzdWUuIEJ1dCBJIHRoaW5rIHRoYXQgdGhlIHNjaGVtZSBJIHN1Z2dlc3Rl
ZCB3b3VsZCBtaW5pbWl6ZSB0aGlzIG92ZXJoZWFkLg0KPiANCj4gV2VsbCwgaXQgd291bGQgaGF2
ZSBhIGxvdCBtb3JlIHVuY29uZGl0aW9uYWwgYXRvbWljIG9wcy4gTXkgc2NoZW1lIG9ubHkNCj4g
d2FpdHMgd2hlbiB0aGVyZSBpcyBhY3R1YWwgY29uY3VycmVuY3kuDQoNCldlbGwsIHNvbWV0aGlu
ZyBoYXMgdG8gZ2l2ZS4gSSBkaWRu4oCZdCB0aGluayB0aGF0IGlmIHRoZSBzYW1lIGNvcmUgZG9l
cyB0aGUNCmF0b21pYyBvcCBpdCB3b3VsZCBiZSB0b28gZXhwZW5zaXZlLg0KDQo+IEkgX3RoaW5r
XyBzb21ldGhpbmcgbGlrZSB0aGUgYmVsb3cgb3VnaHQgdG8gd29yaywgYnV0IGl0cyBub3QgZXZl
biBiZWVuDQo+IG5lYXIgYSBjb21waWxlci4gVGhlIG9ubHkgcHJvYmxlbSBpcyB0aGUgdW5jb25k
aXRpb25hbCB3YWtldXA7IHdlIGNhbg0KPiBwbGF5IGdhbWVzIHRvIGF2b2lkIHRoYXQgaWYgd2Ug
d2FudCB0byBjb250aW51ZSB3aXRoIHRoaXMuDQo+IA0KPiBJZGVhbGx5IHdlJ2Qgb25seSBkbyB0
aGlzIHdoZW4gdGhlcmUncyBiZWVuIGFjdHVhbCBvdmVybGFwLCBidXQgSSd2ZSBub3QNCj4gZm91
bmQgYSBzZW5zaWJsZSB3YXkgdG8gZGV0ZWN0IHRoYXQuDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5j
bHVkZS9saW51eC9tbV90eXBlcy5oIGIvaW5jbHVkZS9saW51eC9tbV90eXBlcy5oDQo+IGluZGV4
IDRlZjRiYmU3OGExZC4uYjcwZTM1NzkyZDI5IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4
L21tX3R5cGVzLmgNCj4gKysrIGIvaW5jbHVkZS9saW51eC9tbV90eXBlcy5oDQo+IEBAIC01OTAs
NyArNTkwLDEyIEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBkZWNfdGxiX2ZsdXNoX3BlbmRpbmcoc3Ry
dWN0IG1tX3N0cnVjdCAqbW0pDQo+IAkgKg0KPiAJICogVGhlcmVmb3JlIHdlIG11c3QgcmVseSBv
biB0bGJfZmx1c2hfKigpIHRvIGd1YXJhbnRlZSBvcmRlci4NCj4gCSAqLw0KPiAtCWF0b21pY19k
ZWMoJm1tLT50bGJfZmx1c2hfcGVuZGluZyk7DQo+ICsJaWYgKGF0b21pY19kZWNfYW5kX3Rlc3Qo
Jm1tLT50bGJfZmx1c2hfcGVuZGluZykpIHsNCj4gKwkJd2FrZV91cF92YXIoJm1tLT50bGJfZmx1
c2hfcGVuZGluZyk7DQo+ICsJfSBlbHNlIHsNCj4gKwkJd2FpdF9ldmVudF92YXIoJm1tLT50bGJf
Zmx1c2hfcGVuZGluZywNCj4gKwkJCSAgICAgICAhYXRvbWljX3JlYWRfYWNxdWlyZSgmbW0tPnRs
Yl9mbHVzaF9wZW5kaW5nKSk7DQo+ICsJfQ0KPiB9DQoNCkl0IHN0aWxsIHNlZW1zIHZlcnkgZXhw
ZW5zaXZlIHRvIG1lLCBhdCBsZWFzdCBmb3IgY2VydGFpbiB3b3JrbG9hZHMgKGUuZy4sDQpBcGFj
aGUgd2l0aCBtdWx0aXRocmVhZGVkIE1QTSkuDQoNCkl0IG1heSBiZSBwb3NzaWJsZSB0byBhdm9p
ZCBmYWxzZS1wb3NpdGl2ZSBuZXN0aW5nIGluZGljYXRpb25zICh3aGVuIHRoZQ0KZmx1c2hlcyBk
byBub3Qgb3ZlcmxhcCkgYnkgY3JlYXRpbmcgYSBuZXcgc3RydWN0IG1tdV9nYXRoZXJfcGVuZGlu
Zywgd2l0aA0Kc29tZXRoaW5nIGxpa2U6DQoNCiAgc3RydWN0IG1tdV9nYXRoZXJfcGVuZGluZyB7
DQogCXU2NCBzdGFydDsNCgl1NjQgZW5kOw0KCXN0cnVjdCBtbXVfZ2F0aGVyX3BlbmRpbmcgKm5l
eHQ7DQogIH0NCg0KdGxiX2ZpbmlzaF9tbXUoKSB3b3VsZCB0aGVuIGl0ZXJhdGUgb3ZlciB0aGUg
bW0tPm1tdV9nYXRoZXJfcGVuZGluZw0KKHBvaW50aW5nIHRvIHRoZSBsaW5rZWQgbGlzdCkgYW5k
IGZpbmQgd2hldGhlciB0aGVyZSBpcyBhbnkgb3ZlcmxhcC4gVGhpcw0Kd291bGQgc3RpbGwgcmVx
dWlyZSBzeW5jaHJvbml6YXRpb24gKGFjcXVpcmluZyBhIGxvY2sgd2hlbiBhbGxvY2F0aW5nIGFu
ZA0KZGVhbGxvY2F0aW5nIG9yIHNvbWV0aGluZyBmYW5jaWVyKS4NCg0K

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95291B269
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 11:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbfEMJLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 05:11:46 -0400
Received: from mail-eopbgr700051.outbound.protection.outlook.com ([40.107.70.51]:33184
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726132AbfEMJLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 05:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtybcWDbOKI3896SyjwYPpijOF11AfCIV1TpGLQImZc=;
 b=ZLw/TxZxyhgYlzGr9Hg2UmKGM/GDFZSoBxqiUwr1wVru10+LlprK1F94VAPcFgKYxBuyE3AcTsZxmlStL10JcXR5VO7thQMnSWWcVMMQewwofwkKS/gSnAUbjMs6t8LSK2noL1IBJWaW9YG1wZ3H4owcsxs0lfShNw44+uyiT6c=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB3991.namprd05.prod.outlook.com (52.135.199.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.19; Mon, 13 May 2019 09:11:39 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::b057:917a:f098:6098]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::b057:917a:f098:6098%7]) with mapi id 15.20.1900.010; Mon, 13 May 2019
 09:11:39 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Yang Shi <yang.shi@linux.alibaba.com>,
        "jstancek@redhat.com" <jstancek@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Nick Piggin <npiggin@gmail.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Thread-Topic: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Thread-Index: AQHVBlNcdgyGQHvMg0ymTH6Y7O8srKZjDs8AgAANcoCAAAcZgIAABfcAgAAkYwCABXN1AIAACeyA
Date:   Mon, 13 May 2019 09:11:38 +0000
Message-ID: <75FD46B2-2E0C-41F2-9308-AB68C8780E33@vmware.com>
References: <1557264889-109594-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190509083726.GA2209@brain-police>
 <20190509103813.GP2589@hirez.programming.kicks-ass.net>
 <F22533A7-016F-4506-809A-7E86BAF24D5A@vmware.com>
 <20190509182435.GA2623@hirez.programming.kicks-ass.net>
 <04668E51-FD87-4D53-A066-5A35ABC3A0D6@vmware.com>
 <20190509191120.GD2623@hirez.programming.kicks-ass.net>
 <7DA60772-3EE3-4882-B26F-2A900690DA15@vmware.com>
 <20190513083606.GL2623@hirez.programming.kicks-ass.net>
In-Reply-To: <20190513083606.GL2623@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [50.204.119.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd500dcc-4142-40be-cad3-08d6d78301d7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR05MB3991;
x-ms-traffictypediagnostic: BYAPR05MB3991:
x-microsoft-antispam-prvs: <BYAPR05MB39915BDFF0257003483D8A0AD00F0@BYAPR05MB3991.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(346002)(136003)(39860400002)(396003)(51444003)(199004)(189003)(26005)(71190400001)(7416002)(83716004)(81156014)(82746002)(6916009)(71200400001)(8936002)(305945005)(229853002)(7736002)(81166006)(446003)(478600001)(25786009)(186003)(6486002)(6436002)(4326008)(8676002)(14444005)(86362001)(99286004)(256004)(11346002)(476003)(54906003)(14454004)(486006)(66066001)(2616005)(53936002)(6506007)(6246003)(76176011)(53546011)(6512007)(102836004)(68736007)(316002)(3846002)(6116002)(64756008)(2906002)(33656002)(66476007)(66556008)(5660300002)(66446008)(91956017)(76116006)(73956011)(66946007)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB3991;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XHsRYBCcUwJS1F6oiOx9ddAWKCNGafHK7j7pqStWVYHqx/r3WJP+SgOZX3THqY1PbwCBtjmuPBE1m2iSSiDifZmS83//caDqq/jvxIPAq3P5x4CNE6Xl6sOigpEk+bSQciSSg7tp4rO1RHnaWvZ09KFx49ZcfNBjchkOWpfigBZeQZ+yZBjcSisftmLmvL7W+bw9unGlXSE/fqgVlUME+qtrEcE9aCqvzQUNYvfBVMVQeINOYX6rxJtkl7syZfNtalaH23rVju07MpRaPyewJy6rd+YWEBa7UQnGH/m/YddF84X7RmhMnRu6x2Im8Xm0arIMnzXZ1gmOK+aUrUe6nIx8ymcIWLV2529X9+OMZmXEmhCPkQd/pG5yaCd8aXG44pQ81hXp0uLDB8gGqMQ908cvaX/v6MGaVmVZljz6E6g=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68CAB2117800184493BC336790D6679E@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd500dcc-4142-40be-cad3-08d6d78301d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 09:11:38.9331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB3991
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBPbiBNYXkgMTMsIDIwMTksIGF0IDE6MzYgQU0sIFBldGVyIFppamxzdHJhIDxwZXRlcnpAaW5m
cmFkZWFkLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBUaHUsIE1heSAwOSwgMjAxOSBhdCAwOToyMToz
NVBNICswMDAwLCBOYWRhdiBBbWl0IHdyb3RlOg0KPiANCj4+Pj4+IEFuZCB3ZSBjYW4gZml4IHRo
YXQgYnkgaGF2aW5nIHRsYl9maW5pc2hfbW11KCkgc3luYyB1cC4gTmV2ZXIgbGV0IGENCj4+Pj4+
IGNvbmN1cnJlbnQgdGxiX2ZpbmlzaF9tbXUoKSBjb21wbGV0ZSB1bnRpbCBhbGwgY29uY3VycmVu
Y3QgbW11X2dhdGhlcnMNCj4+Pj4+IGhhdmUgY29tcGxldGVkLg0KPj4+Pj4gDQo+Pj4+PiBUaGlz
IHNob3VsZCBub3QgYmUgdG9vIGhhcmQgdG8gbWFrZSBoYXBwZW4uDQo+Pj4+IA0KPj4+PiBUaGlz
IHN5bmNocm9uaXphdGlvbiBzb3VuZHMgbXVjaCBtb3JlIGV4cGVuc2l2ZSB0aGFuIHdoYXQgSSBw
cm9wb3NlZC4gQnV0IEkNCj4+Pj4gYWdyZWUgdGhhdCBjYWNoZS1saW5lcyB0aGF0IG1vdmUgZnJv
bSBvbmUgQ1BVIHRvIGFub3RoZXIgbWlnaHQgYmVjb21lIGFuDQo+Pj4+IGlzc3VlLiBCdXQgSSB0
aGluayB0aGF0IHRoZSBzY2hlbWUgSSBzdWdnZXN0ZWQgd291bGQgbWluaW1pemUgdGhpcyBvdmVy
aGVhZC4NCj4+PiANCj4+PiBXZWxsLCBpdCB3b3VsZCBoYXZlIGEgbG90IG1vcmUgdW5jb25kaXRp
b25hbCBhdG9taWMgb3BzLiBNeSBzY2hlbWUgb25seQ0KPj4+IHdhaXRzIHdoZW4gdGhlcmUgaXMg
YWN0dWFsIGNvbmN1cnJlbmN5Lg0KPj4gDQo+PiBXZWxsLCBzb21ldGhpbmcgaGFzIHRvIGdpdmUu
IEkgZGlkbuKAmXQgdGhpbmsgdGhhdCBpZiB0aGUgc2FtZSBjb3JlIGRvZXMgdGhlDQo+PiBhdG9t
aWMgb3AgaXQgd291bGQgYmUgdG9vIGV4cGVuc2l2ZS4NCj4gDQo+IFRoZXkncmUgc3RpbGwgYXQg
bGVhc3QgMjAgY3ljbGVzIGEgcG9wLCB1bmNvbnRlbmRlZC4NCj4gDQo+Pj4gSSBfdGhpbmtfIHNv
bWV0aGluZyBsaWtlIHRoZSBiZWxvdyBvdWdodCB0byB3b3JrLCBidXQgaXRzIG5vdCBldmVuIGJl
ZW4NCj4+PiBuZWFyIGEgY29tcGlsZXIuIFRoZSBvbmx5IHByb2JsZW0gaXMgdGhlIHVuY29uZGl0
aW9uYWwgd2FrZXVwOyB3ZSBjYW4NCj4+PiBwbGF5IGdhbWVzIHRvIGF2b2lkIHRoYXQgaWYgd2Ug
d2FudCB0byBjb250aW51ZSB3aXRoIHRoaXMuDQo+Pj4gDQo+Pj4gSWRlYWxseSB3ZSdkIG9ubHkg
ZG8gdGhpcyB3aGVuIHRoZXJlJ3MgYmVlbiBhY3R1YWwgb3ZlcmxhcCwgYnV0IEkndmUgbm90DQo+
Pj4gZm91bmQgYSBzZW5zaWJsZSB3YXkgdG8gZGV0ZWN0IHRoYXQuDQo+Pj4gDQo+Pj4gZGlmZiAt
LWdpdCBhL2luY2x1ZGUvbGludXgvbW1fdHlwZXMuaCBiL2luY2x1ZGUvbGludXgvbW1fdHlwZXMu
aA0KPj4+IGluZGV4IDRlZjRiYmU3OGExZC4uYjcwZTM1NzkyZDI5IDEwMDY0NA0KPj4+IC0tLSBh
L2luY2x1ZGUvbGludXgvbW1fdHlwZXMuaA0KPj4+ICsrKyBiL2luY2x1ZGUvbGludXgvbW1fdHlw
ZXMuaA0KPj4+IEBAIC01OTAsNyArNTkwLDEyIEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBkZWNfdGxi
X2ZsdXNoX3BlbmRpbmcoc3RydWN0IG1tX3N0cnVjdCAqbW0pDQo+Pj4gCSAqDQo+Pj4gCSAqIFRo
ZXJlZm9yZSB3ZSBtdXN0IHJlbHkgb24gdGxiX2ZsdXNoXyooKSB0byBndWFyYW50ZWUgb3JkZXIu
DQo+Pj4gCSAqLw0KPj4+IC0JYXRvbWljX2RlYygmbW0tPnRsYl9mbHVzaF9wZW5kaW5nKTsNCj4+
PiArCWlmIChhdG9taWNfZGVjX2FuZF90ZXN0KCZtbS0+dGxiX2ZsdXNoX3BlbmRpbmcpKSB7DQo+
Pj4gKwkJd2FrZV91cF92YXIoJm1tLT50bGJfZmx1c2hfcGVuZGluZyk7DQo+Pj4gKwl9IGVsc2Ug
ew0KPj4+ICsJCXdhaXRfZXZlbnRfdmFyKCZtbS0+dGxiX2ZsdXNoX3BlbmRpbmcsDQo+Pj4gKwkJ
CSAgICAgICAhYXRvbWljX3JlYWRfYWNxdWlyZSgmbW0tPnRsYl9mbHVzaF9wZW5kaW5nKSk7DQo+
Pj4gKwl9DQo+Pj4gfQ0KPj4gDQo+PiBJdCBzdGlsbCBzZWVtcyB2ZXJ5IGV4cGVuc2l2ZSB0byBt
ZSwgYXQgbGVhc3QgZm9yIGNlcnRhaW4gd29ya2xvYWRzIChlLmcuLA0KPj4gQXBhY2hlIHdpdGgg
bXVsdGl0aHJlYWRlZCBNUE0pLg0KPiANCj4gSXMgdGhhdCBBcGFjaGUtTVBNIHdvcmtsb2FkIHRy
aWdnZXJpbmcgdGhpcyBsb3RzPyBIYXZpbmcgYSBrbm93bg0KPiBiZW5jaG1hcmsgZm9yIHRoaXMg
c3R1ZmYgaXMgZ29vZCBmb3Igd2hlbiBzb21lb25lIGhhcyB0aW1lIHRvIHBsYXkgd2l0aA0KPiB0
aGluZ3MuDQoNClNldHRpbmcgQXBhY2hlMiB3aXRoIG1wbV93b3JrZXIgY2F1c2VzIGV2ZXJ5IHJl
cXVlc3QgdG8gZ28gdGhyb3VnaA0KbW1hcC13cml0ZXYtbXVubWFwIGZsb3cgb24gZXZlcnkgdGhy
ZWFkLiBJIGRpZG7igJl0IHJ1biB0aGlzIHdvcmtsb2FkIGFmdGVyDQp0aGUgcGF0Y2hlcyB0aGF0
IGRvd25ncmFkZSB0aGUgbW1hcF9zZW0gdG8gcmVhZCBiZWZvcmUgdGhlIHBhZ2UtdGFibGUNCnph
cHBpbmcgd2VyZSBpbnRyb2R1Y2VkLiBJIHByZXN1bWUgdGhlc2UgcGF0Y2hlcyB3b3VsZCBhbGxv
dyB0aGUgcGFnZS10YWJsZQ0KemFwcGluZyB0byBiZSBkb25lIGNvbmN1cnJlbnRseSwgYW5kIHRo
ZXJlZm9yZSB3b3VsZCBoaXQgdGhpcyBmbG93Lg0KDQo+PiBJdCBtYXkgYmUgcG9zc2libGUgdG8g
YXZvaWQgZmFsc2UtcG9zaXRpdmUgbmVzdGluZyBpbmRpY2F0aW9ucyAod2hlbiB0aGUNCj4+IGZs
dXNoZXMgZG8gbm90IG92ZXJsYXApIGJ5IGNyZWF0aW5nIGEgbmV3IHN0cnVjdCBtbXVfZ2F0aGVy
X3BlbmRpbmcsIHdpdGgNCj4+IHNvbWV0aGluZyBsaWtlOg0KPj4gDQo+PiAgc3RydWN0IG1tdV9n
YXRoZXJfcGVuZGluZyB7DQo+PiAJdTY0IHN0YXJ0Ow0KPj4gCXU2NCBlbmQ7DQo+PiAJc3RydWN0
IG1tdV9nYXRoZXJfcGVuZGluZyAqbmV4dDsNCj4+ICB9DQo+PiANCj4+IHRsYl9maW5pc2hfbW11
KCkgd291bGQgdGhlbiBpdGVyYXRlIG92ZXIgdGhlIG1tLT5tbXVfZ2F0aGVyX3BlbmRpbmcNCj4+
IChwb2ludGluZyB0byB0aGUgbGlua2VkIGxpc3QpIGFuZCBmaW5kIHdoZXRoZXIgdGhlcmUgaXMg
YW55IG92ZXJsYXAuIFRoaXMNCj4+IHdvdWxkIHN0aWxsIHJlcXVpcmUgc3luY2hyb25pemF0aW9u
IChhY3F1aXJpbmcgYSBsb2NrIHdoZW4gYWxsb2NhdGluZyBhbmQNCj4+IGRlYWxsb2NhdGluZyBv
ciBzb21ldGhpbmcgZmFuY2llcikuDQo+IA0KPiBXZSBoYXZlIGFuIGludGVydmFsX3RyZWUgZm9y
IHRoaXMsIGFuZCB5ZXMsIHRoYXQncyBob3cgZmFyIEkgZ290IDovDQo+IA0KPiBUaGUgb3RoZXIg
dGhpbmcgSSB3YXMgdGhpbmtpbmcgb2YgaXMgdHJ5aW5nIHRvIGRldGVjdCBvdmVybGFwIHRocm91
Z2gNCj4gdGhlIHBhZ2UtdGFibGVzIHRoZW1zZWx2ZXMsIGJ1dCB3ZSBoYXZlIGEgZGlzdGluY3Qg
bGFjayBvZiBzdG9yYWdlDQo+IHRoZXJlLg0KDQpJIHRyaWVkIHRvIHRoaW5rIGFib3V0IHNhdmlu
ZyBzb21lIGdlbmVyYXRpb24gaW5mbyBzb21ld2hlcmUgaW4gdGhlDQpwYWdlLXN0cnVjdCwgYnV0
IEkgY291bGQgbm90IGNvbWUgdXAgd2l0aCBhIHJlYXNvbmFibGUgc29sdXRpb24gdGhhdA0Kd291
bGQgbm90IHJlcXVpdGUgdG8gdHJhdmVyc2UgYWxsIHRoZSBwYWdlIHRhYmxlcyBhZ2FpbiBvbmUg
dGhlIFRMQg0KZmx1c2ggaXMgZG9uZS4NCg0KPiBUaGUgdGhpbmdzIGlzLCBpZiB0aGlzIHRocmVh
ZGVkIG1vbnN0ZXIgcnVucyBvbiBhbGwgQ1BVcyAoYnVzeSBmcm9udCBlbmQNCj4gc2VydmVyKSBh
bmQgZG9lcyBhIHRvbiBvZiBpbnZhbGlkYXRpb24gZHVlIHRvIGFsbCB0aGUgc2hvcnQgbGl2ZWQN
Cj4gcmVxdWVzdCBjcnVkLCB0aGVuIGFsbCB0aGUgZXh0cmEgaW52YWxpZGF0aW9ucyB3aWxsIGFk
ZCB1cCB0b28uIEhhdmluZw0KPiB0byBkbyBwcm9jZXNzIChtYWNoaW5lIGluIHRoaXMgY2FzZSkg
d2lkZSBpbnZhbGlkYXRpb25zIGlzIGV4cGVuc2l2ZSwNCj4gaGF2aW5nIHRvIGRvIG1vcmUgb2Yg
dGhlbSBzdXJlbHkgaXNuJ3QgY2hlYXAgZWl0aGVyLg0KPiANCj4gU28gdGhlcmUgbWlnaHQgYmUg
c29tZXRoaW5nIHRvIHdpbiBoZXJlLg0KDQpZZXMuIEkgcmVtZW1iZXIgdGhhdCB0aGVzZSBmdWxs
IFRMQiBmbHVzaGVzIGxlYXZlIHRoZWlyIG1hcmsuDQoNCkJUVzogc29tZXRpbWVzIHlvdSBkb27i
gJl0IHNlZSB0aGUgZWZmZWN0IG9mIHRoZXNlIGZ1bGwgVExCIGZsdXNoZXMgYXMgbXVjaCBpbg0K
Vk1zLiBJIGVuY291bnRlcmVkIGEgc3RyYW5nZSBwaGVub21lbm9uIGF0IHRoZSB0aW1lIC0gSU5W
TFBHIGZvciBhbg0KYXJiaXRyYXJ5IHBhZ2UgY2F1c2UgbXkgSGFzd2VsbCBtYWNoaW5lIGZsdXNo
IHRoZSBlbnRpcmUgVExCLCB3aGVuIHRoZQ0KSU5WTFBHIHdhcyBpc3N1ZWQgaW5zaWRlIGEgVk0u
IEl0IHRvb2sgbWUgcXVpdGUgc29tZSB0aW1lIHRvIGFuYWx5emUgdGhpcw0KcHJvYmxlbS4gRXZl
bnR1YWxseSBJbnRlbCB0b2xkIG1lIHRoYXTigJlzIHBhcnQgb2Ygd2hhdCBpcyBjYWxsZWQg4oCc
cGFnZQ0KZnJhY3R1cmluZ+KAnSAtIGlmIHRoZSBob3N0IHVzZXMgNGsgcGFnZXMgaW4gdGhlIEVQ
VCwgdGhleSAodXN1YWxseSkgbmVlZCB0bw0KZmx1c2ggdGhlIGVudGlyZSBUTEIgZm9yIGFueSBJ
TlZMUEcuIFRoYXTigJlzIGhhcHBlbnMgc2luY2UgdGhleSBkb27igJl0IGtub3cNCnRoZSBzaXpl
IG9mIHRoZSBmbHVzaGVkIHBhZ2UuDQoNCkkgcmVhbGx5IG5lZWQgdG8gZmluaXNoIG15IGJsb2ct
cG9zdCBhYm91dCBpdCBzb21lIGRheS4=

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4581BB87
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 19:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730358AbfEMRGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 13:06:18 -0400
Received: from mail-eopbgr720074.outbound.protection.outlook.com ([40.107.72.74]:64209
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730268AbfEMRGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 13:06:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eHLpfnWoWujPeilq2Vzxl8f6Oekfsot30OspAFhCnvA=;
 b=zIss71+oKy+qkYWnO8iIPsiuerwJqUgQAT2ySU5TZnFJjPDu/z3rLw92rugKfP4UWcIj1sZH5gCZQA4oLBtTu6DLY+9kF9iDVNt6msCq9uLPwySXwaj7bsm8NamJEO+S+j1gr8hdDDJnyHxrL2XE2qT9S7hwNTI7vS0XFsqRxtw=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB5029.namprd05.prod.outlook.com (20.177.230.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.14; Mon, 13 May 2019 17:06:03 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::b057:917a:f098:6098]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::b057:917a:f098:6098%7]) with mapi id 15.20.1900.010; Mon, 13 May 2019
 17:06:03 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        "jstancek@redhat.com" <jstancek@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Nick Piggin <npiggin@gmail.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Thread-Topic: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Thread-Index: AQHVBlNcdgyGQHvMg0ymTH6Y7O8srKZjDs8AgAANcoCAAAcZgIAABfcAgAAkYwCABXN1AIAACeyAgAB8rgCAAAfegA==
Date:   Mon, 13 May 2019 17:06:03 +0000
Message-ID: <43638259-8EDB-4B8D-A93D-A2E86D8B2489@vmware.com>
References: <1557264889-109594-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190509083726.GA2209@brain-police>
 <20190509103813.GP2589@hirez.programming.kicks-ass.net>
 <F22533A7-016F-4506-809A-7E86BAF24D5A@vmware.com>
 <20190509182435.GA2623@hirez.programming.kicks-ass.net>
 <04668E51-FD87-4D53-A066-5A35ABC3A0D6@vmware.com>
 <20190509191120.GD2623@hirez.programming.kicks-ass.net>
 <7DA60772-3EE3-4882-B26F-2A900690DA15@vmware.com>
 <20190513083606.GL2623@hirez.programming.kicks-ass.net>
 <75FD46B2-2E0C-41F2-9308-AB68C8780E33@vmware.com>
 <20190513163752.GA10754@fuggles.cambridge.arm.com>
In-Reply-To: <20190513163752.GA10754@fuggles.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [50.204.119.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47297cbe-ed62-467f-e6aa-08d6d7c547c8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR05MB5029;
x-ms-traffictypediagnostic: BYAPR05MB5029:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR05MB50293E7CEBC629E4E9DC7419D00F0@BYAPR05MB5029.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(346002)(39860400002)(396003)(366004)(51444003)(199004)(189003)(6306002)(66476007)(66556008)(64756008)(66446008)(66946007)(33656002)(54906003)(53546011)(4326008)(229853002)(2906002)(6506007)(14454004)(76116006)(83716004)(53936002)(73956011)(478600001)(486006)(76176011)(99286004)(476003)(966005)(3846002)(6116002)(14444005)(256004)(6512007)(6246003)(6916009)(102836004)(7416002)(36756003)(71190400001)(2616005)(305945005)(68736007)(316002)(66066001)(11346002)(71200400001)(6436002)(25786009)(5660300002)(446003)(86362001)(26005)(81166006)(6486002)(186003)(82746002)(7736002)(8676002)(81156014)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5029;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: M3YMOwND2CWU6vsD5LVIT2NkqoWdZ80ZU1tBtqKXZPzu8maZSifKTkZZjd8cYNNk3+58zbxpU6wvvVxjdBGtSSA5ve9wjXbnQHUxihk0Pmz5qh+6yXgmnz4KeraotmRDkNtc2J411Wv+88sjkMYtpn4oCiul8LBmqQEASl+JUgUl1O3/8urnOisBFN3JGrdsQKPibL9o/xG1Cl122bPDDmGa37B8JkS8bvWJHL6XE5hJhETE/qavChdxvZ7GrQ5bBHHek82u/o3pKnmVnw9L1zbwlNxnoHfQTfzXYYcjrASIOmdsXjeiKxohaCcDY9DB2JQxSInuMGAcRg5Y/v3cRw5g8GYh+YNtGWtz2YWW/pFDNQiF20aRaAAFUWoWfqJIGRbl2+phHDO2wHhe1O2LcApMOjKS3eQjUeWL59zTte8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE53F45D5AB1584CAB1191AD54213E73@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47297cbe-ed62-467f-e6aa-08d6d7c547c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 17:06:03.1242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5029
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBPbiBNYXkgMTMsIDIwMTksIGF0IDk6MzcgQU0sIFdpbGwgRGVhY29uIDx3aWxsLmRlYWNvbkBh
cm0uY29tPiB3cm90ZToNCj4gDQo+IE9uIE1vbiwgTWF5IDEzLCAyMDE5IGF0IDA5OjExOjM4QU0g
KzAwMDAsIE5hZGF2IEFtaXQgd3JvdGU6DQo+Pj4gT24gTWF5IDEzLCAyMDE5LCBhdCAxOjM2IEFN
LCBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+IHdyb3RlOg0KPj4+IA0KPj4+
IE9uIFRodSwgTWF5IDA5LCAyMDE5IGF0IDA5OjIxOjM1UE0gKzAwMDAsIE5hZGF2IEFtaXQgd3Jv
dGU6DQo+Pj4gDQo+Pj4+Pj4+IEFuZCB3ZSBjYW4gZml4IHRoYXQgYnkgaGF2aW5nIHRsYl9maW5p
c2hfbW11KCkgc3luYyB1cC4gTmV2ZXIgbGV0IGENCj4+Pj4+Pj4gY29uY3VycmVudCB0bGJfZmlu
aXNoX21tdSgpIGNvbXBsZXRlIHVudGlsIGFsbCBjb25jdXJyZW5jdCBtbXVfZ2F0aGVycw0KPj4+
Pj4+PiBoYXZlIGNvbXBsZXRlZC4NCj4+Pj4+Pj4gDQo+Pj4+Pj4+IFRoaXMgc2hvdWxkIG5vdCBi
ZSB0b28gaGFyZCB0byBtYWtlIGhhcHBlbi4NCj4+Pj4+PiANCj4+Pj4+PiBUaGlzIHN5bmNocm9u
aXphdGlvbiBzb3VuZHMgbXVjaCBtb3JlIGV4cGVuc2l2ZSB0aGFuIHdoYXQgSSBwcm9wb3NlZC4g
QnV0IEkNCj4+Pj4+PiBhZ3JlZSB0aGF0IGNhY2hlLWxpbmVzIHRoYXQgbW92ZSBmcm9tIG9uZSBD
UFUgdG8gYW5vdGhlciBtaWdodCBiZWNvbWUgYW4NCj4+Pj4+PiBpc3N1ZS4gQnV0IEkgdGhpbmsg
dGhhdCB0aGUgc2NoZW1lIEkgc3VnZ2VzdGVkIHdvdWxkIG1pbmltaXplIHRoaXMgb3ZlcmhlYWQu
DQo+Pj4+PiANCj4+Pj4+IFdlbGwsIGl0IHdvdWxkIGhhdmUgYSBsb3QgbW9yZSB1bmNvbmRpdGlv
bmFsIGF0b21pYyBvcHMuIE15IHNjaGVtZSBvbmx5DQo+Pj4+PiB3YWl0cyB3aGVuIHRoZXJlIGlz
IGFjdHVhbCBjb25jdXJyZW5jeS4NCj4+Pj4gDQo+Pj4+IFdlbGwsIHNvbWV0aGluZyBoYXMgdG8g
Z2l2ZS4gSSBkaWRu4oCZdCB0aGluayB0aGF0IGlmIHRoZSBzYW1lIGNvcmUgZG9lcyB0aGUNCj4+
Pj4gYXRvbWljIG9wIGl0IHdvdWxkIGJlIHRvbyBleHBlbnNpdmUuDQo+Pj4gDQo+Pj4gVGhleSdy
ZSBzdGlsbCBhdCBsZWFzdCAyMCBjeWNsZXMgYSBwb3AsIHVuY29udGVuZGVkLg0KPj4+IA0KPj4+
Pj4gSSBfdGhpbmtfIHNvbWV0aGluZyBsaWtlIHRoZSBiZWxvdyBvdWdodCB0byB3b3JrLCBidXQg
aXRzIG5vdCBldmVuIGJlZW4NCj4+Pj4+IG5lYXIgYSBjb21waWxlci4gVGhlIG9ubHkgcHJvYmxl
bSBpcyB0aGUgdW5jb25kaXRpb25hbCB3YWtldXA7IHdlIGNhbg0KPj4+Pj4gcGxheSBnYW1lcyB0
byBhdm9pZCB0aGF0IGlmIHdlIHdhbnQgdG8gY29udGludWUgd2l0aCB0aGlzLg0KPj4+Pj4gDQo+
Pj4+PiBJZGVhbGx5IHdlJ2Qgb25seSBkbyB0aGlzIHdoZW4gdGhlcmUncyBiZWVuIGFjdHVhbCBv
dmVybGFwLCBidXQgSSd2ZSBub3QNCj4+Pj4+IGZvdW5kIGEgc2Vuc2libGUgd2F5IHRvIGRldGVj
dCB0aGF0Lg0KPj4+Pj4gDQo+Pj4+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbV90eXBl
cy5oIGIvaW5jbHVkZS9saW51eC9tbV90eXBlcy5oDQo+Pj4+PiBpbmRleCA0ZWY0YmJlNzhhMWQu
LmI3MGUzNTc5MmQyOSAxMDA2NDQNCj4+Pj4+IC0tLSBhL2luY2x1ZGUvbGludXgvbW1fdHlwZXMu
aA0KPj4+Pj4gKysrIGIvaW5jbHVkZS9saW51eC9tbV90eXBlcy5oDQo+Pj4+PiBAQCAtNTkwLDcg
KzU5MCwxMiBAQCBzdGF0aWMgaW5saW5lIHZvaWQgZGVjX3RsYl9mbHVzaF9wZW5kaW5nKHN0cnVj
dCBtbV9zdHJ1Y3QgKm1tKQ0KPj4+Pj4gCSAqDQo+Pj4+PiAJICogVGhlcmVmb3JlIHdlIG11c3Qg
cmVseSBvbiB0bGJfZmx1c2hfKigpIHRvIGd1YXJhbnRlZSBvcmRlci4NCj4+Pj4+IAkgKi8NCj4+
Pj4+IC0JYXRvbWljX2RlYygmbW0tPnRsYl9mbHVzaF9wZW5kaW5nKTsNCj4+Pj4+ICsJaWYgKGF0
b21pY19kZWNfYW5kX3Rlc3QoJm1tLT50bGJfZmx1c2hfcGVuZGluZykpIHsNCj4+Pj4+ICsJCXdh
a2VfdXBfdmFyKCZtbS0+dGxiX2ZsdXNoX3BlbmRpbmcpOw0KPj4+Pj4gKwl9IGVsc2Ugew0KPj4+
Pj4gKwkJd2FpdF9ldmVudF92YXIoJm1tLT50bGJfZmx1c2hfcGVuZGluZywNCj4+Pj4+ICsJCQkg
ICAgICAgIWF0b21pY19yZWFkX2FjcXVpcmUoJm1tLT50bGJfZmx1c2hfcGVuZGluZykpOw0KPj4+
Pj4gKwl9DQo+Pj4+PiB9DQo+Pj4+IA0KPj4+PiBJdCBzdGlsbCBzZWVtcyB2ZXJ5IGV4cGVuc2l2
ZSB0byBtZSwgYXQgbGVhc3QgZm9yIGNlcnRhaW4gd29ya2xvYWRzIChlLmcuLA0KPj4+PiBBcGFj
aGUgd2l0aCBtdWx0aXRocmVhZGVkIE1QTSkuDQo+Pj4gDQo+Pj4gSXMgdGhhdCBBcGFjaGUtTVBN
IHdvcmtsb2FkIHRyaWdnZXJpbmcgdGhpcyBsb3RzPyBIYXZpbmcgYSBrbm93bg0KPj4+IGJlbmNo
bWFyayBmb3IgdGhpcyBzdHVmZiBpcyBnb29kIGZvciB3aGVuIHNvbWVvbmUgaGFzIHRpbWUgdG8g
cGxheSB3aXRoDQo+Pj4gdGhpbmdzLg0KPj4gDQo+PiBTZXR0aW5nIEFwYWNoZTIgd2l0aCBtcG1f
d29ya2VyIGNhdXNlcyBldmVyeSByZXF1ZXN0IHRvIGdvIHRocm91Z2gNCj4+IG1tYXAtd3JpdGV2
LW11bm1hcCBmbG93IG9uIGV2ZXJ5IHRocmVhZC4gSSBkaWRu4oCZdCBydW4gdGhpcyB3b3JrbG9h
ZCBhZnRlcg0KPj4gdGhlIHBhdGNoZXMgdGhhdCBkb3duZ3JhZGUgdGhlIG1tYXBfc2VtIHRvIHJl
YWQgYmVmb3JlIHRoZSBwYWdlLXRhYmxlDQo+PiB6YXBwaW5nIHdlcmUgaW50cm9kdWNlZC4gSSBw
cmVzdW1lIHRoZXNlIHBhdGNoZXMgd291bGQgYWxsb3cgdGhlIHBhZ2UtdGFibGUNCj4+IHphcHBp
bmcgdG8gYmUgZG9uZSBjb25jdXJyZW50bHksIGFuZCB0aGVyZWZvcmUgd291bGQgaGl0IHRoaXMg
Zmxvdy4NCj4gDQo+IEhtbSwgSSBkb24ndCB0aGluayBzbzogbXVubWFwKCkgc3RpbGwgaGFzIHRv
IHRha2UgdGhlIHNlbWFwaG9yZSBmb3Igd3JpdGUNCj4gaW5pdGlhbGx5LCBzbyBpdCB3aWxsIGJl
IHNlcmlhbGlzZWQgYWdhaW5zdCBvdGhlciBtdW5tYXAoKSB0aHJlYWRzIGV2ZW4NCj4gYWZ0ZXIg
dGhleSd2ZSBkb3duZ3JhZGVkIGFmYWljdC4NCj4gDQo+IFRoZSBpbml0aWFsIGJ1ZyByZXBvcnQg
d2FzIGFib3V0IGNvbmN1cnJlbnQgbWFkdmlzZSgpIHZzIG11bm1hcCgpLg0KDQpJIGd1ZXNzIHlv
dSBhcmUgcmlnaHQgKGFuZCBJ4oCZbSB3cm9uZykuDQoNClNob3J0IHNlYXJjaCBzdWdnZXN0cyB0
aGF0IGViaXp6eSBtaWdodCBiZSBhZmZlY3RlZCAoYSB0aHJlYWQgYnkgTWVsDQpHb3JtYW4pOiBo
dHRwczovL2xrbWwub3JnL2xrbWwvMjAxNS8yLzIvNDkzDQoNCg==

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8B810FD8C
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 13:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfLCMZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 07:25:28 -0500
Received: from mail-eopbgr750040.outbound.protection.outlook.com ([40.107.75.40]:60767
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725907AbfLCMZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 07:25:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jNET2JPJE+ElNPQHmdqg7o04VaOA8dK8n25Bvg/SRfLTBYL32mSZRC/pFh87XjbHaqAa7DP7oQ9eFEjEXW218X4gs4SNy97/k8rasHc6xaJtLe1NXWGQRpWH6yJLI5bIvgndy9PwfUMXavgsRA3Eot/Z+E2dAuckhgc5P5NT3DE0UW2J1T+P7Y2+ndJ+3Tb+VsZey7V11NJu9xRgvDFYHJkPLxJPF2UBs1uOOcoIoG1p6E+Yc4aXigUOurQOjErMiPCPdaghr9u+/Ht0WU27Vw0OrBgFfvBuh+1+6mqyqf+wKp9WarwAik0PaxFg+GlG7NKu1fF36Ih8TNVLelM0xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5G6uq9FR3hL9EowbOGuWowwymHPS2JeeeuTLE49evw=;
 b=VoRYgKflCeaoo98arXz3MQQIgOoJdNHvlCEOnii+VKbvLNJBHjVtkMeyzGdFk5ENPGWhoFqz74lXVhsb30XRE5EPPlnQLw9TP86BkLv9X+jbJboWxxpmRkZrvpfGGE2glPuu6Hxdr4nhOpRrUoxyUZX2RPLXj93pqSPShV+MZNS8P8RRSlAqeNwU+wnOiIxb8yWZk64ziC2DFqTxvH1lwB71j/S/tMhexTJ5oTZqF1bOVa3S5+MR+qr4l7nakMiR4fg6sYGqTvhESiXM65BQe9lT8XMw/ZqX9j6RLzGExOEoCFOqUdhxcf6wUeLQ09Wprcb0CFqBwVeHpn11KVOyUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5G6uq9FR3hL9EowbOGuWowwymHPS2JeeeuTLE49evw=;
 b=B9xz7EHWwp/YZssIe8CY0F9IYijqBhd+7gLUEvhrVjJ828nzFBSriVV+PAf1h5g6j/EUbmxeCKez1xsTeRwnJ+6edEr+LpgQYQLyeke1Qqxz2mVn1l6B0DRzT/nPTUdkovII417XO6Q2kFXkTsrYykVE+R1cDWDNxTLNxPYI3ws=
Received: from MN2PR05MB6208.namprd05.prod.outlook.com (20.178.241.91) by
 MN2PR05MB6622.namprd05.prod.outlook.com (20.178.246.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.4; Tue, 3 Dec 2019 12:25:24 +0000
Received: from MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::ed0d:9029:720c:1459]) by MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::ed0d:9029:720c:1459%2]) with mapi id 15.20.2516.003; Tue, 3 Dec 2019
 12:25:24 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     Vlastimil Babka <vbabka@suse.cz>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jann Horn <jannh@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        "stable@kernel.org" <stable@kernel.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>
Subject: Re: [PATCH STABLE 4.4 5/8] mm: prevent get_user_pages() from
 overflowing page refcount
Thread-Topic: [PATCH STABLE 4.4 5/8] mm: prevent get_user_pages() from
 overflowing page refcount
Thread-Index: AQHVlhhHx12DFRikrEimDS6JVcInLqeo2SgA
Date:   Tue, 3 Dec 2019 12:25:24 +0000
Message-ID: <519D18AF-DD01-4107-96D2-D8E33058B2CB@vmware.com>
References: <20191108093814.16032-1-vbabka@suse.cz>
 <20191108093814.16032-6-vbabka@suse.cz>
In-Reply-To: <20191108093814.16032-6-vbabka@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [103.19.212.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2599a422-2a1a-4543-fa2e-08d777ebdf85
x-ms-traffictypediagnostic: MN2PR05MB6622:|MN2PR05MB6622:|MN2PR05MB6622:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR05MB6622A2012EF2F94E61683500BB420@MN2PR05MB6622.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 02408926C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(199004)(189003)(6306002)(6512007)(6436002)(229853002)(5660300002)(86362001)(4326008)(107886003)(66446008)(6486002)(8676002)(66946007)(81156014)(81166006)(8936002)(91956017)(2501003)(6246003)(64756008)(66556008)(7736002)(76116006)(66476007)(14444005)(305945005)(478600001)(33656002)(25786009)(966005)(14454004)(71200400001)(3846002)(446003)(6116002)(256004)(2616005)(2906002)(76176011)(71190400001)(11346002)(186003)(110136005)(99286004)(6506007)(54906003)(36756003)(102836004)(26005)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6622;H:MN2PR05MB6208.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zmGr42ycy8IC++Bn+An+bC9fmBhjjm3GKAPJpG7QmCUyTFxLKGf3DfFFxboKzhL4XSmeAFgt17mT+WV0FvdUMQawY6r6W/fEXjukH7g7fOLyq+2jOVn3r8yYnr8fjA8iD0+3Snu03mfjxzfg79YGxnQNm+LrfCEZWx6e/nrdfj2d808V0RCVs4+MVc5kE8jgW9XlURRGKMHZUAnw7eIM/NzfLufx2f93c1Rab5Re7WkzTz/HLmr5DiANLgBaXp3YMBHpfT8RBORz3z3/rBW5zxDmiOJBFew/IWCi9corcFbE4Z40hAKCIjRvak+F7N4OP4fIXy3vA+BoZou8Qs88wXmgBxtq1+UnW9A9OdOBWQLfwss5VtXnO8sZDBsYorIX3onFYu6tfgNqHwe7k7wg9UUqbPTkSo3oHfW9rR3ohNywUMnT2rrSGlr7jMSN3D5YWCHhSrdoEf7ryv2qV5NkrGjoNlouAEGtI4rpbFZ8kGI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B51119AEB61144995DE1FF965BBB888@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2599a422-2a1a-4543-fa2e-08d777ebdf85
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2019 12:25:24.6334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lAK2NHyTChBxgAXksfFdudx1BVYsrJZoSbMcxMx3nqfyFAbF91Bio1HG446fAm3G185Ol+iROwNPXwzKG4sbCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6622
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCu+7v09uIDA4LzExLzE5LCAzOjA4IFBNLCAiVmxhc3RpbWlsIEJhYmthIiA8dmJhYmthQHN1
c2UuY3o+IHdyb3RlOg0KDQo+IEZyb206IExpbnVzIFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1m
b3VuZGF0aW9uLm9yZz4NCj4gDQo+IGNvbW1pdCA4ZmRlMTJjYTc5YWZmOWI1YmE5NTFmY2UxYTI2
NDE5MDFiOGQ4ZTY0IHVwc3RyZWFtLg0KPiAgICANCj4gWyA0LjQgYmFja3BvcnQ6IHRoZXJlJ3Mg
Z2V0X3BhZ2VfZm9sbCgpLCBzbyBhZGQgdHJ5X2dldF9wYWdlKCktbGlrZSBjaGVja3MNCj4gICAg
ICAgICAgICAgICAgIGluIHRoZXJlLCBlbmFibGVkIGJ5IGEgbmV3IHBhcmFtZXRlciwgd2hpY2gg
aXMgZmFsc2Ugd2hlcmUNCj4gICAgICAgICAgICAgICAgIHVwc3RyZWFtIHBhdGNoIGRvZXNuJ3Qg
cmVwbGFjZSBnZXRfcGFnZSgpIHdpdGggdHJ5X2dldF9wYWdlKCkNCj4gICAgICAgICAgICAgICAg
ICh0aGUgVEhQIGFuZCBodWdldGxiIGNhbGxlcnMpLg0KDQpDb3VsZCB3ZSBoYXZlIHRyeV9nZXRf
cGFnZV9mb2xsKCksIGFzIGluOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvc3RhYmxlLzE1NzA1
ODE4NjMtMTIwOTAtMy1naXQtc2VuZC1lbWFpbC1ha2FoZXJAdm13YXJlLmNvbS8NCg0KKyBDb2Rl
IHdpbGwgYmUgaW4gc3luYyBhcyB3ZSBoYXZlIHRyeV9nZXRfcGFnZSgpDQorIE5vIG5lZWQgdG8g
YWRkIGV4dHJhIGFyZ3VtZW50IHRvIHRyeV9nZXRfcGFnZSgpDQorIE5vIG5lZWQgdG8gbW9kaWZ5
IHRoZSBjYWxsZXJzIG9mIHRyeV9nZXRfcGFnZSgpDQoNCj4JCUluIGd1cF9wdGVfcmFuZ2UoKSwg
d2UgZG9uJ3QgZXhwZWN0IHRhaWwgcGFnZXMsIHNvIGp1c3QgY2hlY2sNCj4gICAgICAgICAgICAg
ICAgIHBhZ2UgcmVmIGNvdW50IGluc3RlYWQgb2YgdHJ5X2dldF9jb21wb3VuZF9oZWFkKCkNCg0K
VGVjaG5pY2FsbHkgaXQncyBmaW5lLiBJZiB5b3Ugd2FudCB0byBrZWVwIHRoZSBjb2RlIG9mIHN0
YWJsZSB2ZXJzaW9ucyBpbiBzeW5jDQp3aXRoIGxhdGVzdCB2ZXJzaW9ucyB0aGVuIHRoaXMgY291
bGQgYmUgZG9uZSBpbiBmb2xsb3dpbmcgd2F5cyAod2l0aG91dCBhbnkNCm1vZGlmaWNhdGlvbiBp
biB1cHN0cmVhbSBwYXRjaCBmb3IgZ3VwX3B0ZV9yYW5nZSgpKToNCg0KQXBwbHkgN2FlZjQxNzJj
Nzk1N2Q3ZTY1ZmMxNzJiZTRjOTliZWNhZWY4NTVkNCBiZWZvcmUgYXBwbHlpbmcNCjhmZGUxMmNh
NzlhZmY5YjViYTk1MWZjZTFhMjY0MTkwMWI4ZDhlNjQsIGFzIGRvbmUgaGVyZToNCmh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL3N0YWJsZS8xNTcwNTgxODYzLTEyMDkwLTQtZ2l0LXNlbmQtZW1haWwt
YWthaGVyQHZtd2FyZS5jb20vDQoNCj4gCQlBbHNvIHBhdGNoIGFyY2gtc3BlY2lmaWMgdmFyaWFu
dHMgb2YgZ3VwLmMgZm9yIHg4NiBhbmQgczM5MCwNCj4gCQlsZWF2aW5nIG1pcHMsIHNoLCBzcGFy
YyBhbG9uZQkJCQkgICAgICBdDQo+IA0KICAgIA0KPiAtLS0NCj4gIGFyY2gvczM5MC9tbS9ndXAu
YyB8ICA2ICsrKystLQ0KPiAgYXJjaC94ODYvbW0vZ3VwLmMgIHwgIDkgKysrKysrKystDQo+ICBt
bS9ndXAuYyAgICAgICAgICAgfCAzOSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0t
LS0tLS0NCj4gIG1tL2h1Z2VfbWVtb3J5LmMgICB8ICAyICstDQo+ICBtbS9odWdldGxiLmMgICAg
ICAgfCAxOCArKysrKysrKysrKysrKysrLS0NCj4gIG1tL2ludGVybmFsLmggICAgICB8IDEyICsr
KysrKysrKy0tLQ0KPiAgNiBmaWxlcyBjaGFuZ2VkLCA2OSBpbnNlcnRpb25zKCspLCAxNyBkZWxl
dGlvbnMoLSkNCj4gICAgDQo+ICNpZmRlZiBfX0hBVkVfQVJDSF9QVEVfU1BFQ0lBTA0KPiAgc3Rh
dGljIGludCBndXBfcHRlX3JhbmdlKHBtZF90IHBtZCwgdW5zaWduZWQgbG9uZyBhZGRyLCB1bnNp
Z25lZCBsb25nIGVuZCwNCj4gIAkJCSBpbnQgd3JpdGUsIHN0cnVjdCBwYWdlICoqcGFnZXMsIGlu
dCAqbnIpDQo+IEBAIC0xMDgzLDYgKzExMDMsOSBAQCBzdGF0aWMgaW50IGd1cF9wdGVfcmFuZ2Uo
cG1kX3QgcG1kLCB1bnNpZ25lZCBsb25nIGFkZHIsIHVuc2lnbmVkIGxvbmcgZW5kLA0KPiAgCQlW
TV9CVUdfT04oIXBmbl92YWxpZChwdGVfcGZuKHB0ZSkpKTsNCj4gCQlwYWdlID0gcHRlX3BhZ2Uo
cHRlKTsNCj4gIA0KPiArCQlpZiAoV0FSTl9PTl9PTkNFKHBhZ2VfcmVmX2NvdW50KHBhZ2UpIDwg
MCkpDQo+ICsJCQlnb3RvIHB0ZV91bm1hcDsNCj4gKw0KPiAgCQlpZiAoIXBhZ2VfY2FjaGVfZ2V0
X3NwZWN1bGF0aXZlKHBhZ2UpKQ0KPiAgCQkJZ290byBwdGVfdW5tYXA7DQoNCg0KIA0KPiBkaWZm
IC0tZ2l0IGEvbW0vaW50ZXJuYWwuaCBiL21tL2ludGVybmFsLmgNCj4gaW5kZXggYTY2MzljNzI3
ODBhLi5iNTIwNDE5NjlkMDYgMTAwNjQ0DQo+IC0tLSBhL21tL2ludGVybmFsLmgNCj4gKysrIGIv
bW0vaW50ZXJuYWwuaA0KPiBAQCAtOTMsMjMgKzkzLDI5IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBf
X2dldF9wYWdlX3RhaWxfZm9sbChzdHJ1Y3QgcGFnZSAqcGFnZSwNCj4gICAqIGZvbGxvd19wYWdl
KCkgYW5kIGl0IG11c3QgYmUgY2FsbGVkIHdoaWxlIGhvbGRpbmcgdGhlIHByb3BlciBQVA0KPiAg
ICogbG9jayB3aGlsZSB0aGUgcHRlIChvciBwbWRfdHJhbnNfaHVnZSkgaXMgc3RpbGwgbWFwcGlu
ZyB0aGUgcGFnZS4NCj4gICAqLw0KPiAtc3RhdGljIGlubGluZSB2b2lkIGdldF9wYWdlX2ZvbGwo
c3RydWN0IHBhZ2UgKnBhZ2UpDQo+ICtzdGF0aWMgaW5saW5lIGJvb2wgZ2V0X3BhZ2VfZm9sbChz
dHJ1Y3QgcGFnZSAqcGFnZSwgYm9vbCBjaGVjaykNCj4gIHsNCj4gLQlpZiAodW5saWtlbHkoUGFn
ZVRhaWwocGFnZSkpKQ0KPiArCWlmICh1bmxpa2VseShQYWdlVGFpbChwYWdlKSkpIHsNCj4gIAkJ
LyoNCj4gIAkJICogVGhpcyBpcyBzYWZlIG9ubHkgYmVjYXVzZQ0KPiAgCQkgKiBfX3NwbGl0X2h1
Z2VfcGFnZV9yZWZjb3VudCgpIGNhbid0IHJ1biB1bmRlcg0KPiAgCQkgKiBnZXRfcGFnZV9mb2xs
KCkgYmVjYXVzZSB3ZSBob2xkIHRoZSBwcm9wZXIgUFQgbG9jay4NCj4gIAkJICovDQo+ICsJCWlm
IChjaGVjayAmJiBXQVJOX09OX09OQ0UoDQo+ICsJCQkJcGFnZV9yZWZfY291bnQoY29tcG91bmRf
aGVhZChwYWdlKSkgPD0gMCkpDQo+ICsJCQlyZXR1cm4gZmFsc2U7DQo+ICAJCV9fZ2V0X3BhZ2Vf
dGFpbF9mb2xsKHBhZ2UsIHRydWUpOw0KPiAtCWVsc2Ugew0KPiArCX0gZWxzZSB7DQo+ICAJCS8q
DQo+ICAJCSAqIEdldHRpbmcgYSBub3JtYWwgcGFnZSBvciB0aGUgaGVhZCBvZiBhIGNvbXBvdW5k
IHBhZ2UNCj4gIAkJICogcmVxdWlyZXMgdG8gYWxyZWFkeSBoYXZlIGFuIGVsZXZhdGVkIHBhZ2Ut
Pl9jb3VudC4NCj4gIAkJICovDQo+ICAJCVZNX0JVR19PTl9QQUdFKHBhZ2VfcmVmX3plcm9fb3Jf
Y2xvc2VfdG9fb3ZlcmZsb3cocGFnZSksIHBhZ2UpOw0KPiArCQlpZiAoY2hlY2sgJiYgV0FSTl9P
Tl9PTkNFKHBhZ2VfcmVmX2NvdW50KHBhZ2UpIDw9IDApKQ0KPiArCQkJcmV0dXJuIGZhbHNlOw0K
PiAgCQlhdG9taWNfaW5jKCZwYWdlLT5fY291bnQpOw0KPiAgCX0NCj4gKwlyZXR1cm4gdHJ1ZTsN
Cj4gIH0NCiAgICANCiAgICANCg0K

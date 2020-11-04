Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496362A60F2
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 10:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgKDJyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 04:54:02 -0500
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:40737
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727110AbgKDJyC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 04:54:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGNk4M6us8tqGJfRKLmGLG0kWtMD0mVg4aGngVYeEDFBw3AIngleYfKT9CrZr+IYx3oE1fLdPZmNwPHWLBP0Rfnjm9YyQnjV4O+MRyIYfUWoYx5d6jGAi3apvJEVo43E6f2WbSyeR1POrxC2QUS0PG1X5ChkDZDEWDaxbGW05Eok5fuTGNdhwU7oyAzGaJEQ5PsmaTmeBw39Mc8ciEdb10yFpgsHyQSCx5mYXDo0cODNwk9rHPKbx//JBFUx8BgDg6Zpr8uQeL0httSvGQAyGwFiD+L4IB7qNyHVz+SPcjrOKjdLOMpKRPL4fxEpGJdECNQ3yZrP3pNl0IVrL70mMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ab8Q3oxc2kkLHHkFLXIod109QzFKMWuMdyhrPzlK7bA=;
 b=bA10N5moFXKCkbLlbtP3Rgkr+v1aVMyqc9SI7h1OF6t4CXoHKV2moujrzzZNiE4CgGBuFNAikEjwBy51r+CCODk/dN2kcOOgHvfBSMzEHZAetGkb1H7vgQDROeXAhz4TJTSkHhdGsXyDhYyrQk6OYLasbRtnbzcwTo2EMqRDI9o2TguD2c4smvnQyWs+kjQY5hnCNNskK7ue7pXkBeLTu1kVUP43oIw56fxaHGvHgqomY0B6kG1N8MLOZcUvWoKzVDKYTpRGGtbV8zfmVFyI90wXach0QlXB5CRd+x7mIIe1lMSNgN4rljGNvfIUqeJ7trMTlsHk9ho9vzlygMRKMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ab8Q3oxc2kkLHHkFLXIod109QzFKMWuMdyhrPzlK7bA=;
 b=NHNryZEDfn3Fi2FDfYGkrt7KdLCGBDogVRCXu90TKgckfwKZfpXOOfE16uKM3ZQqO241a+UfG0QJugULVrKtVj7ntzSN1f8UWzh4/y+jDclXHchxZqpxrBmmldyw+bFrKhO11iVyziGrQtmYk1EG/3+KvK1seqIK6Rqs8FwtQfs=
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 (2603:10b6:910:45::21) by CY4PR10MB1558.namprd10.prod.outlook.com
 (2603:10b6:903:26::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Wed, 4 Nov
 2020 09:53:59 +0000
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::a4b0:cd03:3459:6853]) by CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::a4b0:cd03:3459:6853%2]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 09:53:58 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "vigneshr@ti.com" <vigneshr@ti.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] mtd: cfi_cmdset_0002: Use status register where possible
Thread-Topic: [PATCH] mtd: cfi_cmdset_0002: Use status register where possible
Thread-Index: AQHWqIpTWSfEXw2OaEiocc+ivq8o4KmweGwAgAAOhQCAAAO2gIABFY8AgAXpLoCAAEZbAA==
Date:   Wed, 4 Nov 2020 09:53:58 +0000
Message-ID: <2198bd20e69be374f7533f45118c98750eb5362a.camel@infinera.com>
References: <20201022154506.17639-1-joakim.tjernlund@infinera.com>
         <20201030184736.4ec434f5@xps13>
         <aefef0187e5ebbe315e57e834ff1ba756ba88817.camel@infinera.com>
         <20201030195251.687809f7@xps13>
         <931f422255204f0420e6f1b79657f9770ce0cf6e.camel@infinera.com>
         <31ce9a84-d949-c1d1-a8c6-44ead119ca1b@ti.com>
In-Reply-To: <31ce9a84-d949-c1d1-a8c6-44ead119ca1b@ti.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.1 
authentication-results: ti.com; dkim=none (message not signed)
 header.d=none;ti.com; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ed3ab02-2b50-4543-0f2c-08d880a78d2b
x-ms-traffictypediagnostic: CY4PR10MB1558:
x-microsoft-antispam-prvs: <CY4PR10MB1558A3D6CA7198096E53A4DEF4EF0@CY4PR10MB1558.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TI++/7YAgM5gxCPR9e4engJwyQqnSb5VKhcySJOdg9WRVlzj3XMlI95aLmc5hAtQ1CXTNG+8uhTGsMpAw4fc9hfZB9i9Xod3aYEhulVvem8GHa8cl2Xp0KbyI3i2MUZ+leG6LS+H/jTSo/mX9z4yBR0XMXgNsz5SN83TcdIJR6z39BZYJHS3iz5KggmE8ujoF+4fGgp0Px3Dyf63AG4CaXTei0caJvyAy2i2hTh/mQAsSt1irCaA/p0H14+lisswc/mCqU/dCgP9j43trIZZye0khHbobi5r87+J92abjkNIdI50tTWA30cfoun+Ajs31xUV5CIYrzOCm8EZMRBzlA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2389.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39850400004)(366004)(136003)(66556008)(66476007)(66446008)(2616005)(64756008)(66946007)(5660300002)(76116006)(86362001)(6512007)(91956017)(36756003)(4326008)(71200400001)(186003)(110136005)(26005)(2906002)(316002)(4001150100001)(6486002)(8936002)(83380400001)(6506007)(53546011)(8676002)(478600001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Eq5MJcBUZinOr+n9/8aat2PhI5GtelY7Zb86lPnjXFq0p25ZQIRRvysJFqPPeifd8bey6z4DBYaspAO+c9Q/0LYSJbg5TrRziiOvpypl9BC97bfLyjzs9MRx+1gBqmbjiocCIYNGu9SPc2bSZMb3oFO/GeWFxkr00JwaoIZIxEl25ycXeRkwG/gqpPNs79Hui2tRZF0/RKbRvN1akItldU3mxVphcfVJ2yT7NSXH9jzBpEKAUwA1e1uC6IVbgWBDNnDUlbo+CyTgT8Hk1+KJ6KuMfkiedEMMfofYh4U9y0nFKAQu3b3CZhRp/XoLKMBgUcRgBCcZ6rcq6tBp3njon4KeNu8aYk7SVRGA5RDKXQWhQiHqBJ79JBYjQBTPsUN8creK9VsVV67DPr9C+UbXPlzPW3L+mznxh+vPv/41iWmTwlw9ug32jk34WQG9H9QcXpoFz1bKWxZYQAzIuy96cjkmTwnRCbm34RaMSH+hIBFvo71ZTxvJ7ZE1LJRBgzs0dfrTfP+1oH3ceFD0OEHHX8tk9hVVMfu72TqC9a9/BQdwX7M2RJrDscgSKNLoUG6lI9scwtK11WyIcNCMs5n1WQBPogJ7/JuHOm7ntyqrzM7qeWsHOFykSleBG1+PWs6fb1eNgL01848RPKJaRt2g6w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC72FD33911D53438B493F0DB2B6E7AC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2389.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ed3ab02-2b50-4543-0f2c-08d880a78d2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 09:53:58.8408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zTVtN+I4BuG2g8mjW8pAVDTCfX/mfUm/OM2ztIBc8dRZENiM/G2PNEZDvaTAKdIl/uAjhjiX6fMrNiM2EjgmnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1558
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIwLTExLTA0IGF0IDExOjEyICswNTMwLCBWaWduZXNoIFJhZ2hhdmVuZHJhIHdy
b3RlOg0KPiBIaSBKb2FraW0NCj4gDQo+IE9uIDEwLzMxLzIwIDQ6NTYgUE0sIEpvYWtpbSBUamVy
bmx1bmQgd3JvdGU6DQo+ID4gT24gRnJpLCAyMDIwLTEwLTMwIGF0IDE5OjUyICswMTAwLCBNaXF1
ZWwgUmF5bmFsIHdyb3RlOg0KPiA+ID4gQ0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZy
b20gb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bmxlc3MgeW91IHJlY29nbml6ZSB0aGUgc2VuZGVyIGFuZCBrbm93IHRo
ZSBjb250ZW50IGlzIHNhZmUuDQo+ID4gPiANCj4gPiA+IA0KPiA+ID4gSGkgSm9ha2ltLA0KPiA+
ID4gDQo+ID4gPiBKb2FraW0gVGplcm5sdW5kIDxKb2FraW0uVGplcm5sdW5kQGluZmluZXJhLmNv
bT4gd3JvdGUgb24gRnJpLCAzMCBPY3QNCj4gPiA+IDIwMjAgMTg6Mzk6MzUgKzAwMDA6DQo+ID4g
PiANCj4gPiA+ID4gT24gRnJpLCAyMDIwLTEwLTMwIGF0IDE4OjQ3ICswMTAwLCBNaXF1ZWwgUmF5
bmFsIHdyb3RlOg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEhpIEpvYWtpbSwNCj4gPiA+ID4gDQo+
ID4gPiA+IEhpIE1pcXVlbA0KPiA+ID4gPiANCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBQbGVhc2Ug
Q2MgdGhlIE1URCBtYWludGFpbmVycywgbm90IG9ubHkgdGhlIGxpc3QgKGdldF9tYWludGFpbmVy
cy5wbCkuDQo+ID4gPiA+IA0KPiA+ID4gPiBJIGZpZ3VyZSBhbGwgbWFpbnRhaW5lcnMgYXJlIG9u
IHRoZSBsaXN0ID8NCj4gPiA+IA0KPiA+ID4gSSBwZXJzb25hbGx5IGRvbid0IGxvb2sgYXQgdGhl
IGxpc3QgdmVyeSBvZnRlbi4gSSBleHBlY3QgcGF0Y2hlcyB0byBiZQ0KPiA+ID4gZGlyZWN0ZWQg
dG8gbWUgKGluIHRoZSBjdXJyZW50IGNhc2UsIFZpZ25lc2gpIHdoZW4gSSBhbSBjb25jZXJuZWQu
DQo+ID4gDQo+ID4gQWRkZWQgVmlnbmVzaA0KPiA+IA0KPiANCj4gQXMgTWlxdWVsIHN1Z2dlc3Rl
ZCwgSSBsb29rIGF0IHBhdGNoZXMgb24gbWFpbGluZyBsaXN0IGF0IGEgbG93ZXINCj4gcHJpb3Jp
dHkgdGhhbiBwYXRjaGVzIHRoYXQgYXJlIENDJ2QgdG8gbWUuDQo+IA0KPiANCj4gPiA+IA0KPiA+
ID4gPiANCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBKb2FraW0gVGplcm5sdW5kIDxqb2FraW0udGpl
cm5sdW5kQGluZmluZXJhLmNvbT4gd3JvdGUgb24gVGh1LCAyMiBPY3QNCj4gPiA+ID4gPiAyMDIw
IDE3OjQ1OjA2ICswMjAwOg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gQ29tbWl0ICJtdGQ6IGNm
aV9jbWRzZXRfMDAwMjogQWRkIHN1cHBvcnQgZm9yIHBvbGxpbmcgc3RhdHVzIHJlZ2lzdGVyIg0K
PiA+ID4gPiA+ID4gYWRkZWQgc3VwcG9ydCBmb3IgcG9sbGluZyB0aGUgc3RhdHVzIHJhdGhlciB0
aGFuIHVzaW5nIERRIHBvbGxpbmcuDQo+ID4gPiA+ID4gPiBIb3dldmVyLCBzdGF0dXMgcmVnaXN0
ZXIgaXMgdXNlZCBvbmx5IHdoZW4gRFEgcG9sbGluZyBpcyBtaXNzaW5nLg0KPiA+ID4gPiA+ID4g
TGV0cyB1c2Ugc3RhdHVzIHJlZ2lzdGVyIHdoZW4gYXZhaWxhYmxlIGFzIGl0IGlzIHN1cGVyaW9y
IHRvIERRIHBvbGxpbmcuDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBJIHdp
bGwgbGV0IHZpZ25lc2ggY29tbWVudCBhYm91dCB0aGUgY29udGVudCAobG9va3MgZmluZSBieSBt
ZSkgYnV0IHlvdSB3aWxsDQo+ID4gPiA+ID4gbmVlZCBhIEZpeGVzIHRhZyBoZXJlLg0KPiA+ID4g
PiANCj4gPiA+ID4gVGhpcyBpcyBub3QgYSBGaXhlcyBzaXR1YXRpb24sIG5vIGJ1ZyBqdXN0IGEg
aHcgZW5hYmxpbmcgdGhpbmcuDQo+ID4gPiA+IEFsc28sIEkgd291bGQgbGlrZSB0byBzZWUgdGhl
IFN0YXR1cyBwYXRjaGVzIGJlIGJhY2twb3J0ZWQgdG8gNC4xOSBhcyB3ZWxsLg0KPiA+ID4gDQo+
ID4gPiBCYWNrcG9ydGluZyBmZWF0dXJlcyBpcyBJTUhPIG5vdCByZWxldmFudC4gSSBndWVzcyBz
dGFibGUga2VybmVsIG9ubHkNCj4gPiA+IHRha2UgZml4ZXMuLi4NCj4gPiANCj4gPiBUaGlzIGlz
IG5vdCBhIGZlYXR1cmUgcmVhbGx5IGFuZCB0aGUgNS40IHN0YWJsZSBkaWQgZ2V0IHRoZW0sIEkg
YXNrIDQuMTkgZ2V0IHRoZW0gdG9vLg0KPiA+IA0KPiANCj4gY29tbWl0IDQ4NDRlZjgwMzA1ZCAo
Im10ZDogY2ZpX2NtZHNldF8wMDAyOiBBZGQgc3VwcG9ydCBmb3IgcG9sbGluZw0KPiBzdGF0dXMg
cmVnaXN0ZXIiKSB3YXMgYWRkZWQgaW4gNS4zIGFuZCB0aGVyZWZvcmUgaXMgcGFydCBvZiA1LjQu
IEJ1dA0KPiBub3RlIHRoYXQgdGhpcyBpcyBhICJuZXcgZmVhdHVyZSIgYW5kIHRoZXJlZm9yZSB3
b24ndCBiZSBiYWNrcG9ydGVkIHRvDQo+IGtlcm5lbHMgb2xkZXIgdGhhbiA1LjMuDQoNCk9oLCBt
eSBtZW1vcnkgaXMgb2ZmIHRoZW4sIHNvcnJ5Lg0KDQo+IFNpbWlsYXJseSwgdGhpcyBwYXRjaCAo
d2hlbiBhY2NlcHRlZCkgaXMgbm90IGEgY2FuZGlkYXRlIGZvciBzdGFibGUNCj4ga2VybmVsIGJh
Y2twb3J0cyBiZWNhdXNlIHRoZSBpbnRlbnRpb24gb2YgZW5hYmxpbmcgcG9sbGluZyBzdGF0dXMN
Cj4gcmVnaXN0ZXIgZm9yIFdyaXRlIENvbXBsZXRpb24gaXMgdG8gZW5hYmxlIGZsYXNoZXMgdGhh
dCAiZG9uJ3QiIHN1cHBvcnQNCj4gRFEgcG9sbGluZyBhdCBhbGwgKG1haW5seSBIeXBlckZsYXNo
KS4NCj4gRW5hYmxpbmcgdGhpcyBmb3IgYWxsIGZsYXNoZXMgdGhhdCBzdXBwb3J0IHRoZSBmZWF0
dXJlIGlzIG5vdCBhIGJ1ZyBmaXgNCj4gSU1PLiBBbHNvLCB0aGVyZSBpc24ndCBlbm91Z2ggdGVz
dGluZyB0byBwcm92ZSB0aGF0IGZlYXR1cmUgd29ya3MgZm9yDQo+IGFsbCBDRkkgTk9SIGZsYXNo
ZXMgb24gYWxsIHBsYXRmb3JtcyBhbmQgdGhlcmVmb3JlIHdvdWxkIGJlIHJpc2t5IHRvIGJlDQo+
IGJhY2twb3J0ZWQgdG8gc3RhYmxlIGtlcm5lbHMuDQoNClRoaXMgaXMgMiB0aGluZ3MsDQogMS4g
bWFraW5nIGl0IHBvc3NpYmxlIHRvIHVzZSBIeXBlciBmbGFzaCAoSFcgZW5hYmxlbWVudCkNCiAy
LiBpbXByb3ZpbmcgdGhlIGZsYXNoIGRyaXZlciB0byBmdW5jdGlvbiBtb3JlIHByZWNpc2UoZ2V0
dGluZyBhbiBhY2N1cmF0ZSBlcnJvciByYXRoZXIgdGhhbiBhIFRNTykgZm9yIG1vc3QgQU1EIGZs
YXNoZXMuDQoNCjEuIGhhcHBlbnMgb24gYSByZWd1bGFyIGJhc2lzIGluIHN0YWJsZS4NCjIuIGNh
biBiZSBkaXNjdXNzZWQgZm9yIHN0YWJsZSBidXQgc2hvdWxkIGF0IGxlYXN0IGdvIGludG8gbWFz
dGVyIG5vdyB0aGF0IHN0YXR1cyBoYXMgYmVlbiBpbiB0aGVyZSBmb3IgYSB3aGlsZQ0KDQoNCg0K
IEpvY2tlDQo=

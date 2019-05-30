Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86662F8B8
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 10:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfE3Isc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 04:48:32 -0400
Received: from mail-eopbgr60078.outbound.protection.outlook.com ([40.107.6.78]:50149
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726439AbfE3Isc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 04:48:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3icaLPgM7LUrmaELHESHqn+6SRwgKn2nQc49y6Tzkg=;
 b=DyVD4lQa7rhMsAZbcfFdlU5myFzw1WeltQBCpbX5XfDB2rLMNM1fFZXZ16cFYmqhpoM8ITRHF2F+lqwSaMSy+mgpw0HEmnCdzbQeynDWBAiBhhmTdyO5bamYYkdHUQXqfoAja5hLsEP4tmCnnsBqYYZN20y32/JAZ/M1e6iuoGQ=
Received: from VI1PR04MB5327.eurprd04.prod.outlook.com (20.177.52.16) by
 VI1PR04MB4830.eurprd04.prod.outlook.com (20.177.49.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 30 May 2019 08:48:26 +0000
Received: from VI1PR04MB5327.eurprd04.prod.outlook.com
 ([fe80::9891:c973:a697:3c7b]) by VI1PR04MB5327.eurprd04.prod.outlook.com
 ([fe80::9891:c973:a697:3c7b%3]) with mapi id 15.20.1943.016; Thu, 30 May 2019
 08:48:26 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jun Li <jun.li@nxp.com>
Subject: RE: [PATCH 1/1] usb: chipidea: udc: workaround for endpoint conflict
 issue
Thread-Topic: [PATCH 1/1] usb: chipidea: udc: workaround for endpoint conflict
 issue
Thread-Index: AQHVFrL3D6ynn0YQykmGysSqurgIPaaDVF+AgAAG1aA=
Date:   Thu, 30 May 2019 08:48:26 +0000
Message-ID: <VI1PR04MB53274A6AA3D9F1DD613102858B180@VI1PR04MB5327.eurprd04.prod.outlook.com>
References: <20190530064505.6292-1-peter.chen@nxp.com>
 <2036f4d4-1d5d-f0b3-f0cb-5df59cc91be9@cogentembedded.com>
In-Reply-To: <2036f4d4-1d5d-f0b3-f0cb-5df59cc91be9@cogentembedded.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.chen@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7c5b5e6-c9fd-42ca-032d-08d6e4db94b0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB4830;
x-ms-traffictypediagnostic: VI1PR04MB4830:
x-microsoft-antispam-prvs: <VI1PR04MB483012C6ECABEF0C4C2BFE958B180@VI1PR04MB4830.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(366004)(136003)(376002)(189003)(199004)(486006)(7696005)(76176011)(4326008)(5660300002)(11346002)(44832011)(53546011)(2906002)(316002)(446003)(110136005)(54906003)(86362001)(26005)(476003)(186003)(102836004)(74316002)(7736002)(305945005)(6506007)(8936002)(81166006)(81156014)(8676002)(99286004)(52536014)(9686003)(2501003)(76116006)(66446008)(64756008)(66556008)(66476007)(55016002)(6436002)(68736007)(14454004)(478600001)(6116002)(25786009)(71200400001)(229853002)(3846002)(6246003)(66946007)(71190400001)(66066001)(256004)(33656002)(53936002)(73956011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4830;H:VI1PR04MB5327.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IV/q+JfzZBDLtX3ypUyeXNi94QKw3AUL6YXQXsr6fQ4RFugvMx4jrATJC/EaeGkrbHtS+JU6rTyEvTcYBt0pQjG17QxbNp2Kq5azr7f4dh5M/fn9sTzWCaYaysTrHr0gSLUqpE3tJfXSeeAg7sNkZ10IY2R0Pz+Qyet2MuxJYz3CtHwBs9VGcqjaSPkIm5Ud2J3M6nfrCsRvFcn5a7SB/Hxm3Hdo4vhyyKeSr97NUN5pA+6484yzc4di6RvGrFZQRoBxuh0c8H2CThOUZPL6E5SdnMP04vPnHl0bEUg1qMI/aIgER+WdUpC+isdX5m9imXziK8j98DXYtXiAYakztI1I7cZqLYidDOH7yBCqak9Cd+yXEB4K+QgDVJ1khDwqmc26KqZgi4Ek4NNwsb67V4yOnv/9azEB1ZkNqodP/5k=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7c5b5e6-c9fd-42ca-032d-08d6e4db94b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 08:48:26.1828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: peter.chen@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4830
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

IA0KPiBPbiAzMC4wNS4yMDE5IDk6NDUsIFBldGVyIENoZW4gd3JvdGU6DQo+IA0KPiA+IEFuIGVu
ZHBvaW50IGNvbmZsaWN0IG9jY3VycyB3aGVuIHRoZSBVU0IgaXMgd29ya2luZyBpbiBkZXZpY2Ug
bW9kZQ0KPiA+IGR1cmluZyBhbiBpc29jaHJvbm91cyBjb21tdW5pY2F0aW9uLiBXaGVuIHRoZSBl
bmRwb2ludEEgSU4gZGlyZWN0aW9uDQo+ID4gaXMgYW4gaXNvY2hyb25vdXMgSU4gZW5kcG9pbnQs
IGFuZCB0aGUgaG9zdCBzZW5kcyBhbiBJTiB0b2tlbiB0bw0KPiA+IGVuZHBvaW50QSBvbiBhbm90
aGVyIGRldmljZSwgdGhlbiB0aGUgT1VUIHRyYW5zYWN0aW9uIG1heSBiZSBtaXNzZWQNCj4gPiBy
ZWdhcmRsZXNzIHRoZSBPVVQgZW5kcG9pbnQgbnVtYmVyLiBHZW5lcmFsbHksIHRoaXMgb2NjdXJz
IHdoZW4gdGhlDQo+ID4gZGV2aWNlIGlzIGNvbm5lY3RlZCB0byB0aGUgaG9zdCB0aHJvdWdoIGEg
aHViIGFuZCBvdGhlciBkZXZpY2VzIGFyZQ0KPiA+IGNvbm5lY3RlZCB0byB0aGUgc2FtZSBodWIu
DQo+ID4NCj4gPiBUaGUgYWZmZWN0ZWQgT1VUIGVuZHBvaW50IGNhbiBiZSBlaXRoZXIgY29udHJv
bCwgYnVsaywgaXNvY2hyb25vdXMsIG9yDQo+ID4gYW4gaW50ZXJydXB0IGVuZHBvaW50LiBBZnRl
ciB0aGUgT1VUIGVuZHBvaW50IGlzIHByaW1lZCwgaWYgYW4gSU4NCj4gPiB0b2tlbiB0byB0aGUg
c2FtZSBlbmRwb2ludCBudW1iZXIgb24gYW5vdGhlciBkZXZpY2UgaXMgcmVjZWl2ZWQsIHRoZW4N
Cj4gPiB0aGUgT1VUIGVuZHBvaW50IG1heSBiZSB1bnByaW1lZCAoY2Fubm90IGJlIGRldGVjdGVk
IGJ5IHNvZnR3YXJlKSwNCj4gPiB3aGljaCBjYXVzZXMgdGhpcyBlbmRwb2ludCB0byBubyBsb25n
ZXIgcmVzcG9uZCB0byB0aGUgaG9zdCBPVVQgdG9rZW4sDQo+ID4gYW5kIHRodXMsIG5vIGNvcnJl
c3BvbmRpbmcgaW50ZXJydXB0IG9jY3Vycy4NCj4gPg0KPiA+IFRoZXJlIGlzIG5vIGdvb2Qgd29y
a2Fyb3VuZCBmb3IgdGhpcyBpc3N1ZSwgdGhlIG9ubHkgdGhpbmcgdGhlDQo+ID4gc29mdHdhcmUg
Y291bGQgZG8gaXMgbnVtYmVyaW5nIGlzb2Nocm9ub3VzIElOIGZyb20gdGhlIGhpZ2hlc3QNCj4g
PiBlbmRwb2ludCBzaW5jZSB3ZSBoYXZlIG9ic2VydmVkIG1vc3Qgb2YgZGV2aWNlIG51bWJlciBl
bmRwb2ludCBmcm9tIHRoZQ0KPiBsb3dlc3QuDQo+ID4NCj4gPiBDYzogPHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmc+ICN2My4xNCsNCj4gPiBDYzogSnVuIExpIDxqdW4ubGlAbnhwLmNvbT4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBQZXRlciBDaGVuIDxwZXRlci5jaGVuQG54cC5jb20+DQo+ID4gLS0tDQo+
ID4gQ2hhbmdlcyBmb3IgdjI6DQo+ID4gLSBTb21lIGNvZGluZyBzdHlsZSBpbXByb3ZlbWVudHMN
Cj4gDQo+ICAgICBOb3RoaW5nIHJlYWxseSBjaGFuZ2VkIGluIHRoZSBwYXRjaC4uLiA6LS8NCj4g
DQo+ID4gICBkcml2ZXJzL3VzYi9jaGlwaWRlYS91ZGMuYyB8IDI0ICsrKysrKysrKysrKysrKysr
KysrKysrKw0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDI0IGluc2VydGlvbnMoKykNCj4gPg0KPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9jaGlwaWRlYS91ZGMuYyBiL2RyaXZlcnMvdXNiL2No
aXBpZGVhL3VkYy5jDQo+ID4gaW5kZXggODI5ZTk0N2NhYmY1Li40MTFkMzg3YTQ1YzkgMTAwNjQ0
DQo+ID4gLS0tIGEvZHJpdmVycy91c2IvY2hpcGlkZWEvdWRjLmMNCj4gPiArKysgYi9kcml2ZXJz
L3VzYi9jaGlwaWRlYS91ZGMuYw0KPiA+IEBAIC0xNjIyLDYgKzE2MjIsMjkgQEAgc3RhdGljIGlu
dCBjaV91ZGNfcHVsbHVwKHN0cnVjdCB1c2JfZ2FkZ2V0ICpfZ2FkZ2V0LA0KPiBpbnQgaXNfb24p
DQo+ID4gICBzdGF0aWMgaW50IGNpX3VkY19zdGFydChzdHJ1Y3QgdXNiX2dhZGdldCAqZ2FkZ2V0
LA0KPiA+ICAgCQkJIHN0cnVjdCB1c2JfZ2FkZ2V0X2RyaXZlciAqZHJpdmVyKTsNCj4gPiAgIHN0
YXRpYyBpbnQgY2lfdWRjX3N0b3Aoc3RydWN0IHVzYl9nYWRnZXQgKmdhZGdldCk7DQo+ID4gKw0K
PiA+ICsNCj4gPiArLyogTWF0Y2ggSVNPQyBJTiBmcm9tIHRoZSBoaWdoZXN0IGVuZHBvaW50ICov
IHN0YXRpYyBzdHJ1Y3QgdXNiX2VwDQo+ID4gKypjaV91ZGNfbWF0Y2hfZXAoc3RydWN0IHVzYl9n
YWRnZXQgKmdhZGdldCwNCj4gDQo+ICAgICBIZXJlLi4uDQo+IA0KPiA+ICsJCQkgICAgICBzdHJ1
Y3QgdXNiX2VuZHBvaW50X2Rlc2NyaXB0b3IgKmRlc2MsDQo+ID4gKwkJCSAgICAgIHN0cnVjdCB1
c2Jfc3NfZXBfY29tcF9kZXNjcmlwdG9yICpjb21wX2Rlc2MpIHsNCj4gPiArCXN0cnVjdCBjaV9o
ZHJjICpjaSA9IGNvbnRhaW5lcl9vZihnYWRnZXQsIHN0cnVjdCBjaV9oZHJjLCBnYWRnZXQpOw0K
PiA+ICsJc3RydWN0IHVzYl9lcCAqZXA7DQo+ID4gKwl1OCB0eXBlID0gZGVzYy0+Ym1BdHRyaWJ1
dGVzICYgVVNCX0VORFBPSU5UX1hGRVJUWVBFX01BU0s7DQo+ID4gKw0KPiA+ICsJaWYgKCh0eXBl
ID09IFVTQl9FTkRQT0lOVF9YRkVSX0lTT0MpICYmDQo+ID4gKwkJKGRlc2MtPmJFbmRwb2ludEFk
ZHJlc3MgJiBVU0JfRElSX0lOKSkgew0KPiANCj4gICAgIC4uLiBhbmQgaGVyZS4NCj4gDQo+ID4g
KwkJbGlzdF9mb3JfZWFjaF9lbnRyeV9yZXZlcnNlKGVwLCAmY2ktPmdhZGdldC5lcF9saXN0LCBl
cF9saXN0KSB7DQo+ID4gKwkJCWlmIChlcC0+Y2Fwcy5kaXJfaW4gJiYgIWVwLT5jbGFpbWVkKQ0K
PiA+ICsJCQkJcmV0dXJuIGVwOw0KPiA+ICsJCX0NCj4gPiArCX0NCj4gPiArDQo+ID4gKwlyZXR1
cm4gTlVMTDsNCj4gPiArfQ0KPiA+ICsNCj4gPiAgIC8qKg0KPiA+ICAgICogRGV2aWNlIG9wZXJh
dGlvbnMgcGFydCBvZiB0aGUgQVBJIHRvIHRoZSBVU0IgY29udHJvbGxlciBoYXJkd2FyZSwNCj4g
PiAgICAqIHdoaWNoIGRvbid0IGludm9sdmUgZW5kcG9pbnRzIChvciBpL28pDQo+IFsuLi5dDQo+
IA0KDQpPb3BzLiBJIHVzZWQgdGhlIGZvcm1lciBwYXRjaCBmaWxlLiBzb3JyeSBhYm91dCB0aGF0
Lg0KDQpQZXRlcg0K

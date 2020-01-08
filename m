Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C72E13392F
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 03:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgAHCiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 21:38:23 -0500
Received: from mail-eopbgr30072.outbound.protection.outlook.com ([40.107.3.72]:64064
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725812AbgAHCiX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 21:38:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHI2cl4DROu3/8GWSjfyVgHGwC9T51y7pfYuaPwU8Ly7WKRx0FOGJ51++sBGWirP3UcMlPOEH8ZZ+9BmVXMpmLMUnOxvFQALrE3UK/QyCSwfCjfqPwlEFYGQxvlNrUDJcf/i9VkfM/Wvg5rp48OCqQqKETaUS7lxUlNKSix6LVWBmxLwE/XKUT1tiYOaYqSR84YGYLV+gJCGkvIcrVZ8VV5LlvSBevu7RAAZR/0F6ONlrC+BY/2+xoVAP5RBSjIp95uZNwArapeb50jyox2Kxcnd54SfynSGKRn8CLtjQ1Nq19jCyR7bfUeJ74LRHHe5Lg8D0eSaXshLexYRen8ZeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPMDQCDFXCjTGjIoYFYcc2LuFKhWOZ5DL/ZrIuLoUrM=;
 b=KaT7vaC5RHZZDnmW/Evr4HVSsJxYiksW3NFVvbcURNvSFnPiGLGGSdg8Lw2MjephBEk1Hsc9M2xXQDU5GPbYro+YjflIhVmV24eXOXE0saD5PzARacjfnHO1m5ej49T8RbyK9esVIlBtAa3fnzlWVFtQZuWGwqBExDcoN9Hy/kaJ0laHwBuNqvv1Db/sp0edUW0BacdkdCkNwUyD0Sx9Y9EZNhMh+GNZAFiIkBh8Hu0DUKNOvIFoOhFWPjU2nqdri6u6m7rxWDGw0eoKm2LJ+u0fAP0i3P5/rlWr20g3rYhmytZFmehCl6WrASPYz1omKfSPK/bTPb7c5YF7ai9l8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPMDQCDFXCjTGjIoYFYcc2LuFKhWOZ5DL/ZrIuLoUrM=;
 b=Okx1pJFxpR3XkLFxzIf+RQWb7R2RFAh71z06OxFNS6Y0kTctNZTMG7olRuuAaZWt5KsDQtBelcALAPSsktiIoSJcxlKRe/NuUmAkd9Z2QK4gAyQoBqD1mX5hjO1d2umGZsIcg2K+em3qMPSfbhxRofUjNJ5p6LJgloyC+SggeJE=
Received: from DB8PR04MB6826.eurprd04.prod.outlook.com (52.133.243.14) by
 DB8PR04MB5675.eurprd04.prod.outlook.com (20.179.9.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Wed, 8 Jan 2020 02:38:18 +0000
Received: from DB8PR04MB6826.eurprd04.prod.outlook.com
 ([fe80::7d82:244b:a750:d117]) by DB8PR04MB6826.eurprd04.prod.outlook.com
 ([fe80::7d82:244b:a750:d117%4]) with mapi id 15.20.2602.016; Wed, 8 Jan 2020
 02:38:18 +0000
From:   Ran Wang <ran.wang_1@nxp.com>
To:     Tejas Joglekar <Tejas.Joglekar@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jun Li <jun.li@nxp.com>, Peter Chen <peter.chen@nxp.com>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: RE: [PATCH] usb: dwc3: gadget: Fix controller get stuck when kicking
 extra transfer in wrong case
Thread-Topic: [PATCH] usb: dwc3: gadget: Fix controller get stuck when kicking
 extra transfer in wrong case
Thread-Index: AQHVxSphpQKq2PPQoUe5fmD1/GDiZqfe/HiAgAERIlA=
Date:   Wed, 8 Jan 2020 02:38:18 +0000
Message-ID: <DB8PR04MB6826D2A83F2DD353F9647B2EF13E0@DB8PR04MB6826.eurprd04.prod.outlook.com>
References: <20200107071441.480-1-ran.wang_1@nxp.com>
 <9f9d0193-8fe6-33b3-4f5c-95a1181e6681@synopsys.com>
In-Reply-To: <9f9d0193-8fe6-33b3-4f5c-95a1181e6681@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ran.wang_1@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 009d64d5-c492-4073-a133-08d793e3d227
x-ms-traffictypediagnostic: DB8PR04MB5675:|DB8PR04MB5675:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB5675106A3F92E9E049182E2FF13E0@DB8PR04MB5675.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10001)(10009020)(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(199004)(189003)(45080400002)(8936002)(8676002)(4326008)(9686003)(6636002)(478600001)(110136005)(81156014)(2906002)(81166006)(54906003)(5660300002)(966005)(316002)(55016002)(186003)(7696005)(66476007)(66556008)(66946007)(66446008)(64756008)(33656002)(26005)(71200400001)(76116006)(52536014)(6506007)(53546011)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB5675;H:DB8PR04MB6826.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oseAenXLFNh90urTFveUdFOcBIzXfE4GY26x9ohM7oKYmNtDSdHJY1qVrlwJ97KYvnuqMNgeeMcQ8/NUAD+ZZsg//OgYwYx+bCNpF8dXwZ6E04ql8LJvAQeCgct/dEvjkHukhrUZvl9DPTSsAFpnVYvJIwwyTCjYxYMY2KYH1V2ZBg16kzeIvm9aRIEBKpIsYkRjfBoKNc6ztnktdOxCbW1daCeN3ZY3WgcwQOuUXWPIIHacmoT9Dh8O5qyA/6YtP6MoRz299++xbdNlGftJoA/xJGnMBjWLY5XFl+cmO5PtCVFHZByvDA06YiVNzOm6ROsGdo1bwZvfmpPugyb/RancecjGXO7NAAtn9Yqj6C0chebiuqVdrSPwzwttsf8Pwt8gIkxmhiJIXGi/aNXPhWQgBsOgPkkC2VOqBEXgPi4KiIPx38BKg5hLKWFPIf1Nsa8++w8sSoqxQNCAjH8RVvdxDWHgXXb27p6yUz8tucGcaJjTNV2TIxaKv60Wpm/7wEdhmw1OIyLERA/+KFnFzw1Y+d4rIuFOkccdvdROszMVPMlGepCM6rDjVHjt2hyB10orxybCRYkwtO3PavCNDw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 009d64d5-c492-4073-a133-08d793e3d227
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 02:38:18.8109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tC+/rrxPnQ4y0yJs6Orr2SjEyWVzaXBonzMKEVxTAcfeCgIMFoM11ihHW8ZaW7oRsrYIi/Ye7rH7YpjDh+UQaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5675
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgVGVqYXMsDQoNCg0KT24gVHVlc2RheSwgSmFudWFyeSAwNywgMjAyMCAxODoxNiwgVGVqYXMg
Sm9nbGVrYXIgd3JvdGU6DQo+IEhpLA0KPiBPbiAxLzcvMjAyMCAxMjo0NCBQTSwgUmFuIFdhbmcg
d3JvdGU6DQo+ID4gQWNjb3JkaW5nIHRvIG9yaWdpbmFsIGNvbW1pdCBjOTZlNjcyNWRiOWQ2YSAo
InVzYjogZHdjMzogZ2FkZ2V0Og0KPiA+IENvcnJlY3QgdGhlIGxvZ2ljIGZvciBxdWV1aW5nIHNn
cyIpLCB3ZSB3b3VsZCBvbmx5IGtpY2sgb2ZmIGFub3RoZXINCj4gPiB0cmFuc2ZlciBpbiBjYXNl
IG9mDQo+ID4gcmVxLT5udW1fcGVuZGluZ19zZ3MgPiAwLg0KPiA+DQo+IFRoZSBjb21taXQgOGM3
ZDRiN2IzZDQzICgidXNiOiBkd2MzOiBnYWRnZXQ6IEZpeCBsb2dpY2FsIGNvbmRpdGlvbiIpIGZp
eGVzDQo+IHRoZSBjb21taXQgZjM4ZTM1ZGQ4NGUyICh1c2I6IGR3YzM6IGdhZGdldDogc3BsaXQN
Cj4gZHdjM19nYWRnZXRfZXBfY2xlYW51cF9jb21wbGV0ZWRfcmVxdWVzdHMoKSkuDQoNClllcywg
YWN0dWFsbHkgSSBoYXZlIHRyaWVkIHRvIGRpZyB0aGUgaGlzdG9yeSBvZiB0aGlzIGltcGxlbWVu
dGF0aW9uIGFzIG11Y2ggYXMgSSBjYW4uDQphbmQgdGhlIGNvbW1pdCBJIG1lbnRpb25lZCBsb29r
cyBsaWtlIHRoZSBmaXJzdCBvbmUgdG8gYWRkIHRoaXMgZnVuY3Rpb24uDQogDQo+ID4gSG93ZXZl
ciwgY3VycmVudCBsb2dpYyB3aWxsIGRvIHRoaXMgYXMgbG9uZyBhcyByZXEtPnJlbWFpbmluZyA+
IDAsDQo+ID4gdGhpcyB3aWxsIGluY2x1ZGUgdGhlIGNhc2Ugb2Ygbm9uLXNncyAoYm90aA0KPiA+
IGR3YzNfZ2FkZ2V0X2VwX3JlcXVlc3RfY29tcGxldGVkKHJlcSkgYW5kDQo+ID4gcmVxLT5udW1f
cGVuZGluZ19zZ3MgYXJlIDApIHRoYXQgd2UgZGlkIG5vdCB3YW50IHRvLg0KPiA+DQo+ID4gV2l0
aG91dCB0aGlzIGZpeCwgd2Ugb2JzZXJ2ZWQgZHdjMyBnb3Qgc3R1Y2sgb24gTGF5ZXJzY2FwZSBw
bGFmdG9ybXMNCj4gPiAoc3VjaCBhcw0KPiA+IExTMTA4OEFSREIpIHdoZW4gZW5hYmxpbmcgZ2Fk
Z2V0IChtYXNzIHN0b3JhZ2UgZnVuY3Rpb24pIGFzIGJlbG93Og0KPiA+DQo+IFNpbWlsYXIgaXNz
dWUgd2FzIHJlcG9ydGVkIGJ5IFRoaW5oIGFmdGVyIG15IGZpeCwgYW5kIGhlIGhhcyBzdWJtaXR0
ZWQgYQ0KPiBwYXRjaCBmb3IgdGhlIHNhbWUuIFlvdSBjYW4gcmVmZXIgdGhlIGRpc2N1c3Npb24N
Cj4gaHR0cHM6Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0
dHBzJTNBJTJGJTJGcGF0Y2gNCj4gd29yay5rZXJuZWwub3JnJTJGcGF0Y2glMkYxMTI5MjA4NyUy
RiZhbXA7ZGF0YT0wMiU3QzAxJTdDcmFuLndhbg0KPiBnXzElNDBueHAuY29tJTdDOTczNDVmMzhj
MTk4NDllNWE4MjYwOGQ3OTM1YThkMzElN0M2ODZlYTFkM2JjMmINCj4gNGM2ZmE5MmNkOTljNWMz
MDE2MzUlN0MwJTdDMCU3QzYzNzEzOTg4OTQ5NTc0OTg4OSZhbXA7c2RhdGE9dGNWNg0KPiBGV2px
dllZTzdCQ0J5QUNxQWclMkZCJTJCJTJGejNOQyUyQjIwJTJCSUVWdXlmSmM0JTNEJmFtcDtyZXNl
cg0KPiB2ZWQ9MC4NCg0KVGhhbmtzIGZvciB0aGlzIGluZm9ybWF0aW9uLiBJIHdpbGwgZm9sbG93
IHRoYXQgdGhyZWFkLg0KDQpSZWdhcmRzLA0KUmFuDQoNCj4gPiBbICAgMjcuOTIzOTU5XSBNYXNz
IFN0b3JhZ2UgRnVuY3Rpb24sIHZlcnNpb246IDIwMDkvMDkvMTENCj4gPiBbICAgMjcuOTI5MTE1
XSBMVU46IHJlbW92YWJsZSBmaWxlOiAobm8gbWVkaXVtKQ0KPiA+IFsgICAyNy45MzM0MzJdIExV
TjogZmlsZTogL3J1bi9tZWRpYS9zZGExLzQxOS90ZXN0DQo+ID4gWyAgIDI3LjkzNzk2M10gTnVt
YmVyIG9mIExVTnM9MQ0KPiA+IFsgICAyNy45NDEwNDJdIGdfbWFzc19zdG9yYWdlIGdhZGdldDog
TWFzcyBTdG9yYWdlIEdhZGdldCwgdmVyc2lvbjoNCj4gMjAwOS8wOS8xMQ0KPiA+IFsgICAyNy45
NDgwMTldIGdfbWFzc19zdG9yYWdlIGdhZGdldDogdXNlcnNwYWNlIGZhaWxlZCB0byBwcm92aWRl
DQo+IGlTZXJpYWxOdW1iZXINCj4gPiBbICAgMjcuOTU1MDY5XSBnX21hc3Nfc3RvcmFnZSBnYWRn
ZXQ6IGdfbWFzc19zdG9yYWdlIHJlYWR5DQo+ID4gWyAgIDI4LjQxMTE4OF0gZ19tYXNzX3N0b3Jh
Z2UgZ2FkZ2V0OiBzdXBlci1zcGVlZCBjb25maWcgIzE6IExpbnV4IEZpbGUtDQo+IEJhY2tlZCBT
dG9yYWdlDQo+ID4gWyAgIDQ4LjMxOTc2Nl0gZ19tYXNzX3N0b3JhZ2UgZ2FkZ2V0OiBzdXBlci1z
cGVlZCBjb25maWcgIzE6IExpbnV4IEZpbGUtDQo+IEJhY2tlZCBTdG9yYWdlDQo+ID4gWyAgIDY4
LjMyMDc5NF0gZ19tYXNzX3N0b3JhZ2UgZ2FkZ2V0OiBzdXBlci1zcGVlZCBjb25maWcgIzE6IExp
bnV4IEZpbGUtDQo+IEJhY2tlZCBTdG9yYWdlDQo+ID4gWyAgIDg4LjMxOTg5OF0gZ19tYXNzX3N0
b3JhZ2UgZ2FkZ2V0OiBzdXBlci1zcGVlZCBjb25maWcgIzE6IExpbnV4IEZpbGUtDQo+IEJhY2tl
ZCBTdG9yYWdlDQo+ID4gWyAgMTA4LjMyMDgwOF0gZ19tYXNzX3N0b3JhZ2UgZ2FkZ2V0OiBzdXBl
ci1zcGVlZCBjb25maWcgIzE6IExpbnV4DQo+ID4gRmlsZS1CYWNrZWQgU3RvcmFnZSBbICAxMjgu
MzIzNDE5XSBnX21hc3Nfc3RvcmFnZSBnYWRnZXQ6IHN1cGVyLXNwZWVkDQo+ID4gY29uZmlnICMx
OiBMaW51eCBGaWxlLUJhY2tlZCBTdG9yYWdlIFsgIDE0OC4zMjA4NTddIGdfbWFzc19zdG9yYWdl
DQo+ID4gZ2FkZ2V0OiBzdXBlci1zcGVlZCBjb25maWcgIzE6IExpbnV4IEZpbGUtQmFja2VkIFN0
b3JhZ2UgWw0KPiA+IDE0OC4zNjIwMjNdIGdfbWFzc19zdG9yYWdlIGdhZGdldDogc3VwZXItc3Bl
ZWQgY29uZmlnICMwOiB1bmNvbmZpZ3VyZWQNCj4gPg0KPiA+IEZpeGVzOiA4YzdkNGI3YjNkNDMg
KCJ1c2I6IGR3YzM6IGdhZGdldDogRml4IGxvZ2ljYWwgY29uZGl0aW9uIikNCj4gPg0KPiA+IENj
OiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4gU2lnbmVkLW9mZi1ieTogUmFuIFdhbmcgPHJh
bi53YW5nXzFAbnhwLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy91c2IvZHdjMy9nYWRnZXQu
YyB8IDIgKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9u
KC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYyBiL2Ry
aXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4gPiBpbmRleCAwYzk2MGE5Li41YjBmMDJmIDEwMDY0
NA0KPiA+IC0tLSBhL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4gPiArKysgYi9kcml2ZXJz
L3VzYi9kd2MzL2dhZGdldC5jDQo+ID4gQEAgLTI0OTEsNyArMjQ5MSw3IEBAIHN0YXRpYyBpbnQN
Cj4gPiBkd2MzX2dhZGdldF9lcF9jbGVhbnVwX2NvbXBsZXRlZF9yZXF1ZXN0KHN0cnVjdCBkd2Mz
X2VwICpkZXAsDQo+ID4NCj4gPiAgCXJlcS0+cmVxdWVzdC5hY3R1YWwgPSByZXEtPnJlcXVlc3Qu
bGVuZ3RoIC0gcmVxLT5yZW1haW5pbmc7DQo+ID4NCj4gPiAtCWlmICghZHdjM19nYWRnZXRfZXBf
cmVxdWVzdF9jb21wbGV0ZWQocmVxKSB8fA0KPiA+ICsJaWYgKCFkd2MzX2dhZGdldF9lcF9yZXF1
ZXN0X2NvbXBsZXRlZChyZXEpICYmDQo+ID4gIAkJCXJlcS0+bnVtX3BlbmRpbmdfc2dzKSB7DQo+
ID4gIAkJX19kd2MzX2dhZGdldF9raWNrX3RyYW5zZmVyKGRlcCk7DQo+ID4gIAkJZ290byBvdXQ7
DQo+ID4NCj4gDQo+IFRoYW5rcyAmIFJlZ2FyZHMsDQo+ICBUZWphcyBKb2dsZWthcg0K

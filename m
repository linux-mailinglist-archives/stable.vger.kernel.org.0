Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2AD2A83C5
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 17:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgKEQoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 11:44:55 -0500
Received: from mail-mw2nam12on2048.outbound.protection.outlook.com ([40.107.244.48]:38869
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726214AbgKEQoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 11:44:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUrFYwz5IgTvg2veOIz7QX8tNt7hAQAntLL7hyLKZYTgP/Djejq1TavIl3YqvaNXnhmnKFxTmf94FX+w26VRiCcflJidz4u5m5AJllWPUJc4e/G9/kC8S9cEk96csF+djmPcykjlX3SfhWu1ZS6DCGAS+GBl8KXRtO8HfbwScYbTrngYn8o1Lanu8uRLtLcYsWDWI38eaR1pOsL8Qfk0XCuKUUiK92yyGd/7JWuzENM71J+iPxAjuE3o+WtR5Y6G3AaATOT2j7XQY6o9lMviXDBGA1VrSKRgOMaWneOXH56yD6K4Vx2GCpIJFDzDzNtsf5s/IfV8kmZo0o+YhIROvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptQScykK4K+/DpKSgoW7Z/EWeluXRogVXATXcsG3v+Y=;
 b=XxCjavQqZiElwFTX0DPQ8DsqFj2tyg/cFnmWrnhmYr5XnKmQ/SEuTf83gkzPW/nsBoOZtlUEPMiUaoByMDrRimoWRTDPTk9FU3wopABH/NIs+PBrUYgelNqceVm7+6thJlmRJQg9zcrPGMRnzo5CFEcnjevDOlfrB8EMnPScbQ2fSTE90FeKyCq1jLQks2RoW9971UcqDQ+ipGROxmDnMWoxtzcw709cDDJCM0nz8wlQ5GD1uXDT0MWjwZiAMwZPFQCT6nHD4kZCQmDxH8//cYoStV9NLMHKCEWHhe8hbi0AzXwBg5Fg8F9wKggMhRz8keOzfmBE3t3qbA1ZIPEUUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptQScykK4K+/DpKSgoW7Z/EWeluXRogVXATXcsG3v+Y=;
 b=I7rfncWbjzVVmahta08+ZB7X/r7jQC3MtABOB+dZ9JN0dfc5wEUurJ/S7noqy/DUaoH0OJAWNFiaDLwytbEXbc8eQA8ayD/HXm7s0h8DYeOs9v0s1Zm4K09z0fCUdq68zl9q/nVgBlcuSEjsYdF9EyST/WvESwTVR9gY35igJqI=
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 (2603:10b6:910:45::21) by CY4PR10MB1862.namprd10.prod.outlook.com
 (2603:10b6:903:125::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 5 Nov
 2020 16:44:52 +0000
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::a4b0:cd03:3459:6853]) by CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::a4b0:cd03:3459:6853%2]) with mapi id 15.20.3499.032; Thu, 5 Nov 2020
 16:44:52 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "vigneshr@ti.com" <vigneshr@ti.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] mtd: cfi_cmdset_0002: Use status register where possible
Thread-Topic: [PATCH] mtd: cfi_cmdset_0002: Use status register where possible
Thread-Index: AQHWqIpTWSfEXw2OaEiocc+ivq8o4KmweGwAgAAOhQCAAAO2gIABFY8AgAXpLoCAAEZbAIAB+d4AgAALRIA=
Date:   Thu, 5 Nov 2020 16:44:52 +0000
Message-ID: <5928a41bec2fe977085cbea0f69413c684950d58.camel@infinera.com>
References: <20201022154506.17639-1-joakim.tjernlund@infinera.com>
         <20201030184736.4ec434f5@xps13>
         <aefef0187e5ebbe315e57e834ff1ba756ba88817.camel@infinera.com>
         <20201030195251.687809f7@xps13>
         <931f422255204f0420e6f1b79657f9770ce0cf6e.camel@infinera.com>
         <31ce9a84-d949-c1d1-a8c6-44ead119ca1b@ti.com>
         <2198bd20e69be374f7533f45118c98750eb5362a.camel@infinera.com>
         <1af99b7d-e388-3c41-a8d8-9f82067ae857@ti.com>
In-Reply-To: <1af99b7d-e388-3c41-a8d8-9f82067ae857@ti.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.1 
authentication-results: ti.com; dkim=none (message not signed)
 header.d=none;ti.com; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8bc11528-ca75-4fd7-bda7-08d881aa1e52
x-ms-traffictypediagnostic: CY4PR10MB1862:
x-microsoft-antispam-prvs: <CY4PR10MB18624DB05D10F24063772F97F4EE0@CY4PR10MB1862.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y0BJ3GeGwesX/bh/JFP6gUYWnPjv9ijG5wjhBwOYSonO4G7KnuC4oqnUa0vQwxXGt1uCOdNC8xGdKHCvSL5jH19/LU+JUrIicTKXi05mrvTTpRnhTNVZNHqWeIelzjHTIKcyf+GaPxvGSgZgyoIfjucgQoxBD2Td13pQQgc50POx08o/bLmOP3gF9JY6HMXVNLjMqR5/dfnnpj5Nibo5i9hhLpgYjF6necTx65d664eQqxIPC++50MDAbM8tBYjpVeJS6FgCeo7sGTy+cIRJ7r+p8k/kbqzYnqFKBwM5Z6NC2Qw5nAtmsyMF4AHQXRTFIigTyXujxN8Svw/Ong59lg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2389.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(6506007)(53546011)(478600001)(83380400001)(186003)(2616005)(36756003)(86362001)(66946007)(71200400001)(66556008)(4326008)(5660300002)(54906003)(6512007)(8936002)(76116006)(8676002)(91956017)(110136005)(6486002)(26005)(66476007)(2906002)(66446008)(64756008)(316002)(4001150100001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 5MlBOipMugtJBgnJjQdbI2Y84URgox6+aB2iEfz+IJFIvVVt8dJ6P070RqYnpwm9qilY+4LMtN5hCxL7Yj3/8TIqq0la7UPwlykwZFjlEK2J8XumbsMd8qRJEEh4i3OIp8IHLE31C+7Na2kpmRWz5P8uXDB53ms1h1bSiLQEz2RbEQXNVLpOw8TplkQ32g6ylDQMHYglQpbJOEy6zbzNUTTzNunTj3cr6dVE6W5/B7xGKPOQBOPfm8rk0rxNfAMQkUVt1NeSdOJY0bgUUvjEQcPdZ558VPUqt/0Ve+Bx6L5Fj0lmwW8+kgBXz/qU4KfW+e4b1IfVlq4NJ0IwJamUUO9oPePhpGN29Ru4j1xtpEnBx2hY7RuSXnG77eN3ucCngDnDW3Z2JyQpGNcRzSbEBITyCJ3+mWBAMveWFhIcSjW+RlUOB3xlcGd1QxgNefoEJdkoJAch3tYUHFKs2h6+M8RlqQ0KTWD35jnPQAZxmgZoPCZHM7+lsVkRqTtSEKcq7DGf/wMe9Ib0r/mIkFs3yjKa3lEQXMQ/zf4tYO8DELJVez1cF7iIOTPB3DED2rtcGPp2AGwkIJnbjHaEVpkYkfD/Bl6JHn4Vx5MMzvCoCYlvX48qMLbJbbnp8RQpufXrPeQy1EM8A8G6KQ0QMsBNsw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A33435C1DDD7AF4DAAFBB09CB84FCE50@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2389.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc11528-ca75-4fd7-bda7-08d881aa1e52
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2020 16:44:52.5627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B7k6i624PrX56vyi3EuPt8398vWF9O0aaKgUwyevhIMfP5VXttlMmfvAs2OGvvYHSwDm5G+3eO6HqwaqARRjHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1862
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIwLTExLTA1IGF0IDIxOjM0ICswNTMwLCBWaWduZXNoIFJhZ2hhdmVuZHJhIHdy
b3RlOg0KPiANCj4gT24gMTEvNC8yMCAzOjIzIFBNLCBKb2FraW0gVGplcm5sdW5kIHdyb3RlOg0K
PiA+IE9uIFdlZCwgMjAyMC0xMS0wNCBhdCAxMToxMiArMDUzMCwgVmlnbmVzaCBSYWdoYXZlbmRy
YSB3cm90ZToNCj4gPiA+IEhpIEpvYWtpbQ0KPiA+ID4gDQo+ID4gPiBPbiAxMC8zMS8yMCA0OjU2
IFBNLCBKb2FraW0gVGplcm5sdW5kIHdyb3RlOg0KPiA+ID4gPiBPbiBGcmksIDIwMjAtMTAtMzAg
YXQgMTk6NTIgKzAxMDAsIE1pcXVlbCBSYXluYWwgd3JvdGU6DQo+ID4gPiA+ID4gQ0FVVElPTjog
VGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBE
byBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IHJlY29nbml6
ZSB0aGUgc2VuZGVyIGFuZCBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUuDQo+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gDQo+IFsuLi5dDQo+ID4gPiBjb21taXQgNDg0NGVmODAzMDVkICgibXRkOiBjZmlf
Y21kc2V0XzAwMDI6IEFkZCBzdXBwb3J0IGZvciBwb2xsaW5nDQo+ID4gPiBzdGF0dXMgcmVnaXN0
ZXIiKSB3YXMgYWRkZWQgaW4gNS4zIGFuZCB0aGVyZWZvcmUgaXMgcGFydCBvZiA1LjQuIEJ1dA0K
PiA+ID4gbm90ZSB0aGF0IHRoaXMgaXMgYSAibmV3IGZlYXR1cmUiIGFuZCB0aGVyZWZvcmUgd29u
J3QgYmUgYmFja3BvcnRlZCB0bw0KPiA+ID4ga2VybmVscyBvbGRlciB0aGFuIDUuMy4NCj4gPiAN
Cj4gPiBPaCwgbXkgbWVtb3J5IGlzIG9mZiB0aGVuLCBzb3JyeS4NCj4gPiANCj4gPiA+IFNpbWls
YXJseSwgdGhpcyBwYXRjaCAod2hlbiBhY2NlcHRlZCkgaXMgbm90IGEgY2FuZGlkYXRlIGZvciBz
dGFibGUNCj4gPiA+IGtlcm5lbCBiYWNrcG9ydHMgYmVjYXVzZSB0aGUgaW50ZW50aW9uIG9mIGVu
YWJsaW5nIHBvbGxpbmcgc3RhdHVzDQo+ID4gPiByZWdpc3RlciBmb3IgV3JpdGUgQ29tcGxldGlv
biBpcyB0byBlbmFibGUgZmxhc2hlcyB0aGF0ICJkb24ndCIgc3VwcG9ydA0KPiA+ID4gRFEgcG9s
bGluZyBhdCBhbGwgKG1haW5seSBIeXBlckZsYXNoKS4NCj4gPiA+IEVuYWJsaW5nIHRoaXMgZm9y
IGFsbCBmbGFzaGVzIHRoYXQgc3VwcG9ydCB0aGUgZmVhdHVyZSBpcyBub3QgYSBidWcgZml4DQo+
ID4gPiBJTU8uIEFsc28sIHRoZXJlIGlzbid0IGVub3VnaCB0ZXN0aW5nIHRvIHByb3ZlIHRoYXQg
ZmVhdHVyZSB3b3JrcyBmb3INCj4gPiA+IGFsbCBDRkkgTk9SIGZsYXNoZXMgb24gYWxsIHBsYXRm
b3JtcyBhbmQgdGhlcmVmb3JlIHdvdWxkIGJlIHJpc2t5IHRvIGJlDQo+ID4gPiBiYWNrcG9ydGVk
IHRvIHN0YWJsZSBrZXJuZWxzLg0KPiA+IA0KPiA+IFRoaXMgaXMgMiB0aGluZ3MsDQo+ID4gwqAx
LiBtYWtpbmcgaXQgcG9zc2libGUgdG8gdXNlIEh5cGVyIGZsYXNoIChIVyBlbmFibGVtZW50KQ0K
PiA+IMKgMi4gaW1wcm92aW5nIHRoZSBmbGFzaCBkcml2ZXIgdG8gZnVuY3Rpb24gbW9yZSBwcmVj
aXNlKGdldHRpbmcgYW4gYWNjdXJhdGUgZXJyb3IgcmF0aGVyIHRoYW4gYSBUTU8pIGZvciBtb3N0
IEFNRCBmbGFzaGVzLg0KPiA+IA0KPiA+IDEuIGhhcHBlbnMgb24gYSByZWd1bGFyIGJhc2lzIGlu
IHN0YWJsZS4NCj4gPiAyLiBjYW4gYmUgZGlzY3Vzc2VkIGZvciBzdGFibGUgYnV0IHNob3VsZCBh
dCBsZWFzdCBnbyBpbnRvIG1hc3RlciBub3cgdGhhdCBzdGF0dXMgaGFzIGJlZW4gaW4gdGhlcmUg
Zm9yIGEgd2hpbGUNCj4gPiANCj4gDQo+IFllcywgYnV0IG15IG9iamVjdGlvbiBpcyB0aGF0IHRo
ZXJlIGhhcyBub3QgYmVlbiBlbm91Z2ggdGVzdGluZyB0byBwcm92ZQ0KPiB0aGF0IGl0cyBzYWZl
IHRvIGJhY2twb3J0IHRvIHN0YWJsZSBrZXJuZWxzIGFuZCB0aGVyZSBpcyBub3RoaW5nIHRoYXQn
cw0KPiBicm9rZW4gaW4gb2xkZXIga2VybmVscyB3aGljaCB0aGlzIHBhdGNoIGZpeGVzLg0KDQpT
ZW1pIGJyb2tlbiB0aG91Z2guIEkgc3R1bWJsZWQgdXBvbiBzb21lIGVyYXNlIGZhaWx1cmVzIHRo
YXQganVzdCByZXN1bHRlZCBpbiBhIHN1cGVyIGxvbmcgVE1PIGVycm9yDQpyYXRoZXIgdGhhbiBy
ZXBvcnQgYSBmYWlsdXJlIGRpcmVjdGx5KHRoZSBwYWdlIHdhcyBsb2NrZWQpLg0KDQpUaGVyZSBJ
IG5vIHdheSB0byBpbXByb3ZlIHVwb24gZXJyb3IgaGFuZGxpbmcgd2l0aG91dCB5b3VyIHN0YXR1
cyB1cGRhdGVzIGFuZCB0aGlzIGlzDQp0aGUgbWFpbiByZWFzb24gSSB3YW50IHlvdXIgcGF0Y2hl
cyBiYWNrcG9ydGVkIHRvIDQuMTkgYXMgd2VsbC4NCg0KTXkgcGF0Y2ggY2FuIGJlIGRyb3BwZWQg
Zm9yIHN0YWJsZSwgZ2l2aW5nIGl0IHRpbWUgdG8gbWF0dXJlIGluIG1hc3RlciB0aG91Z2guDQoN
CiBKb2NrZQ0K

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E23FDC1EA
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 11:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392711AbfJRJzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 05:55:12 -0400
Received: from mail-eopbgr140113.outbound.protection.outlook.com ([40.107.14.113]:59025
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389081AbfJRJzM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 05:55:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIy5ne8pU/dJJmDINzhcDRQGeS8VHYLMgLbrO10Y0hEEjvn3cL2soshAFTQGmCDDlM4S5s64VkJx2i5xfAvFLosVM3UMNkoSBs2m0tKaqetQxiZbt9oNv59r9FLT+1gvWza+2BmhbQaicVmrDLZiO/Zb38jLJWMvuIRl3caCiJ9Hhea+6vbrTLMlfuwv+BjvMCI1XDQCEFZLvo8YehH0Gx9aG0pr8EKbEE+1xhJPe5tlTDER4irvfcKu9PSIX0mYn+tmuvb5XRUzNnqSAm6lSggFAk6N5wCp9594+tOr9suQpzvp5ERWXonrS+Or3hfX54dK1nJigQPXrORenPcmpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+2r6QL/+kkttbY8p/Pq518SB5aAm7pzwDtwsG9hw1E=;
 b=ikP+Amiw+SEwzi554V8H1UJ581/ncZCOu2l8UtHL/amST6eqCKiyQWou8clwuDbif6TAJXXgdSNXQdfvmuKagL/653X9bHLDv5B28dStJOEwWDmfRmy6WuVHH5OyU3oM6aALRns2xOohxo5OrpJtewCMby70/JjPlsjDICCJThOZ+yRonJERqaRQK6A/k9KJQoRTeAMxN7rbl/oZRTaFkva3/gUGlKx0Sm1JtuXnD1NZXaPPaWUTtttGnvsbH3lrrfBxKJs9g9ZW2BZpMsc0sgtC0d7h7ZCF47+/3CdGL51toIDOelsmfeF8ENcI2X5zMEF8h6qbbKh9gfnfrMS9DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+2r6QL/+kkttbY8p/Pq518SB5aAm7pzwDtwsG9hw1E=;
 b=B8ayynvxLaQ12OtMbM331meox+kV42ANGH5avJCLavE+vaTuHdGZAV/3U5jy/lnNFK0WF8hp719ruR4gywP3fQGcWTerYJmZ9xXIPyz4II/tc5yxxx73mLbh0yoVS5XLCJfoSvPHRXlGaiS1Xr8mI2jTARZSDECcEy4S3JsZRzo=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.212) by
 AM6PR05MB4504.eurprd05.prod.outlook.com (52.135.168.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Fri, 18 Oct 2019 09:55:05 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c9f9:f21d:d401:7f35]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c9f9:f21d:d401:7f35%5]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 09:55:05 +0000
From:   Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
To:     "broonie@kernel.org" <broonie@kernel.org>
CC:     "festevam@gmail.com" <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Igor Opaniuk <igor.opaniuk@toradex.com>
Subject: Re: [PATCH 5.3 112/112] ASoC: sgtl5000: add ADC mute control
Thread-Topic: [PATCH 5.3 112/112] ASoC: sgtl5000: add ADC mute control
Thread-Index: AQHVhPVsKAZEluJB9E6wNlSBYDJtdadfCNyAgAEhcoA=
Date:   Fri, 18 Oct 2019 09:55:04 +0000
Message-ID: <1811a32aef35a221ad0b247f7de5241e51363904.camel@toradex.com>
References: <20191016214907.599726506@linuxfoundation.org>
         <20191016220044.GB11473@sirena.co.uk> <20191016221025.GA990599@kroah.com>
         <20191016223518.GC11473@sirena.co.uk> <20191016232358.GA994597@kroah.com>
         <de9630e5-341f-b48d-029a-ef1a516bf820@skidata.com>
         <AM6PR05MB653568E379699EE907E146BDF96D0@AM6PR05MB6535.eurprd05.prod.outlook.com>
         <CAGgjyvFQQ4E5VfZ3nwFu+7UiGOmkyXK-n9PHjo1p=iYNX5JrPw@mail.gmail.com>
         <20191017111122.GA4976@sirena.co.uk>
         <b90f4cfc04686a669d145b5c5e7e59e2edf58779.camel@toradex.com>
         <20191017163905.GH4976@sirena.co.uk>
In-Reply-To: <20191017163905.GH4976@sirena.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=oleksandr.suvorov@toradex.com; 
x-originating-ip: [194.105.145.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f3402ee-1fef-404e-7a01-08d753b14061
x-ms-traffictypediagnostic: AM6PR05MB4504:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB4504C239AEA01865610F4E55F96C0@AM6PR05MB4504.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(136003)(366004)(189003)(199004)(186003)(6512007)(2351001)(2501003)(102836004)(36756003)(66066001)(476003)(2906002)(2616005)(446003)(44832011)(8676002)(5660300002)(486006)(71190400001)(11346002)(54906003)(76176011)(99286004)(71200400001)(118296001)(6436002)(6486002)(26005)(5640700003)(4001150100001)(25786009)(6116002)(6246003)(229853002)(305945005)(6506007)(3846002)(4326008)(7736002)(91956017)(107886003)(76116006)(64756008)(6916009)(256004)(508600001)(14444005)(66556008)(66476007)(66446008)(66946007)(14454004)(1730700003)(81156014)(8936002)(81166006)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB4504;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iGdF5rwryxXohp/fu0G4gwGHu4lIxuTMJYnVmOMzrF1OwXejhWMnYobZ479Nbbmhvl0PJpzn8WKuH2q5WoPQyw3WDw4uI5OAO/5YXAMMjuQ6ubdSCm3a0WzRvvFr7vw0NKVDIurzmzPpTZ4f2BVH3PomVu+1p9yyCzK1NBb7rLeTMpfVsyn6iuCEkedvdaimGMlXtBNneD5GQ0Nu3qfOcS5RUOXnfxkAZjk3wo2EvpP/Bwbf27zWgIbUcQCwQ3WLUR9HMU8iW34XKSHowfU2Cv2cipgwt5mkcf0hLA9ORBGfjLRb2/A2LQL1/eNMG9g/wpGoi1NMzZiE4v0jRw5RCNm3ja1rTwU8FjuPHV0qm1ZpLZi3aIn2R2naca0DM6zVyxZOB6Fi1JYneFJk6kl8MRoN9MmX92/N1DK6jfvPPHM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6DE9FBA6AF368644B4F5DC32F58C7D8D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f3402ee-1fef-404e-7a01-08d753b14061
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 09:55:04.9611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8lcRW6C2Nngk62dLJ+KojwLxk6SgLXBnElqFujjNLPh9bZxyOOeYxNcLjniArbq1ri4ZASwd9paFSE0NcVQMDfSSJSPyOwAoB6hHIT43JkU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4504
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDE5LTEwLTE3IGF0IDE3OjM5ICswMTAwLCBNYXJrIEJyb3duIHdyb3RlOg0KPiAN
Cj4gQWxsIHZlcnNpb25zIG9mIGRyaXZlciBzZ3RsNTAwMCAoc2luY2UgY3JlYXRpbmcgaW4gMjAx
MSkgaGFzIGEgYnVnIGluDQo+ID4gc2d0bDUwMDBfcHJvYmUoKToNCj4gPiAuLi4NCj4gPiAgICAg
ICAgc25kX3NvY193cml0ZShjb2RlYywgU0dUTDUwMDBfQ0hJUF9BTkFfQ1RSTCwNCj4gPiAgICAg
ICAgICAgICAgICAgICAgICAgIFNHVEw1MDAwX0hQX1pDRF9FTiB8DQo+ID4gICAgICAgICAgICAg
ICAgICAgICAgICBTR1RMNTAwMF9BRENfWkNEX0VOKTsNCj4gPiAuLi4NCj4gPiBUaGlzIGNvbW1h
bmQgcmV3cml0ZXMgdGhlIHdob2xlIHJlZ2lzdGVyIHZhbHVlIGluc3RlYWQgb2YganVzdA0KPiA+
IGVuYWJsaW5nDQo+ID4gWkNEIGZlYXR1cmUgZm9yIGhlYWRwaG9uZSBhbmQgYWRjLg0KPiA+IFRo
aXMgcmVnaXN0ZXIgaGFzIGJpdHMgZm9yIEhQL0xpbmVPdXQvQURDIG11dGluZywgdGh1cw0KPiA+
IHNndGw1MDAwX3Byb2JlKCkNCj4gPiBhbHdheXMgdW5tdXRlcyBIUC9MaW5lT3V0L0FEQy4NCj4g
DQo+IFllcywgb3IgYXQgdGhlIHZlcnkgbGVhc3QgdGhpcyBpcyBhIGJhZGx5IGRvY3VtZW50ZWQg
Yml0IG9mDQo+IGludGVudGlvbmFsDQo+IGNvZGUuICBJIHN1c3BlY3QgaXQgbWF5IGJlIHRoZSBs
YXR0ZXIgYnV0IGF0IHRoaXMgcG9pbnQgd2UgY2FuJ3QNCj4gdGVsbC4NCj4gPiAyLiBrZWVwIDYz
MWJjOGYwMTM0YWUgYW5kIGFkZCA2OTRiMTQ1NTRkNzVmIHRvIDQuMTksIDUuMiBhbmQgNS4zLg0K
PiANCj4gVGhpcyBtZWFucyB0aGUgcGF0Y2ggdGhhdCBtYWtlcyBaQyBvbmx5IHVwZGF0ZSB0aGUg
WkMgYml0cyBhbmQgYWxzbw0KPiB0aGUNCj4gcGF0Y2ggdGhhdCBtYWtlcyB0aGUgbXV0ZXMgdXNl
ciBjb250cm9sbGFibGUsIHRoZSBkZWZhdWx0IGJlaW5nDQo+IG11dGVkLg0KPiBBcyBJIHBvaW50
ZWQgb3V0IHVwIHRocmVhZCB0aGlzIHdvdWxkIG1lYW4gdGhhdCBzb21lb25lIHVwZ3JhZGluZyB0
bw0KPiBhDQo+IG5ld2VyIHN0YWJsZSBtYXkgbmVlZCB0byBjaGFuZ2UgdGhlaXIgdXNlcnNwYWNl
IHRvIGRvIHRoZSB1bm11dGUNCj4gaW5zdGVhZA0KPiBvZiBoYXZpbmcgdGhpbmdzIHVuY29uZGl0
aW9uYWxseSB1bm11dGVkIGJ5IHRoZSBkcml2ZXIuICBUaGlzIGlzIG5vdA0KPiByZWFsbHkgd2hh
dCBwZW9wbGUgZXhwZWN0IGZyb20gc3RhYmxlIHVwZGF0ZXMsIHdlIHdhbnQgdGhlbSB0byBiZQ0K
PiBhYmxlDQo+IHRvIHB1bGwgdGhlc2UgaW4gd2l0aG91dCB0aGlua2luZyBhYm91dCBpdC4gIGkN
Cg0KSSB0aGluayBub3cgSSBzZWUsIHdoYXQgeW91IG1lYW4uDQoNCk9mIGNvcnNlLCB3ZSBjYW4g
Y2hhbmdlIHRoZSBvcmlnaW5hbCBjb21taXQNClsgNjMxYmM4ZjAxMzRhZSBBU29DOiBzZ3RsNTAw
MDogRml4IG9mIHVubXV0ZSBvdXRwdXRzIG9uIHByb2JlIF0NCmZvciBzdGFibGUgYnJhbmNoZXMs
IHVubXV0aW5nIEFEQy9IUC9MaW5lb3V0IGF0IHRoZSBlbmQgb2YgcHJvYmluZy4NCldlIGtlZXAg
YW4gb3JpZ2luYWwgYmVoYXZpb3VyIGZvciB1c2VycyBhbmQgcmVkdWNlIHRoZSBwb3NzaWJsZSAn
cG9wJw0Kb24gcHJvYmUuDQoNCkJ1dCwgdG8gdGFrZSBzaWduaWZpY2FudCBhZHZhbnRhZ2UsIHdl
IHNob3VsZCBhZGQgQURDIGNvbnRyb2wgdG9vLCBhbmQsDQphcyB0aGlzIGlzIGEgZmVhdHVyZSwg
aXQgaXMgdW5kZXNpcmFibGUgZm9yIHN0YWJsZSBicmFuY2hlcy4NCg0KU28gcHJvYmFibHkgdGhl
IGJlc3QgZGVjaXNpb24gaXMgdG8gcm9sbCBvcmlnaW5hbCA2MzFiYzhmMDEzNGFlIGJhY2sgaW4N
CmFsbCBzdGFibGUgYnJhbmNoZXMgd2hlcmUgaXQgd2FzIGFkZGVkLg0KDQpUaGFuayB5b3UsIE1h
cmsuIFlvdXIgZXhwbGFuYXRpb24gaXMgZXh0cmVtZWx5IHVzZWZ1bC4NCg0KPiBUbyBiYWNrcG9y
dCB0aGUgYWRkaXRpb24gb2YgdGhlIGNvbnRyb2xzIHRvIHN0YWJsZSB3ZSdkIG5lZWQgYW4NCj4g
YWRkaXRpb25hbCBjaGFuZ2Ugd2hpY2ggc2V0cyB0aGUgZGVmYXVsdCBmb3IgdGhpcyBjb250cm9s
IHRvIHVubXV0ZWQsDQo+IHRoZXJlJ3MgYSBjYXNlIGZvciBoYXZpbmcgc3VjaCBhIGNoYW5nZSB1
cHN0cmVhbSByZWdhcmRsZXNzIGJ1dCBpdCdzDQo+IHN0aWxsIG5vdCBjbGVhciBpZiBhbnkgb2Yg
dGhlc2UgY2hhbmdlcyBhcmUgcmVhbGx5IGZpeGVzIGluIHRoZSBzZW5zZQ0KPiB0aGF0IHdlIG1l
YW4gZm9yIHN0YWJsZS4NCg==

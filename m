Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D0098B6F
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 08:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfHVGfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 02:35:33 -0400
Received: from mail-eopbgr780040.outbound.protection.outlook.com ([40.107.78.40]:57072
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727476AbfHVGfd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 02:35:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eFAvtKeb06N4qq04TXgHeT1jSK3ETlEhYZBdhIjb+BpICZ9duM2Av79Z+CFM7pOsiJmbp42s07CDv3Rxx3+3lP8BXcnFYlQ+G8G6b8q6LiKwanGGEt7foaeoZK2i6Qwq7JcDm8O5j+KLk/y5ikul3rn35I8bgRiF9plM7NkBq0RvFYSKiJFDOkv0vNQzxFR7Ko6q9BwSxCRYlcWG1gntsTG1YMXBXor99NVf1ZbfM1o2Bw8Sf2hskX4f+KntbDQXxtJHUveUuk+JFk6Ju/5Kp6YxoswjSVaPjcJywB08HWn5hayKGnnqDc6zi7tszEfAtd5DRVlesVjLpnH7qtL4SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mj2s755RbFJ4CVQ+yH7gD+aR20UntcNrzfYc1VKbpA=;
 b=dBWaxw73Dyjhp4vVogJ7wszrV1uFNu+kobysFPZwNUbZRrw0y3K+FU0ovNbM6CEqCiBJdxIjTOzcFrerdh7s9cP85wLdf/aONBWNd4OU1xyyggTarE7hnpUQ0A0J76pvtve4gLdcKp6/dCLF5HL03Vvoor/7wua83dzF5+qaxAh2ZIzDLdw/flhC/2ASqeO8NC3/DYscKF0ScivqP6s8vfDjJfUYFiRFy8j8vwG/mHk794fZrtrFDxU614GjF/jlcDeDYv/5mxogBWOCX91j49V9MtLsUX525A8TCIjdz8fZElEG1c+tp5WhvaMGyqIlknXJoVRCNq/7PEP/H1wtyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mj2s755RbFJ4CVQ+yH7gD+aR20UntcNrzfYc1VKbpA=;
 b=yyI4eo24WV1yDKNfNaT4imElXQRFeA2zvJcZYumL+qWhEiW/U1/Wq0oHnh4eiEJb9u9c+VviVvRHfps/eeBjrJ1o/Tdsnuv0boybRGcvc/FjAPu7fp+QatT6Lw+4tub1LdfqiJYf9kB+SWfDscU6caWtJTQtcf+yaoQBS3B4tPQ=
Received: from BYAPR05MB5048.namprd05.prod.outlook.com (20.177.230.218) by
 BYAPR05MB5783.namprd05.prod.outlook.com (20.178.48.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.12; Thu, 22 Aug 2019 06:35:27 +0000
Received: from BYAPR05MB5048.namprd05.prod.outlook.com
 ([fe80::2422:dfa2:395c:aa11]) by BYAPR05MB5048.namprd05.prod.outlook.com
 ([fe80::2422:dfa2:395c:aa11%7]) with mapi id 15.20.2199.011; Thu, 22 Aug 2019
 06:35:27 +0000
From:   Vishnu Dasa <vdasa@vmware.com>
To:     Nadav Amit <namit@vmware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Francois Rigault <rigault.francois@gmail.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Adit Ranadive <aditr@vmware.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] VMCI: Release resource if the work is already queued
Thread-Topic: [PATCH] VMCI: Release resource if the work is already queued
Thread-Index: AQHVV9M8tJAqZjub1kOlwzCiMWHTG6cGQpEA
Date:   Thu, 22 Aug 2019 06:35:27 +0000
Message-ID: <9B1AACDC-21BF-486C-9102-21E2461C3433@vmware.com>
References: <20190820202638.49003-1-namit@vmware.com>
In-Reply-To: <20190820202638.49003-1-namit@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1c.0.190812
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vdasa@vmware.com; 
x-originating-ip: [2601:647:4a00:444d:4ce2:1e96:ef01:25e7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e0d09be-c213-40cb-06de-08d726caebb4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR05MB5783;
x-ms-traffictypediagnostic: BYAPR05MB5783:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR05MB57832B2B5123013AB23EFCD6CEA50@BYAPR05MB5783.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(199004)(189003)(51914003)(66476007)(46003)(66946007)(66556008)(14454004)(6436002)(6486002)(6512007)(66446008)(7736002)(91956017)(478600001)(316002)(76116006)(446003)(64756008)(71200400001)(86362001)(71190400001)(36756003)(2616005)(53936002)(53546011)(33656002)(25786009)(54906003)(6116002)(486006)(81156014)(81166006)(58126008)(2906002)(8676002)(11346002)(476003)(4326008)(76176011)(229853002)(102836004)(5660300002)(305945005)(186003)(256004)(110136005)(6246003)(6506007)(8936002)(14444005)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5783;H:BYAPR05MB5048.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4cMEY0LiMplTMAW9Nhs2b7ksoJd9ct61ZVfNveu1iFOLvZkYcumfYb/cqMo1eniFxE5FAv6SlBk1wKsNyntsAP6/kaxZAbZu+Rj/cePEE7zhweCn1TpWcqkzXnY8Hao3hfB4yIpxsNR4fBl/KKtWh5dtPcdkV4hRR9Y3DxlgpR2nVAmJEdUEPI5Op1//zyCLqIWpMy1ieoOqvoQdC/c3tEYNTHH+kNvrg0alPw3fQhwz4fzU/dIgvws3Qu1XS7yk1JItHep/xRhF4h3e8AisFms+Xokih5TJO1TlOl1w35e32kpfyRFHz95SRYd5UirBgMm0DfSVQcFQF1EgxBh8lVQM0puMKPw7QK+SkjeDtpS6+K2wNu6p5+bBSNn6i5F70YKrs5lhJblcS5kxTchWshnCXIoUIqjankaaBBBBBW0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F572DB676547324F8C02576706AAC553@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e0d09be-c213-40cb-06de-08d726caebb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 06:35:27.3729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ql5zWo/rqvqwpz46/5R3dBtGEAikivNRQBd2ng/q4KJjquSoakaC5epxxs5ksUjaVp7nJRvADPCQpi6TCox+UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5783
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gOC8yMC8xOSwgODo0OCBQTSwgIk5hZGF2IEFtaXQiIDxuYW1pdEB2bXdhcmUuY29tPiB3cm90
ZToNCj4gRnJhbmNvaXMgcmVwb3J0ZWQgdGhhdCBWTXdhcmUgYmFsbG9vbiBnZXRzIHN0dWNrIGFm
dGVyIGEgYmFsbG9vbiByZXNldCwNCj4gd2hlbiB0aGUgVk1DSSBkb29yYmVsbCBpcyByZW1vdmVk
LiBBIHNpbWlsYXIgZXJyb3IgY2FuIG9jY3VyIHdoZW4gdGhlDQo+IGJhbGxvb24gZHJpdmVyIGlz
IHJlbW92ZWQgd2l0aCB0aGUgZm9sbG93aW5nIHNwbGF0Og0KPiANCj4gWyAxMDg4LjYyMjAwMF0g
SU5GTzogdGFzayBtb2Rwcm9iZTozNTY1IGJsb2NrZWQgZm9yIG1vcmUgdGhhbiAxMjAgc2Vjb25k
cy4NCj4gWyAxMDg4LjYyMjAzNV0gICAgICAgVGFpbnRlZDogRyAgICAgICAgVyAgICAgICAgIDUu
Mi4wICM0DQo+IFsgMTA4OC42MjIwODddICJlY2hvIDAgPiAvcHJvYy9zeXMva2VybmVsL2h1bmdf
dGFza190aW1lb3V0X3NlY3MiIGRpc2FibGVzIHRoaXMgbWVzc2FnZS4NCj4gWyAxMDg4LjYyMjIw
NV0gbW9kcHJvYmUgICAgICAgIEQgICAgMCAgMzU2NSAgIDE0NTAgMHgwMDAwMDAwMA0KPiBbIDEw
ODguNjIyMjEwXSBDYWxsIFRyYWNlOg0KPiBbIDEwODguNjIyMjQ2XSAgX19zY2hlZHVsZSsweDJh
OC8weDY5MA0KPiBbIDEwODguNjIyMjQ4XSAgc2NoZWR1bGUrMHgyZC8weDkwDQo+IFsgMTA4OC42
MjIyNTBdICBzY2hlZHVsZV90aW1lb3V0KzB4MWQzLzB4MmYwDQo+IFsgMTA4OC42MjIyNTJdICB3
YWl0X2Zvcl9jb21wbGV0aW9uKzB4YmEvMHgxNDANCj4gWyAxMDg4LjYyMjMyMF0gID8gd2FrZV91
cF9xKzB4ODAvMHg4MA0KPiBbIDEwODguNjIyMzcwXSAgdm1jaV9yZXNvdXJjZV9yZW1vdmUrMHhi
OS8weGMwIFt2bXdfdm1jaV0NCj4gWyAxMDg4LjYyMjM3M10gIHZtY2lfZG9vcmJlbGxfZGVzdHJv
eSsweDllLzB4ZDAgW3Ztd192bWNpXQ0KPiBbIDEwODguNjIyMzc5XSAgdm1iYWxsb29uX3ZtY2lf
Y2xlYW51cCsweDZlLzB4ZjAgW3Ztd19iYWxsb29uXQ0KPiBbIDEwODguNjIyMzgxXSAgdm1iYWxs
b29uX2V4aXQrMHgxOC8weGNjOCBbdm13X2JhbGxvb25dDQo+IFsgMTA4OC42MjIzOTRdICBfX3g2
NF9zeXNfZGVsZXRlX21vZHVsZSsweDE0Ni8weDI4MA0KPiBbIDEwODguNjIyNDA4XSAgZG9fc3lz
Y2FsbF82NCsweDVhLzB4MTMwDQo+IFsgMTA4OC42MjI0MTBdICBlbnRyeV9TWVNDQUxMXzY0X2Fm
dGVyX2h3ZnJhbWUrMHg0NC8weGE5DQo+IFsgMTA4OC42MjI0MTVdIFJJUDogMDAzMzoweDdmNTRm
NjI3OTFiNw0KPiBbIDEwODguNjIyNDIxXSBDb2RlOiBCYWQgUklQIHZhbHVlLg0KPiBbIDEwODgu
NjIyNDIxXSBSU1A6IDAwMmI6MDAwMDdmZmYyYTk0OTAwOCBFRkxBR1M6IDAwMDAwMjA2IE9SSUdf
UkFYOiAwMDAwMDAwMDAwMDAwMGIwDQo+IFsgMTA4OC42MjI0MjZdIFJBWDogZmZmZmZmZmZmZmZm
ZmZkYSBSQlg6IDAwMDA1NWRmZjhiNTVkMDAgUkNYOiAwMDAwN2Y1NGY2Mjc5MWI3DQo+IFsgMTA4
OC42MjI0MjZdIFJEWDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6IDAwMDAwMDAwMDAwMDA4MDAgUkRJ
OiAwMDAwNTVkZmY4YjU1ZDY4DQo+IFsgMTA4OC42MjI0MjddIFJCUDogMDAwMDU1ZGZmOGI1NWQw
MCBSMDg6IDAwMDA3ZmZmMmE5NDdmYjEgUjA5OiAwMDAwMDAwMDAwMDAwMDAwDQo+IFsgMTA4OC42
MjI0MjddIFIxMDogMDAwMDdmNTRmNjJmNWNjMCBSMTE6IDAwMDAwMDAwMDAwMDAyMDYgUjEyOiAw
MDAwNTVkZmY4YjU1ZDY4DQo+IFsgMTA4OC42MjI0MjhdIFIxMzogMDAwMDAwMDAwMDAwMDAwMSBS
MTQ6IDAwMDA1NWRmZjhiNTVkNjggUjE1OiAwMDAwN2ZmZjJhOTRhM2YwDQo+IA0KPiBUaGUgY2F1
c2UgZm9yIHRoZSBidWcgaXMgdGhhdCB3aGVuIHRoZSAiZGVsYXllZCIgZG9vcmJlbGwgaXMgaW52
b2tlZCwgaXQNCj4gdGFrZXMgYSByZWZlcmVuY2Ugb24gdGhlIGRvb3JiZWxsIGVudHJ5IGFuZCBz
Y2hlZHVsZXMgd29yayB0aGF0IGlzDQo+IHN1cHBvc2VkIHRvIHJ1biB0aGUgYXBwcm9wcmlhdGUg
Y29kZSBhbmQgZHJvcCB0aGUgZG9vcmJlbGwgZW50cnkNCj4gcmVmZXJlbmNlLiBUaGUgY29kZSBp
Z25vcmVzIHRoZSBmYWN0IHRoYXQgaWYgdGhlIHdvcmsgaXMgYWxyZWFkeSBxdWV1ZWQsDQo+IGl0
IHdpbGwgbm90IGJlIHNjaGVkdWxlZCB0byBydW4gb25lIG1vcmUgdGltZS4gQXMgYSByZXN1bHQg
b25lIG9mIHRoZQ0KPiByZWZlcmVuY2VzIHdvdWxkIG5vdCBiZSBkcm9wcGVkLiBXaGVuIHRoZSBj
b2RlIHdhaXRzIGZvciB0aGUgcmVmZXJlbmNlDQo+IHRvIGdldCB0byB6ZXJvLCBkdXJpbmcgYmFs
bG9vbiByZXNldCBvciBtb2R1bGUgcmVtb3ZhbCwgaXQgZ2V0cyBzdHVjay4NCj4NCj4gRml4IGl0
LiBEcm9wIHRoZSByZWZlcmVuY2UgaWYgc2NoZWR1bGVfd29yaygpIGluZGljYXRlcyB0aGF0IHRo
ZSB3b3JrIGlzDQo+IGFscmVhZHkgcXVldWVkLg0KPg0KPiBOb3RlIHRoYXQgdGhpcyBidWcgZ290
IG1vcmUgYXBwYXJlbnQgKG9yIGFwcGFyZW50IGF0IGFsbCkgZHVlIHRvDQo+IGNvbW1pdCBjZTY2
NDMzMWIyNDggKCJ2bXdfYmFsbG9vbjogVk1DSV9ET09SQkVMTF9TRVQgZG9lcyBub3QgY2hlY2sg
c3RhdHVzIikuDQo+DQo+IEZpeGVzOiA4M2UyZWM3NjViZTAzICgiVk1DSTogZG9vcmJlbGwgaW1w
bGVtZW50YXRpb24uIikNCj4gUmVwb3J0ZWQtYnk6IEZyYW5jb2lzIFJpZ2F1bHQgPHJpZ2F1bHQu
ZnJhbmNvaXNAZ21haWwuY29tPg0KPiBDYzogSm9yZ2VuIEhhbnNlbiA8amhhbnNlbkB2bXdhcmUu
Y29tPg0KPiBDYzogQWRpdCBSYW5hZGl2ZSA8YWRpdHJAdm13YXJlLmNvbT4NCj4gQ2M6IEFsZXhp
b3MgWmF2cmFzIDxhbGV4aW9zLnphdnJhc0BpbnRlbC5jb20+DQo+IENjOiBWaXNobnUgREFTQSA8
dmRhc2FAdm13YXJlLmNvbT4NCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU2lnbmVk
LW9mZi1ieTogTmFkYXYgQW1pdCA8bmFtaXRAdm13YXJlLmNvbT4NCj4gLS0tDQo+IGRyaXZlcnMv
bWlzYy92bXdfdm1jaS92bWNpX2Rvb3JiZWxsLmMgfCA2ICsrKystLQ0KPiAxIGZpbGUgY2hhbmdl
ZCwgNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpUaGFua3MgZm9yIHRoZSBmaXgs
IGxvb2tzIGdvb2QgdG8gbWUuDQpSZXZpZXdlZC1ieTogVmlzaG51IERhc2EgPHZkYXNhQHZtd2Fy
ZS5jb20+DQoNCi0tDQp2aXNobnUNCg0K

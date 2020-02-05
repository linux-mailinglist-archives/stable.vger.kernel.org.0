Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C061528A7
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 10:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgBEJte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 04:49:34 -0500
Received: from mail-eopbgr130090.outbound.protection.outlook.com ([40.107.13.90]:49282
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727068AbgBEJte (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 04:49:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a48Fv+Z7ZEWzTU1f75kvVSHoSLkHp6gPlcI+5PzXQdDtjYqv1o2ybuJygmaF3sj1qYgaiGbjoeBrbfMCBZfDZKA2no+pEyfMCHhxYZoZbc6YO8RsiUpE4m5ztwuYa9xDtKmeKfMQP3cZpPYgz3C/314yonyz7q5NDtiZdv6Ho+w1mLf3/8Q1kjhTmNAJo/FB4PnpYT2blPMADLnfS51FHjMGWbyw0wC+9JMZkXuPc5cjCftlin2Y4x3qlIf29A5qg73HMs+V5lPvC1qoJCR4AU0X8SxZUTOM/KadIUzCAVPvrl1KPuBGPeGBzH+mcAKRyN/5HGkWarot3/c3Zg3kvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3D1+E0cz9ub0Q8e2TDuyAVDCEQuJMivWO7it8CUVVEw=;
 b=F0UK342lcV+ksacRFwD5gdYvkiNZTPdHvX3OhLwiHXTyCQUQb4vKlok9u3xwWLcxb4JOJno3UXmNv1l9xRn21YMk92KIO/b4rw7ufWxSYTkco2gO8WFAVqvpjm9CGPYHlmvgPbTfpVfrINh3AmT26WpydnRXkzMTyTEa8uiL41Y8RpciSJypMXYtZ5sLWHRAl8jfh4xxbTNjIkrWg3imUPYu8obIkvJQDwHc+BfyV3ywcsA6Eyq6PXR/IHLHRe0FRF/7SKvo1K8i87lVJDUo8ziR0kOVZdw5f9xfHfRwwr5p0XxwVUivuPPE4WiO2piDX++fsTGdoo3LWS9bsKoFxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Sony.onmicrosoft.com;
 s=selector2-Sony-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3D1+E0cz9ub0Q8e2TDuyAVDCEQuJMivWO7it8CUVVEw=;
 b=Q3nP91NImNgYZ8SvdORKbTIrMnqzSg2oPqQiVOEIksDJQZMEF+8eLad0dmfQxfwQDA099CTDYMkoHq088ZdWDvrhRTqYF+3pOZhHgIJrghGJoU/FzeigRs3K7W2uFUi+Unop1Z6Gyh1p2DMKEfL2fTt2E5ISW1w4/N2eHk6N1Gc=
Received: from DB8P193MB0488.EURP193.PROD.OUTLOOK.COM (20.180.3.12) by
 DB8P193MB0695.EURP193.PROD.OUTLOOK.COM (10.255.35.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 5 Feb 2020 09:49:30 +0000
Received: from DB8P193MB0488.EURP193.PROD.OUTLOOK.COM
 ([fe80::6ce3:8cc5:1278:94e7]) by DB8P193MB0488.EURP193.PROD.OUTLOOK.COM
 ([fe80::6ce3:8cc5:1278:94e7%6]) with mapi id 15.20.2686.034; Wed, 5 Feb 2020
 09:49:30 +0000
From:   "Enderborg, Peter" <Peter.Enderborg@sony.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "syzbot+09ef48aa58261464b621@syzkaller.appspotmail.com" 
        <syzbot+09ef48aa58261464b621@syzkaller.appspotmail.com>
Subject: Re: [PATCH 5.4 17/78] HID: Fix slab-out-of-bounds read in
 hid_field_extract (Broken!)
Thread-Topic: [PATCH 5.4 17/78] HID: Fix slab-out-of-bounds read in
 hid_field_extract (Broken!)
Thread-Index: AQHV3AdGg8ELjRm9m0KqfalRnm9xJKgMWw+A
Date:   Wed, 5 Feb 2020 09:49:30 +0000
Message-ID: <08ff9caa-0473-fae3-6f98-8530ed4c3b1a@sony.com>
References: <20200114094352.428808181@linuxfoundation.org>
 <20200114094356.028051662@linuxfoundation.org>
 <27ba705a-6734-9a92-a60c-23e27c9bce6d@sony.com>
 <20200205093226.GC1164405@kroah.com>
In-Reply-To: <20200205093226.GC1164405@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Peter.Enderborg@sony.com; 
x-originating-ip: [37.139.156.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a207a064-9ac7-4c0c-4156-08d7aa20b248
x-ms-traffictypediagnostic: DB8P193MB0695:
x-microsoft-antispam-prvs: <DB8P193MB069521B11C6214920A9584C086020@DB8P193MB0695.EURP193.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 0304E36CA3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(199004)(189003)(91956017)(76116006)(66446008)(64756008)(66476007)(66946007)(6486002)(66556008)(316002)(5660300002)(478600001)(54906003)(6512007)(110136005)(31686004)(86362001)(31696002)(186003)(71200400001)(36756003)(53546011)(6506007)(8936002)(26005)(8676002)(81156014)(81166006)(2616005)(2906002)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:DB8P193MB0695;H:DB8P193MB0488.EURP193.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: sony.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V8hEfoKXsDgo1D+/KMm8fDEBgCH2W5FSCdek6k3eHtmkkDX6XG9+Q0k6zTsVn5Uo6d85vMa1BUWQwR1ebM0kdd97Mc1WdddtV2ucPMG9+25kKiVYpYUm5lcKW16Vhe42ZevFk1LR1JrQmdh26QTNKEb0Y6tg4OB1cRtpLMBGFl3t7cpE03v58CjKt/+PUx5CAY5dJfCY2zCG43BUvMlAwXSQDuR+QGVv0lILyXBCphLTjoOC0tmtCjlxAsuLIHrrmy1kU3+wbDXRoY/Z2otHlvnkNQOyTY1tXAlnWnbIvG1j4ukpIknmPWrVEKeBI1KsLMCDYVLhxddEJGMC5o87eKVqmwuuaFpRo9NxpdO+RHS+iLrB3//9djYcE1MmnD2TNoaq4HHAiHvQXySTWiBvldEMVkqJUla2SSIFiHfgXAtNzbWcwk1p0nkoexdseS8D
x-ms-exchange-antispam-messagedata: IrPXCad0ZWx7+FdsN7acfgASJEAWDDbBiWAlZTDM1BscejkEn/FJzCed7Nr4ECbM2KsTBzcPNhkX6RTVJIz2Vr7OM5E2A+fxFfYUFt09SgfrRTVjdWfasiQKKxnYUfO/NoXOyUQSF0Zxg8NxIQt4Sw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <62DDFDB7F15C9944BD323C87C0EC9993@EURP193.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a207a064-9ac7-4c0c-4156-08d7aa20b248
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2020 09:49:30.1048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZAoz8Xh1lBSPz5wCm9G5t+27In8RZZeUA8srOXn1A03U4kBlnnun/xfrVYZc4QLCUeN6B3mHribBMq6StgvR2shl9jb2lRBlyEDjdjFQgMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P193MB0695
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMi81LzIwIDEwOjMyIEFNLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+IE9uIFdlZCwg
RmViIDA1LCAyMDIwIGF0IDA4OjEyOjI3QU0gKzAxMDAsIHBldGVyIGVuZGVyYm9yZyB3cm90ZToN
Cj4+IE9uIDEvMTQvMjAgMTE6MDAgQU0sIEdyZWcgS3JvYWgtSGFydG1hbiB3cm90ZToNCj4+PiBG
cm9tOiBBbGFuIFN0ZXJuIDxzdGVybkByb3dsYW5kLmhhcnZhcmQuZWR1Pg0KPj4+DQo+Pj4gY29t
bWl0IDhlYzMyMWU5NmUwNTZkZTg0MDIyYzAzMmZmZWEyNTM0MzFhODNjM2MgdXBzdHJlYW0uDQo+
Pj4NCj4+PiBUaGUgc3l6Ym90IGZ1enplciBmb3VuZCBhIHNsYWItb3V0LW9mLWJvdW5kcyBidWcg
aW4gdGhlIEhJRCByZXBvcnQNCj4+PiBoYW5kbGVyLiAgVGhlIGJ1ZyB3YXMgY2F1c2VkIGJ5IGEg
cmVwb3J0IGRlc2NyaXB0b3Igd2hpY2ggaW5jbHVkZWQgYQ0KPj4+IGZpZWxkIHdpdGggc2l6ZSAx
MiBiaXRzIGFuZCBjb3VudCA0ODk5LCBmb3IgYSB0b3RhbCBzaXplIG9mIDczNDkNCj4+PiBieXRl
cy4NCj4+Pg0KPj4+IFRoZSB1c2JoaWQgZHJpdmVyIHVzZXMgYXQgbW9zdCBhIHNpbmdsZS1wYWdl
IDQtS0IgYnVmZmVyIGZvciByZXBvcnRzLg0KPj4+IEluIHRoZSB0ZXN0IHRoZXJlIHdhc24ndCBh
bnkgcHJvYmxlbSBhYm91dCBvdmVyZmxvd2luZyB0aGUgYnVmZmVyLA0KPj4+IHNpbmNlIG9ubHkg
b25lIGJ5dGUgd2FzIHJlY2VpdmVkIGZyb20gdGhlIGRldmljZS4gIFJhdGhlciwgdGhlIGJ1Zw0K
Pj4+IG9jY3VycmVkIHdoZW4gdGhlIEhJRCBjb3JlIHRyaWVkIHRvIGV4dHJhY3QgdGhlIGRhdGEg
ZnJvbSB0aGUgcmVwb3J0DQo+Pj4gZmllbGRzLCB3aGljaCBjYXVzZWQgaXQgdG8gdHJ5IHJlYWRp
bmcgZGF0YSBiZXlvbmQgdGhlIGVuZCBvZiB0aGUNCj4+PiBhbGxvY2F0ZWQgYnVmZmVyLg0KPj4+
DQo+Pj4gVGhpcyBwYXRjaCBmaXhlcyB0aGUgcHJvYmxlbSBieSByZWplY3RpbmcgYW55IHJlcG9y
dCB3aG9zZSB0b3RhbA0KPj4+IGxlbmd0aCBleGNlZWRzIHRoZSBISURfTUFYX0JVRkZFUl9TSVpF
IGxpbWl0IChtaW51cyBvbmUgYnl0ZSB0byBhbGxvdw0KPj4+IGZvciBhIHBvc3NpYmxlIHJlcG9y
dCBpbmRleCkuICBJbiB0aGVvcnkgYSBkZXZpY2UgY291bGQgaGF2ZSBhIHJlcG9ydA0KPj4+IGxv
bmdlciB0aGFuIHRoYXQsIGJ1dCBpZiB0aGVyZSB3YXMgc3VjaCBhIHRoaW5nIHdlIHdvdWxkbid0
IGhhbmRsZSBpdA0KPj4+IGNvcnJlY3RseSBhbnl3YXkuDQo+Pj4NCj4+PiBSZXBvcnRlZC1hbmQt
dGVzdGVkLWJ5OiBzeXpib3QrMDllZjQ4YWE1ODI2MTQ2NGI2MjFAc3l6a2FsbGVyLmFwcHNwb3Rt
YWlsLmNvbQ0KPj4+IFNpZ25lZC1vZmYtYnk6IEFsYW4gU3Rlcm4gPHN0ZXJuQHJvd2xhbmQuaGFy
dmFyZC5lZHU+DQo+Pj4gQ0M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPj4+IFNpZ25lZC1v
ZmYtYnk6IEppcmkgS29zaW5hIDxqa29zaW5hQHN1c2UuY3o+DQo+Pj4gU2lnbmVkLW9mZi1ieTog
R3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCj4+Pg0KPj4+
IC0tLQ0KPj4+ICBkcml2ZXJzL2hpZC9oaWQtY29yZS5jIHwgICAgNiArKysrKysNCj4+PiAgMSBm
aWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQ0KPj4+DQo+Pj4gLS0tIGEvZHJpdmVycy9oaWQv
aGlkLWNvcmUuYw0KPj4+ICsrKyBiL2RyaXZlcnMvaGlkL2hpZC1jb3JlLmMNCj4+PiBAQCAtMjg4
LDYgKzI4OCwxMiBAQCBzdGF0aWMgaW50IGhpZF9hZGRfZmllbGQoc3RydWN0IGhpZF9wYXJzDQo+
Pj4gIAlvZmZzZXQgPSByZXBvcnQtPnNpemU7DQo+Pj4gIAlyZXBvcnQtPnNpemUgKz0gcGFyc2Vy
LT5nbG9iYWwucmVwb3J0X3NpemUgKiBwYXJzZXItPmdsb2JhbC5yZXBvcnRfY291bnQ7DQo+Pj4g
IA0KPj4+ICsJLyogVG90YWwgc2l6ZSBjaGVjazogQWxsb3cgZm9yIHBvc3NpYmxlIHJlcG9ydCBp
bmRleCBieXRlICovDQo+Pj4gKwlpZiAocmVwb3J0LT5zaXplID4gKEhJRF9NQVhfQlVGRkVSX1NJ
WkUgLSAxKSA8PCAzKSB7DQo+Pj4gKwkJaGlkX2VycihwYXJzZXItPmRldmljZSwgInJlcG9ydCBp
cyB0b28gbG9uZ1xuIik7DQo+Pj4gKwkJcmV0dXJuIC0xOw0KPj4+ICsJfQ0KPj4+ICsNCj4+PiAg
CWlmICghcGFyc2VyLT5sb2NhbC51c2FnZV9pbmRleCkgLyogSWdub3JlIHBhZGRpbmcgZmllbGRz
ICovDQo+Pj4gIAkJcmV0dXJuIDA7DQo+Pj4gIA0KPj4+DQo+Pj4NCj4+Pg0KPj4gVGhpcyBwYXRj
aCBicmVha3MgRWxnYXRvIFN0cmVhbURlY2suDQo+IERvZXMgdGhhdCBtZWFuIHRoZSBkZXZpY2Ug
aXMgYnJva2VuIHdpdGggYSB0b28tbGFyZ2Ugb2YgYSByZXBvcnQ/DQoNClllcy4NCg0KPiBJcyBp
dCBicm9rZW4gaW4gTGludXMncyB0cmVlPyAgSWYgc28sIGNhbiB5b3Ugd29yayB3aXRoIHRoZSBI
SUQNCj4gZGV2ZWxvcGVycyB0byBmaXggaXQgdGhlcmUgc28gd2UgY2FuIGJhY2twb3J0IHRoZSBm
aXggdG8gYWxsIHN0YWJsZQ0KPiB0cmVlcz8NCg0KSSBjYW50IHNlZSB0aGF0IHRoZXJlIGFyZSBh
bnkgb3RoZXIgZml4ZXMgdXBvbiB0aGlzIHNvIEkgZG9udCB0aGluayBzby4gSSBjYW4gdHJ5LsKg
wqANCg0KSmlyaSBpcyBpbiB0aGUgbG9vcC4gSSBndWVzcyBoZSBpcyB0aGUgIkhJRCBkZXZlbG9w
ZXJzIiA/DQoNCj4NCj4gdGhhbmtzLA0KPg0KPiBncmVnIGstaA0KDQo=

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E8C14EE04
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 14:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgAaN55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 08:57:57 -0500
Received: from mail-db8eur05hn2246.outbound.protection.outlook.com ([52.101.150.246]:6262
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728500AbgAaN55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 08:57:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhTVi9Vu0O9uHoWLhl+50iTjPejREZI5JY1jAMWcj4W1rDf79nH8OC02jhzV9iZXZp6TxxNANEqbCYlxvu/lOvlmSVNVc5EaoohCNwCG/RXjylwoasAi5g7AFRvXwt+kksqogpdgRJjzUPFwvFf/MzZB6aZ/HKU7qfAE/dSt92WIfZSq5HwBY3H49HxrLDQ4LfkOZTePxD7WWSbod/OWM+WB/0mc33Ojq3H6oZxpBkwWa8XTnFrkWJM3rzZqhM266w7KdsUzLoxpjODLBm85/w1iUXg3XSpsxegBqUlk8J1IcCdtBU+uDBVUlCNgntdwGN2LdY9SEK799J5kd8wR4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+UjitgXU3fXBKPXkDYOM9/znXqfzsvKF08qZfcGYVI=;
 b=CAwZgIOew1iLwa+ZsupEcAhnGXAKW2USw6HtXGIvdIL+KX3Wg0r67Yj1tX9ftPzDuktF3hIRh/xhsAn441dlZwSLZyyoxelI0S8eVK0vcdaAdOvj0BOyT+Yx82quG19CICiIaBs41za5i6iP8CwlFu0pTUehKB9G+oP6wdU5JZMMbj1IECmcwwVOafTCLZy6lAcIlKE6BIE8JbDdDawRF/vtTfn9fUcxMCTJO5VhA1DtFS+EQNLTXGcHopgAryEase7j7dT21a33jcR5T8x5bHG5hvcAiI48Nv46dVRlI3AIKGtl8ultd3TgZm4qGc7SK1ChX9KkMilRVeaj0zFE8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+UjitgXU3fXBKPXkDYOM9/znXqfzsvKF08qZfcGYVI=;
 b=bXVTcmHodwI2BP0Bzwznr9iFYLcAPIe8Da1o1y2Ku8I/s1l6pOCQ3ojU129DSMQRWvIU7LeHt0cW8LfK6oWPyWAQDQnjsWXD+biFzsbrqjdcqTmao28RLHDqOfDmOSSS1pmY0+/FkSNBgdmDGpISdhx3IEC1MFO06HiBdIYVeZc=
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com (10.167.127.12) by
 HE1PR0702MB3787.eurprd07.prod.outlook.com (52.133.6.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.13; Fri, 31 Jan 2020 13:57:47 +0000
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::d524:dc56:dd0e:c1a1]) by HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::d524:dc56:dd0e:c1a1%3]) with mapi id 15.20.2686.025; Fri, 31 Jan 2020
 13:57:47 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4.19 43/92] do_last(): fetch directory ->i_mode and
 ->i_uid before its too late
Thread-Topic: [PATCH 4.19 43/92] do_last(): fetch directory ->i_mode and
 ->i_uid before its too late
Thread-Index: AQHV1ec90l8XtXVIjUGbfw+3P3vanKgEkPoAgAAkyoCAABs9AA==
Date:   Fri, 31 Jan 2020 13:57:46 +0000
Message-ID: <2adb411b0a7f4f6c1449970e39a21ce6848b347c.camel@nokia.com>
References: <20200128135809.344954797@linuxfoundation.org>
         <20200128135814.584735840@linuxfoundation.org>
         <5cbe397b7f7bb0f8bd579080c8a4c41d7b359632.camel@nokia.com>
         <20200131122013.GF23230@ZenIV.linux.org.uk>
In-Reply-To: <20200131122013.GF23230@ZenIV.linux.org.uk>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tommi.t.rantala@nokia.com; 
x-originating-ip: [131.228.2.19]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3bc51ce2-22ac-48fd-93a7-08d7a6558d68
x-ms-traffictypediagnostic: HE1PR0702MB3787:|HE1PR0702MB3787:
x-microsoft-antispam-prvs: <HE1PR0702MB37871E3A21ACF208D41BEA7CB4070@HE1PR0702MB3787.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:261;
x-forefront-prvs: 029976C540
x-forefront-antispam-report: SFV:SPM;SFS:(10019020)(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(199004)(189003)(26005)(36756003)(186003)(4326008)(81156014)(81166006)(478600001)(86362001)(54906003)(316002)(6916009)(6506007)(8676002)(6512007)(66556008)(6486002)(71200400001)(5660300002)(8936002)(2616005)(2906002)(66946007)(76116006)(66446008)(66476007)(64756008)(239114006)(33073002)(31884003);DIR:OUT;SFP:1501;SCL:5;SRVR:HE1PR0702MB3787;H:HE1PR0702MB3675.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;CAT:OSPM;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d8I+1By/DsYvXaUvcG2f9Gd2vwuEgAhXRAfUSheA30SeDfmk17JHZTG1eNRKVJsZqQo3eYYTFH6veddNynghEKaabD25/2suwLhtwoAiG7KJeb1dzymzmgd8AaE9zSYsaBBxbPVlsr2V6oB3Y7+R4tGwuq2IFymW6G+qjdHYRUe5K/8whtca7u6ZV++YlDVXjU2eWEIDZTy+fg0GxrQsIL3/J/Y7FrA2qUfOaRJpvOHc9ShsiBaeq18VoXFO0d9uazOHD0kuFzzWhT5uF2LoedSpMHv89ct38mbe7avJPgY/RZ1OZtj0yDNHl623eb1fR+y0SaZ8KH6fVHN7aNkKn/XkfOWaxb5qb+YrPzcBVBDFP+RGRFQ1WPLdGCcDRw0W4y3WgLZTpITLDpXWKpnS1TEHdNDA8JP6RRHZfMyWgWzbIO42T0Fz1WSe3fHdqATuOJatGFDIqRE6AXyHYE0E5b8q23NG5pU/vp3eGuJyGoTVMNR4E7qHqcKD99VHWdezO6MyrDPFWiKFsKHjSAQ4OT9H4+qHCkDC/lRV1R9I6KiWpacd2a9sIYPLTamCwGZiWL+HkUG9wdytri0NOfkvgxRpxqGMHnrVym6r3aGRa1m/8NFuoIDbQur6vLRBqRJjoCeu+91iIuFc40znWeNA6dG6vrkKk0D1Jwzqj09V/pduCsefE1thIl5T0BGbIz8q8p076sugIWPo6QQqVjNCfv+778KytSLwVDR9tT78HK4havYwsZMpdUV3QVt63a7br7UCLLLvF8+7JKZ0DxajkR7WBGZdJJBDRoCDbRoZ0j9qMswYKH4hVuGk/M/RevGJ
x-ms-exchange-antispam-messagedata: CcvNhhM6OcPFTcfyocUUwvB+hCdNlJhJVK5VkWU1si53Mh2gEhEwwfToyi38JrOrx/S0cgdEqerlRwXsnF1/7RCAzhCK3Z1nlZJdI0e3nwnN2ZO9Y6ieqFMpW0YCQAVrNKSKEpWYiLi3qBYWrC/cHw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <657E964C3DE1F84DBEA920095E250377@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bc51ce2-22ac-48fd-93a7-08d7a6558d68
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2020 13:57:46.9537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B1meGrPuThFAsUNtWo7CogBUwbwUCNI3y0cJBOoa5ZWAa7IxeXvzMSRKv3eyzsk+zvBOhqC2DlC0ZwxtO/gicKUEr1BJ9zZu2ylEOiTbI1Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3787
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDIwLTAxLTMxIGF0IDEyOjIwICswMDAwLCBBbCBWaXJvIHdyb3RlOg0KPiBPbiBG
cmksIEphbiAzMSwgMjAyMCBhdCAxMDowODozN0FNICswMDAwLCBSYW50YWxhLCBUb21taSBULiAo
Tm9raWEgLQ0KPiBGSS9Fc3Bvbykgd3JvdGU6DQo+ID4gT24gVHVlLCAyMDIwLTAxLTI4IGF0IDE1
OjA4ICswMTAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+ID4gPiBGcm9tOiBBbCBWaXJv
IDx2aXJvQHplbml2LmxpbnV4Lm9yZy51az4NCj4gPiA+IA0KPiA+ID4gQEAgLTMyNTgsNiArMzI1
OSw4IEBAIHN0YXRpYyBpbnQgZG9fbGFzdChzdHJ1Y3QgbmFtZWlkYXRhICpuZCwNCj4gPiA+ICAJ
CSAgIHN0cnVjdCBmaWxlICpmaWxlLCBjb25zdCBzdHJ1Y3Qgb3Blbl9mbGFncyAqb3ApDQo+ID4g
PiAgew0KPiA+ID4gIAlzdHJ1Y3QgZGVudHJ5ICpkaXIgPSBuZC0+cGF0aC5kZW50cnk7DQo+ID4g
PiArCWt1aWRfdCBkaXJfdWlkID0gZGlyLT5kX2lub2RlLT5pX3VpZDsNCj4gPiANCj4gPiBJIGhp
dCB0aGUgZm9sbG93aW5nIG9vcHMgaW4gNC4xOS4xMDAgd2hpbGUgcnVubmluZyBrc2VsZnRlc3Rz
Lg0KPiA+IA0KPiA+IGZzL25hbWVpLmM6MzI2MiBtYXRjaGVzIHRoZSBsaW5lIGFib3ZlLg0KPiA+
IA0KPiA+IEFueSBpZGVhcz8NCj4gDQo+IFllcy4gIE1ha2UgdGhvc2UgdHdvIGxpbmUNCj4gCWt1
aWRfdCBkaXJfdWlkID0gbmQtPmlub2RlLT5pX3VpZDsNCj4gCXVtb2RlX3QgZGlyX21vZGUgPSBu
ZC0+aW5vZGUtPmlfbW9kZTsNCj4gDQo+IEknbSBwcmV0dHkgc3VyZSB0aGF0IEkga25vdyB3aGlj
aCB3YXkgSSdkIGZ1Y2tlZCB1cCB0aGVyZTsgd2UgY2FuDQo+IGdldCBoZXJlIGluIFJDVSBtb2Rl
IHdpdGggc3RhbGUgbmQtPnBhdGguZGVudHJ5ICh0aGF0IHdvdWxkIG1ha2UNCj4gdGhlIHRoaW5n
IGZhaWwgd2l0aCAtRUNISUxELiB3aXRoIHJldHJ5IGluIG5vbi1SQ1UgbW9kZSkuICBJbg0KPiBu
b24tc3RhbGUgY2FzZSBuZC0+aW5vZGUgaXMgdGhlIHNhbWUgYXMgbmQtPnBhdGguZGVudHJ5LT5k
X2lub2RlDQo+IGFuZCBpdCdzIGFsd2F5cyBwb2ludGluZyB0byBhIHN0cnVjdCBpbm9kZSB0aGF0
IGhhZG4ndCBiZWVuDQo+IGZyZWVkIHlldC4NCg0KVGhlIG9vcHMgZG9lcyBub3Qgc2VlbSB0byBy
ZXByb2R1Y2UgZWFzaWx5IHdpdGgga3NlbGZ0ZXN0cywgSSd2ZSBvbmx5IGhpdA0KaXQgb25jZSB3
aXRoIDQuMTkuMTAwLg0KDQpNYWRlIHRoZSBjaGFuZ2UgaW4gZnMvbmFtZWkuYywgc28gZmFyIG5v
IGlsbCBlZmZlY3RzLg0KSSdsbCBjb250aW51ZSBydW5uaW5nIHRoZSBrc2VsZnRlc3RzLi4uDQoN
Ci1Ub21taQ0KDQo=

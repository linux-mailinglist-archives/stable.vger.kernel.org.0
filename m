Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6330247B0F
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 01:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgHQX14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 19:27:56 -0400
Received: from mail-bn7nam10on2132.outbound.protection.outlook.com ([40.107.92.132]:58208
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726135AbgHQX1y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 19:27:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyXMp/vCPSQtr+s8ad9KzetspXsdZLlA3v5yvfkp/YuY4U0JO/QtYLSJA5TrD4A652NUaDmpiBvv4KMXY9bYo9cwpa7hT3D3jFLWYToa+M2JXistRnqHWR7bUWcE2xdmLdRS8VDcwKHRoOYG6KNKU/9GhDe6dS5CmnbHeARDnRjARk18kALlq4DGR1mv8eQEWKFMo642DmJc/uVvHzVo/Oeo1RXoT9xG7/ZJyhtYpgryVS9Od/lziLv9BCW1S744O3FAO4je8zXlKyUxpvV5MQcIaY7lnsa33J0gWL7dJ4lXI38ABbLyEzaD0gSuamEYeSrHr3P/FjY3qmF+QXgqxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UskLaReNqO+Z1/FQ3Ty2Ra3AOhony7fdXUKSgQe/vdM=;
 b=Bv+8RKo+e+Wy3nHlJpNTq4zjTg+hIGV+65dEblFTB2i4eibTRtL9cPnqvxARPJ0hGLKS0NS1OcdGMIJtYoywJhGRnvo6NWSbYwT9xVnztNESVraunOJl5OfpJwFzyufGWRFigeDXgH8Oh9Ll9USEmH7fVIoRgIf4nf4QbC6aKkzZZuSqBhtICusBJAYbY+yHQndgoWLQYrEDKd08OnY66y33TDYgRQqLwPuFaynpg+bHIcbleZJr+t24Bm0o19p2MD86j2O8NZar6RG/a6HppDvQWXBB1e7PNK0Ys7bqTSUuTZYzGnACAWkIJBsMFYBeRs5rrxD31ZitFZtXX8vs1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UskLaReNqO+Z1/FQ3Ty2Ra3AOhony7fdXUKSgQe/vdM=;
 b=Q84If4OqTlXVINAcPLiL+kHTh2CHVuABs6F7o/9blpZArcKT9gtdgNLVe80OFtbl0IShGfwDTV4g3E0+NAszsMQ0dDy2fkPGC6A5sO5+0Wpn20rs3FV1odZwX06YPYwtluyg7YTMC7WbYL2vi3o6eC8HF0KI5ZuZw5Qyl9FLTE4=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR21MB0846.namprd21.prod.outlook.com (2603:10b6:300:77::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.5; Mon, 17 Aug
 2020 23:27:49 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407%9]) with mapi id 15.20.3305.021; Mon, 17 Aug 2020
 23:27:49 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Wei Hu <weh@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 5.8 298/464] PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally
Thread-Topic: [PATCH 5.8 298/464] PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally
Thread-Index: AQHWdKuWUx6ySUWM/0+01vxmgMFcI6k88O5A
Date:   Mon, 17 Aug 2020 23:27:49 +0000
Message-ID: <MW2PR2101MB1052E21C566EA4F1C31F356FD75F0@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200817143833.737102804@linuxfoundation.org>
 <20200817143848.081418490@linuxfoundation.org>
In-Reply-To: <20200817143848.081418490@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-08-17T23:27:47Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e4b48add-b290-4ad9-86fa-3931c8517014;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 25097bd3-a55d-400b-655b-08d8430527dd
x-ms-traffictypediagnostic: MWHPR21MB0846:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB08463F701510805B67372E1AD75F0@MWHPR21MB0846.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hqfLGhHa1IKdGqj4ydt4GcFhgjrvB8m1fSBpqgjexAfAX8rhMGKlJHT++lTtkvlxqAMDOg3TKG6KutfFSU3ZgdgMiuOXqQZYrEZAAFaeBCVtYqGJ9F6UWwdg7DQhnPZMTDirCDC/46+Oaztj68kSHjFIzKvQQPuHoZJKdsX6McO1ZJUq+nVRXvElDuX4H0lheEwpfLW8PAaNSW/9BkDRMyuzjHP9VQpSlhgFSwIjZOeAqbergLOTUcuJkHeNZCU46FrxzywHZiKSHWjA3lEoi9jQlgTtgFeLlZS+6Px8Lq9i7ExWhuMDN3B4OMdovMT0RO1YoCWFvc7u9032PBTMdfMDTIMdx14aOq9ZTRimp0WxT42Zl41YLTaJOUqbBYpwNAA5y0taLvdySXWtoibZ1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(83380400001)(52536014)(33656002)(86362001)(5660300002)(478600001)(966005)(54906003)(110136005)(316002)(8990500004)(82950400001)(82960400001)(2906002)(76116006)(8936002)(66446008)(64756008)(66556008)(66476007)(10290500003)(9686003)(186003)(8676002)(66946007)(7696005)(4326008)(26005)(6506007)(55016002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +YHxzP0jGPp7WCcrazImFO/n9+m2TGaNuNU1KceRON67Ppaz69BclQJ4FqF+4jkiB70TP0b6JO8shtFpoUh1bl3lLZ+vgewgbEesXoLv3G2vEljSZY7KHOV1jUfSCIOb3jdmWG5JnYuv+kC9Ha40RhmoOMX2COf6AVWPIabd9UZznkDjB3doUnJKY9TX0+laH1kz/JbgTWnRVQvRiG9jGWD4QRxWHr9N+2xLvTDuO9XC1Yi7T3ZbvKmLw6oxXHSrmUT2AZcqNKyQvV8Be/73AqINIV7QzUXYrtfN9Cl7FJZdzj+DdGCiOZQmUiFdmQtcCpiuqOYAhtEMfFXqAZXLm+EJYDakE+ZsjWWnxmWwfzxJJ9um0LiUqvh1PWHTaw8Ig8JYj8xlB1rxPubZKOkbb/Yo/CcxH7b2rr2wZZaRacLTHJQ0kor0JIOfftSoVp7TH6V5cT5UzZqzgdfATd22PqWM7kWuV1GjeSVdxIEThkgW8fZvftjUOY0P789RtuAfKzAj490jZxgZIdllF7UgD/F6xoithFgIdiFMAbkhxHOGZRCfoFc+kQxqCeUSnNMUVIwUUEhM6Ecf4eCYRTkINfKCds/nPNRhDaHQTHO9uwAiGDRmayFmr/6YxDBPehUPIpRFG3A5dkBJq5M5gCcJEQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25097bd3-a55d-400b-655b-08d8430527dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2020 23:27:49.5003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KRjYTd/Ltl9ci3mdDe1fjdxiCWkH3R+wmfQqJm33PcdaDa1eHDlqWbhmklmU+HeHgqWam6mj/CIRS+HB0SaI9wiU6LZKGA9JK5KezL0RpV0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0846
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gIFNl
bnQ6IE1vbmRheSwgQXVndXN0IDE3LCAyMDIwIDg6MTQgQU0NCj4gDQo+IEZyb206IFdlaSBIdSA8
d2VoQG1pY3Jvc29mdC5jb20+DQo+IA0KPiBbIFVwc3RyZWFtIGNvbW1pdCBkNmFmMmVkMjljN2Mx
YzMxMWI5NmRhYzk4OWRjYjk5MWU5MGVlMTk1IF0NCj4gDQo+IEtkdW1wIGNvdWxkIGZhaWwgc29t
ZXRpbWUgb24gSHlwZXItViBndWVzdCBiZWNhdXNlIHRoZSByZXRyeSBpbg0KPiBodl9wY2lfZW50
ZXJfZDAoKSByZWxlYXNlcyBjaGlsZCBkZXZpY2Ugc3RydWN0dXJlcyBpbiBodl9wY2lfYnVzX2V4
aXQoKS4NCj4gDQo+IEFsdGhvdWdoIHRoZXJlIGlzIGEgc2Vjb25kIGFzeW5jaHJvbm91cyBkZXZp
Y2UgcmVsYXRpb25zIG1lc3NhZ2Ugc2VuZGluZw0KPiBmcm9tIHRoZSBob3N0LCBpZiB0aGlzIG1l
c3NhZ2UgYXJyaXZlcyB0byB0aGUgZ3Vlc3QgYWZ0ZXINCj4gaHZfc2VuZF9yZXNvdXJjZV9hbGxv
Y2F0ZWQoKSBpcyBjYWxsZWQsIHRoZSByZXRyeSB3b3VsZCBmYWlsLg0KPiANCj4gRml4IHRoZSBw
cm9ibGVtIGJ5IG1vdmluZyByZXRyeSB0byBodl9wY2lfcHJvYmUoKSBhbmQgc3RhcnQgdGhlIHJl
dHJ5DQo+IGZyb20gaHZfcGNpX3F1ZXJ5X3JlbGF0aW9ucygpIGNhbGwuICBUaGlzIHdpbGwgY2F1
c2UgYSBkZXZpY2UgcmVsYXRpb25zDQo+IG1lc3NhZ2UgdG8gYXJyaXZlIHRvIHRoZSBndWVzdCBz
eW5jaHJvbm91c2x5OyB0aGUgZ3Vlc3Qgd291bGQgdGhlbiBiZQ0KPiBhYmxlIHRvIHJlYnVpbGQg
dGhlIGNoaWxkIGRldmljZSBzdHJ1Y3R1cmVzIGJlZm9yZSBjYWxsaW5nDQo+IGh2X3NlbmRfcmVz
b3VyY2VfYWxsb2NhdGVkKCkuDQo+IA0KPiBMaW5rOg0KPiBodHRwczovL2xvcmUua2VybmVsLm9y
Zy9saW51eC1oeXBlcnYvMjAyMDA3MjcwNzE3MzEuMTg1MTYtMS13ZWhAbWljcm9zb2Z0LmNvbS8N
Cj4gRml4ZXM6IGM4MTk5MmU3ZjRhYSAoIlBDSTogaHY6IFJldHJ5IFBDSSBidXMgRDAgZW50cnkg
b24gaW52YWxpZCBkZXZpY2Ugc3RhdGUiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBXZWkgSHUgPHdlaEBt
aWNyb3NvZnQuY29tPg0KPiBbbG9yZW56by5waWVyYWxpc2lAYXJtLmNvbTogZml4ZWQgYSBjb21t
ZW50IGFuZCBjb21taXQgbG9nXQ0KPiBTaWduZWQtb2ZmLWJ5OiBMb3JlbnpvIFBpZXJhbGlzaSA8
bG9yZW56by5waWVyYWxpc2lAYXJtLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IE1pY2hhZWwgS2VsbGV5
IDxtaWtlbGxleUBtaWNyb3NvZnQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTYXNoYSBMZXZpbiA8
c2FzaGFsQGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiAgZHJpdmVycy9wY2kvY29udHJvbGxlci9wY2kt
aHlwZXJ2LmMgfCA3MSArKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDM3IGluc2VydGlvbnMoKyksIDM0IGRlbGV0aW9ucygtKQ0KPiANCg0KR3JlZyAtLQ0K
DQpEb24ndCBiYWNrcG9ydCB0aGlzIHBhdGNoIHRvIDUuOCBhbmQgZWFybGllci4gIEl0IGRvZXNu
J3QgYnJlYWsgYW55dGhpbmcsDQpidXQgaXQgZG9lc24ndCBmdWxseSBhY2NvbXBsaXNoIHdoYXQg
d2FzIGludGVuZGVkIGVpdGhlci4gIEFzIHN1Y2ggaXQgd2lsbA0KcHJvYmFibHkgbmVlZCBhIHJl
dmlzaW9uIGluIDUuOS4gIFdlaSBIdSBpcyB1bmF2YWlsYWJsZSBmb3IgYSBmZXcgZGF5cw0KZm9y
IHBlcnNvbmFsIHJlYXNvbnMsIHNvIEknbSBqdW1waW5nIGluIGhlcmUgb24gaGlzIGJlaGFsZi4N
Cg0KTWljaGFlbA0K

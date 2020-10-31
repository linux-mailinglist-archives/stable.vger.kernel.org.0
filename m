Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDD92A1572
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgJaL0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:26:23 -0400
Received: from mail-mw2nam10on2057.outbound.protection.outlook.com ([40.107.94.57]:16000
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726789AbgJaL0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:26:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKWsRxWjCpG87w3D9gpi1AemukFTNSRVgihSQwM/BxMMZGZJF7TBzkMukmBBF42C4RqUFgu+c+mPKmUpX5B0BxLcoRMB+EQ0RIH3hyY0mU0nQWcF/m+3Hsk5qhZFQRgeCfJLAIkaiJ8hCOWw//wHC/E6+te1wi/HHZn67OLfATTy9Y+eh6RLzTXNX5z44Q+emy37Dt+m82Jh5BJGtXwkfD1srnTKTSnizQQPK7V84XZ3EcWnT2AY3LS8v4eogN8pnDsWLDtrX+FwL4Hcxwis2WCx+xBZirYhKIbjdHyqwTe9veCrp0vfsIFhGEzgMpquZMdvTY8hSrwF4yFWEhQB5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtQDnTG16V1DHPy+eJAPc5adpIp2T+AbI07+P6vREs0=;
 b=P8f5p1+GsebUDV3a3nkj6k4vGIIg/DuovlBk9OH9XR1PQ84paR6Jrh/Tj+0j6bxRSKAfpEKz3m9boh3ORdOpo0I16MqtBeJu5B5WMvLPQpMpF7NZRc4mKmU6AHhLTbXUnC4mMLERNn2/Q0tAIp/Qs8w7A06bXtO1VqIL/p5qtKSrjDZMOJvSUkckOJSWb/ySGu0jXayTyN1F/qR7Tyzij/KyBJ3XEsz56RnLFnJGN4WYs3j8JMMJRR758gMWebBxHEEHfwlxLVaaswptuEMDJuwoW748EQqEA7wA8N9gbMD9bNkpdmPD2XsKYsV1Q0cVXTqYl0vhSkNEsnPaa5KfmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtQDnTG16V1DHPy+eJAPc5adpIp2T+AbI07+P6vREs0=;
 b=FcCnXyqVNzlVoLtBgPXUEN98KuaqxS7Q6WSmm7lK81z0jxLemc37ZBy8wOIDa2/Bx97sReA0yDihdATfEPBR+Zpf4nTqfmAV1/6iAG7tI27724eSJC5Y6u4eEl+5oFc7OgUhE813xn8gd24GshG0PlIvYS50e8gbvS5Z4SaRMmU=
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 (2603:10b6:910:45::21) by CY4PR1001MB2168.namprd10.prod.outlook.com
 (2603:10b6:910:48::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Sat, 31 Oct
 2020 11:26:18 +0000
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::a4b0:cd03:3459:6853]) by CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::a4b0:cd03:3459:6853%2]) with mapi id 15.20.3499.027; Sat, 31 Oct 2020
 11:26:18 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "vigneshr@ti.com" <vigneshr@ti.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] mtd: cfi_cmdset_0002: Use status register where possible
Thread-Topic: [PATCH] mtd: cfi_cmdset_0002: Use status register where possible
Thread-Index: AQHWqIpTWSfEXw2OaEiocc+ivq8o4KmweGwAgAAOhQCAAAO2gIABFY8A
Date:   Sat, 31 Oct 2020 11:26:18 +0000
Message-ID: <931f422255204f0420e6f1b79657f9770ce0cf6e.camel@infinera.com>
References: <20201022154506.17639-1-joakim.tjernlund@infinera.com>
         <20201030184736.4ec434f5@xps13>
         <aefef0187e5ebbe315e57e834ff1ba756ba88817.camel@infinera.com>
         <20201030195251.687809f7@xps13>
In-Reply-To: <20201030195251.687809f7@xps13>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.1 
authentication-results: ti.com; dkim=none (message not signed)
 header.d=none;ti.com; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9fe306f4-bee1-47bc-7dfe-08d87d8fc98f
x-ms-traffictypediagnostic: CY4PR1001MB2168:
x-microsoft-antispam-prvs: <CY4PR1001MB21681F71EC08DF499EECE4E3F4120@CY4PR1001MB2168.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gmPF6W8ia3i2biLnijCOTLhniCrAbCigxY63fzGwl4wYGbVDRgpe5NySG46Rx4XCs3wBVElyDxsnZaQlnwr1l7COoL+K74ulBCvDYFYXVkpKU1c7nWOgqNsZVca+++510p9p6DiY4QqlqtRN/XkDeDhiylvBphxIqirbYe3OFkUiqga+2/EoqTyNOMpmVjZ2Buvvpvc0nd2hW+Z7YP8+9awH8QEhaJO76Jb4PIjHARvtVwLDSAskvjsyeeDpM0FQL2TF0i48KJzRvHRIKL3uvCITc2VeRSHQzlCpNnDsmX+PGMieLxpsHxGd9zGalWYt3R+GBZI+it/eO1i1ioyTBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2389.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(6512007)(186003)(110136005)(4001150100001)(26005)(36756003)(316002)(54906003)(6506007)(478600001)(2616005)(71200400001)(2906002)(66946007)(4326008)(66476007)(86362001)(66556008)(66446008)(76116006)(91956017)(8936002)(8676002)(6486002)(64756008)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: AB9O9EYX87gL2n+7zqr6KP2Fgn+yOWWMm6qeelef9PUfoijt4E8mreWnK98xy0NcF60F+mcq5WlVfo0JgAIDrNqSosWrFL0STdSSCS4eD627uzlNniDsUdvfTyWN6pzZXVW6/2fjg8OopL1fTBiL8KNZ6H6uHnKy76kRHt7cNaGGkpOQNHDgeg7xdIEA2pFeROkM3o5bSF1naXghzICLkVJQZg+f/bOqJsFfQRXMXCjzf70YODtRj7/AH9tx5qacSwLKzcegcxVbG0HfjaB083ziTGeakUBxPXpZuXjDkFvxGkJNa1JIzHP8QC/XmRqrMr+YjRvUPR4JpcGFl+SrJ+QovqMp9aw+DkUN9ccEuCWxUKlKIVD+39gF2uY+P5Oc098QiOLbr+bsKWw91GYE6pCOxw4OZKprbFZlPsAD4Qp23S/0fcXUEDarctKBbvcBG3ZsYaA7GM/0atIVRjRHRxE+fitdU65QqhPBn2Wiuvszy3B5XYMe1hIxfyBKB46qUP7f/RRakY4PVkr5klwhoI+zilrBm+QFCF/wSFfiN2zzMBhAhwdwCn0HLFYctq91D4aOObbBCqiWQDIeHoivkXOn2wM3qqacolM++mCcKgHAjn0KzT/yo8XUE/HDA8AGeUWr1VMrcevG50Klzj7ytQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9A607EDDDFE3A4BB69914B1B1C18097@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2389.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fe306f4-bee1-47bc-7dfe-08d87d8fc98f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2020 11:26:18.7805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z8ast3NK4/yqDSQiIn1IReqC/ji4yoGW2wYuGVUPQxuLbRQYv68KETdYfriywj1TYYwaV3g9QTh86I05zb7pCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2168
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTMwIGF0IDE5OjUyICswMTAwLCBNaXF1ZWwgUmF5bmFsIHdyb3RlOg0K
PiBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdh
bml6YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3UgcmVjb2duaXplIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4g
DQo+IA0KPiBIaSBKb2FraW0sDQo+IA0KPiBKb2FraW0gVGplcm5sdW5kIDxKb2FraW0uVGplcm5s
dW5kQGluZmluZXJhLmNvbT4gd3JvdGUgb24gRnJpLCAzMCBPY3QNCj4gMjAyMCAxODozOTozNSAr
MDAwMDoNCj4gDQo+ID4gT24gRnJpLCAyMDIwLTEwLTMwIGF0IDE4OjQ3ICswMTAwLCBNaXF1ZWwg
UmF5bmFsIHdyb3RlOg0KPiA+ID4gDQo+ID4gPiBIaSBKb2FraW0sDQo+ID4gDQo+ID4gSGkgTWlx
dWVsDQo+ID4gDQo+ID4gPiANCj4gPiA+IFBsZWFzZSBDYyB0aGUgTVREIG1haW50YWluZXJzLCBu
b3Qgb25seSB0aGUgbGlzdCAoZ2V0X21haW50YWluZXJzLnBsKS4NCj4gPiANCj4gPiBJIGZpZ3Vy
ZSBhbGwgbWFpbnRhaW5lcnMgYXJlIG9uIHRoZSBsaXN0ID8NCj4gDQo+IEkgcGVyc29uYWxseSBk
b24ndCBsb29rIGF0IHRoZSBsaXN0IHZlcnkgb2Z0ZW4uIEkgZXhwZWN0IHBhdGNoZXMgdG8gYmUN
Cj4gZGlyZWN0ZWQgdG8gbWUgKGluIHRoZSBjdXJyZW50IGNhc2UsIFZpZ25lc2gpIHdoZW4gSSBh
bSBjb25jZXJuZWQuDQoNCkFkZGVkIFZpZ25lc2gNCg0KPiANCj4gPiANCj4gPiA+IA0KPiA+ID4g
Sm9ha2ltIFRqZXJubHVuZCA8am9ha2ltLnRqZXJubHVuZEBpbmZpbmVyYS5jb20+IHdyb3RlIG9u
IFRodSwgMjIgT2N0DQo+ID4gPiAyMDIwIDE3OjQ1OjA2ICswMjAwOg0KPiA+ID4gDQo+ID4gPiA+
IENvbW1pdCAibXRkOiBjZmlfY21kc2V0XzAwMDI6IEFkZCBzdXBwb3J0IGZvciBwb2xsaW5nIHN0
YXR1cyByZWdpc3RlciINCj4gPiA+ID4gYWRkZWQgc3VwcG9ydCBmb3IgcG9sbGluZyB0aGUgc3Rh
dHVzIHJhdGhlciB0aGFuIHVzaW5nIERRIHBvbGxpbmcuDQo+ID4gPiA+IEhvd2V2ZXIsIHN0YXR1
cyByZWdpc3RlciBpcyB1c2VkIG9ubHkgd2hlbiBEUSBwb2xsaW5nIGlzIG1pc3NpbmcuDQo+ID4g
PiA+IExldHMgdXNlIHN0YXR1cyByZWdpc3RlciB3aGVuIGF2YWlsYWJsZSBhcyBpdCBpcyBzdXBl
cmlvciB0byBEUSBwb2xsaW5nLg0KPiA+ID4gPiANCj4gPiA+IA0KPiA+ID4gSSB3aWxsIGxldCB2
aWduZXNoIGNvbW1lbnQgYWJvdXQgdGhlIGNvbnRlbnQgKGxvb2tzIGZpbmUgYnkgbWUpIGJ1dCB5
b3Ugd2lsbA0KPiA+ID4gbmVlZCBhIEZpeGVzIHRhZyBoZXJlLg0KPiA+IA0KPiA+IFRoaXMgaXMg
bm90IGEgRml4ZXMgc2l0dWF0aW9uLCBubyBidWcganVzdCBhIGh3IGVuYWJsaW5nIHRoaW5nLg0K
PiA+IEFsc28sIEkgd291bGQgbGlrZSB0byBzZWUgdGhlIFN0YXR1cyBwYXRjaGVzIGJlIGJhY2tw
b3J0ZWQgdG8gNC4xOSBhcyB3ZWxsLg0KPiANCj4gQmFja3BvcnRpbmcgZmVhdHVyZXMgaXMgSU1I
TyBub3QgcmVsZXZhbnQuIEkgZ3Vlc3Mgc3RhYmxlIGtlcm5lbCBvbmx5DQo+IHRha2UgZml4ZXMu
Li4NCg0KVGhpcyBpcyBub3QgYSBmZWF0dXJlIHJlYWxseSBhbmQgdGhlIDUuNCBzdGFibGUgZGlk
IGdldCB0aGVtLCBJIGFzayA0LjE5IGdldCB0aGVtIHRvby4NCg==

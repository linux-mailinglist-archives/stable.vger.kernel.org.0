Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA9016A73F
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 14:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgBXNYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 08:24:14 -0500
Received: from mail-zr0che01on2082.outbound.protection.outlook.com ([40.107.24.82]:6067
        "EHLO CHE01-ZR0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726806AbgBXNYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Feb 2020 08:24:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTIv878o3kFH2XIdbEAmKZRPnpAOCsc06wZkgaNOKKbk9YKiW53bGiM5v9YDoLZB4wSIPk+K2uLUUpC1juWD8knhgHk77BOiuzvkGkbbFs05bHlHSkKAxelB0FhKPuFOGNMByWN+quhLFpg1ZzyR0XOi636qZL5EGSzLJHC7Nyld8VctdWyWiXlhd4cdCsyrSgJLQjJY9UCbCNdthM2Y05Nt6rzSNa71VK2K87Td7YQ/MqxTH6lIziXXriMcAoerFPGDTByxzY2MQ6IpnVmtu0pmuFeaIUHtjiQ4EZd9/i9btWWSFQl1euuwD/M76JKuVDbQeg2b3PN168HUnouD1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jk4eTNpNZIfbp0rdXbzCwFI9tGksP4KNNfSvvK9vWks=;
 b=QRUVwqZo0A8E/Tg/+5AM1XD7EJmc3Abx+XrTyJH5piAU4JSlTMS+U+zVZAuqyzvgcOiOVf0SZZ3Vmpt4/SxiiG0JnK0AZQeWuoH8u591y3BTK4jS+nzPMXIBp8WYK6OrARpnbAYnZ1aSpujggl9qkXUAROYFzcxjVIUExVcKzAPtlYgYRh2KFMoZyFD3fWvnvNPAcdO3biGN3LKt3D1gXJ7yb2E6UCbGTWf7k8m0sO/PS2QnahVbQrAUD63etFokTmIG0YLhEs3E9fk20rbiCkZVhRbBiAptcs1ikRaNF7giuaJvaTBgd+hrpboj2kgcL0RDn0ryYRaZwwwMFIy/3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=onway.ch; dmarc=pass action=none header.from=onway.ch;
 dkim=pass header.d=onway.ch; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cloudguard.onmicrosoft.com; s=selector2-cloudguard-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jk4eTNpNZIfbp0rdXbzCwFI9tGksP4KNNfSvvK9vWks=;
 b=GNOTBd0KVSsya+8B1X1vUnuY+eatbLp86hpW5qqdxk/sNjinnx1+dqWPVOs+oJBRz6hy3ljoInxsnent7AZbi9LQ4m6IuxVbm2pXHGRYI5bHXlfGAjkLOj+J/nBDgnHM71uzpqN5HAmszIAv6tspTY/ZgaQQZWqsqph1gtgLfzY=
Received: from GV0P278MB0083.CHEP278.PROD.OUTLOOK.COM (10.186.181.138) by
 GV0P278MB0115.CHEP278.PROD.OUTLOOK.COM (10.186.181.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.18; Mon, 24 Feb 2020 13:24:05 +0000
Received: from GV0P278MB0083.CHEP278.PROD.OUTLOOK.COM
 ([fe80::58c6:b764:cf29:233d]) by GV0P278MB0083.CHEP278.PROD.OUTLOOK.COM
 ([fe80::58c6:b764:cf29:233d%3]) with mapi id 15.20.2750.021; Mon, 24 Feb 2020
 13:24:05 +0000
Received: from bohrium.local (185.12.128.225) by PR0P264CA0119.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Mon, 24 Feb 2020 13:24:04 +0000
From:   Andreas Tobler <andreas.tobler@onway.ch>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Robin Gong <yibin.gong@nxp.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 160/344] dmaengine: imx-sdma: Fix memory leak
Thread-Topic: [PATCH 5.4 160/344] dmaengine: imx-sdma: Fix memory leak
Thread-Index: AQHV6xWuKJPktnRSx0+cZ6Tsw+Vdsg==
Date:   Mon, 24 Feb 2020 13:24:04 +0000
Message-ID: <1429291b-77c5-41aa-8dee-8858eba6d138@onway.ch>
References: <20200221072349.335551332@linuxfoundation.org>
 <20200221072403.369335694@linuxfoundation.org>
In-Reply-To: <20200221072403.369335694@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0119.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::35) To GV0P278MB0083.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:1d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=andreas.tobler@onway.ch; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [185.12.128.225]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd81c0b1-f86a-421b-a4f6-08d7b92cd1e7
x-ms-traffictypediagnostic: GV0P278MB0115:
x-microsoft-antispam-prvs: <GV0P278MB0115C09F93B976B1F75BFFADF3EC0@GV0P278MB0115.CHEP278.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:291;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(42606007)(39830400003)(366004)(136003)(396003)(199004)(189003)(66616009)(66476007)(81156014)(6512007)(81166006)(8676002)(186003)(8936002)(66946007)(26005)(2906002)(6486002)(71200400001)(956004)(5660300002)(2616005)(52116002)(316002)(966005)(110136005)(16526019)(66446008)(66556008)(64756008)(36756003)(31696002)(6506007)(44832011)(53546011)(54906003)(86362001)(508600001)(31686004)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:GV0P278MB0115;H:GV0P278MB0083.CHEP278.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: onway.ch does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HSEV6VKc9yczXWLeg9XiT34/+omV7VcIaGPaWfyIPNAnyDH9ntPlvMgh79h9dnpljjN1pHv1ouKE9TjcN8tEXb7MmBOwJ4yXa9w7iMb6Krsh3tue+1WQB2z2BbY9SLqEbeUDDAazbwyN3CjTAnBeX/H1bWiScwxerENN5Cx6ybTEIzBD7Qm/Uh2m8mUIB5v1+T5SUK4p59od+80zhSVeJUpE5h55U/0ifTvG4WHXP5h2Ik4t/MY6JVWMMIoz8ukLxxzo8VcyzNV7o5TSYR2DvD7tIvHjsi1L/Bkx9+Kh5lpd1ZNWy5UnDTe6B3FLKocR+RmpDcsKdyZU+Ezf5+YAzofyum69pFM0y4Z7D5WYtmc7BnseIp2qgEFqvJfLfnlBAWhH2mjwMWqIM8YX5SFqtGprDoOe+2ScpV8ttxd7V5CpBn0I1wQBFTZOOMAX9mhJhkKyceRrhbTH3uQSakQQNFdiiEE8tA+S5/Ud8G5UOfWCQ7KGV+4el6wyZzysYuhj8wkyEB7OOdiLr/LXkwW6BQ==
x-ms-exchange-antispam-messagedata: ALP8AgmF5/vX4+XRoZHT5l8slDrD4Ws471AmFMf7g3RozTaRk8QRFaPgt6CqrDRk/7zfQoSgRcNg5dEhqhW6hpiemHOoroKtoOAFaW96x7s+6+mkBf2pN1YXFkt+sFGnCN4B15XZE1ix/LoNhzN1Mw==
x-ms-exchange-transport-forked: True
Content-Type: multipart/mixed;
        boundary="_002_1429291b77c541aa8dee8858eba6d138onwaych_"
MIME-Version: 1.0
X-OriginatorOrg: onway.ch
X-MS-Exchange-CrossTenant-Network-Message-Id: dd81c0b1-f86a-421b-a4f6-08d7b92cd1e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2020 13:24:04.9056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6609f251-fcb7-49e1-90a9-db1acfa508db
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aNUoptg6h8ucSG6fVSYoVg81tYCLO7xOTNGTMMJ1qn8BW/V3wrueXnHCtLeinRpZNd21IdaNqsLFkTnQLzzRMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV0P278MB0115
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--_002_1429291b77c541aa8dee8858eba6d138onwaych_
Content-Type: text/plain; charset="utf-8"
Content-ID: <465F8109E379994987CBF9857EAA0C40@CHEP278.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64

SGkgYWxsLA0KDQpPbiAyMS4wMi4yMCAwODozOSwgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0K
PiBGcm9tOiBTYXNjaGEgSGF1ZXIgPHMuaGF1ZXJAcGVuZ3V0cm9uaXguZGU+DQo+IA0KPiBbIFVw
c3RyZWFtIGNvbW1pdCAwMjkzOWNkMTY3MDk1ZjE2MzI4YTFiZDVjYWI1YTkwYjU1MDYwNmRmIF0N
Cj4gDQo+IFRoZSBjdXJyZW50IGRlc2NyaXB0b3IgaXMgbm90IG9uIGFueSBsaXN0IG9mIHRoZSB2
aXJ0dWFsIERNQSBjaGFubmVsLg0KPiBPbmNlIHNkbWFfdGVybWluYXRlX2FsbCgpIGlzIGNhbGxl
ZCB3aGVuIGEgZGVzY3JpcHRvciBpcyBjdXJyZW50bHkNCj4gaW4gZmxpZ2h0IHRoZW4gdGhpcyBv
bmUgaXMgZm9yZ290dGVuIHRvIGJlIGZyZWVkLiBXZSBoYXZlIHRvIGNhbGwNCj4gdmNoYW5fdGVy
bWluYXRlX3ZkZXNjKCkgb24gdGhpcyBkZXNjcmlwdG9yIHRvIHJlLWFkZCBpdCB0byB0aGUgbGlz
dHMuDQo+IE5vdyB0aGF0IHdlIGFsc28gZnJlZSB0aGUgY3VycmVudGx5IHJ1bm5pbmcgZGVzY3Jp
cHRvciB3ZSBjYW4gKGFuZA0KPiBhY3R1YWxseSBoYXZlIHRvKSByZW1vdmUgdGhlIGN1cnJlbnQg
ZGVzY3JpcHRvciBmcm9tIGl0cyBsaXN0IGFsc28NCj4gZm9yIHRoZSBjeWNsaWMgY2FzZS4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IFNhc2NoYSBIYXVlciA8cy5oYXVlckBwZW5ndXRyb25peC5kZT4N
Cj4gUmV2aWV3ZWQtYnk6IFJvYmluIEdvbmcgPHlpYmluLmdvbmdAbnhwLmNvbT4NCj4gVGVzdGVk
LWJ5OiBSb2JpbiBHb25nIDx5aWJpbi5nb25nQG54cC5jb20+DQo+IExpbms6IGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL3IvMjAxOTEyMTYxMDUzMjguMTUxOTgtMTAtcy5oYXVlckBwZW5ndXRyb25p
eC5kZQ0KPiBTaWduZWQtb2ZmLWJ5OiBWaW5vZCBLb3VsIDx2a291bEBrZXJuZWwub3JnPg0KPiBT
aWduZWQtb2ZmLWJ5OiBTYXNoYSBMZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiAg
IGRyaXZlcnMvZG1hL2lteC1zZG1hLmMgfCAxOSArKysrKysrKysrKy0tLS0tLS0tDQo+ICAgMSBm
aWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9kbWEvaW14LXNkbWEuYyBiL2RyaXZlcnMvZG1hL2lteC1zZG1hLmMN
Cj4gaW5kZXggYzI3ZTIwNmE3NjRjMy4uNjZmMWIyYWM1Y2RlNCAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9kbWEvaW14LXNkbWEuYw0KPiArKysgYi9kcml2ZXJzL2RtYS9pbXgtc2RtYS5jDQo+IEBA
IC03NjAsMTIgKzc2MCw4IEBAIHN0YXRpYyB2b2lkIHNkbWFfc3RhcnRfZGVzYyhzdHJ1Y3Qgc2Rt
YV9jaGFubmVsICpzZG1hYykNCj4gICAJCXJldHVybjsNCj4gICAJfQ0KPiAgIAlzZG1hYy0+ZGVz
YyA9IGRlc2MgPSB0b19zZG1hX2Rlc2MoJnZkLT50eCk7DQo+IC0JLyoNCj4gLQkgKiBEbyBub3Qg
ZGVsZXRlIHRoZSBub2RlIGluIGRlc2NfaXNzdWVkIGxpc3QgaW4gY3ljbGljIG1vZGUsIG90aGVy
d2lzZQ0KPiAtCSAqIHRoZSBkZXNjIGFsbG9jYXRlZCB3aWxsIG5ldmVyIGJlIGZyZWVkIGluIHZj
aGFuX2RtYV9kZXNjX2ZyZWVfbGlzdA0KPiAtCSAqLw0KPiAtCWlmICghKHNkbWFjLT5mbGFncyAm
IElNWF9ETUFfU0dfTE9PUCkpDQo+IC0JCWxpc3RfZGVsKCZ2ZC0+bm9kZSk7DQo+ICsNCj4gKwls
aXN0X2RlbCgmdmQtPm5vZGUpOw0KPiAgIA0KPiAgIAlzZG1hLT5jaGFubmVsX2NvbnRyb2xbY2hh
bm5lbF0uYmFzZV9iZF9wdHIgPSBkZXNjLT5iZF9waHlzOw0KPiAgIAlzZG1hLT5jaGFubmVsX2Nv
bnRyb2xbY2hhbm5lbF0uY3VycmVudF9iZF9wdHIgPSBkZXNjLT5iZF9waHlzOw0KPiBAQCAtMTA3
MSw3ICsxMDY3LDYgQEAgc3RhdGljIHZvaWQgc2RtYV9jaGFubmVsX3Rlcm1pbmF0ZV93b3JrKHN0
cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCj4gICANCj4gICAJc3Bpbl9sb2NrX2lycXNhdmUoJnNk
bWFjLT52Yy5sb2NrLCBmbGFncyk7DQo+ICAgCXZjaGFuX2dldF9hbGxfZGVzY3JpcHRvcnMoJnNk
bWFjLT52YywgJmhlYWQpOw0KPiAtCXNkbWFjLT5kZXNjID0gTlVMTDsNCj4gICAJc3Bpbl91bmxv
Y2tfaXJxcmVzdG9yZSgmc2RtYWMtPnZjLmxvY2ssIGZsYWdzKTsNCj4gICAJdmNoYW5fZG1hX2Rl
c2NfZnJlZV9saXN0KCZzZG1hYy0+dmMsICZoZWFkKTsNCj4gICAJc2RtYWMtPmNvbnRleHRfbG9h
ZGVkID0gZmFsc2U7DQo+IEBAIC0xMDgwLDExICsxMDc1LDE5IEBAIHN0YXRpYyB2b2lkIHNkbWFf
Y2hhbm5lbF90ZXJtaW5hdGVfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQo+ICAgc3Rh
dGljIGludCBzZG1hX2Rpc2FibGVfY2hhbm5lbF9hc3luYyhzdHJ1Y3QgZG1hX2NoYW4gKmNoYW4p
DQo+ICAgew0KPiAgIAlzdHJ1Y3Qgc2RtYV9jaGFubmVsICpzZG1hYyA9IHRvX3NkbWFfY2hhbihj
aGFuKTsNCj4gKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiArDQo+ICsJc3Bpbl9sb2NrX2lycXNh
dmUoJnNkbWFjLT52Yy5sb2NrLCBmbGFncyk7DQo+ICAgDQo+ICAgCXNkbWFfZGlzYWJsZV9jaGFu
bmVsKGNoYW4pOw0KPiAgIA0KPiAtCWlmIChzZG1hYy0+ZGVzYykNCj4gKwlpZiAoc2RtYWMtPmRl
c2MpIHsNCj4gKwkJdmNoYW5fdGVybWluYXRlX3ZkZXNjKCZzZG1hYy0+ZGVzYy0+dmQpOw0KPiAr
CQlzZG1hYy0+ZGVzYyA9IE5VTEw7DQo+ICAgCQlzY2hlZHVsZV93b3JrKCZzZG1hYy0+dGVybWlu
YXRlX3dvcmtlcik7DQo+ICsJfQ0KPiArDQo+ICsJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmc2Rt
YWMtPnZjLmxvY2ssIGZsYWdzKTsNCj4gICANCj4gICAJcmV0dXJuIDA7DQo+ICAgfQ0KPiANCg0K
VGhpcyBwYXRjaCBicmVha3Mgb3VyIGlteDYgYm9hcmQgd2l0aCB0aGUgYXR0YWNoZWQgdHJhY2Uu
ICBSZXZlcnRpbmcgdGhlIA0KcGF0Y2ggbWFrZXMgaXQgYm9vdCBhZ2Fpbi4NCkkgdHJpZWQgYWxz
byA1LjYtcmMzIGFuZCBpdCBib290ZWQgdG9vLiBBIGNsb3NlciBsb29rIGludG8gaW14LXNkbWEu
YyANCmZyb20gNS42LXJjMyBzaG93ZWQgbWUgc29tZSBkZXRhaWxzIHdoaWNoIG1pZ2h0IGhhdmUg
dG8gYmUgYmFja3BvcnRlZCBhcyANCndlbGwgdG8gbWFrZSB0aGlzIHBhdGNoIHdvcmsuDQpJIHRy
aWVkIGExZmY2YTA3ZjVhMzk1MWZjYWM4NGYwNjRhNzZkMWFkNzljMTBlNDAgYW5kIHdhcyBzb21l
aG93IA0Kc3VjY2Vzc2Z1bC4gSSBzdGlsbCBoYXZlIG9uZSB0cmFjZSBidXQgdGhlIGJvYXJkIGJv
b3RzIG5vdy4NCg0KQW55IGluc2lnaHRzIGZyb20gdGhlIGV4cGVydHM/DQpUSUEsDQpBbmRyZWFz
DQoNCg0KDQoNCg0K

--_002_1429291b77c541aa8dee8858eba6d138onwaych_
Content-Type: text/plain; name="trace_uart_sdma.txt"
Content-Description: trace_uart_sdma.txt
Content-Disposition: attachment; filename="trace_uart_sdma.txt"; size=2083;
	creation-date="Mon, 24 Feb 2020 13:24:04 GMT";
	modification-date="Mon, 24 Feb 2020 13:24:04 GMT"
Content-ID: <6678F70FF5EFDF438ABD80DFD6AE3755@CHEP278.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64

a2xvZzogLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tCmtsb2c6IFdBUk5JTkc6
IENQVTogMCBQSUQ6IDMwNyBhdCBrZXJuZWwvZG1hL21hcHBpbmcuYzozMzUgZG1hX2ZyZWVfYXR0
cnMrMHhjNC8weGM4Cmtsb2c6IE1vZHVsZXMgbGlua2VkIGluOiBuZl9kZWZyYWdfaXB2NAprbG9n
OiBDUFU6IDAgUElEOiAzMDcgQ29tbTogZ2luYSBOb3QgdGFpbnRlZCA1LjQuMjIgIzQKa2xvZzog
SGFyZHdhcmUgbmFtZTogRnJlZXNjYWxlIGkuTVg2IFF1YWQvRHVhbExpdGUgKERldmljZSBUcmVl
KQprbG9nOiBbPGMwMTEwMzI4Pl0gKHVud2luZF9iYWNrdHJhY2UpIGZyb20gWzxjMDEwYjdlYz5d
IChzaG93X3N0YWNrKzB4MTAvMHgxNCkKa2xvZzogWzxjMDEwYjdlYz5dIChzaG93X3N0YWNrKSBm
cm9tIFs8YzA4ZGQ3Zjg+XSAoZHVtcF9zdGFjaysweDkwLzB4YTQpCmtsb2c6IFs8YzA4ZGQ3Zjg+
XSAoZHVtcF9zdGFjaykgZnJvbSBbPGMwMTJiZWEwPl0gKF9fd2FybisweGJjLzB4ZDgpCmtsb2c6
IFs8YzAxMmJlYTA+XSAoX193YXJuKSBmcm9tIFs8YzAxMmJmMjA+XSAod2Fybl9zbG93cGF0aF9m
bXQrMHg2NC8weGM0KQprbG9nOiBbPGMwMTJiZjIwPl0gKHdhcm5fc2xvd3BhdGhfZm10KSBmcm9t
IFs8YzAxODFhNjg+XSAoZG1hX2ZyZWVfYXR0cnMrMHhjNC8weGM4KQprbG9nOiBbPGMwMTgxYTY4
Pl0gKGRtYV9mcmVlX2F0dHJzKSBmcm9tIFs8YzA0NjMxYzg+XSAoc2RtYV9mcmVlX2JkKzB4MzAv
MHgzOCkKa2xvZzogWzxjMDQ2MzFjOD5dIChzZG1hX2ZyZWVfYmQpIGZyb20gWzxjMDQ2MzFkYz5d
IChzZG1hX2Rlc2NfZnJlZSsweGMvMHgxOCkKa2xvZzogWzxjMDQ2MzFkYz5dIChzZG1hX2Rlc2Nf
ZnJlZSkgZnJvbSBbPGMwNDY0ZjcwPl0gKHNkbWFfY2hhbm5lbF9zeW5jaHJvbml6ZSsweDQ4LzB4
ODgpCmtsb2c6IFs8YzA0NjRmNzA+XSAoc2RtYV9jaGFubmVsX3N5bmNocm9uaXplKSBmcm9tIFs8
YzA0OTVmYWM+XSAoaW14X3VhcnRfc2h1dGRvd24rMHgxNmMvMHgyYTgpCmtsb2c6IFs8YzA0OTVm
YWM+XSAoaW14X3VhcnRfc2h1dGRvd24pIGZyb20gWzxjMDQ4NTdiOD5dICh1YXJ0X3BvcnRfc2h1
dGRvd24rMHgzNC8weDQwKQprbG9nOiBbPGMwNDg1N2I4Pl0gKHVhcnRfcG9ydF9zaHV0ZG93bikg
ZnJvbSBbPGMwNDg1ODE0Pl0gKHVhcnRfdHR5X3BvcnRfc2h1dGRvd24rMHg1MC8weGI4KQprbG9n
OiBbPGMwNDg1ODE0Pl0gKHVhcnRfdHR5X3BvcnRfc2h1dGRvd24pIGZyb20gWzxjMDQ4MTQ0Yz5d
ICh0dHlfcG9ydF9zaHV0ZG93bisweDkwLzB4OWMpCmtsb2c6IFs8YzA0ODE0NGM+XSAodHR5X3Bv
cnRfc2h1dGRvd24pIGZyb20gWzxjMDQ4MWMyYz5dICh0dHlfcG9ydF9jbG9zZSsweDNjLzB4NzQp
Cmtsb2c6IFs8YzA0ODFjMmM+XSAodHR5X3BvcnRfY2xvc2UpIGZyb20gWzxjMDQ3ODQ1OD5dICh0
dHlfcmVsZWFzZSsweGYwLzB4NDhjKQprbG9nOiBbPGMwNDc4NDU4Pl0gKHR0eV9yZWxlYXNlKSBm
cm9tIFs8YzAyNDI1ZWM+XSAoX19mcHV0KzB4ODgvMHgyMTgpCmtsb2c6IFs8YzAyNDI1ZWM+XSAo
X19mcHV0KSBmcm9tIFs8YzAxNDc3OTg+XSAodGFza193b3JrX3J1bisweGE0LzB4YzQpCmtsb2c6
IFs8YzAxNDc3OTg+XSAodGFza193b3JrX3J1bikgZnJvbSBbPGMwMTBiMzEwPl0gKGRvX3dvcmtf
cGVuZGluZysweDU1MC8weDU1YykKa2xvZzogWzxjMDEwYjMxMD5dIChkb193b3JrX3BlbmRpbmcp
IGZyb20gWzxjMDEwMTA2Yz5dIChzbG93X3dvcmtfcGVuZGluZysweGMvMHgyMCkKa2xvZzogRXhj
ZXB0aW9uIHN0YWNrKDB4ZWU3MjNmYjAgdG8gMHhlZTcyM2ZmOCkKa2xvZzogM2ZhMDogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMDAwMDAwMDAgMDAwMDU0MDIgYmVhNmFiNjQg
MDAwMDAwMDAKa2xvZzogM2ZjMDogMDAwMDAwMDAgYjZmMTI0ZDAgYmVhNmFiYTQgMDAwMDAwMDYg
MDAwMDAwMGQgMDAwMDAwMDEgMDAwODRmZjggMDAwMDAwMDAKa2xvZzogM2ZlMDogMDAwNDgyMmMg
YmVhNmFiODggMDAwMzQ3ODAgYjZkMDhjMzQgNjAwYjAwMTAgMDAwMDAwMDYKa2xvZzogLS0tWyBl
bmQgdHJhY2UgODZmZWE0ZTc0YTI2N2Y1NyBdLS0tCg==

--_002_1429291b77c541aa8dee8858eba6d138onwaych_--

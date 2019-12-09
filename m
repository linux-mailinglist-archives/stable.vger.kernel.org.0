Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6233B117379
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 19:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfLISHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 13:07:22 -0500
Received: from m4a0039g.houston.softwaregrp.com ([15.124.2.85]:41896 "EHLO
        m4a0039g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726342AbfLISHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 13:07:20 -0500
Received: FROM m4a0039g.houston.softwaregrp.com (15.120.17.146) BY m4a0039g.houston.softwaregrp.com WITH ESMTP;
 Mon,  9 Dec 2019 18:06:10 +0000
Received: from M9W0068.microfocus.com (2002:f79:bf::f79:bf) by
 M4W0334.microfocus.com (2002:f78:1192::f78:1192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Mon, 9 Dec 2019 18:05:44 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (15.124.72.14) by
 M9W0068.microfocus.com (15.121.0.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Mon, 9 Dec 2019 18:05:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8OMFJ/gs8r+cTSPMgwnBC2aZzt8g7iG0oTOeKzJ187hz+LKi1X/xiaHf8zHpcYRLdj42Y8onw7Pt2/eQJu/dQTGn+l7XeiPxbs6/OCyitBk9vENGZFcMV5eqHZiqwDc6DJVbx6RDlc76JjCRvqdt2r+kmgsJcGscvibimHA4YlAmIHptBCafES3g8w159tJqHpV7qUofxJh/zJu4ObPYuIyJx87s1z2XUjy/Kvee81hldXWiknVDc+9Mt74xQ4qT4uGOeBg6pxGDM43cZni7YPDQxNs0zunQBZDgDfvQyQb6E/Wi/yjnjJJFej3KODp4lwprlZSX/kED6yLsWbgkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+2cxs0ORETCRxv0jdd4irZF1UklkYxpMrLMp6D62I7U=;
 b=lZLM1ie9esCP7fPi70Eyv9tdILW/5IfbYjKOIzUsxafrGKUiw2TEU5YFb+OmFP4Kdj+kJemwqZKYCDAFxRSYr1w1qeGSwCPwgjOJt17/cQ2DfiNiJWftod+L70hhX1LUsEIbirVgD2KmdaHqGroz64aC25cDHbyz2qlUelo14YOmIZca0qo9OXF6bjrT27aMWKJiuCsdTh1d0aPirAH9mTypJT79f5547cPmlrL/cKloHTQ5BxG6wLaqGeKspyKVV2ZTOxZzvFbWDIol3PjRjxPEbr/+gptJ7E9hk+1t9yDLto1CysY/n6USApfPJFS4U2JRE+bRIevJdfzan2Pxpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (10.255.237.204) by
 MN2PR18MB3344.namprd18.prod.outlook.com (10.255.86.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Mon, 9 Dec 2019 18:05:41 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::2914:6699:d7e5:de45]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::2914:6699:d7e5:de45%3]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 18:05:41 +0000
From:   Lee Duncan <LDuncan@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Christoph Hellwig" <hch@lst.de>,
        Keith Busch <keith.busch@intel.com>,
        Chris Leech <cleech@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] iscsi: Fix a potential deadlock in the timeout handler
Thread-Topic: [PATCH] iscsi: Fix a potential deadlock in the timeout handler
Thread-Index: AQHVrrcBlB0UehsZYE+h9DghdG4TTqeyGRaA
Date:   Mon, 9 Dec 2019 18:05:41 +0000
Message-ID: <49adf8c8-d524-dfb8-1a2d-4daac7af50ad@suse.com>
References: <20191209173457.187370-1-bvanassche@acm.org>
In-Reply-To: <20191209173457.187370-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:300:6c::22) To MN2PR18MB3278.namprd18.prod.outlook.com
 (2603:10b6:208:168::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [73.25.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b190a53a-f155-4ca7-0ed4-08d77cd2671b
x-ms-traffictypediagnostic: MN2PR18MB3344:
x-microsoft-antispam-prvs: <MN2PR18MB3344F48E3452B1F7BDF1C93BDA580@MN2PR18MB3344.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(189003)(51234002)(199004)(66476007)(4326008)(229853002)(26005)(36756003)(64756008)(66446008)(66946007)(66556008)(71190400001)(305945005)(71200400001)(5660300002)(316002)(8676002)(81166006)(8936002)(81156014)(54906003)(2906002)(2616005)(31696002)(186003)(31686004)(53546011)(478600001)(6486002)(6512007)(6506007)(110136005)(86362001)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR18MB3344;H:MN2PR18MB3278.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qw7iGwqwS7Ki1/M/8zy1oZzxgkjjCDXK95JAevZJCQboo4c3ErXoOBouqGPnRXPmVeecUdrXwxiqCCIrr29gAtNzmjQImWyly8Zdi/rK0H16bfe/hovG1u0V1cVX8Y0NJltjl04/ApeJkh51Ref1OofKlfb0yJe+rEfEBGi1JKn9K4QGlAYNbb/SFP2qEHXZ8f0HgC4JSAAM20NOw8lnf5War4NblFte519egmueLg2eJ7ouexaY6EfHHzuj/mxgreWlgPNWbcizkot8En+u/zvCVQGOmO/D8pj7MElDSqEpVUj0PtxsSSZlxueLWlW8VlCQPr1MHHZrRmdMOH/EwEM0PJdl0saj+ovxxOsWwnj1wkrKc/54aumvH7iQHwfbasZKeVwBjM9pW+dfkj5ZIa2+fkkLXKyPWcUI0662AiKlOtEWJas3tspr2Q/5rwzZ+qzSxuGhNWnQA2SiJLogKgmDQYihVEMO9X5CnSYHFQw3uEcn2WXrahhTfnA3evXp
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7C256F448108241B62D00134858EC45@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b190a53a-f155-4ca7-0ed4-08d77cd2671b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 18:05:41.2416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TudzXXrzdwqMgbctszf0KBgTLL/qwQkHvCWY/bRIPH4XoRScJZJUaia3C09rT51je9kHCVHTuJYFrl47n3CZuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3344
X-OriginatorOrg: suse.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTIvOS8xOSA5OjM0IEFNLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+IFNvbWUgdGltZSBh
Z28gdGhlIGJsb2NrIGxheWVyIHdhcyBtb2RpZmllZCBzdWNoIHRoYXQgdGltZW91dCBoYW5kbGVy
cyBhcmUgY2FsbGVkDQo+IGZyb20gdGhyZWFkIGNvbnRleHQgaW5zdGVhZCBvZiBpbnRlcnJ1cHQg
Y29udGV4dC4gTWFrZSBpdCBzYWZlIHRvIHJ1biB0aGUgaVNDU0kNCj4gdGltZW91dCBoYW5kbGVy
IGluIHRocmVhZCBjb250ZXh0LiBUaGlzIHBhdGNoIGZpeGVzIHRoZSBmb2xsb3dpbmcgbG9ja2Rl
cA0KPiBjb21wbGFpbnQ6DQo+IA0KPiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0K
PiBXQVJOSU5HOiBpbmNvbnNpc3RlbnQgbG9jayBzdGF0ZQ0KPiA1LjUuMS1kYmcrICMxMSBOb3Qg
dGFpbnRlZA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBpbmNvbnNpc3Rl
bnQge0lOLVNPRlRJUlEtV30gLT4ge1NPRlRJUlEtT04tV30gdXNhZ2UuDQo+IGt3b3JrZXIvNzox
SC8yMDYgW0hDMFswXTpTQzBbMF06SEUxOlNFMV0gdGFrZXM6DQo+IGZmZmY4ODgwMmQ5ODI3ZTgg
KCYoJnNlc3Npb24tPmZyd2RfbG9jayktPnJsb2NrKXsrLj8ufSwgYXQ6IGlzY3NpX2VoX2NtZF90
aW1lZF9vdXQrMHhhNi8weDZkMCBbbGliaXNjc2ldDQo+IHtJTi1TT0ZUSVJRLVd9IHN0YXRlIHdh
cyByZWdpc3RlcmVkIGF0Og0KPiAgIGxvY2tfYWNxdWlyZSsweDEwNi8weDI0MA0KPiAgIF9yYXdf
c3Bpbl9sb2NrKzB4MzgvMHg1MA0KPiAgIGlzY3NpX2NoZWNrX3RyYW5zcG9ydF90aW1lb3V0cysw
eDNlLzB4MjEwIFtsaWJpc2NzaV0NCj4gICBjYWxsX3RpbWVyX2ZuKzB4MTMyLzB4NDcwDQo+ICAg
X19ydW5fdGltZXJzLnBhcnQuMCsweDM5Zi8weDViMA0KPiAgIHJ1bl90aW1lcl9zb2Z0aXJxKzB4
NjMvMHhjMA0KPiAgIF9fZG9fc29mdGlycSsweDEyZC8weDVmZA0KPiAgIGlycV9leGl0KzB4YjMv
MHgxMTANCj4gICBzbXBfYXBpY190aW1lcl9pbnRlcnJ1cHQrMHgxMzEvMHgzZDANCj4gICBhcGlj
X3RpbWVyX2ludGVycnVwdCsweGYvMHgyMA0KPiAgIGRlZmF1bHRfaWRsZSsweDMxLzB4MjMwDQo+
ICAgYXJjaF9jcHVfaWRsZSsweDEzLzB4MjANCj4gICBkZWZhdWx0X2lkbGVfY2FsbCsweDUzLzB4
NjANCj4gICBkb19pZGxlKzB4MzhhLzB4M2YwDQo+ICAgY3B1X3N0YXJ0dXBfZW50cnkrMHgyNC8w
eDMwDQo+ICAgc3RhcnRfc2Vjb25kYXJ5KzB4MjIyLzB4MjkwDQo+ICAgc2Vjb25kYXJ5X3N0YXJ0
dXBfNjQrMHhhNC8weGIwDQo+IGlycSBldmVudCBzdGFtcDogMTM4MzcwNQ0KPiBoYXJkaXJxcyBs
YXN0ICBlbmFibGVkIGF0ICgxMzgzNzA1KTogWzxmZmZmZmZmZjgxYWFjZTVjPl0gX3Jhd19zcGlu
X3VubG9ja19pcnErMHgyYy8weDUwDQo+IGhhcmRpcnFzIGxhc3QgZGlzYWJsZWQgYXQgKDEzODM3
MDQpOiBbPGZmZmZmZmZmODFhYWNiOTg+XSBfcmF3X3NwaW5fbG9ja19pcnErMHgxOC8weDUwDQo+
IHNvZnRpcnFzIGxhc3QgIGVuYWJsZWQgYXQgKDEzODM2OTApOiBbPGZmZmZmZmZmYTBlMmVmZWE+
XSBpc2NzaV9xdWV1ZWNvbW1hbmQrMHg3NmEvMHhhMjAgW2xpYmlzY3NpXQ0KPiBzb2Z0aXJxcyBs
YXN0IGRpc2FibGVkIGF0ICgxMzgzNjgyKTogWzxmZmZmZmZmZmEwZTJlOTk4Pl0gaXNjc2lfcXVl
dWVjb21tYW5kKzB4MTE4LzB4YTIwIFtsaWJpc2NzaV0NCj4gDQo+IG90aGVyIGluZm8gdGhhdCBt
aWdodCBoZWxwIHVzIGRlYnVnIHRoaXM6DQo+ICBQb3NzaWJsZSB1bnNhZmUgbG9ja2luZyBzY2Vu
YXJpbzoNCj4gDQo+ICAgICAgICBDUFUwDQo+ICAgICAgICAtLS0tDQo+ICAgbG9jaygmKCZzZXNz
aW9uLT5mcndkX2xvY2spLT5ybG9jayk7DQo+ICAgPEludGVycnVwdD4NCj4gICAgIGxvY2soJigm
c2Vzc2lvbi0+ZnJ3ZF9sb2NrKS0+cmxvY2spOw0KPiANCj4gICoqKiBERUFETE9DSyAqKioNCj4g
DQo+IDIgbG9ja3MgaGVsZCBieSBrd29ya2VyLzc6MUgvMjA2Og0KPiAgIzA6IGZmZmY4ODgwZDU3
YmY5MjggKCh3cV9jb21wbGV0aW9uKWtibG9ja2QpeysuKy59LCBhdDogcHJvY2Vzc19vbmVfd29y
aysweDQ3Mi8weGFiMA0KPiAgIzE6IGZmZmY4ODgwMmI5YzdkZTggKCh3b3JrX2NvbXBsZXRpb24p
KCZxLT50aW1lb3V0X3dvcmspKXsrLisufSwgYXQ6IHByb2Nlc3Nfb25lX3dvcmsrMHg0NzYvMHhh
YjANCj4gDQo+IHN0YWNrIGJhY2t0cmFjZToNCj4gQ1BVOiA3IFBJRDogMjA2IENvbW06IGt3b3Jr
ZXIvNzoxSCBOb3QgdGFpbnRlZCA1LjUuMS1kYmcrICMxMQ0KPiBIYXJkd2FyZSBuYW1lOiBCb2No
cyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExDQo+IFdvcmtxdWV1ZToga2Jsb2NrZCBibGtf
bXFfdGltZW91dF93b3JrDQo+IENhbGwgVHJhY2U6DQo+ICBkdW1wX3N0YWNrKzB4YTUvMHhlNg0K
PiAgcHJpbnRfdXNhZ2VfYnVnLmNvbGQrMHgyMzIvMHgyM2INCj4gIG1hcmtfbG9jaysweDhkYy8w
eGE3MA0KPiAgX19sb2NrX2FjcXVpcmUrMHhjZWEvMHgyYWYwDQo+ICBsb2NrX2FjcXVpcmUrMHgx
MDYvMHgyNDANCj4gIF9yYXdfc3Bpbl9sb2NrKzB4MzgvMHg1MA0KPiAgaXNjc2lfZWhfY21kX3Rp
bWVkX291dCsweGE2LzB4NmQwIFtsaWJpc2NzaV0NCj4gIHNjc2lfdGltZXNfb3V0KzB4ZjQvMHg0
NDAgW3Njc2lfbW9kXQ0KPiAgc2NzaV90aW1lb3V0KzB4MWQvMHgyMCBbc2NzaV9tb2RdDQo+ICBi
bGtfbXFfY2hlY2tfZXhwaXJlZCsweDM2NS8weDNhMA0KPiAgYnRfaXRlcisweGQ2LzB4ZjANCj4g
IGJsa19tcV9xdWV1ZV90YWdfYnVzeV9pdGVyKzB4M2RlLzB4NjUwDQo+ICBibGtfbXFfdGltZW91
dF93b3JrKzB4MWFmLzB4MzgwDQo+ICBwcm9jZXNzX29uZV93b3JrKzB4NTZkLzB4YWIwDQo+ICB3
b3JrZXJfdGhyZWFkKzB4N2EvMHg1ZDANCj4gIGt0aHJlYWQrMHgxYmMvMHgyMTANCj4gIHJldF9m
cm9tX2ZvcmsrMHgyNC8weDMwDQo+IA0KPiBDYzogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3Qu
ZGU+DQo+IENjOiBLZWl0aCBCdXNjaCA8a2VpdGguYnVzY2hAaW50ZWwuY29tPg0KPiBDYzogTGVl
IER1bmNhbiA8bGR1bmNhbkBzdXNlLmNvbT4NCj4gQ2M6IENocmlzIExlZWNoIDxjbGVlY2hAcmVk
aGF0LmNvbT4NCj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiBGaXhlczogMjg3OTIy
ZWIwYjE4ICgiYmxvY2s6IGRlZmVyIHRpbWVvdXRzIHRvIGEgd29ya3F1ZXVlIikNCj4gU2lnbmVk
LW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IC0tLQ0KPiAg
ZHJpdmVycy9zY3NpL2xpYmlzY3NpLmMgfCA0ICsrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGlu
c2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
Y3NpL2xpYmlzY3NpLmMgYi9kcml2ZXJzL3Njc2kvbGliaXNjc2kuYw0KPiBpbmRleCBlYmQ0N2Mw
Y2Y5ZTkuLjcwYjk5YzBlMmU2NyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL2xpYmlzY3Np
LmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL2xpYmlzY3NpLmMNCj4gQEAgLTE5NDUsNyArMTk0NSw3
IEBAIGVudW0gYmxrX2VoX3RpbWVyX3JldHVybiBpc2NzaV9laF9jbWRfdGltZWRfb3V0KHN0cnVj
dCBzY3NpX2NtbmQgKnNjKQ0KPiAgDQo+ICAJSVNDU0lfREJHX0VIKHNlc3Npb24sICJzY3NpIGNt
ZCAlcCB0aW1lZG91dFxuIiwgc2MpOw0KPiAgDQo+IC0Jc3Bpbl9sb2NrKCZzZXNzaW9uLT5mcndk
X2xvY2spOw0KPiArCXNwaW5fbG9ja19iaCgmc2Vzc2lvbi0+ZnJ3ZF9sb2NrKTsNCj4gIAl0YXNr
ID0gKHN0cnVjdCBpc2NzaV90YXNrICopc2MtPlNDcC5wdHI7DQo+ICAJaWYgKCF0YXNrKSB7DQo+
ICAJCS8qDQo+IEBAIC0yMDcyLDcgKzIwNzIsNyBAQCBlbnVtIGJsa19laF90aW1lcl9yZXR1cm4g
aXNjc2lfZWhfY21kX3RpbWVkX291dChzdHJ1Y3Qgc2NzaV9jbW5kICpzYykNCj4gIGRvbmU6DQo+
ICAJaWYgKHRhc2spDQo+ICAJCXRhc2stPmxhc3RfdGltZW91dCA9IGppZmZpZXM7DQo+IC0Jc3Bp
bl91bmxvY2soJnNlc3Npb24tPmZyd2RfbG9jayk7DQo+ICsJc3Bpbl91bmxvY2tfYmgoJnNlc3Np
b24tPmZyd2RfbG9jayk7DQo+ICAJSVNDU0lfREJHX0VIKHNlc3Npb24sICJyZXR1cm4gJXNcbiIs
IHJjID09IEJMS19FSF9SRVNFVF9USU1FUiA/DQo+ICAJCSAgICAgInRpbWVyIHJlc2V0IiA6ICJz
aHV0ZG93biBvciBuaCIpOw0KPiAgCXJldHVybiByYzsNCj4gDQoNClJldmlld2VkLWJ5OiBMZWUg
RHVuY2FuIDxsZHVuY2FuQHN1c2UuY29tPg0K

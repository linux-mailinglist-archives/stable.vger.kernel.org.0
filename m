Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4216BB94EA
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 18:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389239AbfITQG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 12:06:57 -0400
Received: from mail-eopbgr150122.outbound.protection.outlook.com ([40.107.15.122]:6114
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387662AbfITQG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 12:06:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQ4H3KJG0Y9tK5WOU8dlSfdFlvHxB/d0KbN0rau9FsHdmOPBsigLwAT3kR0Fnk5cqRMb6K5bMO0Tg1wEd149zu9zophhxb12PYvPEKnPBuhHlgwdlAyMuIXFKiT9nE59GVYID1IjmmC78gtkm/zglX8DxR0IiuuXohn+pYAaJfOTaSwf4LuJYC/6c1ujnCKx+Ya5EiJakdDO3OKB8jXmA3f+B3rzW3EZAh/Fi13d89L76OeWtYBN+xIWJr7WkQWlMKElVLSwjKHrXcedWBHVAk4wgtF5qxlNRN2xu2IFDgyiiVofJ9lUqSxPCb1yBIzobmRLnjBUrXdT6GMMZ4CXKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDHyRECkfl6Z3yxsXzeLa9SGV52d6woTAeLZjHLpKiM=;
 b=jgxjiQOm0+meNFgvCpRGIfD51EJgfJE7KYMFNy/3nHwx7tS0c4lpG2x2E9fOTNCp4pYXQDCyi+jp/ea4BLVIKsJkiZxpnU0+j/LU2Nf0lTVbKlTeLm6VToTY4SDWdTMdXGNNwBGAoYyy4QRYi2k6ZyLdJX1tPN/xHKVdpQ7x3zLZsnnuIFnMHz2ryrADTlUbyIK9DiK5YJtoAdkPqntsPPl1OuYMnspARBpksTpK9mV3FrauXvBxaje1zh62bOzesyA64wy07NHgzgQzBvQqHvQaV0+mLX4+IF/v6Oggpqdb+U50vlk6Fr2Kgl/2lnBbKi0KI6iCRpGmqoauPKfZmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDHyRECkfl6Z3yxsXzeLa9SGV52d6woTAeLZjHLpKiM=;
 b=FmxUwH0zFQ2/YJEUuAd7J++4HKiAZ6WKiWzIcMGy7bRgYJpTDJvUstcEsF5z9k1tPPvY3WoLoJBO5yi4/4fNaOjVxlLPAbTKNfoDVMY97xaceX7AoCjcwN8wi2abowQbOG73zmhgNvWJwYfzXXurMX1lmTUkY4p0iT5sUh4pv1s=
Received: from AM6PR0702MB3527.eurprd07.prod.outlook.com (52.133.24.149) by
 AM6PR0702MB3526.eurprd07.prod.outlook.com (52.133.25.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.18; Fri, 20 Sep 2019 16:06:14 +0000
Received: from AM6PR0702MB3527.eurprd07.prod.outlook.com
 ([fe80::892c:2b90:e54f:ab56]) by AM6PR0702MB3527.eurprd07.prod.outlook.com
 ([fe80::892c:2b90:e54f:ab56%3]) with mapi id 15.20.2284.009; Fri, 20 Sep 2019
 16:06:13 +0000
From:   "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
To:     Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC:     Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        "Glavinic-Pecotic, Matija (EXT - DE/Ulm)" 
        <matija.glavinic-pecotic.ext@nokia.com>,
        "Adamski, Krzysztof (Nokia - PL/Wroclaw)" 
        <krzysztof.adamski@nokia.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/3] genirq/irqdomain: Re-check mapping after associate in
 irq_create_mapping()
Thread-Topic: [PATCH 2/3] genirq/irqdomain: Re-check mapping after associate
 in irq_create_mapping()
Thread-Index: AQHVaU6gP0yvNptpJkyGgiCIhPQf3ac0xDyAgAADyIA=
Date:   Fri, 20 Sep 2019 16:06:12 +0000
Message-ID: <cb31d8a4-2a4c-9de1-d89e-074d65efe77c@nokia.com>
References: <20190912094343.5480-1-alexander.sverdlin@nokia.com>
 <20190912094343.5480-3-alexander.sverdlin@nokia.com>
 <2c02b9d5-2394-7dcb-ee89-9950c6071dd1@kernel.org>
In-Reply-To: <2c02b9d5-2394-7dcb-ee89-9950c6071dd1@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.228.32.167]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
x-clientproxiedby: HE1PR05CA0241.eurprd05.prod.outlook.com
 (2603:10a6:3:fb::17) To AM6PR0702MB3527.eurprd07.prod.outlook.com
 (2603:10a6:209:11::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db4bad02-5829-4969-189e-08d73de47568
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR0702MB3526;
x-ms-traffictypediagnostic: AM6PR0702MB3526:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0702MB35262DB27CC6E68B1D5D0AF188880@AM6PR0702MB3526.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(189003)(199004)(110136005)(7736002)(305945005)(66066001)(6436002)(65956001)(6246003)(5660300002)(65806001)(3846002)(478600001)(71190400001)(71200400001)(36756003)(6116002)(26005)(476003)(2616005)(11346002)(446003)(186003)(52116002)(99286004)(256004)(76176011)(53546011)(102836004)(6506007)(386003)(2501003)(31686004)(54906003)(6486002)(229853002)(6512007)(58126008)(14454004)(25786009)(486006)(66556008)(64756008)(66446008)(2906002)(14444005)(66476007)(66946007)(31696002)(81156014)(316002)(81166006)(8676002)(8936002)(86362001)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR0702MB3526;H:AM6PR0702MB3527.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: j9gY6utnzMh+NTi2e2EaQqN8/KhnEnVPSyl3XkMqcN3vu8zuVn+5vNrZUyAw8uSwzvOtV3P2N4iDqp5mVy6EPbc79laZUK0pHZPamXk4M7L5zyLxo604f22foYFR1jMH03a7yUPVv1Mu9ef96GtWx4AQD24+b/Al2LyweVufPjqV0Rs7FQ0g0xVXE7ooH8LMLwDxsqOl7ipOsENWCpFSLVcx38dTAE3TiEjqAvBqluEEr+vG7uEqS9HiV5+GnNXtNuMWXId63X3VeRx9tNXhkxgZpbzLvCOY5o1ARQVVUvf7zIrauvPxeG35d79PY8e+vNnvhYy2R02NHps9utK7QEmxPAReNmruixzLSoePFl2O5PX+FO5T4hLnUsiga4LC3NcUC5muZVk0+7MRNUWafz4AE+fGRBJ2nBWmxX0Im6g=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D69900438B514847878022F57E045081@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db4bad02-5829-4969-189e-08d73de47568
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 16:06:12.9667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: odwhli7jyFEMmjefXdkI0rYo59PjZSiY+85YsAZV+0ICmq8BhT4+Q+iMzk6kNZXUBh0ny+2XwdrWBa4IkeLTFwqQaSRuMpID00DLV0WIrAg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0702MB3526
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgTWFyYywNCg0KT24gMjAvMDkvMjAxOSAxNzo1MiwgTWFyYyBaeW5naWVyIHdyb3RlOg0KPj4g
SWYgdHdvIGlycV9jcmVhdGVfbWFwcGluZygpIGNhbGxzIHBlcmZvcm0gYSBtYXBwaW5nIG9mIHRo
ZSBzYW1lIGh3aXJxIG9uDQo+PiB0d28gQ1BVIGNvcmVzIGluIHBhcmFsbGVsIHRoZXkgYm90aCB3
aWxsIGdldCAwIGZyb20gaXJxX2ZpbmRfbWFwcGluZygpLA0KPj4gYm90aCB3aWxsIGFsbG9jYXRl
IHVuaXF1ZSB2aXJxIHVzaW5nIGlycV9kb21haW5fYWxsb2NfZGVzY3MoKSBhbmQgYm90aA0KPj4g
d2lsbCBmaW5hbGx5IGlycV9kb21haW5fYXNzb2NpYXRlKCkgaXQuIEdpdmluZyBkaWZmZXJlbnQg
dmlycSBudW1iZXJzDQo+PiB0byB0aGVpciBjYWxsZXJzLg0KPj4NCj4+IEluIHByYWN0aWNlIHRo
ZSBmaXJzdCBjYWxsZXIgaXMgdXN1YWxseSBhbiBpbnRlcnJ1cHQgY29udHJvbGxlciBkcml2ZXIg
YW5kDQo+PiB0aGUgc2Vjb25kcyBpcyBzb21lIGRldmljZSByZXF1ZXN0aW5nIHRoZSBpbnRlcnJ1
cHQgcHJvdmlkZWRlIGJ5IHRoZSBhYm92ZQ0KPj4gaW50ZXJydXB0IGNvbnRyb2xsZXIuDQo+IEkg
ZGlzYWdyZWUgd2l0aCB0aGlzICJJbiBwcmFjdGljZSIuIEFuIGlycWNoaXAgY29udHJvbGxlciBz
aG91bGQgKnZlcnkNCj4gcmFyZWx5KiBjYWxsIGlycV9jcmVhdGVfbWFwcGluZyBvbiBpdHMgb3du
LiBJdCB1c3VhbGx5IGluZGljYXRlcyBzb21lDQo+IGxldmVsIG9mIGJyb2tlbm5lc3MsIHVubGVz
cyB0aGUgbWFwcGVkIGludGVycnVwdCBpcyBleHBvc2VkIGJ5IHRoZQ0KPiBpcnFjaGlwIGl0c2Vs
ZiAodGhlIEdJQyBtYWludGVuYW5jZSBpbnRlcnJ1cHQsIGZvciBleGFtcGxlKS4NCg0KSSBhbHNv
IGRpZG4ndCB1bmRlcnN0YW5kIHRoZSByZWFzb24gdGhlIGlycWNoaXAgaW4gcXVlc3Rpb24gY2Fs
bHMNCmlycV9jcmVhdGVfbWFwcGluZygpLCBidXQgYXMgOSB1cHN0cmVhbSBpcnFjaGlwcyBkbyB0
aGlzIGFzIHdlbGwgSSB3YXMNCm5vdCByZWFsbHkgaW50ZXJlc3RlZCBpbiB0aGUgcmVhc29ucyBm
b3IgdGhpcy4NCg0KPj4gSW4gdGhpcyBjYXNlIGVpdGhlciB0aGUgaW50ZXJydXB0IGNvbnRyb2xs
ZXIgZHJpdmVyIGNvbmZpZ3VyZXMgdmlycSB3aGljaA0KPj4gaXMgbm90IHRoZSBvbmUgYmVpbmcg
ImFzc29jaWF0ZWQiIHdpdGggaHdpcnEsIG9yIHRoZSAic2xhdmUiIGRldmljZQ0KPj4gcmVxdWVz
dHMgdGhlIHZpcnEgd2hpY2ggaXMgbmV2ZXIgYmVpbmcgdHJpZ2dlcmVkLg0KPiBXaHkgc2hvdWxk
IHRoZSBpbnRlcnJ1cHQgY29udHJvbGxlciBjb25maWd1cmUgdGhhdCBpbnRlcnJ1cHQ/IE9uIGFu
eQ0KPiBzYW5lIHBsYXRmb3JtLCB0aGUgbWFwcGluZyBzaG91bGQgYmUgY3JlYXRlZCBieSB0aGUg
dXNlciBvZiB0aGUNCj4gaW50ZXJydXB0LCBhbmQgbm90IGJ5IHRoZSBwcm92aWRlci4NCj4gDQo+
IFRoaXMgZG9lc24ndCBtZWFuIHdlIHNob3VsZG4ndCBmaXggdGhlIGlycWRvbWFpbiByYWNlcywg
YnV0IEkgdGVuZCB0bw0KPiBkaXNhZ3JlZSB3aXRoIHRoZSBhbmFseXNpcyBoZXJlLg0KDQpUaGF0
J3MgaW4gZmFjdCB3aGF0IGhhcHBlbnMgaW4gb3VyIGNhc2UgYW5kIG1heSBoYXBwZW4gd2l0aCA5
IHVwc3RyZWFtDQppcnFjaGlwcyBhcyB3ZWxsLiBTYW1lIHJhY2Ugd291bGQgaG93ZXZlciBoYXBw
ZW4gd2l0aCBhbnkgSVJRIGNsaWVudA0KZHJpdmVyIGNhbGxpbmcgb2ZfaXJxX2dldCgpLCBpZiB0
aGV5IHNoYXJlIHNhbWUgSFcgSVJRIGxpbmUuDQoNCi0tIA0KQmVzdCByZWdhcmRzLA0KQWxleGFu
ZGVyIFN2ZXJkbGluLg0K

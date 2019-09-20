Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96284B9503
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 18:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392042AbfITQOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 12:14:16 -0400
Received: from mail-eopbgr50109.outbound.protection.outlook.com ([40.107.5.109]:1926
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388473AbfITQOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 12:14:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nj1CXZf5FeuzIJLQdnUkYqGu8zw6h0omyl6/J4ZI5y9btf2b/Yp4YHRThNubXjwO3DvTW5CN14xKscSc9ZZFcIjfSB/un063rxzpNBnehweTQlJYw7+MSft5BGpPxGrOJ5alImQwa91YiqbOr1ZOPs3L7SurkI578s4/ug0Z6XDz8s7c4mL/e3NALg6TVzRVljd0Q0U10M3bg9/1akiHMutGnTA3gksyjkZsybqUF2RXepwylgwkQGoiovbRErOR08z9yZq4F3Gj4UFhzreugf/Sdo3xSHDK4oqKSioqFifjMndj8Z0258IESisjYoyhMuWomj9s6gpZQXsMhTLPzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+4Bh2ybJkFMdS6p2FgiVBrSvTxmmSFZY39CoLCdlnA=;
 b=OWwlYLRQplYUbxpxkTfeoYpdiELPjnatpJr0t7OysU4GE6GDBOOztJjkaJgKRNwwkdQSDran1BurcaTLGDb38HQ7y34HIWnjYKuiT9UW74Zl+tlY4lp+HbP0QUsy9K5jVPva2RScd4QbT4Linn5sn47G4GgYwqS0E0JJP8zbs9gK5EPVKkWwA0yI8XFaHOKzttqzX7O6najwuS9j9U6eX8cysfgo5GklTtfI95xVuoOgpz3pVdRHv6I+2yC+aOqUt7RSIyRiT7UGE2h3FmsVqIGZZK+3CdnW3Sq7TqbmMze+ZifvyOpD3H3b1FzNmPI/EsuPZn8Nu/32SWChCrfIwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+4Bh2ybJkFMdS6p2FgiVBrSvTxmmSFZY39CoLCdlnA=;
 b=KUj/mG6bpk2wFlM3g8V7PWZf7Z2Djnwq0W/QjE1WPn7f8NdywigQHPiJoJAA10VCbVgb13TTUPnytI/xcXcAQq9vqq6lUAcaG6pc+aILMFbX83brqrnDO5ZYcE1oOzJdG6TLG4PFYDvU48F6yRrTovt43bqfQIzhBWKEVqZjP8A=
Received: from AM6PR0702MB3527.eurprd07.prod.outlook.com (52.133.24.149) by
 AM6PR0702MB3605.eurprd07.prod.outlook.com (52.133.20.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.17; Fri, 20 Sep 2019 16:14:12 +0000
Received: from AM6PR0702MB3527.eurprd07.prod.outlook.com
 ([fe80::892c:2b90:e54f:ab56]) by AM6PR0702MB3527.eurprd07.prod.outlook.com
 ([fe80::892c:2b90:e54f:ab56%3]) with mapi id 15.20.2284.009; Fri, 20 Sep 2019
 16:14:12 +0000
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
Subject: Re: [PATCH 3/3] genirq/irqdomain: Detect type race in
 irq_create_fwspec_mapping()
Thread-Topic: [PATCH 3/3] genirq/irqdomain: Detect type race in
 irq_create_fwspec_mapping()
Thread-Index: AQHVaU6gc4wd5DvxjEeG+LE441tLCKc0yF8AgAAB4AA=
Date:   Fri, 20 Sep 2019 16:14:11 +0000
Message-ID: <f3092af0-b354-b8cb-7c07-b874c2dd909f@nokia.com>
References: <20190912094343.5480-1-alexander.sverdlin@nokia.com>
 <20190912094343.5480-4-alexander.sverdlin@nokia.com>
 <e86441c4-9ce2-b0f2-f8ca-2823497b4d6d@kernel.org>
In-Reply-To: <e86441c4-9ce2-b0f2-f8ca-2823497b4d6d@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.228.32.166]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
x-clientproxiedby: HE1PR05CA0193.eurprd05.prod.outlook.com
 (2603:10a6:3:f9::17) To AM6PR0702MB3527.eurprd07.prod.outlook.com
 (2603:10a6:209:11::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89be7f80-18a8-4727-94b7-08d73de592ed
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR0702MB3605;
x-ms-traffictypediagnostic: AM6PR0702MB3605:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0702MB3605A8D18B471A2359EFFDF588880@AM6PR0702MB3605.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(189003)(199004)(14444005)(54906003)(5660300002)(4326008)(53546011)(305945005)(6246003)(66946007)(110136005)(31686004)(229853002)(6486002)(316002)(6512007)(256004)(14454004)(36756003)(71190400001)(71200400001)(6436002)(58126008)(31696002)(25786009)(2906002)(99286004)(66446008)(65806001)(478600001)(3846002)(52116002)(446003)(86362001)(11346002)(26005)(8936002)(8676002)(81166006)(66066001)(2616005)(76176011)(486006)(7736002)(476003)(66476007)(6506007)(386003)(65956001)(66556008)(64756008)(186003)(2501003)(102836004)(6116002)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR0702MB3605;H:AM6PR0702MB3527.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: V5/DJOPOnyRCQ51zTMezhJxJhgS6cdRw0GJGx6Jw187DJ28ibH3jJl9mKi+ijtYrX+vWonl9zqLb7ldh6xiE1dmn0+b6AGiWEO1fClJw2agLq0lqOkyLxzTnJ6WeZkkVyMGS19pcoVAehRW8W5ZniEBUGY78L4DkOGJPdgt21QN5ZoCt2TMSFDFKiVGj4EoiW9ZZ3NBQTzN9RW5BXBq7anK92VCAcptyilam7WlMusXFN0Oy9nnhnXAEWjVk/SA5WUBMYmnx5zwrrhy8bnJV4j0XT563VvRaBsEOuzYsMv4RYLhgjJHUNitvikNwJpqErkmYW2FedleZPicHMqBhYLn1kpTYBz5/FAsOfyMVdCNI+0Dd54URnPoPgQ0OiV6UBLpTOLU1s0vF9fmcdf7QR8NLJyHTpuCHQH52KubpehM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <10F9AF03540D2049B1A9119B56583365@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89be7f80-18a8-4727-94b7-08d73de592ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 16:14:11.9802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7oP78RRKgI+UQ8I8sifiOlc2P4LTbE5G6rPtIfldnHkrIB2A/BHkXdd3ZBPkJrSxyZVr7P7aEsevmb6kaVFm+L/Cqvh+7VN8IzZwo0B0c18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0702MB3605
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkhDQoNCk9uIDIwLzA5LzIwMTkgMTg6MDcsIE1hcmMgWnluZ2llciB3cm90ZToNCj4+IGlycV9j
cmVhdGVfZndzcGVjX21hcHBpbmcoKSBjYW4gcmFjZSB3aXRoIGl0c2VsZiBkdXJpbmcgSVJRIHRy
aWdnZXIgdHlwZQ0KPj4gY29uZmlndXJhdGlvbi4gUG9zc2libGUgc2NlbmFyaW9zIGluY2x1ZGU6
DQo+Pg0KPj4gLSBNYXBwaW5nIGV4aXN0cywgdHdvIGlycV9jcmVhdGVfZndzcGVjX21hcHBpbmco
KSBydW5uaW5nIGluIHBhcmFsbGVsIGRvDQo+PiAgIG5vdCBkZXRlY3QgdHlwZSBtaXNtYXRjaCwg
SVJRIHJlbWFpbnMgY29uZmlndXJlZCB3aXRoIG9uZSBvZiB0aGUNCj4+ICAgZGlmZmVyZW50IHRy
aWdnZXIgdHlwZXMgcmFuZG9tbHkNCj4+IC0gU2Vjb25kIGNhbGwgdG8gaXJxX2NyZWF0ZV9md3Nw
ZWNfbWFwcGluZygpIHNlZXMgZXhpc3RpbmcgbWFwcGluZyBqdXN0DQo+PiAgIGNyZWF0ZWQgYnkg
Zmlyc3QgY2FsbCwgYnV0IGVhcmxpZXIgaXJxZF9zZXRfdHJpZ2dlcl90eXBlKCkgY2FsbCByYWNl
cw0KPj4gICB3aXRoIGxhdGVyIGlycWRfc2V0X3RyaWdnZXJfdHlwZSgpID0+IHRvdGFsbHkgdW5k
ZXRlY3RlZCwgSVJRIHR5cGUNCj4+ICAgaXMgYmVpbmcgc2V0IHJhbmRvbWx5IHRvIGVpdGhlciBv
bmUgb3IgYW5vdGhlciB0eXBlDQo+IElzIHRoYXQgYW4gYWN0dWFsIHRoaW5nPyBGcmFua2x5LCB0
aGUgc2NlbmFyaW8geW91J3JlIGRlc2NyaWJpbmcgaGVyZQ0KPiBzZWVtcyB0byBjYXJyeSB0aGUg
aGFsbG1hcmtzIG9mIGEgY29tcGxldGVseSBicm9rZW4gc3lzdGVtLiBDYW4geW91DQo+IHBvaW50
IGF0IGEgc3lzdGVtIHN1cHBvcnRlZCBpbiBtYWlubGluZSB0aGF0IHdvdWxkIGJlaGF2ZSBhcyBz
dWNoPw0KDQpCcmllZmx5IHNwZWFraW5nLCB0aGlzIHJhY2UgaXMgYWJvdXQgbm90LWNvbXBsYWlu
aW5nIGluIGNhc2Ugb2YgYSBicm9rZW4NCmRldmljZSB0cmVlLiBUaGlzIGlzIG5vdCBzb21ldGhp
bmcgcHVyZWx5IHRoZW9yZXRpY2FsLiBJIGRvbid0IGtub3cgaWYNCkRUcyB1bmRlciBhcmNoL2Fy
bS9ib290L2R0cyBhcmUgYWxsIGNvcnJlY3QsIGJ1dCBJIHNhdyBhIGxvdCBEVHMgZnJvbQ0Kc2ls
aWNvbmUgdmVuZG9ycyBhbmQgdmVyeSBsaXR0bGUgb2YgdGhlbSB3ZXJlIDEwMCUgY29ycmVjdC4N
Cg0KSW4gb3RoZXIgd29yZHMsIHRoaXMgcGF0Y2ggcmVwYWlycyBlcnJvci1oYW5kbGluZy4gV2l0
aCAxMDAlIGNvcnJlY3QNCkRUcyAob3IgQUNQSSB0YWJsZXMsIGhhdmUgeW91IHNlZW4gb25lIDEw
MCUgY29ycmVjdCBCVFc/IDopKSBpdCdzDQpub3QgcmVxdWlyZWQuDQoNCi0tIA0KQmVzdCByZWdh
cmRzLA0KQWxleGFuZGVyIFN2ZXJkbGluLg0K

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C6047723
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 00:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfFPWw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 18:52:28 -0400
Received: from mail-eopbgr800129.outbound.protection.outlook.com ([40.107.80.129]:10528
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726016AbfFPWw1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 Jun 2019 18:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJizSwLYnyMy5hSTVGw/n8Ejb1uXAhLgP38yrGfH3WA=;
 b=argvBXju4eU/ytRk1HY4tDNM7ohi1iICQfjlVN1PAdANJkGQBJHbLuCQBRDmVJ5UMkmEf9Q5Lzos0ES3rSAB5QIYvjOZ60/KfdglP2qu5EGMhr5itlLDN4PoMiRKQfcwU3sJkfobxTiHSDbDehw4X05ykfagRXav6gVoyqw6EP0=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1648.namprd22.prod.outlook.com (10.174.167.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Sun, 16 Jun 2019 22:52:23 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40%2]) with mapi id 15.20.1987.014; Sun, 16 Jun 2019
 22:52:23 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Hauke Mehrtens <hauke@hauke-m.de>
CC:     Paul Burton <pburton@wavecomp.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "jhogan@kernel.org" <jhogan@kernel.org>,
        "f4bug@amsat.org" <f4bug@amsat.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Yunqiang Su <ysu@wavecomp.com>,
        "jcristau@debian.org" <jcristau@debian.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH] MIPS: Fix bounds check virt_addr_valid
Thread-Topic: [PATCH] MIPS: Fix bounds check virt_addr_valid
Thread-Index: AQHVJJM2zyT1sAHyZkOPErpVODxD6Kae4ymA
Date:   Sun, 16 Jun 2019 22:52:23 +0000
Message-ID: <MWHPR2201MB127770B15273D2B1BC3B3F40C1E80@MWHPR2201MB1277.namprd22.prod.outlook.com>
References: <20190616223039.28158-1-hauke@hauke-m.de>
In-Reply-To: <20190616223039.28158-1-hauke@hauke-m.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR06CA0069.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::46) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2601:646:8a00:9810:9d6:9cca:ff8c:efe0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94a9631e-3160-49de-dd1a-08d6f2ad4b53
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1648;
x-ms-traffictypediagnostic: MWHPR2201MB1648:
x-microsoft-antispam-prvs: <MWHPR2201MB164837ABE3D00FECA6B0DCF0C1E80@MWHPR2201MB1648.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0070A8666B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39840400004)(366004)(136003)(346002)(376002)(396003)(199004)(189003)(33656002)(76176011)(7696005)(52116002)(7736002)(305945005)(71200400001)(8936002)(14454004)(71190400001)(42882007)(46003)(9686003)(55016002)(256004)(5660300002)(99286004)(446003)(478600001)(6116002)(44832011)(11346002)(6916009)(68736007)(186003)(4326008)(102836004)(386003)(6506007)(81156014)(81166006)(52536014)(6436002)(316002)(229853002)(74316002)(476003)(2906002)(486006)(53936002)(73956011)(66946007)(66476007)(66556008)(64756008)(66446008)(4744005)(8676002)(25786009)(54906003)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1648;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oK1d5ltOWXluM8mV9ywoSQlInRNPRrZ/VIuXCZeQuCM+XxU43mdaHFgem4AcUM7KOvP4FYlyvuCtLRj2XTUNqPs+p6F7Pf7WTVn3jsoUq3ewUf0ms1npc6IN/lqjYtlvSWFtGELW3ueupFO6DVgczOj5GTJNmbYyzoayyyWVvDoMnIJ8PlCito1bRs60oajrmBaFU8fgxcDSswNuk0vVtlHlotRChp+n4gQ8pNmuiVt+imp79WBA5Bh39k6N8fnLUU2mbuwzVk2h2jEsLNQmHM4RqGZ02v18HvoqkAea1NMb1ysge2vC+xo2opskJEEd08wyQ8SUgM/CeoJjUeJm1uJTdaesao6GAeOUhzAuVqApkF08d87ZrnV8yWRYMPZhU+BvnEaoh8Nu+j6gwE36+6n81d+huasPtyKAGLGa9LQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94a9631e-3160-49de-dd1a-08d6f2ad4b53
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2019 22:52:23.5132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1648
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8sDQoNCkhhdWtlIE1laHJ0ZW5zIHdyb3RlOg0KPiBUaGUgYm91bmRzIGNoZWNrIHVzZWQg
dGhlIHVuaW5pdGlhbGl6ZWQgdmFyaWFibGUgdmFkZHIsIGl0IHNob3VsZCB1c2UNCj4gdGhlIGdp
dmVuIHBhcmFtZXRlciBrYWRkciBpbnN0ZWFkLiBXaGVuIHVzaW5nIHRoZSB1bmluaXRpYWxpemVk
IHZhbHVlDQo+IHRoZSBjb21waWxlciBhc3N1bWVkIGl0IHRvIGJlIDAgYW5kIG9wdGltaXplZCB0
aGlzIGZ1bmN0aW9uIHRvIGp1c3QNCj4gcmV0dXJuIDAgaW4gYWxsIGNhc2VzLg0KPiANCj4gVGhp
cyBzaG91bGQgbWFrZSB0aGUgZnVuY3Rpb24gY2hlY2sgdGhlIHJhbmdlIG9mIHRoZSBnaXZlbiBh
ZGRyZXNzIGFuZA0KPiBvbmx5IGRvIHRoZSBwYWdlIG1hcCBjaGVjayBpbiBjYXNlIGl0IGlzIGlu
IHRoZSBleHBlY3RlZCByYW5nZSBvZg0KPiB2aXJ0dWFsIGFkZHJlc3Nlcy4NCj4gDQo+IEZpeGVz
OiAwNzRhMWUxMTY3YWYgKCJNSVBTOiBCb3VuZHMgY2hlY2sgdmlydF9hZGRyX3ZhbGlkIikNCj4g
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgIyB2NC4xMisNCj4gQ2M6IFBhdWwgQnVydG9uIDxw
YXVsLmJ1cnRvbkBtaXBzLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogSGF1a2UgTWVocnRlbnMgPGhh
dWtlQGhhdWtlLW0uZGU+DQoNCkFwcGxpZWQgdG8gbWlwcy1maXhlcy4NCg0KVGhhbmtzLA0KICAg
IFBhdWwNCg0KWyBUaGlzIG1lc3NhZ2Ugd2FzIGF1dG8tZ2VuZXJhdGVkOyBpZiB5b3UgYmVsaWV2
ZSBhbnl0aGluZyBpcyBpbmNvcnJlY3QNCiAgdGhlbiBwbGVhc2UgZW1haWwgcGF1bC5idXJ0b25A
bWlwcy5jb20gdG8gcmVwb3J0IGl0LiBdDQo=

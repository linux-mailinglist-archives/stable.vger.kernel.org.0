Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCD024A3C
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 10:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfEUIYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 04:24:51 -0400
Received: from mail-eopbgr730040.outbound.protection.outlook.com ([40.107.73.40]:28330
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725790AbfEUIYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 04:24:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvmOXxnNgFe5e/MlRqO9VH2k2WmWXw7/Xp7LCA2YCcE=;
 b=vEFV0km9y44MQ6CgCpkvewFzQZ7jZvtO1ra4p2Bdc54OLhgA4267JcK43JyqH0bIKYF9Ddcqpk0Or+ilpzTG/Gikj+ykwa3Wbpkoa/+E+NXUt0FtT9Bm2tKGLkRf0I6QzTsdBZbSrwBWscEgJijyxHbp8iuvY6cKdjWQU2YnxvM=
Received: from MN2PR05MB6141.namprd05.prod.outlook.com (20.178.241.217) by
 MN2PR05MB6384.namprd05.prod.outlook.com (20.178.246.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.12; Tue, 21 May 2019 08:24:46 +0000
Received: from MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::c19e:e8f8:b151:9ad]) by MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::c19e:e8f8:b151:9ad%6]) with mapi id 15.20.1922.013; Tue, 21 May 2019
 08:24:46 +0000
From:   Thomas Hellstrom <thellstrom@vmware.com>
To:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC:     Thomas Hellstrom <thellstrom@vmware.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Brian Paul <brianp@vmware.com>
Subject: [PATCH 3/6] drm/vmwgfx: Fix compat mode shader operation
Thread-Topic: [PATCH 3/6] drm/vmwgfx: Fix compat mode shader operation
Thread-Index: AQHVD66lqs5OTMEjPUWqDBC8yJKr3Q==
Date:   Tue, 21 May 2019 08:24:45 +0000
Message-ID: <20190521082345.27286-3-thellstrom@vmware.com>
References: <20190521082345.27286-1-thellstrom@vmware.com>
In-Reply-To: <20190521082345.27286-1-thellstrom@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR08CA0156.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::34) To MN2PR05MB6141.namprd05.prod.outlook.com
 (2603:10b6:208:c7::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thellstrom@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [155.4.205.35]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b015e473-01eb-4be1-e0b7-08d6ddc5c812
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MN2PR05MB6384;
x-ms-traffictypediagnostic: MN2PR05MB6384:
x-microsoft-antispam-prvs: <MN2PR05MB638449214D26E8CE75B71AFFA1070@MN2PR05MB6384.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:163;
x-forefront-prvs: 0044C17179
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(376002)(346002)(39860400002)(199004)(189003)(25786009)(6116002)(8676002)(305945005)(14454004)(5660300002)(3846002)(476003)(54906003)(11346002)(81156014)(26005)(486006)(81166006)(256004)(68736007)(76176011)(71200400001)(8936002)(7736002)(6916009)(1076003)(478600001)(2616005)(446003)(71190400001)(66476007)(66556008)(64756008)(66446008)(73956011)(36756003)(6512007)(86362001)(66946007)(2906002)(66066001)(186003)(53936002)(52116002)(50226002)(316002)(4326008)(2501003)(102836004)(386003)(6506007)(99286004)(5640700003)(6436002)(2351001)(107886003)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6384;H:MN2PR05MB6141.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AwFgDY/l6xSg99lF14vuSL1RpQRHEElxO668UGCBFsmVrEF7YTXBKElJbBT2nfLPN79zkcLv5ZsnvitcCo6EutGbUcCYa9I3ponGphEhFfTqJ40BIuoNF5vi6dryEec9svzbidvGcWvN/nRMAct/5GwkDjP0SQWqq4VBvLUNub/tBND3vm6F0e6cxh3dpKRsk+qzn09x+ctayoYPzVKhug3gJFIVFgyK0eeaoWDorGKBdyKSOdOKnDuyfe6IVUgSTF6Ixs7rtQfS86V2s8cDhoEJHUjih6rGPBCAXCyj5uc4PkPIVjoDomLEZKYzrdmx5OF7/IUbC5EcycD2U2ZKaBgbW4gXNWsaG6cAijLXFR56UwXxCH6bCOCjRpljRLtP7EpOy3yf7n5kB/hK2m2kI5PPZrzc/xWWUEqVjHnLkZ8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b015e473-01eb-4be1-e0b7-08d6ddc5c812
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2019 08:24:45.8787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: thellstrom@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6384
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SW4gY29tcGF0IG1vZGUsIHdlIGFsbG93ZWQgaG9zdC1iYWNrZWQgdXNlci1zcGFjZSB3aXRoIGd1
ZXN0LWJhY2tlZA0Ka2VybmVsIC8gZGV2aWNlLiBJbiB0aGlzIG1vZGUsIHNldCBzaGFkZXIgY29t
bWFuZHMgd2FzIGJyb2tlbiBzaW5jZQ0Kbm8gcmVsb2NhdGlvbnMgd2VyZSBlbWl0dGVkLiBGaXgg
dGhpcy4NCg0KQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KRml4ZXM6IGU4YzY2ZWZiZmUz
YSAoImRybS92bXdnZng6IE1ha2UgdXNlciByZXNvdXJjZSBsb29rdXBzIHJlZmVyZW5jZS1mcmVl
IGR1cmluZyB2YWxpZGF0aW9uIikNClNpZ25lZC1vZmYtYnk6IFRob21hcyBIZWxsc3Ryb20gPHRo
ZWxsc3Ryb21Adm13YXJlLmNvbT4NClJldmlld2VkLWJ5OiBCcmlhbiBQYXVsIDxicmlhbnBAdm13
YXJlLmNvbT4NCi0tLQ0KIGRyaXZlcnMvZ3B1L2RybS92bXdnZngvdm13Z2Z4X2V4ZWNidWYuYyB8
IDEzICsrKysrKysrKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKQ0KDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3Ztd2dmeC92bXdnZnhfZXhlY2J1Zi5jIGIvZHJp
dmVycy9ncHUvZHJtL3Ztd2dmeC92bXdnZnhfZXhlY2J1Zi5jDQppbmRleCAyZmY3YmEwNGQ4Yzgu
LjMxNWY5ZWZjZTc2NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS92bXdnZngvdm13Z2Z4
X2V4ZWNidWYuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL3Ztd2dmeC92bXdnZnhfZXhlY2J1Zi5j
DQpAQCAtMjAxMCw2ICsyMDEwLDExIEBAIHN0YXRpYyBpbnQgdm13X2NtZF9zZXRfc2hhZGVyKHN0
cnVjdCB2bXdfcHJpdmF0ZSAqZGV2X3ByaXYsDQogCQlyZXR1cm4gMDsNCiANCiAJaWYgKGNtZC0+
Ym9keS5zaGlkICE9IFNWR0EzRF9JTlZBTElEX0lEKSB7DQorCQkvKg0KKwkJICogVGhpcyBpcyB0
aGUgY29tcGF0IHNoYWRlciBwYXRoIC0gUGVyIGRldmljZSBndWVzdC1iYWNrZWQNCisJCSAqIHNo
YWRlcnMsIGJ1dCB1c2VyLXNwYWNlIHRoaW5rcyBpdCdzIHBlciBjb250ZXh0IGhvc3QtDQorCQkg
KiBiYWNrZWQgc2hhZGVycy4NCisJCSAqLw0KIAkJcmVzID0gdm13X3NoYWRlcl9sb29rdXAodm13
X2NvbnRleHRfcmVzX21hbihjdHgpLA0KIAkJCQkJY21kLT5ib2R5LnNoaWQsIGNtZC0+Ym9keS50
eXBlKTsNCiAJCWlmICghSVNfRVJSKHJlcykpIHsNCkBAIC0yMDE3LDYgKzIwMjIsMTQgQEAgc3Rh
dGljIGludCB2bXdfY21kX3NldF9zaGFkZXIoc3RydWN0IHZtd19wcml2YXRlICpkZXZfcHJpdiwN
CiAJCQkJCQkJICAgIFZNV19SRVNfRElSVFlfTk9ORSk7DQogCQkJaWYgKHVubGlrZWx5KHJldCAh
PSAwKSkNCiAJCQkJcmV0dXJuIHJldDsNCisNCisJCQlyZXQgPSB2bXdfcmVzb3VyY2VfcmVsb2Nh
dGlvbl9hZGQNCisJCQkJKHN3X2NvbnRleHQsIHJlcywNCisJCQkJIHZtd19wdHJfZGlmZihzd19j
b250ZXh0LT5idWZfc3RhcnQsDQorCQkJCQkgICAgICAmY21kLT5ib2R5LnNoaWQpLA0KKwkJCQkg
dm13X3Jlc19yZWxfbm9ybWFsKTsNCisJCQlpZiAodW5saWtlbHkocmV0ICE9IDApKQ0KKwkJCQly
ZXR1cm4gcmV0Ow0KIAkJfQ0KIAl9DQogDQotLSANCjIuMjAuMQ0KDQo=

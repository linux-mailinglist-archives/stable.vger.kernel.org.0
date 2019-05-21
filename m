Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C092724A3F
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 10:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfEUIZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 04:25:04 -0400
Received: from mail-eopbgr720044.outbound.protection.outlook.com ([40.107.72.44]:35616
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725790AbfEUIZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 04:25:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GABHx8R42T9goBZkKnieCdLu7mt10L9I2fFPKfU7Y7Y=;
 b=gZBr978a03Has6HpYQXV5cKhPq4C1fA/WhSqo5EGzkWoQwcI2SveONACofqpyvG4CZqgyfe7TE9B1RbgLSHu0fosozCQF1U0+MXc5wsOkDManegd0ed4bPUNSot9E01OPVFBOvcNDr8pxmDw8JzOOKNx+9mmKc5SYSAmnhtHxR4=
Received: from MN2PR05MB6141.namprd05.prod.outlook.com (20.178.241.217) by
 MN2PR05MB6384.namprd05.prod.outlook.com (20.178.246.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.12; Tue, 21 May 2019 08:25:01 +0000
Received: from MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::c19e:e8f8:b151:9ad]) by MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::c19e:e8f8:b151:9ad%6]) with mapi id 15.20.1922.013; Tue, 21 May 2019
 08:25:01 +0000
From:   Thomas Hellstrom <thellstrom@vmware.com>
To:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC:     Murray McAllister <murray.mcallister@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 5/6] drm/vmwgfx: NULL pointer dereference from
 vmw_cmd_dx_view_define()
Thread-Topic: [PATCH 5/6] drm/vmwgfx: NULL pointer dereference from
 vmw_cmd_dx_view_define()
Thread-Index: AQHVD66vMx659dgbLkCRMkI5Y/UGAg==
Date:   Tue, 21 May 2019 08:25:01 +0000
Message-ID: <20190521082345.27286-5-thellstrom@vmware.com>
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
x-ms-office365-filtering-correlation-id: 8e580b37-bb83-4a6b-bd4b-08d6ddc5d13b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MN2PR05MB6384;
x-ms-traffictypediagnostic: MN2PR05MB6384:
x-microsoft-antispam-prvs: <MN2PR05MB6384776C41C53FDAA33B23E5A1070@MN2PR05MB6384.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:765;
x-forefront-prvs: 0044C17179
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(366004)(136003)(396003)(376002)(346002)(39860400002)(199004)(189003)(25786009)(6116002)(8676002)(305945005)(14454004)(5660300002)(3846002)(476003)(54906003)(11346002)(81156014)(26005)(486006)(81166006)(256004)(68736007)(76176011)(71200400001)(8936002)(7736002)(6916009)(1076003)(478600001)(2616005)(446003)(71190400001)(66476007)(66556008)(64756008)(66446008)(73956011)(36756003)(6512007)(86362001)(66946007)(2906002)(66066001)(186003)(53936002)(52116002)(50226002)(316002)(4326008)(2501003)(102836004)(386003)(6506007)(99286004)(5640700003)(6436002)(2351001)(107886003)(6486002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6384;H:MN2PR05MB6141.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LY+BeyGKqj8Ay1+6S1TERchrjOpD0uNDKl7EA2GWXqT4vjSRtg0dQ09rAyV+jpbIR55CBTiSOFcvN9JzcVNImxyO9+TJSmMKjLF3ToXYGV0SS4M6Flt4qUPfVfBuwJo0A0lXf7AAvtnozvEnIC87jwA8oSBVhqgVfn7MOA34jIjeu5//g7ZV6uFnZ4fuRwFIb0jRJLvPpvIs3TpkLSkzV4fjnwdTgFKX369KOVE1dadQY7yAtdb9yi7ZEVKcdPJEJ7sEYakOz3lb8PVY2i7XXGguGiLSySVGRCRmn2PnnBQc5Xm4oTIkSyo/IvSBOPNzkd7mlea5RKP068Oy/M45kmnP+kEIheFsy3PiyGzw8/up9jW3Aa+iM8+R/6nndCja7vow249L7BJy3udIgaEciJqm72xaUyAgQnKGTQ5sMts=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e580b37-bb83-4a6b-bd4b-08d6ddc5d13b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2019 08:25:01.3250
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

RnJvbTogTXVycmF5IE1jQWxsaXN0ZXIgPG11cnJheS5tY2FsbGlzdGVyQGdtYWlsLmNvbT4NCg0K
SWYgU1ZHQV8zRF9DTURfRFhfREVGSU5FX1JFTkRFUlRBUkdFVF9WSUVXIGlzIGNhbGxlZCB3aXRo
IGEgc3VyZmFjZQ0KSUQgb2YgU1ZHQTNEX0lOVkFMSURfSUQsIHRoZSBzcmYgc3RydWN0IHdpbGwg
cmVtYWluIE5VTEwgYWZ0ZXINCnZtd19jbWRfcmVzX2NoZWNrKCksIGxlYWRpbmcgdG8gYSBudWxs
IHBvaW50ZXIgZGVyZWZlcmVuY2UgaW4NCnZtd192aWV3X2FkZCgpLg0KDQpDYzogPHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmc+DQpGaXhlczogZDgwZWZkNWNiM2RlICgiZHJtL3Ztd2dmeDogSW5pdGlh
bCBEWCBzdXBwb3J0IikNClNpZ25lZC1vZmYtYnk6IE11cnJheSBNY0FsbGlzdGVyIDxtdXJyYXku
bWNhbGxpc3RlckBnbWFpbC5jb20+DQpSZXZpZXdlZC1ieTogVGhvbWFzIEhlbGxzdHJvbSA8dGhl
bGxzdHJvbUB2bXdhcmUuY29tPg0KU2lnbmVkLW9mZi1ieTogVGhvbWFzIEhlbGxzdHJvbSA8dGhl
bGxzdHJvbUB2bXdhcmUuY29tPg0KLS0tDQogZHJpdmVycy9ncHUvZHJtL3Ztd2dmeC92bXdnZnhf
ZXhlY2J1Zi5jIHwgNCArKysrDQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQ0KDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3Ztd2dmeC92bXdnZnhfZXhlY2J1Zi5jIGIvZHJp
dmVycy9ncHUvZHJtL3Ztd2dmeC92bXdnZnhfZXhlY2J1Zi5jDQppbmRleCAzMTVmOWVmY2U3NjUu
LmI0Yzc1NTNkMjgxNCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS92bXdnZngvdm13Z2Z4
X2V4ZWNidWYuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL3Ztd2dmeC92bXdnZnhfZXhlY2J1Zi5j
DQpAQCAtMjQyNyw2ICsyNDI3LDEwIEBAIHN0YXRpYyBpbnQgdm13X2NtZF9keF92aWV3X2RlZmlu
ZShzdHJ1Y3Qgdm13X3ByaXZhdGUgKmRldl9wcml2LA0KIAkJcmV0dXJuIC1FSU5WQUw7DQogDQog
CWNtZCA9IGNvbnRhaW5lcl9vZihoZWFkZXIsIHR5cGVvZigqY21kKSwgaGVhZGVyKTsNCisJaWYg
KHVubGlrZWx5KGNtZC0+c2lkID09IFNWR0EzRF9JTlZBTElEX0lEKSkgew0KKwkJVk1XX0RFQlVH
X1VTRVIoIkludmFsaWQgc3VyZmFjZSBpZC5cbiIpOw0KKwkJcmV0dXJuIC1FSU5WQUw7DQorCX0N
CiAJcmV0ID0gdm13X2NtZF9yZXNfY2hlY2soZGV2X3ByaXYsIHN3X2NvbnRleHQsIHZtd19yZXNf
c3VyZmFjZSwNCiAJCQkJVk1XX1JFU19ESVJUWV9OT05FLCB1c2VyX3N1cmZhY2VfY29udmVydGVy
LA0KIAkJCQkmY21kLT5zaWQsICZzcmYpOw0KLS0gDQoyLjIwLjENCg0K

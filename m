Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B0D24A39
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 10:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfEUIYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 04:24:25 -0400
Received: from mail-eopbgr780070.outbound.protection.outlook.com ([40.107.78.70]:42816
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726289AbfEUIYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 04:24:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwKp7MBQrobFVMA6UrLVzIXuUlK7fyuxYdOSASmRVVE=;
 b=tONd3NOCPHX+JcFH8MPLKRDq0u899q8Mf+r41QMB8f4a1oVBulEGP90RdY/ijYLd+L1S1LR0c7/didObknsgFMX166BRT6PzmryRineWsk3ZhoT3FtgclJEwDCo8xBf4ZzPXm8btJDc7NYl4xL1vkp/dX8WkmUZMB6ZFwlvRzIk=
Received: from MN2PR05MB6141.namprd05.prod.outlook.com (20.178.241.217) by
 MN2PR05MB6383.namprd05.prod.outlook.com (20.178.245.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.13; Tue, 21 May 2019 08:24:20 +0000
Received: from MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::c19e:e8f8:b151:9ad]) by MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::c19e:e8f8:b151:9ad%6]) with mapi id 15.20.1922.013; Tue, 21 May 2019
 08:24:20 +0000
From:   Thomas Hellstrom <thellstrom@vmware.com>
To:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC:     Thomas Hellstrom <thellstrom@vmware.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Deepak Singh Rawat <drawat@vmware.com>
Subject: [PATCH 1/6] drm/vmwgfx: Don't send drm sysfs hotplug events on
 initial master set
Thread-Topic: [PATCH 1/6] drm/vmwgfx: Don't send drm sysfs hotplug events on
 initial master set
Thread-Index: AQHVD66WB8FhPxysTkevBEDoHQXT2g==
Date:   Tue, 21 May 2019 08:24:20 +0000
Message-ID: <20190521082345.27286-1-thellstrom@vmware.com>
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
x-ms-office365-filtering-correlation-id: 3916b6a4-4501-461d-7e40-08d6ddc5b8b4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MN2PR05MB6383;
x-ms-traffictypediagnostic: MN2PR05MB6383:
x-microsoft-antispam-prvs: <MN2PR05MB638390B595A83E131816C96BA1070@MN2PR05MB6383.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0044C17179
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(39860400002)(366004)(346002)(376002)(189003)(199004)(52116002)(3846002)(2501003)(71190400001)(71200400001)(6116002)(316002)(102836004)(99286004)(2906002)(6506007)(386003)(68736007)(256004)(14444005)(14454004)(66946007)(73956011)(66476007)(66556008)(64756008)(66446008)(478600001)(54906003)(305945005)(6512007)(36756003)(66066001)(26005)(7736002)(5640700003)(6436002)(81166006)(6916009)(1076003)(25786009)(186003)(8676002)(6486002)(4744005)(81156014)(86362001)(50226002)(8936002)(4326008)(2616005)(107886003)(5660300002)(486006)(53936002)(2351001)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6383;H:MN2PR05MB6141.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mftSggKJbOGyidAMiUYrS4/UZ8y9IvSWcCLgonWSB1p44PcSdPMnKEVgAqJ8O2tPJzJTK5kUA9K+wjhTWc11dStNpy59hnRUCii5IYOFZVDPcTZIGPLOev30EyNnt1umQkP/qcitAKKJKF3NDdmGbOq+ZNJRjggfWZS4TUauFXme3U6vEYy5mhHqQ0EAAXp6bRA3eSpyDYKRz62WH8NxfmIe4qmSxOJz8c3lh26HK9fTMGweoalITqmCIq7gsEYqdlzhKp61Q76ty6e+ThhaC+6pX+TQ7YkYdfQZwyhXk7O27fF1OcFmzZH6Cc4x3S4wlz5pIsm8cVu/gwsyP68gTdBZIrM0Bhp8tCTyK9mFOP54E4/xGIMGB3RCzmfqPv7rCg28A0ual733m7BfmBUp6N0mahPpIlKkJhCx4KUqRFg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3916b6a4-4501-461d-7e40-08d6ddc5b8b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2019 08:24:20.1953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: thellstrom@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6383
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhpcyBtYXkgY29uZnVzZSB1c2VyLXNwYWNlIGNsaWVudHMgbGlrZSBwbHltb3V0aCB0aGF0IG9w
ZW5zIGEgZHJtDQpmaWxlIGRlc2NyaXB0b3IgYXMgYSByZXN1bHQgb2YgYSBob3RwbHVnIGV2ZW50
IGFuZCB0aGVuIGdlbmVyYXRlcyBhDQpuZXcgZXZlbnQuLi4NCg0KQ2M6IDxzdGFibGVAdmdlci5r
ZXJuZWwub3JnPg0KRml4ZXM6IDVlYTE3MzQ4MjdiYiAoImRybS92bXdnZng6IFNlbmQgYSBob3Rw
bHVnIGV2ZW50IGF0IG1hc3Rlcl9zZXQiKQ0KU2lnbmVkLW9mZi1ieTogVGhvbWFzIEhlbGxzdHJv
bSA8dGhlbGxzdHJvbUB2bXdhcmUuY29tPg0KUmV2aWV3ZWQtYnk6IERlZXBhayBSYXdhdCA8ZHJh
d2F0QHZtd2FyZS5jb20+DQotLS0NCiBkcml2ZXJzL2dwdS9kcm0vdm13Z2Z4L3Ztd2dmeF9kcnYu
YyB8IDggKysrKysrKy0NCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vdm13Z2Z4L3Ztd2dmeF9kcnYu
YyBiL2RyaXZlcnMvZ3B1L2RybS92bXdnZngvdm13Z2Z4X2Rydi5jDQppbmRleCBiZjZjMzUwMGQz
NjMuLjRmZjExYTAwNzdlMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS92bXdnZngvdm13
Z2Z4X2Rydi5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vdm13Z2Z4L3Ztd2dmeF9kcnYuYw0KQEAg
LTEyMzksNyArMTIzOSwxMyBAQCBzdGF0aWMgaW50IHZtd19tYXN0ZXJfc2V0KHN0cnVjdCBkcm1f
ZGV2aWNlICpkZXYsDQogCX0NCiANCiAJZGV2X3ByaXYtPmFjdGl2ZV9tYXN0ZXIgPSB2bWFzdGVy
Ow0KLQlkcm1fc3lzZnNfaG90cGx1Z19ldmVudChkZXYpOw0KKw0KKwkvKg0KKwkgKiBJbmZvcm0g
YSBuZXcgbWFzdGVyIHRoYXQgdGhlIGxheW91dCBtYXkgaGF2ZSBjaGFuZ2VkIHdoaWxlDQorCSAq
IGl0IHdhcyBnb25lLg0KKwkgKi8NCisJaWYgKCFmcm9tX29wZW4pDQorCQlkcm1fc3lzZnNfaG90
cGx1Z19ldmVudChkZXYpOw0KIA0KIAlyZXR1cm4gMDsNCiB9DQotLSANCjIuMjAuMQ0KDQo=

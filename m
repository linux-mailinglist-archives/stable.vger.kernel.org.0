Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 552F624A3A
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 10:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfEUIYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 04:24:39 -0400
Received: from mail-eopbgr730082.outbound.protection.outlook.com ([40.107.73.82]:33047
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726417AbfEUIYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 04:24:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0lBf2kzOrCa93YAZyWALHyZOdYDTzgC7hcgVZ2GMlQ=;
 b=sRzi0RAP6INqn9xQH5zF+lTT3hzHz3X++J1VwbKEucgtMvyIScCeX78rU2/rjHMtwi4YVhDynOAWxVNDQ1bVPnewmxUWlkHakWWMsQuVq0C8VXXyG9Z9T+xP+brV2ABw50XDwQ1c8i8ppfc56oIADYuX1NXc3ytJmIGZDMGItrU=
Received: from MN2PR05MB6141.namprd05.prod.outlook.com (20.178.241.217) by
 MN2PR05MB6384.namprd05.prod.outlook.com (20.178.246.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.12; Tue, 21 May 2019 08:24:36 +0000
Received: from MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::c19e:e8f8:b151:9ad]) by MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::c19e:e8f8:b151:9ad%6]) with mapi id 15.20.1922.013; Tue, 21 May 2019
 08:24:36 +0000
From:   Thomas Hellstrom <thellstrom@vmware.com>
To:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC:     Thomas Hellstrom <thellstrom@vmware.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Deepak Singh Rawat <drawat@vmware.com>
Subject: [PATCH 2/6] drm/vmwgfx: Fix user space handle equal to zero
Thread-Topic: [PATCH 2/6] drm/vmwgfx: Fix user space handle equal to zero
Thread-Index: AQHVD66ftHwFBaQDdEyTGRRTD/XPiw==
Date:   Tue, 21 May 2019 08:24:35 +0000
Message-ID: <20190521082345.27286-2-thellstrom@vmware.com>
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
x-ms-office365-filtering-correlation-id: e26a61c5-e307-4fa0-ea80-08d6ddc5c217
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MN2PR05MB6384;
x-ms-traffictypediagnostic: MN2PR05MB6384:
x-microsoft-antispam-prvs: <MN2PR05MB6384E3B216AB8A89CE19137CA1070@MN2PR05MB6384.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:451;
x-forefront-prvs: 0044C17179
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(376002)(346002)(39860400002)(199004)(189003)(25786009)(6116002)(8676002)(305945005)(14454004)(5660300002)(3846002)(476003)(54906003)(11346002)(81156014)(26005)(486006)(81166006)(256004)(14444005)(68736007)(76176011)(71200400001)(8936002)(7736002)(6916009)(1076003)(478600001)(2616005)(446003)(71190400001)(66476007)(66556008)(64756008)(66446008)(73956011)(36756003)(6512007)(86362001)(66946007)(2906002)(66066001)(186003)(53936002)(52116002)(50226002)(316002)(4326008)(2501003)(102836004)(386003)(6506007)(99286004)(5640700003)(6436002)(2351001)(107886003)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6384;H:MN2PR05MB6141.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: X7LKVtQ9Gpxyr8XHc3GT7zR0OAMPSrUgvB7sgYiEdFdyGHSk5fbHrIABtGBya3axGT7UtUCKb3SSPLbTfPO5UXiY/8j/F8JsMRGm9TxvGGGi0ET+2PNA0eECgsc7wBD4v8D4fEUwv435PYDF4xCZtso5+AwEVV2UNtGb/S7kgThU0tToY8+/c+eHCcOa9JoduomYH5Cjn24X0hK/f/+BnEA2UGnkmkPPuGa2RlIOSnSPGdksNWE2q+G9dhmZ/l+LdRWn9IISFuF/7LrmYTOaX+SHeDlg1VP1YxeGyOoCPDBm/77HwkF3Co++RY3OhmILkYCvbuqQ3jmhJBhifPkYYUmzadJM7MZxQSESb2SaNkcWmoiJcSwZf/0bKpD/xX2CqTY+4mVeKoJJ0NKJF9DkaStPVw6J7ReV/bE9/+qpgWM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e26a61c5-e307-4fa0-ea80-08d6ddc5c217
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2019 08:24:35.8144
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

VXNlci1zcGFjZSBoYW5kbGVzIGVxdWFsIHRvIHplcm8gYXJlIGludGVycHJldGVkIGFzIHVuaW5p
dGlhbGl6ZWQgb3INCmlsbGVnYWwgYnkgc29tZSBkcm0gc3lzdGVtcyAobW9zdCBub3RhYmx5IGtt
cykuIFRoaXMgbWVhbnMgdGhhdCBhDQpkdW1iIGJ1ZmZlciBvciBzdXJmYWNlIHdpdGggYSB6ZXJv
IHVzZXItc3BhY2UgaGFuZGxlIGNhbiBuZXZlciBiZQ0KdXNlZCBhcyBhIGttcyBmcmFtZS1idWZm
ZXIuDQoNCkNjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCkZpeGVzOiBjN2VhZTYyNjY2YWQg
KCJkcm0vdm13Z2Z4OiBNYWtlIHRoZSBvYmplY3QgaGFuZGxlcyBpZHItZ2VuZXJhdGVkIikNClNp
Z25lZC1vZmYtYnk6IFRob21hcyBIZWxsc3Ryb20gPHRoZWxsc3Ryb21Adm13YXJlLmNvbT4NClJl
dmlld2VkLWJ5OiBEZWVwYWsgUmF3YXQgPGRyYXdhdEB2bXdhcmUuY29tPg0KLS0tDQogZHJpdmVy
cy9ncHUvZHJtL3Ztd2dmeC90dG1fb2JqZWN0LmMgfCAyICstDQogMSBmaWxlIGNoYW5nZWQsIDEg
aW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9k
cm0vdm13Z2Z4L3R0bV9vYmplY3QuYyBiL2RyaXZlcnMvZ3B1L2RybS92bXdnZngvdHRtX29iamVj
dC5jDQppbmRleCAzNjk5MGI4MGU3OTAuLjE2MDc3Nzg1YWQ0NyAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvZ3B1L2RybS92bXdnZngvdHRtX29iamVjdC5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vdm13
Z2Z4L3R0bV9vYmplY3QuYw0KQEAgLTE3NCw3ICsxNzQsNyBAQCBpbnQgdHRtX2Jhc2Vfb2JqZWN0
X2luaXQoc3RydWN0IHR0bV9vYmplY3RfZmlsZSAqdGZpbGUsDQogCWtyZWZfaW5pdCgmYmFzZS0+
cmVmY291bnQpOw0KIAlpZHJfcHJlbG9hZChHRlBfS0VSTkVMKTsNCiAJc3Bpbl9sb2NrKCZ0ZGV2
LT5vYmplY3RfbG9jayk7DQotCXJldCA9IGlkcl9hbGxvYygmdGRldi0+aWRyLCBiYXNlLCAwLCAw
LCBHRlBfTk9XQUlUKTsNCisJcmV0ID0gaWRyX2FsbG9jKCZ0ZGV2LT5pZHIsIGJhc2UsIDEsIDAs
IEdGUF9OT1dBSVQpOw0KIAlzcGluX3VubG9jaygmdGRldi0+b2JqZWN0X2xvY2spOw0KIAlpZHJf
cHJlbG9hZF9lbmQoKTsNCiAJaWYgKHJldCA8IDApDQotLSANCjIuMjAuMQ0KDQo=

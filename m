Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5CD124A41
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 10:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfEUIZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 04:25:08 -0400
Received: from mail-eopbgr720060.outbound.protection.outlook.com ([40.107.72.60]:43568
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725790AbfEUIZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 04:25:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yU/e3nnsYZKhs5ZFwWRintMu6fsB820PHLUcXUtlbPs=;
 b=b+ny0b+oTz1aWnMh0lnazd8wZilY7K+rSrk3r2+MWSgg0F/mLIpCTEfJ8D42iFf0UhpOrcwUcNmSdbWVXIjm03uxxIhy4ArfZ9DKXqm2sN6Prsh//LlAbOiECltlkd8/rezlzuVZW7JAHkGguaf0MlPRcC7TuLHotNLzuYKV7RQ=
Received: from MN2PR05MB6141.namprd05.prod.outlook.com (20.178.241.217) by
 MN2PR05MB6384.namprd05.prod.outlook.com (20.178.246.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.12; Tue, 21 May 2019 08:25:05 +0000
Received: from MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::c19e:e8f8:b151:9ad]) by MN2PR05MB6141.namprd05.prod.outlook.com
 ([fe80::c19e:e8f8:b151:9ad%6]) with mapi id 15.20.1922.013; Tue, 21 May 2019
 08:25:05 +0000
From:   Thomas Hellstrom <thellstrom@vmware.com>
To:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC:     Murray McAllister <murray.mcallister@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 6/6] drm/vmwgfx: integer underflow in vmw_cmd_dx_set_shader()
 leading to an invalid read
Thread-Topic: [PATCH 6/6] drm/vmwgfx: integer underflow in
 vmw_cmd_dx_set_shader() leading to an invalid read
Thread-Index: AQHVD66xyjyjvStMIUOjtPqDr9K8bw==
Date:   Tue, 21 May 2019 08:25:05 +0000
Message-ID: <20190521082345.27286-6-thellstrom@vmware.com>
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
x-ms-office365-filtering-correlation-id: 2a34fde9-80ea-481a-5841-08d6ddc5d385
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MN2PR05MB6384;
x-ms-traffictypediagnostic: MN2PR05MB6384:
x-microsoft-antispam-prvs: <MN2PR05MB638415B59E8658F5BAB2E313A1070@MN2PR05MB6384.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0044C17179
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(376002)(346002)(39860400002)(199004)(189003)(25786009)(6116002)(8676002)(305945005)(14454004)(5660300002)(3846002)(476003)(54906003)(11346002)(81156014)(26005)(486006)(81166006)(256004)(14444005)(68736007)(76176011)(71200400001)(8936002)(7736002)(6916009)(1076003)(478600001)(2616005)(446003)(71190400001)(66476007)(66556008)(64756008)(66446008)(73956011)(36756003)(6512007)(86362001)(66946007)(2906002)(66066001)(186003)(53936002)(52116002)(50226002)(316002)(4326008)(2501003)(102836004)(386003)(6506007)(99286004)(5640700003)(6436002)(2351001)(107886003)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6384;H:MN2PR05MB6141.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sOyVqlotRN14VebJm8ZawPg/YnOKe6MKBRfNcHUnUvh4Ja/tdA70A2wuhlaKu4IwkCR8gg+UBt2cLyhFv+b9ArSkZXlg9YqTzaaZy6qcNpsRRtaaq7iBFpk2TiAWiDgL8yyGCp6qmaouPOLrCtFZIg/upONlHeZ2bvtj7BwunPAzkDwcENBC2B/27iavHzDJ++ysBseknR0arCp2TypngRQb2JFwmN/CX1gY9drxUgIgH8SC7GrC8BpXMLjrSBbS8WuNj9dJ7SGEnDo+zwkDCymlgIg6veWpkoaSISe114PS710+caEcJBARmTcHay3L+aAwsmKNUrkV2pPZgqQpziCvUPrO5VC8opbyTyCHI3WN71WNyhS4+V2TNPs53RD4upuDGcgYqnl/GdOM9CldzcyxXScGXHHJsK13zxt5tbU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a34fde9-80ea-481a-5841-08d6ddc5d385
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2019 08:25:05.0578
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
SWYgU1ZHQV8zRF9DTURfRFhfU0VUX1NIQURFUiBpcyBjYWxsZWQgd2l0aCBhIHNoYWRlciBJRA0K
b2YgU1ZHQTNEX0lOVkFMSURfSUQsIGFuZCBhIHNoYWRlciB0eXBlIG9mDQpTVkdBM0RfU0hBREVS
VFlQRV9JTlZBTElELCB0aGUgY2FsY3VsYXRlZCBiaW5kaW5nLnNoYWRlcl9zbG90DQp3aWxsIGJl
IDQyOTQ5NjcyOTUsIGxlYWRpbmcgdG8gYW4gb3V0LW9mLWJvdW5kcyByZWFkIGluIHZtd19iaW5k
aW5nX2xvYygpDQp3aGVuIHRoZSBvZmZzZXQgaXMgY2FsY3VsYXRlZC4NCg0KQ2M6IDxzdGFibGVA
dmdlci5rZXJuZWwub3JnPg0KRml4ZXM6IGQ4MGVmZDVjYjNkZSAoImRybS92bXdnZng6IEluaXRp
YWwgRFggc3VwcG9ydCIpDQpTaWduZWQtb2ZmLWJ5OiBNdXJyYXkgTWNBbGxpc3RlciA8bXVycmF5
Lm1jYWxsaXN0ZXJAZ21haWwuY29tPg0KUmV2aWV3ZWQtYnk6IFRob21hcyBIZWxsc3Ryb20gPHRo
ZWxsc3Ryb21Adm13YXJlLmNvbT4NClNpZ25lZC1vZmYtYnk6IFRob21hcyBIZWxsc3Ryb20gPHRo
ZWxsc3Ryb21Adm13YXJlLmNvbT4NCi0tLQ0KIGRyaXZlcnMvZ3B1L2RybS92bXdnZngvdm13Z2Z4
X2V4ZWNidWYuYyB8IDMgKystDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3Ztd2dmeC92bXdnZnhf
ZXhlY2J1Zi5jIGIvZHJpdmVycy9ncHUvZHJtL3Ztd2dmeC92bXdnZnhfZXhlY2J1Zi5jDQppbmRl
eCBiNGM3NTUzZDI4MTQuLjMzNTMzZDEyNjI3NyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2Ry
bS92bXdnZngvdm13Z2Z4X2V4ZWNidWYuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL3Ztd2dmeC92
bXdnZnhfZXhlY2J1Zi5jDQpAQCAtMjIwNiw3ICsyMjA2LDggQEAgc3RhdGljIGludCB2bXdfY21k
X2R4X3NldF9zaGFkZXIoc3RydWN0IHZtd19wcml2YXRlICpkZXZfcHJpdiwNCiANCiAJY21kID0g
Y29udGFpbmVyX29mKGhlYWRlciwgdHlwZW9mKCpjbWQpLCBoZWFkZXIpOw0KIA0KLQlpZiAoY21k
LT5ib2R5LnR5cGUgPj0gU1ZHQTNEX1NIQURFUlRZUEVfRFgxMF9NQVgpIHsNCisJaWYgKGNtZC0+
Ym9keS50eXBlID49IFNWR0EzRF9TSEFERVJUWVBFX0RYMTBfTUFYIHx8DQorCSAgICBjbWQtPmJv
ZHkudHlwZSA8IFNWR0EzRF9TSEFERVJUWVBFX01JTikgew0KIAkJVk1XX0RFQlVHX1VTRVIoIkls
bGVnYWwgc2hhZGVyIHR5cGUgJXUuXG4iLA0KIAkJCSAgICAgICAodW5zaWduZWQgaW50KSBjbWQt
PmJvZHkudHlwZSk7DQogCQlyZXR1cm4gLUVJTlZBTDsNCi0tIA0KMi4yMC4xDQoNCg==

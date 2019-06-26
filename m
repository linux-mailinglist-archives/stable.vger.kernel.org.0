Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5230656967
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 14:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfFZMkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 08:40:51 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:3665 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfFZMkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 08:40:51 -0400
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Ajay.Kathat@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Ajay.Kathat@microchip.com";
  x-sender="Ajay.Kathat@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  a:mx1.microchip.iphmx.com a:mx2.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Ajay.Kathat@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; spf=Pass smtp.mailfrom=Ajay.Kathat@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.63,419,1557212400"; 
   d="scan'208";a="39093146"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jun 2019 05:40:50 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.87.152) by
 chn-vm-ex03.mchp-main.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 26 Jun 2019 05:42:00 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 26 Jun 2019 05:42:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QwCAFrke+Fr2UQnFeAENausuqBGh1w63G5+FI7A7NGE=;
 b=ogPqKjiGh0ZyrUp/nLSkQy460hnORGaORxZgVn+OLeNmXt7om1mm7dwt0yC4oqaAEqrkbeMKQcu6ib7fRZPilKM92U9V3/OHsTWYYll0rv7n9oo35UdOAR9WccloBONEh9yeci0rUOdDqI1UItyu41QQHwYiEfhJ6bveTfjYm7Y=
Received: from BN6PR11MB3985.namprd11.prod.outlook.com (10.255.129.78) by
 BN6PR11MB3987.namprd11.prod.outlook.com (10.255.128.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 12:40:48 +0000
Received: from BN6PR11MB3985.namprd11.prod.outlook.com
 ([fe80::49ee:ab78:412:48ac]) by BN6PR11MB3985.namprd11.prod.outlook.com
 ([fe80::49ee:ab78:412:48ac%5]) with mapi id 15.20.2008.017; Wed, 26 Jun 2019
 12:40:48 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/8] staging: wilc1000: fix error path cleanup in
 wilc_wlan_initialize()
Thread-Topic: [PATCH 2/8] staging: wilc1000: fix error path cleanup in
 wilc_wlan_initialize()
Thread-Index: AQHVLBxh6f5c1fo7v0WfMlE3JbKx7g==
Date:   Wed, 26 Jun 2019 12:40:48 +0000
Message-ID: <1561552810-8933-3-git-send-email-ajay.kathat@microchip.com>
References: <1561552810-8933-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1561552810-8933-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BM1PR0101CA0066.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::28) To BN6PR11MB3985.namprd11.prod.outlook.com
 (2603:10b6:405:7b::14)
x-mailer: git-send-email 2.7.4
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [183.82.16.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4d9d848-a3ae-4483-bf0b-08d6fa3383f1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB3987;
x-ms-traffictypediagnostic: BN6PR11MB3987:
x-microsoft-antispam-prvs: <BN6PR11MB3987F9DEE8562382ED72CAB1E3E20@BN6PR11MB3987.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(366004)(376002)(136003)(396003)(189003)(199004)(3846002)(11346002)(305945005)(476003)(2616005)(5660300002)(99286004)(54906003)(25786009)(8676002)(486006)(81156014)(81166006)(8936002)(66066001)(7736002)(66476007)(66556008)(64756008)(66446008)(6116002)(66946007)(6486002)(50226002)(446003)(68736007)(52116002)(73956011)(14444005)(256004)(4326008)(6436002)(316002)(478600001)(386003)(72206003)(53936002)(2906002)(102836004)(6512007)(2501003)(6916009)(76176011)(86362001)(186003)(6506007)(36756003)(71190400001)(78486014)(14454004)(26005)(2351001)(71200400001)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB3987;H:BN6PR11MB3985.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AjcIGeChrrKz1zeiMG42mAhOYQetBrMbmFKYbYqbTrMvXwXRD2I01aOTo/RlKDFDx80vRje02md4cvsC/6a5wuGnPYpYkEojNziUfaGBklUuc4lUlv3EtEeyvS9oKmQzwnHjaD+rttBq+Hc+OrhdhUbGPDiQgm3nMq5JtKwjX+g+RCmqZ37aa1VEcCHTUOVZ32afA6DnJhHnehRhhOV9PQa8aEZezp+7GyQyonCHekxky/rPDifuCbH4Y8q1jOnJFSXBfd6yd4Bvopjdx6Ym1KWYNmE8v8IPs06QneSOCZwW6ZEPx0YUya5P/yLV4RMTJFIEtbeqvZ07j2ntwkouVsEpty4/OasgxL6GGTf8x0oixcMgJDACBblOLIsv0Z/neiWeQ58rAZZstBpe2T1jQdYVGhzz/pEAfvAsCb2aX9A=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a4d9d848-a3ae-4483-bf0b-08d6fa3383f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 12:40:48.6766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ajay.kathat@microchip.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3987
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogQWpheSBTaW5naCA8YWpheS5rYXRoYXRAbWljcm9jaGlwLmNvbT4NCg0KRm9yIHRoZSBl
cnJvciBwYXRoIGluIHdpbGNfd2xhbl9pbml0aWFsaXplKCksIHRoZSByZXNvdXJjZXMgYXJlIG5v
dA0KY2xlYW51cCBpbiB0aGUgY29ycmVjdCBvcmRlci4gUmV2ZXJ0ZWQgdGhlIHByZXZpb3VzIGNo
YW5nZXMgYW5kIHVzZSB0aGUNCmNvcnJlY3Qgb3JkZXIgdG8gZnJlZSBkdXJpbmcgZXJyb3IgY29u
ZGl0aW9uLg0KDQpGaXhlczogYjQ2ZDY4ODI1YzJkICgic3RhZ2luZzogd2lsYzEwMDA6IHJlbW92
ZSBDT01QTEVNRU5UX0JPT1QiKQ0KQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KU2lnbmVk
LW9mZi1ieTogQWpheSBTaW5naCA8YWpheS5rYXRoYXRAbWljcm9jaGlwLmNvbT4NCi0tLQ0KIGRy
aXZlcnMvc3RhZ2luZy93aWxjMTAwMC93aWxjX25ldGRldi5jIHwgMTIgKysrKysrLS0tLS0tDQog
MSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93aWxjMTAwMC93aWxjX25ldGRldi5jIGIvZHJpdmVycy9z
dGFnaW5nL3dpbGMxMDAwL3dpbGNfbmV0ZGV2LmMNCmluZGV4IGM0ZWZlYzIuLjBlMGE0ZWUgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2lsYzEwMDAvd2lsY19uZXRkZXYuYw0KKysrIGIv
ZHJpdmVycy9zdGFnaW5nL3dpbGMxMDAwL3dpbGNfbmV0ZGV2LmMNCkBAIC01MzAsMTcgKzUzMCwx
NyBAQCBzdGF0aWMgaW50IHdpbGNfd2xhbl9pbml0aWFsaXplKHN0cnVjdCBuZXRfZGV2aWNlICpk
ZXYsIHN0cnVjdCB3aWxjX3ZpZiAqdmlmKQ0KIAkJCWdvdG8gZmFpbF9sb2NrczsNCiAJCX0NCiAN
Ci0JCWlmICh3bC0+Z3Bpb19pcnEgJiYgaW5pdF9pcnEoZGV2KSkgew0KLQkJCXJldCA9IC1FSU87
DQotCQkJZ290byBmYWlsX2xvY2tzOw0KLQkJfQ0KLQ0KIAkJcmV0ID0gd2xhbl9pbml0aWFsaXpl
X3RocmVhZHMoZGV2KTsNCiAJCWlmIChyZXQgPCAwKSB7DQogCQkJcmV0ID0gLUVJTzsNCiAJCQln
b3RvIGZhaWxfd2lsY193bGFuOw0KIAkJfQ0KIA0KKwkJaWYgKHdsLT5ncGlvX2lycSAmJiBpbml0
X2lycShkZXYpKSB7DQorCQkJcmV0ID0gLUVJTzsNCisJCQlnb3RvIGZhaWxfdGhyZWFkczsNCisJ
CX0NCisNCiAJCWlmICghd2wtPmRldl9pcnFfbnVtICYmDQogCQkgICAgd2wtPmhpZl9mdW5jLT5l
bmFibGVfaW50ZXJydXB0ICYmDQogCQkgICAgd2wtPmhpZl9mdW5jLT5lbmFibGVfaW50ZXJydXB0
KHdsKSkgew0KQEAgLTU5Niw3ICs1OTYsNyBAQCBzdGF0aWMgaW50IHdpbGNfd2xhbl9pbml0aWFs
aXplKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIHN0cnVjdCB3aWxjX3ZpZiAqdmlmKQ0KIGZhaWxf
aXJxX2luaXQ6DQogCQlpZiAod2wtPmRldl9pcnFfbnVtKQ0KIAkJCWRlaW5pdF9pcnEoZGV2KTsN
Ci0NCitmYWlsX3RocmVhZHM6DQogCQl3bGFuX2RlaW5pdGlhbGl6ZV90aHJlYWRzKGRldik7DQog
ZmFpbF93aWxjX3dsYW46DQogCQl3aWxjX3dsYW5fY2xlYW51cChkZXYpOw0KLS0gDQoyLjcuNA0K
DQo=

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA45746126
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 16:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbfFNOmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 10:42:25 -0400
Received: from mail-eopbgr720064.outbound.protection.outlook.com ([40.107.72.64]:48082
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727560AbfFNOmZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 10:42:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSS2WnNtLKX5nm9AtU2dd6wZz/T66Qzau2ddoL0MMuY=;
 b=iU0D099Th3u0RUqj9wnhvXhe58BiJKlS1GagKx5JtOWXzX+tZ7w9uK0kRca2H4FpPjuBwEJsRHDfXK9sXYtfa3R2cfxMAmV6LJmSwjcbZlXbumGneJrcuRXlt7GxlbEGzU9U0Xpcz0mdhH3TKhB5s2m+yv+7CjbnSBIe9DgA16s=
Received: from MN2PR05MB6208.namprd05.prod.outlook.com (20.178.241.91) by
 MN2PR05MB6160.namprd05.prod.outlook.com (20.178.241.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Fri, 14 Jun 2019 14:41:39 +0000
Received: from MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::ed54:e8f8:b67e:96]) by MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::ed54:e8f8:b67e:96%4]) with mapi id 15.20.2008.002; Fri, 14 Jun 2019
 14:41:39 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     "aarcange@redhat.com" <aarcange@redhat.com>,
        "jannh@google.com" <jannh@google.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "rppt@linux.ibm.com" <rppt@linux.ibm.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "mhocko@suse.com" <mhocko@suse.com>
CC:     "yishaih@mellanox.com" <yishaih@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "sean.hefty@intel.com" <sean.hefty@intel.com>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
        "matanb@mellanox.com" <matanb@mellanox.com>,
        "leonro@mellanox.com" <leonro@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [v4.14.y] infiniband: fix race condition between
 infiniband mlx4, mlx5  driver and core dumping
Thread-Topic: [PATCH] [v4.14.y] infiniband: fix race condition between
 infiniband mlx4, mlx5  driver and core dumping
Thread-Index: AQHVH4tRRHVVOX8JAkClk28/bWguy6abm6mA
Date:   Fri, 14 Jun 2019 14:41:39 +0000
Message-ID: <9C189085-083D-46EA-98DB-B11AD62051B6@vmware.com>
References: <1560199937-23476-1-git-send-email-akaher@vmware.com>
In-Reply-To: <1560199937-23476-1-git-send-email-akaher@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [103.19.212.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed3d0317-a463-4637-8d51-08d6f0d668ea
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR05MB6160;
x-ms-traffictypediagnostic: MN2PR05MB6160:
x-microsoft-antispam-prvs: <MN2PR05MB6160415D5AFAA7730EC7A709BBEE0@MN2PR05MB6160.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(396003)(136003)(346002)(376002)(189003)(199004)(6506007)(73956011)(2906002)(36756003)(186003)(14444005)(256004)(6512007)(25786009)(6246003)(91956017)(99286004)(7736002)(305945005)(6436002)(2616005)(476003)(6116002)(3846002)(4326008)(446003)(11346002)(102836004)(26005)(68736007)(81156014)(8676002)(110136005)(54906003)(76116006)(478600001)(316002)(229853002)(86362001)(2201001)(8936002)(71190400001)(71200400001)(14454004)(7416002)(5660300002)(66066001)(53936002)(66556008)(66446008)(64756008)(6486002)(66946007)(2501003)(33656002)(81166006)(486006)(76176011)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6160;H:MN2PR05MB6208.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H/PsLn65G6/iGZG0FErQsMPFAfh8AylKzUm3mw8BoE1NiDtuK/6M+MJO90yHGU1IuTlN8VVlalKxL7Ie9ua3VVmOOYPEC47s7Qrot0fNRLTQs/gmYnmK+D/uhw9em4YMF9HqmpHZ9e/jcpc7DhK9ASsjH4QYk7UVi6IASibZpLTBPKc2JHgvxbZwpJ87JDyaHcxm3FUFIWWvctvq1Ias03MqccBw/lRhiq2EVfUJNPDNQwt52PneGod6kSANLsGehcKbDada8LSAK5iLpLiCjz9h7bRK6DLCcjGh1+Yy534cFrRc+QtZz4ZZvqoRoUq4vhYdQk8AeGpRotVyI8PNhCh+YP4iLJDiwzpBX+rL2ns/LTF6YGOu+B14JELAIfFKxF/xWXSWrWsKaZ1xIbfrAULxlNLLaLRXdPLJXNg9mDM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <13955127BE722040A2F36BA3306CE790@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed3d0317-a463-4637-8d51-08d6f0d668ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 14:41:39.1794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: akaher@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6160
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQrvu79PbiAxMC8wNi8xOSwgNjoyMiBQTSwgIkFqYXkgS2FoZXIiIDxha2FoZXJAdm13YXJlLmNv
bT4gd3JvdGU6DQoNCj4gVGhpcyBwYXRjaCBpcyB0aGUgZXh0ZW5zaW9uIG9mIGZvbGxvd2luZyB1
cHN0cmVhbSBjb21taXQgdG8gZml4DQo+IHRoZSByYWNlIGNvbmRpdGlvbiBiZXR3ZWVuIGdldF90
YXNrX21tKCkgYW5kIGNvcmUgZHVtcGluZw0KPiBmb3IgSUItPm1seDQgYW5kIElCLT5tbHg1IGRy
aXZlcnM6DQo+IA0KPiBjb21taXQgMDRmNTg2NmU0MWZiICgiY29yZWR1bXA6IGZpeCByYWNlIGNv
bmRpdGlvbiBiZXR3ZWVuDQo+IG1tZ2V0X25vdF96ZXJvKCkvZ2V0X3Rhc2tfbW0oKSBhbmQgY29y
ZSBkdW1waW5nIiknDQo+ICAgIA0KPiBUaGFua3MgdG8gSmFzb24gZm9yIHBvaW50aW5nIHRoaXMu
DQo+ICAgIA0KPiBTaWduZWQtb2ZmLWJ5OiBBamF5IEthaGVyIDxha2FoZXJAdm13YXJlLmNvbT4N
Cj4gQWNrZWQtYnk6IEphc29uIEd1bnRob3JwZSA8amdnQG1lbGxhbm94LmNvbT4NCg0KR3JlZywg
SSBob3BlIHlvdSB3b3VsZCBsaWtlIHRvIHJldmlldyBhbmQgcHJvY2VlZCBmdXJ0aGVyIHdpdGgg
dGhpcyBwYXRjaC4gIA0KDQo+IC0tLQ0KPiBkcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NC9tYWlu
LmMgfCA0ICsrKy0NCj4gZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvbWFpbi5jIHwgMyArKysN
Cj4gMiBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gICAg
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NC9tYWluLmMgYi9kcml2
ZXJzL2luZmluaWJhbmQvaHcvbWx4NC9tYWluLmMNCj4gaW5kZXggZTJiZWIxOC4uMDI5OWMwNiAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDQvbWFpbi5jDQo+ICsrKyBi
L2RyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg0L21haW4uYw0KPiBAQCAtMTE5Nyw2ICsxMTk3LDgg
QEAgc3RhdGljIHZvaWQgbWx4NF9pYl9kaXNhc3NvY2lhdGVfdWNvbnRleHQoc3RydWN0IGliX3Vj
b250ZXh0ICppYmNvbnRleHQpDQo+ICAJICogbWx4NF9pYl92bWFfY2xvc2UoKS4NCj4gIAkgKi8N
Cj4gIAlkb3duX3dyaXRlKCZvd25pbmdfbW0tPm1tYXBfc2VtKTsNCj4gKwlpZiAoIW1tZ2V0X3N0
aWxsX3ZhbGlkKG93bmluZ19tbSkpDQo+ICsJCWdvdG8gc2tpcF9tbTsNCj4gIAlmb3IgKGkgPSAw
OyBpIDwgSFdfQkFSX0NPVU5UOyBpKyspIHsNCj4gIAkJdm1hID0gY29udGV4dC0+aHdfYmFyX2lu
Zm9baV0udm1hOw0KPiAgCQlpZiAoIXZtYSkNCj4gIEBAIC0xMjE1LDcgKzEyMTcsNyBAQCBzdGF0
aWMgdm9pZCBtbHg0X2liX2Rpc2Fzc29jaWF0ZV91Y29udGV4dChzdHJ1Y3QgaWJfdWNvbnRleHQg
KmliY29udGV4dCkNCj4gIAkJLyogY29udGV4dCBnb2luZyB0byBiZSBkZXN0cm95ZWQsIHNob3Vs
ZCBub3QgYWNjZXNzIG9wcyBhbnkgbW9yZSAqLw0KPiAgCQljb250ZXh0LT5od19iYXJfaW5mb1tp
XS52bWEtPnZtX29wcyA9IE5VTEw7DQo+ICAJfQ0KPiAtDQo+ICtza2lwX21tOg0KPiAJdXBfd3Jp
dGUoJm93bmluZ19tbS0+bW1hcF9zZW0pOw0KPiAgCW1tcHV0KG93bmluZ19tbSk7DQo+IAlwdXRf
dGFza19zdHJ1Y3Qob3duaW5nX3Byb2Nlc3MpOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZp
bmliYW5kL2h3L21seDUvbWFpbi5jIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvbWFpbi5j
DQo+IGluZGV4IDEzYTkyMDYuLjNmYmUzOTYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvaW5maW5p
YmFuZC9ody9tbHg1L21haW4uYw0KPiArKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9t
YWluLmMNCj4gQEAgLTE2NDYsNiArMTY0Niw4IEBAIHN0YXRpYyB2b2lkIG1seDVfaWJfZGlzYXNz
b2NpYXRlX3Vjb250ZXh0KHN0cnVjdCBpYl91Y29udGV4dCAqaWJjb250ZXh0KQ0KPiAgCSAqIG1s
eDVfaWJfdm1hX2Nsb3NlLg0KPiAgCSAqLw0KPiAgCWRvd25fd3JpdGUoJm93bmluZ19tbS0+bW1h
cF9zZW0pOw0KPiArCWlmICghbW1nZXRfc3RpbGxfdmFsaWQob3duaW5nX21tKSkNCj4gKwkJZ290
byBza2lwX21tOw0KPiAgCW11dGV4X2xvY2soJmNvbnRleHQtPnZtYV9wcml2YXRlX2xpc3RfbXV0
ZXgpOw0KPiAgCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZSh2bWFfcHJpdmF0ZSwgbiwgJmNvbnRl
eHQtPnZtYV9wcml2YXRlX2xpc3QsDQo+ICAJCQkJIGxpc3QpIHsNCj4gQEAgLTE2NjIsNiArMTY2
NCw3IEBAIHN0YXRpYyB2b2lkIG1seDVfaWJfZGlzYXNzb2NpYXRlX3Vjb250ZXh0KHN0cnVjdCBp
Yl91Y29udGV4dCAqaWJjb250ZXh0KQ0KPiAgCQlrZnJlZSh2bWFfcHJpdmF0ZSk7DQo+ICAJfQ0K
PiAgCW11dGV4X3VubG9jaygmY29udGV4dC0+dm1hX3ByaXZhdGVfbGlzdF9tdXRleCk7DQo+ICtz
a2lwX21tOg0KPiAgCXVwX3dyaXRlKCZvd25pbmdfbW0tPm1tYXBfc2VtKTsNCj4gIAltbXB1dChv
d25pbmdfbW0pOw0KPiAgCXB1dF90YXNrX3N0cnVjdChvd25pbmdfcHJvY2Vzcyk7DQo+IC0tIA0K
PiAyLjcuNA0KICAgIA0KICAgIA0KDQo=

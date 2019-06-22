Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B08764F3FF
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 08:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfFVGak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 02:30:40 -0400
Received: from mail-eopbgr810074.outbound.protection.outlook.com ([40.107.81.74]:22432
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726100AbfFVGaj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 02:30:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mjjC/lNp+jP0bTVidSvkZh8wfK69ohbkAcNlboC2oc=;
 b=gPbICuPI5YinXzLONwbI3J0LdoNQ1Ungag95yphiGGecDHDN9ElXUyh8RdjG0lCW52jamZoaheWCeBrSzukVzpuYhEcP3trtdl7EQmyGAHgMJmugzOtkVUyMGWf4XPtqneUJyXZ0Yl6Hje0ElSEh6A+LIq22j1cb1QpR6aZcDAA=
Received: from MN2PR05MB6208.namprd05.prod.outlook.com (20.178.241.91) by
 MN2PR05MB6350.namprd05.prod.outlook.com (20.178.245.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.12; Sat, 22 Jun 2019 06:30:37 +0000
Received: from MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::f4b2:4f83:7076:ffbf]) by MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::f4b2:4f83:7076:ffbf%6]) with mapi id 15.20.2008.007; Sat, 22 Jun 2019
 06:30:37 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Michal Hocko <mhocko@kernel.org>
CC:     "Stable tree ," <stable@vger.kernel.org>,
        "Jason Gunthorpe ," <jgg@mellanox.com>,
        "linux-mm@kvack.org, LKML ," <linux-kernel@vger.kernel.org>,
        "Andrea Arcangeli ," <aarcange@redhat.com>,
        "Jann Horn ," <jannh@google.com>,
        "Oleg Nesterov ," <oleg@redhat.com>,
        "Peter Xu ," <peterx@redhat.com>,
        "Mike Rapoport ," <rppt@linux.ibm.com>,
        "Michal Hocko ," <mhocko@suse.com>,
        "Andrew Morton ," <akpm@linux-foundation.org>,
        "Linus Torvalds ," <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH stable-4.4 v3] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Thread-Topic: [PATCH stable-4.4 v3] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Thread-Index: AQHVKMP9M9AlE9hN9EW8WcihMlSxEQ==
Date:   Sat, 22 Jun 2019 06:30:37 +0000
Message-ID: <66C05D07-4075-400D-832C-C82120C93922@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [27.59.36.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68b8202c-7700-4c83-8b13-08d6f6db236a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR05MB6350;
x-ms-traffictypediagnostic: MN2PR05MB6350:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR05MB6350093010401C8AF7619526BBE60@MN2PR05MB6350.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0076F48C8A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(366004)(376002)(136003)(199004)(189003)(66946007)(66476007)(2616005)(91956017)(76116006)(6306002)(102836004)(64756008)(66556008)(71190400001)(73956011)(36756003)(26005)(6116002)(66446008)(5660300002)(71200400001)(86362001)(6506007)(68736007)(256004)(4744005)(53936002)(8936002)(6486002)(3846002)(966005)(14454004)(486006)(478600001)(54906003)(2906002)(476003)(229853002)(110136005)(7416002)(25786009)(81156014)(6246003)(186003)(7736002)(316002)(6512007)(33656002)(66066001)(81166006)(6436002)(305945005)(99286004)(8676002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6350;H:MN2PR05MB6208.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3VBpGso3BboRzbtKYP5TEO9BAz7cqNEXk0+snzHOBKvBu2YdTQTRm2QT7B8FetVsG0VuEZxu0KYsegcUlSmvVUi9QGtCw/+husVrsH1t0pRM1gfwnfkakkct8knNJtMwYfqjKERuDfqKDhL3tCkuSIcMjF2yr0jYNexPkJnhVaUcgzRMIPnCuc1xvkmiZN4HZ8VXzomr4BLTgKWQ8X3VXDi5lhgBRKgQVzzLxgEWHbiwc3emVH7bwesbC0fMUWIjRZFuDor1IO3jYc0fFW/aufv1yNW2Y9hhpqp7Is7n/JnV865ARGDg3B5axfah/dDknt/3kuxMzwCkJ7n4wVXuqSJr4J2YUIso2punOOHc0Xi6ytXl58h7PyoQdoJWRb1S9MPkCD69y5AcuJ4S+h59FmllFRaN0v1hGVgzAlaJyrU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9227D5D87AF62438B0DFFFEE128F82D@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68b8202c-7700-4c83-8b13-08d6f6db236a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2019 06:30:37.0330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: akaher@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6350
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQo+IE9uIE1vbiwgSnVuIDE3LCAyMDE5IGF0IDA4OjU4OjI0QU0gKzAyMDAsIE1pY2hhbCBIb2Nr
byB3cm90ZToNCj4gPiBGcm9tOiBBbmRyZWEgQXJjYW5nZWxpIDxhYXJjYW5nZUByZWRoYXQuY29t
Pg0KPiA+IA0KPiA+IFVwc3RyZWFtIDA0ZjU4NjZlNDFmYjcwNjkwZTI4Mzk3NDg3ZDhiZDhlZWE3
ZDcxMmEgY29tbWl0Lg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IE1pY2hhbCBIb2NrbyA8bWhv
Y2tvQHN1c2UuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL2FuZHJvaWQvYmluZGVyLmMgICAg
ICAgICAgfCAgNiArKysrKysNCj4gPiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDQvbWFpbi5j
IHwgIDMgKysrDQo+ID4gIGZzL3Byb2MvdGFza19tbXUuYyAgICAgICAgICAgICAgICB8IDE4ICsr
KysrKysrKysrKysrKysrKw0KPiA+ICBmcy91c2VyZmF1bHRmZC5jICAgICAgICAgICAgICAgICAg
fCAxMCArKysrKysrKy0tDQo+ID4gIGluY2x1ZGUvbGludXgvbW0uaCAgICAgICAgICAgICAgICB8
IDIxICsrKysrKysrKysrKysrKysrKysrKw0KPiA+ICBtbS9tbWFwLmMgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgNyArKysrKystDQo+ID4gIDYgZmlsZXMgY2hhbmdlZCwgNjIgaW5zZXJ0aW9u
cygrKSwgMyBkZWxldGlvbnMoLSkNCj4NCj4gSSd2ZSBxdWV1ZWQgdGhpcyB1cCBub3csIGFzIGl0
IGxvb2tzIGxpa2UgZXZlcnlvbmUgYWdyZWVzIHdpdGggaXQuICBXaGF0DQo+IGFib3V0IGEgNC45
LnkgYmFja3BvcnQ/DQoNCkdyZWcsIGl0J3MgaGVyZSBwbGVhc2UgcmV2aWV3Lg0KaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvc3RhYmxlLzE1NjEyMDg1MzktMjk2ODItMS1naXQtc2VuZC1lbWFpbC1h
a2FoZXJAdm13YXJlLmNvbS9ULyNtNTNlYWY2ZTY4N2NiMjdlNDYzOTUxNzNhYTc0YTg1YzJjY2I1
YzE5MA0KDQpNaWNoYWwsIHBhdGNoZWQgZm9yIGJpbmRlciBjb2RlIFRoYW5rcywgd291bGQgeW91
IGxpa2UgdG8gc3VnZ2VzdCANCmlmIG1tZ2V0X3N0aWxsX3ZhbGlkIGNoZWNrIHJlcXVpcmUgYW55
d2hlcmUgZm9yIGtodWdlcGFnZWQgY29kZS4NCg0KPiB0aGFua3MsDQo+IGdyZWcgay1oDQoNCg0K

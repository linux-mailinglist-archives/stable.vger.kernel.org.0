Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273AA37191
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 12:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfFFKZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 06:25:29 -0400
Received: from mail-eopbgr780054.outbound.protection.outlook.com ([40.107.78.54]:51386
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726952AbfFFKZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 06:25:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPyrRpBKIvHQ2fpjCGSuNhDO2lLh1UqzN5g4aMBY4QM=;
 b=zkcTKz27FEMm8zK5mQf5uPGshGFmiZ1PHqCITU0asgfLwWnexTlysSuoAdSWLs77bg3j9GQxlBN8N737No2dvbQPvvcX0Ettp/jUuVwMzWzqgGGBYgzo2Aes7R7511KjEnYdGwn6sO6X457Bs3a8i/g5FR6rNig3mH6rmwsVpzI=
Received: from MN2PR05MB6208.namprd05.prod.outlook.com (20.178.241.91) by
 MN2PR05MB6221.namprd05.prod.outlook.com (20.178.240.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 10:25:23 +0000
Received: from MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::fc2c:24b8:4047:a9a0]) by MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::fc2c:24b8:4047:a9a0%2]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 10:25:23 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
CC:     "aarcange@redhat.com" <aarcange@redhat.com>,
        "jannh@google.com" <jannh@google.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "rppt@linux.ibm.com" <rppt@linux.ibm.com>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/1] [v4.9.y] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Thread-Topic: [PATCH 1/1] [v4.9.y] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Thread-Index: AQHVEJKsDwy9S0VSH0qGIlGjrsAD56Z3DMGAgBfSlQA=
Date:   Thu, 6 Jun 2019 10:25:23 +0000
Message-ID: <DE6BE512-F3CF-4847-BED0-EE2FCC31DCED@vmware.com>
References: <1558553850-27745-1-git-send-email-akaher@vmware.com>
 <20190522120733.GB6039@mellanox.com>
In-Reply-To: <20190522120733.GB6039@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [103.19.212.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ee9ee2a-acc1-494d-6073-08d6ea6948f5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR05MB6221;
x-ms-traffictypediagnostic: MN2PR05MB6221:
x-ms-exchange-purlcount: 2
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-microsoft-antispam-prvs: <MN2PR05MB6221EA844140B564939F870EBB170@MN2PR05MB6221.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(39860400002)(136003)(376002)(396003)(199004)(189003)(71200400001)(71190400001)(2906002)(45080400002)(83716004)(14454004)(446003)(6512007)(229853002)(53936002)(186003)(6436002)(478600001)(7736002)(11346002)(486006)(14444005)(316002)(86362001)(256004)(476003)(2616005)(54906003)(6306002)(305945005)(33656002)(966005)(6246003)(8936002)(7416002)(66946007)(91956017)(73956011)(64756008)(66556008)(66476007)(6116002)(82746002)(6916009)(66446008)(68736007)(3846002)(81166006)(25786009)(4326008)(81156014)(102836004)(6486002)(36756003)(5660300002)(99286004)(76176011)(8676002)(66066001)(26005)(76116006)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6221;H:MN2PR05MB6208.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0xQwgj2aCunnnQOCAqhIZdP2DKXZHcZLGy/9GOikAE+8I7m8IintJahR5xQVhn73UQPAxCzzjBwwrOEtnuJ4k9+4Bm/lkh9qSFFVdMyzMiVcvgvcbm3En5HShSPEX3Ei0HFHD9tdSuTR5TORKdbjhT2xxkyjp2pb9fsMGL+GA7r/CiOfFpzl4nxgnbIMEUzYNuLhxN6Eh7fC0gCRJVXBYcQGi3wQ7neTs5j4fALfB1klW9vtB/Ep+FPmXjq/iHDQhT0cBuLs8SM/3HTpjsr9UfqYSX6TO6BU5L0Twhml7PUk7rXRJwl1HU+fadJIFqXaSSONG/YkzXOwwCvd2+qmeMDPjbUvup+2DI2NwcDPX4qdMA6mvC1MlF+qDlQlE2Cj3FTFIYKgT0AyaQAl5oa1BC1H7nAwuiKnw3ZrIjOYJEo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <54C7915E6DBF8643A07BB4C7B3578E2B@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee9ee2a-acc1-494d-6073-08d6ea6948f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 10:25:23.4490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: akaher@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6221
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCu+7v09uIDIyLzA1LzE5LCA1OjM3IFBNLCAiSmFzb24gR3VudGhvcnBlIiA8amdnQG1lbGxh
bm94LmNvbT4gd3JvdGU6DQoNCj5PbiBUaHUsIE1heSAyMywgMjAxOSBhdCAwMTowNzozMEFNICsw
NTMwLCBBamF5IEthaGVyIHdyb3RlOg0KPj4gRnJvbTogQW5kcmVhIEFyY2FuZ2VsaSA8YWFyY2Fu
Z2VAcmVkaGF0LmNvbT4NCj4+IA0KPj4gY29tbWl0IDFlYjcxOWYwOWY3ZTMxOWU3OWY2YWJmMmI5
ZThjMGRjYzFjNDc3YjUgdXBzdHJlYW0uDQo+DQo+IFRoaXMgaXMgbm90IHRoZSByaWdodCBjb21t
aXQgaWQuLg0KSW4gbmV4dCB2ZXJzaW9uIG9mIHRoaXMgcGF0Y2ggSSB3aWxsIGFkZCB0aGUgY29y
cmVjdCBjb21taXQgaS5lLiAwNGY1ODY2ZTQxZmI3MDY5MGUyODM5NzQ4N2Q4YmQ4ZWVhN2Q3MTJh
IA0KPg0KPj4gVGhlIGNvcmUgZHVtcGluZyBjb2RlIGhhcyBhbHdheXMgcnVuIHdpdGhvdXQgaG9s
ZGluZyB0aGUgbW1hcF9zZW0gZm9yDQo+PiB3cml0aW5nLCBkZXNwaXRlIHRoYXQgaXMgdGhlIG9u
bHkgd2F5IHRvIGVuc3VyZSB0aGF0IHRoZSBlbnRpcmUgdm1hDQo+PiBsYXlvdXQgd2lsbCBub3Qg
Y2hhbmdlIGZyb20gdW5kZXIgaXQuICBPbmx5IHVzaW5nIHNvbWUgc2lnbmFsDQo+PiBzZXJpYWxp
emF0aW9uIG9uIHRoZSBwcm9jZXNzZXMgYmVsb25naW5nIHRvIHRoZSBtbSBpcyBub3QgbmVhcmx5
IGVub3VnaC4NCj4+IFRoaXMgd2FzIHBvaW50ZWQgb3V0IGVhcmxpZXIuICBGb3IgZXhhbXBsZSBp
biBIdWdoJ3MgcG9zdCBmcm9tIEp1bCAyMDE3Og0KPj4gDQo+PiAgIGh0dHBzOi8vbmFtMDQuc2Fm
ZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRmxrbWwua2Vy
bmVsLm9yZyUyRnIlMkZhbHBpbmUuTFNVLjIuMTEuMTcwNzE5MTcxNjAzMC4yMDU1JTQwZWdnbHku
YW52aWxzJmFtcDtkYXRhPTAyJTdDMDElN0Nha2FoZXIlNDB2bXdhcmUuY29tJTdDYjQyZGQ1ZGVk
Zjk1NGI3ZGVmNTkwOGQ2ZGVhZTE3ZDklN0NiMzkxMzhjYTNjZWU0YjRhYTRkNmNkODNkOWRkNjJm
MCU3QzAlN0MwJTdDNjM2OTQxMjM2NjUwMjEwNDg4JmFtcDtzZGF0YT1jNDd2WEF2Z1JWMUdLV2RC
ZmZCeGowSThVZ0o3dm9RWElBN1VQRVVOcTU0JTNEJmFtcDtyZXNlcnZlZD0wDQo+PiANCj4+ICAg
Ik5vdCBzdHJpY3RseSByZWxldmFudCBoZXJlLCBidXQgYSByZWxhdGVkIG5vdGU6IEkgd2FzIHZl
cnkgc3VycHJpc2VkDQo+PiAgICAgdG8gZGlzY292ZXIsIG9ubHkgcXVpdGUgcmVjZW50bHksIGhv
dyBoYW5kbGVfbW1fZmF1bHQoKSBtYXkgYmUgY2FsbGVkDQo+PiAgICAgd2l0aG91dCBkb3duX3Jl
YWQobW1hcF9zZW0pIC0gd2hlbiBjb3JlIGR1bXBpbmcuIFRoYXQgc2VlbXMgYQ0KPj4gICAgIG1p
c2d1aWRlZCBvcHRpbWl6YXRpb24gdG8gbWUsIHdoaWNoIHdvdWxkIGFsc28gYmUgbmljZSB0byBj
b3JyZWN0Ig0KPj4gDQo+PiBJbiBwYXJ0aWN1bGFyIGJlY2F1c2UgdGhlIGdyb3dzZG93biBhbmQg
Z3Jvd3N1cCBjYW4gbW92ZSB0aGUNCj4+IHZtX3N0YXJ0L3ZtX2VuZCB0aGUgdmFyaW91cyBsb29w
cyB0aGUgY29yZSBkdW1wIGRvZXMgYXJvdW5kIHRoZSB2bWEgd2lsbA0KPj4gbm90IGJlIGNvbnNp
c3RlbnQgaWYgcGFnZSBmYXVsdHMgY2FuIGhhcHBlbiBjb25jdXJyZW50bHkuDQo+PiANCj4+IFBy
ZXR0eSBtdWNoIGFsbCB1c2VycyBjYWxsaW5nIG1tZ2V0X25vdF96ZXJvKCkvZ2V0X3Rhc2tfbW0o
KSBhbmQgdGhlbg0KPj4gdGFraW5nIHRoZSBtbWFwX3NlbSBoYWQgdGhlIHBvdGVudGlhbCB0byBp
bnRyb2R1Y2UgdW5leHBlY3RlZCBzaWRlDQo+PiBlZmZlY3RzIGluIHRoZSBjb3JlIGR1bXBpbmcg
Y29kZS4NCj4+IA0KPj4gQWRkaW5nIG1tYXBfc2VtIGZvciB3cml0aW5nIGFyb3VuZCB0aGUgLT5j
b3JlX2R1bXAgaW52b2NhdGlvbiBpcyBhDQo+PiB2aWFibGUgbG9uZyB0ZXJtIGZpeCwgYnV0IGl0
IHJlcXVpcmVzIHJlbW92aW5nIGFsbCBjb3B5IHVzZXIgYW5kIHBhZ2UNCj4+IGZhdWx0cyBhbmQg
dG8gcmVwbGFjZSB0aGVtIHdpdGggZ2V0X2R1bXBfcGFnZSgpIGZvciBhbGwgYmluYXJ5IGZvcm1h
dHMNCj4+IHdoaWNoIGlzIG5vdCBzdWl0YWJsZSBhcyBhIHNob3J0IHRlcm0gZml4Lg0KPj4gDQo+
PiBGb3IgdGhlIHRpbWUgYmVpbmcgdGhpcyBzb2x1dGlvbiBtYW51YWxseSBjb3ZlcnMgdGhlIHBs
YWNlcyB0aGF0IGNhbg0KPj4gY29uZnVzZSB0aGUgY29yZSBkdW1wIGVpdGhlciBieSBhbHRlcmlu
ZyB0aGUgdm1hIGxheW91dCBvciB0aGUgdm1hIGZsYWdzDQo+PiB3aGlsZSBpdCBydW5zLiAgT25j
ZSAtPmNvcmVfZHVtcCBydW5zIHVuZGVyIG1tYXBfc2VtIGZvciB3cml0aW5nIHRoZQ0KPj4gZnVu
Y3Rpb24gbW1nZXRfc3RpbGxfdmFsaWQoKSBjYW4gYmUgZHJvcHBlZC4NCj4+IA0KPj4gQWxsb3dp
bmcgbW1hcF9zZW0gcHJvdGVjdGVkIHNlY3Rpb25zIHRvIHJ1biBpbiBwYXJhbGxlbCB3aXRoIHRo
ZQ0KPj4gY29yZWR1bXAgcHJvdmlkZXMgc29tZSBtaW5vciBwYXJhbGxlbGlzbSBhZHZhbnRhZ2Ug
dG8gdGhlIHN3YXBvZmYgY29kZQ0KPj4gKHdoaWNoIHNlZW1zIHRvIGJlIHNhZmUgZW5vdWdoIGJ5
IG5ldmVyIG1hbmdsaW5nIGFueSB2bWEgZmllbGQgYW5kIGNhbg0KPj4ga2VlcCBkb2luZyBzd2Fw
aW5zIGluIHBhcmFsbGVsIHRvIHRoZSBjb3JlIGR1bXBpbmcpIGFuZCB0byBzb21lIG90aGVyDQo+
PiBjb3JuZXIgY2FzZS4NCj4+IA0KPj4gSW4gb3JkZXIgdG8gZmFjaWxpdGF0ZSB0aGUgYmFja3Bv
cnRpbmcgSSBhZGRlZCAiRml4ZXM6IDg2MDM5YmQzYjRlNiINCj4+IGhvd2V2ZXIgdGhlIHNpZGUg
ZWZmZWN0IG9mIHRoaXMgc2FtZSByYWNlIGNvbmRpdGlvbiBpbiAvcHJvYy9waWQvbWVtDQo+PiBz
aG91bGQgYmUgcmVwcm9kdWNpYmxlIHNpbmNlIGJlZm9yZSAyLjYuMTItcmMyIHNvIEkgY291bGRu
J3QgYWRkIGFueQ0KPj4gb3RoZXIgIkZpeGVzOiIgYmVjYXVzZSB0aGVyZSdzIG5vIGhhc2ggYmV5
b25kIHRoZSBnaXQgZ2VuZXNpcyBjb21taXQuDQo+PiANCj4+IEJlY2F1c2UgZmluZF9leHRlbmRf
dm1hKCkgaXMgdGhlIG9ubHkgbG9jYXRpb24gb3V0c2lkZSBvZiB0aGUgcHJvY2Vzcw0KPj4gY29u
dGV4dCB0aGF0IGNvdWxkIG1vZGlmeSB0aGUgIm1tIiBzdHJ1Y3R1cmVzIHVuZGVyIG1tYXBfc2Vt
IGZvcg0KPj4gcmVhZGluZywgYnkgYWRkaW5nIHRoZSBtbWdldF9zdGlsbF92YWxpZCgpIGNoZWNr
IHRvIGl0LCBhbGwgb3RoZXIgY2FzZXMNCj4+IHRoYXQgdGFrZSB0aGUgbW1hcF9zZW0gZm9yIHJl
YWRpbmcgZG9uJ3QgbmVlZCB0aGUgbmV3IGNoZWNrIGFmdGVyDQo+PiBtbWdldF9ub3RfemVybygp
L2dldF90YXNrX21tKCkuICBUaGUgZXhwYW5kX3N0YWNrKCkgaW4gcGFnZSBmYXVsdA0KPj4gY29u
dGV4dCBhbHNvIGRvZXNuJ3QgbmVlZCB0aGUgbmV3IGNoZWNrLCBiZWNhdXNlIGFsbCB0YXNrcyB1
bmRlciBjb3JlDQo+PiBkdW1waW5nIGFyZSBmcm96ZW4uDQo+PiANCj4+IExpbms6IGh0dHBzOi8v
bmFtMDQuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwJTNBJTJGJTJG
bGttbC5rZXJuZWwub3JnJTJGciUyRjIwMTkwMzI1MjI0OTQ5LjExMDY4LTEtYWFyY2FuZ2UlNDBy
ZWRoYXQuY29tJmFtcDtkYXRhPTAyJTdDMDElN0Nha2FoZXIlNDB2bXdhcmUuY29tJTdDYjQyZGQ1
ZGVkZjk1NGI3ZGVmNTkwOGQ2ZGVhZTE3ZDklN0NiMzkxMzhjYTNjZWU0YjRhYTRkNmNkODNkOWRk
NjJmMCU3QzAlN0MwJTdDNjM2OTQxMjM2NjUwMjIwNDg4JmFtcDtzZGF0YT1uSjdhOCUyRkxrU1U0
ZVQlMkZpb1VxZjh0ajJld3pKS2N5cmcyUjBaakdXRVp6QSUzRCZhbXA7cmVzZXJ2ZWQ9MA0KPj4g
Rml4ZXM6IDg2MDM5YmQzYjRlNiAoInVzZXJmYXVsdGZkOiBhZGQgbmV3IHN5c2NhbGwgdG8gcHJv
dmlkZSBtZW1vcnkgZXh0ZXJuYWxpemF0aW9uIikNCj4+IFNpZ25lZC1vZmYtYnk6IEFuZHJlYSBB
cmNhbmdlbGkgPGFhcmNhbmdlQHJlZGhhdC5jb20+DQo+PiBSZXBvcnRlZC1ieTogSmFubiBIb3Ju
IDxqYW5uaEBnb29nbGUuY29tPg0KPj4gU3VnZ2VzdGVkLWJ5OiBPbGVnIE5lc3Rlcm92IDxvbGVn
QHJlZGhhdC5jb20+DQo+PiBBY2tlZC1ieTogUGV0ZXIgWHUgPHBldGVyeEByZWRoYXQuY29tPg0K
Pj4gUmV2aWV3ZWQtYnk6IE1pa2UgUmFwb3BvcnQgPHJwcHRAbGludXguaWJtLmNvbT4NCj4+IFJl
dmlld2VkLWJ5OiBPbGVnIE5lc3Rlcm92IDxvbGVnQHJlZGhhdC5jb20+DQo+PiBSZXZpZXdlZC1i
eTogSmFubiBIb3JuIDxqYW5uaEBnb29nbGUuY29tPg0KPj4gQWNrZWQtYnk6IEphc29uIEd1bnRo
b3JwZSA8amdnQG1lbGxhbm94LmNvbT4NCj4+IEFja2VkLWJ5OiBNaWNoYWwgSG9ja28gPG1ob2Nr
b0BzdXNlLmNvbT4NCj4+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCj4+IFNpZ25lZC1v
ZmYtYnk6IEFuZHJldyBNb3J0b24gPGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+DQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+
DQo+PiBTaWduZWQtb2ZmLWJ5OiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5k
YXRpb24ub3JnPg0KPj4gW0FqYXk6IERyb3BwZWQgaW5maW5pYmFuZCBjaGFuZ2VzIHRvIGdldCBw
YXRjaCB0byBhcHBseSBvbiA0LjkueV0NCj4NCj4gSSB0aGluayBpbiB0aGlzIGtlcm5lbCB0aGUg
bW0gaGFuZGxpbmcgY29kZSBmb3IgSUIgaXMgaW4gdGhyZWUNCj4gZGlmZmVyZW50IGRyaXZlcnMs
IGl0IHByb2JhYmx5IG5lZWRzIHRvIGJlIGZpeGVkIHRvbz8NCg0KVGhhbmtzIEphc29uIGZvciBw
b2ludGluZyB0aGlzLg0KICANCkNyb3NzZWQgY2hlY2tlZCB0aGUgbG9ja2luZyBvZiBtbWFwX3Nl
bSBpbiBJQiBkcml2ZXIgY29kZSBvZiA0LjkgdG8gNC4xNCB3aXRoID41LjANCmFuZCBmb3VuZCBp
dCByZXF1aXJlcyB0byBoYW5kbGUgYXQgZm9sbG93aW5nIGxvY2F0aW9ucyBvZiA0LjkgYW5kIDQu
MTQ6DQptbHg0X2liX2Rpc2Fzc29jaWF0ZV91Y29udGV4dCgpIG9mIGRyaXZlcnMvaW5maW5pYmFu
ZC9ody9tbHg1L21haW4uYzoNCm1seDVfaWJfZGlzYXNzb2NpYXRlX3Vjb250ZXh0KCkgb2YgZHJp
dmVycy9pbmZpbmliYW5kL2h3L21seDQvbWFpbi5jDQoNClRvIGZpeCBhdCBhYm92ZSBsb2NhdGlv
biwgd291bGQgeW91IGxpa2UgbWUgdG8gbW9kaWZ5IHRoZSBvcmlnaW5hbCBwYXRjaCBvciBzdWJt
aXQgaW4gYW5vdGhlciBwYXRjaC4NCg0KQWpheQ0KDQo+IEphc29uDQoNCg0K

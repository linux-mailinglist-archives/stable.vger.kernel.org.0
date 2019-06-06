Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D479937D68
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 21:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfFFTm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 15:42:26 -0400
Received: from mail-eopbgr710041.outbound.protection.outlook.com ([40.107.71.41]:58368
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726697AbfFFTmZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 15:42:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptGQkAb4bWbtSN8BP3oURGNkwJaEs2OAxlwtlFfplkQ=;
 b=ZRmSoUY4mz8+F9AD8oQX0pYiQ75tRI5doVUDsD256Uy0wm/Z8au91iuie1vdZ07f5wXmBD4D7Y1hPtbqkWCdCPPYZ1xenLM/WkW4QFybzWOALBqnjhdmL0lhMIBhEAGvtnTpCWlUcWbD6HpGzB6FJbtyop9AJJj+y03Z+GRFAos=
Received: from MN2PR05MB6208.namprd05.prod.outlook.com (20.178.241.91) by
 MN2PR05MB6703.namprd05.prod.outlook.com (20.178.249.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 19:42:21 +0000
Received: from MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::fc2c:24b8:4047:a9a0]) by MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::fc2c:24b8:4047:a9a0%2]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 19:42:21 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     Michal Hocko <mhocko@kernel.org>
CC:     Stable tree <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Srivatsa Bhat <srivatsab@vmware.com>
Subject: Re: [RFC PATCH stable-4.4] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Thread-Topic: [RFC PATCH stable-4.4] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Thread-Index: AQHVHJ/0ITirHCq2DkaXsMkoZ1TuYw==
Date:   Thu, 6 Jun 2019 19:42:20 +0000
Message-ID: <5756B041-C0A8-4178-9F5B-7CBF7A554E31@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [2401:4900:3311:e32e:40b3:dd71:b60:71c9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11c9e4b0-efc3-4dea-e448-08d6eab7174f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR05MB6703;
x-ms-traffictypediagnostic: MN2PR05MB6703:
x-microsoft-antispam-prvs: <MN2PR05MB6703BA1F73E6460BFB7E2FCFBB170@MN2PR05MB6703.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(478600001)(486006)(4326008)(66946007)(46003)(316002)(476003)(186003)(14444005)(6116002)(6916009)(102836004)(53936002)(256004)(14454004)(25786009)(86362001)(83716004)(2906002)(6506007)(7416002)(54906003)(71200400001)(71190400001)(81156014)(33656002)(99286004)(2616005)(6512007)(68736007)(8676002)(73956011)(64756008)(76116006)(66446008)(305945005)(36756003)(66556008)(7736002)(5660300002)(66476007)(229853002)(107886003)(6486002)(82746002)(6246003)(81166006)(8936002)(6436002)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6703;H:MN2PR05MB6208.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SosFWyNtuQTqWPRcXv+U7rmCfdaX8rqjjuLPoH0J/CCHP5RZMh5ge8QQYtCbsAe2tgZtqFRDXE+Izpce0GxgWKuM/BWn7GP/3Yj04cL5LiUxbfcO65t3SG/b0/k8wv1q0j7yMiwawHTIYiBksgQWe2jap5JazchZMin3Txs1fYYU215Tn8k6i3d1ZiSXSGznD2GI9I46zmycIO3o9h1n+dJ/0jl+Eh0c7vsrpVDE+ZzXYjJKU6BHR5Cu39RNip/EqvjPCHmQIscdFHyZ7yh6hib2X27MfL6IDeQbdb2QDB/iLn35pvGBaRG6Lis2meTIfimNJQxtM7QSfHsMd9yDeBQJF+XLi9ZGa5hR4Ds/QGyDWXrfavFNykR0dUd6mtSsqr5s3hM5JHEWR+Ai1O/VzxQd1tH5MtZohIDK2GEIQ3A=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D37DEB9F3DAB484E8D5A6904E695BC12@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11c9e4b0-efc3-4dea-e448-08d6eab7174f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 19:42:20.9101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: akaher@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6703
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQo+IEZyb206IEFuZHJlYSBBcmNhbmdlbGkgPGFhcmNhbmdlQHJlZGhhdC5jb20+DQo+DQo+IFVw
c3RyZWFtIDA0ZjU4NjZlNDFmYjcwNjkwZTI4Mzk3NDg3ZDhiZDhlZWE3ZDcxMmEgY29tbWl0Lg0K
Pg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWwgSG9ja28gPG1ob2Nrb0BzdXNlLmNvbT4NCj4g
LS0tDQo+IEhpLA0KPiB0aGlzIGlzIGJhc2VkIG9uIHRoZSBiYWNrcG9ydCBJIGhhdmUgZG9uZSBm
b3Igb3V0IDQuNCBiYXNlZCBkaXN0cmlidXRpb24NCj4ga2VybmVsLiBQbGVhc2UgZG91YmxlIGNo
ZWNrIHRoYXQgSSBoYXZlbid0IG1pc3NlZCBhbnl0aGluZyBiZWZvcmUNCj4gYXBwbHlpbmcgdG8g
dGhlIHN0YWJsZSB0cmVlLiBJIGhhdmUgYWxzbyBDQ2VkIEpvZWwgZm9yIHRoZSBiaW5kZXIgcGFy
dA0KPiB3aGljaCBpcyBub3QgaW4gdGhlIGN1cnJlbnQgdXBzdHJlYW0gYW55bW9yZSBidXQgSSBi
ZWxpZXZlIGl0IG5lZWRzIHRoZQ0KPiBjaGVjayBhcyB3ZWxsLg0KPg0KPiBSZXZpZXcgZmVlZGJh
Y2sgd2VsY29tZS4NCj4NCj4gZHJpdmVycy9hbmRyb2lkL2JpbmRlci5jIHwgIDYgKysrKysrDQo+
IGZzL3Byb2MvdGFza19tbXUuYyAgICAgICB8IDE4ICsrKysrKysrKysrKysrKysrKw0KPiBmcy91
c2VyZmF1bHRmZC5jICAgICAgICAgfCAxMCArKysrKysrKy0tDQo+IGluY2x1ZGUvbGludXgvbW0u
aCAgICAgICB8IDIxICsrKysrKysrKysrKysrKysrKysrKw0KPiBtbS9odWdlX21lbW9yeS5jICAg
ICAgICAgfCAgMiArLQ0KPiBtbS9tbWFwLmMgICAgICAgICAgICAgICAgfCAgNyArKysrKystDQo+
IDYgZmlsZXMgY2hhbmdlZCwgNjAgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4NCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYW5kcm9pZC9iaW5kZXIuYyBiL2RyaXZlcnMvYW5kcm9pZC9i
aW5kZXIuYw0KPiBpbmRleCAyNjBjZTBlNjAxODcuLjFmYjFjZGRiZDE5YSAxMDA2NDQNCj4gLS0t
IGEvZHJpdmVycy9hbmRyb2lkL2JpbmRlci5jDQo+ICsrKyBiL2RyaXZlcnMvYW5kcm9pZC9iaW5k
ZXIuYw0KPiBAQCAtNTcwLDYgKzU3MCwxMiBAQCBzdGF0aWMgaW50IGJpbmRlcl91cGRhdGVfcGFn
ZV9yYW5nZShzdHJ1Y3QgYmluZGVyX3Byb2MgKnByb2MsIGludCBhbGxvY2F0ZSwNCj4gDQo+IAlp
ZiAobW0pIHsNCj4gCQlkb3duX3dyaXRlKCZtbS0+bW1hcF9zZW0pOw0KPiArCQlpZiAoIW1tZ2V0
X3N0aWxsX3ZhbGlkKG1tKSkgew0KPiArCQkJaWYgKGFsbG9jYXRlID09IDApDQo+ICsJCQkJZ290
byBmcmVlX3JhbmdlOw0KDQpQbGVhc2UgY3Jvc3MgY2hlY2ssIGZyZWVfcmFuZ2U6IHNob3VsZCBu
b3QgZW5kLXVwIHdpdGggbW9kaWZpY2F0aW9ucyBpbiB2bWEuDQogDQo+ICsJCQlnb3RvIGVycl9u
b192bWE7DQo+ICsJCX0NCj4gKw0KPiAJCXZtYSA9IHByb2MtPnZtYTsNCj4gCQlpZiAodm1hICYm
IG1tICE9IHByb2MtPnZtYV92bV9tbSkgew0KPiAJCQlwcl9lcnIoIiVkOiB2bWEgbW0gYW5kIHRh
c2sgbW0gbWlzbWF0Y2hcbiIsDQoNCg0K

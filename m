Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3715652348
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 08:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbfFYGKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 02:10:45 -0400
Received: from mail-eopbgr710073.outbound.protection.outlook.com ([40.107.71.73]:58944
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbfFYGKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 02:10:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lo2788zc3ba6AQPBvrY7/wbULJd9YzLO/MZXNIg1XA0=;
 b=tfBA3FWovYHivYtV4EX+AXUXUnM4v76HXCZ6eQxjvsbsRO62V5Rb+B82TScsuAkje+AoR7ba6ufdCPfmUBSffhtPczF8CBp2XodhrCpLG0fsYB7H6DqGp4AU/4eYpr562Ld3OCw5tM+7GTaCMPRI5nBRiwjBb5bqu71Q9VvR3xo=
Received: from MN2PR05MB6208.namprd05.prod.outlook.com (20.178.241.91) by
 MN2PR05MB6432.namprd05.prod.outlook.com (20.178.249.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.12; Tue, 25 Jun 2019 06:10:40 +0000
Received: from MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::f4b2:4f83:7076:ffbf]) by MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::f4b2:4f83:7076:ffbf%6]) with mapi id 15.20.2008.007; Tue, 25 Jun 2019
 06:10:40 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "aarcange@redhat.com" <aarcange@redhat.com>,
        "jannh@google.com" <jannh@google.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "rppt@linux.ibm.com" <rppt@linux.ibm.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "jglisse@redhat.com" <jglisse@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "riandrews@android.com" <riandrews@android.com>,
        "arve@android.com" <arve@android.com>,
        "yishaih@mellanox.com" <yishaih@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "sean.hefty@intel.com" <sean.hefty@intel.com>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
        "matanb@mellanox.com" <matanb@mellanox.com>,
        "leonro@mellanox.com" <leonro@mellanox.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>
Subject: Re: [PATCH v4 0/3] [v4.9.y] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Thread-Topic: [PATCH v4 0/3] [v4.9.y] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Thread-Index: AQHVKo1iIUbk16XbJ0SDrOziR/ss8aarP80AgAEAroA=
Date:   Tue, 25 Jun 2019 06:10:40 +0000
Message-ID: <0EA7BFD6-ABA6-4008-B30F-20653114F34F@vmware.com>
References: <1561410186-3919-1-git-send-email-akaher@vmware.com>
 <1561410186-3919-4-git-send-email-akaher@vmware.com>
 <20190624202150.GC3881@sasha-vm>
In-Reply-To: <20190624202150.GC3881@sasha-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [103.19.212.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36e99abf-899a-4967-2e08-08d6f933d93c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR05MB6432;
x-ms-traffictypediagnostic: MN2PR05MB6432:
x-ms-exchange-purlcount: 1
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-microsoft-antispam-prvs: <MN2PR05MB643293A8AB84F8A7C3859EB4BBE30@MN2PR05MB6432.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(136003)(39860400002)(346002)(376002)(51344004)(199004)(189003)(66476007)(5660300002)(76116006)(6916009)(91956017)(966005)(73956011)(33656002)(66946007)(14454004)(66446008)(66556008)(36756003)(64756008)(7416002)(76176011)(256004)(99286004)(26005)(102836004)(6506007)(486006)(11346002)(478600001)(2616005)(476003)(446003)(6436002)(6116002)(3846002)(86362001)(8936002)(8676002)(229853002)(81166006)(81156014)(6486002)(186003)(66066001)(71200400001)(2906002)(4326008)(316002)(25786009)(6246003)(53936002)(305945005)(6306002)(7736002)(71190400001)(68736007)(54906003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6432;H:MN2PR05MB6208.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7C0X+nm7Rleca1jNZbcgVC5+kiFYKWHjJvaBFQWOTfBE8Uh5S2deK1ou1WjOhFcfLGxXDknePIo1gqzhNlqGhOtgbOaZI+jgRm/6xURpCTa+ONdh4xV91+svDCPtqnI1BQRDAn1QgV5kPvFVe0vs5ZkcddEBNt6hnWF3xM7u2G9INuoOdpL7hbS/qMYhMVbDvUuTPEam+gSM8X71/DevULJtTl0jikPt+MUiGh/B+DT0gB/qjmVlTbRjSPOl3IQrBh39vLZEdDh6iQP44bxM0jEm0VRuP50Vl8vns5g6XbAhl2mnxwsiWXguv7R7gWcPvq4NfCbZ170lvK+y7bgyy+OBKPWLk8cHPqyr8nvTMnQeksj8HwF3U1zEqTcdWyTcupcgwmCErTDQXWUTPkY5aj79zsgvz4JAWhwyBfzf9zM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FAB09C25F4BC4C40B101E9C6E4EFD2C4@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e99abf-899a-4967-2e08-08d6f933d93c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 06:10:40.0723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: akaher@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6432
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQrvu79PbiAyNS8wNi8xOSwgMTo1MSBBTSwgIlNhc2hhIExldmluIiA8c2FzaGFsQGtlcm5lbC5v
cmc+IHdyb3RlOg0KICAgIA0KPiBPbiBUdWUsIEp1biAyNSwgMjAxOSBhdCAwMjozMzowNkFNICsw
NTMwLCBBamF5IEthaGVyIHdyb3RlOg0KPiA+IGNvcmVkdW1wOiBmaXggcmFjZSBjb25kaXRpb24g
YmV0d2VlbiBtbWdldF9ub3RfemVybygpL2dldF90YXNrX21tKCkNCj4gPiBhbmQgY29yZSBkdW1w
aW5nDQo+ID4NCj4gPiBbUEFUQ0ggdjQgMS8zXToNCj4gPiBCYWNrcG9ydGluZyBvZiBjb21taXQg
MDRmNTg2NmU0MWZiNzA2OTBlMjgzOTc0ODdkOGJkOGVlYTdkNzEyYSB1cHN0cmVhbS4NCj4gPg0K
PiA+IFtQQVRDSCB2NCAyLzNdOg0KPiA+IEV4dGVuc2lvbiBvZiBjb21taXQgMDRmNTg2NmU0MWZi
IHRvIGZpeCB0aGUgcmFjZSBjb25kaXRpb24gYmV0d2Vlbg0KPiA+IGdldF90YXNrX21tKCkgYW5k
IGNvcmUgZHVtcGluZyBmb3IgSUItPm1seDQgYW5kIElCLT5tbHg1IGRyaXZlcnMuDQo+ID4NCj4g
PiBbUEFUQ0ggdjQgMy8zXQ0KPiA+IEJhY2twb3J0aW5nIG9mIGNvbW1pdCA1OWVhNmQwNmNmYTky
NDdiNTg2YTY5NWMyMWY5NGFmYTcxODNhZjc0IHVwc3RyZWFtLg0KPiA+DQo+ID4gW2RpZmYgZnJv
bSB2M106DQo+ID4gLSBhZGRlZCBbUEFUQ0ggdjQgMy8zXQ0KICAgICAgICANCj4gV2h5IGRvIGFs
bCB0aGUgcGF0Y2hlcyBoYXZlIHRoZSBzYW1lIHN1YmplY3QgbGluZT8NClRoYW5rcyBmb3IgY2F0
Y2hpbmcgdGhpcy4gSSB3aWxsIGNvcnJlY3QgaW4gbmV4dCB2ZXJzaW9uIG9mIHRoZXNlIHBhdGNo
ZXMsDQphbG9uZyB3aXRoIHJldmlldyBjb21tZW50cyBpZiBhbnkuDQogICAgDQogICAgICAgIA0K
PiBJIGd1ZXNzIGl0J3MgY29ycmVjdCBmb3IgdGhlIGZpcnN0IG9uZSwgYnV0IGNhbiB5b3UgZXhw
bGFpbiB3aGF0J3MgdXANCj4gd2l0aCAjMiBhbmQgIzM/DQo+DQo+IElmIHRoZSBzZWNvbmQgb25l
IGlzbid0IHVwc3RyZWFtLCBwbGVhc2UgZXhwbGFpbiBpbiBkZXRhaWwgd2h5IG5vdCBhbmQNCj4g
aG93IDQuOSBkaWZmZXJzIGZyb20gdXBzdHJlYW0gc28gdGhhdCBpdCByZXF1aXJlcyBhIGN1c3Rv
bSBiYWNrcG9ydC4NCg0KIzIgYXBwbGllZCB0byA0LjE0Lnk6DQpodHRwczovL2dpdC5rZXJuZWwu
b3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zdGFibGUvc3RhYmxlLXF1ZXVlLmdpdC90cmVl
L3F1ZXVlLTQuMTQvaW5maW5pYmFuZC1maXgtcmFjZS1jb25kaXRpb24tYmV0d2Vlbi1pbmZpbmli
YW5kLW1seDQtbWx4NS1kcml2ZXItYW5kLWNvcmUtZHVtcGluZy5wYXRjaD9pZD1lNDA0MWEzZjZi
NTY5MTQwNTQ5ZmU3YjQxZWQ1MjdjNWMxZTM4ZWM5DQoNCkFuZCB0aGVuIHRvIDQuOS55IChzb21l
IHBhcnQgYXMgcmVxdWlyZXMpLiANCjQuMTggYW5kIG9ud2FyZHMgZG9lc24ndCBoYXZlICBtbWFw
X3NlbSBsb2NraW5nIGluIG1seDQgYW5kIG1seDUsIA0Kc28gbm8gbmVlZCBvZiAjMiBpbiA0LjE4
IGFuZCBvbndhcmRzLg0KDQo+IFRoZSB0aGlyZCBvbmUganVzdCBsb29rcyBsaWtlIGEgZGlmZmVy
ZW50IHBhdGNoIGFsdG9nZXRoZXIgd2l0aCBhIHdyb25nDQo+IHN1YmplY3QgbGluZT8NCiMzIHdh
cyBpbiBkaXNjdXNzaW9uIGhlcmUgKGR1cmluZyB2MSksIHNvIGFkZGVkIGhlcmUuIA0KICANCj4g
LS0NCj4gVGhhbmtzLA0KPiBTYXNoYQ0KIA0KDQo=

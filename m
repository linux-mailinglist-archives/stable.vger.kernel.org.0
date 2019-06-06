Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735D0375A6
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 15:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfFFNuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 09:50:17 -0400
Received: from mail-eopbgr820087.outbound.protection.outlook.com ([40.107.82.87]:64416
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726014AbfFFNuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 09:50:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9U9qPN8eBrLnpfAo4j6vW6cbd3IdTpKoA7nGNKkMKrk=;
 b=r5xIZ11mZb8KyaaGsGCP3INkvu17mHfyGyAONroV7v4cf7sVmCptfW3/cv05QK62SYIBnfacknA+j187XxZq60RidzX5bUJWxNQL7+QPe2Lnj+uE9gkPDV+5/6J/OeVsenoMKDIrIAhRJrz2JNJWGpXrt8N6dN39YyhmsGLP9cQ=
Received: from MN2PR05MB6208.namprd05.prod.outlook.com (20.178.241.91) by
 MN2PR05MB6559.namprd05.prod.outlook.com (20.178.246.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.3; Thu, 6 Jun 2019 13:50:11 +0000
Received: from MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::fc2c:24b8:4047:a9a0]) by MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::fc2c:24b8:4047:a9a0%2]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 13:50:11 +0000
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
Thread-Index: AQHVEJKsDwy9S0VSH0qGIlGjrsAD56Z3DMGAgBfSlQD//89xAIAAacmA
Date:   Thu, 6 Jun 2019 13:50:11 +0000
Message-ID: <07748D2A-B644-4240-B118-C2F796F7F0ED@vmware.com>
References: <1558553850-27745-1-git-send-email-akaher@vmware.com>
 <20190522120733.GB6039@mellanox.com>
 <DE6BE512-F3CF-4847-BED0-EE2FCC31DCED@vmware.com>
 <20190606130127.GB17392@mellanox.com>
In-Reply-To: <20190606130127.GB17392@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [103.19.212.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eda06d98-2ae5-471e-3fca-08d6ea85e557
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR05MB6559;
x-ms-traffictypediagnostic: MN2PR05MB6559:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-microsoft-antispam-prvs: <MN2PR05MB6559534DFF036872A4B7AE74BB170@MN2PR05MB6559.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(136003)(376002)(199004)(189003)(476003)(2616005)(6116002)(3846002)(6916009)(11346002)(446003)(86362001)(256004)(54906003)(82746002)(8676002)(33656002)(14454004)(7416002)(81156014)(81166006)(5660300002)(68736007)(316002)(91956017)(66946007)(66476007)(64756008)(66446008)(8936002)(73956011)(2906002)(76116006)(36756003)(66556008)(26005)(4326008)(486006)(6512007)(7736002)(305945005)(478600001)(6246003)(99286004)(6506007)(83716004)(76176011)(25786009)(102836004)(53936002)(6486002)(71190400001)(71200400001)(6436002)(229853002)(66066001)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6559;H:MN2PR05MB6208.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: B5bbkELmaL0FKyrFjsdAgcB7L50E41RyRFJYvnTWgARLTL43CUl5FAwfBs7360IiUOE0LB43+v0riKlju752aXbP7RBPTNRA5GfGT6hAUTOLobzJcObBIz7uyp6zJ0XPd2YNFiZqLdM+PYHZRsLFGVvZphQPk21CvXFZGQlNkZzKlC8Ds8oSAqltVoTvZJBjPxGB6RaRlDFuIE025EVj1XS2+BLdjJyUS5ADpXW0yMMnh5vtRNbuLpBo2An2gqh5mKCz62VI3MwcmjXTG1BOwqQOebypBYWCC1/vaYELHXiAxrGa8AVipA7X1UlXiFHNPD5MUrCo4nGZw2vVvMj6A4iG9P7aXvGlHgjWW5eQyGd/nfsOBCRzbbir3LePdeVOSZoOZOoEkYV1igd6rMFHtXtbAA4JNygaSnvgY6a2T40=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BEFA09AECA12E43A45F6E5D880A1A4A@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eda06d98-2ae5-471e-3fca-08d6ea85e557
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 13:50:11.8024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: akaher@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6559
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCu+7v09uIDA2LzA2LzE5LCA2OjMxIFBNLCAiSmFzb24gR3VudGhvcnBlIiA8amdnQG1lbGxh
bm94LmNvbT4gd3JvdGU6DQoNCj5PbiBUaHUsIEp1biAwNiwgMjAxOSBhdCAxMDoyNToyM0FNICsw
MDAwLCBBamF5IEthaGVyIHdyb3RlOg0KPg0KPj4gPiBJIHRoaW5rIGluIHRoaXMga2VybmVsIHRo
ZSBtbSBoYW5kbGluZyBjb2RlIGZvciBJQiBpcyBpbiB0aHJlZQ0KPj4gPiBkaWZmZXJlbnQgZHJp
dmVycywgaXQgcHJvYmFibHkgbmVlZHMgdG8gYmUgZml4ZWQgdG9vPw0KPj4gDQo+PiBUaGFua3Mg
SmFzb24gZm9yIHBvaW50aW5nIHRoaXMuDQo+PiAgIA0KPj4gQ3Jvc3NlZCBjaGVja2VkIHRoZSBs
b2NraW5nIG9mIG1tYXBfc2VtIGluIElCIGRyaXZlciBjb2RlIG9mIDQuOSB0byA0LjE0IHdpdGgg
PjUuMA0KPj4gYW5kIGZvdW5kIGl0IHJlcXVpcmVzIHRvIGhhbmRsZSBhdCBmb2xsb3dpbmcgbG9j
YXRpb25zIG9mIDQuOSBhbmQgNC4xNDoNCj4+IG1seDRfaWJfZGlzYXNzb2NpYXRlX3Vjb250ZXh0
KCkgb2YgZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvbWFpbi5jOg0KPj4gbWx4NV9pYl9kaXNh
c3NvY2lhdGVfdWNvbnRleHQoKSBvZiBkcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NC9tYWluLmMN
Cj4+IA0KPj4gVG8gZml4IGF0IGFib3ZlIGxvY2F0aW9uLCB3b3VsZCB5b3UgbGlrZSBtZSB0byBt
b2RpZnkgdGhlIG9yaWdpbmFsDQo+PiBwYXRjaCBvciBzdWJtaXQgaW4gYW5vdGhlciBwYXRjaC4N
Cj4NCj4gSSB0aGluayBpdCBpcyBhIGJhY2twb3J0aW5nIHRoaW5nLCBzbyB5b3Ugc2hvdWxkIHB1
dCB0aGUgbmV3IHdvcmsgaW4NCj4gdGhpcyBwYXRjaD8gSSdtIG5vdCBzdXJlLg0KDQpPaywgSSB3
b3VsZCBsaWtlIHRvIHN1Ym1pdCBuZXcgcGF0Y2ggZm9yIG5ldyB3b3JrIGluIDQuMTQsIGFuZCB0
aGVuDQpiYWNrcG9ydCB0byA0LjksIHNvb24gSSB3aWxsIHN1Ym1pdCBmb3IgcmV2aWV3Lg0KDQpS
ZS1zdWJtaXR0ZWQgdGhlIHRoaXMgcGF0Y2ggYWdhaW4gYWZ0ZXIgY29ycmVjdGluZyB0aGUgdXBz
dHJlYW0gY29tbWl0LCBhczoNClN1YjogW1BBVENIIHYyIDEvMV0gW3Y0LjkueV0gY29yZWR1bXA6
IGZpeCByYWNlIGNvbmRpdGlvbiBiZXR3ZWVuIA0KICAgICAgICAgbW1nZXRfbm90X3plcm8oKS9n
ZXRfdGFza19tbSgpIGFuZCBjb3JlIGR1bXBpbmcNCg0KUGxlYXNlIHJldmlldy4NCg0KPiBJJ20g
YWxzbyBzdXJwcmlzZWQgaG5zIGlzbid0IGluIHRoZSBhYm92ZSBsaXN0IG9mIGRyaXZlcnMsIGJ1
dCBtYXliZQ0KPiBobnMgZGlkbid0IGhhdmUgdGhpcyBzdXBwb3J0IGluIHRoZXNlIGtlcm5lbHMu
Lg0KDQpJQi0+aG5zIGRvZXNuJ3QgaGF2ZSBhbnkgaW5zdGFuY2Ugb2YgbW1hcF9zZW0gY2hlY2tl
ZCBmb3IgNC45LTQuMTQuDQoNCj5KYXNvbg0KPg0KDQo=

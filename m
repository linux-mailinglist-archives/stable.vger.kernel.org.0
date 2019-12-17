Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 623FC1222F0
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 05:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfLQEOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 23:14:00 -0500
Received: from mail-eopbgr680070.outbound.protection.outlook.com ([40.107.68.70]:51681
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727404AbfLQEOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 23:14:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXMqrjGRpmmrj4EiDTXwH2N311OPoG/IIiEYNM5hocPiaHI/P8F+F4i8W1gT3yCwj1D/ROZc90+FkIEAksFt8Z+hZkqOe+TY7IzVjUlh573SmZvtwFlKAgo2NeDyUKnZ4ThHmQiIHkwbbD9smRge/bix7dOxdAlWPa8LddtoXU2W7M66DiHTlgbXb38eWF33GvoIUa/n7GeNNVjVU0RT4VGqsAMl4D6BhruS1EPcvWf1q5qwQzNUz+z9yB1dAs7HrPb9sNXtpwJHAmUEBEsFsCJAdKlidjK24BzYh2h4V5Jbb/TIbPK3MS0gCkjnrB06Zv5RWBquL4JB2CyAq/pvJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W27erezjQteOZFuVTOP2dSh8eBcNx32M2EwpBX8/oVc=;
 b=MK9TpxRWWZROXJHa2ue3rp6ELSl+E64Ks00gXRAbl/6KASoi7z5mWkcflfe324GiNrSpIrl7wJVPbJ1I6fP8y8s9zO8XGla2C0T0F4y6iOaPV6xgtDI4zKFOTrBlh3p6ODLh9xDeJ21hY25NZ7yBOIyFSE2iU2dpFckBWkOlbJy3AFdT1Mc20/iLn30W5ys91t9a2LK4WtrGZgiwo/hkNaimix0zC5Lw2FpeHI7FMie+LfQKpZSpLXZT/g2boGsuLLP7IKr1Nmd+jGs4ytmxiO/XBIHUDxbNecb9TO1G2igzSl2Zv8gi4OqKUywvpHSlB5HAM/cLjuwgenDbPw+7Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W27erezjQteOZFuVTOP2dSh8eBcNx32M2EwpBX8/oVc=;
 b=DTVF5TAPCg9C+HeHOKvh6eN5AK9tYU0MTPxRJG4sBm1d0TFrUkkjmXN3mZeKnJ1plGUkM7EAsd6UvMHY5dPNgSV2nUKaMWIU2t0PUKfNtEngvOei0VAjO0fXcGZ/GH2QNiKfdvlSxA0bndvlnFwh+RSDfhEJqJ+peYWiZrbNoD0=
Received: from MN2PR05MB6208.namprd05.prod.outlook.com (20.178.241.91) by
 MN2PR05MB6464.namprd05.prod.outlook.com (20.178.246.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.12; Tue, 17 Dec 2019 04:13:57 +0000
Received: from MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::ed0d:9029:720c:1459]) by MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::ed0d:9029:720c:1459%2]) with mapi id 15.20.2559.012; Tue, 17 Dec 2019
 04:13:57 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>
CC:     Peter Zijlstra <peterz@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "punit.agrawal@arm.com" <punit.agrawal@arm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "mszeredi@redhat.com" <mszeredi@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Srinidhi Rao <srinidhir@vmware.com>,
        Vikash Bansal <bvikas@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        Steven Rostedt <srostedt@vmware.com>,
        Oscar Salvador <osalvador@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v3 8/8] x86, mm, gup: prevent get_page() race with munmap
 in paravirt guest
Thread-Topic: [PATCH v3 8/8] x86, mm, gup: prevent get_page() race with munmap
 in paravirt guest
Thread-Index: AQHVtA8fuh6znFRRV0qqDxHv/b6uMqe8uqWAgAAHRQCAAASqgIAAF2sAgAAQAgCAASbBAA==
Date:   Tue, 17 Dec 2019 04:13:55 +0000
Message-ID: <DDB0E6FC-1338-4E38-BD79-3325399C3E81@vmware.com>
References: <1576529149-14269-1-git-send-email-akaher@vmware.com>
 <1576529149-14269-9-git-send-email-akaher@vmware.com>
 <20191216130443.GN2844@hirez.programming.kicks-ass.net>
 <87lfrc9z3v.fsf@vitty.brq.redhat.com>
 <20191216134725.GE2827@hirez.programming.kicks-ass.net>
 <1aacc7ac-87b0-e22e-a265-ea175506844d@suse.cz>
 <87immg9rsv.fsf@vitty.brq.redhat.com>
In-Reply-To: <87immg9rsv.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [103.19.212.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0bd35fc9-e913-4fe7-8fdc-08d782a7894c
x-ms-traffictypediagnostic: MN2PR05MB6464:|MN2PR05MB6464:|MN2PR05MB6464:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR05MB64644D62614B7FF310B915F4BB500@MN2PR05MB6464.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(43544003)(199004)(189003)(33656002)(4744005)(966005)(8936002)(5660300002)(316002)(86362001)(81156014)(71200400001)(81166006)(6486002)(2616005)(91956017)(76116006)(66476007)(66946007)(66556008)(64756008)(66446008)(2906002)(6506007)(7416002)(36756003)(110136005)(54906003)(8676002)(478600001)(186003)(6512007)(4326008)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6464;H:MN2PR05MB6208.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lwipi+0FLjWKowyPcdLkbMj89UFHRc2VVoev8wbZsYz1+zwOuf1CwlsPnavyn7D/VbkXOq7xRuJFTrHYVgiSCy8DF6kpLrt+ROFZS8jQFLQKD7x+JXOGSDfgZg8rI9RTW54KBVr4vI8cDfI5lMXT0vtl7i4gqFfd3vOfIuXm0n9IS9CCzzIYPJgqS7ltoujuwCdR76YRL36zogmRkmQSSb9WA4Jla3//PFxOkkUQet1LarX9mGz6F9xtYZe5BxjiKkcGGHKwZML38YUVgyG2QBCwHwWeEOI0j64YCwHWlv8fkx6AeF4mJoKucGQA1TyxCA3KCqBSumtNxfGAj4iOuIy2ynET87Y/agMAw1XDUeLthe+ON8oEbj1NAQxSuErafnT7JfxP2f4BRGF5JuyEKhkSMV14wyBU/7ViDoOTkADKvW8sQ3UnKKdt4pDjlfOUazGDKvjBMSfU6FAIcyeOBKMyFADvMXVjtfI9CAM7yl0Q+6KuqgtmxhLkJ7P7jabNJDeXRbrz3SwEouv3DwNm9antb2o70I8Y/LwZ76hLFD0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5634395AAEA93349A97693DA064689AB@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd35fc9-e913-4fe7-8fdc-08d782a7894c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 04:13:56.7431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1gUNXjJRpcBoUROM72QMwCq476uGvolsx43KVNO+VbCLTUblKoQQWn1kraV8cRp/ChlS4SuTh31FdK4rGUcMoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6464
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCu+7v09uIDE2LzEyLzE5LCA5OjM4IFBNLCAiVml0YWx5IEt1em5ldHNvdiIgPHZrdXpuZXRz
QHJlZGhhdC5jb20+IHdyb3RlOg0KDQo+IChJIGFsc28gZGlzbGlrZSByZWNlaXZpbmcgb25seSB0
aGlzIHBhdGNoIG9mIHRoZSBzZXJpZXMsIG5leHQgdGltZQ0KPiBwbGVhc2Ugc2VuZCB0aGUgd2hv
bGUgdGhpbmcsIGl0J3Mgb25seSA4IHBhdGNoZXMsIG91ciBtYWlsZm9sZGVycyB3aWxsDQo+IHN1
cnZpdmUgdGhhdCkNCg0KVGhhbmtzIGZvciBwb2ludGluZyB0aGlzLCBJIHdpbGwgdGFrZSBjYXJl
LiANCg0KPiBJJ20gbm90IHN1cmUgd2hpY2ggc3RhYmxlIGtlcm5lbCB5b3UncmUgdGFyZ2V0aW5n
IChhbmQgaWYgeW91IGFkZHJlc3NlZCB0aGlzDQo+IHdpdGggb3RoZXIgcGF0Y2hlcyBpbiB0aGUg
c2VyaWVzLCBpZiB0aGlzIGlzIG5lZWRlZCwuLi4pIHNvIEpGWUkuDQoNClRoaXMgc2VyaWVzIGlz
IGZvciA0LjQueSwgcGxlYXNlIHJlZmVyIGZvbGxvd2luZyBsaW5rIGZvciBjb21wbGV0ZSBzZXJp
ZXM6DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9zdGFibGUvMTU3NjUyOTE0OS0xNDI2OS0xLWdp
dC1zZW5kLWVtYWlsLWFrYWhlckB2bXdhcmUuY29tLw0KDQpZZXMsIHRoaXMgJ1BhdGNoIHYzIDgv
OCcgY291bGQgYmUgbWVyZ2VkIHNlcGFyYXRlbHksIGlmIGl0J3MgdW5zYWZlIHRvIG1lcmdlIGF0
IHRoaXMgbW92ZW1lbnQuICANCg0KLSBBamF5DQogICAgDQogICAgDQoNCg==

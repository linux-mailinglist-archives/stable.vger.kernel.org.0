Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E4C14ECBA
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 13:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgAaMvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 07:51:45 -0500
Received: from mail-eopbgr680076.outbound.protection.outlook.com ([40.107.68.76]:13934
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728500AbgAaMvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 07:51:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQe3vsTruoi8AYkCkK0BT/YZwIN2a2WWkIXGLQG/lFIRt+pGaNefrqS5u4xxht95xxMYe7SLcdgipOpsBf/KG57NCjHvik30MHApb1gyZh6H/rqxJTzEsNrnHkMdNToWysxJF0DR4LQ9qgIFxIAaHbjaRK9U5SGxM0wzXiDk3kyE9rKhAmi+K19OF9iZX4BrKIfoGn75DN9v9xtxiyHnYFofsk1v6kLgTIbGLI7stWaL20RwOLz7SokqGHW7MCCxIm7+biNMQTW6KrrUMa5nKa8p7zZC/kaGT5zaKQSXCea49SOEtmdBYDnIT2LQ0GcJTlTqBRDfcZ34gcM2zgOqhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjE6cx8W8UpWF3l3bociv9BX+TfQSN3QXcXnTjs5vyQ=;
 b=XznQ+1x1+wVJcgv5bcEzszrkgqaIl31Nealc1kvTFOkFCjCzXPBeACTju+rLbgYisNNcRfy+Bew9rSuaIWLyDtJNFdxvmnlGZ0Hyas2am0CqCKEVlTIysuKCXFxhJU51APLw4sUixFVYfGbILD5yz2aKPiE1hAbbxge+5T5BkLdTEJNDNchkwDqEIIm0U8z4YiKU5uQazfnRKK3fV64RJBoWA/Qx5L/QMWUCfYC8onmVBAEHuyV3MNoN/zGQfgj60QGvLD0FKjxDFt5XoWKXn+AxeYFK3G0MiSnAhrtbT/QRnqNU3fDMhC2icviBfjFEhC99lhqvSs+tL7HxEN4iyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjE6cx8W8UpWF3l3bociv9BX+TfQSN3QXcXnTjs5vyQ=;
 b=pOsaZU+wnIKbeJ55e3RPePSiNtBhJ3x7+JFLMZCS/KJsPzBdN1AagOgXhrscdbiI+kQrzM8Fq6e57D1VWLaCOtkNaVwyHQYNUSCXJlGyVrAWxoPe8Dub0DWyKQH2/LzQ4yXNaRRRMu9a6D6AMCtWlUtkXvjSGebF8AG2q1aTNJ0=
Received: from MN2PR05MB6208.namprd05.prod.outlook.com (20.178.241.91) by
 MN2PR05MB6893.namprd05.prod.outlook.com (52.135.38.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.12; Fri, 31 Jan 2020 12:51:36 +0000
Received: from MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::ed0d:9029:720c:1459]) by MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::ed0d:9029:720c:1459%2]) with mapi id 15.20.2686.025; Fri, 31 Jan 2020
 12:51:36 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Peter Zijlstra <peterz@infradead.org>,
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
Thread-Index: AQHVtA8fuh6znFRRV0qqDxHv/b6uMqe8uqWAgAAHRQCAAASqgIAAF2sAgAAQAgCASHBJgA==
Date:   Fri, 31 Jan 2020 12:51:35 +0000
Message-ID: <9755E757-3A63-4001-84BA-ECDF4D0337C8@vmware.com>
References: <1576529149-14269-1-git-send-email-akaher@vmware.com>
 <1576529149-14269-9-git-send-email-akaher@vmware.com>
 <20191216130443.GN2844@hirez.programming.kicks-ass.net>
 <87lfrc9z3v.fsf@vitty.brq.redhat.com>
 <20191216134725.GE2827@hirez.programming.kicks-ass.net>
 <1aacc7ac-87b0-e22e-a265-ea175506844d@suse.cz>
 <87immg9rsv.fsf@vitty.brq.redhat.com>
In-Reply-To: <87immg9rsv.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [103.19.212.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7224ae4b-28e4-4525-5a70-08d7a64c4e84
x-ms-traffictypediagnostic: MN2PR05MB6893:|MN2PR05MB6893:|MN2PR05MB6893:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR05MB6893C504FEEFEF0077CF9033BB070@MN2PR05MB6893.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 029976C540
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(199004)(189003)(36756003)(81166006)(33656002)(966005)(86362001)(110136005)(54906003)(186003)(26005)(316002)(6506007)(8676002)(5660300002)(2616005)(478600001)(81156014)(64756008)(4326008)(66946007)(66446008)(66476007)(66556008)(8936002)(91956017)(2906002)(76116006)(6486002)(6512007)(71200400001)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6893;H:MN2PR05MB6208.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oxT3cjTc0Ught+qfXr5jJTAhsXe9QVGPIS+k+k6aCD9t4AjcSv+D4S8q28aYbFF7AbTdkgpoSWtwTGh6RnaYxKWfp+WPioyML9EKrveNaWpeh7PhHui2aFPc1MKQXfZ3KsQMixQxKycIwAH2YSnngBM42LHSnLEhnBrtdKX22ILkcOsK2poh5bMT4OJY10qjI/qI+x8Liek94PUVlvdV0XFqrllHbo40A2+tK2Ch/YUMUapkrj2qNWplrYIRqBueomigXWIgP0pwVmimIWqUS0/BoR0iuI3CevjJ9DOXWNGIWIPmZNgyODtRkiRBjjp/+FyG2mV/hnZheU9f0aJkHK+jQHOxdgs2Wp7/wna14nAi82gEnGC3jzTGpYdwzU3+n4+IA6NjDnO4WFMdkVd1gKDJ3cEoJRDv2PxQCUQaXKZrSZMX66uqwth7IFmt6AJFb1gnLj3xPk9CuxpPxWvLCJSxQEcN5rAg3bggEBfOm6X4tVeJKXqbWnyFDYUBqgefK8Z7c4XRwNNQXfvwggyF/g==
x-ms-exchange-antispam-messagedata: UVfcG6XZoZo9KH5qDr37tFnNMZvpYC88RAzGX+kxavmy29BTQ6qcVJS20AnK4ZzAdnfcFCmnca4bmuIuNPm4E3b4n1B7+VfSaIzCQAX4A9XdEpJZ5V/n3XJFPbw9j343gRuDJU32cNT9cNST6f02yw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <A99E06A6DE06A8468971147B46950FAC@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7224ae4b-28e4-4525-5a70-08d7a64c4e84
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2020 12:51:35.8158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UkofGULSVttWg1Wm/MNHBilmVqxwnvYWAVhp8c4pm/AYccdVbjADi0wYo38QsAzHBlaI3R7nVTK6mOhgIGSQfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6893
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCu+7v09uIDE2LzEyLzE5LCA5OjM4IFBNLCAiVml0YWx5IEt1em5ldHNvdiIgPHZrdXpuZXRz
QHJlZGhhdC5jb20+IHdyb3RlOg0KDQo+PiAoSSBhbHNvIGRpc2xpa2UgcmVjZWl2aW5nIG9ubHkg
dGhpcyBwYXRjaCBvZiB0aGUgc2VyaWVzLCBuZXh0IHRpbWUNCj4+IHBsZWFzZSBzZW5kIHRoZSB3
aG9sZSB0aGluZywgaXQncyBvbmx5IDggcGF0Y2hlcywgb3VyIG1haWxmb2xkZXJzIHdpbGwNCj4+
IHN1cnZpdmUgdGhhdCkNCj4NCj4gVGhhbmtzIGZvciBwb2ludGluZyB0aGlzLCBJIHdpbGwgdGFr
ZSBjYXJlLiANCj4NCj4+IEknbSBub3Qgc3VyZSB3aGljaCBzdGFibGUga2VybmVsIHlvdSdyZSB0
YXJnZXRpbmcgKGFuZCBpZiB5b3UgYWRkcmVzc2VkIHRoaXMNCj4+IHdpdGggb3RoZXIgcGF0Y2hl
cyBpbiB0aGUgc2VyaWVzLCBpZiB0aGlzIGlzIG5lZWRlZCwuLi4pIHNvIEpGWUkuDQo+DQo+IFRo
aXMgc2VyaWVzIGlzIGZvciA0LjQueSwgcGxlYXNlIHJlZmVyIGZvbGxvd2luZyBsaW5rIGZvciBj
b21wbGV0ZSBzZXJpZXM6DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3N0YWJsZS8xNTc2NTI5
MTQ5LTE0MjY5LTEtZ2l0LXNlbmQtZW1haWwtYWthaGVyQHZtd2FyZS5jb20vDQo+DQo+IFllcywg
dGhpcyAnUGF0Y2ggdjMgOC84JyBjb3VsZCBiZSBtZXJnZWQgc2VwYXJhdGVseSwgaWYgaXQncyB1
bnNhZmUgdG8gbWVyZ2UgYXQgdGhpcyBtb3ZlbWVudC4gIA0KPg0KPiAtIEFqYXkNCg0KR3JlZywg
bGFzdCBtb250aCBJIHBvc3RlZCB0aGlzIHNlcmllcyBbMV0gZm9yIHY0LjQueSAoaW5jbHVkaW5n
IFZsYXN0aW1pbCdzIGNoYW5nZSkuDQoNClRoZXJlIHdlcmUgc29tZSBkaXNjdXNzaW9uIGZvciBb
UEFUQ0ggdjMgOC84XSBbMl0gYW5kIG5vIGZ1cnRoZXIgZGlzY3Vzc2lvbiBvbmNlIEkgc3BlY2lm
aWVkIGl0J3MgZm9yIDQuNC55Lg0KUGxlYXNlIHN1Z2dlc3QsIGlmIEkgbmVlZCB0byByZXBvc3Qg
dGhpcyBzZXJpZXMgYWdhaW4uDQoNCi0gQWpheQ0KDQpbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvc3RhYmxlLzE1NzY1MjkxNDktMTQyNjktMS1naXQtc2VuZC1lbWFpbC1ha2FoZXJAdm13YXJl
LmNvbS8NClsyXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9zdGFibGUvMTU3NjUyOTE0OS0xNDI2
OS05LWdpdC1zZW5kLWVtYWlsLWFrYWhlckB2bXdhcmUuY29tLw0KDQoNCiAgICANCg0K

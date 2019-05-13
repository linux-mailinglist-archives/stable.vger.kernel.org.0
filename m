Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 670D51B2BF
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 11:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfEMJVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 05:21:05 -0400
Received: from mail-eopbgr700076.outbound.protection.outlook.com ([40.107.70.76]:64172
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727305AbfEMJVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 05:21:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpQenlchEVhV4euQXTFLGGQfIy3VwdfKzHdbshG8Jls=;
 b=1xs1l8ip9XgGIbHrmiGznrt9OZMVA/nh7iinXKABA16dyA0aN6U17aRDSDBO+Ybv3g5rA3GsWTP47t1Bj9vOKj6M4zTKQ2guM6+7ncuevfCoGg4V8Bi+RStWfOHTfcnSIPzFCxio3OFGxxymaMUfdo6Y02NtqdpjCEq6DGNtbfM=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB4360.namprd05.prod.outlook.com (52.135.202.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.14; Mon, 13 May 2019 09:21:01 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::b057:917a:f098:6098]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::b057:917a:f098:6098%7]) with mapi id 15.20.1900.010; Mon, 13 May 2019
 09:21:01 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Yang Shi <yang.shi@linux.alibaba.com>,
        "jstancek@redhat.com" <jstancek@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Nick Piggin <npiggin@gmail.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Thread-Topic: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Thread-Index: AQHVBlNcdgyGQHvMg0ymTH6Y7O8srKZjDs8AgAANcoCAAAcZgIAABfcAgAAkYwCABXN1AIAACg2AgAACfYA=
Date:   Mon, 13 May 2019 09:21:01 +0000
Message-ID: <847D4C2F-BD26-4BE0-A5BA-3C690D11BF77@vmware.com>
References: <1557264889-109594-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190509083726.GA2209@brain-police>
 <20190509103813.GP2589@hirez.programming.kicks-ass.net>
 <F22533A7-016F-4506-809A-7E86BAF24D5A@vmware.com>
 <20190509182435.GA2623@hirez.programming.kicks-ass.net>
 <04668E51-FD87-4D53-A066-5A35ABC3A0D6@vmware.com>
 <20190509191120.GD2623@hirez.programming.kicks-ass.net>
 <7DA60772-3EE3-4882-B26F-2A900690DA15@vmware.com>
 <20190513083606.GL2623@hirez.programming.kicks-ass.net>
 <20190513091205.GO2650@hirez.programming.kicks-ass.net>
In-Reply-To: <20190513091205.GO2650@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [50.204.119.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8037cc0d-71c9-443a-c2a0-08d6d78450e8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR05MB4360;
x-ms-traffictypediagnostic: BYAPR05MB4360:
x-microsoft-antispam-prvs: <BYAPR05MB4360448DF978D529BCC10D81D00F0@BYAPR05MB4360.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(396003)(346002)(376002)(39860400002)(136003)(366004)(189003)(199004)(53546011)(14454004)(6246003)(305945005)(8676002)(186003)(8936002)(6506007)(82746002)(68736007)(53936002)(81156014)(66066001)(4326008)(81166006)(102836004)(478600001)(3846002)(66446008)(66556008)(316002)(91956017)(2906002)(6116002)(76116006)(86362001)(73956011)(64756008)(6916009)(7736002)(66476007)(99286004)(66946007)(7416002)(5660300002)(54906003)(25786009)(76176011)(33656002)(83716004)(26005)(71200400001)(71190400001)(14444005)(256004)(229853002)(6512007)(446003)(11346002)(6436002)(476003)(2616005)(6486002)(36756003)(486006)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4360;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CelJo98N5BTvgBiCtmSEwR3SSuriFAV1AWdPS3GaWiwjgig3EQhZ3CyoLcbcj5z1hi5TD3MxaK+7aqwEGdasae4pADNL8lhEd6eB4jMrlCHoEVPe+xu27n5H1l2NdmTEXZTDSFAxePnHQ3/QgLyDcRJOFN/ZMHaxB4FrnZAIb5CpZRjz5ItTTSmWTweJXQYhNJE/XfMEuFj9Y3GrpzVzD4JAh92A5NHs5IVLzu+SXf8cciyV+nMFQfcK6ggYHs0dzSHfkTnUkOItkfH/oY4/s2YFf7OHevdw/R7rmnKK5NKBVJGcX8s1RUBurbwJnrGOBdG1vHRs1wSwHGizXfmlM1+fiO7Uw2iSu+Hm7k0IMy4YV6blEKppgyf3g8DzcDsUQ6vsELtdi8EDvarBfHdIhoLO6xa1WZg4R914HApNMXo=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2D5CBDD523036D4CB25AC81AC9005E04@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8037cc0d-71c9-443a-c2a0-08d6d78450e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 09:21:01.0171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4360
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On May 13, 2019, at 2:12 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> On Mon, May 13, 2019 at 10:36:06AM +0200, Peter Zijlstra wrote:
>> On Thu, May 09, 2019 at 09:21:35PM +0000, Nadav Amit wrote:
>>> It may be possible to avoid false-positive nesting indications (when th=
e
>>> flushes do not overlap) by creating a new struct mmu_gather_pending, wi=
th
>>> something like:
>>>=20
>>>  struct mmu_gather_pending {
>>> 	u64 start;
>>> 	u64 end;
>>> 	struct mmu_gather_pending *next;
>>>  }
>>>=20
>>> tlb_finish_mmu() would then iterate over the mm->mmu_gather_pending
>>> (pointing to the linked list) and find whether there is any overlap. Th=
is
>>> would still require synchronization (acquiring a lock when allocating a=
nd
>>> deallocating or something fancier).
>>=20
>> We have an interval_tree for this, and yes, that's how far I got :/
>>=20
>> The other thing I was thinking of is trying to detect overlap through
>> the page-tables themselves, but we have a distinct lack of storage
>> there.
>=20
> We might just use some state in the pmd, there's still 2 _pt_pad_[12] in
> struct page to 'use'. So we could come up with some tlb generation
> scheme that would detect conflict.

It is rather easy to come up with a scheme (and I did similar things) if yo=
u
flush the table while you hold the page-tables lock. But if you batch acros=
s
page-tables it becomes harder.

Thinking about it while typing, perhaps it is simpler than I think - if you
need to flush range that runs across more than a single table, you are very
likely to flush a range of more than 33 entries, so anyhow you are likely t=
o
do a full TLB flush.

So perhaps just avoiding the batching if only entries from a single table
are flushed would be enough.

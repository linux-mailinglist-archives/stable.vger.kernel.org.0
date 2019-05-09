Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4132218F47
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 19:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfEIRgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 13:36:36 -0400
Received: from mail-eopbgr760050.outbound.protection.outlook.com ([40.107.76.50]:34403
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726576AbfEIRgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 13:36:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmJlQHnyxWKpE2tFnlIITdB+xJYRJxRTmsD4Isj4Iu8=;
 b=cjQ5WC8pQdg83EDEcqTJPzKKCYvfHOuCcsKv5gLezQbUUJEExMdCDPD3O7VHruN6e5m1LdmCx68wSBIEJLIKCWJ/KQKSoWSyhh0vdh5fz5mcUYN3j9ZzPdcEUkbmmavWOlkFHwolCNVxFVdvn4oIkUvp7J7eJ+gM44MA03Bt2b8=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB4247.namprd05.prod.outlook.com (20.176.252.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.4; Thu, 9 May 2019 17:36:29 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::b057:917a:f098:6098]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::b057:917a:f098:6098%7]) with mapi id 15.20.1900.006; Thu, 9 May 2019
 17:36:29 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Will Deacon <will.deacon@arm.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        "jstancek@redhat.com" <jstancek@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aneesh.kumar@linux.vnet.ibm.com" <aneesh.kumar@linux.vnet.ibm.com>,
        "npiggin@gmail.com" <npiggin@gmail.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Thread-Topic: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Thread-Index: AQHVBlNcdgyGQHvMg0ymTH6Y7O8srKZjDs8A
Date:   Thu, 9 May 2019 17:36:29 +0000
Message-ID: <F22533A7-016F-4506-809A-7E86BAF24D5A@vmware.com>
References: <1557264889-109594-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190509083726.GA2209@brain-police>
 <20190509103813.GP2589@hirez.programming.kicks-ass.net>
In-Reply-To: <20190509103813.GP2589@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cdc4f936-48aa-49af-f768-08d6d4a4deed
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR05MB4247;
x-ms-traffictypediagnostic: BYAPR05MB4247:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR05MB424786746F70CE42FB017980D0330@BYAPR05MB4247.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 003245E729
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(376002)(346002)(366004)(39860400002)(199004)(189003)(31014005)(53754006)(54534003)(71190400001)(99286004)(6916009)(86362001)(6506007)(102836004)(76176011)(7416002)(71200400001)(966005)(33656002)(82746002)(83716004)(45080400002)(478600001)(14454004)(4326008)(68736007)(6246003)(25786009)(36756003)(53936002)(66066001)(53546011)(66476007)(66946007)(66556008)(64756008)(66446008)(73956011)(76116006)(316002)(446003)(11346002)(486006)(476003)(26005)(186003)(2616005)(229853002)(6486002)(256004)(14444005)(5660300002)(6512007)(6306002)(6436002)(3846002)(6116002)(8676002)(81156014)(81166006)(8936002)(54906003)(7736002)(305945005)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4247;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ki/tjrBreloibQFmkhncPLsiKjP29Wy2yUcrtIRutaEDPAjs3C0WZGDPmidY0mXwqts/RYNhujDxbn9KXMT2sx4B67Xhx944WMjZAF65slU25DV7eEHpCA+MxLv0jGYm/LW97kaV0nZmMKLLVCqk802qz52JJglxcxmSLwK1UQaux9SGEeWs8WCApC0VuUECVhAp4rQ89kBsnSyVZFS9nNhI0DbiFdF1g6geZPCaA1pLOOdQKXnh7HPMl1MY328Q/Dh0Hx11zBrvao63X/ywKYTd7jKxVwjXyHuOFOsNFRWEmNwihUk01PQvOQbrvoDXIi1pZxfOVz6hK87JyMuGd00MGBR1Jtl1e2Vy1O55VXshPAiMs19JvBtXGB/ixLQ7TYKInrOe32YvG/yYFOUxfFGKF3aHYBiWxqMXlsNdNCk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E5E4CD6BAFEC2E4F9C0A9DBFDA3782F3@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc4f936-48aa-49af-f768-08d6d4a4deed
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2019 17:36:29.4858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4247
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On May 9, 2019, at 3:38 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> On Thu, May 09, 2019 at 09:37:26AM +0100, Will Deacon wrote:
>> Hi all, [+Peter]
>=20
> Right, mm/mmu_gather.c has a MAINTAINERS entry; use it.
>=20
> Also added Nadav and Minchan who've poked at this issue before. And Mel,
> because he loves these things :-)
>=20
>> Apologies for the delay; I'm attending a conference this week so it's tr=
icky
>> to keep up with email.
>>=20
>> On Wed, May 08, 2019 at 05:34:49AM +0800, Yang Shi wrote:
>>> A few new fields were added to mmu_gather to make TLB flush smarter for
>>> huge page by telling what level of page table is changed.
>>>=20
>>> __tlb_reset_range() is used to reset all these page table state to
>>> unchanged, which is called by TLB flush for parallel mapping changes fo=
r
>>> the same range under non-exclusive lock (i.e. read mmap_sem).  Before
>>> commit dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in
>>> munmap"), MADV_DONTNEED is the only one who may do page zapping in
>>> parallel and it doesn't remove page tables.  But, the forementioned com=
mit
>>> may do munmap() under read mmap_sem and free page tables.  This causes =
a
>>> bug [1] reported by Jan Stancek since __tlb_reset_range() may pass the
>=20
> Please don't _EVER_ refer to external sources to describe the actual bug
> a patch is fixing. That is the primary purpose of the Changelog.
>=20
> Worse, the email you reference does _NOT_ describe the actual problem.
> Nor do you.
>=20
>>> wrong page table state to architecture specific TLB flush operations.
>>=20
>> Yikes. Is it actually safe to run free_pgtables() concurrently for a giv=
en
>> mm?
>=20
> Yeah.. sorta.. it's been a source of 'interesting' things. This really
> isn't the first issue here.
>=20
> Also, change_protection_range() is 'fun' too.
>=20
>>> So, removing __tlb_reset_range() sounds sane.  This may cause more TLB
>>> flush for MADV_DONTNEED, but it should be not called very often, hence
>>> the impact should be negligible.
>>>=20
>>> The original proposed fix came from Jan Stancek who mainly debugged thi=
s
>>> issue, I just wrapped up everything together.
>>=20
>> I'm still paging the nested flush logic back in, but I have some comment=
s on
>> the patch below.
>>=20
>>> [1] https://nam04.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2=
Flore.kernel.org%2Flinux-mm%2F342bf1fd-f1bf-ed62-1127-e911b5032274%40linux.=
alibaba.com%2FT%2F%23m7a2ab6c878d5a256560650e56189cfae4e73217f&amp;data=3D0=
2%7C01%7Cnamit%40vmware.com%7C7be2f2b29b654aba7de308d6d46a7b93%7Cb39138ca3c=
ee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C636929951176903247&amp;sdata=3DgGptCMeb9vW=
4jXUnG53amgvrv8TB9F52JYBHmPeHFvs%3D&amp;reserved=3D0
>>>=20
>>> Reported-by: Jan Stancek <jstancek@redhat.com>
>>> Tested-by: Jan Stancek <jstancek@redhat.com>
>>> Cc: Will Deacon <will.deacon@arm.com>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
>>> Signed-off-by: Jan Stancek <jstancek@redhat.com>
>>> ---
>>> mm/mmu_gather.c | 7 ++++---
>>> 1 file changed, 4 insertions(+), 3 deletions(-)
>>>=20
>>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>>> index 99740e1..9fd5272 100644
>>> --- a/mm/mmu_gather.c
>>> +++ b/mm/mmu_gather.c
>>> @@ -249,11 +249,12 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
>>> 	 * flush by batching, a thread has stable TLB entry can fail to flush
>>=20
>> Urgh, we should rewrite this comment while we're here so that it makes s=
ense...
>=20
> Yeah, that's atrocious. We should put the actual race in there.
>=20
>>>  * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
>>> 	 * forcefully if we detect parallel PTE batching threads.
>>> +	 *
>>> +	 * munmap() may change mapping under non-excluse lock and also free
>>> +	 * page tables.  Do not call __tlb_reset_range() for it.
>>> 	 */
>>> -	if (mm_tlb_flush_nested(tlb->mm)) {
>>> -		__tlb_reset_range(tlb);
>>> +	if (mm_tlb_flush_nested(tlb->mm))
>>> 		__tlb_adjust_range(tlb, start, end - start);
>>> -	}
>>=20
>> I don't think we can elide the call __tlb_reset_range() entirely, since =
I
>> think we do want to clear the freed_pXX bits to ensure that we walk the
>> range with the smallest mapping granule that we have. Otherwise couldn't=
 we
>> have a problem if we hit a PMD that had been cleared, but the TLB
>> invalidation for the PTEs that used to be linked below it was still pend=
ing?
>=20
> That's tlb->cleared_p*, and yes agreed. That is, right until some
> architecture has level dependent TLBI instructions, at which point we'll
> need to have them all set instead of cleared.
>=20
>> Perhaps we should just set fullmm if we see that here's a concurrent
>> unmapper rather than do a worst-case range invalidation. Do you have a f=
eeling
>> for often the mm_tlb_flush_nested() triggers in practice?
>=20
> Quite a bit for certain workloads I imagine, that was the whole point of
> doing it.
>=20
> Anyway; am I correct in understanding that the actual problem is that
> we've cleared freed_tables and the ARM64 tlb_flush() will then not
> invalidate the cache and badness happens?
>=20
> Because so far nobody has actually provided a coherent description of
> the actual problem we're trying to solve. But I'm thinking something
> like the below ought to do.
>=20
>=20
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index 99740e1dd273..fe768f8d612e 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -244,15 +244,20 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
> 		unsigned long start, unsigned long end)
> {
> 	/*
> -	 * If there are parallel threads are doing PTE changes on same range
> -	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer TLB
> -	 * flush by batching, a thread has stable TLB entry can fail to flush
> -	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
> -	 * forcefully if we detect parallel PTE batching threads.
> +	 * Sensible comment goes here..
> 	 */
> -	if (mm_tlb_flush_nested(tlb->mm)) {
> -		__tlb_reset_range(tlb);
> -		__tlb_adjust_range(tlb, start, end - start);
> +	if (mm_tlb_flush_nested(tlb->mm) && !tlb->full_mm) {
> +		/*
> +		 * Since we're can't tell what we actually should have
> +		 * flushed flush everything in the given range.
> +		 */
> +		tlb->start =3D start;
> +		tlb->end =3D end;
> +		tlb->freed_tables =3D 1;
> +		tlb->cleared_ptes =3D 1;
> +		tlb->cleared_pmds =3D 1;
> +		tlb->cleared_puds =3D 1;
> +		tlb->cleared_p4ds =3D 1;
> 	}
>=20
> 	tlb_flush_mmu(tlb);

As a simple optimization, I think it is possible to hold multiple nesting
counters in the mm, similar to tlb_flush_pending, for freed_tables,
cleared_ptes, etc.

The first time you set tlb->freed_tables, you also atomically increase
mm->tlb_flush_freed_tables. Then, in tlb_flush_mmu(), you just use
mm->tlb_flush_freed_tables instead of tlb->freed_tables.


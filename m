Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC211C3C4
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 09:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfENHVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 03:21:36 -0400
Received: from mail-eopbgr810072.outbound.protection.outlook.com ([40.107.81.72]:23049
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726491AbfENHVg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 03:21:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7I0I7EqMp9u8qoAqgsPq2edPo34Jt6gf97q8PQTA6gw=;
 b=HvR8LkL7t2fasfzTvvJk3WsltZRAIkASXXTez6W9A1wJ3YR6+fCBX+sgjGqs/DZFRbRpgNBZKMzZKGGOG7vr1QsotKorQtf/Nth5ybtw5SovtyMivfhc+MXJNgfDThE4252qz8Klhv2I77wPR/j+e7z7eLUEEmEVUq8gR+tX/qc=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB5173.namprd05.prod.outlook.com (20.177.231.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.4; Tue, 14 May 2019 07:21:33 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::b057:917a:f098:6098]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::b057:917a:f098:6098%7]) with mapi id 15.20.1900.010; Tue, 14 May 2019
 07:21:33 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Jan Stancek <jstancek@redhat.com>
CC:     Yang Shi <yang.shi@linux.alibaba.com>,
        Will Deacon <will.deacon@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v2 PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Thread-Topic: [v2 PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Thread-Index: AQHVCfj1/ZS8SZ4p0ke1CH5gp1S1IPlIMumfrSIEdAA=
Date:   Tue, 14 May 2019 07:21:33 +0000
Message-ID: <9E536319-815D-4425-B4B6-8786D415442C@vmware.com>
References: <45c6096e-c3e0-4058-8669-75fbba415e07@email.android.com>
 <914836977.22577826.1557818139522.JavaMail.zimbra@redhat.com>
In-Reply-To: <914836977.22577826.1557818139522.JavaMail.zimbra@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [50.204.119.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac502c48-e668-4174-56e5-08d6d83ccac7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR05MB5173;
x-ms-traffictypediagnostic: BYAPR05MB5173:
x-microsoft-antispam-prvs: <BYAPR05MB5173E2C0864A692094A3A104D0080@BYAPR05MB5173.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(346002)(136003)(376002)(366004)(51444003)(13464003)(189003)(199004)(26005)(6916009)(76116006)(486006)(82746002)(8936002)(11346002)(446003)(476003)(2616005)(53546011)(6506007)(3846002)(6116002)(8676002)(102836004)(64756008)(66946007)(86362001)(478600001)(66476007)(66556008)(99286004)(66446008)(76176011)(73956011)(2906002)(186003)(305945005)(33656002)(81166006)(81156014)(54906003)(14444005)(7736002)(25786009)(256004)(66066001)(4326008)(68736007)(83716004)(14454004)(71190400001)(71200400001)(6246003)(316002)(6436002)(5660300002)(6486002)(53936002)(229853002)(36756003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5173;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jjvcp9/FuCA+7L2BLRNXI2KVPUCKVLkqEiABBUAolJOx08v596JYEHvi8zyej5TMk//dNwHPC0vzjiDo5fdGgG8mKoSw/LOPTRQSBlXWnirIGyuLD34jckMdDkxKt/2KThV1le9URf+Rya6TPXtbRIZEDHUIlgwYBpQ0s4c0dJPhdSlqgTMgyjlRNIvCFJe9umdHHhibwwfH9uPPj/UWdAnfHZaN4MNvve9gg8TLo2alcjFkCF0RPGYmpkdRm2aEkepPJq0cI2Hf7NIcFxWOzHAA+Txw4Ux+0T0ZS3Tm1pEI/aqxDBBJNcaRbcLegFZupiq6we1WvtE8zBneMUe1Cc67keYOdH69ZwHfXsgnLKbqbV5g0rNHMgrvEA8q/0zaHsvbiJzCXH2A01wrQMxqUm64PoDlJJjzeD/rWHu+TsE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <92DBC1E19E9DE0418FCBE6C11065680D@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac502c48-e668-4174-56e5-08d6d83ccac7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2019 07:21:33.0143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5173
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On May 14, 2019, at 12:15 AM, Jan Stancek <jstancek@redhat.com> wrote:
>=20
>=20
> ----- Original Message -----
>> On May 13, 2019 4:01 PM, Yang Shi <yang.shi@linux.alibaba.com> wrote:
>>=20
>>=20
>> On 5/13/19 9:38 AM, Will Deacon wrote:
>>> On Fri, May 10, 2019 at 07:26:54AM +0800, Yang Shi wrote:
>>>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>>>> index 99740e1..469492d 100644
>>>> --- a/mm/mmu_gather.c
>>>> +++ b/mm/mmu_gather.c
>>>> @@ -245,14 +245,39 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
>>>>  {
>>>>      /*
>>>>       * If there are parallel threads are doing PTE changes on same ra=
nge
>>>> -     * under non-exclusive lock(e.g., mmap_sem read-side) but defer T=
LB
>>>> -     * flush by batching, a thread has stable TLB entry can fail to f=
lush
>>>> -     * the TLB by observing pte_none|!pte_dirty, for example so flush=
 TLB
>>>> -     * forcefully if we detect parallel PTE batching threads.
>>>> +     * under non-exclusive lock (e.g., mmap_sem read-side) but defer =
TLB
>>>> +     * flush by batching, one thread may end up seeing inconsistent P=
TEs
>>>> +     * and result in having stale TLB entries.  So flush TLB forceful=
ly
>>>> +     * if we detect parallel PTE batching threads.
>>>> +     *
>>>> +     * However, some syscalls, e.g. munmap(), may free page tables, t=
his
>>>> +     * needs force flush everything in the given range. Otherwise thi=
s
>>>> +     * may result in having stale TLB entries for some architectures,
>>>> +     * e.g. aarch64, that could specify flush what level TLB.
>>>>       */
>>>> -    if (mm_tlb_flush_nested(tlb->mm)) {
>>>> -            __tlb_reset_range(tlb);
>>>> -            __tlb_adjust_range(tlb, start, end - start);
>>>> +    if (mm_tlb_flush_nested(tlb->mm) && !tlb->fullmm) {
>>>> +            /*
>>>> +             * Since we can't tell what we actually should have
>>>> +             * flushed, flush everything in the given range.
>>>> +             */
>>>> +            tlb->freed_tables =3D 1;
>>>> +            tlb->cleared_ptes =3D 1;
>>>> +            tlb->cleared_pmds =3D 1;
>>>> +            tlb->cleared_puds =3D 1;
>>>> +            tlb->cleared_p4ds =3D 1;
>>>> +
>>>> +            /*
>>>> +             * Some architectures, e.g. ARM, that have range invalida=
tion
>>>> +             * and care about VM_EXEC for I-Cache invalidation, need
>>>> force
>>>> +             * vma_exec set.
>>>> +             */
>>>> +            tlb->vma_exec =3D 1;
>>>> +
>>>> +            /* Force vma_huge clear to guarantee safer flush */
>>>> +            tlb->vma_huge =3D 0;
>>>> +
>>>> +            tlb->start =3D start;
>>>> +            tlb->end =3D end;
>>>>      }
>>> Whilst I think this is correct, it would be interesting to see whether
>>> or not it's actually faster than just nuking the whole mm, as I mention=
ed
>>> before.
>>>=20
>>> At least in terms of getting a short-term fix, I'd prefer the diff belo=
w
>>> if it's not measurably worse.
>>=20
>> I did a quick test with ebizzy (96 threads with 5 iterations) on my x86
>> VM, it shows slightly slowdown on records/s but much more sys time spent
>> with fullmm flush, the below is the data.
>>=20
>>                                     nofullmm                 fullmm
>> ops (records/s)              225606                  225119
>> sys (s)                            0.69                        1.14
>>=20
>> It looks the slight reduction of records/s is caused by the increase of
>> sys time.
>>=20
>>> Will
>>>=20
>>> --->8
>>>=20
>>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>>> index 99740e1dd273..cc251422d307 100644
>>> --- a/mm/mmu_gather.c
>>> +++ b/mm/mmu_gather.c
>>> @@ -251,8 +251,9 @@ void tlb_finish_mmu(struct mmu_gather *tlb,
>>>        * forcefully if we detect parallel PTE batching threads.
>>>        */
>>>       if (mm_tlb_flush_nested(tlb->mm)) {
>>> +             tlb->fullmm =3D 1;
>>>               __tlb_reset_range(tlb);
>>> -             __tlb_adjust_range(tlb, start, end - start);
>>> +             tlb->freed_tables =3D 1;
>>>       }
>>>=20
>>>       tlb_flush_mmu(tlb);
>>=20
>>=20
>> I think that this should have set need_flush_all and not fullmm.
>=20
> Wouldn't that skip the flush?
>=20
> If fulmm =3D=3D 0, then __tlb_reset_range() sets tlb->end =3D 0.
>  tlb_flush_mmu
>    tlb_flush_mmu_tlbonly
>      if (!tlb->end)
>         return
>=20
> Replacing fullmm with need_flush_all, brings the problem back / reproduce=
r hangs.

Maybe setting need_flush_all does not have the right effect, but setting
fullmm and then calling __tlb_reset_range() when the PTEs were already
zapped seems strange.

fullmm is described as:

        /*
         * we are in the middle of an operation to clear
         * a full mm and can make some optimizations
         */

And this not the case.


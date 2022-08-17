Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C335C59693B
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 08:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238715AbiHQGNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 02:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiHQGNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 02:13:19 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B45CDE;
        Tue, 16 Aug 2022 23:13:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIqvSv2lPpjsrZ8P2sZYQE5TFqgXMvxnju/QdSaMSSAoPlmCNheoOy/DUArdQ8gsy/7JAAComwJwZMq87qYWK8eXQcTH+3ajmGZocVjdqeQBGoAtCTruJ5tjd+gKn7ANCZn4ffN5oJRj4NgZUIknlM4yBMRxmpKdwwKqFTFQ7gqQhId/gGkpWYks3rOQogy6Ph79pu/Hp4CYlaVZo/sr/tLuqfJaZzgvjnKWLAE0sDv0DDW0a7YUzSC018aNLafoBd83kYs+t7tArHYKapHNPMPGLkey6WB5aCSDBbdc6lnmdjDIoaLIeEdLWQ4AMQIzhZHNjWOLRjJW7PqUV6RMGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wj6O6kTlZvpwkrJz7YV6nBkdksswDezQWAHfkpAdnbw=;
 b=IOCUzcPMeSm0SQm4AzZUUTBG46uBTSapz0HN2ljM87JLdfgJHxqkXePxtAjq8ZJFquUYXVyX0IDcfAJFccpZR2LmoZDP/0rHCvRH1KeGaOTn0GQCAagY/O/aDBVQZKQn38XQm7wnT1/Z0rPEaV0QZPjDWbwnO6BHVVO/UsCcQJJkCo/oFiNhz/td1LSjjO7lcz30uDNWXt2zNb6kf/kqhLJWlbP7GBuNK6smqRyqNNsf6cjw7Dk524Y/W4XOFcXKNvDc4CPcd5xGwybTKpsAGqQybV7jsOFCTUaAiExpCKjYPU5MZr0Gc6rLhc7t6pt1M5sH5KQZB6avC3f0r3pXeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wj6O6kTlZvpwkrJz7YV6nBkdksswDezQWAHfkpAdnbw=;
 b=hxtN/Ml4fDT87s8BmTqWhuAjkLy6hgWNvSsw8kemjZsjIyHxK122PUH9O6BKDMDbxb/5uSuVGUqZfA2Ij7vPdnj8DLyQA/Rdldvb+zqWvQhJAhPuF33uUFHyCUFsvp0GWb9xI1PuUf4Do97cbqb8r9UGiA6pyyXQKn2gDem9qpd3P0v9XvO9QFToEnSjchiaxR3zqrOwmWkWCpFigDVnZudBJRrfi60j8htPFQyV3CwMsvPLq9FWLaVVgFagYz9dojiFItm610C02BkSrjAqhcmlIVv41qJXxPOzZFdF1i7LdRQCPyTKyxflxBnCy116iMnII0pRprBilEgMMvP3uw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by LV2PR12MB5944.namprd12.prod.outlook.com (2603:10b6:408:14f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Wed, 17 Aug
 2022 06:13:14 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::eca6:a4a7:e2b2:27e7]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::eca6:a4a7:e2b2:27e7%5]) with mapi id 15.20.5504.027; Wed, 17 Aug 2022
 06:13:14 +0000
References: <6e77914685ede036c419fa65b6adc27f25a6c3e9.1660635033.git-series.apopple@nvidia.com>
 <CAC=cRTPGiXWjk=CYnCrhJnLx3mdkGDXZpvApo6yTbeW7+ZGajA@mail.gmail.com>
 <Yvv/eGfi3LW8WxPZ@xz-m1.local> <871qtfvdlw.fsf@nvdebian.thelocal>
 <YvxWUY9eafFJ27ef@xz-m1.local>
User-agent: mu4e 1.6.9; emacs 27.1
From:   Alistair Popple <apopple@nvidia.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     huang ying <huang.ying.caritas@gmail.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, Huang Ying <ying.huang@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate_device.c: Copy pte dirty bit to page
Date:   Wed, 17 Aug 2022 15:41:16 +1000
In-reply-to: <YvxWUY9eafFJ27ef@xz-m1.local>
Message-ID: <87o7wjtn2g.fsf@nvdebian.thelocal>
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0039.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::14) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd77fadf-1ae9-4220-08e6-08da801791d3
X-MS-TrafficTypeDiagnostic: LV2PR12MB5944:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RK+Crj00aVCHeLE/+0n3v1vGcRXvmUb3kT0rIqW5coI9M4tsHm014z/VmD/NWVtGHksQz1MrenC00/aRax5objuTgeUzXSBFDXURSBn91zmIrsJfGHc0xoaO/WiV5KCR/ept/OVzIKhR0N2JnnP9Dup6/ixOGaFIfQBwKn6BnjnHblmkwQdy/y+VYh3JciEffiN7p1y07PIuoln+17Wjrg7PT9SvnLxX+UMXcrlJnrYc/sgq7EoyFxucETliiV2RmFlhEt3Su5jNEFj0+CAxmAn5XyLHTmh1sizlJ3Jx3l0IQMF4cNTeMsZKYZ53myJ0FE4rFNbuEyvMsiMDzwDtp86IYryoy3Ft0JizEomVVZDGmZvkcK11srEDv/T0nKH+II2mDqnNsRCktzF69SgxAvJvseB9vAwyG3IIkdF4Yw1KycyOjLOX5bvOEy3k2mMq5mHBdQS/9MszA86tTJc6/l2EzYqeR42yPJTb60jAjcseRaPq+Uhm3nVDcRoJ03hiP4I2m75uNyL6fcSqcMG8E2v3Q+rlJ6xFNykFRQysBiTOXIBDMi34rk5/4KDbsVAqOWFmGqowzN/YfDp6a1VQH5v2+ISvcdCBSFtUebIonBgY0pgDQ6kLrlyvtGeGz0hDhMpJfYuj2mMuz4HJI+slKqgoLKbrtdBlzpIlRW5VPdLh+mkzB08VaarJL69gC9W/ijqExTkwMYWy31xzaMBlUWimGSmK3ty0cXLanaxGYtGNmcVAE9iiJWgCfeHObaIUkpnUSDPIiz9ZC5V9b1b5UxHq7ouziFT80eWjNIaQLAU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(66556008)(66476007)(9686003)(66946007)(8676002)(2906002)(4326008)(316002)(478600001)(7416002)(6506007)(41300700001)(26005)(8936002)(86362001)(6512007)(186003)(83380400001)(6486002)(5660300002)(38100700002)(6916009)(54906003)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XoMQ7aTm7tF2gUnUY2jGFv5CLvy6wE7bgCXugapuyw/uJEF7gVpkpdFEzFya?=
 =?us-ascii?Q?CnMOx1Q7Wi/ii4HgPNh9mSrDPWGGjKj9ocG5J3xL9ePsgj9eBDG8o+bjNvJp?=
 =?us-ascii?Q?+7HIbxaKuMaaMMW8XSdWe38Yuo4YkeLX3OlBuLhsnDQa9K2uuCf6bVK7cLht?=
 =?us-ascii?Q?zDfF4unlR5R+xpO9lTLQOjofzwHQh0/rhk8lhLWRuDR6CBZuMLoUysHXf+Gq?=
 =?us-ascii?Q?mYzOYQNSaiRIYd3R8IHuuyV6LyqpvXlP2kRBtd1+9G38BazJhMfcDVRD3KtI?=
 =?us-ascii?Q?o5gZ/wIZnD0UUySSgu7FiXWGnxLe9N4Cue/vCqKDrgM22rR/jPVMiTG9s0y/?=
 =?us-ascii?Q?a1BPoPjaGngzO0TPjFKsYNfNi2W5gx8bSt7IBVTSCQ+pgWsodsrGkviy4vQW?=
 =?us-ascii?Q?sQWwga+xEdJHDYlxnGK6xEFMCv88HUwdvFhlWuWjS1b0SSl6/9c5dDfJ/sM8?=
 =?us-ascii?Q?NJwScKLTcbAgD7nqIqKD1kbeyEKm7z/f2TUGfuDQPi20pDqCyy8sUpB3dTMg?=
 =?us-ascii?Q?ckeklUTORxDtf+baX1bt6+bgQg/He3zblzvNxnayZPmeITYkm7uoqIW5y3Lx?=
 =?us-ascii?Q?nuMNeKoKrSOyc9YQ7eVklBZVpp6c48Zj7TiQMwVrT2RsbNbj79HYyh4DKvZw?=
 =?us-ascii?Q?fa7bclp33g8eU73KnJtkd7I/MrHVeqAP/Uv+XZSDpFg3KeFcHB+4Cm6ahRSs?=
 =?us-ascii?Q?I8P7XlDlsUKatJzSzEkfKv6ii1yHHL8KGov7sJbWVcTBHbfyZFLuzCjlUVjX?=
 =?us-ascii?Q?Qu5WqQGJKyS6YMGiTZtazULwX3HBMF/4/bwnKKP2bUGtM6KTT3rYp+IHYnB3?=
 =?us-ascii?Q?/DffqnO/d94WyMe+woCOx7VC/gpb1A7ZDgWd2JDNlt7HkpW6kRBdyQzo6pvM?=
 =?us-ascii?Q?sWfx9PkzXFwKF8VPvfQApML04lTQ71g5m+1k8b8tHYnnwrKJlqEns1y7VqcB?=
 =?us-ascii?Q?LrweflIHJOkEd7I3+Gemvs5AqXg7KGuAIy0OgERcJPGuPR6Vn0DpRRrTgAvY?=
 =?us-ascii?Q?NJON5mtmRuNsOEsK5Fxh4VxpgLyIso/6+gi7JspLNHXnRd5cPjL7sVax5Iih?=
 =?us-ascii?Q?tjsP3941jmFR1bgBotxZFy2fMdhUyuI37rviHM31SBcRBCFCaspHv2eLGXtr?=
 =?us-ascii?Q?m9ilRjn7+39FLaeVJbOnTuO5FvMjFnHbCk0h9DwukYY8698yIFvfNkkm3Y3P?=
 =?us-ascii?Q?IGkUJP4WA27D1VpL2/EAKaeK72raPzLyXAoCkFeNPCNMJaLG/cdFje5l4NvL?=
 =?us-ascii?Q?jlUlQkv8OD+dt+rFGZnwTb46F4uPSMTCN/NdwS7jLLchS7e0vXnJF0OoYzwB?=
 =?us-ascii?Q?lLpp1GUeBY4SynGE4EOKCVmCj1zUkxgF/6QHcL6RLcv11JlOA9Z773ZKL6mA?=
 =?us-ascii?Q?ZH+9K+B8sliPhw+oC5fDPwqclvQMvy+woej5X/1uL/TahQ36GixtxWoPSNyc?=
 =?us-ascii?Q?y31+Y8MI0JsOEkU4eF/9IAPTxu1hch/ptqYR8kUvjAuzVFeY0cOaIErJKJyA?=
 =?us-ascii?Q?HtyJdyJE31lTbuu3HrOARQvpwjf63d5PwQez0R95gzwtls4/COtXR+4C5dih?=
 =?us-ascii?Q?ZIHbVDh77eCqioq4xK/A6VySJt+LqUf1cxl/nsOh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd77fadf-1ae9-4220-08e6-08da801791d3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 06:13:14.7194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SEhIvMM1282l2Rh3WRSm+/rJmNAX6ivK6zBQI/cg+A+NvUjdARPO8IR9KRuLNaWXYkpMkF6Okkqg4TcfC7Tvpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5944
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Peter Xu <peterx@redhat.com> writes:

> On Wed, Aug 17, 2022 at 11:49:03AM +1000, Alistair Popple wrote:
>>
>> Peter Xu <peterx@redhat.com> writes:
>>
>> > On Tue, Aug 16, 2022 at 04:10:29PM +0800, huang ying wrote:
>> >> > @@ -193,11 +194,10 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>> >> >                         bool anon_exclusive;
>> >> >                         pte_t swp_pte;
>> >> >
>> >> > +                       flush_cache_page(vma, addr, pte_pfn(*ptep));
>> >> > +                       pte = ptep_clear_flush(vma, addr, ptep);
>> >>
>> >> Although I think it's possible to batch the TLB flushing just before
>> >> unlocking PTL.  The current code looks correct.
>> >
>> > If we're with unconditionally ptep_clear_flush(), does it mean we should
>> > probably drop the "unmapped" and the last flush_tlb_range() already since
>> > they'll be redundant?
>>
>> This patch does that, unless I missed something?
>
> Yes it does.  Somehow I didn't read into the real v2 patch, sorry!
>
>>
>> > If that'll need to be dropped, it looks indeed better to still keep the
>> > batch to me but just move it earlier (before unlock iiuc then it'll be
>> > safe), then we can keep using ptep_get_and_clear() afaiu but keep "pte"
>> > updated.
>>
>> I think we would also need to check should_defer_flush(). Looking at
>> try_to_unmap_one() there is this comment:
>>
>> 			if (should_defer_flush(mm, flags) && !anon_exclusive) {
>> 				/*
>> 				 * We clear the PTE but do not flush so potentially
>> 				 * a remote CPU could still be writing to the folio.
>> 				 * If the entry was previously clean then the
>> 				 * architecture must guarantee that a clear->dirty
>> 				 * transition on a cached TLB entry is written through
>> 				 * and traps if the PTE is unmapped.
>> 				 */
>>
>> And as I understand it we'd need the same guarantee here. Given
>> try_to_migrate_one() doesn't do batched TLB flushes either I'd rather
>> keep the code as consistent as possible between
>> migrate_vma_collect_pmd() and try_to_migrate_one(). I could look at
>> introducing TLB flushing for both in some future patch series.
>
> should_defer_flush() is TTU-specific code?

I'm not sure, but I think we need the same guarantee here as mentioned
in the comment otherwise we wouldn't see a subsequent CPU write that
could dirty the PTE after we have cleared it but before the TLB flush.

My assumption was should_defer_flush() would ensure we have that
guarantee from the architecture, but maybe there are alternate/better
ways of enforcing that?

> IIUC the caller sets TTU_BATCH_FLUSH showing that tlb can be omitted since
> the caller will be responsible for doing it.  In migrate_vma_collect_pmd()
> iiuc we don't need that hint because it'll be flushed within the same
> function but just only after the loop of modifying the ptes.  Also it'll be
> with the pgtable lock held.

Right, but the pgtable lock doesn't protect against HW PTE changes such
as setting the dirty bit so we need to ensure the HW does the right
thing here and I don't know if all HW does.

> Indeed try_to_migrate_one() doesn't do batching either, but IMHO it's just
> harder to do due to using the vma walker (e.g., the lock is released in
> not_found() implicitly so iiuc it's hard to do tlb flush batching safely in
> the loop of page_vma_mapped_walk).  Also that's less a concern since the
> loop will only operate upon >1 ptes only if it's a thp page mapped in ptes.
> OTOH migrate_vma_collect_pmd() operates on all ptes on a pmd always.

Yes, I had forgotten we loop over multiple ptes under the same PTL so
didn't think removing the batching/range flush would cause all that much
of a problem.

> No strong opinion anyway, it's just a bit of a pity because fundamentally
> this patch is removing the batching tlb flush.  I also don't know whether
> there'll be observe-able perf degrade for migrate_vma_collect_pmd(),
> especially on large machines.

I agree it's a pity. OTOH the original code isn't correct, and it's not
entirely clear to me that just moving it under the PTL is entirely
correct either. So unless someone is confident and can convince me that
just moving it under the PTL is fine I'd rather stick with this fix
which we all agree is at least correct.

My primary concern with batching is ensuring a CPU write after clearing
a clean PTE but before flushing the TLB does the "right thing" (ie. faults
if the PTE is not present).

> Thanks,

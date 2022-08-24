Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7414059F142
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 04:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbiHXCHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 22:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbiHXCHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 22:07:37 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481D871BEF;
        Tue, 23 Aug 2022 19:07:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BW0HOr41CDsV/wGrunk2Lm/J85BAU40eEviEHRs5HMkeP/sEftGmpDq3jpPFAZoATKUIRb+aDlxf4/oANzS05JhunIQtgPPct0ut54CyS0gHR1nNmDas1oBgjPRe5xm8QOlb0EREAQ/FL6HZh3hhAZLVEbPkbB1iSwZ6+L2TZHxIP/o19HZyki1wWgsuDT+BnMqPbwmioR/KTCCyQKRSCkgsFYjyK7npbTjNGj+W7ObCYniAU1bLSMMONx4HU97gHc02svu3BvB2Boq549aJSK1JlkF6ToLt5jONjiTSV/8/wdPLtZoTK3U7UPlv0h0L0MUvHLUrikWaxHOwkYmXvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/EsHsBSpkl01Xgx6E992Gm8GA/HDYoWLZnjRlByMO6c=;
 b=i/Pb4VlzU5vTjxaaqGRkwEPTK7M3uHrfzzF2un4WZk0DwVr3VueGmNPwgdj9YzvEGNuKUqbpS1KO/iU3NvPmL/0lmcmB4PVVR11ELFZXrso41NOyz3NJXoZmx1cONlLuVwW3EZTclhr4UQzBwciV/OGLrje2XqLrnJi7dQrU8TCQHgF/400q1qd+bVR99cnslBs3JFPL2LsRKJRU4LbYfK0QRAXnOORS5KREjy7JBn45l4ErO78CuOWF9fvcrusi91At+UlOlb6eY/4uLwqvxJqlGyE9mIoqmkR+0ZdogXAcw5rewccsdcnFb55L+TqgnHSyme3j3NK5LeMkN0auuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/EsHsBSpkl01Xgx6E992Gm8GA/HDYoWLZnjRlByMO6c=;
 b=QWOxPO9Z2UDNra3ELXopKNR8DJ4hwzrnvL6BevAQlnbwv0irnyb7EBFGFvZylVGQIJoEyggjmXxsNxw20HivdHUkyS5BAQAnYDpA1B/w3NmV/7oX1HD2sRqwEeuTXUZxGGXjfLMxp5HR7+Vm7PNfV0x6gNbnbnwJcgBmZCmWhEy3Te0j6wO8OQ7MRw0sRSkX2BMts7IGJUc6tEI+S9ex/0xhxFN7mrmRSTnCgosTAtDiNHJKUeXh9XMv2esPTbJA8akB8ZE5ya6doyob6WXDT+xgw0RbHggp1XCjVar2SvtXvAEJ7vnMnQnQIbe+7YnGOL5gz/wF8I3uEpPtixfBaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by BY5PR12MB4918.namprd12.prod.outlook.com (2603:10b6:a03:1df::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Wed, 24 Aug
 2022 02:07:34 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c%7]) with mapi id 15.20.5546.022; Wed, 24 Aug 2022
 02:07:33 +0000
References: <6e77914685ede036c419fa65b6adc27f25a6c3e9.1660635033.git-series.apopple@nvidia.com>
 <CAC=cRTPGiXWjk=CYnCrhJnLx3mdkGDXZpvApo6yTbeW7+ZGajA@mail.gmail.com>
 <Yvv/eGfi3LW8WxPZ@xz-m1.local> <871qtfvdlw.fsf@nvdebian.thelocal>
 <YvxWUY9eafFJ27ef@xz-m1.local> <87o7wjtn2g.fsf@nvdebian.thelocal>
 <87tu6bbaq7.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <1D2FB37E-831B-445E-ADDC-C1D3FF0425C1@gmail.com>
 <Yv1BJKb5he3dOHdC@xz-m1.local>
 <87czcyawl6.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Yv5QXkS4Bm9pTBeG@xz-m1.local>
 <874jy9aqts.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-agent: mu4e 1.6.9; emacs 27.1
From:   Alistair Popple <apopple@nvidia.com>
To:     "Huang, Ying" <ying.huang@intel.com>
Cc:     Peter Xu <peterx@redhat.com>, Nadav Amit <nadav.amit@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
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
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate_device.c: Copy pte dirty bit to page
Date:   Wed, 24 Aug 2022 11:56:25 +1000
In-reply-to: <874jy9aqts.fsf@yhuang6-desk2.ccr.corp.intel.com>
Message-ID: <87czcqiecd.fsf@nvdebian.thelocal>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0191.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::16) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5fc7fcf-eb26-4461-e1d3-08da85756851
X-MS-TrafficTypeDiagnostic: BY5PR12MB4918:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AZ0ERyiZQbgOuusr6wIrkirtipLx3fxd0p93qmdogTeS0jvGNpoLpsdSxunIB5vtIlsxyPB4EO8IU75QXFPJ6b0AwYgx6MIG+l/f5r6WMU3jDZEzaU7Drq9CclGy2Tk72Rd+SSkOxryOkoAVISfIrBHpHP6dRwClvawmf4sZplj84FaaljpYGXAjsZa0+8VQosUSy3XALE9AtQMNzNLmoMVVBj6ILkYoubbjDES0FIVIhmtZttE9NHHpbTmyH0C3cXE/nBlVHMNKdGJznrvCS7Yf0oaQJI1WxM/nBx4JKkxuqR80CkE24+TILt1Wtdm/5TdHUdQCas75LexjYOwEhv3i7WZUCKpOOVty2kHgH8alXAx2Om0Q6EkJuGg7/Sagem+uSR19Vxrn27V7rRQimwAMHoV0fh8gww9WbBbT3Fe1py+ydTA+H6XNcSHmHi8jfepA7sswCGHr4FhFgvN2m9g1qrzm46OjQp15bXo66n590EziaGIJHR8AhW1rhhDSP6LK4RWwdCuAFVImswFLeUQ5EdVXTesn6+xttXffiNPybNBESKD6ZnPE3V+663uuQ1rtqghHaMedu2WWaTwnNulzUrgd/WpyqMnaQJPlWlDylUn6ENIUoED8e5ugKE+THbJquGJ2AoQ8NHEpH51Y87roGj1SQ1oUh04ZIQNngVT1zGVOKhI8tgBH56atp7DizeI4oDJSkmePn3Ajzcpd0dcw2RdTzaGyN9QCCaQ/Hh4GZXdm1rI9MB8eHz5fGovG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(26005)(2906002)(86362001)(6506007)(6512007)(9686003)(186003)(38100700002)(83380400001)(54906003)(6916009)(8936002)(316002)(4326008)(66476007)(6666004)(66946007)(8676002)(66556008)(478600001)(6486002)(7416002)(5660300002)(41300700001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/6fK4Tc8EN+t3UKDjkLLwN1vrOkj2LEFVherEZU190HpKJL6++AEvqw4HDTp?=
 =?us-ascii?Q?iZ+iWnPK7wppbWZqIQnoU7C4BTlYp1qmOs7wHh76T3LohfX+g0stMN9NIZ84?=
 =?us-ascii?Q?cP6/6k/bcOP7FT2LF6tatb5d0to5GFXGy3dkYC6AnPr8qe7MrUfwvsCjAxC5?=
 =?us-ascii?Q?Oq6H56XWBGB6MNHf2UAB5/WIHZ2LQg04rGnTbtsrfvz8xRicSS21DUOoul8j?=
 =?us-ascii?Q?xM7U4asLqVbnfH2284H+gz1ilvDyEmu1c5zQq6lM/EB259W+Z6Y2/JkN7rHw?=
 =?us-ascii?Q?/ULtweEd9eXNFhliL8E762OzesWYiXoeG/6DCH05SOrfido0dEm7dS44EdP+?=
 =?us-ascii?Q?jdBNRwep+oTmu9i+AqIdEulCin+Umd6qJThNyDx4lDAbFR62XiKBD4QwHMYY?=
 =?us-ascii?Q?iAsyvNZCY2SZiWo6yng2TaR94SlHb2ehUGDUhtKTK3Udd3b7ronbiWJyYHzM?=
 =?us-ascii?Q?OkccaHwqL8RL9+z80w39i4zRmYrmfyJ2BiVfwlif5nFv281SuRjNXIt+PWiK?=
 =?us-ascii?Q?QPAVjksGT7xhWgPExRa0dsKcO6TZUUCsZ+rxFlBxnfY5wgSamBdaUgJxh91G?=
 =?us-ascii?Q?s5I0y/E4xl2mG9+sjmRVcULOh6p1Yy+CLZu0Vh3zOOGJNkho8wCGaRtSqJBv?=
 =?us-ascii?Q?JHLSu/1rZLDdGqQTOAr59+pBtR3ySzaghM6X2CgLqgedkA9BomViZAMFNSfg?=
 =?us-ascii?Q?H4xzOdk0uvYtZcG3B3gIaFCy+JbMVJqnQ0SUFYDoxVvO4uqZ3dsWfd3UhUZp?=
 =?us-ascii?Q?vnQ7cZpfPD6Z59h7KP2ohSEIyF9OYbt1cRhgtc/FHYwMd9H+1KQ/4k/Sk0Tg?=
 =?us-ascii?Q?AoIB0yyFe01P5wgbkp+A27ZYDYXapmnffZpgXaMyCViFUxSfjVk/NWNauJNb?=
 =?us-ascii?Q?xRpw/w77h8MsAGBD3RG2QJW0sAnZwGOwgdGP4EcH75UOdEw7Oznuh74evVtw?=
 =?us-ascii?Q?aCe3IsELi2mPCxQtBuXiBFgB2Dlt6iLxarWCwNpZAcJWTyH3DmA1D5348GqM?=
 =?us-ascii?Q?/bW+9NZ4PQzxHQ7OqDpd2Cuiv2cVKbHSw3MV8yc9pr2WzwLSENW0n2BsHGtS?=
 =?us-ascii?Q?iEubZqKQ0JNRmT/TTIwlfcuTJ+25E3a2cO/5wOdqT9MWw3HIAMuO64lqWcVF?=
 =?us-ascii?Q?xxJCFp8RbBWqZUtavLRXY8B4KMOC0n6Ot+IR6dss67dfEUoVaVnjCzXFkRRy?=
 =?us-ascii?Q?QeyYcizh0xcoNj5qBFuOT1kgAY+I2eP/Xra7Yvkn8glp1F1xlLC+XYCqXy21?=
 =?us-ascii?Q?WNoORWc0Bij5x7+hL53yT/LFfXMURNJD+oDH5dQSCcOvmbRoeYM+l5GgoGgl?=
 =?us-ascii?Q?0VK+rJ67WzStwmzCr9bYZXxDQa5EgRZQLEJPGXKMAJn7TpnnPiHJHkMK+Hkm?=
 =?us-ascii?Q?s5bWhEVXqhxnQ8dW0jefgCzAGAKklOr+W8jl6qzUxYlDJxlplhH8GoBHq4nR?=
 =?us-ascii?Q?wq7TWpaDW4tqoyDGeEmJX7HVkl9MxvcsjlJSkydbMSdCfzuvzsAPXG93ieGN?=
 =?us-ascii?Q?gykzrgcmX6uooBSacv6Plqy4XYHDCRnERaae/Roq9CPJErxquzm5FodoISU1?=
 =?us-ascii?Q?D1TrxP02fMPG3Xu0QnZheLrY3NVIrp9wVpTbOt48?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5fc7fcf-eb26-4461-e1d3-08da85756851
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 02:07:33.7335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RQXgCX74IYU1+4DNPdhzNTO0u8EKAa7l7w1vu6iXDq717ms42rJt/KrnrRLj8KRJmYEBHogq/6UIbtFMZC8l6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4918
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


"Huang, Ying" <ying.huang@intel.com> writes:

> Peter Xu <peterx@redhat.com> writes:
>
>> On Thu, Aug 18, 2022 at 02:34:45PM +0800, Huang, Ying wrote:
>>> > In this specific case, the only way to do safe tlb batching in my mind is:
>>> >
>>> > 	pte_offset_map_lock();
>>> > 	arch_enter_lazy_mmu_mode();
>>> >         // If any pending tlb, do it now
>>> >         if (mm_tlb_flush_pending())
>>> > 		flush_tlb_range(vma, start, end);
>>> >         else
>>> >                 flush_tlb_batched_pending();
>>>
>>> I don't think we need the above 4 lines.  Because we will flush TLB
>>> before we access the pages.

I agree. For migration the TLB flush is only important if the PTE is
present, and in that case we do a TLB flush anyway.

>> Could you elaborate?
>
> As you have said below, we don't use non-present PTEs and flush present
> PTEs before we access the pages.
>
>>> Can you find any issue if we don't use the above 4 lines?
>>
>> It seems okay to me to leave stall tlb at least within the scope of this
>> function. It only collects present ptes and flush propoerly for them.  I
>> don't quickly see any other implications to other not touched ptes - unlike
>> e.g. mprotect(), there's a strong barrier of not allowing further write
>> after mprotect() returns.
>
> Yes.  I think so too.
>
>> Still I don't know whether there'll be any side effect of having stall tlbs
>> in !present ptes because I'm not familiar enough with the private dev swap
>> migration code.  But I think having them will be safe, even if redundant.

What side-effect were you thinking of? I don't see any issue with not
TLB flushing stale device-private TLBs prior to the migration because
they're not accessible anyway and shouldn't be in any TLB.

> I don't think it's a good idea to be redundant.  That may hide the real
> issue.
>
> Best Regards,
> Huang, Ying

Thanks all for the discussion. Having done some more reading I agree
that it's safe to assume HW dirty bits are write-through, so will remove
the ptep_clear_flush() and use ptep_get_and_clear() instead. Will split
out the TLB flushing fix into a separate patch in this series.

 - Alistair

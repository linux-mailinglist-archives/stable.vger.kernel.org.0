Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070AE624EAE
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 01:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiKKAFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 19:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiKKAFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 19:05:15 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D3949B5D;
        Thu, 10 Nov 2022 16:05:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UL+1q+0ICJq5H+NvGx4Dg9fkc+oKABHBABka3b17s+tsLNw2l4gjt87p88xd5CVpewb4vZ/xEKb/u2qPN9nDSB+WcoVGJ555lAhMeOVygZi7F0QryWSNuQYdaCHhzdmIOJdepO1yqcSj+QUMyuOJ9wdBlT7pYdhkzMPWrnEV4FHDoWnzpvywiwC/9WtdvdLSmFU+XCdd7KL8L/g2OFITK1Y0KTmMPWEYdV7XE/gSULeC3uIS12Po92sRKWPjkH14g5gnRdHr2orxVFNycHs1ltZOkSsVjsUaGMCzEhwOlor218NbKGCm7vGnmzLkDXia5mO0bUEptxA8hyiv2ewaag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qyB5sUUvYwEgDpi0dhZhbEWusL/+F3ntj9KG8DkDe/w=;
 b=Z2XPPgnSp2V2q1g22EeN/11eit2ArQOkrBDpxLVdG0w2pdBQHL+oGUJUucBXqSF8KjE+Ue0xS63CgHBO9btZaN5k7SPpMUjrDctfjY0Um0wrAqjQDUwRutNjJIo/vDWdW5BHXowZUjCi0oS0lDW9b6ltT5zsEdPCXgtn+EF7EfyE6kuSD251aLVS9Kb95uNo7Er43BjRTb/WO3Hlf8inP2JmYy6pRF910oL/KpeySBykYwTneFrG/VAY7033fwWKp36UZ9dhce6pTZ1nKNT2IjBDmK7z+3qlzcmGIKJqf0fx0eJejAh5INnZ8uYZCDmUmBcyfG4jZvXPfIhhV3TBpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyB5sUUvYwEgDpi0dhZhbEWusL/+F3ntj9KG8DkDe/w=;
 b=NmyndGogmdSzZ2EM8r/W4UkE6PTa3PtQNV/vJ+DKn4i6yms4wcqQzOejInetRIYk5K+7Lu4EKGvyqMLYNvfAVWZIUy5zhVRD6BfSPPkxz9aN1BdKrA4/avbV86yz48YD8HsAUxCIqkxHIkC/3PIzj6pqyiiDuEef47sMt8EUwbTCWR+5IntMDITgEennnsdSnxUJGfyM5B5BDM+z1TljJEoiIkLkAtAFAIT6hL5HVEt6phZm109mytsY/xlBuG/a5DJpgDylgStHuWma/8EJA31n4n5e2jCTyojF3NJEuKZBE4clsbydIfu9ETnGaeOid/kmILZWZ48Y0UiDkkFtDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by CY5PR12MB6347.namprd12.prod.outlook.com (2603:10b6:930:20::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Fri, 11 Nov
 2022 00:05:11 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::a60d:334d:2531:d031]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::a60d:334d:2531:d031%7]) with mapi id 15.20.5813.012; Fri, 11 Nov 2022
 00:05:11 +0000
References: <20221110203132.1498183-1-peterx@redhat.com>
 <20221110203132.1498183-2-peterx@redhat.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
Date:   Fri, 11 Nov 2022 10:42:13 +1100
In-reply-to: <20221110203132.1498183-2-peterx@redhat.com>
Message-ID: <87tu36icej.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0239.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::34) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|CY5PR12MB6347:EE_
X-MS-Office365-Filtering-Correlation-Id: ef2b4de2-9619-4780-a4f1-08dac37866d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +bgzGI94Ds+BFE244ZalGAGk2EZ6GL/lRlRRGjqsHWY2FJVTkoPWKPOwf9+LMtqNGIo8TQWXSXOt+cdqSTjwW8UcR85tBHtbrD6TNBz95lVospLIUkBiIEZj+rrfOdaGvYbBfC6+GN8ZxHIuUXUH0deZ6+mFz7uIHdmH5FKjPLsxkBxVejYAZZnMIti52WIEl5AmPi0g2YP/m9z44DNqmXcm5MBdHg3NYUW6a8by4Hl5GHiByafON9Ho7PPj1Kd2ZcWvqYAgW/d4qYWWtUm7i2ITMzH0jadxmKX0dBTBLS4sUAYZUBLw9oOh4dyWOMBewAsB8d6wVKoBhaJcaY8ENhrCY1TnfiSyrUyq9FfhO012fHawRo0CrL7uBQ+Pkyw9pw+T5kpBXU9advc7Mfg9wccNo4qtQfhRl+T/2Qi7M1G8p3CNWp6QjVj5w8+tMspNeRyGeqQIdPaP6UUkMYk4NFpuznfIzuOnIwF7bcNVKXUE3dUIC4UzhquDNVJt0lwRMubKrLRAglzy0UzKuiz3jLGPv1vyYjaMBttrXna9cTSPPK5fFNuaWcA8juXzrfYX31y5ZGYrftSs3InqhH3eHv0xeG/R3rS4vTLOR9tCD9hZkuiR5OepafNWRQf1LYmUe3EBTfvi8KF8LVWoNqnA3NHZGk1klmYpKg/xCP+W0BvAmreGr4FCYFR9QDnHGFfPpZ2hTlm8ZUA7L4xxQ1we9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(451199015)(83380400001)(2616005)(26005)(6512007)(2906002)(186003)(6506007)(316002)(7416002)(54906003)(38100700002)(6486002)(41300700001)(5660300002)(4326008)(66476007)(478600001)(8936002)(66556008)(8676002)(6916009)(66946007)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oSrTcKAuWycM6/uoGLI0aOqHWeslQIj70GDWhUCqNXKK3ia6w8A+5aKH192T?=
 =?us-ascii?Q?WWQrMDIgrCzOTiC0U4mqyUKAgvRuWxYYLcaWYMxLXalVWAqOQQMAZnvMAy8M?=
 =?us-ascii?Q?TWzYZVXWUv0l4Fyf+0ayp21OtIilU36+Hhd8SWIV0zKnqhwrgkbFwCnwpZji?=
 =?us-ascii?Q?1NON4M+q9kEMjg3CzJORjEhKc6yTV7wu2r+ync34Rlb5bkFQP2CWKcsEkpVr?=
 =?us-ascii?Q?ztCulCTnNLPA58NxGA8IenYg8eBdRIoCbabr1RiRI9XVJOant2Ima/UPgVg6?=
 =?us-ascii?Q?h+ENDMz1btg/vlHhgnQdk9Yx0bi6QXXrICJEPhI0ltJSfDXaLLopxxHGevVs?=
 =?us-ascii?Q?/EosHFaEMx83mme3C5TyUNi+ZowRGWAbBI+R4AvqIPPXwgQBuu4UJExM2lHb?=
 =?us-ascii?Q?Q3p8zy+hhneUhNSJO5f08A/PbRzoeyJ78ZGbRpEEFrrUvjiZIzDRZnsF8dGw?=
 =?us-ascii?Q?v+dEjHSFGKpFg+GK5H4zcwSyYGUZMM93gOpk7eupqck18H0qmQ/lXRTl7wpb?=
 =?us-ascii?Q?RME2J+mJ/yht4wN2ou9pA+kqA90jyfCWgSmt3jnTKFuCc3KkOlBTI58K/Htf?=
 =?us-ascii?Q?l7vYu1Iquo3OBpA2Z+djL3vmjOqFaLrLnAUAzG4tcHeimJgh0dECouNjqScU?=
 =?us-ascii?Q?mEtxm3Qu0+351aRf0mHGQOMpSoU2TFq2ikuVbIh0lRL4DPjFnKxvltdbxzdw?=
 =?us-ascii?Q?8ZMrKu3FvapcuI1Pr5QlyMC84xDmD6ZUY5XS5gFZ66+w/JHgnCAE7M4udkO6?=
 =?us-ascii?Q?zTHWer0akj88EzZ8fslzXcOCcpNrTcxljVZBqUIOF8/q2LIi/fqfdrBmuy/g?=
 =?us-ascii?Q?uXCdqRK367D6QsIE5/LTiQz8h2u52pvvTWvLhsCprehFyVRUkTS/K6PDODH+?=
 =?us-ascii?Q?ywmLIQRLCiXOpFACjX+2ZcPVQ5rtprDa9AqlsUVxjBs5fIBfuBl/kzIEFYGf?=
 =?us-ascii?Q?bLlkKlQnxRenwqYhgrPAnqY4nv7c9MelwKTx6yfC7jm7kh59QcVJ/ThGpb+z?=
 =?us-ascii?Q?MC+BIQcr/oy8R/zC6y0oDB9dIQoX8LqNqwFkpOlRuUWc+mvWVnR3rmr9rNXs?=
 =?us-ascii?Q?QMTOwGkMwwOcus0rvjcUpCa4Z4A88W4i2GWvym9qdIBoJBXlJLCb5jVnx+PJ?=
 =?us-ascii?Q?vJsvuOHIYqciH0HzMyJSCLsUXaqmdCJ2oSC03xSIKwL83RzwKKQ7k/eOguLO?=
 =?us-ascii?Q?6yHER+zT+bJ+v4oJPQNuyWx4O+KxWllxDMfiszIW++HGWhHC7gFa/p/9Orwc?=
 =?us-ascii?Q?fvZOlJXzLF6SMc280HzhRLMv1sZ3ozrVLo7cWqnJSzkqA2t1mc7RclwNuhPx?=
 =?us-ascii?Q?r8cNjSbI+Jp+TEA2egz8YuEDGZJPSasNDhwiEkBxTPErHh+tnreCfLyvGgbW?=
 =?us-ascii?Q?si8f/HplctX5CSww3RuQd7+cmCrVnf3fqegRNfoyt4U2q5TCVtjdUUwemdnX?=
 =?us-ascii?Q?TeKIYZJPUTdNmRYWyZG+Vrh96Vxk/QcMWQZKFGPbxOOMsV89GTTDdS6V2bzJ?=
 =?us-ascii?Q?mYzOR5veDCz5r/VZuVTEhA16+/lDu9wgleyHQV55HM8TBztKkxC0GYiYcZI4?=
 =?us-ascii?Q?Jel9ThECBOryLN1PuSzn2jtPoyn/9X34RgHpAWsY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef2b4de2-9619-4780-a4f1-08dac37866d5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 00:05:11.6990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rlr5l4q0Dgb8foYroQBwkjtRDPDlomWBzDwMMWtWy1kXcDB0yPJEDOhdVSxigIDrrF+6un47DrR/ZhFYHi7Syw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6347
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Peter Xu <peterx@redhat.com> writes:

> Ives van Hoorne from codesandbox.io reported an issue regarding possible
> data loss of uffd-wp when applied to memfds on heavily loaded systems.  The
> sympton is some read page got data mismatch from the snapshot child VMs.
>
> Here I can also reproduce with a Rust reproducer that was provided by Ives
> that keeps taking snapshot of a 256MB VM, on a 32G system when I initiate
> 80 instances I can trigger the issues in ten minutes.
>
> It turns out that we got some pages write-through even if uffd-wp is
> applied to the pte.
>
> The problem is, when removing migration entries, we didn't really worry
> about write bit as long as we know it's not a write migration entry.  That
> may not be true, for some memory types (e.g. writable shmem) mk_pte can
> return a pte with write bit set, then to recover the migration entry to its
> original state we need to explicit wr-protect the pte or it'll has the
> write bit set if it's a read migration entry.
>
> For uffd it can cause write-through.  I didn't verify, but I think it'll be
> the same for mprotect()ed pages and after migration we can miss the sigbus
> instead.
>
> The relevant code on uffd was introduced in the anon support, which is
> commit f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration",
> 2020-04-07).  However anon shouldn't suffer from this problem because anon
> should already have the write bit cleared always, so that may not be a
> proper Fixes target.  To satisfy the need on the backport, I'm attaching
> the Fixes tag to the uffd-wp shmem support.  Since no one had issue with
> mprotect, so I assume that's also the kernel version we should start to
> backport for stable, and we shouldn't need to worry before that.

Hi Peter, for the patch feel free to add:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

I did wonder if this should be backported further for migrate_vma as
well given that a migration failure there might lead a shmem read-only
PTE to become read-write. I couldn't think of an obvious reason why that
would cause an actual problem though.

I think folio_mkclean() will wrprotect the pte for writeback to swap,
but it holds the page lock which prevents migrate_vma installing
migration entries in the first place.

I suppose there is a small window there because migrate_vma will unlock
the page before removing the migration entries. So to be safe we could
consider going back to 8763cb45ab96 ("mm/migrate: new memory migration
helper for use with device memory") but I doubt in practice it's a real
problem.

> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
> Reported-by: Ives van Hoorne <ives@codesandbox.io>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  mm/migrate.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index dff333593a8a..8b6351c08c78 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -213,8 +213,14 @@ static bool remove_migration_pte(struct folio *folio,
>  			pte = pte_mkdirty(pte);
>  		if (is_writable_migration_entry(entry))
>  			pte = maybe_mkwrite(pte, vma);
> -		else if (pte_swp_uffd_wp(*pvmw.pte))
> +		else
> +			/* NOTE: mk_pte can have write bit set */
> +			pte = pte_wrprotect(pte);
> +
> +		if (pte_swp_uffd_wp(*pvmw.pte)) {
> +			WARN_ON_ONCE(pte_write(pte));
>  			pte = pte_mkuffd_wp(pte);
> +		}
>  
>  		if (folio_test_anon(folio) && !is_readable_migration_entry(entry))
>  			rmap_flags |= RMAP_EXCLUSIVE;


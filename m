Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7671D57FC9D
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 11:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbiGYJkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 05:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234298AbiGYJkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 05:40:14 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2047.outbound.protection.outlook.com [40.107.101.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02F5F11
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 02:40:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+M2/t3hh9RVpLldnrjSQOFol68rhJkpt9+8uP55PzayvpJmPTrjEqN/7WQBJpP/F+/cGwFypdEG3yVf8F68XNGNmTey2Gmfx0JktUR7QGEUs6AU5fdoBzBfeU8dcrCtgOcGIXH8GFZqxrS4lYbQ9Da+862pouOMz9dvor1e/x0cTwCusC+tjBOIp2qk/wFthDEDp5AIDaxPILXIzWoV3LHH7Wm/gHvxUASqRy5ppmUBxiWBiTYDKIMtK1RnD8CNzoYtK32z2wmrcDmAswBXJwxib6o/2/1auyClVE3b6CVXAlTz6MPy2jG+kLgKEoQmS29FfQa5EGN5M4NpDhEQlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=40ArEgbz0SMOD7TOPvcMGAA8cZs9dBbBHnswNjB/DUU=;
 b=jCe2tgr/kRbEU3kFsJSApcAhYK/FOBuh80B9gnOQ+++gPaNVw1bf+ckbqJU9iSJQKWonKP1B8xesyxaZvxKK7os9S5765s41xtxGDuzXcDFbkhYF6dBFWZ6BN2Y/yNaj372Q3zjbouzuwjSbq5xwEJtxsLzIj8p5jmLHmb0dMfOTprAqui2rAE2jHBIfJDozUbGxBYMNTSwfuICRm/bN360MCgkJpv4COKYbr/IO/ocHqVtxP/H2/Cr0GNK0elmyrIBZ+TyEaZmcD3O54McwfhtZ9wekzCUrHTCvYIaunuo9+s/+KbtdJ5N54kYoezL3TXGrph24Egyn0hWrrfXlIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40ArEgbz0SMOD7TOPvcMGAA8cZs9dBbBHnswNjB/DUU=;
 b=YzwtUh61Z5URgcZ0mf/p6YWfsZgjQp6VWg9Md4bLmK0Ygj9oMrJ2HAAXkqPyYLGgGV11UfFuY4ein+GH72HUgSLa0+uR426dJIZJcxBUdLIOfiBQ31YvepPtCGVuAMuHW9wdcG0ClvPx82BxwDu/uwmdP1tyFShzFvFedp9XPpKOreKGrI6eSm1WkP47sH0EpjhrcNx0NrxOlFBdGwCk3ZZQPRltwJDXNLIXliERWBgv7BrE47ljvEN5QKnb7Lk9ov8CSATv83Y7uenLhgk1n+XRtSuQHge0g8L4VBufr+IekipxOGUUR8KHlakKU7WstPyFUiTctglA9gsCxUmvsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DM8PR12MB5462.namprd12.prod.outlook.com (2603:10b6:8:24::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Mon, 25 Jul
 2022 09:40:10 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::eca6:a4a7:e2b2:27e7]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::eca6:a4a7:e2b2:27e7%5]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 09:40:10 +0000
References: <20220722225632.4101276-1-rcampbell@nvidia.com>
User-agent: mu4e 1.6.9; emacs 27.1
From:   Alistair Popple <apopple@nvidia.com>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     linux-mm@kvack.org, Felix Kuehling <felix.kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm/hmm: fault non-owner device private entries
Date:   Mon, 25 Jul 2022 19:32:46 +1000
In-reply-to: <20220722225632.4101276-1-rcampbell@nvidia.com>
Message-ID: <878rohbkeg.fsf@nvdebian.thelocal>
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0007.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::20) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcd8fb8c-740a-4e84-b0ef-08da6e21aa9c
X-MS-TrafficTypeDiagnostic: DM8PR12MB5462:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b+vc58IA3mSDwuWEwMYR/Tw8vojoXi7Rxiqw4j+aL5UIHPThdyUUEfLbgYhaadkISeHdpWqJIJKENj/QGsYvAc/OOaKcHxzTM8IgaFTUsVx/buTKJLLMxiOJhvEZjSK1GJUFz94kAdC/NfZHVUx5iYYFvmargnsBE4o7uY5LCZWVzJZmfeAc1GTrOrVHEGGJQHhlsVXmckqM1sMlE25UJBTl+r3wXZO46quBbs/zjbjQ0MsnaIsWtl/+JaHJnSeEvnLo9xGGV/TeB8zWzwT1MeoyDcS1LlVRrRlJN8wAgwtgrCLPJ7TPna5z5BXyz26/hUXQbqOAKYAH6Y2aS1ydVeoljq3sRIkoGmbnsB52P32brAvPDwFV0FZUzyZ4304DKppVb2sXHiuP5OkOBUGiwhuHOdGvoGCM6hTyk5EC1FIbc12mPI4i7LIseAvnVPnne6i3NX0pcIPwAuuLci7HCdijxCY0pOyNLstfo9tULn6e3vh58gWr7dIV3KtdDcyWuDFne2QYp3qRSKXQkVmUIlbo+WD2qwyOJ1FqmjP6tSCggi80mIqCExOslQ9/U9GUUIWNtPUi+k6oQs6gIemnf5ZtBb0I+K95lKQtC4pfeLTnwCtx84bNVkyoj4P2cKMBZBCHFR2INBpi8dOH4iH7GeNk8Xc/in+OVj97RCf1L7liXGr2c2aQTuIciKEFXht9MTeywCh02hAtHwM2KxIQ9CmIb7Osl98zbKokYeYkeNdW7nz9hy2vu7SbFKL0acbE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(38100700002)(6636002)(54906003)(316002)(2906002)(186003)(6506007)(6486002)(8936002)(6862004)(5660300002)(478600001)(86362001)(41300700001)(4326008)(66946007)(66556008)(66476007)(6666004)(9686003)(8676002)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z/hArmHS3fhurtBT/RpO+3TGdr2YPn7EMkVc0z1RlaFDgbttVvIDl7gxQWb3?=
 =?us-ascii?Q?9QbATTR1Ok4wpO0AWHtDsYZq+OfwxKV+c2Aq1+rb4mL4Xkjl8oIlBOSk8yQT?=
 =?us-ascii?Q?hGvknB/JLVtPYkADjlqHGNLNnwOvv/Cso+K4MaZWASzfwrRfwHRt66LDQ0mR?=
 =?us-ascii?Q?Pg+YC8CJFLHkhX5U4WCS2pgsHJxgKEC114Co29gurbjMXVwOA3ovHjMPD0MT?=
 =?us-ascii?Q?9pBFNg5moLKLrKqSRF3Q3BoXuWTykWV+PSg8h9n4Vrmwq4F/rj2ymcVRtXe5?=
 =?us-ascii?Q?bUq6oGzPE7fcTYxow55QH5/rMLuBbYL/h/W/C8P0cV3W0m4a1cOK4rG8KlP5?=
 =?us-ascii?Q?Y7ykxaIPvmXUcPAopZL3rJiNsOUG3kZKEYXKWuNAFux5a+3jYo2fzltQaW5s?=
 =?us-ascii?Q?nCwQWxjC51zByrWSBrC7eZAR1FnRpsxzBOoVbi+9FI9XUjxtcB0BbKzio/ur?=
 =?us-ascii?Q?YAgm77XfkII7RAfwo3FunF96szzZOdDkW54l/JfG7Z5ltHKEN2b8kxhkW+PX?=
 =?us-ascii?Q?PkzrPgpuF7qUeSnDh0PyB/L5zC4rXkd6oSsLi418v7tl3RjeOkYcq0232zRm?=
 =?us-ascii?Q?SUxuH3Gj/YXLnhEmQcj6HQ19aFW45+1fIesPRJCGOHmUEggwLgVMQAJLbF6y?=
 =?us-ascii?Q?uYDvsFjGFv6zDccjwXHmp8TaGE+8DUYEy8wYmYY2DzDPYPffZEPV4+cLLWON?=
 =?us-ascii?Q?PPJRbA9NCZWe0ld9Gpn+dypV4OW0x6VodjgaWo0kMy+gOFsA99J03k64xH+g?=
 =?us-ascii?Q?fs+YPeBWaUmJltOZQMOO77obtZtE6PpsWIEvM1v26FmgZtAtEs+X/MF328LV?=
 =?us-ascii?Q?Z8H5zXSij0wwWbpWLTYzjkPNj8vjhPh4Ble7jUoFbAm5J9a6bKs/ZPgijj5w?=
 =?us-ascii?Q?mDgl8obSYLzsoZocoZTi1L46edKKiwatkRKHfOREmUVqvvnRJ5XEAdhhTtPq?=
 =?us-ascii?Q?Ve5BZfRvNyMNYZqI0HRBW3p4zmhrNXy6Mk7X1FMeNN1ULhT/fdajbXeqk+0j?=
 =?us-ascii?Q?ZY/d3UYCHd2479P5S5ZrfvQriqXlcqd6obCNI8Ld1o051sYLpTOUMNcUzd18?=
 =?us-ascii?Q?ASCvychXeLQhQbSyq2bHLgXyy6SOv4Yszh2vSWj/sgridcDJ8ncTj7ky4tpU?=
 =?us-ascii?Q?wtkW2LK8Dqyj8xhSkUKdWR1hw+Zm9gQC3LS8F7Zb5Jm0hI/5Q98IfLvTlyKr?=
 =?us-ascii?Q?U7wMIVWOBX5lnEgAbqAj2gvdqrsAe+r+TsKdLpYxwNeOE8Bvy2zCQIMD80O8?=
 =?us-ascii?Q?tsJNTgnw088erYnY7DtQMN9Xn5iK4KfmjWc/p6s4zAlYWOMwQqzatZsWyV18?=
 =?us-ascii?Q?US1n6SH4P9pa8KPU53q22+e9z+1icw9img2DvX8XxpeSjaz7F8MbKuyjHNEf?=
 =?us-ascii?Q?YhmX3/wkhLchvJcZRDWmjJGlSQOKat/qV2Bs8svhzcKFZDmaN2uzL4YKKUFN?=
 =?us-ascii?Q?rg7EFMnJOUaFcxmEG4FHcRqFARYQ0dwECnT+dcokiB1rwWUcq6erix7ICLsE?=
 =?us-ascii?Q?AcIgOZv1HnHDPkqOYZMXNZudvmR8UOTGYHh+unN1epBinXsDfdNl9HFxgc4d?=
 =?us-ascii?Q?pUbhlN+1KDekpcoT3gTo8YCY8MFXs4y/vqOFi8bj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd8fb8c-740a-4e84-b0ef-08da6e21aa9c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 09:40:10.3436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d2hh/5VIs9QcKch0iS5HnWEvf5evPtgEcfQ+JVOkPicJYB4fVE0SD+E5h6Ski63Pv0R8pJGjYnlqoyBb1oMLAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5462
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Ralph Campbell <rcampbell@nvidia.com> writes:

> If hmm_range_fault() is called with the HMM_PFN_REQ_FAULT flag and a
> device private PTE is found, the hmm_range::dev_private_owner page is
> used to determine if the device private page should not be faulted in.
> However, if the device private page is not owned by the caller,
> hmm_range_fault() returns an error instead of calling migrate_to_ram()
> to fault in the page.

		/*
		 * Never fault in device private pages, but just report
		 * the PFN even if not present.
		 */

This comment needs updating because it will be possible to fault in
device private pages now.

It also looks a bit strange to be checking for device private entries
twice - I think it would be clearer if hmm_is_device_private_entry() is
removed and the ownership check done directly in hmm_vma_handle_pte().

 - Alistair

> Cc: stable@vger.kernel.org
> Fixes: 76612d6ce4cc ("mm/hmm: reorganize how !pte_present is handled in hmm_vma_handle_pte()")
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> Reported-by: Felix Kuehling <felix.kuehling@amd.com>
> ---
>  mm/hmm.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 3fd3242c5e50..7db2b29bdc85 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -273,6 +273,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>  		if (!non_swap_entry(entry))
>  			goto fault;
>
> +		if (is_device_private_entry(entry))
> +			goto fault;
> +
>  		if (is_device_exclusive_entry(entry))
>  			goto fault;

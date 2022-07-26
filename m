Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562E2580903
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 03:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237123AbiGZB3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 21:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiGZB3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 21:29:34 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2049.outbound.protection.outlook.com [40.107.102.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1183ABE2E
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 18:29:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+NcHQxY+KEpQNAsN7utxalVNmrI567P/CIsXAg8Tc0SUppxv6pE+2v9XEIO6yXGx2qVE+g7uPc1lbB+6fBeYMHHbp8ew8zoVUsWANtww6DSlpCDisD1wKgW5e9J11SdHBLqhKLi7d2GN+8AlJCIxmfLfH3+9hrRwbPTf/HgbcGkMewVTwxIAQhNboEw+TylLHlG1qAPWI+gtoWa7ZJfPI9zZofd3PY0NJwnMi8aAiN3Z69Rtfa5ytVKI9n612OJKgec5fLdKj+VIVAsIlXo7uKSGq4C472DXOOYO8oOYUWqZLopWeHJftYpsiDWN2UqN1d296YJBglMQHM5/X5J0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JYP90HtbY9uJcyS7Y3KyieOs6bEu0Tt4TkStHWoQkB0=;
 b=NclXSaTGAviBU0pHVKrj67m9CqPNvToTEMG3vs14Ggh1k4/D5J6b93wzaQpBbBkILmDMgcu+IpLl7xHNnYF0QRvBnALDOkycO3/StcB22ZQKlI+xKMZDX4dnSZD619w069KU2meT4CVzMQXHiVrOEBAlXIGlNKV31jQiKeulfG5eL5uivlnDPOeY6AbZjJvu22LucnP4tU8QdsHclGVUrAwBG34FzDCis1vwUhVYIylqZn3S56NY41lFseOYsx1b2tV9katHZRRhPP6W9wMuOg9qTV2a/eRTQoVpqKE3TEncN3QlSy0Keag8wEmhAQEb69Zkt/6kwb9IGsMWIBZhoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JYP90HtbY9uJcyS7Y3KyieOs6bEu0Tt4TkStHWoQkB0=;
 b=NbKHrSBisVAj+fOLM86S+hTErFMNrWvX6G8WxRp4gvKZgr84kgKWhgS6iob6sOgFFHpmOe4mPPZqAyiMh7Zcd+2PGuAOwbDvk6t6y81jcX/w6d0uwhMgBxckUDeMQJEWltpX77DMf63+RtZdLaPmfdsN6mUQu7VQniMTQ1Hwb+H7v2Y7g1wLiOfh+Jw4wLSVPcJ7LpUh9noAq6i8rXE9mliWL+iCVORiYJpJ8QARst+brsWho7r7Ir/fDia3IFul5KjN8Q6HP3w5YYlxDMc8GJFO6j4JRvz4XAaZMP0yLUw9DQoYzDF7xpQMRefIE0a29jnap/AFnw4uNT2P4jMHSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by PH8PR12MB6793.namprd12.prod.outlook.com (2603:10b6:510:1c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Tue, 26 Jul
 2022 01:29:30 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::eca6:a4a7:e2b2:27e7]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::eca6:a4a7:e2b2:27e7%5]) with mapi id 15.20.5458.024; Tue, 26 Jul 2022
 01:29:30 +0000
References: <20220725183615.4118795-1-rcampbell@nvidia.com>
 <20220725183615.4118795-2-rcampbell@nvidia.com>
User-agent: mu4e 1.6.9; emacs 27.1
From:   Alistair Popple <apopple@nvidia.com>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     linux-mm@kvack.org, Felix Kuehling <felix.kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/hmm: fault non-owner device private entries
Date:   Tue, 26 Jul 2022 11:26:40 +1000
In-reply-to: <20220725183615.4118795-2-rcampbell@nvidia.com>
Message-ID: <87mtcwacg7.fsf@nvdebian.thelocal>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0149.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::34) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71aa1df9-d90f-4925-fc9f-08da6ea64988
X-MS-TrafficTypeDiagnostic: PH8PR12MB6793:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mz+k9sGXcXj5EnspxCJrkXQDAqW684Mm360pG2fKu/4of/EjBPe1nkCLt+9XtLHs/KUFXfkKKHH5rQC7KXIkYFdL6paDTVruAAM5l6vHVcnIkr8/p+xk1toXG8c1ZG9iOn1QPJat7ceu6aVQbEyMA+CivdSNUAMW8eH2bgmp9uy4V3O7MhrWt718R6P3v4y75ynNycKjQKSeyzWZfLmrO5x+lh+o7djJol3WimDyaUR5J/MRiQ2J7E/yU7P0MzLCJJTdMJ+3cQ4LPlkyVhyBei320vFxeQj1osQC7QGf8aChGuHuXfmv9zzPna/RutxjWoybKKf/kk+NoiRk2fWOAfeplvQpiEBmjDQAL6n6ni/t9jXtc81SDqTicSi9Qme4gACXBvLtlP/VaCvpYTGQW6Bv9ci8REwbDR8O1jroXqRSnAGuYbPaV3SkPUlRzFhRHeJPakc37CI9eWkQ+Bretsv4OgcpUMU4k/poBaW/JSmGOz8sntPzQJo7SoGbLCvdndYFhMw7aRRSDOnaNe/xAHQj0OH8uKfND16PYrZYbXZEVAiPGzNZZTFXNF0lP+spDk8EcTNMSZisu/F9eUONHBPLK6f7nb5SSJtYvVwVR9Iogje9vwutiHz/P2CGDaS1ItgSQCF0OCA7IsQkftytFeRxKeUSDYuV/vBY6gWCEH0hrOsS+cChXxwAL47WqXLPWaAMLWmbIuef38FpKMD39MUkj8KCmRqvg0yxuG+N6HU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(86362001)(6486002)(186003)(478600001)(41300700001)(2906002)(8936002)(6862004)(5660300002)(6636002)(6506007)(26005)(6666004)(6512007)(316002)(54906003)(38100700002)(66946007)(66556008)(66476007)(8676002)(83380400001)(9686003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nsu7rf23cp0TRJ/FsfO4oWfOMHgvr8nz/ZyL7pIpdzlsOnGhUB4USdOjVQvF?=
 =?us-ascii?Q?SEiJL6h0pC5mWq1560Gv2R/Q/4rPMffIx741WOEGt8mXDX6CFhED4v8ISGtP?=
 =?us-ascii?Q?BEmcoWSOnK/a24+K/ij9d0TtAii9yqClkDhOTdIeQ/PV8RRsYOfYA133uBX7?=
 =?us-ascii?Q?wN2dlzFoY5UQ+Yq0s2v4aJvPMuAjruewr6xFNdFoQSTJAAVDT7Cl89irPgLt?=
 =?us-ascii?Q?xEGDFif0OU2NuehWNnUOS3Hw4+uHvUmmWNuekPdpJwP99iBUPA5E/4K18xA3?=
 =?us-ascii?Q?YmVjZ8lV2snPv47msf/r7TR1pMDSH5V/rBjZ6NcUTw0AuOoUezsDNDhpnhKV?=
 =?us-ascii?Q?UW+6mh2xBiVkeIJAH/4QItLxj5oymiK6Non/P/ablCW9386H+vKHZblrOsK/?=
 =?us-ascii?Q?WDLXivtOoI0bTD5GYyksJ8QSYE/R9EV5x3hlpj6eUekx9u5eKcrOgC3ey7Nl?=
 =?us-ascii?Q?n0jQEIjIf6mxYMIA957OgrgZ9Gc6BGeuI0mOGX17G3BnLC3nDxOHidK6d1dP?=
 =?us-ascii?Q?efBX+TtdfqTyoGtoFQGFOxNQBL2JCp6NMV0HRyDMV61W9+BZEIBskQDlMQ2d?=
 =?us-ascii?Q?2jtJbEE9pOa25jppqJta2YF9jMUfkcsn7OT51j+thi/HyTtMZsp5ttYX4iQ3?=
 =?us-ascii?Q?IYuqZG4PM3SBV17EIFuUbX3vdmwMm5zXgYqf0xJlQ44ciDh9ZPhyLZc+cv6g?=
 =?us-ascii?Q?WN38g2mBN1HNt5c0Y1+HIAyrU8VQq9/KWXwC8M3q+CO45iBt3kOPDCB5U0QG?=
 =?us-ascii?Q?UQ4n2NirZOJ0RsxJ8WweuZxcgbD/Wgtplt1BlT9uF/yAS9ZQopaBwC4Hm02P?=
 =?us-ascii?Q?XvtnosMthNxoN5fbYOcx7w1+PAFeQF5yzKr6TKP456AqAUAO/8DSfPwHslzc?=
 =?us-ascii?Q?7QiFrYRw1EqOS129qCN23fRs55bItmBt+SUt1x1GKDb2cDOGnnSwNRIAxceT?=
 =?us-ascii?Q?+LEpB910EdnAEu6xXJWxBlNW8e7Ie6MOwbux9ZwPY/bVJsDUuvvl4nMZn6MK?=
 =?us-ascii?Q?ER/FG3odfMQRjy2l+LYOTFLCwIhBpoKvJ5XvfsPQmjSClP6iAmw0hMV2ZCf5?=
 =?us-ascii?Q?8vPbCSA3Ynw8Vz0LfAnXpp2Dn3Il4owYX2ahv8qsJv1u/iC9TPbmGMUvLNda?=
 =?us-ascii?Q?u+9l1UkFwRWxtXFZOFY/9/xnZTKgfISmO679uq5+Xroz6PA89NILoHZFuhct?=
 =?us-ascii?Q?GES0HzUqDP1x8lCrT8TjcJZV0QiYRy/ECrS0S7c1az4M7YqGRDJtbAi7obpp?=
 =?us-ascii?Q?Ol0qM241OrxipVOYDh2Ui+zJNBaThPKqdwSed/m7lWLhl74zo5nCUS497Fcl?=
 =?us-ascii?Q?3YvVUAxPnQLVbbCFONmg9LH2yV3rLZb9um57k2S9uya8lciFt0j1SbwWc+0E?=
 =?us-ascii?Q?ziCCO89gwAY4glP3AnkNxo9eOOBpUzf0Vg/gaFu1bN0ctT5ah/tixmVEybTi?=
 =?us-ascii?Q?xoGPjYQM/4UMEE7fJ9bmMMHoOrlXDuCxjC7URWQ5guHOW2lYaN9JjA0EwY1G?=
 =?us-ascii?Q?aMtNMb0EbjoWb/b2d/5r1Qaj7k5zDecycL2w21KZ2YPUXqqoyvbEN4sSiXD1?=
 =?us-ascii?Q?qseLhFFj+SdOUQCGLam9u6hCssTwxFcb2beCcVsB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71aa1df9-d90f-4925-fc9f-08da6ea64988
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 01:29:30.6968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N1R6VNvuTfyRjeFjfPHyiN8Upjtea0T29E/VBZCZ7cCu6RRaoOKRBBN7A5mkegSjdMqfAxDXzf6U7r9L26NN2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6793
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Thanks Ralph, please add:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

However I think the fixes tag is wrong, see below.

Ralph Campbell <rcampbell@nvidia.com> writes:

> If hmm_range_fault() is called with the HMM_PFN_REQ_FAULT flag and a
> device private PTE is found, the hmm_range::dev_private_owner page is
> used to determine if the device private page should not be faulted in.
> However, if the device private page is not owned by the caller,
> hmm_range_fault() returns an error instead of calling migrate_to_ram()
> to fault in the page.
>
> Cc: stable@vger.kernel.org
> Fixes: 76612d6ce4cc ("mm/hmm: reorganize how !pte_present is handled in hmm_vma_handle_pte()")

This should be 08ddddda667b ("mm/hmm: check the device private page owner in hmm_range_fault()")

> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> Reported-by: Felix Kuehling <felix.kuehling@amd.com>
> ---
>  mm/hmm.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
>
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 3fd3242c5e50..f2aa63b94d9b 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -212,14 +212,6 @@ int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
>  		unsigned long end, unsigned long hmm_pfns[], pmd_t pmd);
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>
> -static inline bool hmm_is_device_private_entry(struct hmm_range *range,
> -		swp_entry_t entry)
> -{
> -	return is_device_private_entry(entry) &&
> -		pfn_swap_entry_to_page(entry)->pgmap->owner ==
> -		range->dev_private_owner;
> -}
> -
>  static inline unsigned long pte_to_hmm_pfn_flags(struct hmm_range *range,
>  						 pte_t pte)
>  {
> @@ -252,10 +244,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>  		swp_entry_t entry = pte_to_swp_entry(pte);
>
>  		/*
> -		 * Never fault in device private pages, but just report
> -		 * the PFN even if not present.
> +		 * Don't fault in device private pages owned by the caller,
> +		 * just report the PFN.
>  		 */
> -		if (hmm_is_device_private_entry(range, entry)) {
> +		if (is_device_private_entry(entry) &&
> +		    pfn_swap_entry_to_page(entry)->pgmap->owner ==
> +		    range->dev_private_owner) {
>  			cpu_flags = HMM_PFN_VALID;
>  			if (is_writable_device_private_entry(entry))
>  				cpu_flags |= HMM_PFN_WRITE;
> @@ -273,6 +267,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>  		if (!non_swap_entry(entry))
>  			goto fault;
>
> +		if (is_device_private_entry(entry))
> +			goto fault;
> +
>  		if (is_device_exclusive_entry(entry))
>  			goto fault;

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B7D6CCFA7
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 03:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjC2BxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 21:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjC2BxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 21:53:11 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2083.outbound.protection.outlook.com [40.107.102.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8621F1FDA
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 18:53:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbrNktRSwXeXBgaUOzwLrn18hLRy0DJYytrNWCXue+kONjQImnqeelEfPCiB/zzoVOLKYS+6y4uj0zcdcgvl+QjRMM7V8U/sfaqWqeWbkPG27vDZl02SstJB4ikWrAi79NTNeUKDS9p8SFlMv7fv14Z4XVjmOcpPtFlgo7ZT+trWVGeLDFbWwLXLz4nMbFmQHOVHfoOCrYzgyG5CnCLXFg4AVf5jc3IBYPTgmCbAKGbeH0D81HCT3HnCysaM448t+cAT49JxQIkmhO1W1dADMAuKqJ//nrnSxTyRuG+5U6mcSQMbtUBmFgY9VgGx4T6zMpzeGqurhLov1hX7c5jt9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eDnSEFtjE6NjLwMRRJhq8iTi6900xBXsMtTIiKjG7ck=;
 b=ZOzOYe0C2t2uZjdb9XGc/nosRrmvXCSUWpPoBYBkhxYMHAxu54eeXSiqtVHU5jqIEvZtH2K/1rRNJ1X6AExn7sLmI1aYBSzPg59W1hxdEM22QOOkPR/1/cdD6Ilckz6QcJ5UpZ1DibnLi7/m4MEfXD30eR5Cr+3OqXDJmGNwEmvK3Op/h6eEsTfTtNagoLlKRowix7FAkPX2/k6kGk+cWooZjmIkYtNJ/r9+S2aVPHUi0n06i1NKeIknSJPTcJtU6RT9e49cfM3MyKIzVZHYKU2f0ViDUEtFe7X+NJrbEaavm8IcPqBdw9IN/x/Gi+7wkcR1R/NiAi86t9Q2KMlhFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDnSEFtjE6NjLwMRRJhq8iTi6900xBXsMtTIiKjG7ck=;
 b=TPZeuHGybmB+qarGq3IIF2izm0pN9LwfeZg/L/Dk9aLiyDT1PUmRZw3K4FAxrLbb6A/RZT/x39bnyHVbyHmpFaQNPlhcL5qdZ/CuPWyxhx2dtioP8DFQV2BcJ+wTkHyr3jyvweRmn2KhKxTAUTieWSUmOc4tTx1zqJZ82Ov3nIUHBu1E97RJxhB8ma3ey+3oHZbqOTA744nfUZTcG1fIh8aoEJvpOZm/R6521myrZFfx9khKsyEC/tdhEPrIzUppaNDVtuAALPIXF68Y26YzOkC2k08ldeCAM///usB2p8wlZsPL0xMnqsI8mWFkr9TAkYv6ULrsP7XH8j6CDO2Fvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by SA1PR12MB8985.namprd12.prod.outlook.com (2603:10b6:806:377::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 01:52:57 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::84b1:7c9:e9f0:bab5]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::84b1:7c9:e9f0:bab5%7]) with mapi id 15.20.6222.035; Wed, 29 Mar 2023
 01:52:57 +0000
References: <20230328021434.292971-1-apopple@nvidia.com>
 <538f85fc-3cc7-de5c-131e-ba776d5f35b5@nvidia.com>
 <20230328125558.90cf40060e238b24add51d23@linux-foundation.org>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     John Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org,
        Ralph Campbell <rcampbell@nvidia.com>,
        nouveau@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: Take a page reference when removing device
 exclusive entries
Date:   Wed, 29 Mar 2023 12:45:44 +1100
In-reply-to: <20230328125558.90cf40060e238b24add51d23@linux-foundation.org>
Message-ID: <87lejgtjbh.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SYBPR01CA0040.ausprd01.prod.outlook.com
 (2603:10c6:10:4::28) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|SA1PR12MB8985:EE_
X-MS-Office365-Filtering-Correlation-Id: ce38889c-4249-4cc9-ebc3-08db2ff85164
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nApN2sRF9h0fBT14D6r5PFZfi2VWd+eWtyvQPRYMwnLf3hwb0rncJrFwsMRrpwVcn2GqQxvNV2fowBZWUHf761R/L46QpWSphHy4sgE0pCGF+yD4smxWmqvsWqwGBtm4u+yZ1zTKatoAHWNAgrvwepqb2cspB95z82nzwfgC6TV3dW1wyJ+HbszoX05liI0sONW1LT7j8deJqpXcMK6WJs2maA9gN17aYc2/5yvoGfpl8zfq+gHNss2+ASDbJhlj7ML4baLEsGQ6LDqrj7aZAo9MCVo8U9ziuu/DpERoYjqFjZfbXLYjOY3SKERYdSKPIXsGNFpxgSnTzZV78cvhMrgWXYmT0viZlD523WpOp1CUABYyhQgezkCDqfSUCHR7HF1Q3UZtSiGJyq2r5dYYiZLRo8JxeZ4TO8guc3Nk3g+s5oFURUlg+fQreaMIi0utcYZvWifzEWugNOT2pDP/0rJq3dlZQJ0J7N5UXWbhE6NxOHTWEhVhQDwfKw6/PeWoEG2vFgFJfvspS56nPcKcGWgH2/6rAmkLGnqHGAj8VbGF7Lo76QneodXlSHYbj+Jn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(451199021)(2906002)(83380400001)(8936002)(26005)(5660300002)(54906003)(6506007)(6486002)(6666004)(36756003)(316002)(6512007)(478600001)(66476007)(2616005)(186003)(66946007)(38100700002)(66556008)(8676002)(4326008)(6916009)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t6bQE/WTNnomIkUcI6HM601pWRtYGIBraohs11a4s/3769PBLHsyXO0WFfa/?=
 =?us-ascii?Q?I352Zy3FPuYmMZCQnYS8PHkHl8q5hKdoxbwuw5a256Y86rNami2c/fQxR7w4?=
 =?us-ascii?Q?gi1K96xeJLoMlm3dYYqtI9RYhb46eb3Up8azEvIGwl+8ikb6N4zuGQvE8qa2?=
 =?us-ascii?Q?Bnp5M7N5f3rVfJRH8Dq2pqrWhmmr72jZzS49mBCfkvFR1rHZrPwWa8Y3cZ2L?=
 =?us-ascii?Q?C3/7nLOmpTeMlRIZw5t6lE19eNOUl/TuVOmMzSv8xUxkAfHrsnPll4wrO6zU?=
 =?us-ascii?Q?J64vJ1FU0auxE/3CarZQhzn+RldoS5zB+snD64v4NlMg3/zKwUiGUkqCqYlk?=
 =?us-ascii?Q?OFR63b+K3i8zEQKgSb8HivKo8ZZSVGMHcbxI/ZkMgjcfBy0XfafiH8hnSG8I?=
 =?us-ascii?Q?wc8ptdIFxnLDZCCtcwArUrgqREwovG3dVqz32B4dLuvpsehNKJxISoF36VGU?=
 =?us-ascii?Q?JeGtCJ04EEsCuZh6+iXyNgB1JkAFVK5EdQkmUHud4t0uT8uX/9J582o+T9re?=
 =?us-ascii?Q?Jsp43heGKZZvk77oelwxrV5LG5hDvqKM4kpDjeLgK2UkoWqzT6M3ljdmfogx?=
 =?us-ascii?Q?Oa6QaCE+O6+524p9bnk1biUoNJgF07zBmpxqQmbTyQki/JelAtwik9YY1sE3?=
 =?us-ascii?Q?3yQjywSLSUXJt50OFeJgWDTyMoktzXiiHcNk/kykhwMEauQsD+omYooXy2Jd?=
 =?us-ascii?Q?NDIrIQ9yEi87EZzhUNqHrmvMbnyh8NbSpOxHeCnburSnXfmbdbG9HKOC66gG?=
 =?us-ascii?Q?PBtwLlsKmqTYqA6xfo1ZwbZttV/hQvmcUukOWw/R4aPR3PkLs3Lb1zeBxtLY?=
 =?us-ascii?Q?bFuUDV8DpzUQKZBu2/1FKIeDvQd+gqhuB9azj4jqJRpuo93RQsD/X/E93NXT?=
 =?us-ascii?Q?d1yx0uQb+QkM5hov2fjMNR3w1VHXnfrw2yc7viAp4JhvUism3+Aa8CifzJYp?=
 =?us-ascii?Q?Eogx9BJmBA5A+LDJApcO60wP7aoVdquqAxMy66/fB9iGtW3ulNJbxJ5luoW1?=
 =?us-ascii?Q?7+2+n4GHfV7ypU/ySn5Sm2RV28zrqBDMZVEFvDSV3gYrXmD2JXgUD+HEYflt?=
 =?us-ascii?Q?IdS8LjS9Q3PtDZeeaV76WiuILOXeoJKGJQMBe0YG5ncAd9bEW00idEocuHFu?=
 =?us-ascii?Q?qq3M0JDEdp24vqlLeAAFq7RW7BiX/7x+bD2BH/20f7WS+itsfoUQ44wEv2Hq?=
 =?us-ascii?Q?gkpriuMwL4gWb0a/pfut5Gacc6GKUKNGrthGXVLVghjJxsFiRG5biIbdClyK?=
 =?us-ascii?Q?Ch2OoPzbalehFd3jecg5LXmIcA0n4iZKAZrGuMKRBn/Iw5aXi3pzwg9cAKaE?=
 =?us-ascii?Q?me3xQ0FCycZnz/2p2gKV7fzovuSBWkjLwbCRdRYqiFLnk/lNEG9Q+O0r96Ts?=
 =?us-ascii?Q?5ITzjbR6KaSWlOb18bFFIL8g/hWJKwyzS+ic65yIHZHuo3yGlY35gX3Anc/T?=
 =?us-ascii?Q?VQ7MJWWRtVzHHCXqQPz0G9w/GbGYXUIshbqzo+DEobvPBlK0s/301YvstgP/?=
 =?us-ascii?Q?7pndSaQRemfCPPig4HktfJrufRFO6/0U9RxjCf6fHyvnX7uIbq59WfGfXDmk?=
 =?us-ascii?Q?xItvh6mCbZjUHs7lVBTuooNRiE0cCtylQmQZ4w77?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce38889c-4249-4cc9-ebc3-08db2ff85164
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 01:52:56.8753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7MKaEf/mYr6KFH+0APQOO4H5j648H3uCBYSbAd8vyJ0btqb8jGsDwtCs2u2YxAjYP/V5R9LQSekJ4cVlWA9LfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8985
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


John Hubbard <jhubbard@nvidia.com> writes:

>> warnings such as PAGE_FLAGS_CHECK_AT_FREE due to the page being locked
>> when the refcount drops to zero. Note that during removal of the
>> device exclusive entry the PTE is currently re-checked under the PTL
>> so no futher bad page accesses occur once it is locked.
>
> Maybe change that last sentence to something like this:
>
> "Fix this by taking a page reference before starting to remove a device
> exclusive pte. This is done safely in a lock-free way by first getting a
> reference via get_page_unless_zero(), and then re-checking after
> acquiring the PTL, that the page is the correct one."
>
> ?
>
> ...well, maybe that's not all that much help. But it does at least
> provide the traditional description of what the patch *does*, at
> the end of the commit description. But please treat this as just
> an optional suggestion.

My wording was probably a little awkward. The intent was to point out
the existing code subsequent to taking the page lock was already
correct/safe. I figured the patch itself does a pretty good of
describing the actual fix so am inclined to leave it.

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 27 Mar 2023 23:25:49 -0700 John Hubbard <jhubbard@nvidia.com> wrote:
>
>> On the patch process, I see that this applies to linux-stable's 6.1.y
>> branch. I'd suggest two things:
>> 
>> 1) Normally, what I've seen done is to post against either the current
>> top of tree linux.git, or else against one of the mm-stable branches.
>> And then after it's accepted, create a version for -stable. 
>
> Yup.  I had to jiggle the patch a bit because
> mmu_notifier_range_init_owner()'s arguments have changed.  Once this
> hits mainline, the -stable maintainers will probably ask for a version
> which suits the relevant kernel version(s).

Thanks Andrew. That's my bad, I was developing on top of v6.1 and
neglected to rebase. Happy to provide versions for -stable as required.

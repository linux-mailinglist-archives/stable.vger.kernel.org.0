Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8C4580442
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 21:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiGYTHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 15:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiGYTHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 15:07:33 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2057.outbound.protection.outlook.com [40.107.100.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5483120A4
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 12:07:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OI26R3Ep3S8QCQms/1dPnzEdNvXkZv5WC737sBzPo72l/zVK72YG/Ecyy1+AoZWUMYq3wWAaM8xVeqUDuVcqBFzLKr6eXYzvHrMaxYlNnJd8KEvFc9PfnLl85FSC2Z6aqYH87bl2maHwxumWSzz2m0rjmX/qE+f2ryrMWlQzvgCpNPbYeXoTKtlTChi2f5m7eZZv8aFPoH5JplZqXWadbxrnoo8Xskvlx5FQvA8vh5LzDM8bSRGqqP491s702RaDsX0CLk52B7sRY4otPWRQentu2notcDgg5mIVHdk11g/F7xgwQBQYuOrCdGKyNBdbFG0MKU+Sm3IiGDu9m/wgbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9BnvwMS793Cd+t+PVyP3c8sX66K4CQnivve8kGOc8s=;
 b=VdODZ6lsR32O6Z6DZJ63r3KIwh2LeOmfxFCnp90p414I5LQEYMUZ+KyaKoht0L03LXkQlPAxzkKhNdH5CXgfHB3aD0wcvzx0nS652TFUaG4gJdrq6jFFWmtrK2jfvHeHr5feOBNu84ALl0J3Htg6+z1O2cXs/ThP+RMIEda+t1aChGC/p/nZ6AgjcdEY3sQei9ZdaGBsKhrQsqtjQizr4py4v5CZRoYGg3yGw8LQ9IdX50lqHMHzex1vP1YIR2SKx0uGtmUoy6gAzSnU/cF81F/wvQbPIS0Y8aJkIz2mPn+G4SBuVaW/ZGTKta0deBnoM8PuXFMc20pFdc1xtfpmXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9BnvwMS793Cd+t+PVyP3c8sX66K4CQnivve8kGOc8s=;
 b=OQR3ycspDnlFCAV+dE5ghbT5dK1JGarspAtkT0Kc+ibmKmeNqKMbY8do3IQseB0DfH65HNq+SkdStTjF2qRZn+VtomL7DMpk47VX6qf3IOiSoW0+x5bSyhWwWE+hwJ4NoPtCAVZh9yFI4EqbeOLFYxyd6nikn+j0lB8YHz32u04vyMWbjC8MNcp/qb2QvtL08Ly8hNS5IrQRwuxlfneY/2wDfN7j1Rd4xHRATSOJ29AGXi8Tba1/ZdqcPHiY4F8lGrBLBYPCJ/ADuXYlPXGwDOSVgfqZui7ewRG7onICnlgvpu7orHNJqG9DP2z0eo/TS3hj0JM/TPWo/ysYqgYvPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB6150.namprd12.prod.outlook.com (2603:10b6:208:3c6::11)
 by CY4PR12MB1925.namprd12.prod.outlook.com (2603:10b6:903:120::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Mon, 25 Jul
 2022 19:07:30 +0000
Received: from MN0PR12MB6150.namprd12.prod.outlook.com
 ([fe80::30b4:54b4:c046:2e14]) by MN0PR12MB6150.namprd12.prod.outlook.com
 ([fe80::30b4:54b4:c046:2e14%3]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 19:07:30 +0000
Message-ID: <e20f27ab-fb31-4301-0683-3ce51818b6b6@nvidia.com>
Date:   Mon, 25 Jul 2022 12:07:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] mm/hmm: fault non-owner device private entries
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, Felix Kuehling <felix.kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Alistair Popple <apopple@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, stable@vger.kernel.org
References: <20220722225632.4101276-1-rcampbell@nvidia.com>
 <20220725114953.7e53ca4b296e0e753ca7bfda@linux-foundation.org>
From:   Ralph Campbell <rcampbell@nvidia.com>
In-Reply-To: <20220725114953.7e53ca4b296e0e753ca7bfda@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0022.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::35) To MN0PR12MB6150.namprd12.prod.outlook.com
 (2603:10b6:208:3c6::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20aaf763-d7c4-48f7-1fa7-08da6e70ec3a
X-MS-TrafficTypeDiagnostic: CY4PR12MB1925:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XsnWNxn1//eeKXAfKwUQbeg4yaOiSlNv2f3Qn8pKIPsiR6VP9rJ2XkB5fekzYtJ6KLLquOeEqnRrzMLhTKte3LakgsYpUItBzlwTK0weAghH0pE2nTxLS8PJZBynYwPdBSY823SPjlxTGfJEnJCPRUviaa26y6kAkHCb8m+joN36ti4OI4qpley0pbOJdAllY5/vQiTYMui9mYJkz/cqlkpm9rPfuMrbJ6xXlk5VQTt193iheWNnDM+7RcrTupi/lmF9faDifcL3Hrn2NWDFW4drbCjPKMG6xw14pfuA0TVR35MRdF/TTuM6e/W71Z7jxyDd7T5m6aWHSiDBbW6Kv7RyMjuMIb/4LGIMCl/aLGvkqxDSrjMHwXkncSftJkHFAdihfTsYZgv/WenXOKIEog768it1sKpM2bP2qIZvaZ4e21UbKwMBPcK8fC+Xe8pFvQctHZvExvCUbwFp97pY6AqzVB0yTViJ/8HNhimzI2OTKDXiye6zmuR0zUKCOwxk5lWIVYFjKksRbgSKc3SJD2wX9316jdGl7RauSFrCdphbO4yqcfHb+XnTPE5tENLL72hP2hFzIxyJjwGzqkBfKwJY2ZFcvJ+6xAE11tgg0l1khMyvVX5UJ4FhVmEamSa53q6ByMfK8pKUXeDl4o1/rKoJ0mbRB8iXtqGbPuQ4SPkLmNGwbbbqwpXNsi+TpL2uul9/axOBzwGM7c1Hf6SdzHwAezCeb6MhEyPCuQPpsFyW3iGpnCJscRaNgWBmXJpGYn2j15HC2lmffxR9/UkodbHMzNJ9sL8VEcCCffsZzC44bcVhcVFtw3UV91TgnI2D7l8epAGGDssmuHpizyAALA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(36756003)(31686004)(38100700002)(31696002)(186003)(86362001)(6512007)(2616005)(478600001)(53546011)(6506007)(6666004)(2906002)(41300700001)(54906003)(6916009)(316002)(5660300002)(8936002)(66946007)(8676002)(66476007)(66556008)(6486002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVNYdTBkKzBlMUV3dWJmZDFieVlud3hUY2FxK1ZZV1VzWm1JSWhqZk1vWitZ?=
 =?utf-8?B?UHBzcGt4OXRJOVYxMDF3c09jSGRETUZ2MWMrTHlUWVBEemV0Ump5c2Y5NkhC?=
 =?utf-8?B?RWpUWDZrYUx1aGpnQ2VGYzRuWHd2cktSMm0wRE1UZzJVOE1hU0RobjVRb3cr?=
 =?utf-8?B?anoyT1pySGNoMmgxcG5adWpjY0h2cjhZNVVlNzg0amRCUW45RHhvYjdpVmtq?=
 =?utf-8?B?RzByTjk5RENwVDJZSGJuVytLbUF3VjgyOC9DSnJMaCsxcXpHVk1YY29FWnhZ?=
 =?utf-8?B?eW1oV3docDJ5QXFVVjAzbm5vTzdSRUVvamlFN3BUQTRnUVdGK29lMlUvTndC?=
 =?utf-8?B?bHlnaFczalZPS25QSzFaREFCVHBZTjBhTjBycEJiZ3BIbmx2QklpVEkvMjd4?=
 =?utf-8?B?eHVWSUtibnhVZHVpaUp5cUUwMHBNRVJHR2R1SjFzMHRDeEdTVmxRZU9vTmJk?=
 =?utf-8?B?SWtGM0ZKSTRHdVN4bGYydTlKSmh6TFJMT3hrdlhzaHBpKzlZeUYxTFVjUE9I?=
 =?utf-8?B?N3FwaE84WFN2cnBlQk9pdHlLS0FpVWg4czRiVDJha0FLV2xnMFBLMEd5SkdS?=
 =?utf-8?B?SjZWRVNxdjkzTGc2SXBLZmwxZFBsT0wraG9EaXBiMDR2NXdwSklpMVBHMTlk?=
 =?utf-8?B?Rlh1VFVIamdJUU8vVnoxczgvVzhZeFJOaE05aDVURXkxc0NGaVFDWUh5TGph?=
 =?utf-8?B?TGVaU0Nibmh3T3hnKzZiWEhJblQ4ay80VE9xbi9yM3lrNFN6dDdzNzhzTDFy?=
 =?utf-8?B?dUJnTjdEVmdnNzN1NTlhZUVIUExucFR1NTI1dzA1ZHVDWGJ2MnRSSk55Y1E0?=
 =?utf-8?B?ZENPaFRrYTcwNyt2VTlSMnFBTmhnV2RqNDIyS251emt1eERNSkk3RzRUaXlB?=
 =?utf-8?B?ZEtJZlRBbHgySENtSVpSWDZMMkt6a0pTZ28zV3M0dzF2V2R3ZkVsUC9SV3dz?=
 =?utf-8?B?bitkd0lFUGFPNnBYRklwYUJLeFZNZ29sM095WTd3V3lkNHg1TTJBOHdhMCtp?=
 =?utf-8?B?cjV2UGpycVVYY0RyL3EvclNxdEtNQnlLV0lETThUbkhQWjNqVlZKMzQ1T0JQ?=
 =?utf-8?B?bi81OTZHdDNrQjkwVFVKclBWbFliK2Y3b3c4Wm8xQ0g1eS9IMjBTV1dqdHFE?=
 =?utf-8?B?aU1ldjN1YzZ5WS9WQ2JhMmJxclhyM2hnZUFzNkdPOGJIbDd4YUlvUU92Tlhl?=
 =?utf-8?B?QS9nTWdwZ05kZHRBdUg2YXEzVmpRaDZPbE91YlhqajZieDFtUm8yODREbEl5?=
 =?utf-8?B?WVZRUCtTck5tQk5NMlJvdU56dERvSkh5VTB5WDM2OGUwNXlDZjhHVHZFcytZ?=
 =?utf-8?B?b0dNSW9oV2tnUjZ3Y2dqMGR3ZHRZdjAveVpmZEJDZWFoWkZrNDlvUVpCR0Zs?=
 =?utf-8?B?NWlqMEswNnArWjBIUjVWd05rS0tvM1RVTGlJSjBuQzBoQ1UrZlVQeTEyblNH?=
 =?utf-8?B?dmttUUpZeDhtRjNFaERIZkRDb01hSHpMMjNadWhIazZ2UjlSeDB3RTlEWEM1?=
 =?utf-8?B?Y0o2djRaU1FBSkNLS0NycU1yQjV6YUJMOU9ZNVRkVW5mcGtWVC9FNHNyQ2lR?=
 =?utf-8?B?ZDNvdmpuTXpaOFpXU1N4Qzl5eWZZQnBSV3RiY3RkdTA0R1J6dGYvNHM5TTVt?=
 =?utf-8?B?Y25yWjRRTXdmL2gxY1VnRWZZMHFJY1dyajFHVEJab0J1aXFNR1BobThhTFVZ?=
 =?utf-8?B?aDEwL2NMQ2tCc3IrU0NyM21Gakp2NU5LVXRUZXVnZ2tOd0h2R0IwVlpCWmds?=
 =?utf-8?B?YVlDbi9HdlhsSDB0TWFvV2ZaVktSZlh0eUhiRlpjVjZQUVoxR1hLMFM4MHhT?=
 =?utf-8?B?dnd0RHBmWEdHQTdyWVlnN0xlWSsvdGlOVkdxMUwycFUydlFiWHpiUyt5bVFR?=
 =?utf-8?B?NkYxQTRJTkdRTk9aSG5vUjBoalMrU0pvNUFYODhlY21MUTl2aUprdDVnMVRw?=
 =?utf-8?B?UHh4bHE3OGJFTm51akFBNjRQZkNRUWNzMXhXVThtekhxNmdsbXhtRzd5cWhY?=
 =?utf-8?B?L3N0QWRvaDNueTJybjVLd0ZlNU9HTXMxK0wraVdLQmxVN0FPNm5XcGpuVVlm?=
 =?utf-8?B?N2VtYzMyMFFaV0NIOVFJUWhsOFVYQTBvbmJDcGgzWm9XSkhDYVJZMlc1TEVw?=
 =?utf-8?B?RDljZGlOak5jTHNPUFRERjNvWXJpeXlOOVRWOU5KSXJDV3M3RmpZcjREZC82?=
 =?utf-8?Q?gKDmQR+g7WVKbeFQ4KueSO4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20aaf763-d7c4-48f7-1fa7-08da6e70ec3a
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 19:07:30.7314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lIWf8muCPidqJM6fsktb/uo16uEYUVUIYpawzgSPIktf2C5Bf1aOpxTBky3Qn1ZeuvHF0L/mKbEbw7R1u257gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1925
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 7/25/22 11:49, Andrew Morton wrote:
> On Fri, 22 Jul 2022 15:56:32 -0700 Ralph Campbell <rcampbell@nvidia.com> wrote:
>
>> If hmm_range_fault() is called with the HMM_PFN_REQ_FAULT flag and a
>> device private PTE is found, the hmm_range::dev_private_owner page is
>> used to determine if the device private page should not be faulted in.
>> However, if the device private page is not owned by the caller,
>> hmm_range_fault() returns an error instead of calling migrate_to_ram()
>> to fault in the page.
> Could we please include here a description of the end-user visible
> effects of the bug?
>
>> Cc: stable@vger.kernel.org
> Especially when proposing a -stable backport.

If I add the following, would that be sufficient?
Should I post a v3?

For example, if a page is migrated to GPU private
memory and a RDMA fault capable NIC tries to read the migrated page,
without this patch it will get an error. With this patch, the page will
be migrated back to system memory and the NIC will be able to read the
data.


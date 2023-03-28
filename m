Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7EF6CCB20
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 22:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjC1UAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 16:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjC1T7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 15:59:55 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20615.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::615])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD8840F2
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 12:59:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwWRwSp7gHdakU+tmQU6a53EZfW+VoRjWsb7ApjYUQO9+oA80tUgmiL34dqWJ7P94HYB1sXVl6+vrAHVD9DkzQljAskZjOKxekwiFzrvsVYwup0Sc2NpQvLpzP8PPiG8WLdO7aF1n/sFhtT7DIWtG27MCac33Y17d2J/do0K/hxnxW8UQA64Na42bj+nOFSJ0eD8TnKmpeNMUaT1kzINdIcUzfh1dUmkJMg/PkY/GR1ADz53gOFY/rNcp/E6Go4AVEccpJXN/7v0csJBK+Jox8Ju3vksRC5nlVqsusvHDgsTCiLLcFnuAdH+eVgVY1rtdKdh62WbQkDTWiTu652tQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6Ks7rCuYsinKzfO7bmDyxUWVJIbKZZ/2Z/GxoDdFEo=;
 b=ShO+VjnkUxRF1Sg4cMkMd4Y+ZHXHkTEApYrn7bxGomEBZm6huEq25yo6UzxF9bkudzMc9/WDjG+36xFFAH7tnQvulA0A/HRSwtQEkmaujBiUb3ALonVFi9+NjwzvgZaC1kpEkdoGzv2BdAp9jOHjBCcwKz7C3Pv6jT+OoGaD5FIDVRtS3Ks8DIf1S68nr4bKpGTn0NLR1zAaWmII+lLxHa4BoptDkz99VPps/luEwodvkXYpZG3dgGL6NdSlZng/BTX3JA8c1cln1nFETAYMfFgSWFtz16FkxnnIPXrwZmuPr+5dduluPjJM3E2DhFN3jdjzXJABNImTw3TPLHKOCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6Ks7rCuYsinKzfO7bmDyxUWVJIbKZZ/2Z/GxoDdFEo=;
 b=Ajk+n0UF1Z+al1c6HA3mHSBlzDI+bVwK3EREwjRprzliBLpsDxG1aRDuUcgw/WfyYOAoZ7oiqCBmVi8IoZJc1QnE4jTwU8UOVaiE4d45pLe3HNxoKQGxj9HrYloeQ0LyzaourqQ2aGJkXXWOS/FtWcaVtYnPUpjUwJla2vQQYUolqWHWWT+hCP9ngrMTmvG7o/qbyOWwJ0g1mrJayXut3i2WzHSl4aLnaptUQsEz4pea81yxGTovoR/HUsSwLp+E/N6ewZXm+pDGwk0p9sHJ4nAr9R77uIvT9pgpjOtSPm7/VjVLa9ESPBHh8HSxtXFlL13jwIbNv+JTufjrzEDuyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB6150.namprd12.prod.outlook.com (2603:10b6:208:3c6::11)
 by PH8PR12MB6722.namprd12.prod.outlook.com (2603:10b6:510:1cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Tue, 28 Mar
 2023 19:59:04 +0000
Received: from MN0PR12MB6150.namprd12.prod.outlook.com
 ([fe80::31ee:4f83:d8da:3c53]) by MN0PR12MB6150.namprd12.prod.outlook.com
 ([fe80::31ee:4f83:d8da:3c53%7]) with mapi id 15.20.6178.041; Tue, 28 Mar 2023
 19:59:04 +0000
Message-ID: <c6439ee8-6f93-f75a-2ec5-9387f2355b52@nvidia.com>
Date:   Tue, 28 Mar 2023 12:59:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] mm: Take a page reference when removing device exclusive
 entries
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     John Hubbard <jhubbard@nvidia.com>, nouveau@lists.freedesktop.org,
        stable@vger.kernel.org
References: <20230328021434.292971-1-apopple@nvidia.com>
From:   Ralph Campbell <rcampbell@nvidia.com>
In-Reply-To: <20230328021434.292971-1-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::8) To MN0PR12MB6150.namprd12.prod.outlook.com
 (2603:10b6:208:3c6::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6150:EE_|PH8PR12MB6722:EE_
X-MS-Office365-Filtering-Correlation-Id: ab147eb8-0d3a-46e8-e908-08db2fc6e1d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q5kh+u0wB9oNVCFn16A5UFXRoPCxJyapOJDLwuYUWBtGtZXnz/+hsF/DezM7ORpP3W9dQG6BdCcIh0g7mTmONHTCpvMQAtoAFeBUgUGT/o5MyALc2WKQu9AA4nCYfFCZe1APSVf8xrcYG/vsOROE4PZCmuPaUIYRShLtdK4Vk5r77Yl4GJtE4jbZcDFwBQ0dVMWsfNj/CDE48U3WXXhgVeN4BNcCytsc4fijJ/7Sg7agBvuSn29o5L6zO0j+Zo7/QSh8964+Pa+2HMBWvAhvJ5XISTHosBE775JM2komx8fsM/kSuNr54S/EMqEQzA+H/H3nUSU2HrTX9ens46gCvbRclBPDReLduln55JPjbZeQZxjUuu32md4MamqQdJUBpm9jNiZCIi6eBgmw/tR7U3cVkLtNxP8Tqnf94x68K/GdNcsniJAy6lz23/1yL6pnj7PjyUdruwMeuRQFG0vbA2dzMA0fUiV3WJ3+RtjCNezEE4PpaCUcN9JuIqqd4yI35mvkp6aPF/IqAuDpYA5LwoPFLiiwK/rVTJ/IVIoxpDo4Z8TAUxQ+FblSPSVTGzP9u3sce7ML7krvEAffaRlrfbJJ8V2gWQ9T28QZVSQJAHTmwd2pSejkrOkg0Zs6yyLSb4A1TgkWncKuDqvXY8ZUiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199021)(86362001)(36756003)(31696002)(38100700002)(2906002)(31686004)(478600001)(6666004)(83380400001)(6486002)(26005)(2616005)(4326008)(6506007)(110136005)(6512007)(316002)(8676002)(66476007)(186003)(41300700001)(66946007)(53546011)(8936002)(66556008)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFhtbHFMbzFSV3pwbGdBT0E0L2hXRGpGcFB5aDFUdm9pWnc5dmI5NEZwQUhT?=
 =?utf-8?B?TURtaDV4TFJ6S3hocDdEdW1LekJxdzRYeEhTNmJ0V0R1Zzh0UDByemdaTm1X?=
 =?utf-8?B?YlQ3UEFzZEVCRGhDSEZGZzBubWk0bkNMQUNyblhwYVZMcjl4UUhmZTk1dGJ5?=
 =?utf-8?B?dXJQL3VaeWJnUHZUdHZZL1V3eFZpeForSW90MUErWnhTQ0s5RnFnZTVhOWRo?=
 =?utf-8?B?K0QvdWY4K0tGMVFGYmpMUENLL1MwZytIb3VsRGtFUkFjWUdqQ0xyM1ZtdXZP?=
 =?utf-8?B?bWhjWXprNlBadDNWSThHVTAzZTRuaUFSQzRackUxUGhsTENSVG92R3lFMzlC?=
 =?utf-8?B?ME8xTE80b3dJTFNnckZ1UllQc2I4ZXY5NDJVZDZiSFJ4dFFDMkJSeFhhMklR?=
 =?utf-8?B?K1VsOW9TOWxvRzJNcytRRXFmNmFSVnc1TnY2WDJaVTBlSEQvenVMYjdDMXhP?=
 =?utf-8?B?RGdoTGJ4eUZDbElhYzdSMWI3cDNpUGRZbkR0aVM1aHp4dUlodjU3Mks3Y0x5?=
 =?utf-8?B?UkNPL2dOYUYvblNUb29jVm10cGtSVXNqUmJNK1drbmhQWGxrMlEzeS9pcmlh?=
 =?utf-8?B?ZDE1bkRhaHBVMUJVdEdpMFhKNDlTU3o0RHpHODZiODVDd3dMRzByUmdaVERa?=
 =?utf-8?B?b3hOVlpiV2xxeFNVNk5uVUhyaUt3bXlpeFNjdEpZTm1LVStIcFhOa3lsQk4r?=
 =?utf-8?B?a2U0QlpJZWYxNStyMXBSZFpqbHlGbG5mK2hCcVVsT3o0bldralU2VUlqdUxr?=
 =?utf-8?B?cU5qRmMwcmYyRVl6Q1F5SEcxdStsUUNzcXZBY0N2OTQ4TmcyVmRsUlg5eGlm?=
 =?utf-8?B?WWlzWTBvcG4xUC9qcit2ODZ2QnFMNm9jWms3NGlPMFQrdHZrVDBUV1VZRHdB?=
 =?utf-8?B?S3dKeTNJZHhNSndpSVllZ0pKZDE1OWpKdlc5K3A4NXMwVTU1NGlCNnpJcllS?=
 =?utf-8?B?MmdiZHgyMWhZcWd2Y2dNWTNGTmx1Wk1BTEtlTUtOZ1duNFc2ZGJ2OHdKMnFk?=
 =?utf-8?B?NDFyVVQwZnJNSVhJeGJPTHJzblZpczE2OERTM0N4WEVZenUwN2pXQ3FRSFhO?=
 =?utf-8?B?aVFZOVRSRE1BNldPd05xVHZERmIrQUFJUUNxaWx3UEphNWRxNDBEVkpLbUNm?=
 =?utf-8?B?NmxMRFhNSzZsYXhGS25MYXlWMnh0Ti9OeHBrVVg3QUhXcnUrelc3T2NVVnNH?=
 =?utf-8?B?SWR5aHlEZUt6azMrTHF3UkJXcUpWajY5eWlQaVpGRjcwTGsxcVBiajRpdlVl?=
 =?utf-8?B?cVJHMUpyKzZiekFGSWwvaDcyZ283Uy9qbk5XWE9DL3J1Ulc3VExkc3A3Tk00?=
 =?utf-8?B?UHhBMERKM2pFaXgxS3ZWSm81NXh4enlVQXNNc3YxbnVCL3d2UGxaWFpQU3Fz?=
 =?utf-8?B?blFtZFg1S3k2YVJtcGx3elFLMnNSTiswZmdaajBQUzVkYXFiYzY5cWZ6TGtu?=
 =?utf-8?B?c3hjZ3ZRZHNrUUNaNXY0NHJ1Wmh6U2dUWHNvblBrTEdNWXdTeWs1NUV6WXcx?=
 =?utf-8?B?K0VsaGdUMWJuOE5OcVkzUWpydzBzcmlQN2UrbG02YmkxWHkyaVhFQkgrWkhJ?=
 =?utf-8?B?Z3NqSDRreVl0ZWR1dUtpR1lrYWpnQnVtSEhVQldrV3hMZWcxZVpxdTFwSUx4?=
 =?utf-8?B?U05RWHRXbW5VdmM3Q0ZDY1djdkhyeER3NnVtajRiaUR2bHMwNldZOG9jMWc0?=
 =?utf-8?B?WlZrZU5lVG83SFVEZVNkOGo3MmU5bDlXR3lMREFvQVlUeDhvKzlCeEJ5OTJ1?=
 =?utf-8?B?anhhQjBwaWRMQ0VqK09VM3QzQVNrS0MyZHAzbmVlRDVOdk0vaUVLQ1B1cVYw?=
 =?utf-8?B?QjNYVU9ZVTRtV1Bpb05NUjUxZGlZbXNlNG9LaDVscXRoZ2d3bE50bVVRdHVn?=
 =?utf-8?B?eU10WlBLZzV4MmU4bjVoNXJXbEJKbEJKTXBvMmtERVpDREtNaWlxWkozWjFq?=
 =?utf-8?B?TUhpRjlTQkFjNjZwbXBwVHBqUXVQNDNNWkhrbzQxelFSNGM5amRrNVlGZER4?=
 =?utf-8?B?VWtBOGorZE1aZUdXdzFxUW9lUVNxT3RIOVlIb21SQlVRYytERXk0UjR4emFZ?=
 =?utf-8?B?Z0IzOHB5eGI1YWt6NDB5b1lNQVp3MVUzYzFsK2ExK0tZWG04TEROUWhINm16?=
 =?utf-8?Q?27JLVAfwMm4AwxX6Lgoxi1/Sw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab147eb8-0d3a-46e8-e908-08db2fc6e1d5
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 19:59:04.3854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2vXCjl7LPWhsGOPIPg+uk2bUHx5/6iEhj2Gx0GkbdIP89iQ1Siga5ZrDSpfiQ8IoZCBaxxsTAj7QfntK2MLjqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6722
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/27/23 19:14, Alistair Popple wrote:
> Device exclusive page table entries are used to prevent CPU access to
> a page whilst it is being accessed from a device. Typically this is
> used to implement atomic operations when the underlying bus does not
> support atomic access. When a CPU thread encounters a device exclusive
> entry it locks the page and restores the original entry after calling
> mmu notifiers to signal drivers that exclusive access is no longer
> available.
>
> The device exclusive entry holds a reference to the page making it
> safe to access the struct page whilst the entry is present. However
> the fault handling code does not hold the PTL when taking the page
> lock. This means if there are multiple threads faulting concurrently
> on the device exclusive entry one will remove the entry whilst others
> will wait on the page lock without holding a reference.
>
> This can lead to threads locking or waiting on a page with a zero
> refcount. Whilst mmap_lock prevents the pages getting freed via
> munmap() they may still be freed by a migration. This leads to
> warnings such as PAGE_FLAGS_CHECK_AT_FREE due to the page being locked
> when the refcount drops to zero. Note that during removal of the
> device exclusive entry the PTE is currently re-checked under the PTL
> so no futher bad page accesses occur once it is locked.
>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
> Cc: stable@vger.kernel.org

Thanks for finding this. You can add:
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>


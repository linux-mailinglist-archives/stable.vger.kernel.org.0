Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96AF76DA27C
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 22:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237926AbjDFUSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 16:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237787AbjDFUSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 16:18:11 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32215B81;
        Thu,  6 Apr 2023 13:18:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLVCQLIXNmSNTnStB/dbKXOKU4wQiier5J3Y7+/TK103dnqk6Q1IClql4MubE55Ojas0KUADSmHrm354hVVoZSuH5o/te6TJzNkUYOWa2nEWeYQot5XRt2oa5yATHo/JCB39tiZTGVNa3sIfdGK+D+p9oRkjykR/EaVmxpGbXGiLXRGeN+61qyYcYzq9e5/rEqNU3YHML6lZccDr8q8S5WUJ4pJtot/XiW7KYEOeDSURwR1wIyViiXue1ckJViU12jg1erlCJSijkory5m8b0ayMyFCighLRG22XlSpAyYOTJsR+oSftyGG4dE0eXYsw3Gnaqi/UFwBQ/AkWcGh+AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JsXJij2NqlUSzBF+ZkH82taToQn2TAHyHVuuX8X+LF4=;
 b=Mus6b7NiG4KNmsxLEuXfS6e9GEp5s7gvQ6pJPAu1MiqTB0gtaIDZn73UY/U0A7bdBUaENtHqUPWno6vPALP8ZKQ0IE92kGkumoGksYX+8U2dAnJC6Pu0+5z7bU4G0GK6XpTIzVZxGMreZX9j4FraVlt+wN/dgX/8C6ZGox+wgZ2fYJrOhg+tkOH1y3NgzZo4Zi2Hvb1S2+LCFraH0yv7ffj/Crhm/r/F9t6DnJoTuzaNWyGH82Ga5RljS4wp4ofehySw/Lrpi0JxmXvVOqX9CPS+HF3d6KwKD5rsrCPtXp94ZppGCuemBSXv6TjNrQIwQT6Y5Ua84+/QwadnDpfDiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JsXJij2NqlUSzBF+ZkH82taToQn2TAHyHVuuX8X+LF4=;
 b=c1WpdP3tqTlMKMKpagP/xEW4b52hCIiyDCDXpDHNQyc1kZ6wEgbMVLJQnY1Y+Lt9UfG7Q/Gu2CIy298jjYxSu/H1iaMY/s4BfHrB3FMDjru8sIg2HJt4qoa5LLaXkttjliBAe02JnpRbWtwFfHtiiBmHYMTM2pGgXtMsZhmL/8CERT5tE62Ljf+eq6cMsryfJINuU3olw9xahmfsZHMD3swX/oBttjcgc7WBFiuMOQ1FZIVtAjPLsAk9XmV3phXs4wExoqsPtcBmH1+4BV0hMdtAfaZJaFEIJ4eQC26RBVVh98S3tvX2E/ol9V8VMr81RK8J+rELwd+6p3XyTgSy5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by SJ0PR12MB8090.namprd12.prod.outlook.com (2603:10b6:a03:4ea::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Thu, 6 Apr
 2023 20:18:08 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::14c1:21d:5f45:5b49]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::14c1:21d:5f45:5b49%4]) with mapi id 15.20.6277.031; Thu, 6 Apr 2023
 20:18:08 +0000
Message-ID: <77a62c7c-055d-9624-54ca-28cdeaa3b353@nvidia.com>
Date:   Thu, 6 Apr 2023 13:18:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] arm64/mm: don't WARN when alloc/free-ing device private
 pages
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Feiyang Chen <chenfeiyang@loongson.cn>,
        Alistair Popple <apopple@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        stable@vger.kernel.org
References: <20230406040515.383238-1-jhubbard@nvidia.com>
 <20230406130720.ba11ed2de992cc4c2485ad5d@linux-foundation.org>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20230406130720.ba11ed2de992cc4c2485ad5d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0068.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::13) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4130:EE_|SJ0PR12MB8090:EE_
X-MS-Office365-Filtering-Correlation-Id: 877cb641-0e4a-41be-3eb3-08db36dc09ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NvpPK6FfPPtmku9AQhJxEC+7P62tP+vjy6xDUpGi+koiASen6kofsbeRmLkRv+Yd0jUnFxE7uPNmi4oUihpP59FDIDnt96gl236tlt9yeUfxbaixnzDwd8CLIoxmk3aQP9+re7roVEhVqvy9ov7b4rfyUZJXXSQJgUOnVh3/0gemhsKfnRRpFWJkRpsXuQazkQecAvBOklveKLwidwr/pgNwudH0zzWrAwI9XKD6g/WavWmEaSPTYdZbjstzXeVFR5x1vL2n/wz1CbOVex1XWo5No2YvqiexKjGrfMlPrCZYiVzDqQroL22zAXt2/LbJgvzsUWmXrguc/MHoyiH9jigdDYuY+04q6boygJU0hQ2MIKocsUj0IegIWtB3y4FAmgsK5pLRtnWdDiEUQWVAZK07SbW8/E8YTUGe3TXzF6gD7CIMVcNISvBsX7J9C0KspoambbGb4iBGJiEGT4k0Q+vFAyy2YnAw/iDsMoTnEsM9iCM20Ief9zbQ/UIe0ol4g4iDV74hL1cCX3inwhg505ziSE0FABHzgqQ14uLBMAp9uubCg8sev3GhA7Vd9MgJAVkw3hAK3V63/QAIpcCK0ZFt0qvNaguVO0q+xmduxU8B/HtS3MkOkEL1M/qdxNf2Op0oWp7R3+emB2EDspPTkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199021)(31696002)(36756003)(2906002)(31686004)(86362001)(83380400001)(6486002)(2616005)(186003)(26005)(6506007)(6512007)(53546011)(478600001)(6916009)(66946007)(66476007)(4326008)(38100700002)(8936002)(54906003)(66556008)(7416002)(5660300002)(41300700001)(316002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXVEZytuNTBLWnFlV252VDJrYU9lb25TTVlYWGk1KzBOSGROZnluRFBycm1P?=
 =?utf-8?B?OUJQV0NFT243RzlVdUhhaTRSbmhmbHhERWUxeVNEQkZqc2s5UmJnK0YxdXhP?=
 =?utf-8?B?cEJhczUwYTlYT2wrRU5HUnpveXBMVndRQjJIRnA2K0ZvNVRzbmxwNjR3bUNQ?=
 =?utf-8?B?Wmp1NzJ6UmdGSHVXeE9CMlJYTXJlbXhnd0tNZU9qenlCaHpGK3p2d0xSZDdJ?=
 =?utf-8?B?Yk9NRHdwUkVyK25PSVZGVk8zcHNJOW4wc2F3S1ZrSGVkbGFsaUpwUkIwZ2Ri?=
 =?utf-8?B?THFHTjJqWUp1VGhlUlQ1YVhOeElxSmI0dGN3b2J4djBuY1ZPS0Y1aTQ5SE1q?=
 =?utf-8?B?RUlvd1MvRHpXaTlzdHMwbElnMFhTUGpkSlZXUjZ5TW9wS2RUd0J0VkxJN2Nj?=
 =?utf-8?B?bGtGTzNwTDJESE9aelFMSFUzOEZGR0swQW5NVFVmU3JuMFEydjlZQm52V3JO?=
 =?utf-8?B?R2pYaUdqa2crQVdXa3g2MktmS1QyNlJMZFMrWmpXajNreGJqTHRwMm13TXFD?=
 =?utf-8?B?TWpXK09FTG5vZG1PK3Z0UDAxTmJQQzBiRDhQc1drREZEQ044WmJ5dUxBblB1?=
 =?utf-8?B?NWtTTlJUVmc5R2VzR2lhNTZlNktvak5SR2RiNkFTZzc3UUJpOUt3cjF5N0ZK?=
 =?utf-8?B?QjJqYmtwYWJRRGhpWDZocmhhajFkWkQvb1U4T0ZoV2doTWVhM25sVExHQW0v?=
 =?utf-8?B?dS83clAvbnVIRGRyZitnbTkzc1hQSVJsVEw4WjQ1Wkt1Z0lYeUpoYWlQOWZT?=
 =?utf-8?B?c0R2NXRjSVVhQUlZZGh3UnFUSmR0MmY4YTRaaEZaZHRwdGZheUpDbFFlZUs0?=
 =?utf-8?B?RWpiRjZsWU02d3VaUEJzTDVsTmw0aEt1ZU5udU8yKytJYnV3QllKenJQRmly?=
 =?utf-8?B?dnVMVlNoaTFQOU50OGtmeHBwTzhGanIvamFkV0NRZXhrRDhKalhiWHlwNmRa?=
 =?utf-8?B?NVU5bW9HUi9YME40YkgySCt2Qnh3a2JDck9EYUUzeW1pdUJMakpSYzk2SzFK?=
 =?utf-8?B?eVZET1gyWk41Y1JlK3VlVmVmdnFSK3E2ZU00amQvVE9JNFRaUzBxL3V6NEZz?=
 =?utf-8?B?RTJEaUh0SVc0amlWd2lLNmZTNGIvWmVUdWVKdHdVNkcybkY0bk9ScVlCTmI1?=
 =?utf-8?B?VXdCYkZZUGliQ3Jrai9UaWFkZzd1YjZrdTdidnA5Y0loTmV4SnhBeWU1UVE0?=
 =?utf-8?B?MnRkNjlPeS8vYUV4MERWdjRtRjFtcW9sd25XQWwxWkVuM3VSdU9FaTJjVG5X?=
 =?utf-8?B?aG8ybjFlQ2pLTmNncUtlVFRYSFQzTG9lM0FsTXR4WFBjRlgxcXpzN3NWVURE?=
 =?utf-8?B?YVZhd0pMaERkNFAvMGxJL3plcGRhQkRyZkwwQzkydC9sTTQvWFBod0tYU0d0?=
 =?utf-8?B?Qm13aDZ0clkxUmEzcGNQYXVnVWxMaVNQaGJ3c3d5Ymg4K1RyOWlyWFg4VDI5?=
 =?utf-8?B?OU9Rd3pTbGlGKy9ncDdPRmpKd3F2RFdjdjFEc0pzYUNRR1JyOGRqTnVTMEFy?=
 =?utf-8?B?NUlXdm9zbyt4SXpRTHFoK1dmdi9OWGxDMmRZOFpyelV0QXZOc3VjbWdOWnRV?=
 =?utf-8?B?c2I1emsxTUU1MFM3OEJGOW5YZzVHMlM4ODFxY0RBTm82SEU4QWl6NlZGbnAr?=
 =?utf-8?B?QllUK2xOU29JOVIyVi9ncHhZWTh0d2NRK3BJakoxZDJPTmJhRmEzbFNLdFY4?=
 =?utf-8?B?SVpIekRrZmhzWGM3M0R5ZmNRSE16QVBBNzdmaEVaTEhPam9pbGxkMUdpWnBz?=
 =?utf-8?B?Qjg5dlRsdWxVenlvOG85VGU0NHhBQzlTUExiUDlrazV6ZTQrUVVCdHUrUUNG?=
 =?utf-8?B?NlpEZFBLbWJWeUZKTXpMVnYzbWVLd015ajJYd3FFWmZlaG84blNQckFaTzBz?=
 =?utf-8?B?aFZNVFZWTFJOZHB4bVBEc2d1SERuU1dNeHZDZklGbFQvNWI2KzlteXFyV2Zr?=
 =?utf-8?B?OENzckRBOHU0NlpUdU94L29obHg2Q09EWUttamU4eUJON2JQREdDdHEvYlZu?=
 =?utf-8?B?N1hGL0R0ZjhHZTkrU0lsUmlnZnpYSEhuejFNenFOejVrbXdFejE1VExyNWt6?=
 =?utf-8?B?QmpEVTlNOWxlNGNac3FQbFhKbGhpL1grTlA5emlxNTNBbFBtSjRYN3ZyYWZW?=
 =?utf-8?Q?WFg2jQp12avvQ51pSBfHLV0/K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 877cb641-0e4a-41be-3eb3-08db36dc09ad
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 20:18:08.7648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k7SDfzSPrP8KG4fFMKFMPJu3HaOX5hnjf4qfrAbUdtrXZ2FKHOE1f3isLnC7rnHuRjAfknLsSa0LiEAlG3UTzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8090
X-Spam-Status: No, score=-1.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/6/23 13:07, Andrew Morton wrote:
> On Wed, 5 Apr 2023 21:05:15 -0700 John Hubbard <jhubbard@nvidia.com> wrote:
> 
>> Although CONFIG_DEVICE_PRIVATE and hmm_range_fault() and related
>> functionality was first developed on x86, it also works on arm64.
>> However, when trying this out on an arm64 system, it turns out that
>> there is a massive slowdown during the setup and teardown phases.
>>
>> This slowdown is due to lots of calls to WARN_ON()'s that are checking
>> for pages that are out of the physical range for the CPU. However,
>> that's a design feature of device private pages: they are specfically
>> chosen in order to be outside of the range of the CPU's true physical
>> pages.
>>
>> ...
>>
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -1157,8 +1157,10 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
>>  int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
>>  		struct vmem_altmap *altmap)
>>  {
>> +/* Device private pages are outside of the CPU's physical page range. */
>> +#ifndef CONFIG_DEVICE_PRIVATE
>>  	WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
> 
> For a simple expression like this to cause a "massive slowdown", I
> assume the WARN is triggering.  But changelog doesn't mention massive
> dmesg spewage?

Well, it should. Whoever wrote that needs to improve the changelog. :)

> 
> Given Ard's comments, perhaps a switch to WARN_ON_ONCE() would suit?

That would fix up the user-visible problems, which would be very nice.

Meanwhile, I'm trying to sort out whether this really is a false 
positive for arm64.

thanks,
-- 
John Hubbard
NVIDIA


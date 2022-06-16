Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E49F54DEBA
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 12:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359845AbiFPKLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 06:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359684AbiFPKLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 06:11:36 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2056.outbound.protection.outlook.com [40.107.95.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4185E5D5D8;
        Thu, 16 Jun 2022 03:11:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DhR0PpWb7N+6OVHs7mX+R8ne9M9K9PDb0ZA308BKDFiVnGbYLiRGrYQVpTJsksXzqYnILu4gyvsGOp/r+5W/aQXNZ/PitZfuno3YmfgrRXkFTk4Xsibux500+a4hTEugyhjF/zzk8LdVbCl0fUnu5Oc2ELYmSJdSMheasboqARCuOPDH0dHAxketSJ6EaQSOdFWAHvbhCBQUm1t/0vHEmFj/gJ7466GrwLBPcefBNsd1Ipdxf5jiq5sgk2tInOiqxyDC94R3AYXOFGBQ/yTuMjwwXYexg6sHnAKFM4SxoZ1zCte9HG0Wy9dl7FEtVIRM389nrZgcLvpkCxsx1yxGrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1wSf2NO9IVYZ5iA+mLXR+l5lXvI0+N/iPt436dzG2M=;
 b=c3kKnKU6SjrYxw2gAKHr3jp/X4w4C+sBLSO0IeBo7nCb58D3xM+l8Z8jDCDyRnv6xYab8H95zKqJwgEwJ336YO84v+4FH89SDch7Qm6WKTrG8HW8HCww6VBJQUvup8CGoeMpvlM1+Xe4hgrCqgZPVENjzO0Q6WlyxOgVFER0GrEKLEFnGy4WvZu2HWxtCH02Z+IhPwNYrD4es9R0UuxliJsvduAwnhT4pRU6H0aLtU5gLCh/0/L7samLVatBXTxaFKEoiv06GLMm4L+In1XwcmuD5Tn/+uTc9jc+Gyl4GI6cSnMN4zOpphYa3NjeJ6zSOI0AFMbRaPe79R30ObVhfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1wSf2NO9IVYZ5iA+mLXR+l5lXvI0+N/iPt436dzG2M=;
 b=bCLHGm2BUh39dzSc/1QmJqQOkdy2kRGKTd0GWz4xIJDuctIkUpTa6LboHSz3V74ikkFmYTN8qzJTJLRAPIwKjvgtsSyB320TpXjkE1M6EUMvPzGfUQEFw4NUkTybFJEHVZe2PIoOFgFS14MK2dso51YB7FVDuOUWct2DzJT7aW7rXfycQy0wKI3sTJkTNxL6GOjplSq2q+CD/V9fpWAB950anrPe4QBdjpNqrFObPKHrRwfqEwJu45/NwlJu6BmSkTxWzi3h1AYK5Mf+EbHYnGTS9HX0oNaElIVtLuMQ0IFrLNycPSO9s2bT5K/49jXvY+dN1OTqS6yrfys9qef5tg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 SJ1PR12MB6124.namprd12.prod.outlook.com (2603:10b6:a03:459::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Thu, 16 Jun
 2022 10:11:32 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f%4]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 10:11:32 +0000
Message-ID: <51786b52-a33c-96c3-583b-2fd2d158ad5d@nvidia.com>
Date:   Thu, 16 Jun 2022 11:11:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.10 00/11] 5.10.123-rc1 review
Content-Language: en-US
To:     Ron Economos <re@w6rz.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220614183719.878453780@linuxfoundation.org>
 <9e43b35e-31da-7e51-006c-1aa69acb10d4@nvidia.com>
 <a05678bb-29f8-23ea-9260-cc1cece3f480@w6rz.net>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <a05678bb-29f8-23ea-9260-cc1cece3f480@w6rz.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM7PR02CA0026.eurprd02.prod.outlook.com
 (2603:10a6:20b:100::36) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99b5241c-1916-429f-f90d-08da4f809643
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6124:EE_
X-Microsoft-Antispam-PRVS: <SJ1PR12MB61249F36D52B3246B60287F2D9AC9@SJ1PR12MB6124.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bjwSaW/ZrZB1i2DS+ZU2zgV0/CmTBTA/EgEWpDxHk1j/IRiICA5vn9SOA2YRzv382CaId09iKmSVGWCNJfHDQown5Ln93ARiIL+UN0DnXlN8DL5u6jBTyJXR1LbwKO1igcRLT+CyX3YypDOTqjLyRwmINA8oqbhbFNOuwhUC+L6tsaO32yKMrZ+FxAtiwcXxAciL1xlfYY4NEPgjiVpPaLKMIWFAo1HfY4pCiBgYVCKnUhl3lid46Ro/MQ4oDSN2Ue4KgZtNPXgOISGsf0A/u9HT1LJF1cFPb0uHAnj14Qq/EwtjtMfF8Szs9/W5c+43iL27lxAEWmhr1XQNFH80lz06Heh2JjERnwFWcHvVUNzeSyUPxbkB+WVR9MHVKJMRonLmZV5SF75Fuz9WRZO3tdMRnZsBrICDBN7HpD6aCw2ed20rxPnLIqyOZddTTWT4JvYkp2auHrjxTUgjQRDzXsPY4m4wNGLMccH4578VvHjgNOPy5bOrcVBZWseoXs/qcbG/ufwZNGdIxeTovBmffqlytzjSdyq3MfCc/LdChRAbI5ShyFZMGp1EHTgxhZRchhItx3IPA6t4OVNlNKGx0yhUOrat4MQbg83K+xSu7O+Ln2izxBn1PDPowwMAdxxPCZTT+gn1SZXRN2EMC2pm9sSLZc6sqP2ZMYn9d6HXterUUc+r8zd4+81lovtWdVhomqk6GssUtGmUZUMH+rtgBg67NSAZDgj6gmalkyJdpeaXtNvzZdgNN+kMmVSNIflEeXS6kO3QSD/HgdISWN9J/Q1Mh2WUMB1sBwvgXITwE6u/71boYHQQHGxzTHK9OMXc0VgxhNIrWEQMoLVPc85YFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(966005)(4326008)(6486002)(2906002)(31696002)(8936002)(86362001)(8676002)(55236004)(2616005)(26005)(6512007)(66476007)(66556008)(66946007)(186003)(316002)(508600001)(5660300002)(53546011)(110136005)(6506007)(38100700002)(6666004)(83380400001)(31686004)(7416002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUxVMWs3NFUrVWVEczVsOFJGOE9xQ3RBWWcxbjBTYzZ0L2JKNzUrNnhSNGpE?=
 =?utf-8?B?cDZwNjUrUVlXZ3RlNDBCZ3A1c0hFQUJ0MkxadHNFYXhBeEhRVXJnWFpzNlZr?=
 =?utf-8?B?SndRMXlWdnd4MTBTcVJENVBRVmN6NWpTR1ljbWI4d1ZCMzVqRmY3TXAvZHNI?=
 =?utf-8?B?WjhSQStRVTVKR1hNcG5aZStEVTlUMzZXZE5YQUlDdlJHNkh3Rklxd3Z3ZFFJ?=
 =?utf-8?B?Q2xlVmNxdjFqcXlkTHNDNklLTm5pN2dmRE5nUTYvWUpqMWNuRE5oU2VUQWUz?=
 =?utf-8?B?M0MxaHE1N2h4UXVwSmpjdnVIWHdzTWwxWXFrL0tHTUkrdWhFRmhod3dhdE8x?=
 =?utf-8?B?eDU3V3Q5UkR3bWU1WmVBQ21IM09FUVl5Nk5PMThKc2VWQ3VUT1R0MHBtNE9j?=
 =?utf-8?B?QThKMTEyRXQyaE5BellKdURzMmpQU0tBcUxKTmd3UklWQmNyVzZhL09VM3lP?=
 =?utf-8?B?NGdZQkVyS1dxT1Q2ZjFWYmxuSDRsUHRleXROMjN6cm5zUHFTbGcycmk1cXZh?=
 =?utf-8?B?c3VwMU1SbVJYOTgrOGMyZXk3WUJNR0hxY2VuelFjQ2lPbjhsVTBRT1h1Vk83?=
 =?utf-8?B?MVRaUXNpZ3pGWlFvVkpaMGRLRWQ2bnhUNDhUWi8zemkzSHZabWJUcVZXQ3hT?=
 =?utf-8?B?YUt2YklCUEx0VVhpVjcxK1Z6QkhoV1YycXVkYUUrQ1Y2MVpycUZ4NDRNN2pR?=
 =?utf-8?B?aW5xMS9JYjlab25EL3hTTHQ5RmxOYm1mZEFua0g5cHpQNEwyckxqWEJWS2Nk?=
 =?utf-8?B?VDBETXZNM1pBTDdqMTFEanhZdnFLSWFIUDlsRG9aQjl4M0NaTTc5WE9wTEhK?=
 =?utf-8?B?Ly80WWt4a09YUTljRkw3VnJlM2FNMSsraWFlVGtrYVhGNk92S1l5VWN2Z3VX?=
 =?utf-8?B?Y3krem5EeEZROFJWdXJPNmZvdzZ3UzNNbU1GOUVnUXg0OG1HQXlJVC9ubDMz?=
 =?utf-8?B?V0UyUWhSZjFxNDVSSEJPVVFhdDJtSGFPekY2WnQ4SFNXMlFDdWg4V3MzS05G?=
 =?utf-8?B?ZWcxRHRrYVlmZkc1WkVYTUhKVUtSZCsxUXUrVEhCaG91d0R6S1hqZGFnMzV4?=
 =?utf-8?B?Z0hIc0RZUHk2K1dIQi9JTWRzVnE4QWhJNDVtRER1aXRNR2wrQmpRR1d1N0Q0?=
 =?utf-8?B?dnVxSlI4TlhnaEJ1SXVzcHN0YTBCeERZMU56NDE3b3I3QkpPVktnOWxBcXpH?=
 =?utf-8?B?N0NlZlJGWDZCZ1oxTm5WR0lBZTRkdC80ZFpSRWhYQU42cFBtMTlWR0VXQW1D?=
 =?utf-8?B?WXFpc1ozSWtCbDFKa09LQjZHR1ZMRm9wTW1sNEZhZTBZRmFSUk4vTlorRnpk?=
 =?utf-8?B?OUROOXN4TGNOZGwxK29qZHVVY2tMcnNhdXc4eVMwVnJVbjA3TWxTb2Y5YmFj?=
 =?utf-8?B?UmFQM1ZoUUhWbUN0aUZlS2x3czdGck1MZHJSeGUzWDRReW4vMW5TM3c2L0RT?=
 =?utf-8?B?RERFckdWcWRxdnFoNklPeWtaek9uOUNEM2M5TXMxMVVuZnUxb0w3NGkzZlBu?=
 =?utf-8?B?eElnSHVQbHplZVlYUjB6MmJHR09WcGNEVVpNT04xT0FuUC9CdzlneGJISkNY?=
 =?utf-8?B?empOc1RzTDlDclA5TnB5VEduYXJ1WlNNSG4vWktsd05YbEZuWk9pZnZQVzBH?=
 =?utf-8?B?TExDVmpRVGNMUkg0eDM4aU15US84d3BuVGN4R0lUekE2VEdyZjZKcU1uZkpn?=
 =?utf-8?B?bXZjTXNXalRIdzBnMk5MRWdQYlY5bThIMGVZcDFBdGNjS2FVUnZncGxjNmFB?=
 =?utf-8?B?TG5ZWVBib1JtUTJUTzlwcURtTlBnU3IwRkVYTVN1OG8yZU1Hdk12M2lrVHJ6?=
 =?utf-8?B?V2NwVk4wajhyMXlDMXRrTFlDSU5qVS96QU1RSk5Kc0Z6emdRaUN1MDJ6cUpZ?=
 =?utf-8?B?NjQ1bkJKS1RONzZqbUNjazJrL2FqcTZTak1Cb0pSQ2hGSCtPdExhUzRIQmdx?=
 =?utf-8?B?bFNzcTZsM0RxbWM4c2UvejhWWHozQml5RjVsWXVXY0RVQ2ovbGlaZ2xYa05n?=
 =?utf-8?B?WDZ5YUhPR1M2cUtGQ1pHYTQ2ak94U2lIa1lHS3pXcEJ3bGcvZEcrMWdMN2pG?=
 =?utf-8?B?aGNIT2RCS0x6MmZuWGxpdlA1QkdSUzJ3UHhwb2JHbmk3VjJyQ1hTRUk0eXV3?=
 =?utf-8?B?azFVdGl4QTJjdEFUWmx5L0FKSlZiWTRJZk90N0pPakhRV1lsZnJTdWZ4TUhV?=
 =?utf-8?B?NjRDS1J1NHJHdGVLdUhKUDVyeXdlV2dWVWVGTWJHeFlOV1BnL2ZQVXhyTlZl?=
 =?utf-8?B?ZHYreTBIaSsrcmNJQTE2SEw4NW9ORHFKOXVMRGtRN1RCeHpuMUJkYjNGT0JC?=
 =?utf-8?B?SlNsZjk0RWVaeHFNeEV1KzR0a2lSWmtuREh2Q0hWd282VFVpOTg4d0cxckFh?=
 =?utf-8?Q?DOvMmOkDoLvVpRsM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b5241c-1916-429f-f90d-08da4f809643
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 10:11:32.2729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OQe/hq2R/Wx+UfMgIChIjO16iZI/QuGkREgVNHJoZ1ntHR+jj3RRHolSKuzs8OZwXmuQJBoIs6nWrq4oUeNlaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6124
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 16/06/2022 10:46, Ron Economos wrote:
> On 6/16/22 1:48 AM, Jon Hunter wrote:
>>
>> On 14/06/2022 19:40, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.10.123 release.
>>> There are 11 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.123-rc1.gz 
>>>
>>> or in the git tree and branch at:
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>>> linux-5.10.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> No new regressions for Tegra. I am seeing the following kernel warning 
>> that is causing a boot test to fail, but this has been happening for a 
>> few releases now (I would have reported it earlier but we have been 
>> having some infrastructure issues) ...
>>
>>  WARNING KERN urandom_read_iter: 82 callbacks suppressed
>>
>> This appears to be introduced by commit "random: convert to using 
>> fops->read_iter()" [0]. Interestingly, I am not seeing this in the 
>> mainline as far as I can tell and so I am not sure if there is 
>> something else that is missing?
>>
> I'm also seeing this on RISC-V. 5.15 and 5.17, but not 5.18.
> 


That's good to know. I don't see this on 5.18 either, just 5.10, 5.15 
and 5.17.

Jon

-- 
nvpublic

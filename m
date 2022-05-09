Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7797E520007
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 16:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237442AbiEIOlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 10:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237567AbiEIOlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 10:41:06 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42031245638;
        Mon,  9 May 2022 07:37:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oKpdH2Nkl3NgWTAYeGs6LabDHgEk701+fPekg4zK0M6zJF6c3akFlMyvu9IvGUaJefOarN/MWltbnV+ZEg7npw4vi9yIimkpzmbvMQeXh5VrAQCtYSbVXOZusaKdmCdamz02w9X6ET19jjWbO/N7NF+EbmCVKBxoPFxJfAPLRhQKpagm6DjcK4iN9uhtWgi+f+snNgsofOmRum9UKioo6MLjdzYO+G/7foWoIVEDnscEWv6MPn619R94XWiEJZ+EHExemmyRuoWI/HjM1PH3pwYBHJo5lx4JTFjD0XhzF3jsGOUAKJscBlxZWdhbfasdf1WVDL+QidYRZqD+ntS3/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XkC+VzgdumU5dSl7Nt/T31Z5MWHml6GWbpzHm5TyOC8=;
 b=ak2D1H5n89SDZiMLt3/YiGnKcGFkTC3VZMaAJGlSXEVCOUVCCgpgZ2KDV6KeZKZ1LIGCccmgYoPE20DWcp0Nc4xNatUyEg6Kdj/z8MKHSEkK1u/VLcED0j365NfdJPNeSDMlyYgUOYkmiK6poSIbvNZNa2VsH3Iyk9owJvDxsIwBx3QqLBSb3WmuqoyYq8Yu/rVWVUMHb/uXPOrlGZe8HT4U0ZrGvyywaGJXdiMyX5g8X8Tqr9VFgk1Vncv3v/HljXbkKmojWYkmrfR/pT6jbvckew2id+f4BElMCOjymkT2zQfB1V/1oiSskL9alf5L7ZXwUypv7/GCfxmoyqJSqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XkC+VzgdumU5dSl7Nt/T31Z5MWHml6GWbpzHm5TyOC8=;
 b=qson5gfO5iH1HHqn1CMSnkjBodg/qTDeIt5FpWp7ZOQggShwJVTEqejTzOt2y0S8+NYwcDKtYXHTV4truJcZ2VLdfRQLqSVVa8MLe3dxHBjoWvhUoZMezdCxpq8REu5RgDui1cJPPU/+v4G1RuwrQmOl5gMCcwcciHroUviWyecGJmAR9UE2nJcYVB8XTPlo3weY+PU7Y/E3JcHQaFxMCBoe4grBc0ovnZG7UdjMvCv2SEwWQ8wmDlsIZ2F8Yy9c1QC+xvVonxzcSeW0ktJpTk3IMx+tQORPhR1ni+8GL1qxMgMLjvayyNGIgtOwLmX4YqU4h3FvQyUZsAKEcBA1SA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CH2PR12MB4645.namprd12.prod.outlook.com (2603:10b6:610:2::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.23; Mon, 9 May 2022 14:37:09 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::a4b2:cd18:51b1:57e0]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::a4b2:cd18:51b1:57e0%4]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 14:37:09 +0000
Message-ID: <00a2d03e-945d-dc1b-9d87-accf0b0e91b4@nvidia.com>
Date:   Mon, 9 May 2022 15:37:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5.15 000/177] 5.15.38-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, linux-tegra@vger.kernel.org
References: <20220504153053.873100034@linuxfoundation.org>
 <3b2c2d62-1e05-4a41-9d73-7bec2e63f8e7@rnnvmail202.nvidia.com>
 <Yni/Rj0b0IBiXtMi@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <Yni/Rj0b0IBiXtMi@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0042.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::30) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cc2a073-389b-40a4-9aab-08da31c9656f
X-MS-TrafficTypeDiagnostic: CH2PR12MB4645:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4645A94CDB4E5DFD180D69A2D9C69@CH2PR12MB4645.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p+ebZdBA0Dlel73sTNDvrelRAUuVEz4yX5+XcgXUbMFqFW68HjWIow1bsQ3lfIfR/VzX0ZlOOOs6tx+f8Wu3oaxfp6DbQdFoDeXAbt+OqGZ9devqm8We+lLzdIRqi/KoVLRjPjzTrUB/5mgkN0n/gr2Hp5TQS1OLNUey/o9W/8zzJ16tr2EbuPhJgpLMnnoQLuQ0ueXU8GWgQjiGXE4PTpqtFGpYUyatgnK2QVt9vompOU8rKMiVg+B1mpI2uY8gija1LvHtCMsSPsALxbBFJJSRh5VG0KGPdQqWdQt5a78axH4X9bIFfP5dlOtLHXwaVkAlDX2CP9/FjUd6Z9YIV1iWvjbDVfVamadv5HpxPEc4xnkxDHTWtCwAOjm+UVg6L+jmkkunL0C62n44Q4rlj0l2eoEFNJAwPyq1iLthjL4mRDX0Ln/t/39CRpK4LdEtQWb4wbQVgI5J9nPd87NQO80N6rLqULpWgfxnH7GM6so7LVkeypwiPT4g9ybEnjh8iOPt5OCnW/xpoTeGyhW6XAlPRdtbGlZSHTQFAS5Mye6PNv+MfGvfvFMX1llePRQQ11n9ZnyGZhPOXssReENeY35atQddIP/q9m/MhAXWLRdd1v3oR+VZvtRrBiE99P2LeJM1qGIUgNhENbzkCeFmU2mUKqV0zLelmZY5t2tH78w4ZybD52nlbzplWXf3IcpCm83wWXpJIRE0MWGw2wLg4XIwK38SjJROJ1aS3VRl1uJb7ZZfwiVbGeiit2/1km7KR8dR0kypu9FnsoNeF1WvyRID+UchRmxldoVaSNoDw3aN/L1Z7hgLVO+asJ6PaAoKujuWE2JEwn8YmYk410VLNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(2616005)(4326008)(8676002)(6512007)(31696002)(53546011)(6506007)(966005)(2906002)(6666004)(83380400001)(6486002)(8936002)(38100700002)(316002)(7416002)(5660300002)(6916009)(508600001)(186003)(31686004)(36756003)(66946007)(66476007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmdXR0VqSkIrWG81eE9hakdwQkFvSGg1b0htM1grV1lXRHE3NS80WXpZTkcz?=
 =?utf-8?B?eTNWeXVGY0FNbjBlckxCb2VZc2RlYk91dFJ2MHYvMHRQdWVUM2hSb1VSWkRk?=
 =?utf-8?B?RXZoWWxSMHEyNkhIR2Jydy9NZEpka2FadS8ySnozTzhuSUhBMzBIeUpBRTl1?=
 =?utf-8?B?dHhEMHhNVFFiM1NTMFJLNVJLR2ppVjAwQnlRc0l1UjdJdmdmS3hVTmZJTExk?=
 =?utf-8?B?eHZMNFU5eVI4a0FFUDFvMnBXbmE5QzQ1cmo5UDZOaWJNbHF2aGxRTXR0MFFI?=
 =?utf-8?B?NHVKQXRnUWx1cjlLRU16aDZiZ01TTEpNeHNWcnNDOXZaUUpHWEZENTgvSk9K?=
 =?utf-8?B?WTM1RUU1blVtTThPNzRobzNBMS90Rlp0MGNyL01nUUcxYjh3Q1FrRkdZOFJQ?=
 =?utf-8?B?VUtIMDBadmxtdkp4eklTZ3ZmdDgrb1BHYzA0eVdWeW1yNUNEVmtzaUZVSGdz?=
 =?utf-8?B?N2JHd1BtR3lVWkJzbDgzNWF2cXRHSlluZklFOHBkdC9iTDlMbVRvMkpoY2F2?=
 =?utf-8?B?VXhEcERJdTNsc3lhbkx1R1lNRnlxL0hneE54RWR4NVlHcHRCdWVUbmcxMlFi?=
 =?utf-8?B?NndkUzhKZUYxMTZBQ0JTaHJwK2FVTlBUcEk4bnljN0FvaGRiOGJ3aTEzRlRE?=
 =?utf-8?B?NGNkL1VUVGxCSldQdXA2cUJMaGJER1l3L1VMaW9scVJKb1JVUE40ek1BajdR?=
 =?utf-8?B?RkI3RzF5NUdOQUg1QjArSE50YWVuZGhhTXVBS0k2WGRhQlNpMkZUelZGemxl?=
 =?utf-8?B?NWg4ZmMxYTR2NEpyMDlZeDNBaXhoWXQ0Zlo1czd4Q3Jrb21YRFRNT1hWVVp0?=
 =?utf-8?B?emE0T0RkbGE3bkt1bi9kT1NyS1FTdUZlVkVkd2J3OTVZTmRrRlZ1L0FLK1Nh?=
 =?utf-8?B?TG9DNkw1bXFPVHNmWDFYdEJVMFdaQ2oyYWFGSlhxbWJSY0Z2YjNneXN4Z24x?=
 =?utf-8?B?QUtBZGxxS0h3WFp6RHRCQk5qV00rNWU1OXBYWVAzNFpmTVlkZkkxVTRMVkFP?=
 =?utf-8?B?NTFCLzlVb2pRb1NZVlVVL0FJVS8xU3JqQm0vZWtOVGZPVllvdW1vckhYWVRQ?=
 =?utf-8?B?dkdLNGpQYjRDRENkUUh4U3ZyVXNnQnFEVHZDUlRGT0x4d3dLUUQ4Y1F2YTc1?=
 =?utf-8?B?R0U0Z2w2aEpDZmp3RXlpb0xpcFhpdk1WNkFXa3k1MExnTTU0WW0vb0pQVnho?=
 =?utf-8?B?LzI5bU1JS01xUDZ4UU5OU1JJb2F5Y0hIb2VtS0ZZUEsxTFQ5TklFVFhzNzhZ?=
 =?utf-8?B?YVRvUDJ6eElaTzFqdjkxV3MxSHdtY0JKaU94RW82UFNtY0pOT0V2SkRrc1VR?=
 =?utf-8?B?S3M1bWRNMTdiUGd4cU94U0QwOWpJemZiM2FsdEZaM1IzbkxpR1VWK3JwMDIx?=
 =?utf-8?B?SHo5QkZ5T3N5RStudGtaZEJ4em9BSjhDQWhnTGNQekRoVlRBR1E1TDYvSGRt?=
 =?utf-8?B?QzFNYkR6NittRFhuTnE0L3FWa2d1SjlYT2dYQ3BUTE5LdVJWTkRXRlp4dnl0?=
 =?utf-8?B?SEhzZ2h2VlMxRDZsNG5WRFRNRlU4ellTMlh5T0s1VHhsU0FJeHUxeldMamo2?=
 =?utf-8?B?Mm8zUmIwc1ZoN3AyNnNGRFo0MDR0c0FEeUdnditPdVByNS9WR2t6QTJKUkhx?=
 =?utf-8?B?QlFzeUVpRkVhUVpDT3pZUDdMUVRhaE5iSk1rMmRwYUN0VmIxT2QrY3lCUndN?=
 =?utf-8?B?NDRKTkcxanMyUUgydXdxd1Nlb3pMVXV1NUw4QW0yWXJDZWEzNU8waEl3MFlq?=
 =?utf-8?B?Q2NVVjhWTlkvL0NpSVZNS3V4ZkhxSWU5YzFCTnBhWlY5UzFtbUdBc2k4YVM5?=
 =?utf-8?B?YVdHT045MmFJNFZ5UlgrSkFldU5jcXZiSzFwSTZxV2p6UHdNSWlQaHB5RkR5?=
 =?utf-8?B?bFNJbGtyZmlBWUZSV3JpTjIxSkt0dFJQZXh6cDIrWTZrL2xXNVpXcGNLY1Jo?=
 =?utf-8?B?b1JhV1JVLy9Ob1AxK2hKVTV1bDJRempBRTRBSFZkNFdpWDZUdXVxcnlFN3RM?=
 =?utf-8?B?djBCMVcrNkliOGQ4QlNLMEpHRHJqV3JxN1ZVM05XM3FVODkrWk9QazNmN2wr?=
 =?utf-8?B?Z1NMNXFWb1YrdFVQZHdFOTFoUWNiR0RwNGhBSCt5dmZwbkl5SzQrWVFRSWpF?=
 =?utf-8?B?M0dDeDFHK0dNcGhFS3A5NEVQVVhHV1Nha1UwYnA3YjZHWEZQMFNEakZmOG12?=
 =?utf-8?B?UFpVaWlKM0RSNGwwV3IvWWl0UmVrTlNyRVJaQTBrR2pSWkpkNnE5VTJENEQr?=
 =?utf-8?B?OVNmWmltTWtCSWtzTlZBc0N3VkNQcHFmRHdNc0JGdWlybmRndUtuN0FBVVFF?=
 =?utf-8?B?clR5Z1B2Ky9ndC9xTHpiZXpyWlAvMGR1cnIrUDN1ODVCcTcvNWxqcVIvTGUr?=
 =?utf-8?Q?LnAeUykSV3A7txAAYCtuWOS7xu8MQS5Ke35yWUcKwE5fv?=
X-MS-Exchange-AntiSpam-MessageData-1: AmfUGNvZ9SqsPXO11hK+3/LRyFaGPb2rdBQ=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cc2a073-389b-40a4-9aab-08da31c9656f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 14:37:08.9158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D+XrYdhdYzgKfvgTusuYEDEnggtVh04b6Wl6eeReUikp1vkl1pxsTowbdUx0pZRvoVdSdPrLdtorKZS9x+QRUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4645
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 09/05/2022 08:14, Greg Kroah-Hartman wrote:
> On Thu, May 05, 2022 at 02:59:59AM -0700, Jon Hunter wrote:
>> On Wed, 04 May 2022 18:43:13 +0200, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.15.38 release.
>>> There are 177 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.38-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Failures detected for Tegra ...
>>
>> Test results for stable-v5.15:
>>      10 builds:	10 pass, 0 fail
>>      28 boots:	28 pass, 0 fail
>>      114 tests:	110 pass, 4 fail
>>
>> Linux version:	5.15.38-rc1-gc8851235b4b7
>> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>>                  tegra20-ventana, tegra210-p2371-2180,
>>                  tegra210-p3450-0000, tegra30-cardhu-a04
>>
>> Test failures:	tegra194-p2972-0000: boot.py
>>                  tegra194-p2972-0000: pm-system-suspend.sh
>>                  tegra20-ventana: pm-system-suspend.sh
> 
> Odd, any ideas why things failed here?


Odd, indeed. Usually, if something fails I catch it and check to see if 
this is a proper failure. Looks like something went awry and we got a 
false-positive. I have checked again and all seems to be passing fine ...

Test results for stable-v5.15:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     114 tests:	114 pass, 0 fail

Linux version:	5.15.39-rc1-gab77581473a3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Sorry for the noise here.

Jon

-- 
nvpublic

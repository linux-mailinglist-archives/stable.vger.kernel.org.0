Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181C85FF1DC
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 17:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiJNP5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 11:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiJNP5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 11:57:48 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE92107CD0;
        Fri, 14 Oct 2022 08:57:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1ZX6YGbPHNxV6JYtmX1QCH45+nQXx5JEoelF8TRJkNXzzXt1HMW612D4CHAbZNBOsAvS9Ivm8UVd/a8ENpsvk/PmaChARJRLvSr7HudgZ3/KrQ+b1gb6r83/3N6RullG2XrLBgwlLIkiQ9vye8uRGJDPt4AiuI71y+Mg7LsSqxgC5Ve4NrEl5dRs+PYwr7IAAuYJtwFEJwjw9siYt+psGg66PijOSZEb/ltVcjn3sHB9JXJJ5ftJmH8imXkV/3RP6ldGHJd9pChkLPjlVdTh6BXIqXhN0DonUqYFHKNc3B62YkG13FNcA0B/qUykFmP93wrGnjiohtWJWDi7aerKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N+5sISLAJmdAf9DtcWEir7gP12Y165gCqjLNmighxuc=;
 b=FxttUfb+rv0TTf1MX+gE78NNkBG00BhsCPsIFglaxR/iCIDW/tqpYugxh3RCJXXucm/pAqoh6N27nHT30SCwTBKhtJ9CLpLRhexUiSmO4zvskQksKppVY+IEasCejGs4nU9D5LwqxraxKxXyep4RozbS3ABMek8YbGDahqm8CgUbHa1mLIPglsDbkWCL8T0kBDqalp2tOoxJ5gsTFF9wHwAvcgzA8re7bVMxrv+i+94oif0I1RlVd7YoELNTcUoXoUaaH25nhMtHAsk2w7A9aHBMdKwGy7eaocaxLeFKxrDqWNNRQppXVezDZ/Oe1+ZLeH7JP24ST0rvYR5FtmMA1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+5sISLAJmdAf9DtcWEir7gP12Y165gCqjLNmighxuc=;
 b=WSbhtSCP9oWvNBPidL2pkIKM71zVCdoUdXg6YvSnyArtcgrTLU3plk2AVYuW3VHHwLUOVRz4RB3Ikq2LH0wuHmj5HwIVSMdZ60eVp2aEbt/1VJHrJbqsetTxXIi3HIbnBd1WRDKtD6sXBPk4dlBDcFb2I1bOX5I6GYn7yBUeQ9kPK9sKaWux8KgLbX/IQJAUIkzZDUKJlxY4d0mFnSvVGJgxeZXQ+WNYoc/DHMV08ywUUlw0za/ni8Yq11ypJXHrbtSWmSvIGEgNFxyK1i3+65imKpJ+ZmlhuBoVF0YXBfQKb+rXl/jyxuFuT7tzRLQ9XZRCFp2LI+WohcXxkPn2iA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 PH8PR12MB7302.namprd12.prod.outlook.com (2603:10b6:510:221::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Fri, 14 Oct
 2022 15:57:44 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66%5]) with mapi id 15.20.5723.029; Fri, 14 Oct 2022
 15:57:44 +0000
Message-ID: <e43be9a1-4a8f-00f0-9654-4c52e858c913@nvidia.com>
Date:   Fri, 14 Oct 2022 16:57:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 00/34] 6.0.2-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20221013175146.507746257@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0683.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::13) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|PH8PR12MB7302:EE_
X-MS-Office365-Filtering-Correlation-Id: 54d7c627-e9c1-495b-b7e2-08daadfcd4ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EXtsDTSCSnBr13EEUqIMygbluiOMmdq39yBT4soLMbA7dcJbnGOcibVa9gFMif7tGOw+g0m/BNm681RhyVdfD9F2iY6juLfXdG88KUUaxT9sI6mCMicSgryL1VUmWK7SOLi9XsQeb8dI3FmVxCkT0EYJ5iH6o7C12fQyiwIQhfawAlAJO7YDhoD6vkoXj/04fYza17dO589AWt8zTq+UhN62PZOaG8SsQnYMETFjfHo2iz9aWGVE2WVy3Ks+bDgF6kV3BJ/Rju8RNu36ibgKZJ6e+1OTRrvyWryD//2D7213jrcsj7727kUntAbPMslAMpBN1ymhD4OEOsVsu2nOPsRoGm6ejSXSkruUhhep9A0GGwVXNdaUZ4fJbp/GNjs9e9zfb21G9j2LuYgZwveYLXt8mJfBf+Dk/1C38hrJCcd7QRMGX9AEPIZ0bajjoq6Js6NUi2zNtDIti/0Kt3MhPW1dokfsbSkLAF5n0KztIVfBc0x94w4PVoX/ROBidWj44NKYYSwYeUk6dLZtxBdO4BAf/SVX5FERTHe1cZP29dsqmBTfHlva4hBDJscOXS0q03pLlJYvTlyquk9TEo7ulSP9/6HHe/fNIDdaAKHqPAZ8+YQ0qqWFFTjjy2HF6/+XF8vfj00cjISAX53lsGPau5geECsLuWo0FQi/RZxc0YICCE9nAIABkxALcv+HsWF2pJIgs0pl2yHWOoGZW4Wa0bXmxlbdNun25cDR6RKVH/WCvYAfHGkrLR8+j6fNt7Yu07jGeBGOOGMSF+JkhBN0nGgqQ5kJKMbUdsmkQKt1nIckWnjbClTV/JSHcTEhHTgIy7B0zCtCQux/Uh4IN+cyYzuNqAac5rOYY8f0UIPgCACzQ3HfQu0wMBWG5hu9MnSO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199015)(6666004)(4326008)(41300700001)(66476007)(66556008)(8676002)(2906002)(66946007)(5660300002)(38100700002)(2616005)(186003)(7416002)(6506007)(83380400001)(53546011)(8936002)(6512007)(966005)(31686004)(36756003)(478600001)(6486002)(86362001)(316002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEMyNWU2RFJQa21yWlZTRytnN01wWmJJOFFBUkZQTFlNRmFkMFY0ellScjN5?=
 =?utf-8?B?T0lieDBucnJDMlJFQWE2Z2lhdmsxSGhmdFh2YUd1VllqUnZMWi92OW1YTVM0?=
 =?utf-8?B?bXRCeUJyaG9HdjlPZ3YxRUhzUFE5WGlvZkNrOGpWMzhyMHJTdStiUUFTMGtW?=
 =?utf-8?B?VGQwbllFRUpjWFNzbzl5UXhmTTdMcFJsREZnNGlxcG11aGFML0xOZk9xUDZZ?=
 =?utf-8?B?Tzg5RFZyY2pqWWlrbXFZeG9kZkh4ZGRBKzE5LzRZY1JkZEdXLzlybHVoRGMw?=
 =?utf-8?B?T0x2T2dNQTFZeWpGMWF4czRCZ2ZwenhVV25kSzhvWU5HeDBnTy9nYU5DUW5s?=
 =?utf-8?B?UjNvb0R4dytOZHRHbEtOams0dWRhVGkydGRiVHdlOHBpL0tJRkFtcGl1VjUv?=
 =?utf-8?B?bFptVHlGZEF2aTQ0RHpVWnhieExuWGJ0OVJSaDI5VUJoVXJWcVZwSjhFc3pi?=
 =?utf-8?B?dkxFYnBUSVZzQ1ZQREg1RGNCcnJIbU1zMWlUV01pRXJwaURkMWJmWCszUElO?=
 =?utf-8?B?emRBcE5FejRWeG5tWXlUcTZob0ZxKzN0bjROc1QxQW43QnRnQkV0aGRZdjcy?=
 =?utf-8?B?RTVsREM5cUMranBtcFZTdnJJL1g2emJSUjFNNzB0WUgzNTRYbnpGQ0ovem5x?=
 =?utf-8?B?U1JKWnZNSjNVckgvU0tWcGJJL2czVkw1TlJHR21BMUI1aUhwZVNHb2JjbUtK?=
 =?utf-8?B?cTh0T3VLUExBazhaYURUZXJ1cW45T1pmUU5rYTZ5S0V5c0NsdzZOOU0wa1Yv?=
 =?utf-8?B?bjE3SmpSRjZjbDR4Z20zTkRReDRMYjBYOFphcHVCcWpjSzYzZ3ErWUxVRElS?=
 =?utf-8?B?ak10MXlHRTU2cUpXSlZiY3BwaHVSU1Uwdkk1NUZSRGM5VzlSa1E5NlhiOFFQ?=
 =?utf-8?B?VGVETUpwb2RaYTZLWWpQaHF5a3pXOVViL292dUY3ckFNeXJsbHpWVGhpTFVq?=
 =?utf-8?B?Um5IUHh6bi83dk9mSm9zaXFmUnRxY1AvK3R6Sit3MmZIM2lubGhBeVZJMzEr?=
 =?utf-8?B?SzFadExUc0FWTmIzODZVTDNDOGhGU0loT2hXSlczMjdvcFhEejA4QkRNQ2JL?=
 =?utf-8?B?MGE3OTM0V3pveHFtT1dZT3R5TWxOZ2NSSG5NMmRKQmgwR1hoNWx6UTc4WWtt?=
 =?utf-8?B?cEYxWGpZTWllWFlNaWtNSTZSY1VPcnVncnA2UlpOYUZJdmZHS3pRdjBIaHlM?=
 =?utf-8?B?b3NyQldjVGx6ZkUxbTVBS1ZYd1BLR0dPcCtnNHduNlMxZmdEYURKRlZTZFhB?=
 =?utf-8?B?Z29WR2YydXY5dzFSSGgxRXFyeU1rU1FMejZrbFIzL282MkNzNTdxZEx0R2pU?=
 =?utf-8?B?VEt4a1lGcDVsZHVob2g3ZUxZWml4Z0VNS3lLUVZ0Rm1TU3czWG5GMWVLRTNp?=
 =?utf-8?B?QmhCQ1VKUDEySXJleG1mS05jWDgrc3NPa00wWU94eHdVUGZ2OXhwbmo4a2VK?=
 =?utf-8?B?ZjlYSDlpQUVSOXVCc0hjR0ZrOFlsLzBlNHJEYnFhTGN6SGxBQ201SzIwc2I4?=
 =?utf-8?B?MGxSWU9IdFZFOW1RcjZBMVRpTzd4WGJRWERRMERsUXNCVTBRcTlwclVMaGlG?=
 =?utf-8?B?ckJxbGpDZGJkbTNzb3phdjdRRDZhTmNLYjRXcHl3U2dMMHhwR1BYQnNlT0Ja?=
 =?utf-8?B?M3NiSTk1Z3o1Y1dFcWdjNzJvWUlCWko1YVhrT2VXZ3RzSXluczF2UU1PMlR0?=
 =?utf-8?B?VFFkT3UzcytUYUgwSFBqK1VLQXFYd3ppRjlwQVJma0oyOURKeXhjcU41MFVV?=
 =?utf-8?B?RXRhTy9GWVFBOHNOZXd1cEU5ZzhWSHE3ZUx1d0tOMDZXcjVvZTBqcGMreE5G?=
 =?utf-8?B?VTRvZnI2RFk4STBiM2xJcHZpOTlSSEdTTzdwZHpBcW1tcW5jTldPT1dQUmRs?=
 =?utf-8?B?ajJXL3N0K21ORUtYSDdkd28vM0Q5NzA5bEJ6STVuQTFmbnJVd0VOZG9ZZEVx?=
 =?utf-8?B?Z294RktvZzh4R1dYT2JuOENBMmlSMDFpZUJoQ2xpdE9Tb2tOQ1g1ZmUxNE1S?=
 =?utf-8?B?OFVJK25UNTJhd1IwUU56NHIrZ094b0RjM29nbDc0MVF2L1lEK3N3ME5zREpn?=
 =?utf-8?B?V2wzeTh3UHMwZXNscXA1QlJzQVpHcjJ1SDRJeVJ3RDNXbzlPbDdUdU0vUnRL?=
 =?utf-8?B?N1FlWUlyTGNKQWEyV1ErS0JELzQ1ZUpFd2NjejVhWklYcFpqWWpkUkptMGR6?=
 =?utf-8?B?U1drR0wwaE50bU0vSHJJWFNQN3ZHVnZYc3lKNWRzdDMrUytkMzROTXBTdlBq?=
 =?utf-8?B?bnlkUm5jbjAvem5kcVBXRnpwdTRRPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d7c627-e9c1-495b-b7e2-08daadfcd4ed
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 15:57:44.5183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BAG8U5X/UUGbQmKwdDodiR3foNbUOZ6jcqX91Zhw1KueOuZdmo0EKxxoaisMbadkFFTxhebpHBKUEhJhhpeemg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7302
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/10/2022 18:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No new regressions for Tegra ...

Test results for stable-v6.0:
     11 builds:	11 pass, 0 fail
     28 boots:	28 pass, 0 fail
     130 tests:	128 pass, 2 fail

Linux version:	6.0.2-rc1-g2640a427a92b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py
                 tegra210-p3450-0000: devices

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic

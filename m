Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B54D54DCE2
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 10:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiFPI3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 04:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiFPI31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 04:29:27 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2081.outbound.protection.outlook.com [40.107.96.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D825DA44;
        Thu, 16 Jun 2022 01:29:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TdwaF28XkHeVw/9PHtXeMq6dQX9t64eXJCfGrl2nMgS58dirngldSYA/EOu8tBhHMDM6F15+7XxpmDnAGzqSdUDUqvKYwOTgwBzzOARnDUJGwOAKLb3l2zYX+nN2fIh5JjWgSzmWC4oo/YlZg+f8yzhAdKBNr2sYZcF9iYnATH1RlonP5A9nrUFhiLWrcCXjjV4OXJtjwd7BXVaduinULkkEQN2b0KN2Jn2innEF46Lb4xY7vlM55H3J95yZsYowiUev0sWzOr5boCdo2LZp5oek4lmOpP4reoGiT39WQY7pmK+NLWYEJE4nzxf4vSOGDCO57RHQUf8T61Vyv/ECaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2HVuNi2LyYz46BNbnravuZd3CYtCFSMPk86XPXr8Hlg=;
 b=Whhli7gxXIozbbFIxF0aeSDFbwcqI/2oHNFMJUppiL5Zm6ZkYtwk16op/cWf/uX2vpGkN9ICfPn8jbb+eW9E0wl7r0XVO/ZdQoMgBKE7aiIIlyi26QeffrlzABHfDkrFzjEPt8rQ6AKCk6a/Yt+QLf01nQcukO28/SuhjN8L2cQqIGvEQkbzxHxSLzM8I70WGWd37WsEHemIOuBO1Ep44v1k+Z/6/NO5k/h1rAS9opQLjg3QW6HWN1xtyOUpJ7C7k+lqFObUq3KQmUm5UGBuWjTKsELggEFbC9iEESiA+XipzJ8i2Om4w7Prm6uybNr4PriYi2KIJeChoGK+5t9i/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HVuNi2LyYz46BNbnravuZd3CYtCFSMPk86XPXr8Hlg=;
 b=dpQLl3/pzLEZBqdQstxe3hPnLJKSVa6LWX3wRbUscWLO1HaAAV+YGVgshHw6jABLCFyHISh8IPDD6eh9dyegEScamYVEKoNcO0mZd/nO1cNrcF6yl9ufRinETO80xOSLAkve0YRu7K/2HJxN/ZP+NOel096z9DbNJsVARcgHAN+9k8kPbqa2nK9dD8nhYeaeQDtB5RUAvHb9MknpwzJOs4pzCjtO6fek7iKWUWfXaaNXQ2qaWoou1t5JVCbQ0Y2lLOxsvU6PIDNudYnWnxF3tqatzqyr2fFxzSq5wst7lMsU+STMXURx2qdiE4m6/VWC0SArqM2KCcxulMfo3KZJFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 DM4PR12MB6662.namprd12.prod.outlook.com (2603:10b6:8:bb::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.22; Thu, 16 Jun 2022 08:29:25 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f%4]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 08:29:25 +0000
Message-ID: <ae0b5ced-414e-2cd0-e6e8-b9f9ce9f0aa6@nvidia.com>
Date:   Thu, 16 Jun 2022 09:29:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4.19 00/16] 4.19.248-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220614183720.928818645@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220614183720.928818645@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0079.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::19) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b541fe9-f264-481e-c906-08da4f72520d
X-MS-TrafficTypeDiagnostic: DM4PR12MB6662:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB666241A60E4B31BADCBD5CFDD9AC9@DM4PR12MB6662.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4u+r6dfGzG1nvGWfzk5hJVPW1hF3SsKiC8+Nho61B7+V6wrw7Jj8r+QqowsaX7o3NJN/a55Yz6PbNpswbL5OWWOjyKI0ZrsBEPka06eqjqkzU6eIWedii4DUOVRHDGe0PZwQ34lPsGHboQw4nFhB+V5WkGm7KnUbtSu/jRpsIdLgWi6AtLJycLQHdr0nVAM3HMp2GyPe9C2sUx9HlteSkny7cEixBG/5r7ZHDEfMiMeSWMqEFG3qAJLJndBbnP5W2gZw98ne7cC1r/VZLA6WhGTuaY7RMJKOP4FZTdlctYvPXSQK/G7nOmmbdysmKw+RjAr0b2MEUWwiyBv7wEt0cX/pLfDzQgewsWh1TQhqvMMS0Znhbge5Bl7gN2LWQ+bi41zHjDYfceVYj1YgloYjWzE68I43c0qzV2WbvY3LcGj4J37Cz3GXmQb8xrHMNGDHZ1SI0OK1Vdb+GR+X4E3FplBpGUvxt2ZuYOfLnjpCFLHPjJG5KdIK/HUKkOOsaVOwCD+4jVdRBv0zakajvHdPMUnMwj1n/fta6wENvpEZV5Tpc02gfkRkoWFSuMZpc4JCihlrH5X01Mi68F9vQH8m4EYfv14OyP61eXhS997cP1gdT6seVI9OvncXS9NRoj2f4nkj4Bs08uIfTmMpPG/KxnvTgQY90TMOgcklO1+vn/82W/UHTy2waQuWoiTk9QjsL/apng06cCDablpnPeCC89J7YZhfZwi2BWO2kWmzE5XPQTLi51frj8DDUlLB/kNLKVNOuc5vZFAa37CVhgpXfKdBIEtTJyrZuAxFFkzHhkPGElFVUlN4pvUfUNXGsMGOcsGy01XWXMlUBCdrZNiDFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(36756003)(31686004)(2906002)(966005)(8936002)(6486002)(316002)(6666004)(66946007)(508600001)(31696002)(66556008)(4326008)(8676002)(6506007)(66476007)(26005)(5660300002)(186003)(55236004)(2616005)(38100700002)(53546011)(86362001)(6512007)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnlaTHVQNGxtZVEwem44VEJFWTZkR1NIWDhqTFl2Z3JRR1JuQWZ1T1UzaWx0?=
 =?utf-8?B?UVIxWFJkNHlqZHplUzAvcGQrVkZrQ3BtOVJuQ05kWUovdTRBc1RHeWlVMXpw?=
 =?utf-8?B?YXBuV0dDZCt4OW9DT3lyalV4OWloeEVNSm1CbHhyZUh6Vjh6eVlwVlRyRW12?=
 =?utf-8?B?N2NYaXAvNmpKS3FvQkNwTHJrYnFyMU1Kd2ZCdmVLOGptQ3ZSNmhWTEZFMXhE?=
 =?utf-8?B?M25wTFp3ZXRWM1ZySUNrSVFGSkhIcTlyNkVoNGpIMk9ESGc3UHVrNW1ndFVM?=
 =?utf-8?B?K08vYW1acG9mVGlzTFpVV3lmcDA2cUJNQVVoM2gyZDVBRUI2SlRoaTNOUlF5?=
 =?utf-8?B?SDJOSklWNU9IellvTjdLbXVnZUoxaGVIUTU1UU04K1BZMG4wQ3IyU2UyVDRu?=
 =?utf-8?B?OU9aVlBXaTBFeE9oWGRvTXRIMFJxNHF1L3dKRWxFVk9jS1VjYTRibWJ2Z1Z5?=
 =?utf-8?B?UC9pN0NyRUlQVmhZT0IyNTlBaGsrSzBRQ3Z4N0UvczNsa1h5bFlBWHp5aWhB?=
 =?utf-8?B?dFR0eTdkVWZ4M1FFWVdMcHVzcFl3cmloN1Y4YmR6RU5ETit4SXR2Zm52UGd0?=
 =?utf-8?B?SnNJV0FQNkhzd0ZQUnhQZnhxbk1xUWxQZ0t5OHErN3FmMDE0N1NWT00wWEZR?=
 =?utf-8?B?UkQvQVJyK3FIQTVJaElCRTkrNWhZRTVNL2VrYi9LTzNqZDhhY2s4L2RJWjdO?=
 =?utf-8?B?MGhEeDlySndxVUFHdUFnSmFuODVrNnRxdW5MVFU4aHZMYzRFb2tVVmFnOXFG?=
 =?utf-8?B?OWFpbHB5Nmw5U3RiYVQvQ3R2LytzeHFvOXc4VWFPUFBsN0c4RW1kQTljcEgr?=
 =?utf-8?B?K3VmRHc1KzdhbC9uVUo2Ri9YY3VTK3NyczJjbmIwNjcrMmRZc0NYZzMza2Nt?=
 =?utf-8?B?aDk1YVVkays4cnE3ekxXaTRrV2ZYRGF6UXQ2RzZCamlrNktrTWcxTnlsVTBB?=
 =?utf-8?B?NWM0U1BLVVRrKzlBRXh3Sm9aYm5WU1VtT1VlOVhSOE9ncjlpb1RGZnFHMGV4?=
 =?utf-8?B?SjlXQ0txdGVna3FBcW5aQnhmMC8zNG5rREp0aHBQNjdLbjhvcGlha0Yrbko4?=
 =?utf-8?B?MThFZzhaaFRPNUp0ZVY1cERVRGdJRUQ1YisxWWtmTlVteUh1UTJMM0VmWlpS?=
 =?utf-8?B?OG5OT2xqckhPRE1sUkQwNVl4Q29KWG9mZ21LMmFrcDZFOERYbWcwYUNBUTlR?=
 =?utf-8?B?YjFIQU1PUWE2MVN0ZTF6anVzKzVTdVRvVFc3YnhUS1FyZEZQUzlBb1gxcTVj?=
 =?utf-8?B?dzRyQUszZDV4TzZwc3pzYitaaW9RZFJjYXJsM1YwYlJFQVBKVUNUUGFIMW15?=
 =?utf-8?B?WCt2Qm9McXphSmlrOFZKek15eG1lN09VYVFQdXg4Ymxva3ZMMFBxaUd0UVRk?=
 =?utf-8?B?U0tzcUdJdmwxd2VHWjZ6QVFzQXdrczY5STJCNzZYTFd1VGZHenY3UUdYK2dy?=
 =?utf-8?B?WG5NMDFacGx6ZGZodHNkRUxDTVhDUnkxN3lHRHUvSmJrdUt4NWVsdlZxMmpa?=
 =?utf-8?B?UFJKWDJvTGg1MkNGN1dRaHF2dkU5ZWtwTkdOSk91c0tBN2ZDdGdaU2tFOFBW?=
 =?utf-8?B?VHE0ZXRSRDF1UExXaHdldXBFazN5bmlDZHJEVkJoV01WQllYcjIwcGp5VmU2?=
 =?utf-8?B?Q3NNZ2g4WHJCZ3dGc2VkWW1nb0pvVGJ0cUxlZ1c1WDdNUnAySnJYcGRTbFM0?=
 =?utf-8?B?NlkyckhVUjRwSFlrcUh3Y1JQV1lpNTN2Qkl2MHRHNmxOUUZyYjlqMjN5aTF0?=
 =?utf-8?B?VEhnZWhQakM5djhoKzVHV0hCS0Z2VTU5SE81dXZMbCtXNXk2azdtWVZaM3h1?=
 =?utf-8?B?ZTVxMWgwMkYzTks1ZDdlRUMwZExZeStxb1c3TW5rL1lXdmc4cjZJYVN3dk9N?=
 =?utf-8?B?QWw4ZkFlVmtpeVU5cG0xdXBCa05HYTB5MVRTS3I1ZnV2VFM0cnRPMTB4Y2h3?=
 =?utf-8?B?MndMTmdXZVpsNDN5N1p5cjdZN2ZGaUdRQTVNWFJXNi93MGdaazE4TitzREhQ?=
 =?utf-8?B?WTlLSFBTMlNtQjJuWVBBeWxNbUw0Q1Nia0JHb2ZOK3crY1FiSEJrWE9kdVEr?=
 =?utf-8?B?N1h1VFc0STEyOGVqYVpiUGg3b0IxeUNqWXdlczZraXp6bDRUY0w4QzhiVEg0?=
 =?utf-8?B?QUdqdk9KQzJZeWhCZk9qcTR6QjBmYmEyczh2TzVZcHkybTJkVEVURXFOMlhM?=
 =?utf-8?B?ZUo1YmJHbk44emNxd0FBRTRxa25NcXp1ZnpNOTl4eCtvQTMzYm45b1hCcVFZ?=
 =?utf-8?B?T2krRjVoOVd5a2ZnbURVenM4aEJXZG42WkVjaFRSUkI5cFk4U0VPM3NlOGZm?=
 =?utf-8?B?ZUxpY29JYklSRDhHeU92SE94UGFnMno1YjlSRUJnTlZGbkdFdVdhaWF5Ujl2?=
 =?utf-8?Q?Nq7YoNKz3l0niLnk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b541fe9-f264-481e-c906-08da4f72520d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 08:29:25.0347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ra72gPh1ASZydlEfFnmCoSWCXCJE7yW0Fy+2Iy/FcHSoWTRuIxVrRzBhiDLqpMc9Sr7Ak0XJWm8tns1o7rYunA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6662
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


On 14/06/2022 19:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.248 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.248-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
     10 builds:	10 pass, 0 fail
     22 boots:	22 pass, 0 fail
     40 tests:	40 pass, 0 fail

Linux version:	4.19.248-rc1-g3a3ddc084a29
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra20-ventana,
                 tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic

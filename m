Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80AB5B8BDB
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 17:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiINPcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 11:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiINPct (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 11:32:49 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8155D4455F;
        Wed, 14 Sep 2022 08:32:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mlh2IjETTDbMNIDUNH2hNG1NlGqEnMmCFb9fQMB5amYaCJJQGjbqVX82VInn6YNJW9/JyA+FtzS7U1WhIv4xDkZvnyO4ZBRrIXF2/eelUjeTD4vS+JUvW+3M8sledKaGhGOg+2x1pJczHrftY6jcMeM6SU62C8fd3sll+FaFwPvGeqeFl+UZSZ1cfks1vhqmaMrGmqh7ujhcXnkCDWDzPbSEbhzYSsgEahES4tIHloiY8uMt6yprJR7SV+lvjDkRKDbkq6eWLkmgnfPuGkhsLdTNhX2ePeq9O1N1TEOSn85BioRyGmiKrRhQh3jOH2+kDHuVnAPMNSQdcA4por0kbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qAqGQVHeRXUkDrdo+syMeO4kVCxE8D0iFGKp4quQx8=;
 b=AMNTKXsZCnLT/KbhgK4MWSk+lJjck8NFvCF6BNtcpGw0kYiaQ4FNQfO3NAAm1ByJFTIATc4j+j7PlzrqBcZtWS+yVhVOdFXmRIrcnDLgq33/YRuiIu+CUSkWRBEL6mpmUy8LWnaGGvnjRNBSbjkNMrNpuDMA9M0EksrMp37kKSSHLskIj3lNMaKLcxl0u2j/dPWabuaL+w+UH07L+TCehO9tQtBeKKMhGO9qznvOIvds7Rc7O1PpLJIOahdIYdI2lrdV1fx98WMNXs3+VWbIeamHrjqexLUVFYbbnaBX3T/RhdujezvHDKb5y0QcRX32rxAYFWLUyQJNYeOZSALljw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qAqGQVHeRXUkDrdo+syMeO4kVCxE8D0iFGKp4quQx8=;
 b=XWEj7uP2YiAqwiRbqWEGZX646QwWO3yjuO3eoWwR992bn+s4EDKp8m6DVPfVT6ayVWdNJvHm2tTzVC9661eFpIAs4lPuvkzyJUYaqGsH1JiLS7v7lXtn6MgF4n3kVTripeK0x6duRA5v/wduUsq0ejt3XXPlS7inEtpEVBZi5B4gstbituA/1/o6wcHnUoKK+KTr9V0dwCzJQ7sGhEcYYvzNUieBZkD52fTEvU2M7kuaVN547EeiN4piB6CnVke1VedHs+gQjSPrJRXCIPUf6kYPdpXFN7bXYzcwaZnGoyctLo2s8xO9+N4n1ICJIxbq1zi4MAoo1Vvuy9kdTfLSbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 MW4PR12MB7142.namprd12.prod.outlook.com (2603:10b6:303:220::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.22; Wed, 14 Sep 2022 15:32:47 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::7090:22ef:abb3:ae9f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::7090:22ef:abb3:ae9f%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 15:32:47 +0000
Message-ID: <9438bed6-7dd8-026a-6a3c-0968a31a27ec@nvidia.com>
Date:   Wed, 14 Sep 2022 16:32:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4.19 00/79] 4.19.257-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220913140348.835121645@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0344.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::7) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|MW4PR12MB7142:EE_
X-MS-Office365-Filtering-Correlation-Id: da9a85b4-ac23-4854-75d7-08da96666021
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d3LRBGtwjHJAISFH+uwZgoa9dCdGQWxXCkV+yiz9zhJGmJFW/76S4m8fVtNbN7u03dXlAESvFPg0LbfwMl/WHH1/6ZLynmAtYnXAmTZkBJtRYwywyM01DVjsk9i1Ib6PRbHEH3NQNex/7rjZgz9iw6lz8KXcR6RE1+I7fiLqG32L3QnCCnoeJSB7N/E3Oev8au+TQjFIrzGQJzBrjt4WyuDmsVso1H03cgiWRYXQ+eCMkU/uPj1m97IxufsOZr23ZEOsrbSrryuuWKMePIT3XSDucTqBZOIOYogKQvS9HxX8zgSB5ZF6PctkDaTgyU8PkAbQuwYtoJnK9ya8+qP3BVDyXU56r3EwMkVuqNEWbdZSMC+HwL4h5xFlDbkQgxN5aW4tmPVRC5lz2ESoAbFFrEN2eIcUPcJRl1SK6Xv0VuLfyoRkiJGZAPYVNbs3zw0FB0o5/o2jbeifmwHVoQW5za3NXFBkHo3r7F7phJSvMVtvBqYIKcCvD3qQB22SOHxDjhTp62c2yMl+2N0/KqwWPvCry+kzSNFpvnJgANM77ueW92N4yR6bXPDUl+qFakfrLJ+I72tcfWMaXVd9oGyaUt20XgCTfZaBTqfbo7kT5JEeB8jahv+5JD4aipN4NrLRRnmgrSoBXjTuMLZG2f4ZN0pbG7bezDVoa2ZqMoriYdRC25bYFmFr3epyXU3hdMJu0NBdx0gRtLUt2a5xQeNUaOIgdOF/Usr19fV8bEffyO38Io1lVIsaZaTkWPd4TWlPf8mm1QkWj1IP4Mu7znFZCZpzgXy9SrvEyNWVWE6iVI+POPg0t9Or8jxsBQHZK7PVIvbt3gR1ZgiwivnkuXFBnZ4nPPv4ebRD4Vith6CusLTOSn60H+FSz7PeLtXYA5gF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199015)(6512007)(31696002)(6506007)(53546011)(186003)(86362001)(2616005)(316002)(41300700001)(7416002)(8936002)(5660300002)(66946007)(2906002)(66556008)(4326008)(8676002)(38100700002)(66476007)(31686004)(36756003)(6486002)(966005)(478600001)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blRsMlY2K2VVQmc3MWJ6VUVBZFRxclU1QUVEYUpTYkEzN1dZSVNxOWorL0VI?=
 =?utf-8?B?a3l3TDV3SEgrVm1wYUFiK2dDTGgxYlJjUDE0UStid20xdWo1Zm1DMkNQaDA0?=
 =?utf-8?B?QkpBeTA1Z3FqUjNmNHdOdW5mcXRiZ21mUlovVDkxVGtLcnkzZWlIN3lEcVFn?=
 =?utf-8?B?WTdSUzdFRWI5Mmw1NEpGcjFSRjhQUEE0cGxkaitBK1RLVDJscEpKMUlPdzRM?=
 =?utf-8?B?cllVdFBYUzVRbmFkd00xRFQvcXFSc0hCTFUvUzR1TU5RdTFZakYxc0JWa1ZN?=
 =?utf-8?B?SUJnWVNyRkhvY252aFFreGlLMzMvL2lpOGlzZkRrK0UvNjNpSk50RksrYVp2?=
 =?utf-8?B?b1FzOUh6WDFLTE9vMUI3RE1GQkVueXNwdXdRSUNrSlZDbXlOWEVSdENiSiti?=
 =?utf-8?B?Y1FKU3QxZVBnQzhhMWNPUDQzY1NzdDd6R0RwSUE0ZUFwWlZ3ZTV3WlZ2MGlV?=
 =?utf-8?B?aXRkdDRYd1ByczhsejNuL3VuRVJQcUEzQVByTkZhYkZVUXFrcVAxRHZJajd5?=
 =?utf-8?B?c1lZY081UVh0NHhyd2w5TEZqNkNnbHRNelVEQWY3UG5ZY3c0ZUJRRUdtRklz?=
 =?utf-8?B?dEpTZW9TbEdsOTFEQTY4dmRhRG5ZcTdEOFdkMnVPOEZnZld2c081aHNRN2Uz?=
 =?utf-8?B?TUhoRGx4Rk5RVUtEaFRqME5FQkUzdG0zQmdBN3dpV3lseUZiOUpEeDk3Uk9v?=
 =?utf-8?B?NXB4amYxcVh4QlVKOEFLcFl1UmRUZTJGNnR4WlplMkc3YUN6c0trdjZ6cUd4?=
 =?utf-8?B?RUtKMHF3Q1Y2cE90djRIYUhwQklCY1ZlbEcyZko4dm9wTTMxTXpPZ01EUHB2?=
 =?utf-8?B?NGp1V3FTVmFnYUxSKzJEV3YrRVcxQ0dubllxeHdSM3B0enFOTW9xaVhjMUVS?=
 =?utf-8?B?MVRNRmpRVE5NRVJvczJEd25yTCtPUklCcUw2czZVOG5SRnhOM1BUYk1lRG9H?=
 =?utf-8?B?c0JLeGVxTTNpMUJmRTFPbmozeFZUQTNyeEtEWTFMUHFPUWROWmlSZW45MlY2?=
 =?utf-8?B?WnE3ZkhxY21ER2NaQ251ZllZczBhN2p2WXcxSncwYzhJZEdtQzd3YjFacmt2?=
 =?utf-8?B?TUdlUmZlNGgyaTBZK25Oay9iaFZyekxqanl1RHlTTmUzZXZTQUYySkRRNG9O?=
 =?utf-8?B?Z0o4SlU5RlpvZTBFNHBla3dDMlNjeG8zRkJyS0E1SDN0UUc1N0J5aU1nL2p6?=
 =?utf-8?B?cWQvemp4ckp6NDlDQlpEYnQwaU92N0IrLzZ2WkVtRUVleU5DT1h2TnlwNDZT?=
 =?utf-8?B?RW43ZWM0bGZid1dreUpLUDEvTExCUGlJSnZ3VnZFTnpGRm1Od2EzaTJGOHZx?=
 =?utf-8?B?dUFkZmdpc2FSRzdCejBFV3o4TkdxcG1WSjRnU3RTLzh4UWUyT2UwMEFVM3ZE?=
 =?utf-8?B?RmloSzRDbzZQQ1VhQ0xWRFF5ZldWUGkzNWFOOFBycnFHd3hIYXdwekZYYVhD?=
 =?utf-8?B?OW5MSVFwdDZXamFNK0pCcXZIQlllSHRjRHdCMXFtRkNtSnhETDU2OEpLQ1dJ?=
 =?utf-8?B?cXhOT1ZpaTVDeFpqWnV1bFlSdyszUGlYUDEwaE54a2ZLSHBqcFJQVmNjU0xa?=
 =?utf-8?B?dEpDdXNIcjdUWXJJWFN3cVRtWnFtaDE1a0xnanArM2NKM1VGOW1EUU0wYzNH?=
 =?utf-8?B?a05LMk9aMXYvWXpKL2V0QTJFUW1KSThKbGZ0eExxQkp5RDNqRDZwaEMxL2U5?=
 =?utf-8?B?QWd2bDBIMWRubjBxWFdmUTlEb3FYQWlTQjFKS3RHa3RQdysyWmpOV1hyRmFa?=
 =?utf-8?B?TDdRREN0UkdoTlQ2WVZYNkVNYXBSOW5oTnB6SlBRbEY4UjZNeng1RXA5dVg2?=
 =?utf-8?B?M2ZIKzdTNk02SFRpK2lPQVZyTHpnYVp6bFhSeTRWcHRwN05LelkvTVhjK0kx?=
 =?utf-8?B?ak5reFhUKzNzUFNjTHQ0YUxaQ0g5ZUpYU2dFRkdiMGhuOHBDRFBuSS9xNmNi?=
 =?utf-8?B?V0VjZThCV2FTUm5NYStFa21pMjdFRGZYK0VGaTZHNEpjZWV6VEo1WFVCZ3hx?=
 =?utf-8?B?MVQzUjE1UzRuTkxSSmtGZ1g4ckI1VGhLSmlwNmRoYVFTUEhScnBDYlRLTUds?=
 =?utf-8?B?L01YZ1I2V2x4eGk4cnBkL2V1aFRVZURrMXVYODVUVlJMcHFYTXVjRHJKeWFG?=
 =?utf-8?B?WEQwdkNjZHRpc09HaVBiMmc1OEtRQktBRERPQVIyRTBvNFliMkdKTFFBWDhq?=
 =?utf-8?B?MWtCVk9YR3lnSW9oUVdWT25jRGRtWHQ2cHdlZVVmcEh5OHZ4N3BPSmRqV2Rq?=
 =?utf-8?B?cmVLeDRIYkk0M1RhUngzTkJqR3JBPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da9a85b4-ac23-4854-75d7-08da96666021
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:32:47.3732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O+idkdKst0ZG5UD7jTRG2lbHq09D/wi83//hFQqxZkHvyumGhX2gRS8n5AC4vW7Qw1SROPVFCm/Y93HkKuGD7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7142
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/09/2022 15:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.257 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.257-rc1.gz
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

Linux version:	4.19.257-rc1-g74af49d445c5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra20-ventana,
                 tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2F0552F48
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 11:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiFUJ75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 05:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349597AbiFUJ6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 05:58:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D19B237CB;
        Tue, 21 Jun 2022 02:58:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/PYWS2bsvUFL1laqINuB6sV/xxlAcrr1AuDSxO8b9bcVbOF/2lH8gyIkb5tzpTAbqJgFDDC7Kh+F203aty0Lqe28qzk0fRyAelyAC0hs54wQiFYzzcRiyon5KWcQiXDqg/Blzj27dPp624699hk2//vI7CxO6JPxnIY1JNmLYrChiu6zxPFwSBMV7ZyVLu8Gd9sSZHkkqjh8gI7Ux+SEcCzTtfRxUwiGbzOlKtwz5h8QHYs9pKn+cQ6egIiS5TriwF7AKJv+Q+R9aEej8iaAAQV2n5MjeFJpPzMn2uQtejkbajrBTXMi1wUPeSXgvSPozzbmCrut2fYRKwF1Lh8HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79HAdEisXH0rPRRJWCKrVSlJHPCcPAI9skKGVfN9ffk=;
 b=Vv5ri2d+GfAMjL1q+/4Z6PyNk4aycrXEex8eG0Dl/yadpftHVGzQ/8PksNuv/Jzx4W6L3+0VUkQeNEMh7/zgSkPLV4lp4kJ/ahPAYno/gK+XpwLXd3sNULt/w2O5fDmPb+QP+wc5xZA0ojR9qoBNAp8jGlbvE6MxKbAw6ZPLAlAy5NGndGcmjvSjOLdZVK6joQwNfkAWlPdUDfldaLP9fkGFcbhctqfBFn9nFJY4QCieYBMYF3T8qHc+L0knMqXdp1WEkRjaunmcHfune4hLNjl4pwymOd0X8AW/ZqQEoA+nAyxUAExh1oZqnV6VWHEpFXpvsmqQPhiklhAFZ260vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79HAdEisXH0rPRRJWCKrVSlJHPCcPAI9skKGVfN9ffk=;
 b=slokWFZTp515lnTbHkAwgh7AqrxHtx6tpKZzRbn+smOQDXoTmQg/BCYW9zkMEr21g05xmfLyVksXByPFUHtsF5ndcB8fFHwbXdXRcMH3/7dKEWr2XZTwq51kEu0tQieNqVE75ZlVDs65VxHPEuYlIxO73d6D0aGe+Uvop1gbTNV1ofIHS0/virh2n5JTNINmqQXEn3Sp/kyR1rl1TMPh6iD5bGNUEM/nQvbPmdO9096W1uAt8J/ZcFTr7HzZn38gtku06rYcqXBmWtIBDlUd6Q2CBXs67ZtEe/nk9psaRljenRHoCDcu+fQpXUdx5yOpsa4KkHxS4y+LCJ10lgA7jg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 BY5PR12MB4274.namprd12.prod.outlook.com (2603:10b6:a03:206::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.13; Tue, 21 Jun
 2022 09:58:41 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f%4]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 09:58:41 +0000
Message-ID: <16a5cf84-2bb7-6e46-9eb9-de0cabcd18d3@nvidia.com>
Date:   Tue, 21 Jun 2022 10:58:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.10 00/84] 5.10.124-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220620124720.882450983@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0140.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::13) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fda40bf-3239-44cc-9717-08da536c9e9f
X-MS-TrafficTypeDiagnostic: BY5PR12MB4274:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB42749F42BC809A009FAA6AFED9B39@BY5PR12MB4274.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tu7ugBKu86LBAG2ezsfGvrMOtd1met0+h+kd49CwO7wflAdotk7pYTWrbNIC2kY8cS+35/NjpkTDIFRWHdanuQFFN9Ur/JVXUBnlvEeJYx9Oby+illHTvOF+EJ2PcS0UpLKl+FhpVmBfmh6WxnAAMvJRlZA8FuOoXAwHthB+/NRhRSjBZBefyMUlqtmSoew8LnNbmlxqDjuWNXBy2zfLyuLgkSweVRMPoLVZbY51n9zszYhj9PcZNCs+Q2/DF8TV7XY5GhTxTXcfB1Tt89iWApA4v8huyhthZaVTC01+uNDxpvdQL51O0eED5h7sVOYWsKc/K7qvfrOHC1R0GXWptPBd82g4QzfmS2K4+DOhMtnc60cmMBKLCesgS/cutY6ynAe3uOTHzgZIpkYS9/nBCzYbS6MMK52qQtU6502sbIiXQARaqBcRzi5keXdSj1ecFKyrkFqztS2rTg41gQl4Zh5cikoE70YxyhsFprdnjPVm4t9gTlvbH6shgZ6eKRgi/w+FDBhsrLYugRLAhvUsq9OhjPodtGIKhwSqBf3EB5FZdTihgVOnZnBtAH38VxBEuSRPOKclOxOHghw8U3q9pQ30u1SS3TMJwfQ7BffCShPbewUzX6cXm/XjSrz5sRJ+K/Cg42gL1Z1eZ0zS9uoEo0mNVJclrZhLAKJn2l7p1WRHqN7+eHCUCkCR6KVn+L4WHBV54Vs3ieqyddPJ4cUCCn4yRoq7qky26kBeS8PcL3dWAuVb6cSuzYem2bNTdaZVko8XWEJyF3QGMhzzAfvl+jDJ05aklGPuN0+GkKakL8rpWJvfyHfuDni/G8Iyz91S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(38100700002)(2616005)(6512007)(7416002)(55236004)(2906002)(5660300002)(31696002)(6506007)(41300700001)(6666004)(26005)(86362001)(83380400001)(53546011)(966005)(316002)(36756003)(66946007)(66476007)(66556008)(478600001)(6486002)(31686004)(4326008)(186003)(8936002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1VIeUVsMVkwT09xeVZQbm41V01SRTdNdVZOYXZzVkZWV3VIcXdETFlsb2xY?=
 =?utf-8?B?d1Noa2Y1Qk1ySm9xUDZvMzdMeHJKN2JHclJta2Q2aGRMZTIrZGdUUVhQNXA0?=
 =?utf-8?B?SmZyLzVnRjEyR3hObERJTjMrcy94NXdQRHhjQnc3TlhoWEVmSXlqbVVXZURj?=
 =?utf-8?B?WDRRcmllYVFPeTJpSU1NLzB6RjRXSk84bUpQamFwSzRSK3o3MUk3UEszZWdr?=
 =?utf-8?B?VFpIL3lOMGcvZHMxNHpXNWNScDJPMTFwWWxqR3U5VDBheXJhSFNINWFuamlm?=
 =?utf-8?B?QVNuei9CVjZHRXV1UCtQK3VnZ0k1aWtnVk50Y0Vzb0VEN2JsS2lrZXh4Y0cx?=
 =?utf-8?B?bGJBcnhseU9QZFVabExxK0NXMGZ3Q3BpTmNCL05mWDVBWVhkNi9xWDJORnVB?=
 =?utf-8?B?cVBXdTJEUEQrdm9ONW4zRWlwcmVDb09NRTM5RzdmSG0xTXZ5VFV5dy9UYkJa?=
 =?utf-8?B?dVQwVXBBL09kWS9UUGZvRmlLdDlKVVBCWWpUZkJ6RnFOQUZIa1BGN0JtZXN4?=
 =?utf-8?B?OUVuR1hNWVZrZS9iNWZzTzZWKy9NVTVRa1p2NmhObHZMWFpCT0NwV1NxV0dQ?=
 =?utf-8?B?a29ma0xpYStSVTlLKzZ4MC9ETEtJZlZvYk9ITjBaeGVkNmpPdUFKRko5d2JW?=
 =?utf-8?B?NjBpYS9mN0JINnhoV1FtcXNLa2NqUWRpUVdRRXloR2phTUhuRHBIcVhWWFA0?=
 =?utf-8?B?SkVCZzlVMFNCd2tuVGVDKzBJMnJ5NG9NOFBQc3pCNUNBRml2SmNHYmk3WjZ6?=
 =?utf-8?B?c0J1UlExcHJQejgxSFZiSVloek5pUjZSK0t2a0MxaXhkbENHUTNDbHlQYldo?=
 =?utf-8?B?NTcxU2ZsQ2l4NkY2UlhOQkwxbGQ4VjhRT0dQY05pVTlkajNJcXd4TEtqb1Nh?=
 =?utf-8?B?S0xFQXhKTnk1L2Z4dTBZeDlwZkZGMHFadm1PZW00QkVmNXlpYTBSVm9XYW9j?=
 =?utf-8?B?b2czOGFUeEgzMzV3YlpaYlFrSGl2eGlJS2NlWG5UMXRFbXhuR0xSbHZZWEJ4?=
 =?utf-8?B?a05kUFdLNG9LYXkzS0dnY2xPcysvNXhwVnMxZndoc3J6aFZaVmVzQStmQXk0?=
 =?utf-8?B?cnc3elQzNlQwemxySFF5cUNydmJzN3A2cVpNZkNQMmlvMUVIUW5RVjh1UnJ3?=
 =?utf-8?B?TWl5QmIranhYaGU3VXVLbnlCZ3BQU2xLQnJlVTR6Z2lLN2NudkpWY1BuUzhW?=
 =?utf-8?B?MjFIam5VS010bmhNVHAwdW1QcktEMHlBMEVWVmxTek95MERlK3FJUU0vc1RR?=
 =?utf-8?B?NFdlbDd2SFpMUU9nSCt1NjNKTVVZemtRRk43b0xuZmFWTFBvUTNqeG44OGx0?=
 =?utf-8?B?V1MxTDM3NG4zbmR2MksxbUt6V2hSaUJVQmxjcFpUNnVwUjdQWktrR2pPTUdS?=
 =?utf-8?B?anZLNmkreWF2UnNDU0V3RmpnQVdlY01PRGtMOFZsMkZseEozTHFoOFhDcEF4?=
 =?utf-8?B?M0tDZytEdDA1bEJwY2k3Mnlvd2F4U2ZnUGxUZVpubitWdm1sdXQ5akUyWjhy?=
 =?utf-8?B?elFEYUtqNUJCQ2RpcVlwRmI1UXhhbnFGektxdE41UU8xOUtrSDZUNWNFOXFS?=
 =?utf-8?B?NkNMczU0ZnZvclE4SVdrTlNhU3VGQ0dBWWl6dVFHdE9yOUx1RUIxN0t1RmJW?=
 =?utf-8?B?eVEvbHpleDJRUXI5SVViM21RcjhBeFRBSEtyN2VWVkg2MTRkRTd3U0lNSm52?=
 =?utf-8?B?NHEzSml5a3o3OXlXNGVxeGVncHMraDBXRk5DdGZaTndxSjRiZ2JCYzA2ejhN?=
 =?utf-8?B?Z2FFVlhTY3VYVkZkWU1pdThzcHBkTElEZzlWNFpOZE5XSVVhdG1vZnY0NnJF?=
 =?utf-8?B?RzI3ZHJDVjBBbkRrM3NUWklvUEY4eXhTc1BqdEd3RXR2aW5CQ0ZDRHpCSzZ1?=
 =?utf-8?B?bXZ4SjNsWnl6TU5jeFNVZSs4d1VDWmlsT21kbEhaRHV2enNSZHhiblB2MlFz?=
 =?utf-8?B?aG9wYzdCTHRVaDF6bnJPdHcvdDZLZGlydW9nVU84VUR6a2FOR3FaWngwNmRq?=
 =?utf-8?B?RDl3WnpKeGlQZXpOL3BhWVArc0ZhTzUzNDhHUzhzSUdZMXFndXpPVEZuSjk0?=
 =?utf-8?B?OW9qeTRNQ1lCMXVoMWVNQThxd3FxL0grT0VrWjNlelBDM1A5RFJ4YUJKKzc5?=
 =?utf-8?B?TWM1dEcrRGRSM0h4aFFjT085MGhkRy9VSUNoV1c5ZnIwY3E1bDhkM0drQ0E1?=
 =?utf-8?B?b2FMN1VhOS81c0d1L2NBeS80RXZtZCt4a01lZXlTU01ld0FCNVR0bWZ2SDl3?=
 =?utf-8?B?Wlc2L2sycDRWRjhrOUZFQVBmN3QzYWhFdXViRVBncmZLdXhoVjA5WE82blpU?=
 =?utf-8?B?d3pSVEJtUkYzemZ6T0JTeFpGanJkeHd1ZDdIMlZuemw2bXlRME85ditaRHFB?=
 =?utf-8?Q?3O3lXKEudLAcaiIQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fda40bf-3239-44cc-9717-08da536c9e9f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 09:58:41.2294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JliYKb0Hj1SK0p8aDoqFAMwCIliIVRPkP/BfwxsRYDKYqZGU+wp/yTcMHE5OKujhtnyklPoRoRPZmXX7ERJqIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4274
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 20/06/2022 13:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.124 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.124-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No new regressions for Tegra ...

Test results for stable-v5.10:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     75 tests:	74 pass, 1 fail

Linux version:	5.10.124-rc1-g1432bd558ac0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
-- 
nvpublic

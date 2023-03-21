Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB7F76C30EA
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 12:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjCULxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 07:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjCULxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 07:53:18 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2961D934;
        Tue, 21 Mar 2023 04:53:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tp+GfOhM5aH4zX0ZPBSBFx1ZVRDCh9MLnhN43PqxRWJh0w9TgUTOm/oBi5G+o9XzOTd3duj4jyXZPioxZ/7zScY0Ps5vpcanmkbEwBhQi28yjH/1onzEcRsZG7+yXukqs8EbxKfkBhfkAsj+dboA1RsaqWRz9PHbTrfbhX/HWI/UlfIdPRb6d1ub0ebOzrGPC9Nrj25llHJ2hAUSILB/V8tiK1wWHflAnuY5HzHiJre6Yi4VEfA2UB09LS1P+zcDJoEqqDprHulbV5aIff7NsEsNLw1gnXa10HRjnqm2tFJn7YFWmnb4Pd9q2iK+NoC8tHRCHE6WLUgxiD/3fWk3DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=65yv6wefkgNOI47Lx32w79jZ3s14A1aMQ/zP5DirNPo=;
 b=S+sZ6tdItoR8pCTUvQldKMxbBEck6fw8JfqifpG1O36aqkD+ujCZWyt6n6JWXWEkT5GC7JxTsoACDrTyF4jMoXPbhhrVfqHAAKSlkB4PvTuDdubnoUwlSwYNlL2Ie0E1onBCBMKC1A42xso5fpNg7reB4qL0AHHAZRL8eb993dWCCaB803ZVuM+r8XMtvVEqcPq5dyH7Va3Ym9fMvmH9z+ZWa4r00DrUsU0AuOKbKtD4eX57PgdAc99JCnoJahiBISoLvemUHbjYw2KQ/FmalnEUvzX2xjbkidhJzFMuhUotvmcu8vmidnexSTf+d9fGbbmySWdpctt8vbaBUJ//EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65yv6wefkgNOI47Lx32w79jZ3s14A1aMQ/zP5DirNPo=;
 b=KPgOfDCP5Xjn3Ji8QTTr64Zrr3ShzcaC79wKVN9nD2vObWpMEKNO0b9aoRhAEAlFzItpYcQkl3aIs20i6ketMJbJmcm7F23jsmH2YdifOEcFQRGzY9s6oddQF4X/5gYTmsXvsRvMBt9mdUtp7vy7WqcwPMXrrvh2YT06DB80BwM7kl6L80P9KFIYDkPW7cwtjUzCP+AfZd+E/KkR6RYHdcY24GOlJUHT4VWEblSQkc7N9C9hclm84Ir79cWYO3Is5nxKNYiICj3tnV/C94bMcqXcOesWiwtQFMmeIQW8kwg+kK6HD/6x4lCMdg7oX9en71yN6UwFwXLXUh+7QdK4aw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 PH7PR12MB7164.namprd12.prod.outlook.com (2603:10b6:510:203::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 11:53:13 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07%9]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 11:53:13 +0000
Message-ID: <259c852c-f813-bb43-a4bb-bb2d4f9e1879@nvidia.com>
Date:   Tue, 21 Mar 2023 11:53:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 4.19 00/36] 4.19.279-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20230320145424.191578432@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0211.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::18) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|PH7PR12MB7164:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b0671c2-9560-4742-7b85-08db2a02d97f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sBJL77E03Io5HIoZIZLd0zsX0tWI/0/WvKiop1wBc2J1qiK7zgF0/EolRVkB7OBeCOQGySpUG848KxeI559c/5LECJ+9PALNfWfvu6y6CCxUcthY9FbOse56MXveqZqwc03vIWUd2j2g7SOS6l9WWOTQ+FT0zoyQVd7+sxMftJpCj6zK6W5mmVIYR3fyWMTvX3BmB2gK16bwS34P9nyTQkD9XEw4LKHFK8JjuIAGCNxOhqRZ2z6+9KEw3gNvreQHiu4bfeQe10uPuAPizsWu/8leiXG2UsLP+47/iBErw3QfdlbF1TLcZPTPIXqj6zdiQtg0T92MFuAUfSAA+hmSKHHZPZYJDzcGb2Tk7LQ2cBk9orpu+2k+/xwRPonUr2EHESZbPZ/OEfaxLWXD3cZCOOoULD07y+q65/m3Av/qzrnUtDtSnULcahSqisI93PCkXk/rjFGzpW3121n+27V6afJdQnYdAqrwOY5NTyS5x+Q1/H+Rq6JQVm6YGc8PhWWJaPovbu6w4litnt7GINyHhmxvs+Hc6PSCgjlEYaleh+JEvVzYqGJcU8dKlCDvlZkbxP5dvS1zxYUS+5qW0No6zzWj0WyTXwDc6CM8QhHf8FMXh8CvLym+6CCZGHHtaIohw4YDl628s2YKQwiY/V6kVQAoakKYHSgr5YnjSRtOBdq8xOC+BOp2IdE9ZQNyTvfoKzlCDbSm3mDP+O9++1CRjlhX5+tGr97qYh/5cuNbLOjPF1y3XZWJQol8e0x3gWS1POcOu1qkyRsHkJ2PTh/yug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199018)(66556008)(2616005)(6506007)(6512007)(55236004)(6486002)(186003)(26005)(966005)(31686004)(6666004)(8676002)(4326008)(53546011)(66476007)(66946007)(316002)(478600001)(4744005)(7416002)(5660300002)(8936002)(2906002)(41300700001)(38100700002)(31696002)(86362001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUx1N2Q5dk10alJzVEo5U1RlQ0xxL3dsamU1OTZGQUJCWDhrTmNnd2paYlM1?=
 =?utf-8?B?RW9rZ1R1Um4wSzM1cG1tKzlaS25RWTNDVXhWL3dMNGhYZ0RkUzdnOGVOOFZh?=
 =?utf-8?B?aXpuT1d3M1FINXpPUlZNNHhiemM1OVVsL0JQUXBYZWRmZm1mcHZoZ0RHeTVJ?=
 =?utf-8?B?dGlvY1UwUnRPd1IvMVcyRlZnS25RM09RM1BESWFxdGVHM3VhT3RENm90Mmgr?=
 =?utf-8?B?R0daRjlxNXV2enFGOVlNTkJZNGQySjVRYVBsaUJzSEpMTkdVdnNaOXRQQ1Jh?=
 =?utf-8?B?ejBSclIvSWRZVWJiQnNXREwzS3o4dzVyNDNJWWpvTmlkdWxmL0MwdEhPaHdq?=
 =?utf-8?B?cTdjQ0ZoeE1oU2xOOFdVaExRdU9Wa0xLWTdmMk1UdWRRb3pzcUVWQmMvMCt0?=
 =?utf-8?B?ZlNuMTByQnpIRGl1akVHbmRxbnhTQVc1dU1EdDZkV09DUzhVWmg5TDM3ZEE1?=
 =?utf-8?B?ZWZsdUNrdjRwc0Z0WjNXWUxObHVtWWdabUxVOFoyenZQcnRRM0NhZFJMK1B0?=
 =?utf-8?B?cEVQc21yYWFxRzZjS0ZhVnFFVUh3WE8rSnRCSW42WEFGNlI3c2Ivby9kcDZ5?=
 =?utf-8?B?d3RVVVFiS1h1NjVYMzcyOUhZdTJaMVFhTTNmbXdlVFNWNGRTUzZHYXI5S3FL?=
 =?utf-8?B?YTVOVDlWd3UwZkNGTFRYcFhNbGhMb25semhGWlFyend6cWgrWXJvSVB5Z0U4?=
 =?utf-8?B?bDRRWWppNEo2M3V0TmV4TlVpSzdsUk5DbGRVbThEdUdsTkFtcGRNL2JzckpI?=
 =?utf-8?B?VmFjQk1NdHVBSGxEaXdhRWcxVnNnM3llRFByelJzdUdCZVNCSWVVeTZBbHRI?=
 =?utf-8?B?Q3UyT0hmM3FrMnZ3MlBFZlZzZll1aTk5R2dtZmRXY1Y3YVdjYTdjWmF0UWpo?=
 =?utf-8?B?S1pSQS9wQkVmNEZjVXkzY1ZTaXBLdDcrT05yVnBiZ0VHWFFvVHNTTnpZUndB?=
 =?utf-8?B?YlZteUM0Zk9OK3VXeW1RVjQyS3BZTjd6TFQ5OUl1azhpTXNBMXBsZERsQlBV?=
 =?utf-8?B?QitvR3JnSkQ1czRCQjhRME5RREo4QkR3NzlSalA3VkhjRWRGOWtqaW5aUlZx?=
 =?utf-8?B?NGxRS0FwV3FsK0lDVVJXSXVnYVVhTDJxNEk2ZHU2NVhXbUxtT1pnd0k4MEhW?=
 =?utf-8?B?TXZZSS9iOTl6L0dIN2c5OUtLaW93SURQdnFidmVFWDE2bU9tNkthZldTeUlG?=
 =?utf-8?B?S0lreWdPeGdUNTZ4b2dSOU1VYjlRUVY1dkVDV1JxZ3pBMmVsbjdrWjVlazJj?=
 =?utf-8?B?K3ZuWndGTEp4cTNFME82RGRBOGRvMjdtVHJxYkEzNFpqUG5GQ1ZTVk01SEJW?=
 =?utf-8?B?WEdmVzMvV1ZGdmZOVVd0R1hZS2E1elpoWGJsNHJlOWc5Tjh4M3h1TGZoU282?=
 =?utf-8?B?QmxKMENRSU10cjMzaGxUcUxiTlNQUTRhbHpZN2lVaXJFMlZidUg1ZVdUdE9x?=
 =?utf-8?B?UEhldWZ6eWtNeld4dEpoQ1dzK0hUSjRQM2ROWmNrNmRVaWxKblZkcno4aTB5?=
 =?utf-8?B?ZWE2aGYxTng5eVN5NExCVE5hRmNTbTZRcnVtZ2oyODZodFhmU0hUM3BHTUtj?=
 =?utf-8?B?T1RqazRwcVEzSzJweUxrRXpUQkpEc3NqdXNCSXpBdU53dGYxNEcxbFRxNWF3?=
 =?utf-8?B?NzdoZnhYdkRhN2Ztc3hDMVdBbUY2Zk9rV2Y2blp0KzljaGV4c041T2NIcWxD?=
 =?utf-8?B?b0x1aTlBQTZGakJQb0tKV2E2ekR5aWlJS094czM3emowVityUTc4alFJbkpM?=
 =?utf-8?B?VGZHcUxmcVdYQ3NxcVNKZDhsckJwM1VkTlZZaFI4Kzlndms3cUFRcHowNEI3?=
 =?utf-8?B?azEvSzI2Zjg4VHZPNnllYkQrMzdqOWkrYUorczhYUEFPZUFTN0NqKzJMVnVV?=
 =?utf-8?B?djR2OFJIU0Zwck4ybGQybW5kOW0xamlTQWVRTjNhK2NIU3FDY2g0TXhmdlZp?=
 =?utf-8?B?WXY3WUhpOFdDMFdjVDNCWnBTZ2V2VWZPTGVKc2R4cFp2YlJIYkI0WlVYNG9T?=
 =?utf-8?B?TXYrU2xkaG1XNmhPdlZDM1htU3BvUm94MllzdGk2dGpzUlo0RmJUZzF4eWpP?=
 =?utf-8?B?U1RMbGpicVdlZmtUYnFXLzBNYkZjSkJQaDJ3ZEFRZWp3TUttSVdDeTYzZ0JX?=
 =?utf-8?B?NTR1UVJVU3lsTVZJUTJFNXpPSE5xcEJjcmRWZ1V6RnNOU2JPM2F6bFNVSXhI?=
 =?utf-8?B?Q2c9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b0671c2-9560-4742-7b85-08db2a02d97f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 11:53:13.3472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UUWKzCDsp1X/y36r9wpVJ+ZXvEFtLPRUVuy8EcbU5r77C8rWVkFW7dPWGwlcQZv3Sju3K485Q0W6sS3s2fIWeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7164
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 20/03/2023 14:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.279 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.279-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra.

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Due to infrastructure issues, no test report available, but all tests 
are passing.

Jon

-- 
nvpublic

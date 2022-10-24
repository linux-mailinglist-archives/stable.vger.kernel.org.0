Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF1360B511
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiJXSMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiJXSML (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:12:11 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4059E26DB37;
        Mon, 24 Oct 2022 09:54:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dj9HxWvqDNWGU11cykeYcFqB3fh9MUvlrApEszaDuCUApT5LeGFIB+mOvBZnavPpBdSK5H14+DWBQhRsIEQ61lq4j+NRriG8uGYj9Bd0lb69RZ/OMWGgt6nJ1uIuaJsNSdiCp7oCFkaw430N1bM0VKUbElWWPDSiZF8cJJAHRH1PKdLcddbJi8ZN80G7JH62+ayzzntawVtSmjb5rG6U+zIhs55av+QatNWYsgZNVpMxdN5M1zV+G4xe+MJpMkCEADAuYTDWjjHk4rb+lpSQUwo3fWahxEeTuTrGGbhOj6TLYNuqRfDIK5VTkA6lj6A2jK88jAb1PubF/K7e2JhOwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mEQir750RaiNGJtQhoYaEA4jLAr9s/8Kk0QzZOygJOs=;
 b=Hb89nC0+QCcchVjmXUtmY45bMvttHAOJ7hpEgKvstX2bwj6I1xuHYzDSX0mI1teOmiLrExgVAgPtHZsyvk1HRSqolYZvf/cr6lf6SZi2DgBq6sPrOTIXshJdbEYExEjypAdonnDxdqGtqaEaO90HWC0vZ+VgYGdA0DTwtQlyvhhQjmJ6hZLYygj2pEpdSruFUCzjjjTjd33O5UFitNyIjBRsVaVnZeVOsi6yEhWAX8DeWcFjbEm225LEIutAnnUPTAfi6QKUF/aSvLxEOdawHNeqKjUDAkLxrwydOew7H4A6lzc0vwkC/6Yy/Uoj0PIw99uzKPdZL7vNKD7Waz0Qwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mEQir750RaiNGJtQhoYaEA4jLAr9s/8Kk0QzZOygJOs=;
 b=HQpKzw/w69fs/BC+v5aMp0ZQimkjkiVf5ScbIje0IapARDtL+4Ce8OZII8WA5t84iz6HNwSZDkxBdkxvyIzFBk3cXnFMktn3DtxT0RLiO0HJrU/S09SFk12ienoJdinj4Vls/DjN0liLcADKtLNqE9ZNl0m8y1G7r/8BEnC75u5fJhjLXQsPpBTkVbUvAIwZHzlNTtPpuwAIf37790AB4PW6t9kQ9Hv/c+zD1fp0oVl2DHoMDycze55IwZC6VhGdBzUX1BPcnYMQ0XP+YPU5rvZTjoXAVIN+oAckFwfXgNhpYH/6IXNg7YaEddRFXB7EDBr0KGRxLglErJM0d2hpKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CH0PR12MB5043.namprd12.prod.outlook.com (2603:10b6:610:e2::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.23; Mon, 24 Oct 2022 16:47:05 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66%6]) with mapi id 15.20.5746.023; Mon, 24 Oct 2022
 16:47:05 +0000
Message-ID: <0d12de6a-d261-a6c6-e495-b0e3ee86bdf6@nvidia.com>
Date:   Mon, 24 Oct 2022 17:46:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.4 000/255] 5.4.220-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20221024113002.471093005@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0628.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::6) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|CH0PR12MB5043:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f92307f-c366-4924-44c7-08dab5df619b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YeC8KRJsHRL2a3hfGRN1UtNviViVb3C4rxftqzJnd4sv27zBTerQd2/KLLfVT/rQx9d/16JNZoiUG//H480CzmcDCtXCjj8PUrb//hPO+dNkXb2GKxWAjbbNlJVriBWQ5nDJEmf3eJSD9OYS2pHGlQ5vqwp7Agl9OgyNZVVx4NKYm710wYMZp+8DyCbOcgd+VTlPMXiUrCeLmm2r7i20qDfhAaMStrPy6dFhSY1h0ouMnBRldTfrUuxHt47TgPJwTKB5KUtZR2hIksNf4MoK+DGO6Bpc7cgdCYy6GeYmkSxJrp1Z7qbUZzriOOeR0UrqqWCSpWsupqMbmh5Y09s4rxNieyAlw8oYzHtRdyjha0WpqaV7DdOgeSQBH0KIi/Zw1dxjMB47MeyNKC4xpwBzGH62EKsAWCq4Jzqaqi44qc/Zkfx9kzpYyzkAy6wuiAbQGLt35TUA2fw6Ldvm0g0rb/Kh8+Hu1X06WWOR1Ytu1G6osTYCKFQleNF6vuj3a3Lsv2d3tfQbOaXyZcrac5g+442+aLAq9XviVMLPuiFj415wJ8Sr5wMAWsUD/zHWO1Lg29vTF8PnBi3Pdz1VZV0Os07HAgfopUioJe6Py+J19LR0DIqLmpilOrNHzNeenKFAkQ+HFXtnvmOH/Qj7gJ0BQiK16J64vWzTkEMnsTQC3YityvrpQovMoQF7OJ179+awRbGQA6D2h7z/kuDydrSkcJcjk0Lni/ohHXvQDK5yHzr6/OBvXeJHcc23H1pFFH7uwFJuzF+44ZDOxkJksrbX5RiGv58ztBfTfuWHsXprn/hMexSFugKcGasmdQSR9gj3kXY2WYu5ONA4hlNqiNkEMV16cdgCw1VA7Swb63GD5uQiWiclMS8JhsWZS7Qww4/T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(451199015)(36756003)(186003)(66946007)(66556008)(66476007)(4326008)(8676002)(2906002)(53546011)(41300700001)(31696002)(86362001)(316002)(5660300002)(2616005)(7416002)(6512007)(8936002)(6666004)(6506007)(478600001)(31686004)(6486002)(966005)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2g5ZHVwR1FWWnlaaHFpeStqaVZMWjJWM0ZZRTlNZUh0ZFhTWjFKL2RKY2NK?=
 =?utf-8?B?WWRQaW1ObWY2cnN6dGg4aytvUXdLd3pKUTFGWFZOSzNCNCt0eWJkWFdKV0l6?=
 =?utf-8?B?R3A0NStmTlBUVVUzdlBDdmFqUnNtakZIaUVJNFZrdzVSQXBIaWtKbXAvdU9W?=
 =?utf-8?B?Smc3NW9Cc1R5WlMzbGRpYkJnUDlYS3NuY01ZZU44THJoUGlQaVpUeTQxbUd1?=
 =?utf-8?B?TEJNU3V1RWlkaFhZWFNSQVhDd2RjdFJxTnZxZC9rc2JmVHpTZDJqVXdOb3dq?=
 =?utf-8?B?cUJ1eXkvaVB1VytMV1BHN2pNSkRJYlhXR05xYWlzaDlaOG1lSGttZmZWa0F6?=
 =?utf-8?B?UVdLRm12MEhNUUQyNFQ2TXR0TzA0bW9meTFVaFl1R0U4bDgrRDRJcmhDUThh?=
 =?utf-8?B?YktmVGxsU2k5cnlCcDZ2QldrQmk3d1Y5VUNZbkd3emNLVU83bEhIckN5RlZS?=
 =?utf-8?B?YVk2VFlwQ3FDWHVDZGJ2QUZmaXQ1OFp5U25aWExHMWZPb1I1SWdFWW5UTDVm?=
 =?utf-8?B?dVMxNjVVamJVRUVYWUNmbnZoVEJ3YUZRYldmOU1nZFpOUnJZOG5wcXFFeGlK?=
 =?utf-8?B?ZHNaWTV6YUV1aHpKRDg4YnlSUHdzd1g1aW5tN09OazNqWUhUMDdNSzhrKzFP?=
 =?utf-8?B?dE5TU1NBVzZwUHFNWVZ5eFZqek9DTlRQaExaL0tsSFFLbFhFS0JNZTRFcHQr?=
 =?utf-8?B?VXdjd2RRTmRNSTVVUndrWTNRKzNiY1dDYmVLY1RjQW45N2J0U1JMd1NBWS9u?=
 =?utf-8?B?Mi9FcWNjZzdtNng3ZUFwQnlYLzdnVmRGRmRrRFZ0WE5Vc2RtMXg3ZW5BbkVu?=
 =?utf-8?B?WHZUMnlTd2E4QnNUWmVYYW9mOERaZVU5RVJUQnZRN3VhQ3FvWDA3WGEzajZs?=
 =?utf-8?B?MkxkZWNESDZNWTdGeGlsRUlxNDRzV3FYYkxsSHhFVGpVYXNOc1U3U2NhN3ly?=
 =?utf-8?B?VXdXcmNReUxGdUhUS1VUcWh3THU1elJHL2M5alY3dityVGFOcTNzeFl0bWVN?=
 =?utf-8?B?dUZIZWh1c1g5OWhBNjZ6VDM2dm1zSjIxRWJMc21kWlo5dVZNYnYwUG1pa080?=
 =?utf-8?B?ZDZrOE5FVXVFUkNKcTJTYjdlVjJ2aVJ5OURMK1ZsZzdIclc4TmZCOFI4czdw?=
 =?utf-8?B?QjVYV0tuYkVBWU1HbmpheE5VWUdFYkRWTmJYQ0VLUjJ5US9CYzBZQTJyamh1?=
 =?utf-8?B?dWFSam14eUpvYXRMN1llV3dlUytITWxoUkloa1YzWitnSW85VzZESFNPZFpM?=
 =?utf-8?B?Z1NwdWllMERGckRTVVVDcEdIQ2hGaGs2VWRCTlhkeFBYMmZjTFQxWWdVaVpZ?=
 =?utf-8?B?aHE5YUpRUU9yc2ozbEpYdVZDZG16TmxnZ28rWWhMazNTVkdaOGtwbEhQREY3?=
 =?utf-8?B?M1ZKVDE1R1Y5ZVJkNGdRWmYzOE5EMGIrZElsR1ZkOVZwRGJwZDI4ZUJCZEN6?=
 =?utf-8?B?aFNYQWEyNkZPR3J4eGJ0Q0pTSEN4MHo3QnZDbUloNTc2LzRQanB2TkE1Z0Z5?=
 =?utf-8?B?QncrVThYNjVvOUJldGVvRkdhWkhwOXVNdmVtenlxWWZwNFpFc2JtM1dwUUxa?=
 =?utf-8?B?L21oTFlGV2pEOWRXNUZQTStneGFUTGNINkQxeUdBT1RkQk1jdHcwYWYxa0xx?=
 =?utf-8?B?VWVrTlpLWll4YzBuRkRSZFVwaitiWloxVG5KdU1OVG96V2dSVDVKOG1JeHB6?=
 =?utf-8?B?RE1UU1ZmZlJRVXQva3BNNG04d3FMUFRMWWg4QkpBMGI3aWp2eGcxdUR0bXl0?=
 =?utf-8?B?aWVHSEhIM2F1QnhqL2tQTkdxWXZReE1JT3VUdVpjdytMVW11Q2dzdDlKbWoz?=
 =?utf-8?B?VUErdGFHQ29vWUpsRXdPc2JWWWN2aWU1UFNTZmwwMHN6Z1dNcUw3MGRPNlEw?=
 =?utf-8?B?UkkxR3g2blMrR1VYZ3pCZytFRGpnK0tCZWRPK3ozSnZDWS8zL21EaFJvbWF6?=
 =?utf-8?B?ZGpBcTNJalYrUmcyQ3VROWJlck1ORlF5VHZBL3NGSlhrd3dwOE0wQVpIRmhB?=
 =?utf-8?B?dUI4cXpXUHlPYlRaT1RWc2ZRRmJudkpiTjZUVnl4NjROWEVxS1RmU0ZpdTRm?=
 =?utf-8?B?VmRYQjFXc3dnQXJYVW5EWkhHWmlCVGhLVGprdFN6UGVwY2VBTG5FNkNaazJr?=
 =?utf-8?B?MWhTd1ZGbzdZb0wzT2NMbWN3eDVPS2NMMGd4eEk1UnZISmFtRVBsL1ZBSFhV?=
 =?utf-8?B?clZLWWJlWFdnVUpkVlY4UzJMcjNkUnBzS01PKzBJWElaR0lKKzJwQUZmU0Rs?=
 =?utf-8?B?OFBDNFJuNVBEZ2crRVZ0OTFveWR3PT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f92307f-c366-4924-44c7-08dab5df619b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 16:47:04.9383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i6KxKD7J0jeMuDnoxjMICJt3iea69/q3GYOB+Txulk84SDlBhrMOiOtkGtk0qf7PmIULltuupWqsNfj1/2nWlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5043
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 24/10/2022 12:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.220 release.
> There are 255 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.220-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
     10 builds:	10 pass, 0 fail
     26 boots:	26 pass, 0 fail
     59 tests:	59 pass, 0 fail

Linux version:	5.4.220-rc1-gf49f12b65484
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra20-ventana,
                 tegra210-p2371-2180, tegra210-p3450-0000,
                 tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
-- 
nvpublic

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D525596B9
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 11:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiFXJcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 05:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiFXJcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 05:32:35 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474C355360;
        Fri, 24 Jun 2022 02:32:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFQQxJvoBmdOl22OOuWDV347ZBlhd45uQrzfYExrsgMuwB9Z4Lf3pSseBRdVveFgnPLmkah2t2yPi1Vrrvgf4VhiF5OrPKIBsFWW0rMm8HU52cY0roFyopFkJBPVmKQtF7+xWpcMvEcN2QeIFk2kNa+LELng44eU8NTqMf+arxH4+HxmGXjUcUm95eMD+30wtn0qILeDOb8h5Hp4h8G5G/qD4gJBT/D+1XsMLvsglZeWnyQhQ8qekndLxLART3u3mN37GSpSBX4pACbu77zKgRFaMhHQFkVH1eks3GM94XauwHtxaaXsNOKSNNkR0eMs51O9cDi793VwHVzR2eT61A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=se0OE++HNDqt43gzcl4+qJD3rGEgrQZoTxWjdwMoB/I=;
 b=YL3JvDXf/RU/9NKN3KZJAMqQ0KKEfwbN2qcd3t5xSYLXcey70N2XUsJyXjdTh9ObbD42Y0VNDk/Pkp65DG9e3lqiFu0dCp61Z9XG6yol9/zsFlUHanaOl3A4IVX/vdMS1EYD7CtQ+P9pVSGsw5KidtImS2WSORguTgPLemahWpG7+frf+OqOKHVBVo2PyCLTg4IwSFEyMu0FNXio5Dozk8gd7xml4v1e4sKnel4AejGVHbKIoaLbmoC969NVL4uBm8XYOW/5Kty/ZoI0AJoPQIzmghIerMPcr9nZ6Unv6fn5s+xENZat/Dx75ZsWYEf8BRu/u3qEfr7jB0Woa80oUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=se0OE++HNDqt43gzcl4+qJD3rGEgrQZoTxWjdwMoB/I=;
 b=RFBfmnY1iJRhTZjtFTEpRotEQ9pcHoeuezwmW6xjAalU0VIQrFLCmUoPk9cm1Pe1Vye4aUTUmg8yubsUdoUUyt0qJ0cX8MUmtnjKvdqVRKWw6wqkBk0gqNS6guyqSBGTtzOVabgP5BtFJT38aaECqBohUL6u/QiO8Ka2ci+YKiReO1ws92CjeU1i/RgCJaiKIxxyOabi/owMGng+dKq7s5QHZntAtE9/JtOIs2MoVeQTy8UAt1hr/ePrJXL3VwljppqjOyx2MRUyiTEdMZ5XASA+VKA+ZReK3X9sh0YP9VqeUMlOVG+kopI1y5zW4nm0D9D7CLzJHiTtTtvUDXxQAw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 BN9PR12MB5212.namprd12.prod.outlook.com (2603:10b6:408:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Fri, 24 Jun
 2022 09:32:33 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::190c:967c:2b86:24a8]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::190c:967c:2b86:24a8%4]) with mapi id 15.20.5373.016; Fri, 24 Jun 2022
 09:32:33 +0000
Message-ID: <847bbe49-5ca6-cb93-6fe0-408da52c0899@nvidia.com>
Date:   Fri, 24 Jun 2022 10:32:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.15 0/9] 5.15.50-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220623164322.288837280@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220623164322.288837280@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0085.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::9) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8701bb0b-be03-406e-a329-08da55c4771b
X-MS-TrafficTypeDiagnostic: BN9PR12MB5212:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xXVg2x01b7gUV5CHV67iw4h1SomvF8VL6xb6JbE1dSSa9R0i5Wsx6h+BQ8Q7m83/BynCfhZcEegaSH3RCo+E8GiK5Ba7DYkzRVeZBbUIELTxTCMaHTgx/nfrElIitAiLw57rYFSqUCmjaRc9mZPNIQBcG34V+BIL757W6RtgJuXIB97KeOTLc/H+g6LmkLeeKRIbmcF3bybGqy7kPIiziUy90kpxqdysq1ENAqjewceeL6IBfxLL/OcaC9DeOONJyaQToLKwPthBLC7gzRLPWYOQC/BTPNB5QjRV2uzstGFIubfte/tRjwqMQu/Geav0ZtSNrSSXEvb9TNaPuk5gpZCYyUt/K9ncH8oPa5F5S/tNuHy4lMOPtnEv3Q9G1D4LaotHuDFcO9hkpVWtAxq0Ztl7oECraQgOdA5a8qVeslj17CumFRHEG5kXe9uIDteSmY94Urr7goq6sgn9D75M+3pifoox69jIq2/tYR78o8/njfvbNSmzDvdx8w0XvCPMit84CPlK8iZ3ZXZS9hoDtgDi+Ep6vBED9Wcyxot6e74PAAa/pubjFbFT4OFYr3/rr7oOFAWuzRiDZv6YbmWh9jaiht+B6tNi1Z2x4PqDf1yVTZkvtPmzu9AUMoWRcd1P24142YtJSM1JgTeTu9PE2xTmYjxl5nSTlh3h5gwxopimQQEG7X/iq6/e275zS5ClVTAiscyzPAt9VLqLCPh4JpbfXAaS2zjppcJ39j/18HO2kGNJg1i2btF0fgyU/BAtBRMyLExRdvMU0EoDMaoaDnJobWp+fBWmaYMPoqUKj2rVc/iTEXFWU9EoQWu4Lgq+35T4a9YoRPEzrOsx4DKdITqy4WYVCFjz3m/r+k5r+KkdhmUWSkpyRv3qsj/W+UMOCPnYzxengVpNlr7PjCM8jJpVIdv3Bqwl13Kkgn++Cvw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(2616005)(83380400001)(38100700002)(31686004)(31696002)(186003)(7416002)(5660300002)(2906002)(8936002)(55236004)(53546011)(6506007)(66946007)(41300700001)(478600001)(66556008)(6512007)(316002)(4326008)(6486002)(26005)(966005)(66476007)(8676002)(6666004)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUxaMUJaenlxenN4MExBdDVHR3VsVXRvMCtIQmpndFhwRmpWTGYzc2dPZnZr?=
 =?utf-8?B?NXMxZGJmSm84N3dSNmVJeDJ1SGFnNjYzaVFrb1hQVlNLeng4MEFFU3RpbENh?=
 =?utf-8?B?TmxDRzczTGdBL3VMS05hNXNCYkFuQ3BRRzN5N2V6dWxaN21ja3dsQU8xYmxx?=
 =?utf-8?B?bGxIT0huZTNSTnd0bXZmS0FxVXJTeThLcldQeGlEdEI4WEdXeVB0T1ZPdGd0?=
 =?utf-8?B?M0IxdFFMSElPVy9kQzByaUlNUlRZaGNqTjdhZFZwT1lIWEJZelp3dFFONm9M?=
 =?utf-8?B?b2QrNm4yT1IwNW8rdDE1TXRDd1ZJbEZ4Qkg3Q0VCNkVtVWV0WkFXamtJY2Nw?=
 =?utf-8?B?OHM5MEJGQmNwWE9UQzdvQjJTa05LQzJ2MnhhbEY5dnU3QnVHb1MyT0ZCMDdM?=
 =?utf-8?B?d0cwQkkzbkE0WW4xWlJBZFhHenF3K0xpdVZQZ3FQOHhFK296YVN2UTlFWTAy?=
 =?utf-8?B?VFRNTTNLTHptTVpwOGsvVFJuMWlzYWtFSlcvTm8wRDQ4bnRFQTNsOXZEV21F?=
 =?utf-8?B?bXMzM05jL2V2NFAwQjRIWTV4MU9PRWh1ZVN3NmU4Ukx4VGZOQzIxU2VlT05H?=
 =?utf-8?B?dGFnMExwTHVJcUpBRkpjOUZKM05zcjB5VFVkRzVEOEkrZEkxTDNTU3VnTU9a?=
 =?utf-8?B?TTVhNVhmYVVxbWV4eFRLWTFjTmxNSnFnWTBsRjdBQnVCU2dWS0hjK0xBcXVB?=
 =?utf-8?B?KzNOY0NVdS9IWVJoMFRiQklrcTNic2xLZWtVOFdadWd4YWxjbmFiVG5aUVk4?=
 =?utf-8?B?WFczYjdDT0sxWU1YeW8xSTJvTXJCSHBJc3hodlJwQzZiVERiOEIxczFXUFVv?=
 =?utf-8?B?cDJEUmJXWjA0T3VhNVpwODFhS2hVLzVRVFI4b2NkY1ZPa1h3VXBuNExUR0x5?=
 =?utf-8?B?cFJIUkQydGxoMWpCeEJBaWdSR0tUdXVsUVM1ak5BZHdTdFVmaTRRcjRibjhX?=
 =?utf-8?B?bWQrRWpjOVIxbUlRR0x0REt1RkRiVmRiYmdaL2Z5NkF6VndObnp3MllraXZh?=
 =?utf-8?B?a29jbUttVFdYMTZaa0VscjB0ZHZQQXVJQ1FFVkhRY2FDc2dtKy8rZDhrQXli?=
 =?utf-8?B?ZlBHbVhreXN1Z1BCMjBVN3NDb2F1ZzBZamd0eVBJYXVMcGV5eDBEM1EvRERK?=
 =?utf-8?B?bExNZGlnTTRMZE5YdUxQMW14L2tZNlpSTzFTWGV1MnNrNkcvdzc0TEszdHdB?=
 =?utf-8?B?L2tSOWFPNlFVL3pqQ05OOFBIdmdCdDZUSEEvQ2xTeDR0dzlQSGhSRWpMT2JD?=
 =?utf-8?B?ZnluRGVrRnBlL1liREJFNlhNWkdtMkY4S3kzNnRUY3RNVnFOWHNDMEJ1WmZP?=
 =?utf-8?B?ZDFYT0IzbWpoSVhUeVBBUkFqdkx4ZHNPYVQ4eER2blkrYTRBUkNqbHVwNXAr?=
 =?utf-8?B?QjNMc29wTEtRS1hpUlg3ei90S3U4TWh1ZDdOMFRVd1FBaG1BY3dNdStEUkVa?=
 =?utf-8?B?YW9BTVpadEVOYVZEMG1FNXJMT0czMzEvZU1SNlZKMlBUdWhaRFZHRklvTG8z?=
 =?utf-8?B?alhsQ0tPNHNyQmJQWEduOEYvaXNwbW5vaVVDVGdYMDVKc0JHcEVUTGs4Y0ww?=
 =?utf-8?B?ZXUwRSs0ZEh4Z29KWmQwYkRPTTM2S0RZd2ZnSVBnU09VM1hZa3UzSWRLSHh4?=
 =?utf-8?B?ejVzS2dWN0JBUjkwMm9yY3hqVE5Hd1FUNHo0ejVnRnVVZm1DODVydWxEOFVV?=
 =?utf-8?B?TnUzdU5OU0cxekxyZExYdlA3K2FaU3c4ZFo1U3VtLy9ZVzZ6RUFTb09HbEh4?=
 =?utf-8?B?WVJIQVBRYlBFeHBPUzZWNEhlRFl3dVdRMFJtb01naGZzZ2NqK003a1hvNXBP?=
 =?utf-8?B?bUFPcjc1TzdpV01WQlY3VGd4cXMyb3p0N05RYnA5SXRqQ05PVzUrK3Rxc25m?=
 =?utf-8?B?Vmdzam53aHBBcVdoS1JCMnFDSkYrZmFQYytnMWtYWXZLWURqUzdZVnF2MEE0?=
 =?utf-8?B?K0ltV1NsN1NnLzJkMlZUemF0ckxPenNjRmN0d1c2TkV6clVseThoREpDbEV2?=
 =?utf-8?B?TWIrTkNLYUIxNGZ3cms3Q1ZPMnJvV3FWWWUxWk1JMks2WEdYWHN6WjJ0aHhR?=
 =?utf-8?B?VThuYWFSSnpIZFR2NjBiMEk0ckxRU2RITCtlZHB1bG9YQ29VSVRTUmJXdlVV?=
 =?utf-8?B?cVVkdjBaT3BrNmYyY1EzUlRjYW40cVpubDExS21YZ0NrQUViOWVkdk1VNEJ2?=
 =?utf-8?B?L3c9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8701bb0b-be03-406e-a329-08da55c4771b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 09:32:32.9713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lymh7EK36mPalLULAU2yyAh0KH11v8mY6CPQaijsVB+/Kucxj+MUNxTnzx5HHYr08r5dTPJ0Fz9TtBYSQhNh6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5212
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


On 23/06/2022 17:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.50 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.50-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No new regressions for Tegra ...

Test results for stable-v5.15:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     114 tests:	113 pass, 1 fail

Linux version:	5.15.50-rc1-gadd0aacf730e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
-- 
nvpublic

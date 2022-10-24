Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0631960B5AA
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiJXSgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiJXSgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:36:09 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20627.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::627])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4A3AC4BA;
        Mon, 24 Oct 2022 10:17:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXnu7HLMPFIJxI/hi1Mlq3j+h3YnZBXhYXx3nEvcbQIRgDxDlrIWHOP1n7lsjUcotTASSJz1H3PeQ3+s7Wa3wACyIorkqKa0lqNabiQNPbNm6M32HpaCrIQRqDovpbZE9eceGC0Fkdqt8QIC3D8+4A1Vdj6q7bmenPuJzMNU/1KZT9XXp25NEJHlWNhdqYP3rg4YL6wD1k7xtNxd+sFm5vyQYRLhwd94GZMqNCltDLKLF4nGZZThpoo9XM8rgeumNvbS5fzpwx77Pl1Y5UAek3gnoozGkx1qYExCTbaJB8tKu7NTgJlX2oFOtrpWLDtvnzu1qGYJhSX36sEq4Osedw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wZMyOY8Nw00vuH5XTqbuhoi7LZ4IihgLdn2AVXfQUQw=;
 b=CXjtUjnw2+KjpEHmsfssCnxsuQCKf5gKihl2B3tMQwQlQ/vjK0tYswZeZ4VswHpirtT7WZ4BnbCWdhXQy8Qes1Gc09KSspCekER6Kjq5qYXJwC/VO9QY1gDJy9ZiDtW9uCoNa0EO4YABLW7FpxtcmGEq7TvHdYYqtOHRON2p8kBGn9YImiIUANTtFC9Nq3jNVA60o+XlsSFeaVVb+NPycD/b52YL2uwLnnxSQXPO7ETuqiRxBDo6IZf+2rVRoZ95u0mDFJmfREcp02RIHRCfaUaTqn22SrMr+FIOleKUSvx8Wl4vMUKvgI30rtMatqTHZA44pMiiRQ2RwsaG6MiEPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZMyOY8Nw00vuH5XTqbuhoi7LZ4IihgLdn2AVXfQUQw=;
 b=KYMVqJI0TZ4jTJiHBOSa3bTgovKoz1bsBBwPYM0xR5rRvR31LhK6V3awi8O9Tcg/bJyKsiFYBFCwEg1Jv0612uX2CPBgm1tnzOvFS0aALT5pR46YtqyE9B4LX9rcB2dHDgWkTCsI0Fne2HKfs5WGOYBm0TIBOjjw2x/DAB/+NSPzsHx+2AI/CXdZnXjMiVPOaa96+EAkQEgkBQkvgo23fFosNymhb8lFi62FtJ/1xbsKnyxIUXRjxWGdjMQnsKYwC/7jlRCCBOczQTis17fB2IFEjDYYuZrvps74sKCdrq2GiabR/lgAUQ8lZJif7E0iDjPnm8Y8Wj6ccDJKLJG/aA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CH0PR12MB5043.namprd12.prod.outlook.com (2603:10b6:610:e2::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.23; Mon, 24 Oct 2022 16:47:53 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66%6]) with mapi id 15.20.5746.023; Mon, 24 Oct 2022
 16:47:53 +0000
Message-ID: <ce803c28-7bdf-15d5-ffbe-0a2ea6f6c5d5@nvidia.com>
Date:   Mon, 24 Oct 2022 17:47:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 000/390] 5.10.150-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20221024113022.510008560@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0636.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::14) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|CH0PR12MB5043:EE_
X-MS-Office365-Filtering-Correlation-Id: a42a291c-cd8f-4f24-f233-08dab5df7e4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cvhg7qlCzXHH5l+gg891l/977eFR3hnEadMcMZ1mQ5QQavzIef/xyixXhzH3k8mk0zWGbtYZFNhM5+ZNpMDW8fqKGSjmX255SXewQfwGqG0rC/cZlQQsmBpolBMSMFOmy7JXAZ3Qj1bDSaGo+zGg5QK/yUeDDu7qxJCx7XjHz/VDUGqKbto2+03NvzPU/S0PanvMYWMGTFTfO6GKOLXCuY35j5/sZO/824reDEyRgtVDbtLDx0gzdiIENHJ3BAJM66H/509bWPh0Odex9R34yniuGAS3+c9DliiJeIVU3LTQ45ojqyKSSKGfJYFd32/GG4DrC9o0EOAcUNb/NylKNsq3c/g2nzngvSkpt37tInMThWLqWT8Z9we7RoSFIriC8AwoVWLOsvE7W4XvOfOZ6FvCcX605AhD0Km2tPJrcxBGBmVKvkkFyZMZSrwwxUBH+K5Hsze4CzO4GTC3ujr7NX3MJxZONhLMNdfrbT+llsoVzAQB6jrnD7S5q+A+ax6OX6cECoUHvr+n9PPPBh+hBH8VyKQRhoYHPKkIkiHRenGc8DL84svdJ7E8iuDqVscOsxSneb5akuPxwteP6WrBZjSrZXy52z6n2Zuz5KNdVgl2ghmTjQqT97MmQIuVmhqJD7lrvyVNXFAzVuL9UIiM3mCWTGWE2SvH3F8DPCRDobXyohoUIbM8pgpKxUtPfvqbgicFBq47gG5w4FGNeo4otN+sdbcnDa1oGfltJY4f42EDAN6iPRayOSn5+FviSkzUWpX27zB2QMR4J4S1trQdCDaB02wSK4sg5V4WJYcBQkTM0DIdyoiZ1DIVZ+xF60aYrPFm7WyH62NfCzBhps7bQW9E8N23zLCSdDjKtHHBotV7bNQ2S/5drPefEH8y4pIK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(451199015)(36756003)(186003)(66946007)(66556008)(66476007)(4326008)(8676002)(2906002)(53546011)(41300700001)(31696002)(86362001)(316002)(5660300002)(2616005)(7416002)(6512007)(8936002)(6666004)(6506007)(478600001)(31686004)(6486002)(966005)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REFrZzdCWldOOHhsRFZHMVVmTnJ4V09pclBhNEFkRmVyL2xZSXZ6R2Z6YTdk?=
 =?utf-8?B?Y1ZyZU1aSzFaNFcyekZkT0ZROFhSUjRqc2VvMXREOTB6QkpKWHUzZlZZOW05?=
 =?utf-8?B?RjJQU2RHR0xka0VrOGdoRU1ZcEk5bHZVOGtBd2o2L0hSbDNKMERiTEZnQ0Jz?=
 =?utf-8?B?RkZWMGwyVUx6dXJmZU5icDdoTFpvbWN0KzFVNzR5bE1LMndJN3l5T0w0dVVR?=
 =?utf-8?B?UktCenVaalZKSkhPT3BMZHB1ZjdONGIvZlRBQnFYNVR4c0RFZFplMXY5NEZU?=
 =?utf-8?B?L3MrT3QyWGI0dkJRT0xCZHlrL2NmdTY4eUE5eGlQVDJvVldmSE9saFZFdmF2?=
 =?utf-8?B?d0NtdzM5elJQNUJ4bDVEOW1SZmFqVmJTKzJTT2syT01GbVRrTXg1eEJZRUhU?=
 =?utf-8?B?c1lwODRkdEN5S2QyM3BSN0w3UzlmcldIUktUakkzUWhCQStTSTRNbXA2RWEy?=
 =?utf-8?B?RzBGTTQxYmdvR1R5SGdtdWRCekV4dGZnbVMzL08rOURXTm1aanpiT1RzclpS?=
 =?utf-8?B?MXdjbXZqY2M3amMzS0xNd2dSUlB4c2I2Y3d6Z3piNUNTT2YzY2d2MTFESFVw?=
 =?utf-8?B?ZXpvMDlkb29TS0R1ajBYd2U4MTFQNHhSKysvNzNndmJWNVErU3orZUo5OFJE?=
 =?utf-8?B?VlAyWkJIeHRScWtVL0puR2taZHZoKzdTSWVQQlNuK1ZudytjMGVpUDl5dTVV?=
 =?utf-8?B?enVpMmJmY04wWXJQMFJyQ1paanBGbG8wRzRVdDZxblF3TVBpMUNPRGY0UGFj?=
 =?utf-8?B?WU5uWlFRcXNaUk1GUlNqYitmbE53N003cVJpWE42OUJ6VTliS3FCOFI3ait6?=
 =?utf-8?B?a0t1S2lWS3BuclF6VzJTaUNyajNxT2t4T2Jyc29NVm9zU1VHT2JJTlUyQjdJ?=
 =?utf-8?B?dmR3NHFCTGVyQ3FXbUZVaURWaTNldy91c3VtWkY4RVJCYjdGa1hVNGNKOThj?=
 =?utf-8?B?eFhXa3lqVWFPTUZjNjdVQjJvV0R6NitGV0ZIamx4NitVK3lpRzZ1SHYyRjBF?=
 =?utf-8?B?blRZaXozYzlRdjJncWJ3REZLOERPYVZocTU1dHRoMlRndDFWakJKRElBZ202?=
 =?utf-8?B?SmUxT3ZkUTUwdHRIdXhjbmRNQXNtODdmR0tpQU1vdHZaVVM5TnFWT0NxUWlv?=
 =?utf-8?B?NFlCL0FrcVg3K1J3VXZvSFhHZXdvVi9xbzZXcG4zS3JOcTN1Um5jODVyMjRo?=
 =?utf-8?B?cnpnVGt4RHZaSG0yTlAyUklVZCtMT0ZsZmdGajZSOG9GNWVOYU1URHRaSC9T?=
 =?utf-8?B?cEFQQTV3ckswN1VkNXU2TEpJTWRjaG01dFUxdzQzTU5nOUlPdlJEYmdxaCtq?=
 =?utf-8?B?RnduQ1F4UUZPWWdDMlU3Q09rdkdmN3ZFc0owVXB6MXNLRmM3Zkx4NDlUTTl6?=
 =?utf-8?B?TS9YZ1IrWnpvTm03bllDNU0yU3A5aG5sOGxaY0RYYktaV2lqbnFFR3FOS3NG?=
 =?utf-8?B?WTZ6MnRDQkg2dEwxbE5aOXV2RFlXbWNnUzl2TXpzMTVVZWpFVTFCZDJQSi9J?=
 =?utf-8?B?YVNQcjFJd2dwSXdCZnV5S01zeFJUWHFTdDlPVW1zOHY5cjFPcWxKVDhoVGRq?=
 =?utf-8?B?UEJyODdLNFp0VldSQ0ZJTXBUdmROcXZyb2h2U0JNaGNKaFBKdkFhVGpMRTEy?=
 =?utf-8?B?YjZxQXAxL1ZLdG01bm5PU2tHdWllOWgveXdBcm93R0ZzYVJXV1JkTEtrWUJl?=
 =?utf-8?B?N1VLME1FbjBEMnpPZFhlSDN6cnQva1lreDlHdU9ISGltR0VTcFIxdlhnc210?=
 =?utf-8?B?L0p0cjBTQlk5Zk1YM3FjbGhjd2NYeFNrclpBd092cStBYkhnK0Y3VXBMNnpF?=
 =?utf-8?B?cFlIWW5oaHltNkFDMDczY08zQjVod3BYNnVyOGFUNDZZVmY5MDlxMjRPdHAx?=
 =?utf-8?B?QmNCU2FtTHJBNmxQL2swZ2srT0YvYTNDdHRZcEFIaUJiRjVZS1lEKzROaVdr?=
 =?utf-8?B?R0xtdFhsekNpaHNSaHFRM3p2RzVvLzJOU21pdzBod1VLcWVRZjM4bld1Sllz?=
 =?utf-8?B?bUUzM0dUOERialpvN2hkMnVaR21nOTlkUnlVcHRyR253czF1YS83cG53K2Jx?=
 =?utf-8?B?TUF2eWdSNWRjZFN6ZVZuZTdMM29icWNCYk05QUF3bElBMnA3bm1uQjR5ZzZn?=
 =?utf-8?B?ZU83TjNIaEg3VERBVjFIbzJ5c0N5REcvSVIyL2lYbWl4bVNWS3cxY2VxQzJN?=
 =?utf-8?B?L2c1Mk9Lb0hOVkp5ZGFQM0FpZXB5UEtVM3hlM1hyZ2pZazI5ZkhJK0wzaTlM?=
 =?utf-8?B?VFkyaXFmWDl1c3dUYS8wbmhlOHFRPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a42a291c-cd8f-4f24-f233-08dab5df7e4a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 16:47:53.1753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NpXESVHAFi9qkg/eFoCvOvAqmjbMuis4UIg5qNKwa3J6JruIS/2G8fSPeL6TlwNl7mzTz6pkaVBcQHElbh0YNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5043
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 24/10/2022 12:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.150 release.
> There are 390 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.150-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests passing for Tegra ...

Test results for stable-v5.10:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     75 tests:	75 pass, 0 fail

Linux version:	5.10.150-rc1-gb4f4370de958
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
-- 
nvpublic

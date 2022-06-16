Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B2F54DE9B
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 12:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359664AbiFPKGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 06:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiFPKGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 06:06:11 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2059.outbound.protection.outlook.com [40.107.95.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2E55D186;
        Thu, 16 Jun 2022 03:06:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2m8eRh+YdIlP1aNnBUzq8jIGV/uwaHIaKesWd1gOFZhEGmwxfazJrdCeaItcqzLBiWg2x/rQ411EVHaMvnVgzf/X3qlJ0ENrNV0HKgZjfg3ZvJLKwu20dK4juBBONHrAwygBsze//QKetISY3LwTYd+vnSn0zReMgWn4uD/0+xyoj96IRZ2tqANsBw4Y50er+RqGHRFfgsYpjpTu7WiYHIVPeKvmCIYJcmVx6hDec0pP07JxQf5g5vzMmkPrKTEt2s4dMFbElur9IsbdKWMR+6HxxJEJgmiFEQNSvAHrTMXSebZ7P1k+RlZOKRRxRiupxcZNSn3auKf0bbnm8WGWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jcovrAdDuuItOCx4IFL1VZ8dEJUSM1rrW7r3X98fnVk=;
 b=a1ScYGVJQMA3LqorjkwRFLbH7M+Oh2cjU2q4cWOM65d86XZXg/+Dlf4LBQM1qFgtxqbUIrlKKnYxQTSbwZo2UDTJiqj8raHm957sBOpBDGcThlKNjiePLmzom3YjdyP+XOdhllc00djHs24C66EeJoDaLu+Xe11KDoAP+sKPsTwl1+dKQXP0VIK+Z8OM2uJnQUdbQuNA7PpKsOLm7REky67eh3Fz092BqSEm8JeOX8Kz8qTvqhorcihRqOXmWOwNPkdHdkOUjKwyKCTn7hEsKoiKCLAhQeacLD62N1V6+erI46nEQpWWOdoWbykI4/GkvNf6Ea2laCp5Nvj6pP2g9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcovrAdDuuItOCx4IFL1VZ8dEJUSM1rrW7r3X98fnVk=;
 b=RV5BsgaA9QyvkwTzUrc4WPVGshGXzD9jNEK4Lg09javDsrBg0l9BmJwn0Ds7IOiTFTINbbTtBYniOARGejVvsgU0eZK9fFHOj4LDdYITj9UCqSoICgo00ofCHNKV7hO4upwr4r3buLVo4c5LOgRKgQn3iPulxJPSMWluziuGIS0mK2JQWCup85C6PbZ5WkTG/snO0+pe2BbMdcILrFL/yT3rXrTAZDqwOl+CF375VwNOO8WkMg2cjx5XXWSqaYHzN4B00JzFhVYFVZRI8h+YYZ8SREQX3OhJ+8r5VOVuiz4DK4p+obq+H4TgV+sYsjvKvF785EDh91yz0MyIwbys+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 MN2PR12MB4159.namprd12.prod.outlook.com (2603:10b6:208:1da::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 16 Jun
 2022 10:06:09 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f%4]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 10:06:09 +0000
Message-ID: <8e65a0f8-5924-a819-06b9-c29658fd9f97@nvidia.com>
Date:   Thu, 16 Jun 2022 11:06:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.18 00/11] 5.18.5-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220614183720.861582392@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220614183720.861582392@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR08CA0037.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::25) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 640ab5e7-66bb-40f8-6762-08da4f7fd58d
X-MS-TrafficTypeDiagnostic: MN2PR12MB4159:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4159D6251654F40A6A4A0157D9AC9@MN2PR12MB4159.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yfTtAdgBhI4lcTZq6IZvj2xxDQ3DHbbwulNS1TVtFqE+UtgFSPsEFI/PC+h3VU6J1DWWblKwZW9sk+9oVwAllrU19ZSmxNG59zN3V1r+wSnrdau6bmLixzL00fFg0q3WtjuHKiflUuuXb3MiejzN1lgym7K8gtWbHHESbhxbl8s+xTjRLDNT5sor+MwQiOpt0Gv/7WACfblZ1BJHw9u8R+ktS3EydViBTaGZVe4WrBCWTkWcAuluMja+f8YwB6HiiNim9+KKAlQoSpST2eXa/AtJHJwQjmEZyooE6e5OTbE3BkI/lLkqzBo+Ga8qFP2ZhZIS9oGgkV4ts2YHIMwAIj8R6Z0sbxvEWQLckgtTdyW2dG2FTCTBiOj8xRfGR9sOVVIK6g6f0/ObizCNLW1+SNKs8bFiweSyLPDLOdBm0q67yDhJhzD3Diq43Hvy6NHyc3Ofo46oRiJymaLfToyRJgdjbVpmx6vdFoPEXUGoZyOVnv1hyW8uip8sTUEoAOM3Csjxaml54KqcMJHB5IYA4wsfMCsIo6KKdXftmEmiCp3saAgzmGtO0QwYlqmdbNwQm0WpCrDqcVWl21u4Pa5/bppg6OZhc4Oie9IuawKrN+OZxzgTAw9fP4LPBwPkpi9IlZj8pOvGwm+dniGI7RVD4xHAHC8VpCx+ZODzaceCm8wNpWBv8G2ioTMkaOqyeoGiDFHJscdKiHC7uKadxrblau1huJ6rMH3uwYkYDOZPLDTMz8MGZc3trykNxTrZdmFexWxT16w77921I3ovorG/7asVwGPBnrAP/Rj1Ub88W8wqTJO8xl8v9UANbxRLbvlMgG/zVRx0NHR3wydUarPTNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(5660300002)(7416002)(2906002)(86362001)(31696002)(38100700002)(6506007)(53546011)(26005)(6512007)(55236004)(186003)(966005)(6666004)(508600001)(2616005)(6486002)(66946007)(66556008)(66476007)(8676002)(4326008)(8936002)(316002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzRqNmJIM1g0SXRpRG5pZFU4dVg2RTRCTitLSjN4YU0vcHZ3dkhSbitCbS92?=
 =?utf-8?B?a0lDY3RHRGxWV2haN2llbW1la2FzR3ZtV2NFa1IwdnJOWjN5eEx0MHdzYlVM?=
 =?utf-8?B?eTllc2pMeGw1SnV6dGlKTU0zUHpob3BLVXJjdUxMNUxHaGgvVEI0anBiYnQr?=
 =?utf-8?B?YWovQlQ3cU8yT1N5bC8wVkk4bjg0SGdEUlhFTnJ1QVpXaExJTVB0cGNTWUNN?=
 =?utf-8?B?eTBWaXpoTFlFSW9IenFOOTRrdWUzcTlRTllUa3JEdVdMVTBTTUNBYnlWMEhL?=
 =?utf-8?B?R25vTzZMT1JjcncvenAwNndhbnVPcjZJTlZqL2lCb0VOU3JSWWdjWW5ibjlL?=
 =?utf-8?B?SjdhcUJ5SUdtbG1tR1gwZEdXY1BzNE5rVGJ2NE5iZnJJNzloMzRBbDBQSXZV?=
 =?utf-8?B?MXE1QWg2M1RuajdTS0dqajhYOEJPeVc2Z1RFWm5wdVJPeXJsQmlqa2JnYWhL?=
 =?utf-8?B?bStwN1RXclZGQkNjUDcxZUFLUnhJbUwzTFYyeXhwVDAyeW5jT1NkdEk0SVRu?=
 =?utf-8?B?dWt1YmtsYnJtMGVWenNhLzgvUnFoeXMyVENJb2ZlTm4yUGJMalRJNGtaeFhC?=
 =?utf-8?B?SkNQeTNqNGJNL1ZMN0NTemtCWUcrb1JidDJQQmt4aTB4VThzVEJHTjdiTnE1?=
 =?utf-8?B?UUNJL1FkdTBiWTU2V3BVeEpENjRjTWllYkJVdWw5Y0ZVMlhjQUtkWEI2eVJ6?=
 =?utf-8?B?UExiSk9KUDBpWVg3bk5yMnZ2dWJSOXhObmJiOXdVUVZlaktwNGF6Und6UXQ1?=
 =?utf-8?B?N0lYaGpETVI5anhHUWxVcXlPc3VkMmdoeGJubVYxbGJXTmR5dkR4RW5UeGlG?=
 =?utf-8?B?M1FjUnA0MlZBVDI1MG9VZE5BMTMrdVBrU2hvSjBFRGZheDlpTjFSOG1kUW9k?=
 =?utf-8?B?Q3dESWZ0YzJpQ3B6cEIveXlBMko3WE1zTXh1dWI1ak40K1A4SzdPUXpvdElZ?=
 =?utf-8?B?YTdyWVE0Wjd6SG1SSzdIR0VlNXVEbytIYVNCSGRRUVFnTVRoR1FzMWMyZlNX?=
 =?utf-8?B?UWFodEdxUnhzcHQ4MUlhdjhWS1pEc1dPdFpuWjU5VnlvLzhNUjlucFlpTFRU?=
 =?utf-8?B?RnN6LzkzKzV3RElCT29QWlJxV1JKRUpTb29tSnFZdnpVYVJEaW1FTk1JMzNr?=
 =?utf-8?B?QWNjZ0lIRGtHZVg4K0tzUUVmUm03VFdWUWw0enhlTUtEYXlkS25UOVZYdVY3?=
 =?utf-8?B?ZURKWUF4aVhVZkdDTmMzRjQ2a25HdURES0RuV21mcUQ2ZS9md3dyaVBzN0FH?=
 =?utf-8?B?TXlZK094SmdxOW9LTEpvUThDclVJejBJKzQxbjdydmhRSGpEdDNSeVVLTlhM?=
 =?utf-8?B?Tm42bmh5OXdOSnFwT2R6Ry9xMHBLSG5BdWV2UWFpVTlRbTFXcnhzaytxWGhV?=
 =?utf-8?B?c2dNT3RoTHVlR0dnTFAwQTJ5YkxSb3V6VURabTR5ZUowUEJYZjR5WUIvYkVq?=
 =?utf-8?B?UTdhaW5HOGJUNnNZV0ZWUk01ZnhPMDhHVUI5L0I2RW41dURUdGJnVkJFTVdt?=
 =?utf-8?B?ZCtRYzRibXl0aDFPeTloaU5VUnM4TmFXK1BISENIL1ptUXNieEQwM2p3cC9I?=
 =?utf-8?B?Tk5xcW1KV01jM2xBOGpzTVpUWVRlc3haZGU2eTVpSFU4UUlkcXBpVnhtY2pN?=
 =?utf-8?B?bWs1RWh1dnpyenFGbElQTm94ODVmdEhVZlgzOUcrVlFGKytJSGpielRTcERR?=
 =?utf-8?B?bzI5WUsvZHVzUG9ZUDZxa1QxcHJUeW1wWEdIMi94bW5HNEhNVWN2bTVBRXY0?=
 =?utf-8?B?MjgyUmhoS0hrVkg0Z1JNTVptOTMvdEhya3J3bklXSmRVMmhQL2l6eE9qV3h1?=
 =?utf-8?B?YnpmbVdjY1lwT1VTUjhYdjNBQXk0WlE1UEhCTk9jK0Y4QVRSMDZ6UlpvREx3?=
 =?utf-8?B?OW9NSWlkeGduOGRwZmEwZU9GYUtxWjNacFBEZWdjelJ6WWVxYSs2UTk0THV4?=
 =?utf-8?B?b3FaTGYySmxLeXZRb3pUbmMyMjFiVDcvUUVuNTMxNS9CQTdrbDdlNzZxY1F4?=
 =?utf-8?B?eU00L3Jua0dwV1NjN2o5NFRqZTNXM1FjY3BIZTgvbjhnZHVRbVFTYmVjeFUw?=
 =?utf-8?B?RzJTK2c3Q3h5UXludGR3bXhiOXA4UkVFdG5UQTZ3d0g4T0lmWTBGLzkzUHpu?=
 =?utf-8?B?TWtNdXZHRDNnMjgxL2xya0ErSENPbnduY2cxUHRWWkIxdjdhRTY5MjF6QXJ2?=
 =?utf-8?B?eGUwck92c1VncURac2htbXJxdFE5cU5xMjRHN1JDRWNsMnVUVGxydDVOLzIz?=
 =?utf-8?B?TytiOGMycm93YWRFQit1enVqa0RuSTgyakw1MzVtblFpVk5CRjJHWVJwaHdS?=
 =?utf-8?B?Z0xOZUJVVUZxb25qSFdvYU5MSDdnSm05cVBNejI4WkwxUzZnUkJDNEFsSks1?=
 =?utf-8?Q?wdx8hRzPz5yuEdMk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 640ab5e7-66bb-40f8-6762-08da4f7fd58d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 10:06:09.1570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yyZ4igAQ5P562Vyz/vSn1bw74JBuInd6ZcONoHTofAYE79KXYPBh8GNKF72b1tLBVNDDelJ4dSTH9QZBZ5irYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4159
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
> This is the start of the stable review cycle for the 5.18.5 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.18:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     130 tests:	130 pass, 0 fail

Linux version:	5.18.5-rc1-g0e32b2c68ea4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
-- 
nvpublic

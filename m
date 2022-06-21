Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30176552F4B
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 12:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiFUJ76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 05:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbiFUJ7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 05:59:43 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2073.outbound.protection.outlook.com [40.107.236.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7D626AF5;
        Tue, 21 Jun 2022 02:59:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZkB3wYKzoj1kf5KnA/FINGKxmZHzXYUjbRabFvPwbi4gQamhdGqNdQgcXCeK1uW3fu1n+895hiFZiuyxU7HVEF5YoEaoU+a2/HyJluAJiPEfGtx8pePccsqol8DqEbmclSgYVLYxVWELE25J1kl47VpfNSH0bEAn1T0xJ+VPlRHMWHiJdZ8X9cvy9cOYp6a3JGwi4nCRq0KTr6flqLdZpK9K4kmZgcYhCQwqy8eQhCiirgQWzKi3dyuzCp70pQKBeBihuCuOZF0YpHn8XtYXNDfrr5olIWQvmhxrdeJB1PbW3XCt5xhP76ytPlv4uSJaMjv7w1Dpd+g2LaHVBSPlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7dASoBrGMRbuX6HWRu/Q+u9XwxTNXSZ4y3cwnlQRfU=;
 b=TpLLBEG+ujmlp78Q1GPEEiJnCZNjuQecdYHrpAv3lqwgjGXIhHgq/wKpWsgLHK/xB21kz2CAHTh5krt9AHVhDEe/NdcPoA2tVTRjgBJBvW4+qkCa77o/B8XeDmPFY8ERmdrgIrAPbumjSri6FbJcXXDbz6KRWoTjFMOoCuX8xbnwfn0/RgZ8VdHYiyTwPrrFU2tA9i0gd1OOGBGeFJ3LlG5+4dVQaPtDHTAWlHgl7iATNNvBkThBZhBWh2sB9psigxhqvSHXQGKDfrmd8ga72WWWY073bhy5YhmLJkTT6+F+bCNk6prnTynrKy1ux1qwtutrjL2Lcu3cHi1hbGns2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f7dASoBrGMRbuX6HWRu/Q+u9XwxTNXSZ4y3cwnlQRfU=;
 b=joYnLROxvjdk7/dDA5Vbzm2BSAphkT8NX7H9QrJ8KMzZWLmqfzPL4t317ehrNtz2SNNfJbeOxhUjMZYvkgOYeiBf3Mojr8G2RiFY+0uWHsqcpH01reEwgLEh8s9XsUAsElFvdjNRL4x7ytQrPCcqVEFwHblkhe4ZlmupbfgfVFmTXsnDGCgW+Hu7gMY2w1UASBCO2mWSz+TbtysHcZkKs2fKuVVtQq736rBNyJL3zTwlS4LlIHIoW9LH9SX7pXLPKT1imMR0qOQMMxDYLXNCY7U+OxUiJNCpHYTwBz5/31OUhxzxt8qnFF69iP3U7oiKMkJZI5qzjL8F3Ti9/o2xbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 PH0PR12MB5450.namprd12.prod.outlook.com (2603:10b6:510:e8::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Tue, 21 Jun 2022 09:59:40 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f%4]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 09:59:40 +0000
Message-ID: <80cad1b5-6527-e177-e778-7d9ca964a2f6@nvidia.com>
Date:   Tue, 21 Jun 2022 10:59:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.15 000/106] 5.15.49-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220620124724.380838401@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0138.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::9) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dab6579a-15f4-4c2f-45d9-08da536cc1a7
X-MS-TrafficTypeDiagnostic: PH0PR12MB5450:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB54505061AC03570CC4CF811DD9B39@PH0PR12MB5450.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6rWhGaiPhF5KgE2HT2OFER8LUpauBjKo8kgD15Fa8u7aHXER0Q6HQcTYvkKHwqURLGh/sO4W64s5E8uD6D8o1ks3o7XsWlOooolBDu9SCZA9vFFLpsKRyjRPzCI5tPysOUB0kxPc4kC7UIfQMwWBhMPouohFpEaDhxzOb8y1ognRkSmJinaCu0XfzL6MUft1fIyYpB3Q7+EYe7b8UgMxSSt83sYANCx3gapS/abEcB5pTXyhZb1itqLa89pcAoQRnEYSPh2hNQMYijs1bAxaN1IVNyRkXwWqZv/qogE5Jq5T2KcCpnDVNEWqBRv/Rv0AobfAj42Y0dfd10LuQ8mDlXy6zVJkxUGbQe8Ccq+oVm81SX+R/rmKC3AzPxUKzqj+UsRt/5njGmWxwmN+jkbqJ0kZzlanm843CD01gPW1WBdxyN18Kgb1hQaojm/5R5VddxQdFQcWoGIn559JDSBOcQHsMzD4P0vdbVQscsEhaNchZKxXe+9dIa04CAJJCCB0gCbrOZLjA+ZHZ36Fd9VikkX7cJ51B364Vov2fiI4YAaIUHRFS/0WC/waMtwbUkOa+tImEpLT9yykMCt6LMu/fLZ4+zOKpP2FmN14arn6B3jYXwB6hVbFSYb38q44U2Jt1AGmACrLfiRP+KJYZEOPHCqor7EAfS2dD1x3CDo7KuesTL1rqW+JE1v47d+JJQcXXcyJCBqv83veXiU3UsqmBPuecCI0a98Qq23KObZ4TSV1GNXb3odBGc2ohdNiBMm0TVmLxbPX4vcAKKx49i9q3Q7/gXKchfGR1Q9IX9qAKt1/itdxg/+c+mQvLxnCBhL+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(2616005)(186003)(83380400001)(66476007)(66946007)(53546011)(8676002)(66556008)(41300700001)(6506007)(31696002)(4326008)(5660300002)(55236004)(86362001)(6666004)(478600001)(7416002)(26005)(6486002)(316002)(966005)(6512007)(31686004)(36756003)(38100700002)(2906002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djlyaFkrZHhEK21OZVVZNUhlTkxzWktnZDJhKzdhdHo3dE5RNHpLQTJGZ1Jv?=
 =?utf-8?B?YlhKVThUdlB1ai81YjU4cHZUTmVXQ3BFMjdld1dBZytEVGJhN3NhbVhQSC9U?=
 =?utf-8?B?VDdqTTVSVXk5UWNRcEJYeGJCWi96dE5KS1lSWkRGc3N2ZGU1TElkdzBtMVZX?=
 =?utf-8?B?Rzc3WGt4aHlRTFBHV01BNk8zTlo0Z3V0K0xqQlBNOFpOaGo5eGl4cWU1Y29h?=
 =?utf-8?B?czdoZjhSb001dStkTlk4RHVBellVdHdsSjEwK1IxVXROQ1cwd1dtZzZkcVFK?=
 =?utf-8?B?bE1SL012YzdEOGprK1lRbzV5elpOUkRHMGZQSnpxSlRpUFhQZVFKazBYZ3l1?=
 =?utf-8?B?bFBEQWVQV1ZFaThyRlRqSmJNbkhjMWVUZEtUOU4yYU91WnVsN05sY3ZaZmhR?=
 =?utf-8?B?OXFXNWFYVEd0TmpPeGVBZjVjY1doUlhSd2VvV1p1WGZSQlFGLzNadGU1M01p?=
 =?utf-8?B?TEtWMXVualpCMm14bmx4UWxxb3JEMXhIR1hIMDdPWjVoZGVZaDRzeEFOckgr?=
 =?utf-8?B?ZG1BMHJYTVNLWkY3ekF6RU95YUFKWURZZnV3Sm9xc3FqNXB5dEtwMnczTlhM?=
 =?utf-8?B?cUVNNXlpV1lXbUMvaU9HRlB4R1JMaTFPUUVIb01DZVo4TkNpYm1hZXB2N3FW?=
 =?utf-8?B?Y0tKdFR6WkFiU1pJaFU1TjhFTWhSVHRtQTdYNTNxZG5XdnRNaWJ2VnhGM2Rw?=
 =?utf-8?B?V3ZmMWVtSWlhcS94ZmJwR1FOOWRpQXBYSU9NSkg3S3ZrV0NhV28xYkUrYkZS?=
 =?utf-8?B?YWtmdWhIOWxmUnVkc3N1WUxXNE9GWjhMaXRtbWgrUERiYXNUK1BmakpFNEdU?=
 =?utf-8?B?eXgydXVxdGUzbUFaU1hQdnMrSHZrNXRpbXRJUmo2bllPRkk4VlpZVXNEMEZw?=
 =?utf-8?B?UStRWXlRVEM5eVdBQXViUUlYa2lwaTFoYXBFT25kTUpkajRaV2l4MjQ5T1JP?=
 =?utf-8?B?c1ZESUZrYU9KOGJzblcyd3NPT1NlYWRyeUdCU2lmc0pZSDBqSEZOTk51VFU4?=
 =?utf-8?B?SXRnUGFzUXRYS0ZaaFB5dGpNcDBLYXY4L3hCaThkNmd1TXlhN3pDajdPTnNa?=
 =?utf-8?B?dFBzKzNweUFLM0Z2NlJqN1NJazBxTmN5cS9KaTRWcTU1Y3VJWU9XYThJcHlG?=
 =?utf-8?B?dncvQ0w1eWE3RHVBdUFpUUpHR2V2WjJQWTdiSmJyR1U1MWpVOXQ5ajd4T2Nz?=
 =?utf-8?B?K2JpaUdtdm9aUVQ2RFIzZCsxWFNvVXZNWXNUeXljaTRWSk1DYjZwVUxsZ0kr?=
 =?utf-8?B?M2tidE1kVzQ0YVYwUVBiRXNGWmtvNFV2VUc5WXUzSi9mQ1REbmZSQUVuL0xr?=
 =?utf-8?B?bVRsalhEU1lxakJKWGl3b0tFSnIwMXF6T1NKaGU3OW1xTGE1Q3hHVGdqRnlW?=
 =?utf-8?B?U1BUSWZJWW9aTWYvNzNFUUxkM3QxTy91UmErSEdnR3ZZUGRKYWYwczlmK01w?=
 =?utf-8?B?dzFRKy9EU281ZHNoNlN1VWVLNXJlRkdiWnhhcmYvTHg4bWVHdzIzN0lzNEZp?=
 =?utf-8?B?Z09jemtwZ3lsSnlwM1dDNFlKaHI4VVFBTEtmOGhPY2ZIb2NGRmhvZUt3emFV?=
 =?utf-8?B?Uk1HK0hWS2xTSkQ5cFhzTk8vQzFQblhFSXZFdHFmd0F1Y2xpRWo3TGY2SFQr?=
 =?utf-8?B?c2hiRVZEYUkvbXdaTC9TdWc5KzU2SGxSSnFGZmJ6elhUTlhJK0FGd3prQkF2?=
 =?utf-8?B?ZE5mdjNBdXRKNUVQOXFiWlZoazJtNUdTeUhFaVlCQWxXaVR0RVZ3MkcyT3ZI?=
 =?utf-8?B?Tnhzck1zSHA5NVN1RkhWYjRJZnNDdk5rQVFudzg4THhDbjBrTkhtVlhlYnZh?=
 =?utf-8?B?MUJBV0FOWkk5SHZSR1dvNmNrNGdVSkxpMzhzamlaR0h2cGs5dnNOK3FYZXRN?=
 =?utf-8?B?RHI2T043SENTWVlNWS9xdlNhNW5kbEU3MDg5T0tRTlIvc01OSUZBN1d2cHRG?=
 =?utf-8?B?SFhRbUVZenI4RXVKQno2ZDRiWWZPcm1QMzVFV0gvcDJsRTE3WnpnbFJncDUw?=
 =?utf-8?B?ekthK3J4b0R6U3N1eHR2SURMQ0Q2M3pJalFxd1RzWlN1ai9hQkp3ck9VL2ZZ?=
 =?utf-8?B?MXk2SmNicmFBQ213RUorMG85dEhrMGg0aS9zYVNXQzlPSFR3QytPYTUvWTkw?=
 =?utf-8?B?TTcxNEd3amRmMnB6Q01ha0dLRk9hZk1vTDcwSVFxQXdXempzaTNzWmdiVWJF?=
 =?utf-8?B?aWNPbk85K0xER0dYRlg1bmxncEtxdnNSQzRjNldwd3hYQXVmNlQ4Ym9HTXJ1?=
 =?utf-8?B?U09ZbTdodldWSGtJVnJ1T3BqQzI3c0FhcFNucnk4elBVRGxCWVpFNExPMVZi?=
 =?utf-8?B?TnM5cEdwa3JKd2FWeklNYnNVVXJsUC8wNEFCVnRHNk0zeDZ2ak5qMm1kUzB1?=
 =?utf-8?Q?2QQhMIavPgHgyq7o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dab6579a-15f4-4c2f-45d9-08da536cc1a7
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 09:59:39.9228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yyYG49UdPFmNuYeOYhtVTFGLyhECo6YSr+dCYnOLdxCtoWwFNZYczfuZZlh9QEt/U6KNGsb+de5TnQjOgUGreA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5450
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
> This is the start of the stable review cycle for the 5.15.49 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.49-rc1.gz
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
     109 tests:	108 pass, 1 fail

Linux version:	5.15.49-rc1-g3797b8fe6025
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
-- 
nvpublic

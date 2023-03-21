Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FE96C310C
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 12:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjCUL50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 07:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjCUL5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 07:57:23 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296ED4AFFE;
        Tue, 21 Mar 2023 04:57:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RR7Fyz1KgaiiALc/eZAdAUO0Q2wkYjv1WDEjBL6doFkpOjQIS4s39Pint9+iMQwiqvxcR0OxL3N8DEVEiaxz95p4mIQ+Y5SbZVitNDlyvBB9/R8hcHzSGD9Mmvz+f8BCR3P5NIs5MGjaUjBy9XzXGSorWuxyIjkisLWl9Xh57pC9HYJK0n6Kn1prDuZPoBn+lkOiApE7BtzpQLYdAD3DU4ty+smQYLBfCl+adqB3pEswDZWje8zcYlUWxVEzelOt1k4v3JKYrH21ggo7U5gYqtkTvZW1sNtNjDj14bgefyeQol9mLwITd88XZZ32nG5OE1Zbzl6ZMmgm1XGfr6DCeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKN4yIdDzmeshgvytgUGUNNKLRLFFZaqx5UNTafAs6o=;
 b=lV4tuk5Pd348q9atlWIR/1i4XtiwXih/cWTqqmo46vVj7YISOxqnnDqOGqsqCnfdUD8WVZu7vJvomHuCtqgagbhTKhZ7mOJoW178eAdANHskXN9tuYb5Rp4AFnT6V936gAuctbehoHS6wAo8q0tawtu1T1zSo9CPKJA+KDnHd7l1c12X3J8Nswl9ULq2cUJi+5ZsEjRCoFBcCPqzX5GsBq5pSchpHBLEugSH1J7BKvUPvZhbV7vp+WECSh9Ghcl5UId8b4BSEqT0mafO5FCHu9Kdt3A2rGD5CWP2++moNoy8z5HpOA7WmlZCueg1oBxuAojzPDkqZxuxl/2EbLCJzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKN4yIdDzmeshgvytgUGUNNKLRLFFZaqx5UNTafAs6o=;
 b=IRNnGkExtb6ygjHQlFioTRzMbxRDPDWwOSph05W32eNE2kbNYW8SQBExlf0TDlBzi6TjLbzqktRWve+DZwPSOmZFojEbHpPmIOTJY/cjw+Qv7ixdCO4z7rciMCoLtfXUaA0xLjosMuDxG4BaiUEmeEhfPjintYzANRXKRG6uJOJuKMZViBlgIPUAIO8dVcysB+T4zCy6Zd3lUrGPKUDy0VZESypEKoChlvhX+yM9BlkXoUztzOTpZls/CMC81owIPiJ/Su4A/9TCiRA389IUvgedmciyqrT6JafXMdoiHgBK70ld+JKpwyBGJo5QH4jcrBr8XKyOz8rOdP7jqQVu/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 DS7PR12MB8273.namprd12.prod.outlook.com (2603:10b6:8:da::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Tue, 21 Mar 2023 11:57:01 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07%9]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 11:57:01 +0000
Message-ID: <d8f6594b-8887-e6ae-d6d2-fde0aff34d4f@nvidia.com>
Date:   Tue, 21 Mar 2023 11:56:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20230320145507.420176832@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P265CA0014.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::16) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|DS7PR12MB8273:EE_
X-MS-Office365-Filtering-Correlation-Id: 78705fbf-77c8-42b6-bd26-08db2a03614e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IVmfldbliVuFQzJCfcVWeq1ktj+bJGqAVfwC+m4DrFX9DYTIsVuU83ksP8+p/eErIaW7ZpWNKKxPlBc/76xNYBhiMC1UdU035siuwWdyMl5W6JGM2+RO2d6jTjYL5resXx7qtxtieaA68gurv9f+YJZ8CfA4HkWBZojgl3UmwTfNrivjrzIwaEwJP98jIGAz1KiVtINstnRJspMKLU8cWNveE4Z54f98W5/CZIwRi1LQq/EjQg2u/a21e6KBc9dVDcjxIFd7XxTFDOV8hY+3WwWiUwz9m0M/aVlbZ+XHq0R2iIzCQs54TfX9GWX1gABt9nPsQOfxs04fL5TI2tclVCdWmUAF1nCQY8U23D05X1tqvdeM8YYgdLbrhEwD5ZdA3Z4svXL4gMXGzFsbAO3n9DNP9rU9/pSvaYb/1ZB8QCqzDe/L5FihFajiu0p91zND08/uiJZKZrrJPidbibyhYYVld3WmEqlv2NyPGL+XWdTCSW2WJQiUgRnCcUj+tVSPQeRvGd1IG+uHxjsdzB5VqvnxaiJPDCIDvLUrhG4a/Og6Qvh1jd5Qkol+bi1FG3/OtpR4YSk1B1MaJ2aJIbu+rWOFY+q70Gqi5iScyEBSNFa2XkLtviudoxqduiClLEnu/NDK1IXZIUKrKYKrAXO8hdfkkrhcRm2QDe+QSQm+NFOsDnL6E9XW5uz5riglkGGNlBUJdbix2m6bkCtb4xBfha9XRZrodcNiPxTVEaQ1WdSA7p9u/hhg+xngIK+xCVdWJncd2O9ZIOUQeig4UvWrGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(451199018)(31686004)(2616005)(966005)(316002)(6512007)(6666004)(55236004)(53546011)(6486002)(478600001)(26005)(6506007)(186003)(7416002)(31696002)(38100700002)(86362001)(4744005)(66946007)(5660300002)(41300700001)(4326008)(2906002)(8936002)(36756003)(66476007)(66556008)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHZYS3hmWlZUREdYOERESXUvUWJLVklLN3V5YkFpaWdXa0VVQXJHVGlHVWtO?=
 =?utf-8?B?M09DbzhjVHpDbnJveTFNb3VYU0lxRWVydmltU0tWMFNreHE0M3hiNzhKUUJu?=
 =?utf-8?B?Umc0akdScnVwb0hNdEg2UEJneklrMEtyRXBmTlprYWo3a21wT2dvTjlRUlVG?=
 =?utf-8?B?MVpZUlZWTFNBZnkxMjI4WWtua1NJd2RmMkpZQjMvNGgyQno1K1ZHeThhNUpK?=
 =?utf-8?B?aHpaczdQa1FiNVBSL1NBSVVzYnpnZVhhQlRLUzkvc1BtM1J4VHNyT3JkMnpj?=
 =?utf-8?B?MTlvVXY5dWFGU2RPME9aRDh2T1d0Yk5VRVhEQ0toUEIyRWlIZVZzZHV0SEl5?=
 =?utf-8?B?dXc1RzkrVzE1VTZvUENHZkN2bXVJRmcrcXM5QkJwUTlFc29zSXBFb0habFlo?=
 =?utf-8?B?SkhCaVlvQVYySWNCS0tqZzJIS0JtWlRFb3l4b3VNOU9xeTkxUmh0Nk15RURw?=
 =?utf-8?B?U0ZjOWhVQVdHRk9FSHY5bjhrY3d6emxQbVBCZkxCdzlOdjdrTFZZek9GYTgr?=
 =?utf-8?B?amdCTUVLQ3hIZHY5STBaYmN4cjduSUMyNGZZUFNNZ1ovK0JPOWcwekJkWjN5?=
 =?utf-8?B?RThINEZkTWF3OCtnN1Q1SGRCU2N3WGhvRVZHNEErMWZnckYvaXpYOTlzcWVz?=
 =?utf-8?B?aFRHbjVuTzRQcFVXUW96czZQQ0N2ZGJCNklVYko4cjdYeDZ1bWFwQVRnaHJo?=
 =?utf-8?B?Y1BqZDRCV0xHbHQzazZUT0NPY1B2dkpnNmxYanRHRXpibWd1djBKMEdJY0Q3?=
 =?utf-8?B?aThnQ3dpNmFjeGw4MXliN0VWcWtmYmtJZ1BmWVB5N2N0ZktXRVZFcTlIZzM0?=
 =?utf-8?B?NmNBTGJQUWYyTmdZTUl1Z3RBNjEvZ0tVQkZVRkNvWXd2amd4aXpROVBtTUVk?=
 =?utf-8?B?RGpPck1WSlcxMlRyM204T3hVRit0VEIweFZIR0wxN3dVbU5yMzBhME0zZGlI?=
 =?utf-8?B?WlRSMHEzVWVXMXNmbXZ2NWp4UXpsaGQ5a05EYjdrQlNsZUY2dXMvc2s2RXQ4?=
 =?utf-8?B?L2k0QUg2NHNpTURLUDAxRFlKdmhYYjY1RVlCL0VWS2tMaDJTUzJhZHExSzMw?=
 =?utf-8?B?ei9KVVowMDlrVWNISnliVnJDNWt3YUMzdFI0TjdCc3RWcjBkZjRpZVh5MmtF?=
 =?utf-8?B?MSs3R0lvQmlXSnJSVVJQL25POExTVnhnbGp3RVc1dUEwc0NIT1VRVnQ5N0Ix?=
 =?utf-8?B?MlAwMS9RYlQvUHRDWElGdGJYYUFNVTAyQ2tGbExFVE9PaEQrWDFpTnVFQmZI?=
 =?utf-8?B?WjA2ellmUEVwOThaRnFibG9BR0NlRzB6N2NnUkNpWGIvSC9ndkJJcHBzYkEy?=
 =?utf-8?B?U1lnQURXZndsQ2xLSGhyZFlZT0RwbzVZSGlhSjJLTHdZcDVBcTFoWXRtMFFu?=
 =?utf-8?B?YXllNlJPQ0hVbmh0Z3Y5Ynk0bFRaK3huaFBWSW0zeTkxYW55cnNaTkR5dmR6?=
 =?utf-8?B?WFZlYkIraTNTZzBicFU3RDhqd25IQzhoK0pVem05ZUlXZDA2WWRkRTUxMjRI?=
 =?utf-8?B?US8zWHhzRWEvbkZVTTd4S09GUVZVOUJqcUVTZDdWWXl4SGlBM0hNc3NVeUoy?=
 =?utf-8?B?cWQ4UWlVOWhTZ3YwY2I0VVdrY3hWOTdRUHdQQ1RzSTFnR3VZUlptdVVwelRU?=
 =?utf-8?B?NVA5dmp5ditBRk5yc1p3VVhsS0UybnY1UlMxN0FmekxhSWVJV3EwTVpDNCth?=
 =?utf-8?B?MFBEN1Q2WHV6TDc3ZkRJZ2RsSEEvaE1jTUdoMFpxQk8xOGxxTEwwVjRJQjNC?=
 =?utf-8?B?YzdjMkt0ZkREYVYzY2FHUnFFdTk1NHVmcmkxM3B1L3g1dENSblZVeDhpTFh0?=
 =?utf-8?B?QyszTDJnM1RZb3k5NVhlZEJLMkNYdnBVRDYzTzA1aWxWTTczeWtWYTltemtU?=
 =?utf-8?B?QkdiWjRwTHlhSDByRDRJdXhXY0VoWmNFRFZYL0hIYUZNNTNleVhGWk9qQ3Rz?=
 =?utf-8?B?dGx3eWQ3aDVNODdVbEtVWDR6azhtVmsyUHFDRDlweEVsUjQxUm9uU2dRWjl0?=
 =?utf-8?B?Szh2VnRicGZiOENMQWE3UEc2SDlDWmY5Vk12cTlLS0VkSVJlcEtycFczSDBu?=
 =?utf-8?B?cldvM3BnbUZxMHZZUWE5NTFjaXF4dG9takN6WnBXNVdFOGU0Njk4VVdWREow?=
 =?utf-8?B?Z1NLRW9iZEd0NTQ5VnpiTWw5aDZaTDl3V1VXZGZhTUdzelI4bWNoR3FTQkN3?=
 =?utf-8?B?d0E9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78705fbf-77c8-42b6-bd26-08db2a03614e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 11:57:01.2325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iFjcal5bpk0PZnV95g2adPPtr51VLTB57msFv/ngWGAw3zrtaYpWCy0ZCL1Rx+z9KOQLgFKEqMzqU9F7SxJmTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8273
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 20/03/2023 14:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

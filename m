Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A195AB7C3
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 19:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236149AbiIBRrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 13:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236166AbiIBRrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 13:47:11 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE22CF32F3;
        Fri,  2 Sep 2022 10:47:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fYhHcuVys0CfusnZMORJfOHoJSNOKqoYxCrYhM9d+5kRx7KZU4BO70Tgcis7/+gbQPsftfCyjZxFBJu9V1neqmL5Wlj5RRviI1OTHVKAjLaJ6meg5DNl/ueUr9Q3yEFt6YvUhXaXDP3RNnTdusisR7MHd95YHlVBTbe8BpFgVngl3HAWxzENCA3h7RrVVKzNbyiU5NPSBKYnuEwD6NX4zl+TIJeZYjLEXJLP1sGMBn6ZkfTYdnoT25zZy24QqXRhIq6dXYDUcHZ8SjdlxnQ8cCP/r31OZxCSksdfdodnttffylodWQIsWnBkth35osmTocUishgAiNhjck+zk5kmjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VHOfz73GrgjJn1i0pjR9QDxm+tKew59BjFJ04HrcGbM=;
 b=TgZy3Oirc+PbpVN2U9Eg2hnYyiVL2CkUwGOGoiLAGTmFAsYbstim+JOf+vt0yanhw5dCkCHKtodtUaJeTACb8ZJOtnBzlDATRCz83flXHhwxMdwhunIBEgfu/D+DRJ7T0f/75+prRAy0hTr6v83nLxbpZdOFBKTPCAm+gsmz5Q2y8RaK6mtS5ZG9A1mBl5AJ8MmMjaqOU5qn7zOhwtHn82O/soZn13OgGpJhMBiEfN2lAGZ0cr77z1mKApRQsfFooo3ByImEiORYOOOWJMXlz8x0tVn44UkHwwF03zYbtxP5Y6cPRaG2fOdJ4wbVs2v9vqgdHWn2aQAgTgPj+wMlaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHOfz73GrgjJn1i0pjR9QDxm+tKew59BjFJ04HrcGbM=;
 b=mrFW24JfV5GhFkAjiGbKTIPZI/zdEvKmsJ5N63dAS/re6cHwzKcx9dlwuanAvpf7uP8U7BpWp1Th5kvhdRkjPBlI+pbDop9G3G/nUgvDF8Dcex4hC5N4eaFZp48ACuyU6pofAujrJ6iTJS9QJb4Gt0XuahetsHO0VDNFN8ZKnU3FQJM+YbT3H39mQX5a0Fe7PUL7AUTmiTmw82g20Ar7eCXPKX5I/Q79pI7VBRT2cNirLohJMnZjTxxrAMRTw9/hYqrnYO72V4oWM/sELDRt6bZA86adEbW7WuHYJdiJ7AzeqkKibovkBVF9/F7zG2J00GLg5fc0JlMBm2uOxBVAhw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 BY5PR12MB4082.namprd12.prod.outlook.com (2603:10b6:a03:212::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 17:47:07 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::7090:22ef:abb3:ae9f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::7090:22ef:abb3:ae9f%5]) with mapi id 15.20.5588.015; Fri, 2 Sep 2022
 17:47:07 +0000
Message-ID: <d3f7531b-83cf-63fa-a266-7229db19558e@nvidia.com>
Date:   Fri, 2 Sep 2022 18:47:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.19 00/72] 5.19.7-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220902121404.772492078@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0458.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::13) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae9c485a-ad4c-4468-e113-08da8d0b275f
X-MS-TrafficTypeDiagnostic: BY5PR12MB4082:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aAPZbZRi6WT0Az1bKU0mB1o5mWSfIhgXozdnSjxNmWaWave94TkoJYozkJrIwXAp/MImW9b1M2e8XBfsGcBftdAJZODPfNH5k3bVKg9SPeOaIWNT2M1f/3V8N1XSazkJYTyaeiOU+7JGANVlzrztZkjOP1FEX9h62UhLsABhD36QJ7YazjpDBA7FfclF7czSBTtjXB2JjzH+RSijWig+ZPBTJyNQ6IvJfM79NvYReDh9gqJUEa+tHcanC4MhL1MCvOARAnqO20A9b7wG7eT30tnfmeSC2PuhWz7HUdTpLc8KQbTI0w6Hueu6m/s+wCEjcrUW/qkTgWhJoNVMqE6K0N0AeKZWJAIcjhU9sO5bQ5x3MeIUyoecEZDmksHKCXJH5Dyf1rHsfQn9VAdpHvTE70K+RPVloro3CoWjo64i8kxf5NXIVeKPFnMH9ZhzPfRCZG8/10p8gaX9mKugjSDFjQI+2FKnD9agPzL7WFN9TFF19ZYM3yd+YMba2gLnxVD85fEhek+BQ/ZRSI0dm1EI3xP6B4zWJ9SYRtb5ZIB7uPctXI4z5+esoXIvXtzELVBT+JYGLTK2UBCywnkJeV1FdKjPW6Gl3ROo+AlzJNHJ7oxk7bDUebfUJzU/xBVhakZDxfuTqhWRlWyl/QpL3mKCbe/CpZfCSaecSq0+mqtcg9w8nh5+ZELyMc+863t9cv5jehyBgnH1uNYpzcJrWJbeobexz8jAt56j//1/364xK9UWfq5mdWLFyyvxxOBHR2MwEQ0/SXBOdLxQMIWX7S1dq27M3PBE7YAmMw2g7RzQpXY8oHQ+uE6lspsjm/sr29cl7/UhgZsBlxeFVfQPy81WSoerDmLP4l8kXz4CEPaoIronVVIneU6Lebzyqzg0LM32
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(366004)(396003)(376002)(31696002)(86362001)(41300700001)(36756003)(53546011)(6666004)(83380400001)(6506007)(6512007)(186003)(31686004)(38100700002)(2616005)(66946007)(966005)(66556008)(6486002)(66476007)(316002)(4326008)(7416002)(8676002)(5660300002)(478600001)(2906002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUdmLzZ3WUljWlpHRXNESnNudzZSUUZ4Wk42UHM4ZURQbWxTRldnaVUxWlRR?=
 =?utf-8?B?Tm1pbzRyNENGRFJyUlhhRVM3UTdLWkQvZHAwa1lWd1cwMGVFdGU0Yy8zQVdj?=
 =?utf-8?B?VUxNa0txOWRVUXRycUpraTc5S05BMXNIeC80bnVKM0VSZkZyTXJMRDBSUnZ6?=
 =?utf-8?B?TXlmcDA2NzJFV0NZMTB5UDBVcFNSaS91YktpVzdCZlFKN3ptcnQ3RjVGM3hn?=
 =?utf-8?B?NmlSZ2gvdEhkV1M0VUw1RTFhbFkzQjFETHBDT1dCSjBjMFYvSmN5NHQvaVZt?=
 =?utf-8?B?MnhUeHpHTVFTbzl2MXJCVEJCUFUzemprQUY1NmQvWlpad3kzb1hSWmUzTHZ0?=
 =?utf-8?B?TkI4SVN3RjVRcVlONGFXRW56T2grdnkxQWJkamJCNVowZnhyNlpldE4xNmhH?=
 =?utf-8?B?b3dYUStvZlhxQmdhZUFWSVYxcktOWHNJMDdqQXVtdWZhaEZyejYvL1FhcEc3?=
 =?utf-8?B?aSs4Myt1Ym5lZEU2QTFWd1pVMFcwNndnRExkTUtRV0Zwak92eTMycnFZMkJt?=
 =?utf-8?B?VjhEN1VKSFlCd1p1NkFtS0RJeG9CTEpoTHByNkZlYWtSVDlneko4d0xLellT?=
 =?utf-8?B?c2J6dTFGalJLT3h4QkRyS1IzVU8yc2NYbzB1SkpsdXFsR1A2amlGOU5jZ29D?=
 =?utf-8?B?VDlnOVMzOGo1Vlk0VUZITlhqb3pQUDFsQ0tzQTNpM2p0UkwzU1BpeUpZOFpW?=
 =?utf-8?B?SjduS1BtSHRyQm5ZNWkxbmVjdFVraUJJa1FwR0xLYTRqUUdObm14RXlCZXN3?=
 =?utf-8?B?YWIyY0wvSXpnRndTM3N4Yk5qa0xWNC9CekhrVGd3Ry85dk5CdnJSbDdDN0Fr?=
 =?utf-8?B?UDVrK3pqQjZHUXcybUh0cVBLT1ArbVpmZFpvMXlLNENjSXptRno4Nlc0Z2tS?=
 =?utf-8?B?a05qWm1vR2JmZ21ZK1NpNlZ1OUJSVkVvZmFPVkZYcVFPc3hsSkJpKzZlWnBV?=
 =?utf-8?B?Mm8zcTVXZWhuR21lVUdmTUJEeTN6YVJkV08zaTVJRTlyeTB3aWk3QnI3RjNi?=
 =?utf-8?B?dTBQd0ozS1paSHFJc1RvNk5YWEF5SGNUUjFIQ0gzUDNFMnRVUEJxUkhBckl4?=
 =?utf-8?B?NE41TjZoTHJmSnpCSTZjT3ZoYmw2UEtMQ3lNUGNXWEtUbTh2cmRpN0FITkxI?=
 =?utf-8?B?YlpGbWhhTll4QUs1ck0yTTY1SUk4aTN5R1ZBMUhnMVIydm1ubnVPb0FydDJ3?=
 =?utf-8?B?VWE2N2JwS28wQWlQNVlYMzJyUHN2YUhjVkZrUWFPeEkyNnNnd1RpWVNDWm9p?=
 =?utf-8?B?K3lBYmEwK0loeGdWQ0NPeEdhVTExWDlOUnlHYi9TYmg2Y1QwYXF1d0phMFdI?=
 =?utf-8?B?b0g3elJOSzZVMnlyaXhQZkYwK3dPRWsrSmFibVFsYkhjeG5vcnA3cnRIR0FW?=
 =?utf-8?B?dS95Vi9WV2NMWnZDam9tVmlhZk9qbWJidFdya3lwcGlzRDU1ZFZUZjBLS3hK?=
 =?utf-8?B?bUo1a00veXNhNWdRU2xnZjExb0VKYzdmMTlpczVTV2Era2syZkY1WFRCcWxw?=
 =?utf-8?B?SFI4QUNTRlM0dXN0UklTYTNTYjhxNk9UYVNBOUJiUzAweVdrd2pCZ2ZWbm5i?=
 =?utf-8?B?TVUyVi9Qb2ZVWU0yOVBMY0F5M3oyeTd6QWVleUt2a3lLV2JDaWVCaUtpUGNK?=
 =?utf-8?B?ZkhsZ2F1REtjUWFuck13YjUybENGa3Z1YXhCUmMvL0dqNW94U041QzljN1V1?=
 =?utf-8?B?TnNoQ3VkQzNZZVEvVTlkUzlMYVlNcmZhT2x2OVpQdVNXcER2NlpDU2R5WkxF?=
 =?utf-8?B?anVHVHZDUHRuaERtQTJob3ZOSUJYeUpiZEpuUUJJeVY0M3hEY1NacjlLRDJP?=
 =?utf-8?B?NWkzbGMzdWNHdmpNUzJxLzRWTG10bmtXb1lkMXV4Q2U4Szhab2cvZkVUbWdB?=
 =?utf-8?B?enNDTjdyKzVzOE5EOXBGUytGSmJEOTJ0d0NnK0FFRHV6M0R4OEJJeWZETi9q?=
 =?utf-8?B?bGlaNzdsd3FUSkdhMENtUFU4bEJMZ2FRQnVMM1ZRRTJzVnhEblFKODRHaWxm?=
 =?utf-8?B?SDdIaTczbmdtWGlhVXlJZ0p4Z0I0Si9kd2V2VVd2NDNaejFiZytlUFZ4VTE2?=
 =?utf-8?B?bGZkbW05SGtSYmJNTWJRMVJrOS9hb0NLU3NneGZ3WUxPMkl3WHk5a1NEb3I1?=
 =?utf-8?B?c1kyakV1Tm5wYnhJWkpPM2kzSG9IZ0JHaTl4c1MzcUthQ1NZUVNqSEVOdWwv?=
 =?utf-8?B?ZUF0UDlIZkxxcGVuSUc4WWFkdTNTYUx0b1V4MldOUDBLa0V5dmVIb25Nb2pJ?=
 =?utf-8?B?MGZCTXRta2hmMk1lSUdJNldzZlBRPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae9c485a-ad4c-4468-e113-08da8d0b275f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 17:47:07.4223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0rPgGLdruXpps1E2MlD8C/HBLxwwxeHRqWa06cUOsJ+T7ruYhBZizFbFFccdWuISI6878nAL1B8BYAkoEJNDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4082
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 02/09/2022 13:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.7 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


We have a couple issues for v5.19 that are still working through and so 
I don't have a clean report for v5.19 yet. However, I don't see any 
thing of concern that has changed in this update so looks fine. Hence, I 
have not been sending reports for v5.19 so far. We are working to 
resolve this.

Cheers
Jon

-- 
nvpublic

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73D261609C
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 11:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiKBKKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 06:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiKBKKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 06:10:13 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4547823EBD;
        Wed,  2 Nov 2022 03:10:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+jI7ho8g3dLDmLzK9HbhBlCncg/SIKiCOuAjJKftmJ3DdI7ufBrvkyIGV+38WoYotZrIZ5NBYkHxI+g/17dwpl83URad0Lzy02JRvh6ilLJMQP5rrHS9fkzfnSQki5opcL5KAVjBsjz8g4NigIKKUSeUrahkOYzOAUVd9odTAY3ONjnBcOGD3gZkR1icET4Jx6tIlyKe++0NzMSr/Kd81lOm3lIFB3pzOiINaoYeB+T4x0irBWPyw4UohZa5ufhsnLT8w9Mc6CCfnytmxPe2l7kVWOBg0v2PYLVeAgyBJuzEu0XIYlowl6maUqVyVEfOqJOe6P58mzqUQUipX/05Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TvpuywBPlb6AvtieizrZ19YO7WDPunrgylHfy8ZyYZg=;
 b=Zo0L8FysDKjTDhvLOocf+ov6fm5PEL5Yl8XX7neFOHBnlSy0z/DGRVVVZ+7zOFFaAPcPKonuG/cEF3gC3cp8Nd7XlpXbMg1jLcaANSiyZOHuDjQMUfAEM0ScWLM9QgafKZfcPgkbTUAvpXKDwmqQtTF2764BgsZMLevaQhlsx2bCFJoh3WYxADnQDO8GcjcYC0D5Q8obzoQYNvrM94Djs2DbqE8MxOlrI+6Lu3IAUs+a/EoxtCvpBFnImSymymj1vab4cDFkhBEhaqSP/kuvw+73yLAsatYin4fSk4LMga4OPIHn3HzoN4PtNN2K7jcD/q6GCntYkSxQ8cTAGoJ9vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TvpuywBPlb6AvtieizrZ19YO7WDPunrgylHfy8ZyYZg=;
 b=rb0/jfFXxQoT3l+AZmiz0dyVRJFXJVdRX00Xu9nvAabZES1c2G5UcyKZzjGqS3T5oRe+S5FKugTFwDW4aDkdVkZzkBuCw3HTnRJCAwc+FRgd3xw4tFFttZVUgqlG8wT4PfXZTimdgMsRdl0cGxHo/9ocR8LCaUPxuNQIUEox9OB6LJfCuUMgYiJJqnQdWxwL2qFQN4OVLDQW4tguLwUdCsosHBikHNnnSboKqoZ02nU/H7qdMIJR8qor1oZhO+Y7DjzHjuBZ0lAI+8dc+BUyLqXict04++JNxX6ohbZL+rycKmar04CiwZt29vWndOczDQKaQwqxG99M4WDLGZ2aJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 SJ0PR12MB5611.namprd12.prod.outlook.com (2603:10b6:a03:426::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Wed, 2 Nov
 2022 10:10:11 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::d749:2439:e6ae:5840]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::d749:2439:e6ae:5840%4]) with mapi id 15.20.5791.020; Wed, 2 Nov 2022
 10:10:10 +0000
Message-ID: <17c18160-bafc-fd36-94d5-baed29db6d08@nvidia.com>
Date:   Wed, 2 Nov 2022 10:10:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 000/240] 6.0.7-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20221102022111.398283374@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0220.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::18) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|SJ0PR12MB5611:EE_
X-MS-Office365-Filtering-Correlation-Id: 46042346-2f0f-41ac-2683-08dabcba6d02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m4nIfFYOXJwCINzVQeziGVPvjGbcDWz8q3xwmC0iXPYSXYY06ga4KEIZ4r92Og53yIgD0kMiHu4azjiQBPNAHRmzHtlzabZhT+ih/sQMo7ArGRYiYMoUz53YOxlUoKRuNjI1MnJP9F4pp6rn/AyJ+shENzf9ocJqoDdsozriN4vHU4DZxQF6tU0/Ez/HqWcwe0/1GrjFqpESya0UV3a5pIVY9jgpCg/7s3GyN7Z19KxWhpjflqeHZr2iFAl5w4WcW77x5DlhM7qQE0+PrqqZc4vg4UiS1IZ0d7giZhmRI5EGxet9jnX55A6BW1Wd2nAgUMPNcRh1rYDBaDrqpznP6KUdsk8U4ccKt13vLsmC8cAnLkYRXai+uJY+2JW3m9tnk57wmeP4BWoAyqRn8g9qcugBsDCkcE+J1kAmH0Q3vp/GoObcsu51CF9gcq3ygSq5DDPhdp44MsBjwLDUzLqaftf3cNmJ6QjhxWLbE+PNyNhM7qk8YiyO7lbbJdI9PPC4LAq0U2c42B2tEhTUVOH2AlvfS9oE/Y2miRRtTtJcmMXaWyEm6jRBoX2LG1GrGzPqQfb3oltBygobqS+JnFBRHZU/lNxQkfZChEW8/xfMQUii9p4wNqicTq6k/by5Pgjgh5YfCJuo2G6WOujtaYUBOB62N1SErl3Cc/xotoMAMjz1AiccAxZnWdlLfTu3towxBZ7tqC5MURp966IK3DDsiiqkFZAby+VH3bZwvk1U4oLsw+nLMSb7KQfzEIf2kTgjtSItwYMCqg3qH84wpP+k1uAo394HPNzz+muCPGqYq6EVLz6SdTxVBVEDU1mujpxSKnnCtlI9lZRCrXFD7EgO6QQvq0QhLKmYBv6fi0YgIzj9Bj3Gwyw7DM5BXzv8QVnq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199015)(6666004)(5660300002)(6506007)(31686004)(7416002)(6512007)(966005)(53546011)(2906002)(6486002)(86362001)(38100700002)(478600001)(2616005)(36756003)(186003)(41300700001)(4326008)(66556008)(66476007)(8676002)(66946007)(8936002)(316002)(83380400001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UCt1MHFmK3Vtc0RnazNacy9GWXJ5R21lNUVhWEE4d1RGaSt5UmJkTkZNckZh?=
 =?utf-8?B?OWs4RW9RMG1rTlVINWVEQnlCVXJ4WlB2OTcwL1lmdnBGWGcvTXJPMUY5QWx3?=
 =?utf-8?B?UmE2WFZseXZubE5USE5XRTNySk1SVFkzRys2Mm5wVjIxUnpGYlZsY0p2U1Z2?=
 =?utf-8?B?dGhxN0xsM2toWkRqUHR3WkRVb21SRWtqQVFGcXhNRzNmakFDajhQSGpIUDFo?=
 =?utf-8?B?UlNQSjlkWUtDUUNtekRIRm5LbFpYVFVWM3NOU2t4enhqbGFPM3FyQnJUbGM2?=
 =?utf-8?B?MnhOZ1JTdlcyck5jUVVCbUsweENEOERZU1VtcHdSS1orVnEyOVl6NWptOGMw?=
 =?utf-8?B?V2FRQUNUdnNXZmRkcS8zN0t1ZVRLcVVoVENSV2dxeExiWEdqN0NGd285bFZR?=
 =?utf-8?B?ZXA4K0FERklNY1ROS1A3WjFCaHFvRUhNVUs2WldZaEgxcEVvTEpla0tEM21X?=
 =?utf-8?B?MStzalpxRG9jSUxuU1doWXFGL1pvbTFSRE9RMm5ZaXg4NUQ0cUNXaksxaXZp?=
 =?utf-8?B?dGJFSzFUeWdianVPRENZbkNWNzhnTTJ5b21ROU1xRmJEenFReEVoelpRc2x1?=
 =?utf-8?B?RVlqc2xmbU4yengrcW1scm5WcVhicm9vVENKSmRRQ1VIUEZEaW9lZ1djc3p2?=
 =?utf-8?B?eURmWUlPUXRwQi9CZlovaXVLQ1hFNEdBUHFvQk53dkNkczBuRE96QXYvNCs0?=
 =?utf-8?B?d3kxeGdRSklEaFJWSnNzQlQ5ZU90UjN1RVBkQjVvVGxKaTRwM2JEN0FrenBI?=
 =?utf-8?B?dmtZL1VNcWdJeDJYdWIrd0RFbGRpbVNqU1EvZ05nZ3ZjOEh3Q1JSUlhwTUF5?=
 =?utf-8?B?c1BGb1JFNlQvWUpVdUpmTDZhTTl0Q1BCdkxHb2VLWU1JRmVRUlF2ZEJLbGxC?=
 =?utf-8?B?NkZ3K3BLZ2w5MTJUUUVuUlZkWmhJeW9rcldYTTRNNVlqNk40aXh0UFBaUCtQ?=
 =?utf-8?B?NnV3Ymw4V1BvOEZHcTlGTmV4VHhldHFoRWViZzlMSzNJUlN5NFpMQmErZWxY?=
 =?utf-8?B?QzM3anJvczd4SElrNzFqQmE1REt5blZIZkFOaURDckpRU1JWRTNSNkVtVmtt?=
 =?utf-8?B?TEdJREt4WDh4NW10SkNWajB0cXJtb3Q3cncxbHU4bCs1UGpJcThIZjUxZzVw?=
 =?utf-8?B?V04zcU1YTzBZblBZZVVNQ28wZERqL3NSSStublJqS1dITHhjbEJKNFZMZGg3?=
 =?utf-8?B?Y1ErTEZYNzZESTkyK0lmTjE3M2lOTWNxVjJoaktBL0psQlY2d29qdUh1R0hy?=
 =?utf-8?B?QWY3eitQanhiUTlYbnI1bno4eWFxSUZCem9FZVZDaHRLSStWQnJEWGh0QUJy?=
 =?utf-8?B?RVhsTFpqY2hxRC9meTFQMkg0bnBVTG9hbVRTa1VuWGhIUkVVTWptN3FxQkZp?=
 =?utf-8?B?b0VkYTBTY1VlZzQwRHhDWHpMM1RwZ084VS9tMVFoRVNTTmdIaVp5NTdkUWpi?=
 =?utf-8?B?TGFoOGIvR0ZVUmdNanhQT1B6cDFhQ1hXUzl5REluRlFwQkJxdy9lalJRcFdE?=
 =?utf-8?B?b2N5eXZQaUwyY0NhNERuM3lHZGpmeXNoZmRGaC82VE5ESmRKUTRDdFQyeDFD?=
 =?utf-8?B?T2xzdUFUd29tMmZPNkI1Wk82b0ZISTkyL3ZqL1NIUUhkcWx6L3lkelIxZkZM?=
 =?utf-8?B?WVllNEFUY1cyd3lnbDJka0dRSkZtVlhJVUxIR1Z5YkM5eXlISTM5NnRXMkxE?=
 =?utf-8?B?MU1mWWNjYzhIVmxNTEUyZlRXR3VidFBZcW9Cc2JKc3hjTGhzdnd1Y2xQUzkr?=
 =?utf-8?B?YkNVSGpSQ0o0NnE1OEJQMUhRaFZwSlNIRHhmQ3cyWkdJbFlTallTVnRNWnE1?=
 =?utf-8?B?cTJDY2RSeDI3NUxTc2NramErZU1ISHowTDJLaEdSM2RaZVkxRTZ5WWRXUDZI?=
 =?utf-8?B?czVOcG0xb0w3SGFnYjdPeUMrK2ZLL1RyL1RvYkZNMG01clVEc1RQcFBxN1E4?=
 =?utf-8?B?MWQwcEN3cVBuMjRlRXdOVlI4SDE3cUNoRUNWV3RMSHBRaFR6czdrRWJLZHhX?=
 =?utf-8?B?TE9vZGxQczlQS2hZRTBmVmhUdVpKWFdUZjhycFdNQjhoTStWbDQwdjcydTcw?=
 =?utf-8?B?cm1ibVYrOG9GOHdrdTV4RWdxbkhmdHVPTFhVNmQwT1BoSTVRMmlCRGFFS2t1?=
 =?utf-8?B?dmFEWGM3d0pwRGkrTmI3b05tSjd2ams4NTI3YjRLMFc2eHRJbHdtS1VmUjJH?=
 =?utf-8?Q?opF9jEtnucycUjF25ELyfnj2axLTt8uTuz/CnnLhWPmn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46042346-2f0f-41ac-2683-08dabcba6d02
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2022 10:10:10.7655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lzKGB8DpvUEN/BzpuXASMuEDT1kduKndyTPRajIBW4ccBCx6wL8fz3aHwZjXdLWhBCA2W4ofNvabs522KFokhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5611
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 02/11/2022 02:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.7 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No new regressions for Tegra ...

Test results for stable-v6.0:
     11 builds:	11 pass, 0 fail
     28 boots:	28 pass, 0 fail
     130 tests:	129 pass, 1 fail

Linux version:	6.0.7-rc1-g436175d0f780
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic

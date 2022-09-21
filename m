Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6355BFC79
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 12:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiIUKji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 06:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiIUKjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 06:39:37 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D77626DA;
        Wed, 21 Sep 2022 03:39:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uwum1RArjCYRMlOc4yawHN8DQ99YgwTelYphd1ntsV7+7Jo4CkxuuCM5I1btckH+nNiA0IIXCshCMISb4bewFmYm5p7Qc0J2mZOoriOC9leDF+yTMMWqv3gASr1Fya4YPuKzV81eLffbPECdN4nj8vayetjMX/8LfL54R2SfAZ5GHL0znbTKKBPDdRWHLE54+d6At4xxpFL3mH1+W2do6lceaQY51yoo8sY2qpsSGsH4XPN+FwEssTQUvlrehOfEAHDmiu3iig6u5pAvpNZA58/VI4yP3iZFbDqGcrOYmKUQBBAntnY9IzOJ4Zyna9AYRVy0IkpOXIwc4oQ9LZxRoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8kZbm1CO/8t10PP/jUUYo2C8FOkNw1go2S8wJoa3W44=;
 b=G9tYzlvhVQa38bnEdyWYTbiBiFnXSVZ5gXO/a1XvAi7kXQy+K6ZMjxolnM8ycwpJIldN5nv2xZ6RtGxJ83nOXr9EtwQktwWVkkMnRXK1SbjIIncGvULPliNsXbR16nyv45Pun3K7JbDnTGjf1nh7kHqvF2VAbrwSGwm4prqDhTXalsuWSbc26PaXAE8/YRL6hJE0VkNngtEj/7aUxQm5d5YY87/fPqr0YERDYlFa86F0QywO6KhXk1MwSt5O6JM0LNSset07nyM3EdXs3ma5HKraXd5eDYiZB+DDOr5mrFGQ0nlwEZ2HtV/a67/gtKVz7R/sNwi1hbVk/R2lDlCKXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8kZbm1CO/8t10PP/jUUYo2C8FOkNw1go2S8wJoa3W44=;
 b=SvsEFMcwaVD+gEtMjRIHvt5nnewUqPlv5wrxyBc1RVHIRmKhg8KBccE/x+xw13a+l8U8SgOnC6AiHulAwtRYtkSuIrtnjiKH9FXabteGfKk6LOhjbsWce47QPNODcJo2vC08kQYtz0wN76mCHH8iAavjrl1X3b6yD4tqhyDcT2k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2381.namprd12.prod.outlook.com (2603:10b6:802:2f::13)
 by PH8PR12MB7135.namprd12.prod.outlook.com (2603:10b6:510:22c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 21 Sep
 2022 10:39:32 +0000
Received: from SN1PR12MB2381.namprd12.prod.outlook.com
 ([fe80::c534:ae1c:f7a1:1f33]) by SN1PR12MB2381.namprd12.prod.outlook.com
 ([fe80::c534:ae1c:f7a1:1f33%4]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 10:39:32 +0000
Message-ID: <f927f969-028a-4ad4-7776-527ed537c77f@amd.com>
Date:   Wed, 21 Sep 2022 16:09:16 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, andi@lisas.de,
        puwen@hygon.cn, mario.limonciello@amd.com, peterz@infradead.org,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        stable@vger.kernel.org, regressions@lists.linux.dev
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <YyrPqlo/ysCeh4qU@zn.tnic>
From:   K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <YyrPqlo/ysCeh4qU@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::21) To SN1PR12MB2381.namprd12.prod.outlook.com
 (2603:10b6:802:2f::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PR12MB2381:EE_|PH8PR12MB7135:EE_
X-MS-Office365-Filtering-Correlation-Id: 76e5ff95-15b4-4496-518c-08da9bbd9189
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cYqz/gHotWMMYvJPsd8SeUR0YitprQz1/BIcCComqXCN4P17TJzqKA0uFocJFRNXiJA656CX/ghX4R75+BnvIaaxHjdh05Vm+soGb0oE9kxOKY8tRy3KteGssFhbvazRhEANHNpe/K46IVNE9KwqdVnYlEjGfVeAgxhGuAur/gGWrU5GosO3/pgH80e6f4eaOaMJ2UhIZ0p1PWNPhC+A3t5AAw77/+PfOeDSaZ/xXvpdRYINQNG7qk/CUQbmC+FUxqHgPi4KS/MqYrRtuwRIIteVQxAOrA3VlT8xihrHV+vxoWoyVIEMTZN87ElJNDCoMNaBrw4B+G+mpCRieGt3AipG8HPSOU7ezkJc+HoChjwpSPCVHKkBIYAAOhPF8LvbnXAbLw1++XF8CQWripNeH1XRgPX8yZGbz9qH+PwT6Xpkn7ggogKV3hOZZsQ9Q2+k3v3Sgh5iADa5jXsmFTVmGqI+TkKFShyIy9lYPsK1dIA6vJql3xK4vPixjNR5dGWVZ3Pxz/RV2pNyeyFVy84ZcIhUvoRAbuY1F+N1uEk2Hy1K527xSEipbPhIFxNwP9+yUm9M21SSxvJ1BHyzcGt8Ca09jQ6tjN/nhmWyikXgYp8jQY3raRgOOmZMvvKoAy8saqdnrezOWxAGadEXEesZdWoGmHjK0fjRp6eTqL5n/+5/JDN+0AINe2KF4O8FlaX+dCmp082n9Ho+GrnnKz4s/T6ENmXMo9OQC4CIkYJfLe0YZdpKf1WamI9yjQVf5zoKiCowR/0YzKFc25jUEcMZad1NH90NDwU8HigbauSHRm4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2381.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(451199015)(8676002)(31696002)(4744005)(478600001)(316002)(6916009)(83380400001)(186003)(2616005)(66476007)(31686004)(6506007)(2906002)(6512007)(7416002)(26005)(8936002)(6666004)(5660300002)(53546011)(66946007)(38100700002)(86362001)(66556008)(4326008)(36756003)(41300700001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDR5c0RWb0hvWm83REd6a1ZrSE8vK2czODhpOHh2MjBlRGY2VEg2ZnFGeFVy?=
 =?utf-8?B?VThOSkU3bUpCSFhvakhOUlhzWUNjckU5WlRITU1oWDA2aDkwYjc4MGw2ZkFP?=
 =?utf-8?B?TDA2UzhCbitORklDTmk0YlFHRkJ3TXZJbnFvZVQ3YjNYZlRGTUp2OWVrSzE5?=
 =?utf-8?B?SDEzUmtERUFWREkwSW9aWXNnVlJXQnRYWFdvUm1oMmRrM0hPYkQ4VWErTm1X?=
 =?utf-8?B?K1JGSzc3ZkppRzFVcDBOME9Qc3UxeXdIS1h6WXlSam9SVGVibzkybTJLNG1k?=
 =?utf-8?B?eEYybEpKWnVKR1pIcjZNVFhYdlZmclVqdHlJQlNZQVRSZUN0YTVpRjgxbzhD?=
 =?utf-8?B?VDA4RktXd3NBQytQQ0lzVEdST1d4NGIraGkxQjdxSXBjNHhxNVVCOHZ0dTJR?=
 =?utf-8?B?aWprUGdvbG95cFJId0YvMVRPS1Y3V3JRbWN0OXIwRFMzR0ljUlVacUhpamlu?=
 =?utf-8?B?Nmp5cE92NDcrYURsYjRwbTRlTDVyZlVjZ014cFZCbm8wV1NWNXdUb00xTDFM?=
 =?utf-8?B?SldxMUpXdHU2NkFKS2ZrQW9FSHE2ek54aTZhejh5blRrY0pQbGFVVlNVMTFK?=
 =?utf-8?B?WVZEWW95dGtyYTR4RXlOUENkWmt0SkdGSkJFMUR5UEZPUVErRWFzaW1jdFZ0?=
 =?utf-8?B?N2ZTSCtXNlYwWTh4V0hDakR5Ylh4UVJWZ0FIeVZBa1c1UEgrYnRVcVlmSVdN?=
 =?utf-8?B?S0M3UEpiVUUzZlRNTzV4WGVScG5Pck5nZzF1YTZ5VDRXS1NmSTNnSTYvMlAy?=
 =?utf-8?B?TWtrMWtRMy9jN2hCQ2NIS0l2WG9tMFBoMWZzVnFYUHVSdlM3Q3hKNVB5eEJz?=
 =?utf-8?B?MmNDZUVKd25zd0R3Q1hQSHI2RGw2YWVJSEpvd2gwQ0tERUJyT0JWNC85V053?=
 =?utf-8?B?NW5yMHJaeDl2QXlONTdxbGpnT1RTUlhTWjZrbVp0NlFFeElUYitZMVltbFRz?=
 =?utf-8?B?M2RmQ3RFSWtheFQxOEU3RU8wL01pWjliQSsxSStadmcwNFdoS0RqQTFLRkVs?=
 =?utf-8?B?SHp0aE00OHBHUjc5U29lVElzR09MS0QrQ0oyYUNRY3JoU3BSaFpnd0RmRHRP?=
 =?utf-8?B?dUxxRmdjQVBVTnh6b1g0OU1iYUhNQWR2WkVBVXdUdUorWlo1OW4yYUEvQ0lz?=
 =?utf-8?B?b0U4SjNJUjNnSlRQZE5VWmo1aE4rWHFXM1ZXQ0I1dURBQk9vcGF1SXV1L1ky?=
 =?utf-8?B?dGtZQ0VzRGVJVmY3OXdyVjd0VUJ0WG5yWGkwME9tVEhVWHVmZUFkanBzaVkw?=
 =?utf-8?B?dXd3OGk4UVJYMGdaZVRqZkMxWVJqOC9UMk5sY0ZhMWVHY3BrWGxoTTQwUFRJ?=
 =?utf-8?B?emFxTXVkMDNNUUxNdGlqYjFCMHlxZUEvaW42bW1zQ25xT0VpRnZhTEI3SU5F?=
 =?utf-8?B?aldJeStjL2tXUGhrNi9HOEsxcEdnNUZZamhVaFZwSnhKbzNvdGE2OXF4Um8y?=
 =?utf-8?B?SWpia0M2Vk1mRXhjZVBPRXVmaFZwdWRFM3dyaGtpQTVPUEJha2xwbStHNTN5?=
 =?utf-8?B?UW5rZ2pSenhzZHdTYkw2ZnBZVWs1bUxVek01U1V2SDZmejNGdVVUZmJBWElS?=
 =?utf-8?B?ZU0wV2hxaVNOM0ZpN2JUSWpwUHdkRm1UdGhKMEM4bkplRTZwVHRhcTUvYm9T?=
 =?utf-8?B?ekl4RFRld054VEI2L1ZnYkVuendOSWx3Tk1vWS9GdW53eUpZWXQ1cTQxNUlE?=
 =?utf-8?B?MW5ZNGowQTFTZXVsMHBoNUpkbXRmYllCbmZQanF0WnRqS2ZRcXdLcEM1RU5Q?=
 =?utf-8?B?bTMyU3FBMWNEcERIMlFLVjNTd3BuNURVazFyMTh2clNiaExBVTVnZXNwK3k4?=
 =?utf-8?B?bS9VT211OWdXeXdKZ09SbXRQUEhyYk5xT1FJR281T1ljZE1SeWluNExmOWls?=
 =?utf-8?B?M3JwUkY4RmYweXlPMDAzNkY0KzlTN0lqSmRrcVBIS1M2S0dsTDgrT3BZeGRK?=
 =?utf-8?B?SkdabGhMM2RxZHpheW5MR3YvVHdRS01FR1J4cTNYb3VIVmRJWnhVMjdURzhZ?=
 =?utf-8?B?eW1qZ0h6UnRQb3dKNjlIVWlmSWFJUll0VS9SUFRxdnR2WUtsTkhFeXdCSm5J?=
 =?utf-8?B?MzI0U0VNcTNaQWhrOW9vLzdxWWpXSTJPTmIzQWhGVjJnQ1pmWElmRlpEckdN?=
 =?utf-8?Q?bQqDOOXnc1qLg60VFNQU9wC6f?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e5ff95-15b4-4496-518c-08da9bbd9189
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2381.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 10:39:32.2916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7+xBE/gDJ3SwkkMhL/sY9vgKbohb8sZR7xnJ3/GDXuYL79UrDmYpZGAXC7P9vIpLfvzkDVmTa3FCcXxrpNSWsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7135
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Boris,

On 9/21/2022 2:17 PM, Borislav Petkov wrote:
> On Wed, Sep 21, 2022 at 12:06:38PM +0530, K Prateek Nayak wrote:
>> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
>> index 16a1663d02d4..18850aa2b79b 100644
>> --- a/drivers/acpi/processor_idle.c
>> +++ b/drivers/acpi/processor_idle.c
>> @@ -528,8 +528,11 @@ static int acpi_idle_bm_check(void)
>>  static void wait_for_freeze(void)
>>  {
>>  #ifdef	CONFIG_X86
>> -	/* No delay is needed if we are in guest */
>> -	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
>> +	/*
>> +	 * No delay is needed if we are in guest or on a processor
>> +	 * based on the Zen microarchitecture.
>> +	 */
>> +	if (boot_cpu_has(X86_FEATURE_HYPERVISOR) || boot_cpu_has(X86_FEATURE_ZEN))
> 
> s/boot_cpu_has/cpu_feature_enabled/g

I was not aware of cpu_feature_enabled() and it makes perfect sense to
use it here. Thank you for bringing it to my notice.
I'll make this change in v2.

> 
> while at it.
> 

--
Thanks and Regards,
Prateek

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD15D62FF18
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 22:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiKRVFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 16:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiKRVFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 16:05:18 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192C2976D7;
        Fri, 18 Nov 2022 13:05:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U81D4Yrmd2Qn1HW9jxRu/y93IRy7cW/pAzM4NmB/BiGtvEPLl3MLyByihpfj5lYtBbCAdTX0Z+JOiwSAmNsHqlCxEsshPMknYiBOWFPkmeEzPufsE3AgTaKK88b8Ic7bEnEQs42l0CSkDfdtn+kb7aACUPmeidr1peIhh15EhsB/a08rQW+JeHaFKVtbDsHPjCGja6AcFuJUVOP2ApWGtmY3GByup1bcSgKSky1eu1wY4JATuYH+KZWBkNgDro+4wuDayQGOjUl6E08RVMLoYY0oauYHyuyeXBLcNoqtNtCmxgVA4XOhuAe5/zXZgGUsqr1FZHKEPE6eh75pphNrkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+PqPQCN8jhTzPxqb9IEFNDG4/F8WaGYthuEEb02wrYE=;
 b=iTezC4aTQvRL10I6lJxhHjUNnNwrtrerlKiLMvHtq3vIuRAo2Cn7+vf6pbz6HL9flLdO5sw1eL6rg2GT+gupQ7sypYu3C60Vnm5DHwPQ4RYp3zWa0wshFty38wKBkRQaBqyd4iRkOutgpVaI/8YsYdt6/Hg3kbxj84lPAj5L4/TJguir/kqa8gGfpfIzN1JmmD/Mgyk2gsffF/wySjcYSTwR5LQGWY5P/t6k1jhQsrw4RPSG3zXj+ma5hAvukaROKOv0m/hLZ9e8WYU5yYi/rcohZBmCpWPRsfgt9RS5q1n4WClFV7jts0xibF+5Pt7H3rPQzrvAMuEpAwwJxOWjoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+PqPQCN8jhTzPxqb9IEFNDG4/F8WaGYthuEEb02wrYE=;
 b=3/EAairKUhqxTxuRebW+JHdaqwRTpCihdx+tA2aqIpM9Bqy2v8wyOzzCSchfEaS3rs+IOrl0OAUdb7D2L3KRRi7oc5DG7IXESibZVsc93MNcFRTshanWsGp63MKxxBNBS7YhA6uy1++qAuxR3SlIIWmK3Ri/faTau6gpxRUQLbk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CO6PR12MB5427.namprd12.prod.outlook.com (2603:10b6:5:358::13)
 by MW4PR12MB7439.namprd12.prod.outlook.com (2603:10b6:303:22b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Fri, 18 Nov
 2022 21:05:14 +0000
Received: from CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::2d6a:70d0:eb90:9dca]) by CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::2d6a:70d0:eb90:9dca%8]) with mapi id 15.20.5813.019; Fri, 18 Nov 2022
 21:05:14 +0000
Message-ID: <8947162f-762e-5ee1-5be7-73ba641149d0@amd.com>
Date:   Fri, 18 Nov 2022 16:05:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] drm/amd/dc/dce120: Fix audio register mapping, stop
 triggering KASAN
Content-Language: en-US
To:     Alex Deucher <alexdeucher@gmail.com>, Lyude Paul <lyude@redhat.com>
Cc:     amd-gfx@lists.freedesktop.org, Alan Liu <HaoPing.Liu@amd.com>,
        Leo Li <sunpeng.li@amd.com>, David Airlie <airlied@gmail.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
References: <20221114222046.386560-1-lyude@redhat.com>
 <CADnq5_PrarJPZQu6uRwDdCqhZr7Hvbtxo_HuhiQ7H1DYRgSyqQ@mail.gmail.com>
 <CADnq5_O+bTG3992uZKvJct6-iRWL9nW1xEzXhh3SShm1=VLFtQ@mail.gmail.com>
From:   Harry Wentland <harry.wentland@amd.com>
In-Reply-To: <CADnq5_O+bTG3992uZKvJct6-iRWL9nW1xEzXhh3SShm1=VLFtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT1PR01CA0061.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::30) To CO6PR12MB5427.namprd12.prod.outlook.com
 (2603:10b6:5:358::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5427:EE_|MW4PR12MB7439:EE_
X-MS-Office365-Filtering-Correlation-Id: 97234e57-3d2d-41b1-7d50-08dac9a89630
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XBp20YGHn2KeSuB6Vf4IiRzR1PKEAcsWD3SlYhPWwzEizyGBRPziyA9YSGxRh7fkwmUudb0FyoM2LbO+Fhx4yxYiBH3jq1Yj13jwDVdLErNw061EJWEpsenbXfEQN71ZqK3iSBRmsRAn1urq8wHvmnuDnTyZMUREVVM/lPIHfEf5I8uAEjVak3SYuXOkoQM5cDgg7E3GbfuFBjfWOEbJIpeWvZ71hH+Q1d4jmRW5eYQ9SSiXxiYshgQFt1cCVmBvLM4hMLF2QcREJJOAJGNt2V9Ch9sjvG2JZAruy3z2vRbWoV4lt95Sbn0JTrExPEzsl47GLQbiGCKcP+FfPnY4t0OCbRej1/DPjYRAUQtLick0LdcKBejJMNGOFUfQCZzd1YpaZ8FzslJjvVnpZGdrAfJ6NDlLLzJ+oFpeTnqzt9L0lf+gCja7uIf0I4M0gazB0i3DWXQZTOhcSD1Dt5lx0MyKAv+EYF6hlNV75WVAZy0rVedrz/EJN6mgJI2sCZG0fO1Ah+2nM6UWwW5QMg7AICHrabHtoQqa2/uUbFhEPwhTgj2bWh+hJvT6aItGgLiQTq7HtkUfO9wU+TeHSNjlsqpbLKl6VgW/1ZNHnbtgXh1QyaMjm7s+lX4YOrJ+74ulhUWEJBsVzqR1FM/uFFMMsbLFSqWxlWMUIfjjv/t82awTk8HAKoFBuQsdlUz9QbIG+L0ercPLGOMjpOKFbsS3Jk6aLULxpvrGKyiF7IeGBME=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5427.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(451199015)(38100700002)(31696002)(5660300002)(6486002)(110136005)(4326008)(478600001)(2906002)(66946007)(41300700001)(316002)(8676002)(44832011)(66476007)(8936002)(66556008)(54906003)(83380400001)(2616005)(186003)(6512007)(6666004)(6506007)(26005)(36756003)(53546011)(31686004)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3lYZnhyNHVFL1lSNVZlVjlmSkZIcXNkeXBGSzYraDVDWmJNQTRjSE9UVVFT?=
 =?utf-8?B?SDdScE4yL0luNjNMTDhFMjZpN2crVzZNT3o5enZKeFRlR3dQam1yNE5heDFO?=
 =?utf-8?B?MUx4VEo2bVZKVm14ejVmakJBa0JiOStUc2U0eS9MVWFZdkNaMXAyWkJuYW4w?=
 =?utf-8?B?T0FUdDFoUUt5VWdreWRxbEFreVBpZjJRUmF4WVVhQ3N5dDFRdjFwV1BEZnls?=
 =?utf-8?B?eU10cEY2cHg2U2JQUUMyWlI1cGxYSUpocFpVSm5QZ01aLy9PNUxJWVRlT3Br?=
 =?utf-8?B?dE50NUlvWFRML3hxODR5cWgzMWREQ21rMm4rZ0FIaHhId1VxTEZCTmNMSWw3?=
 =?utf-8?B?QjlYUFhHdnRNK2dOQUhoNXdhWWxTNDBxdmtyNnBzOVZWM0twS3BkWjJIb3N5?=
 =?utf-8?B?WlNYZVp6NURvNmF6UjFyazgwMFFYMmszSGc5azUrV3prS2l6NnFtcTFtcHNr?=
 =?utf-8?B?RldkZjhReXNSUkZDcmp0YmlpaEJZQmx1TDV5dTAwK2pTdzdDcjhLY3JRZEtw?=
 =?utf-8?B?a0hzNUNwNmxqSG5YQkcyaUk0R3BYakVaMVRwMElIcXN1VjBUVUE3bnpQQVVz?=
 =?utf-8?B?MUowbUVvNURrTEE3R1RjcFU1ZEJLRkg5OURnY2NBRmFOZWVjeCtpMGFvdFB5?=
 =?utf-8?B?Q1g3akxUUVZIbzRQeTNvbHVlSXB1aUUrZFkvL2pXUWttVkFhYlU3cVVkUThL?=
 =?utf-8?B?YTB5NjEvT2ZKYW9sYVBqSEV2M1VXcmNPYTVobkJ6dUR3WjhZZmdrUjFTREY2?=
 =?utf-8?B?Z0xnY0U5L0s2c1NFWEM4Y21ZVXdUdVkvU2RYN014Zml1L1lSYVhrUG90eU4w?=
 =?utf-8?B?aHU2Ry9SZ1NlaldUS3BuM2huY1lxN1RhU0FVc0RwWXptb0lkYmYrbmZ2YzNx?=
 =?utf-8?B?aVNyTHN1ZW15S3BiVGhrMzI4ZzFUdmpwN3VNVzNkNzRIb3prVkxmaUR0OWVv?=
 =?utf-8?B?aTdiYnRhdWVHNnJLbjA0N1ZRenpiUWJDcThHVmtEcGxXNysvVjRsL3ppbVpT?=
 =?utf-8?B?aHJnelc0ZDlFZFhYNkx2blJHcFo4eEdiK2Q3U1dLdTJOakZxMEJjbytwallw?=
 =?utf-8?B?ZUVIVkE4MFdPb2VBS2xmVHJIVE1HMWR3Um9BdFpCTXpidzBxSXIrR0JBaGlQ?=
 =?utf-8?B?ZDN5Rk4xRFZjZ2F0dXRKVHhBbWRBQXVKMlFoaEZVdWcreEFHby9KU1hCaFc1?=
 =?utf-8?B?RTVxalRGOW5tZFNjaGYxYWtQOGJJQkhZbHp1a0JaSWdKOXh2NG5JTVpOWWRl?=
 =?utf-8?B?SkZhQXFJVk5kYzFDaUo0SW1VeDRreUFObmtPUWFUbkRPNEtHQ1R6cjdXcjZN?=
 =?utf-8?B?U3JtSStEMzRnejRrc2FtOXlLdExzSW0xYzkxcFE4aTNab0VGRWxzN3pMVjZl?=
 =?utf-8?B?aVhFSjdFbFNNSWMxNnBPM3kxYzF4TzgrOXk5WHJVSzhqUGFsMWRZUFdqaDV2?=
 =?utf-8?B?c3NCOEl6c3RRWGRBYUV3d2xzREpJa3YwSVRneHhCMkNoaDNXcG4xelRvdlBh?=
 =?utf-8?B?TEgyK2ZUQmZDek0vRHlFclpQZEdFdnkvZ21QTytZVEx0L3lER1k0d3hnSFh5?=
 =?utf-8?B?WHZmREloenNndGlFT2VWRjJxNUhoK0JtenQ0VmNyYzBpcXdYVWRueWxzbDRJ?=
 =?utf-8?B?Q2xOT2RxZ3FmQkIwU2tuaEdCaVVZbTN5RkxXZG9Hc3Y0SkdicW5qSDVjZWJn?=
 =?utf-8?B?eHhqME1iME50SWdYVlZuYndsZForcXRyZ2FMaCt2bUlIb2FUbCtSa0kvWlRH?=
 =?utf-8?B?MmQrS0JUZG1IYzcxTXUzei9uY3JGUXRFWmJ5dmN2M1VkTlBnaVdBbXh6OXlF?=
 =?utf-8?B?K21Nb2llcXdOalUzeHZpUFdiWFVtaXdKTmVSN2pHcXdnRlZIeXJTTnp2cUpD?=
 =?utf-8?B?REFMcjRSaUUwZ3JwdHRCZVdHSUFYaXJpM3k2eXBLQzNSL0l1R2lNOTViWHZB?=
 =?utf-8?B?bFp5TWZxeVdTd3ZKTk9jODFxL0c5TS9tQlpYMVZIbnJJT2VDWVlHTHJEM3ls?=
 =?utf-8?B?L2RTMVhUeEU1eXVjOE1EdUl6NWljSmE1V1B2blBIcFhaaEVYNFNvNXZ4bWpI?=
 =?utf-8?B?MEVxeGR2ekhaTDRkcXBnSkxXRktpQlJQQVZmd0RRMUMzZ1hXOHNMLzZtUXFj?=
 =?utf-8?Q?B34ikOOXsq/E+9/ikBnrdoohu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97234e57-3d2d-41b1-7d50-08dac9a89630
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5427.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 21:05:13.9982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xhizNDcwPxpChmhUvCErSAu5SqjCEOXWOtVwU25ztuU9S51nbDpnoihbK//xXUeEFpWaRfaZg2cCImYmilWofQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7439
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/18/22 15:25, Alex Deucher wrote:
> On Thu, Nov 17, 2022 at 4:40 PM Alex Deucher <alexdeucher@gmail.com> wrote:
>>
>> On Mon, Nov 14, 2022 at 5:21 PM Lyude Paul <lyude@redhat.com> wrote:
>>>
>>> There's been a very long running bug that seems to have been neglected for
>>> a while, where amdgpu consistently triggers a KASAN error at start:
>>>
>>>   BUG: KASAN: global-out-of-bounds in read_indirect_azalia_reg+0x1d4/0x2a0 [amdgpu]
>>>   Read of size 4 at addr ffffffffc2274b28 by task modprobe/1889
>>>
>>> After digging through amd's rather creative method for accessing registers,
>>> I eventually discovered the problem likely has to do with the fact that on
>>> my dce120 GPU there are supposedly 7 sets of audio registers. But we only
>>> define a register mapping for 6 sets.
>>>
>>> So, fix this and fix the KASAN warning finally.
>>>
>>> Signed-off-by: Lyude Paul <lyude@redhat.com>
>>> Cc: stable@vger.kernel.org
>>
>> This is the correct fix for asics having 7 audio instances.  It looks
>> correct to me, assuming DCE12 actually has 7 audio instances.
>> @Wentland, Harry Do you know off hand?  If you can confirm that, the
>> patch is:
>> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> 
> The driver currently defines 7 audio instances, whether or not it
> actually has 7 remains to be seen but the code as is is broken, so
> I'll apply this.  If it turns out there are only 6 instances we can
> fix the count later.  Applied.  Thanks!
> 

Good catch. I seem to recall some DCE generations had an extra audio
device and if DCE12 defines 7 audio instances then this is the correct
fix.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>

Harry

> Alex
> 
>>
>>
>>> ---
>>> Sending this one separately from the rest of my fixes since:
>>>
>>> * It's definitely completely unrelated to the Gitlab 2171 issue
>>> * I'm not sure if this is the correct fix since it's in DC
>>>
>>>  drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
>>> index 1b70b78e2fa15..af631085e88c5 100644
>>> --- a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
>>> +++ b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
>>> @@ -359,7 +359,8 @@ static const struct dce_audio_registers audio_regs[] = {
>>>         audio_regs(2),
>>>         audio_regs(3),
>>>         audio_regs(4),
>>> -       audio_regs(5)
>>> +       audio_regs(5),
>>> +       audio_regs(6),
>>>  };
>>>
>>>  #define DCE120_AUD_COMMON_MASK_SH_LIST(mask_sh)\
>>> --
>>> 2.37.3
>>>


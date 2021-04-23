Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC58369494
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 16:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhDWO0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 10:26:43 -0400
Received: from mail-dm6nam12on2056.outbound.protection.outlook.com ([40.107.243.56]:3671
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229794AbhDWO0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 10:26:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtWB7y2mARoy6fZxLAzm8zulYPbQa2xMUAbjQ9jC1EGZbZ4utvK/hfW14s/mokwtB0O39U827Iqz73xjp2kHyFvlxirByFtBpZhCxuO4BHp2QzFm/vQnZlKQI2AjtEduV4uNiP8vQWjZRe5jOd9rBi3ENcmeOdsSqnxuCOnUAVpQxPFOy4d8p2utvTh6dTatr1UBHz+fx6xXL5GiPhiHA9TrX6yuJZpAjmtklImWcKisFxQuEaQllUskzx6opvAUc/vPYRrBu/z7NTqGu2uHeTq53IRu4s8yiLFmBq3h6H1OyjpHfthwq8Xo/Nl+iZyemdTC4/4ir1s4WwN0t8zYTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXph83cO5mwuEPML48xx/0oiLuC1uj+at/GDv0EGYds=;
 b=Mf+dgDkbK+eRuagSyQ2I/fQq83w3PRQrsR4NvkavNlJODaiIzMbCAkfq9wSXxWQsKn5rIsgwyy+y1gCacJJdV8oelcNZbdmgGNQ0bvIbxy1z2UTIGqM3VCB5dcEKB2An1YjIh9CjYN5nMQ+wCye4qJMrXwcOUrYINZ2YjEfh9g9ThbCja3KfeROv1IQTkk2tG8JCJyMDfB59Z9ufszeCgy2RRYZkkTdKAIlND+1seFFC1xaj26O1aQD785Cvz3NngK3MMiQSR50HQufUqJIUSysPksIscFEgvVArdEeX4Zt8ODPZIis/gtbsGKKgPsbQ+qxO5dkvq3cvnm4dOP57GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXph83cO5mwuEPML48xx/0oiLuC1uj+at/GDv0EGYds=;
 b=SqcZAgn3+F4Fj1cgjXywxTPkpd3BuvBNCfU4tx6tPxvmum1JjS7D1Ka3NlAv5VCcELl8pjktQyAHOY+/ztZaKk/3zNryI9eujXHpvx28vsIobXbdt2QA98fTNeRGZidZc/YikEWp97DU+xhWt7lmurVWM2eboaoy4h2wAXixF9U=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4379.namprd12.prod.outlook.com (2603:10b6:303:5e::11)
 by MWHPR12MB1357.namprd12.prod.outlook.com (2603:10b6:300:b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Fri, 23 Apr
 2021 14:26:03 +0000
Received: from MW3PR12MB4379.namprd12.prod.outlook.com
 ([fe80::c476:9fdf:664e:4f25]) by MW3PR12MB4379.namprd12.prod.outlook.com
 ([fe80::c476:9fdf:664e:4f25%5]) with mapi id 15.20.4042.024; Fri, 23 Apr 2021
 14:26:03 +0000
Subject: Re: [PATCH v2] drm/amd/display: Reject non-zero src_y and src_x for
 video planes
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>,
        amd-gfx@lists.freedesktop.org
Cc:     danny.wang@amd.com, Roman.Li@amd.com, stable@vger.kernel.org,
        hersenxs.wu@amd.com, alexander.deucher@amd.com,
        nicholas.kazlauskas@amd.com
References: <20210423140958.25205-1-harry.wentland@amd.com>
 <49d21b75-eaf7-5e24-7a16-480698e1498c@gmail.com>
From:   Harry Wentland <harry.wentland@amd.com>
Message-ID: <b3ea9558-52ff-0c0b-0766-ad6e55f6e49e@amd.com>
Date:   Fri, 23 Apr 2021 10:25:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <49d21b75-eaf7-5e24-7a16-480698e1498c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.84.11]
X-ClientProxiedBy: BN6PR16CA0008.namprd16.prod.outlook.com
 (2603:10b6:404:f5::18) To MW3PR12MB4379.namprd12.prod.outlook.com
 (2603:10b6:303:5e::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.252.6.172] (165.204.84.11) by BN6PR16CA0008.namprd16.prod.outlook.com (2603:10b6:404:f5::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 14:26:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a9b8c6f-cd99-4a9c-9542-08d90663b8ff
X-MS-TrafficTypeDiagnostic: MWHPR12MB1357:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR12MB1357EB856E996293E64F0D488C459@MWHPR12MB1357.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hK8ahCvr60CEFMmexEvTzrcq5oOo3ZnAXZhl8d0DQT/ureXf7M4zJkP4vTJKL9JNxGD1qXxQpx4gggKCQ0x/RPmJrGsncRKw4WUXhQUmbK6oycG0CD1qV0s5NLQ10Z5pHX8Wz1+dEkoLD9heiCQ3aFucS08FMGAykT/8hPxgt6tuaLfns7FUEFeU1MptvY12GeYg/TKYFeavWeBkkg6D734sjCAVtT66FEV06EXtnMnpmzdRUftddgIq2mPrV9xTLLd2Hrc9UTPJjTt4SotqULm/BUnQQC1LjMymLgnKEifEl62bY3Lbs7ffzwcXbWUnR8mIN1KhVBVS7HiJGIQxdPOrHkCtFdnD8JrlZIjyy+2Gqbs0WwXSdh4tR/R03BE4JAgLWqIlHnE3xKuamAMYcDgsjj7JlLTcPGeyQLGgkMCS5hGWs/Z3GJErWdTJV1i3Mcz7rN2GRXgo2peb8rD7r/q3GkLGbJu77Jjj+D9anFiOzq5EtE7ve5NaeryeDcFnyMka39oRcYGmqiSVQWF4e3Ba7Er2ncF/Q/iaplT/au3rSiHc1o9bbqzEqCyidIGSu96M9DVmzafavpe9HpJNj+y2y6cfm5VljyfhnMNHOUiYQg6+ZI655/bs8u/xx9bOBR2o0m86NAK+BSKSG7OtWQ6vqPuqkraWdNAw6ilj/HPSpixs6VtcaV7kN7QIUtEs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4379.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(39850400004)(136003)(44832011)(316002)(2906002)(66476007)(31686004)(8936002)(956004)(2616005)(86362001)(53546011)(16576012)(66574015)(4326008)(6486002)(6666004)(8676002)(83380400001)(36756003)(38100700002)(66556008)(5660300002)(26005)(478600001)(31696002)(66946007)(186003)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eEdOT2Z5NXJRWURHdm16TTlvUVFxYUtMWGgySGNwbWFqM09RMHVjN0ZJcTk0?=
 =?utf-8?B?eENYNi84RFdwczFvaEFQcGg4WTNpZUtyczNuc1NTUG5Ba2ZaT09BNVlmRXMr?=
 =?utf-8?B?ejdPWFhBU2JVMmhNL0VlbVRNQmdaQ3VXYUFQOGJuM2lvR0NUYkg2ZUg2Ujhw?=
 =?utf-8?B?Vkt0RVVWenMyTWorVnNoNHpsV3RkalY0aVIvbEZEMWltV2doSXZrTk43b2hV?=
 =?utf-8?B?dW1la05ma24vMmliN01YdCthdSt1NmRYNDdkMjEzdWQzT1pYVFpISzZMU05V?=
 =?utf-8?B?WW1hQkZ1YTM3L09GQldWK2EvZlJqQXlheVpPZ3BOK1VNTUpXKzdQUWpIQXNE?=
 =?utf-8?B?ZGc0dE1MalBYRnQ4Sk8rV1JOVXNFUEFNbkdpRjE2TVBwWTcxbE1hRi85YkpN?=
 =?utf-8?B?MGp0a25IZ2tNbCtDbnN0dEROMGxFb2F4djUwR2xLdUJjcWc3enA3VHJIRXht?=
 =?utf-8?B?NnFXc05MNWpPSkNEZ1V4cU9mZEVIYnVMR1JKMzFjbGVxbmtLcjNuaFIrLzNm?=
 =?utf-8?B?SDE4aGZvUEdJdGpIdGlQYjRPQ1VkR2VuQnNkREZwb1BZUGh4dXMwMzFxS3pV?=
 =?utf-8?B?TkdJeEEzcUd5QTAyc3FvTDluNzliSXUrMytVdk4vaFVmK3VvbzhTNWJCRDVV?=
 =?utf-8?B?Y0FBNUNhUkVNYkNIZk5WcVpTMytLVjJvV3FrbE4yNi9BQVZTVExLaDBDWVdC?=
 =?utf-8?B?S1ZRM09oQkIrVTJFaGMyRElkbjR3RjFQaTdoM1JJWXBzWTl5bmZzUEQ5SjNE?=
 =?utf-8?B?MCtVMXh6S0Rka2pQWEhOZU5KRDF4YVFUbE00TnNUcldHRk9NY1NrOHFnbndY?=
 =?utf-8?B?ZHJxZHlwUHViNzBzU2pZNG9JWkZLTXl3QWQvZWF6VWtHVE1SMmpCNWs1V3g3?=
 =?utf-8?B?RUJaTThUaWpqYUxrb0JxcDNvRmNyNFRCcFo5U0dDd29RQ1k1cDNYT1p6ODh4?=
 =?utf-8?B?MTJ2akUyWmN6dW8yQllQQUxkZzZQUnVnamZTNG5aa2hDN1grb1FzbVR4c2F1?=
 =?utf-8?B?ZHAxY3pCcnFFM3lTN2gzVlJqd3h5N1UzL04xODJqdlYvcEc1czZoTnBvaHdx?=
 =?utf-8?B?dERzbFh5WWh1dURaQXlCc1VsVEVoQU9sbUhSb0FrMDVjc3dac250cnBLWCti?=
 =?utf-8?B?eHpES05VOG85eWpZbDlud3BsSkVqTzRmdjdEaE9QK0dFbG0xMk8xNEZ3Wmd0?=
 =?utf-8?B?d1VtM2NuYTJ1UFNpek9OVUZoUjhSVlR0VVNNQm0wbW5MVllMbVVJUW9tTWcr?=
 =?utf-8?B?RldyNE1uUk91UHpiWERJS0tkSmtGZ3RUVGplMHhwcmg5RHhoQ01rTjVzeWg2?=
 =?utf-8?B?ZW5CVlowaEJlSnptZGVadFpRdVJMZGlpZy8wb2xzMGlPZ2ZPNlVUWVZrOVRP?=
 =?utf-8?B?WDcyRWdlOW05dDFveXl6KzRnMEN2dWEyWkFwY0Nnc0hFYUVIWmtHRDdJK0hU?=
 =?utf-8?B?OG16a2JwMHhZbHRnVGNVMEFqc3NZMVh3c2FXRkhnWThnOTdJUFhQbHFtOW8z?=
 =?utf-8?B?MGIrdFNmUWRQaWxnL2R1cHFuMUphaWsrelFGSmFGOTdidzNNSHdYRUpVUXht?=
 =?utf-8?B?b2djM2V6dVJ5Wi9hMitob0tsZUdOQzZPcFF3TFJnUUNZbC9TRk5ITEQwV3lT?=
 =?utf-8?B?WXF3S2Vqa3BEZldwdmlSVnpScWwxU1ZsZjF6OTF5SG03ajU2U3ZyNXZBd3VI?=
 =?utf-8?B?Qmo3VDhLYUJ2a0grVjBhN0hmSEZJd3pvMWUrWkt4MTN1L29ZWFN1aU02UFNq?=
 =?utf-8?Q?jg6eQqhpmqGVfISwVoJ9nCYH7olIUn5RaOAUkxy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a9b8c6f-cd99-4a9c-9542-08d90663b8ff
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4379.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 14:26:02.8038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uQu4l9tZ2u6CQdZmRCBe1RZWN4s1K9ke8UEtNPPeZw3WQ4rJHgbeBHDDdaSEbwVsASkD4SsGM4efDHA2T3Fvjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1357
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-04-23 10:18 a.m., Christian König wrote:
> Good that this has been found. Just a curious guess, but have you guys 
> checked if the src_x and src_y are a multiple of 2?
> 

That was one of my first guesses but I still observed the hang after
forcing src_x and src_y to be multiples of 2.

> Might cause problems to try to access a subsampled surface if the 
> coordinates doesn't make much sense.
> 
> Anyway patch is Acked-by: Christian König <christian.koenig@amd.com>
> 

Thanks,
Harry

> Regards,
> Christian.
> 
> Am 23.04.21 um 16:09 schrieb Harry Wentland:
>> [Why]
>> This hasn't been well tested and leads to complete system hangs on DCN1
>> based systems, possibly others.
>>
>> The system hang can be reproduced by gesturing the video on the YouTube
>> Android app on ChromeOS into full screen.
>>
>> [How]
>> Reject atomic commits with non-zero drm_plane_state.src_x or src_y 
>> values.
>>
>> v2:
>>   - Add code comment describing the reason we're rejecting non-zero
>>     src_x and src_y
>>   - Drop gerrit Change-Id
>>   - Add stable CC
>>   - Based on amd-staging-drm-next
>>
>> Signed-off-by: Harry Wentland <harry.wentland@amd.com>
>> Cc: stable@vger.kernel.org
>> Cc: nicholas.kazlauskas@amd.com
>> Cc: amd-gfx@lists.freedesktop.org
>> Cc: alexander.deucher@amd.com
>> Cc: Roman.Li@amd.com
>> Cc: hersenxs.wu@amd.com
>> Cc: danny.wang@amd.com
>> Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
>> ---
>>   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c   | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c 
>> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> index be1769d29742..b12469043e6b 100644
>> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>> @@ -4089,6 +4089,23 @@ static int fill_dc_scaling_info(const struct 
>> drm_plane_state *state,
>>       scaling_info->src_rect.x = state->src_x >> 16;
>>       scaling_info->src_rect.y = state->src_y >> 16;
>> +    /*
>> +     * For reasons we don't (yet) fully understand a non-zero
>> +     * src_y coordinate into an NV12 buffer can cause a
>> +     * system hang. To avoid hangs (and maybe be overly cautious)
>> +     * let's reject both non-zero src_x and src_y.
>> +     *
>> +     * We currently know of only one use-case to reproduce a
>> +     * scenario with non-zero src_x and src_y for NV12, which
>> +     * is to gesture the YouTube Android app into full screen
>> +     * on ChromeOS.
>> +     */
>> +    if (state->fb &&
>> +        state->fb->format->format == DRM_FORMAT_NV12 &&
>> +        (scaling_info->src_rect.x != 0 ||
>> +         scaling_info->src_rect.y != 0))
>> +        return -EINVAL;
>> +
>>       scaling_info->src_rect.width = state->src_w >> 16;
>>       if (scaling_info->src_rect.width == 0)
>>           return -EINVAL;
> 


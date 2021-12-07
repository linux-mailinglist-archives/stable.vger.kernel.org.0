Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5274546B3C2
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 08:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhLGHY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 02:24:59 -0500
Received: from mail-mw2nam10on2067.outbound.protection.outlook.com ([40.107.94.67]:50976
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229815AbhLGHY6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 02:24:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fH+HPsH3HTiI9e47Ob7cvDl1s4Zusj1ZZA+GAt0yKBxtQQ8TXDn8he7guQeuLte/KitlsbX/MhfnxPAtoK4qx5dH1IfGMUVwo1bY9zBNOws1wPLJbMYxaymufL3pHUB5lA0AzzOyutaised4XrXK1QZuSJ4BgW/OAgUPW/V3iCHlgH4+shIT1bWSQWAu5h/GXiyjUFl8+N7/y65bxO1oYAp2ywYrYsT4OwmRHnGAtRGpIDUAiNDyypwkWANd42Xy8HwBfsCDJWIFguGqQQdS8aAOAiInPlIQs4OnZYdeUYzqirRRZSJzLvWWnY1njEE8vDnQuUkqfVXutDx1WqHBig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0fwSer26iKXrjNx2euwfV5PHiUwAvPTXEoL7UJHf3Bc=;
 b=CNYW1s+QMvrDKaPXlkTpFlwYk83zoNtxjD27MZXikDMweUeg/6ZPbzy++QG5e+ykHivXyM+I8ZFDaekq06kqT1sYbmt2dJSYykjXnSBA/5IMLeUS0NiI4WQ4hJMxezeEVqBB0z8yqG/HPSylDlIlb0VywU+390q74qzDnO2NZ3nW9t0z+fpKerBkBypr13BFOAQzS1KbiuG0SMQ6DkvSBya+Q+CEXh1CJRfPfZlbjWyfK+e/nXfBc6fmVzARnZyKLCrkb8Nu9NcmR3gMV4q3XMBnqQ1z1re+SfDz8xxVF6WF/6DXB/QJP/tDqcAwOxcM2+mnUgAmQRx+C0nk29ccIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fwSer26iKXrjNx2euwfV5PHiUwAvPTXEoL7UJHf3Bc=;
 b=a0osU0vebp9wvG3L6xLXL3fWMLzjHm3tbvOjSICJotQvqoxHfcCa+RiebXzi11RQQGXaCPepOdapl5GPtUsYDn3dFxXprrDtKsTXNDRBINIx9TBaEje1EaRP7rMQgAbakXf2cQ4/dhH8NnXjd5gBUUEZc9FSPjmdcjAk9RRzS5M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14) by MW2PR12MB2556.namprd12.prod.outlook.com
 (2603:10b6:907:a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Tue, 7 Dec
 2021 07:21:26 +0000
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::d16c:a6d5:5d2e:f9d4]) by MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::d16c:a6d5:5d2e:f9d4%12]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 07:21:26 +0000
Subject: Re: [PATCH] drm/syncobj: Deal with signalled fences in transfer.
To:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        dri-devel@lists.freedesktop.org
Cc:     david1.zhou@amd.com, stable@vger.kernel.org
References: <20211207013235.5985-1-bas@basnieuwenhuizen.nl>
 <05f1e475-3483-b780-d66a-a80577edee39@intel.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <7d2f372f-36f5-1ecc-7ddb-25cf7d444e5d@amd.com>
Date:   Tue, 7 Dec 2021 08:21:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <05f1e475-3483-b780-d66a-a80577edee39@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR04CA0011.eurprd04.prod.outlook.com
 (2603:10a6:208:122::24) To MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14)
MIME-Version: 1.0
Received: from [192.168.178.21] (87.176.191.248) by AM0PR04CA0011.eurprd04.prod.outlook.com (2603:10a6:208:122::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Tue, 7 Dec 2021 07:21:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5be20a0-6d6a-471c-1863-08d9b9522e4a
X-MS-TrafficTypeDiagnostic: MW2PR12MB2556:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB2556400F771389F0619E7E71836E9@MW2PR12MB2556.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5o8bxW9Sw1EZ6ywAo5MQnPmIWyJ/Sw7ifmYWb+zQS7XCHBVnVG7VAyp2kviBk9+NihPHo54ZrEJY0/m/bzfvGMzIjtwMx3gOMtc6SFGHpBID0Eg4bInUz93FMhYCyNhhL8pwKbHHqWpzQ0nz/y1Jv4eCVWlYPFLoiGY+3vKku48Jr9g5Z8XmXi05MyW1YHP7wWCJvBdSGmlVeYFY4PIdsZBvzAsud49iXrqBKyn5iPYBgmkTctOUErWLp3y8wHW5pvXC3eKrdr6JBlNM38lHI1KlR0hKt1Q/ReJ1zXcrBEtk5+D7mG/HF0L69NaR4Jihwut7mjgZuRgUwhCp+l9BGdi7rWVE2RDkZZF4ducAkRuih80NttLEh9hxfq1S8Sd5rzGezvJSU/V6EhbWZdATvBOj6Gj8Gp4329SjnUTLf9wrS/qZHW33EWc+Et6AZP4QMvKQLICh6ARMdSL+qi30Q24dV8Vd0mPzWck7og4pdEo57zxsPVCdFH+UohXXHf+e1Kcvy9MkcLnVSRRdgW7uXmMwPd0B7y6LK6HX9vNygZv4G4K71Zblvb4d8LhuHP4SWfou4e8EIoHE27Wzsqi24NhvaE9MEjdEf4toqWo0k26zF9nn0DQqXPigngwCmc04KqeBZBJ8JXV7z9SvAHFeSNniWc2iA4TTySz4Zpt4no44Y1oSXrhbVhs2V9EHmXg6smPZEwvBQwrpNnn29I1HHOwU2OWirhgdlNxw1Ok+p10C2CkTCrA7DwF0MFvU8XuO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1201MB0192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(31686004)(66476007)(8936002)(16576012)(186003)(6486002)(86362001)(26005)(316002)(66946007)(36756003)(8676002)(6666004)(38100700002)(110136005)(31696002)(83380400001)(508600001)(5660300002)(2906002)(2616005)(53546011)(956004)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHBxQm5NWGhFUm9BMEdWUVJmdHR1ejdBSUNNWUFoSE12Wll0Nk5mQ2pVaVo3?=
 =?utf-8?B?eGlad1VkdUFRd1dHTEUvWCswcVhSWG5XaDlETlNlUENUYnZLT2liNWhTY05x?=
 =?utf-8?B?T2VxUXdOaUZ3RDNRa2Z5ZHllQWVhVFlwN0UwcWNsM0U3cmxCOThpTmhaOFlN?=
 =?utf-8?B?c3NaTFFqOFplRzhYbUJLOHpUK29VaGRuMHA4aTZSQWRQSkFHR1hXSWVZaWZr?=
 =?utf-8?B?a253aGpWWlpTSUxoakxiR1pncmQvTWUwZXZHanZDdHF4QnJ0VWd0ajl4RjVp?=
 =?utf-8?B?M3RPdDlnNjFhUnpkZ0F5ZUg4NncyQ2EvR0o3cWFQSjY4R2wzZEdSa095TS9N?=
 =?utf-8?B?UEdJRGxrWU5mK3lrVjF3VHprelhwUzg1WWdnMDl5M1Uwb1NqeDVrblBDNzlS?=
 =?utf-8?B?eXM1Vnl6SGlCMG9FYWtMdEFPSFd5eHVYVVBJVmpNL1I2cmhVZjhTdzlnOXZS?=
 =?utf-8?B?RmdqanVQNVRlb1YwOWsreEt0RGRTV0REdXA1eHB5VFVHcU9MVHRpNWhwTTNS?=
 =?utf-8?B?YjRBRG5QRE1wU3FhN1RIcVBpeHNnTXZzdlFOTk92NmJzYXZXRmVzbWI0aS96?=
 =?utf-8?B?V2VmSmV5VG42ak5YOVBvOWhPTlJsZGZ0cDJMa1dsOCtPRW9IWGhwRDhlYlgr?=
 =?utf-8?B?S1g1aUxOU21GZDZ0cUYrb29XY2dpRU1wT2VkQ3RYK3ZKdHZpTVc2UzZmZC9N?=
 =?utf-8?B?NlgzWS9wSTAwOEZmMEw2S0VkWkZtSDhQTldudE9ZMU5zQTM1WThkRHF0eSt1?=
 =?utf-8?B?eWdITmxLdWJ0VENqSGlkVmczSHJnZ2FIazh2Vi9jYTNUeGc1UnZoaXNBS3lu?=
 =?utf-8?B?SEFyRXBQVlUxeU84NW1QS01DSFdER1ZPSjJsSXRSRlpyRHBSaXJnRmFZNTB0?=
 =?utf-8?B?cDBBZkJQeVVCWkRtZVgwN09RdW5DV2RocnJDWXdTTUd3MDJqaEtucmppc00x?=
 =?utf-8?B?QW16N1FvWDJMV1dwVzBWWmIrNHl5dC9zb05pNUhoRXdNSHpWRWh2QW1vV2dv?=
 =?utf-8?B?VEw1Yi80b05INjlSZG85emhyb1dhWmk2c092RGk3SVBzdGgwd25HQ2ZwZWxY?=
 =?utf-8?B?a3Iyb1dYck9wd2RJRER4aW1HQTcrNHF0R0tXcTN2b01pNGRsM0N3L04xTWJI?=
 =?utf-8?B?dHlZaE1Kb0ZsUGJrVEpXZUlpZWlFeU1kdTd2VlcrUmwwMmViTnBDK2lGbGYx?=
 =?utf-8?B?R0RQVW1zWkVWVHNoc2lTN25FK1Q4cWFHdjBScEVWYkJwV0dKa3Nqd280NitS?=
 =?utf-8?B?MUZlbi9NbUs4N0JmMW9jL3VzUklGTllkRVpKTHZDMUZKcjJCSzVGOTkvWTM3?=
 =?utf-8?B?TkUreU1mbmdjQVpLSU90V29IZ21UVTVnT0hQVmw5S0pIaXE1bHkxWEJWNUF2?=
 =?utf-8?B?RmJzZ2hnMXAvSHp5cmYwUWo2SFF6ZUVabVdUVEsyMEtIL2Y0NndrSk54Z0FJ?=
 =?utf-8?B?d1ordVRkc3hCMVNtTXhrK3JLa2t5aTJ4dklXeHdtd0NpbUJWTVBBTyszZ2dB?=
 =?utf-8?B?NkhqK3FYNURvSW9UYXlzaVI3YlJONUpsSGY1OWNqaVBDSlZEVGUwdFBpcWhD?=
 =?utf-8?B?UlBtdVYxaDFyeVAwTElQM3VoMkV2UFBMTCtXaE4wdDJQQU9zQXhKdElDNjgx?=
 =?utf-8?B?V3AzSmVrRzR1U2JkZkV5dlFCMlNCYWFaL2VvRzB4WjNKRjcyd0V3VmZuYlh1?=
 =?utf-8?B?dkhNQzYxQlJKQWJnMmJpZGgyRFFoN2pqbXhTUmgvQ2ROaFcwY2xtcHc4SEpl?=
 =?utf-8?B?RTEwZ1F1SzVoSW1JeXNRZWd4RU5KK1J6dGZjNUFkMFV0MHd0M2UybHJDMkpw?=
 =?utf-8?B?R3UvY2s4ZmNmZjNCVEIxcDdhWUZRWjdQNDJvZ1VnQmZFTnN5bU10eWVzRUo4?=
 =?utf-8?B?YmVkM1BVV1puL0IwNmVPQ2ZzZnlZaG5NQ25DTnQ5QUVJU3BzMTNJUVJ3WW1l?=
 =?utf-8?B?YXpFWGtXZG0rbUhnNGphcXpmNlE5c0ZTVE0wdXJWWTIxOVFUYUJqUlo3QjlW?=
 =?utf-8?B?bVN5M3lwMW92UUpUOHRaV0k0Wk9taEU4R2crYU5pV0phYnRXOHpVTGlmK2VE?=
 =?utf-8?B?anVtTFJwZmV3eVp6YlNGSkdzTkRneE9QaUhBMXpRTVNSODVrVFVEZjBNU3lX?=
 =?utf-8?Q?NN/M=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5be20a0-6d6a-471c-1863-08d9b9522e4a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1201MB0192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 07:21:26.6139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pxjhzaRvzSIFOWAWlvahlhFb7bp1x08NtP4SCz8P6M6bQ9Aodo67kDLUSlnwDOnN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2556
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 07.12.21 um 08:10 schrieb Lionel Landwerlin:
> On 07/12/2021 03:32, Bas Nieuwenhuizen wrote:
>> See the comments in the code. Basically if the seqno is already
>> signalled then we get a NULL fence. If we then put the NULL fence
>> in a binary syncobj it counts as unsignalled, making that syncobj
>> pretty much useless for all expected uses.
>>
>> Not 100% sure about the transfer to a timeline syncobj but I
>> believe it is needed there too, as AFAICT the add_point function
>> assumes the fence isn't NULL.
>>
>> Fixes: ea569910cbab ("drm/syncobj: add transition iotcls between 
>> binary and timeline v2")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
>> ---
>>   drivers/gpu/drm/drm_syncobj.c | 26 ++++++++++++++++++++++++++
>>   1 file changed, 26 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/drm_syncobj.c 
>> b/drivers/gpu/drm/drm_syncobj.c
>> index fdd2ec87cdd1..eb28a40400d2 100644
>> --- a/drivers/gpu/drm/drm_syncobj.c
>> +++ b/drivers/gpu/drm/drm_syncobj.c
>> @@ -861,6 +861,19 @@ static int 
>> drm_syncobj_transfer_to_timeline(struct drm_file *file_private,
>>                        &fence);
>>       if (ret)
>>           goto err;
>> +
>> +    /* If the requested seqno is already signaled 
>> drm_syncobj_find_fence may
>> +     * return a NULL fence. To make sure the recipient gets 
>> signalled, use
>> +     * a new fence instead.
>> +     */
>> +    if (!fence) {
>> +        fence = dma_fence_allocate_private_stub();
>> +        if (!fence) {
>> +            ret = -ENOMEM;
>> +            goto err;
>> +        }
>> +    }
>> +
>
>
> Shouldn't we fix drm_syncobj_find_fence() instead?

Mhm, now that you mention it. Bas, why do you think that 
dma_fence_chain_find_seqno() may return NULL when the fence is already 
signaled?

Double checking the code that should never ever happen.

Regards,
Christian.

>
> By returning a stub fence for the timeline case if there isn't one.
>
>
> Because the same NULL fence check appears missing in amdgpu (and 
> probably other drivers).
>
>
> Also we should have tests for this in IGT.
>
> AMD contributed some tests when this code was written but they never 
> got reviewed :(
>
>
> -Lionel
>
>
>>       chain = kzalloc(sizeof(struct dma_fence_chain), GFP_KERNEL);
>>       if (!chain) {
>>           ret = -ENOMEM;
>> @@ -890,6 +903,19 @@ drm_syncobj_transfer_to_binary(struct drm_file 
>> *file_private,
>>                        args->src_point, args->flags, &fence);
>>       if (ret)
>>           goto err;
>> +
>> +    /* If the requested seqno is already signaled 
>> drm_syncobj_find_fence may
>> +     * return a NULL fence. To make sure the recipient gets 
>> signalled, use
>> +     * a new fence instead.
>> +     */
>> +    if (!fence) {
>> +        fence = dma_fence_allocate_private_stub();
>> +        if (!fence) {
>> +            ret = -ENOMEM;
>> +            goto err;
>> +        }
>> +    }
>> +
>>       drm_syncobj_replace_fence(binary_syncobj, fence);
>>       dma_fence_put(fence);
>>   err:
>
>


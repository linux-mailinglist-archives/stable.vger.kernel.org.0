Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4186B46D800
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 17:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbhLHQZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 11:25:11 -0500
Received: from mail-dm3nam07on2060.outbound.protection.outlook.com ([40.107.95.60]:12769
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236757AbhLHQZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Dec 2021 11:25:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWQW6ShbmrIMvo1NiVpPt31x0zm4taoEGApfWzGC9BsAvPZfqSnPf97BNyxq93hTAz84O/rZKLqnh4eNN8CDlQfXNu1/U9Ym6vGdYkZRXFOqGVuRxMfrWExSVRrGrzIAb5N7FA1GFxFU1/q3ynh+XKRWr2KfP4rLb6pkrUwWpiDEwGjZC1H5ZlGItoEwtoPFNuCpfZm7ubIUgmLoXSm6lo+LHV9fKk/5DUKyn9zdL2ihz9+BK5slUxeNKgDA0UK2h+1BN4eaPoT9f3av3Gz2QsBwkAVLz+W9yLM4tcXhA5q+z5SlaT/P8m4AILhXaoZcKiRb8+rDLFge6MWEKMpLmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w2wJQmVPpVyriPk1g6wCawujYTRlFG4aesQ4lXSTKa8=;
 b=igAXV6kpTbq+bCCuqASVWhGd9WhJvEP1ZFagUcpqZXrlklGyzxpD+K/V3BEAJbRlakgJu6E1nNKDNQMX/Igx5ys5hB/fMaTJ9NecsOCEfBUzUu57c3lXvlBO2y2tATqGcq6CU/zqXAOfVu3Bn76hGcA3FGs84W7+qQENOWxNwYOT88hfJGsLG0UbODJCHZFlSg5YJQuFlTNVTvqCK6NL7HSmZNGj5UrH+jCYB29D2fR9I6QkUzhc3+0w2Tzqf5R97fv6+0qj2LcvuYb6aYRShcwLefj+llj5cvLgnOdQoBdicUbdY5Huow/AfYLfbR9m7eU/kD4ljEX9rn7cUi8jEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w2wJQmVPpVyriPk1g6wCawujYTRlFG4aesQ4lXSTKa8=;
 b=r9nj2Hqj6dUb4+uMHePO4zwh3eoMLHdemz9jZiu9sgue//16V1VMZ52p7POEY/SFc1BvFkDdb2GqsplKBtpfAqC6bUHEHg7/9HcB6ZweTcbklEykaWe7L01KYDvlhQQC7xt4U8JZXVurQ+Ags5XpTsLH0ru1KOQk6dhB2t3wY/A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14) by MWHPR1201MB0238.namprd12.prod.outlook.com
 (2603:10b6:301:57::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 16:21:37 +0000
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::d16c:a6d5:5d2e:f9d4]) by MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::d16c:a6d5:5d2e:f9d4%12]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 16:21:37 +0000
Subject: Re: [PATCH v2] drm/syncobj: Deal with signalled fences in
 drm_syncobj_find_fence.
To:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        dri-devel@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20211208023935.17018-1-bas@basnieuwenhuizen.nl>
 <2e0269eb-d007-4577-d760-343ccfb05c9a@amd.com>
 <ca5724e4-85a7-11a7-51fa-1152e0cf403f@intel.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <56b31ce3-5742-0c16-2649-58526f7ad037@amd.com>
Date:   Wed, 8 Dec 2021 17:21:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <ca5724e4-85a7-11a7-51fa-1152e0cf403f@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AS9PR06CA0124.eurprd06.prod.outlook.com
 (2603:10a6:20b:467::33) To MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14)
MIME-Version: 1.0
Received: from [IPv6:2a02:908:1252:fb60:23fe:5a01:cda7:6599] (2a02:908:1252:fb60:23fe:5a01:cda7:6599) by AS9PR06CA0124.eurprd06.prod.outlook.com (2603:10a6:20b:467::33) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 8 Dec 2021 16:21:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e4f60db-3027-4495-6043-08d9ba66cebb
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0238:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB02380CA3F214793BBEABA9A3836F9@MWHPR1201MB0238.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tme6g+quvY/Ek1AtW/lpVQs3PfWQiWTec6gs4XyjqkfG0SLC5ITOFyk2BPurpRrebYe5tLN+Ui+Kp0WUIkO2JzsLBrJn4zc3JoDPyXhOQFnzQwn8MK3thwnlN2SiHdX+Gu0DKXHf+56oIVP5igEHDJWONei4g4J/IGwtVXbj29yBjIti+c/7KqSZp+oH2dRPYGxGzeLaZt5rsjZznVPr44h5KoMisCTEvYR7YnlsBsPUkw/X0OzXso2hPUnJTNAMwYtzlDM2zPWn44WQESN9kETKs08NL8bBvQo54j/QfU+IdZ10Qo3TMCKVXXcsRLBzwUSnli/wMTfbefyaV28rC02r33qbM7y+mnsFNdecM7thi1lUMusG9Lk0UQAfAy18aaybiSSkXwLwRW0pWeln6Obo1KhfAkLRMzMuu9NK/F1KOwTGhSd72dh0fpoCX1sNo+xaTdO3L5FygopRzftCo3fXGYkCCESpFABu2aoqzxVJn2RbKXFwR0+gS8u+4eRfE+jcSTOrA3n/N4planGwHxK4+bGFXDjEBgeWuW8WML3gH+Dcbu63LXYWl2ZmiJH9UZWdqzetPjcF2bV+GC+iqIYCGqdsJv3RYGWyyTsu/Ie++/3zPOG2BCK1SpqM/peEproHDU8mz+hF8Ccz2U3l6RgeZtxr+5k/hIwvN9HwipQPbyn+FkLfEGWk8xHMdqkcfUawTHwDU1iCYrjGsMqS8bfGa8H1hwrIvuZb/qaxvsYMeY1R/1oQ4hbRd7T0TDTR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1201MB0192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(110136005)(38100700002)(186003)(66574015)(31696002)(83380400001)(6486002)(66476007)(6666004)(66556008)(4326008)(8676002)(8936002)(31686004)(5660300002)(66946007)(53546011)(508600001)(316002)(2616005)(36756003)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUVPZ2ZyS1IxQXMzejJiR3pZSUtSTmxwYWNidDJNUTZDenp1YUxlVHM0Zy91?=
 =?utf-8?B?c1pITkk4Nmwwa1hwdnc4LzA2cThPNDlGWkJpOVhhclJnRXc4NFVmTVQyemFr?=
 =?utf-8?B?dTlSWUtDUmkxL3M1dERIUFJ6UGNBZlVFS3pCR0J6cGhBeE9Bd0lMeXY3NHFa?=
 =?utf-8?B?OUVIN3ArSm5oUnFkWEl6SXRYYVBsZkN4djBYMFNDVCsrZmJrU2FTYTIxeEZQ?=
 =?utf-8?B?SVRMejlxUHRTLzVvMVNPZTNVN1VYVHlYVThiS3N3SzhxcUxJOU8rbmtRdXVR?=
 =?utf-8?B?L21YTVFaVDlNWkhlaklKcjBHeVRQc09hbThLc1B2dThiNzdCRGxGRE05Ry90?=
 =?utf-8?B?SmpzNDJZckpZeTBFN1BoNDFrRFRjQUY1Q1ZMZitGcjBqV25UY0Eyd2RoMktm?=
 =?utf-8?B?N3ZxVXJOaDF6TnlqMjR1ODJBdXlPRk5yWURTRVc1MnhqZkh0UTVGRXFjdVRh?=
 =?utf-8?B?ekd6aE1pbHcwY2ZJK1daRVdFV2hSdmJnNDZ1Qm5TZ1FMQzFvd3BMV042U2tR?=
 =?utf-8?B?LzFmTnprYU1QQjBmZXpIZnBXMkoyVWg4ckMxTzlaUGozRGNJQkYzNlpYWlFR?=
 =?utf-8?B?RVZudFc4Rzk1UlBZeGVWY2pucllXNUg2d1lrQUxvcEpLWTZiUTBseFZoZEtK?=
 =?utf-8?B?eG0xTWxDSmtTRmdUa3lYSUJLOVlRbGVMc1lTZ3h0SEZ3MVlSdUxza29SWmh6?=
 =?utf-8?B?SGVJSUZtYzI2ZytQVUUrNVBMcFVibHIxZmRDeXVEK0VTVlkvdFM1Z3BqRmJ1?=
 =?utf-8?B?a1loUUJtdHBpaGQzVHo1RURhUjRwZGhoYVphTXlxb1UrUnlVQ3JOZnBtT2hN?=
 =?utf-8?B?K3NXWUYrSmJBbTJ2UVpsYjVtYzlOeDFzS2I5dTFKTW1VaUlGK2JrZlJkbHRm?=
 =?utf-8?B?YzZOL2RwRWxPRitnSzM4czZLRmt6NytsUEpISk5oVUZjQmxvejBjWVhtY0JW?=
 =?utf-8?B?VEFIYndUSE53S1lybTJPRlFZOWYva2J6UVBtTFRXdEUyYThRRjEzaDFaSExi?=
 =?utf-8?B?ekxlS0QxWW94MmlncnVCdUFEUnVnNW92TjJ6aHVRb25zdTZpalZwQ3kzM0ZK?=
 =?utf-8?B?WUkrcVBnWWFVWnRMeWRSL1ovTy9ESExadTBRczdmeGUrck1ienFiei9pRzZn?=
 =?utf-8?B?bnpvUGdjaktJMlB0NTh2MWxCUzNoQTdBMnd1elAra1Yrb25kVVNnaDdEK28r?=
 =?utf-8?B?NndOMXE4VWNWWVgwZCs1cGVPQ3ovNFh3R0thZHdnV1loWnZUWmtLOVhIemxG?=
 =?utf-8?B?OWJyRXYwREQ1bXJzb1FwRjc1UGJDN2hIQXpGRmU0azhuZ01GV0E4aVdrKzdP?=
 =?utf-8?B?Z2ZIRnQ2YXVRWTJtNVErTkg0dlpwLzZUck1WK1gxWk4zSUVMUHR2RVBaSE5t?=
 =?utf-8?B?aHBWYjczMGhHNkVYcElvay9uR3ErMHN6NGlNN3NIQ21mTnhwaTNjdTIvd3hr?=
 =?utf-8?B?NThIMzdoNFFOaDgxY3VybTN5eE5XZC9pcFpHZlN6MFBSbGxmeUxQcnlCUm1i?=
 =?utf-8?B?ZkNSS3dRblpUaUczVGRCbXF2VmJSSHlaZzM5aWVtd3FpdWxVaFBFQzhCRWM5?=
 =?utf-8?B?NjVNYmxrMVNTWUxJMm1XVTJvYVRFTlZqN1Nnb2dESEJQUTNpdjFBVjJuNGE4?=
 =?utf-8?B?MUlBY3FXZGo4VFRGMWg3L3lOUVhHbm1rU09JNWNDb09pVlFFVjdjREVwYWZh?=
 =?utf-8?B?RUlUYlY2TnNlNDAwS2kxblpjK3ZhTlNjSDRoZWx0a25iTWNvY3hzZEJCdUQv?=
 =?utf-8?B?UFhseHplSGJqOU1LTndnUTl3MVpJeDhCS2hENEp4OVRNa0tDMVhTazA4cDZr?=
 =?utf-8?B?SWlad2hiUnlrWXlGeU1OdzdIa1RBeWptTDF6Y1RQTFJpS09pdEpEWEk0bk9n?=
 =?utf-8?B?enZRNDFtanlHaEpDeHFZMFJCQUpVL1VEY1JQSkhuTDNoSWV3V0dEZ0J3Q3Bo?=
 =?utf-8?B?WE9DUDFPMTZaQVFydDU4c0s1c0s4YVFaUjA1a2tDZU1ZVktPd1Jydnc0bmdk?=
 =?utf-8?B?eit2NGs4ckZnamVmWnBObmJ5aUlIOGhPZGtPMHE5RHZueUlXNlYvWVJJT0Vm?=
 =?utf-8?B?dnpuSGRZMWxYN1RaMFQzR2lMa0hSQlpablo0SzVZWG41bE84anYyRktyb0NV?=
 =?utf-8?B?ZWVBMW03TFZyNC9zWWxoZTRMVUpPWWhRQmVVMzFGWnNVMTk0c2NsS2dDdWo5?=
 =?utf-8?Q?15VZAnJCoXY4kjOu1bKWvhc=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e4f60db-3027-4495-6043-08d9ba66cebb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1201MB0192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 16:21:36.9621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iCOAhx5Blqx3DN6xwkC7tcAHuZcRaQDkT8gmWgzbqnfq+4ODViXtAWw3EK4fD1T8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0238
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Am 08.12.21 um 11:08 schrieb Lionel Landwerlin:
> On 08/12/2021 11:28, Christian König wrote:
>> Am 08.12.21 um 03:39 schrieb Bas Nieuwenhuizen:
>>> dma_fence_chain_find_seqno only ever returns the top fence in the
>>> chain or an unsignalled fence. Hence if we request a seqno that
>>> is already signalled it returns a NULL fence. Some callers are
>>> not prepared to handle this, like the syncobj transfer functions
>>> for example.
>>>
>>> This behavior is "new" with timeline syncobj and it looks like
>>> not all callers were updated. To fix this behavior make sure
>>> that a successful drm_sync_find_fence always returns a non-NULL
>>> fence.
>>>
>>> v2: Move the fix to drm_syncobj_find_fence from the transfer
>>>      functions.
>>>
>>> Fixes: ea569910cbab ("drm/syncobj: add transition iotcls between 
>>> binary and timeline v2")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
>>
>> Reviewed-by: Christian König <christian.koenig@amd.com>
>
>
> Thanks!
>
>
> Acked-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>

And pushed to drm-misc-fixes.

Thanks,
Christian.

>
>
>>
>>> ---
>>>   drivers/gpu/drm/drm_syncobj.c | 11 ++++++++++-
>>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/gpu/drm/drm_syncobj.c 
>>> b/drivers/gpu/drm/drm_syncobj.c
>>> index fdd2ec87cdd1..11be91b5709b 100644
>>> --- a/drivers/gpu/drm/drm_syncobj.c
>>> +++ b/drivers/gpu/drm/drm_syncobj.c
>>> @@ -404,8 +404,17 @@ int drm_syncobj_find_fence(struct drm_file 
>>> *file_private,
>>>         if (*fence) {
>>>           ret = dma_fence_chain_find_seqno(fence, point);
>>> -        if (!ret)
>>> +        if (!ret) {
>>> +            /* If the requested seqno is already signaled
>>> +             * drm_syncobj_find_fence may return a NULL
>>> +             * fence. To make sure the recipient gets
>>> +             * signalled, use a new fence instead.
>>> +             */
>>> +            if (!*fence)
>>> +                *fence = dma_fence_get_stub();
>>> +
>>>               goto out;
>>> +        }
>>>           dma_fence_put(*fence);
>>>       } else {
>>>           ret = -EINVAL;
>>
>


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E58937FE4F
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 21:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhEMTiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 15:38:54 -0400
Received: from mail-dm6nam12on2078.outbound.protection.outlook.com ([40.107.243.78]:20321
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231649AbhEMTix (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 15:38:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lS2UKqs3r2QwYi7m07gid3JHff6kDhk4GeEt9tUWLkGFkEHEbJWOJZ+2yhGVsPbL/lSjRlrrqvhriamF7P2W/SW/anzIAiyagdyUQDby0WbJZoE4WoqSaI4nmTyzGXGbg1GtCi4mUyGdSknxaMofO9RAsRLjQmLak8QpLS/NCSumNmvP4fUhnCbFbxCbrhTh5+xMC9iHy0q8fTJ50JnB3e+v+BPa62gC+IcVQ77jQz1bQc/cW51FwN5mXPU+EML7YFQSWkzkZ5fH51vCvXT/zlCuMZDTCfop7Z971E3rfB5kO/YtDQnBccFxNYB5z8zAwmrW0RRPOpKNRL8zyhrU0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQ6gBzv9JHgOf+wLyQBSFJ+rDmGRwbeDWvUs95+xMkA=;
 b=nIGnWuogD+e54K4x+Y4kiKwqOygyPfuUIqkUUeSrm3Jmebau7tZ4A+cqxoFN526BkqoHR5ot3JiPhY1m9P+jCUmHmg7Blrn6zObye2nFItnh9lH5Iv6ed4bYl7JqQpSNYkjBb+T8s/if7U9K+R+aoaTjeIRxQx41eAMZl3SR0FhkXNXwWJXGWLhx6ixl7L7owUasz2qYI3811rtp6Lvi0qkZBnXw0DTqCFzkwUQLnSo8KAvJLi9TIL/l96Tq6SNQMauOsfBB0J84xCl62K7n5WJTZ5Lkm/dWbNtOawlADycutggGlWSNcbme3mEgVPbJCXeM7DiaKry2Ek9nmokeig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQ6gBzv9JHgOf+wLyQBSFJ+rDmGRwbeDWvUs95+xMkA=;
 b=Y7hf0037/YFmT7G5k054QdNLBBbsBJa+YK76Onn0SsqWbVOdLT0p0KFOOFNVFdCLmNJuvwGi7Mvn43UKY1geXr9VspWqNQYPV9l5+x+Be1815U4WS++alddmjcGV9EPkzrRX2+btU/p7Ln8tFdoDUTqWUQTJa1ily0wBqMC13qA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB3962.namprd12.prod.outlook.com (2603:10b6:5:1ce::21)
 by DM6PR12MB4387.namprd12.prod.outlook.com (2603:10b6:5:2ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 13 May
 2021 19:37:41 +0000
Received: from DM6PR12MB3962.namprd12.prod.outlook.com
 ([fe80::142:82e3:7e9d:55a0]) by DM6PR12MB3962.namprd12.prod.outlook.com
 ([fe80::142:82e3:7e9d:55a0%6]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 19:37:41 +0000
Subject: Re: [PATCH 1/2] drm/amdgpu: Don't query CE and UE errors
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>,
        amd-gfx@lists.freedesktop.org
Cc:     Alexander Deucher <Alexander.Deucher@amd.com>,
        stable@vger.kernel.org
References: <20210512170302.64951-1-luben.tuikov@amd.com>
 <9d7f82e8-6528-154f-9a23-bf78ff249505@gmail.com>
From:   Luben Tuikov <luben.tuikov@amd.com>
Message-ID: <1d54c92e-1448-7aaf-9738-3a22e6799356@amd.com>
Date:   Thu, 13 May 2021 15:37:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <9d7f82e8-6528-154f-9a23-bf78ff249505@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-CA
X-Originating-IP: [108.162.138.69]
X-ClientProxiedBy: YTBPR01CA0025.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::38) To DM6PR12MB3962.namprd12.prod.outlook.com
 (2603:10b6:5:1ce::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (108.162.138.69) by YTBPR01CA0025.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:14::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.31 via Frontend Transport; Thu, 13 May 2021 19:37:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b64c9578-5688-440f-eaed-08d9164692a3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4387:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4387CC12F6C9100B5913169099519@DM6PR12MB4387.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FZLYoAq95uoqXaAQcIQADT5PrbL8ailUDkXxdkO44Atn0HJyi96W/MLkt6vpawNQASa3yPWc9SAnlvCkcRuO1MF9C6QqCKUrEb2wguAhFWD9HKtP1A1e+fExtP8I6XcmB2dejYv/p7jXTNa0Z03IEfqK+jLapsvdMXPhON2+yTtRAV5s4BEQ9+SuCy8bjlxjwzhCD2lND0bSstIs3x/P3zC/RFmGlAjb1+azLVEUqU5N5+DDUKkmoMvXJHfxE/ITLQdGbBp6r7LECAH+4X5b/8Jj4cQ9+/5BUjYYkwcHf6ldKL68CWX54/CQclhaKq8bHY1fNvDIwu98W7O8xo9lf0dRIAVk0MfdyMvbhZrhnt61dyZ9TO/NLAT5hHeiodpAx62o+IiN4Ah1PkBfxAZRFyTjl0pVEiULbfV2RIOD/rGdxnGpXmnIwf75GbYOuqUTTDI+1vO79T/oKxvgeNyLioFiNBhQBMyfdpSf0YUOalS85xySysSrXJoSS2ZyajBKQAF9VNn18QqLsq+p5ZOnFb/vg4Wk1NZoHW3bNCk1Eg3pvJrZoLoMpzMW0fpw7SvL5mm1AX9ODoRY8adgnK0GheaNIS2BHjodInssePPOxomSUm2p3uXhmHdYJPTiJ1dRWs+2N/fSyfcAhvI8cTLflYKNnAfMOF8mBUmxl6M36RSNAizkGRxfLdlb5ow6tI41
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3962.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(396003)(39850400004)(6512007)(478600001)(16526019)(44832011)(66556008)(316002)(2906002)(36756003)(38100700002)(2616005)(956004)(26005)(66946007)(53546011)(8936002)(4326008)(8676002)(31686004)(66476007)(6506007)(6486002)(66574015)(31696002)(86362001)(55236004)(5660300002)(186003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NVRYM2VtdDlwRGtKYWVSUFdOVHVDbEQveXFUdEhoYUNITjR3Yk9XRVd3Q0Zu?=
 =?utf-8?B?aXZkN0Nvdi8rRUdkWHd5UDNielFmVGVqT0J3TEpqSndjM21tdS9RMC9wZHRS?=
 =?utf-8?B?VG8yMWs2aEpLZEQyYVZFRTZLeVN1a3RMY0ltMUhqdnUrTUozRGl5Tlgyd1FT?=
 =?utf-8?B?dzFxdGFaMjFFeTRGZWpWOWRaTzdqL0puODRNQ1lZSTllU25CYVg1bHZsREt4?=
 =?utf-8?B?YUZtNHRLc1RXMHE1OG9YbVZEd3NmZ0VRV1hyaG1EUERKN0ZHM2NmZWlrYlM4?=
 =?utf-8?B?S3ZTMEUvWitwZTJFall3bWFnM1JkUDdqSE1PdXMzOFF2UjgwZlVqQTdFWG80?=
 =?utf-8?B?S2w1YjhqZmZ4OTd0SlRSR0F3dnNxV01RUjJxem5TcG9Xdm1EemgvTk1ablNp?=
 =?utf-8?B?MmJKejJ6ck1MUU5MMFJManJ5U3BNZFR5YklnVjExejdXN3RUTXFzS1g3QmMr?=
 =?utf-8?B?T0xYMFViT2ZKZktaM2JXRDArRWVzOWxucnB2ZkpWQWN1TXdOOE1TNWp5YWpM?=
 =?utf-8?B?elNJYTdsRXFlVlc2dWIzWnNVZU5ldUZyQ2dXamdXQ3V6SXZjNWxLTDF0YXAx?=
 =?utf-8?B?QmlSVmMrbHBEaXZBblBTVTlKeHhyVkY2Y3BGOWxjNUNidU5KMUY1eThEQVJ4?=
 =?utf-8?B?Zlo3ZWNGSjZ6ZHZ4T2Yvc3JEaUZLbkVYVEhaU0xoSWUzV1JJUStOZGJGN0pm?=
 =?utf-8?B?U2pyOVZXcmpOYUNiRW9tT05DUHFzSHNWenUvb1B6SS9UcThDVDdmV3VXMVFv?=
 =?utf-8?B?SFVuSTJMSE5QZkZ3U1JoUDc2cEovZ1VaUnFtQThIaWU0Zm5nYVF0Ti9wQTNs?=
 =?utf-8?B?RnJhTzZoUDQ4N1VHR0RqeVBiM1RXSmNaUlhNbGJSeGNvU0RNQm5BZzdrelZs?=
 =?utf-8?B?dm1tMmJ3NnZGN0JLeUtVWTBzY3cyQmtLQ0xScXZicHZpQ1JjbjBHZXJMR2U4?=
 =?utf-8?B?a3k1Y1NqZ2hqanFOYVYwVGhaQWVPNUxaaldlczA3K2RGM0h4SkdDZkY5UGh3?=
 =?utf-8?B?VEo3UnZ0ZjF4M3YrbFdQRWdDUWZvSVZ4MjhWNXFuSnNjUHhLNWYxWEQ0bm56?=
 =?utf-8?B?WGhQT2YvYmRkTHhUMlhJZm40T2RKcEkxSDg0QmpGQVVkNmJHeEpmTHVYbC93?=
 =?utf-8?B?djdZM1VqOVlsQWRqL093c2orbVhqcUxCTk9HNitmUUJ6ekxyMUcxWEhKV1Va?=
 =?utf-8?B?R2tlQUZGNGpoWGgwRnNaN3ZTbnUrS0k2Q1gvclNPVStyZTRHUC9rMjI5UThQ?=
 =?utf-8?B?NTQ1cWpyM2owNUZvTXRVeGwvOU5rSTVOM2dVcm5wV3dOVm5HY0tjWEg4Rktl?=
 =?utf-8?B?VXZBN1lxYkxtQlZKUUEzMTBFM2FOZ05zZDJ5QjBmdU1UbThMVHZiM2cvQkRn?=
 =?utf-8?B?SDJ0NUJISEtNTTJOclE0elhaL083S25DeG9QcUFZRzhEWGUyeStmRW8rV3Bn?=
 =?utf-8?B?TXFmenpCNE5uSkdOK3dkS3RSWDhnaExPbWRCY0I5OVUvQlI5Z1RwSjI2SC96?=
 =?utf-8?B?MWpHc1JxRHpqSGNvMmdTVDhYTDRpMWFsMTJKdFJ4aHRlUnRyM3dJRFRrMm1D?=
 =?utf-8?B?cW9jZlNwdHJWTEs0bmJ5bzVaNytoUE4wNUl3b1lYdVRzbWJBUHhTUGlSbjAv?=
 =?utf-8?B?OWtybEp4Q2QvRm80MGJ0RFlrTWFWY2FkWWZHZUhvT3BOd2crUitmeENLcE9r?=
 =?utf-8?B?OEdrVmJONTd3UVlsQm1xK0FKRzRidXNpNUVVQy9lWXd5MXlYNWFXbEFxbmpH?=
 =?utf-8?Q?rolmsun50U+DgajykqqQ+PnYYZbGdJLWrdeZ9Cy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b64c9578-5688-440f-eaed-08d9164692a3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3962.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 19:37:41.5302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uL+7NObQcJy9gc0BxOueF3Wr8QZbJM3I+jYEGcQTG7FXMOCdMUlUgeDwupO8d0ID
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4387
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-05-13 3:56 a.m., Christian König wrote:
>
> Am 12.05.21 um 19:03 schrieb Luben Tuikov:
>> On QUERY2 IOCTL don't query counts of correctable
>> and uncorrectable errors, since when RAS is
>> enabled and supported on Vega20 server boards,
>> this takes insurmountably long time, in O(n^3),
>> which slows the system down to the point of it
>> being unusable when we have GUI up.
>>
>> Fixes: ae363a212b14 ("drm/amdgpu: Add a new flag to AMDGPU_CTX_OP_QUERY_STATE2")
>> Cc: Alexander Deucher <Alexander.Deucher@amd.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
>> ---
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c | 26 ++++++++++++-------------
>>   1 file changed, 13 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
>> index 01fe60fedcbe..d481a33f4eaf 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
>> @@ -363,19 +363,19 @@ static int amdgpu_ctx_query2(struct amdgpu_device *adev,
>>   		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_GUILTY;
>>   
>>   	/*query ue count*/
>> -	ras_counter = amdgpu_ras_query_error_count(adev, false);
>> -	/*ras counter is monotonic increasing*/
>> -	if (ras_counter != ctx->ras_counter_ue) {
>> -		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_UE;
>> -		ctx->ras_counter_ue = ras_counter;
>> -	}
>> -
>> -	/*query ce count*/
>> -	ras_counter = amdgpu_ras_query_error_count(adev, true);
>> -	if (ras_counter != ctx->ras_counter_ce) {
>> -		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_CE;
>> -		ctx->ras_counter_ce = ras_counter;
>> -	}
>> +	/* ras_counter = amdgpu_ras_query_error_count(adev, false); */
>> +	/* /\*ras counter is monotonic increasing*\/ */
>> +	/* if (ras_counter != ctx->ras_counter_ue) { */
>> +	/* 	out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_UE; */
>> +	/* 	ctx->ras_counter_ue = ras_counter; */
>> +	/* } */
>> +
>> +	/* /\*query ce count*\/ */
>> +	/* ras_counter = amdgpu_ras_query_error_count(adev, true); */
>> +	/* if (ras_counter != ctx->ras_counter_ce) { */
>> +	/* 	out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_CE; */
>> +	/* 	ctx->ras_counter_ce = ras_counter; */
>> +	/* } */
> Please completely drop the code. We usually don't keep commented out 
> code in the driver.

1. Alex suggested this when we chatted--this is why it is commented.
2. He suggested the same thing last night and 2.5 hours before your email,
    I posted a patch in which the code is commented out--did you not see it?
    It's threaded, it appears above, 2.5 hours before your email.

Regards,
Luben

>
> With that done the patch is Reviewed-by: Christian König 
> <christian.koenig@amd.com>
>
> Christian.
>
>>   
>>   	mutex_unlock(&mgr->lock);
>>   	return 0;


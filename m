Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DC046B3CB
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 08:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhLGH0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 02:26:25 -0500
Received: from mail-mw2nam10on2076.outbound.protection.outlook.com ([40.107.94.76]:47510
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229710AbhLGH0Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 02:26:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DX3h4qFBcUE5Z4+IvbYiHlhT4mlzmdRQj/7snQyAtuu2bPVuXtVU8yCIAw+Zx8cSfMTGOsma9q6ao9/Ep+PpRsTiRNC0RmmLVD78OXm/wwvM5iLoZDssj4jipPLYp9FCehI5CMTwV/07C5EwsLwrD4ahEgTjBVy/c/5Avsz8SGljyUwAliOiQsxxHr1f00Qko4YQEafUmFSJlxz8vr9as1sSBAQpd1FG4WRqE1ySI8wsBfzrua3/g5SWaA3oyS08a+J2icUueepr8cc7Wxhdqne/saepa6jWnydjfPax0BLXjZf02Gq8oMdha0JkgiMFT7/fbGiLZLWbLP/PwVhb0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9q34D7/TFqyI/bRgA1UbRRaEjj2Ku2qxoh2yOddcrOY=;
 b=MTAxW0tT9X7nsJN2nO3jZlAfH0CQ5YUyQEEEBIwARXQSu+WDPQPBi1SgnnrOnl1R0IwMZYR9MNgOD9JHSzgArsiMKKoH4L944q5tE/ZQQBLVzorRGCqKX7TwHG0wiIwRWOLDkRzbFgsDUp86KuSssvMs4SM3kz/zcqGJ/Yl/DqT6iMHe3gH+A6bdenVDSbrBqdkJNJyB+Dbrz55CWVKzZv3AoBguHs+wQQ0lmcZ3RT8itjanPtBE2jxTr/nkKG2vbt2Fetc7POoj+pRL3THJqWKdzVS5Fh0dSHTNuTDvfvSK0y2/XlzgFKwA+6nvig/RjtjsVEWpuAQVrbHG3xfVgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9q34D7/TFqyI/bRgA1UbRRaEjj2Ku2qxoh2yOddcrOY=;
 b=aNcs/DvgOFHqCXQvfu/GfJvQS7aiZh5HioDz1N8GFVhYhlpY24KnZOqfIDEKsO27dXuDcaBo18pg41BFjFQEuEU+twhySNdcSQqxwCvui77c91Bke0t/EGjqngTTCFd79bbMsx3J7RQmULqJmlQwTJ5Sn7kRvSypsl4gVTyfLIo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14) by MW2PR12MB2556.namprd12.prod.outlook.com
 (2603:10b6:907:a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Tue, 7 Dec
 2021 07:22:52 +0000
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::d16c:a6d5:5d2e:f9d4]) by MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::d16c:a6d5:5d2e:f9d4%12]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 07:22:52 +0000
Subject: Re: [PATCH] drm/syncobj: Deal with signalled fences in transfer.
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
To:     Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        dri-devel@lists.freedesktop.org
Cc:     lionel.g.landwerlin@intel.com, stable@vger.kernel.org
References: <20211207013235.5985-1-bas@basnieuwenhuizen.nl>
 <6b4beed9-6d2a-96c2-956e-5a5fb6f6fbd9@amd.com>
Message-ID: <411e8dc7-56e3-744c-7067-7d73529ad49a@amd.com>
Date:   Tue, 7 Dec 2021 08:22:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <6b4beed9-6d2a-96c2-956e-5a5fb6f6fbd9@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR04CA0003.eurprd04.prod.outlook.com
 (2603:10a6:208:122::16) To MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14)
MIME-Version: 1.0
Received: from [192.168.178.21] (87.176.191.248) by AM0PR04CA0003.eurprd04.prod.outlook.com (2603:10a6:208:122::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Tue, 7 Dec 2021 07:22:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6c86ebf-1e99-46ac-9f10-08d9b95261a3
X-MS-TrafficTypeDiagnostic: MW2PR12MB2556:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB2556FB2A47697348A12B41F4836E9@MW2PR12MB2556.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a+Xq+TKIqP7wCuuSr55IjHih/bAIrwOa1qrt8hT5nhDh9TapGENFShC7P2QaqLyQFbBHOuvXmDw5uvDBCmoYMpQs3siKpwbmxXNp9GSzy7kw+ZrznvsBQKxFeG5OMCf+n49beI1tfK/0IToFnao0Xtg9WHP72dlLZbUZDFeXRcllaDPycASlubqkcvb7YXadQot9TBT6bgS6au5lLKOcLQX+kjFC2K9a+DzqPo/37tXlfowMyjJY8rP3SCqAfvsm0qpPDSahMPyzyoWebWB7OYdODYPWb0NkGUenJh5G62tS1Px14q37/z+WeJoYYFb0Af6jvehIhAibyQTOUN6bAWnItTvFg2f7FCKCjtS99+wCA9/0lpwTYXIpZ7Q+Nq3MkCZViYZCGgtYABm+v1MbCnIA+kw//HJA94V23JHxw22U6bSTKvcaE63MaW6aijeZlIx/9AQikkCINWg577h7KOq00g0XgRPmHi3naqc7i/ELPU/DiPb+5yENsLesFBzyByd+2bXN9xMzoztG+2qWv1VdEU8mfjoezNAodf6UDYpMVEGPKOtc5qbIDYryct6ipimgnbC/oQk3SWRy/rE2DCLkaBZrgWbQY4TvaXmGclm+pUvR+FIRK6/I66M4D9eOBP9cJp7FBYRbgYEpKai6TR2O1+89K7MzJqVbaFNcVgJkDV6NmxvKdHpcHJexXzMZgzlyPaEHHV7iq2BQqvJIDpKzY5Twj+ro8ZTxmX5dufM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1201MB0192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(31686004)(66476007)(8936002)(16576012)(186003)(6486002)(86362001)(26005)(316002)(66946007)(36756003)(8676002)(6666004)(38100700002)(31696002)(83380400001)(508600001)(5660300002)(2906002)(2616005)(956004)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2dxdHdBY082SDBDQkpHS2lEOHNHYUpiUkxKNm1Ia082OUo5YVhOYjB4ZEs1?=
 =?utf-8?B?Wm1iYTVRV2pTaFVOenlwUDdtZVpCVElIK3N5QVVpc0puTFlrOUJVUDg4K0lq?=
 =?utf-8?B?VzdVdmU2b1E0T21ObWhodHFVR0xUYmxGaEdrTW0zZlVPUC8ybWpnT1ppR2FP?=
 =?utf-8?B?QkNWdUp1d1MzMCtFdDJkeFIvMmRnVjU5NTQxNjV4V3ZBLy93Zk51NUFvL3Nq?=
 =?utf-8?B?ZnFtUnNoR1NrQWpsOUx6SU84c3hraHJPelhwWGtWNlUrTk5iS0lzUFQ3SVRx?=
 =?utf-8?B?NXRET01tZUFqRTM2eThqWWJucEg3Ty9lUksrVUUwSHErcUpUOFVZb3FXeWFQ?=
 =?utf-8?B?cW5TcHpWY0J5d1hsaVhTRnVoNTBaVFBDeDZ2TFJsRUZLNDFaWS81MDFyYlBO?=
 =?utf-8?B?MzUveE4wVlh5U21oelZWOStrRmhiVGZ3VWhLY1o4R1pQeFlDRXJoSEZlcXpT?=
 =?utf-8?B?Vjl4Y3lQSGpJc3lwYythdmtHa2FIL3FwaU52ZnVTQVU3d2hIL1hFRXZUN1R3?=
 =?utf-8?B?SUYzWHVkN2hwZm15NDVaWllFdERsNkU4T2NwUTdwTHRTLytOdGtwdjRET3Zx?=
 =?utf-8?B?ZjFTQUhhaUFqeHZsakdHYnBNYkxvOTRoQi9YeUZTV0tTdmcvZVMzNTFEaWV1?=
 =?utf-8?B?ZWI5UDRUd1dJd2d0Wkh5QlBmbEFscnhBNjVLSHMranRmRFRqdnV4L2RFWjRk?=
 =?utf-8?B?OWdwS0ZBZ08xRTluTE96bFkzUWJMVTBmdDFSVFdhb3RuYSt4cTNMaXhDV04y?=
 =?utf-8?B?L0JCTExjVXpIRUQxd3RkNm05M2dpcC9JNURJQWNxOGZZRXBuV0twUGxTM2dJ?=
 =?utf-8?B?cFN2QW1TZ3BPK3oraS9IOVdxOW5lSUphYVd4MHhSRjB2S1lZYW12a2xTOFdk?=
 =?utf-8?B?M2tEc01rUFpGY2lqdHF0RjQ1TDZTS29wQXdtY3ZCQ2NqZSt0WXFEaktNQkY3?=
 =?utf-8?B?VmNWTGExczU0dURjR1o3ZG1oOXZ3K3FYeFdMeG9KdWd1TVJYV1B2cHRESVRl?=
 =?utf-8?B?dERnV2JnaXd6VmxBR1lUUXdhQ2w3eU1iZExTa3hoMlJ6bkZpTWt2WUJOS1A0?=
 =?utf-8?B?QWxEWFkrM0hldFJtempVbXQ1VkhSWUo3ZW5JRnpuY29XQUJlUzFBVmhzSUly?=
 =?utf-8?B?MU1YWFhWMG9JR3lSVm5jM053SmliYnNKM3JVVTBQcXExZ2FnK2NOckVZYlpn?=
 =?utf-8?B?SUhMaFZ4dHFTTTlKTVFLUS80TjRuWEdQajRzQlUxSFg5N1RIK2N4aEZpNDhB?=
 =?utf-8?B?a2ZjNE15VWUyREpJeVl3NFJVaU9wOFBrd21kNzBNNFQ1c3Vxa2M2bVhFN3dB?=
 =?utf-8?B?OFZJWXVkdWFkcEs0WlFtcjdKWGVHMUNDMk1ZNEhBakIrUmt5NUNZSjN0Y2hs?=
 =?utf-8?B?RWhsak5wMVhCVFZuWDhESG8vNnNXWlB6NG5OaEREaEhGQnZ3TThHNi84K3la?=
 =?utf-8?B?SFhTNHZBeUduTzdSMTdEL3RMbmpITDRJbHdaNU5hQklTeFNpeXMvN3RtK0ll?=
 =?utf-8?B?WFU2ZTd6RG1KcWpueUVTZkNZamhJL29PNW5wTGdJZGlNY3VIazVXVm5aU1pW?=
 =?utf-8?B?OUNSdEhUSnNyYWcrSEg4YnlZbzEzTStZUUV2TUFhRktqc1c2c3Q3cHFaU0ZD?=
 =?utf-8?B?ZlgxUXdOa3VOcFRMMVpFT0piMmNNWUlxUmFHdlE2dFBPVUFPT2lKVmNQVlpJ?=
 =?utf-8?B?MXpVd3VDeW5idVJIVVdkY3hnT1BybVUxUGVqYTVjeWQrVzdHNmpTRWhxTWJV?=
 =?utf-8?B?UFRINVJoVEpRcEE3UjhDVThtUHl3cUpqUVVRWkNBT3V3NVhsNmtaWE0zVTd0?=
 =?utf-8?B?dFRJVUt1LytRdW5hMFBlNnNQb1pKYUgrZlJjVEl6eStyRTdXVXB3dFNlYUI1?=
 =?utf-8?B?RkxqMHY1QmFHK3JKbFcvMkl2Z1hCZ0ZQWGF0cnhEZmxNUmdINUZNa21wak9M?=
 =?utf-8?B?V1FtK2RobkxBa0FPMUlLbytYaGhqcDN0SE5LRU1jZzByUnNYdWptL0VCdWUy?=
 =?utf-8?B?OHZ5Y09YLzVsZUExWHFGTTZZL1VRYmt2R3lEMUJFQkpMV0V0RWh3azBpS2ZE?=
 =?utf-8?B?TTZ2SWhDK2V5UjFETGNYcHRPbzNwcmhZRitGYWFrYmhWV3IvRU9FdHpCZ1du?=
 =?utf-8?Q?xXsw=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6c86ebf-1e99-46ac-9f10-08d9b95261a3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1201MB0192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 07:22:52.7625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 56YjnBSrqabTAe2AG7shPYUhPWya/Gdyn6bPoBbzvPsHwvt21519rq6KCaB8y2Ct
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2556
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Am 07.12.21 um 08:09 schrieb Christian König:
> Am 07.12.21 um 02:32 schrieb Bas Nieuwenhuizen:
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
>
> Reviewed-by: Christian König <christian.koenig@amd.com>
>
> Going to push that to drm-misc-fixes later today if nobody objects in 
> the meantime.

Need to retreat that rb, Lionel correctly pointed out that this should 
never ever happen.

Christian.

>
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


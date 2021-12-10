Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE16047027B
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 15:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbhLJOSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 09:18:10 -0500
Received: from mail-bn8nam08on2084.outbound.protection.outlook.com ([40.107.100.84]:61982
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234477AbhLJOSK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Dec 2021 09:18:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atXfl/OkZpTdrtwabX1uw8UlcXCu4Vuj2B93KUa3hL75PuMKyMwZZ3X5Zluw1r8tOzF80jbf4brbWDm37NSX83mtnktI0PaGxI7psnurYKSacG5vN/d3fytgTlhJ0BZBxcRu1F+hCzyTNcHF+btAUSVST2oLndpZ+1vYJZAqNNmNWSf2SCJWB1Hcm7U7+Fwk+QJRjTetpPXkm2cw9jj28Cr8SLGYxVktywlRwi68OmhMdQNFxAQ14UZmYxFs0n7yJ4pJa+X+aN1Zao5mxnN8Cc11fPKDCIO6Rq1FBsNLRk6qs9sc4EaW9kw+AjAFMVOYMSyJcpUBNIl7MVS7qnTVHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=33q2atYeuskqg3UEU5Fu/gdtPwWnkjvn3z9LeNU2wm0=;
 b=eUOGHvH/9gDG4Ly3Wtc058xGubRiqB8U4P2bCSmaoK4EBahPKb7o0wolPiy1kGcE5z524c2si8FeDxqbxh3KPuqTkqHA5CkWU+C+ZwhHa+78ZoznymcIfw8HzmO0cPosVQauc0w07Utvt/lOM+yhK0ftPlV+0Zr/B75MzkCU77vqGf3erTZf4zajlm0qFs4izahCTKsWEgWC5pVyOBgAJM0GgsbWAE6Bpr6f2ZxqEeqwASl/WmxwowZz7M789K7uWn/mJfyD81pMQ4BVy65p685jCjGzNNg0HmMRC1AjmnB8XjR9p5vWUWETIiKwWXa7Jrn6t4RT54MbEJWLfSj7DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33q2atYeuskqg3UEU5Fu/gdtPwWnkjvn3z9LeNU2wm0=;
 b=QETkQo6kUBdt3FGkolh20fgRkUv/o5CtQ1Ay7KWRC5980jh1QGnVBQHhMExmAuiIX3NiC1DVMWNuEIltkT2dJtvnLTLkYhtsan7mgoCFnpg53TVnS5OlnxKNjpAU/b8mGPWtGDoINw0Ji5TWPfEPjrSYhtvxtehPlbYwgRcaUBg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1753.namprd12.prod.outlook.com (2603:10b6:3:10d::16)
 by DM5PR12MB1243.namprd12.prod.outlook.com (2603:10b6:3:74::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 10 Dec
 2021 14:14:33 +0000
Received: from DM5PR12MB1753.namprd12.prod.outlook.com
 ([fe80::9d61:180f:e2e0:2db5]) by DM5PR12MB1753.namprd12.prod.outlook.com
 ([fe80::9d61:180f:e2e0:2db5%8]) with mapi id 15.20.4778.015; Fri, 10 Dec 2021
 14:14:33 +0000
Message-ID: <74391909-3894-457c-6516-7bc8c28e0d58@amd.com>
Date:   Fri, 10 Dec 2021 09:14:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 6/6] drm/amdkfd: fix boot failure when iommu is disabled
 in Picasso.
Content-Language: en-CA
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Zhu <James.Zhu@amd.com>
Cc:     stable@vger.kernel.org, jzhums@gmail.com,
        alexander.deucher@amd.com, kolAflash@kolahilft.de,
        Yifan Zhang <yifan1.zhang@amd.com>,
        youling <youling257@gmail.com>
References: <20211209220956.3466442-1-James.Zhu@amd.com>
 <20211209220956.3466442-7-James.Zhu@amd.com> <YbNXFGM4s93myyLu@kroah.com>
From:   James Zhu <jamesz@amd.com>
In-Reply-To: <YbNXFGM4s93myyLu@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0324.namprd03.prod.outlook.com
 (2603:10b6:610:118::18) To DM5PR12MB1753.namprd12.prod.outlook.com
 (2603:10b6:3:10d::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8691a015-baac-40ac-900f-08d9bbe76346
X-MS-TrafficTypeDiagnostic: DM5PR12MB1243:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1243C3C5DADB640F0F13C215E4719@DM5PR12MB1243.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JWdsja6SNEpy8Zfa4wv5VXXz8ndHcpxkEbwBlo+xbMvCbsmggCxC+o7qgTjBIoOLm0xHNjArmpokNRoLH69cyB0qhllH9lTUjyqPXR2ph7LA2b/iI5fT0Dt7V4LWux9X9FY2ZaHykPdpVQR5nT/HmPnuX1mXaomrvclANuh/4X8T9Qy21DiyNBWNf1voxXgjKSnA5B5Ggd3trgxPnB2x51JCdN5etdBRh05lfgllQpbYlxVDuLiNAwgihKOQHoDq0kMJgo2xh/y4JHpuW7UgYj87rHmzVzjXkWyXv2Z9iMLnSxXHdZEWI5PgiW7KYTML/JuzzLFOVmaOryRQVBcPlCUbBNbPmugYFvW1+//QIJsdP/FUMrls66snvLspSiyBWbP4KUHW91IZRmk/OJbxnTepsSQz69De9Cd/fOcbBoRgxyOIvRDw5Tn0uFf2thj2mo8BHtIIckW9571YJ3PMj8rRqpdXLe0Ni+F/lK6vnj5dYcrMkBrY/M/HmtNw3oq7UGEgb914DmNAK2XnkPyfLSGPKLZcAjtF3beNKXCQsAM55fz3E/yy4b6y0P6azlKz9FyL4qkI0AxXHCGpzTqj3M4QLpRFIqtMv/gbgoMM1/gKCTO0+4fH6UVAygOvMfiZekwuhzugRRJWKNGlv6JhFdTTWQHLWOfJd0sOfWlV/dhesGHkdQV1d9Rz5B85nNJTkS+TbcZV1+20gzXGx9phuYFp3gWWwXOgp8mMYT18Gjg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1753.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(66946007)(53546011)(6636002)(5660300002)(26005)(8936002)(110136005)(6486002)(66556008)(8676002)(66476007)(6506007)(36756003)(38100700002)(4326008)(31696002)(508600001)(6512007)(316002)(4001150100001)(186003)(2616005)(54906003)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFhpdHpTMDFTMllqbk9ZbFRiTERlQlpsQnoxL3VRTVlZREx1ZzhISzk3VXdn?=
 =?utf-8?B?T0d3SlJ4WlYxTmlKbnJ5MUt6OTQzc1FQTFc3RVAvYkRRaGR2dVBFT00zYnN5?=
 =?utf-8?B?Z1ZiVG10eTN1ZWFQb1psNXkxT1llQXFrUllJT21ZR2dDLzRQUFBUZVlwUGxB?=
 =?utf-8?B?R2pBeVlIblBzaXljZzE2VzdtSzhIbStoamRpYTVGbE1FSE1qbjUyUis1SHNP?=
 =?utf-8?B?Uk1FdnZDc1p4SzlQcVZKam9RaXJ1Y2F3L0JQYU95NjJQdUlDU0hsQ1g5VTZK?=
 =?utf-8?B?ZDh1VHg5Q1lvMGhsWlA1cVpkUFlVTGlVcHU0OUZEU3M5RzUzYnI1b2lsWjhz?=
 =?utf-8?B?ZDFVejF3S2h5WlY0NWY5WGpManZCMkljODNTMms0OUlzS2JTWmVMTTRwdCtn?=
 =?utf-8?B?clVzTnRtUVJpT2U5aWp1azRWcDVJUk5EZHRrN3JGNkc2L09VSit2S3RXc25o?=
 =?utf-8?B?cElZYzVUZW1kVU80YTB4S3B4bWw0eWxhTW14VG55akw5WFVRbEYzTXgvOEp0?=
 =?utf-8?B?MXpGYXI1U29iUkNoMklEZ3JmS1ZkWjZFRVY4R2VYQXc0L3BLTWhDZklObzJx?=
 =?utf-8?B?d2dqdms1VWg0VmxaQ1JhNUtBejRGQU41S1JwS3B4Y0ZFNkJZV09xbG1reUxS?=
 =?utf-8?B?aVJ1Q0kyTFNPU29MUFNVSkU1ZmZaellWRFNLQkdHTzQ4Zi8zd1NNNEVENXpO?=
 =?utf-8?B?TUw4R2tnK2ZwM1RjK2ZneEgvYXY1VkxxZWkxWFA1UjJKcFBuWlpIT1FXaWFY?=
 =?utf-8?B?L2lpNVlZTSthdHpWb2JReS9vdnUxbW9uZUlGdHZaWVJWbldlNjUzem5uQ2RF?=
 =?utf-8?B?OVEzSHhMVWc2L1pjZHVCVitGRG1Pbk9QcCtzYW9qdFlQdndyQ2djZ3JJdjBs?=
 =?utf-8?B?WmNQOXc1TXFuSDVhalBFbXk2WkdKbUUxWllDZldYRE5Xb3FjT0dkbjJ0ck1p?=
 =?utf-8?B?b2h1N3lqQUowckZSOHZ0NERIVmpBVXBPS0o4NDhaYjZJdzJRVHEvZHZ6eEZ3?=
 =?utf-8?B?TDBLZzkxc2RYc3QwNlk0NlpoOHBRamZubzNZbWE4VUd5WEhGNUFlUmxSQ1FG?=
 =?utf-8?B?ZnBJTm9KNzdlQnBQOGNNbnZxczZjQS9SWk9haHgvQXROeTFLM2Y3YkpMa1o0?=
 =?utf-8?B?MURKK2p1VU92QjFhYW1BUmoyM0xWWGtPUUF2Z0dYZEVjSlY2eENZQldqeXQ2?=
 =?utf-8?B?MGY3MjhLSUdkOUZWcmNLZC9HMEZOQkVLRmtCQVp0aGpaMlFmR2lReXliQzA3?=
 =?utf-8?B?cEVaaGRBUlNWRThoUGVJbVlKSVNqK2VueG1KUXIwb3FXam1Dc0VjSGJvcDVT?=
 =?utf-8?B?aSt3QzZya2FKZFI3Q1dzRVhKYVYvMWdjZ3hQRWEwSncwY1NiWE9oZ1JFYytJ?=
 =?utf-8?B?bk9IeVIzUEthRmNxMU14UGdRZ2FqSXFJeGNiemtkdDRya05JNW90MVhHcE90?=
 =?utf-8?B?Q2l0bG8zY2dLMTEvT0I2NEJFdUlsNnBEcUlCL2lreXNlbzlldVBXYVhpVklx?=
 =?utf-8?B?RTl6ZUd3bjM3a2xSbVlVTzhqQmo2OVROUDhiTm1DOEVxZlVKS3Q0L0NFSDZs?=
 =?utf-8?B?OGhXYzZseUhIUHNtWURMZmVNYUNOMmJ1bC9WYi8wWldURlg5RjVoOWlDdnlC?=
 =?utf-8?B?WFFTZ216SWJ1eGV4cDdzalo3NUJWcXVNTFBENnZJU3ZvL2VLQlpOVW00NjhJ?=
 =?utf-8?B?TjZISCtDREtNVUl5L3RTdk51dklUaUxudXgxS0FGckhjWEh5NTFzVWdKYytX?=
 =?utf-8?B?aUd2NEJHYnNPMXdLbTZ2Z0VuRFB0dWc3VXZ2UEdBSVpHMXJzeWZTRnBvUUt4?=
 =?utf-8?B?OWVCRUoza0lidDd0aENXdWFJSTFwdmdUMXVVb3c5ZDh0TlhKTmpidWNYaVpa?=
 =?utf-8?B?d3pQamkzcmh1bm45SWROQlJsOFpScHdlYTdzVzgrTVNoVnNZS0hNbmRPWWQz?=
 =?utf-8?B?SUNQR1B2cWlyYkFlcXYyc3NHZnFxOW9uaFk4NHNwSWsxOHZFbmJFbjRoMGhG?=
 =?utf-8?B?RzBMQXowQmNmcTZ4YmlBOUlCWElrYU5MaG9CbU51a3ltZ0JHb29NWERYMWxx?=
 =?utf-8?B?OEllc3ROR1ExelA0S2pUZG15TDF5dEZCU0h6eWxMcitMQW1RVnEzWnF3Uk5D?=
 =?utf-8?Q?8efI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8691a015-baac-40ac-900f-08d9bbe76346
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1753.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 14:14:32.9323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RXF0z2kCpEa0CyELSME55F7c2xxanq992KZKK8FMi1VzNlKWxskTrKB15uyadX7A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1243
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2021-12-10 8:33 a.m., Greg Kroah-Hartman wrote:
> On Thu, Dec 09, 2021 at 05:09:56PM -0500, James Zhu wrote:
>> From: Yifan Zhang <yifan1.zhang@amd.com>
>>
>> commit afd18180c07026f94a80ff024acef5f4159084a4 upstream.
>>
>> When IOMMU disabled in sbios and kfd in iommuv2 path, iommuv2
>> init will fail. But this failure should not block amdgpu driver init.
>>
>> Reported-by: youling <youling257@gmail.com>
>> Tested-by: youling <youling257@gmail.com>
>> Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
>> Reviewed-by: James Zhu <James.Zhu@amd.com>
>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: James Zhu <James.Zhu@amd.com>
>> ---
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ----
>>   drivers/gpu/drm/amd/amdkfd/kfd_device.c    | 3 +++
>>   2 files changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>> index 488e574f5da1..f262c4e7a48a 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>> @@ -2255,10 +2255,6 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
>>   		amdgpu_xgmi_add_device(adev);
>>   	amdgpu_amdkfd_device_init(adev);
>>   
>> -	r = amdgpu_amdkfd_resume_iommu(adev);
>> -	if (r)
>> -		goto init_failed;
>> -
>>   	amdgpu_fru_get_product_info(adev);
>>   
>>   init_failed:
>> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
>> index 1204dae85797..b35f0af71f00 100644
>> --- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
>> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
>> @@ -751,6 +751,9 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
>>   
>>   	kfd_cwsr_init(kfd);
>>   
>> +	if (kgd2kfd_resume_iommu(kfd))
>> +		goto device_iommu_error;
>> +
>>   	if (kfd_resume(kfd))
>>   		goto kfd_resume_error;
>>   
>> -- 
>> 2.25.1
>>
> Like I said last time, do not change the backport unless you HAVE to.
> You did it here again for no good reason :(

[JZ] Yes, I should add more explanation next time.

Backport conflict fix to remove  svm_migrate_init((struct amdgpu_device 
*)kfd->kgd);

new AMD svm feature has not been added for 5.10 So it is safe to remove it.

>
> greg k-h

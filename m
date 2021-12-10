Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F4B4703F2
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 16:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242885AbhLJPhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 10:37:33 -0500
Received: from mail-mw2nam10on2077.outbound.protection.outlook.com ([40.107.94.77]:52576
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242870AbhLJPhd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Dec 2021 10:37:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3S6LbrHYEMHcrrEPwjWaFnvNf1gn6LAt1Cwuf3SZm56u09A0wELlEeS8i1MdxOP6q4FLCNWcSftMU4nSbZVtpZSKCDg8UYKuoIejmAkANF+GS6J/1SBP74EfBi1fNjs3WkP/gZwNkzVIy7f553vGQupeDQy2eI6Px+rrq9dgrQjooR7sE4byhkD5tdm6vtSq3N5K3SjQXioO5xATml+5lrcFq/qmNhnKPIvT1I6LIybolfXIB6OhwFujvDlMDVvqvOJO3zhrYIx7YgQTloNlqvlm/0TlFxszpS0hhF9Wy7uXUkhFFczjo1dXvqhgCITTt5eJbprQwbrqXCFIQkOjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PiWqt7A9yZnBKfzsR8Cv30E+vfD7M5LJueeGIvBY5g8=;
 b=UgYCzr3KKOp90ZAMYWddopPXUiT344E+9kc1NV0lp7Ti9oBB4RIz7K+Bel/GFjTX8Zz1hUxC/yxO3amUbKQ+2A1uZCZk9oS+SZ+TueoppfDL9orXm56aG1kuQ2Lp4KYiNvo6mmltpgc1gYKvtCO3zKocXmD+Sx0CH+hrq5QR6aUe7C5ykfOFRmwp8ED6/nJNBAMLp1h8y9RS2/r+qzKOUn8J0bqUz9Bu/66vunaNizpM0mul8qwdwgmTPqYqeiiuA8FlIBuiGZ1Bw/WHZNVU7aeFvPvwlYJhqyRtTsAcpFaT0aTbHz3n8CodyZh4FXdyx873J/pNx4G+lTTOHbInJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiWqt7A9yZnBKfzsR8Cv30E+vfD7M5LJueeGIvBY5g8=;
 b=G6IisaBbvMPhG4iKEFF1vfKFYrVqJzjFdqTRxb33Spsl+j1wLdcqaDyx9HLVdjZAYgQB6UXWccALkWYwG2SDyP32BoIzFuKE6n+PnUxJfifjb7sLq1QdXv8F/Tm6cvfuxs+Jh9NUYM4BaJp1yuY0+mfhse6roU2pBd48ubgYc2I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1753.namprd12.prod.outlook.com (2603:10b6:3:10d::16)
 by DM6PR12MB3307.namprd12.prod.outlook.com (2603:10b6:5:15d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 10 Dec
 2021 15:33:56 +0000
Received: from DM5PR12MB1753.namprd12.prod.outlook.com
 ([fe80::9d61:180f:e2e0:2db5]) by DM5PR12MB1753.namprd12.prod.outlook.com
 ([fe80::9d61:180f:e2e0:2db5%8]) with mapi id 15.20.4778.015; Fri, 10 Dec 2021
 15:33:56 +0000
Message-ID: <0dc3ef66-dc42-3e95-2903-7aec073d8123@amd.com>
Date:   Fri, 10 Dec 2021 10:33:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 6/6] drm/amdkfd: fix boot failure when iommu is disabled
 in Picasso.
Content-Language: en-CA
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     James Zhu <James.Zhu@amd.com>, stable@vger.kernel.org,
        jzhums@gmail.com, alexander.deucher@amd.com,
        kolAflash@kolahilft.de, Yifan Zhang <yifan1.zhang@amd.com>,
        youling <youling257@gmail.com>
References: <20211209220956.3466442-1-James.Zhu@amd.com>
 <20211209220956.3466442-7-James.Zhu@amd.com> <YbNXFGM4s93myyLu@kroah.com>
 <74391909-3894-457c-6516-7bc8c28e0d58@amd.com> <YbNluFUESYFvuWO6@kroah.com>
 <56c017a9-8def-4f1c-5c4e-f4977da0c3d7@amd.com> <YbNud2OL+Mf6BCaE@kroah.com>
From:   James Zhu <jamesz@amd.com>
In-Reply-To: <YbNud2OL+Mf6BCaE@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR17CA0010.namprd17.prod.outlook.com
 (2603:10b6:610:53::20) To DM5PR12MB1753.namprd12.prod.outlook.com
 (2603:10b6:3:10d::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc755129-fe11-487a-028b-08d9bbf27a89
X-MS-TrafficTypeDiagnostic: DM6PR12MB3307:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3307EAEED7EEEFE7FCD6179FE4719@DM6PR12MB3307.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6U/lqUU14dsvfyYCNhNHFbS8FmEMH+oON8FE6BYFvRsBYd0RcGstOlEHefYA1TpnYqwsMGhv0ghGXSTa/sDD6272twzpdRbNHv9IHQiLpmQuS8YjaQ93/o45u61ELRigMosiqgvALWJEb2ncJZ0NpXIu3Yq/3r5OTeAIgroHmefzrL1iGKqg9bZ6WsMBFWCz2uKUVpD25KzTxhRQp0kYicdut/bbur4rih9M4/sUi+UCYX+A6XR1RjRceD7+E2PhCif4rGBMQwdtyyK+zC0JO65HljSzGYd+Fou/lz47R23J3VROKQrrD8vFTDiVp1hrc+AljjMTf09wf+YFcTsY6wv3Z+krhR8UXdoFkh34fbwq+8bi1krCqRW4uTEEZ03M9tuGo5r7h4OqiNQQPBPcUMLkuu4eyw1Ea39njl4Dp5eI3oViRt2fyxFWZ/RiMMALaEbFXKyR/8oTGpvIzaWYWdz0lmkJyzapSP8pBY1ulCDAUsrFVr1FjIK5TyfIGdH5a9IX+xVwEsAoyu18QM8eHVJKc+3CygdM9RCb217oW9c+LbFgwlJEIUP1E+/vjuptwqbGE40P9rkYYL5sMmulf5ZeyL2cbVrzpeWn77mW5aa10qTnuZIZ6V7wv+7HX0w74EBLBtxXxu7mdpIl6e/ZZuA3XiAjx9zlKmYH6pNcFmF9XQYImfYHWfRpp40z8TzUTZoCvTL3GPGASMKMmBU8W6kSqTPtpFtbkmCT/mqlZ3PrlZe9XTPOttFd4iK5h12T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1753.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(53546011)(26005)(31686004)(83380400001)(38100700002)(36756003)(4001150100001)(6512007)(66556008)(66476007)(54906003)(316002)(8936002)(66946007)(2616005)(5660300002)(8676002)(4326008)(6916009)(508600001)(6486002)(31696002)(186003)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDg4c2Q4T3NwQjR5bEFOZnQzczhFWWRIYWJ0NUNpcy9pMHRGTUhWTCtadGdm?=
 =?utf-8?B?R0lVZ1VKQmwyN0Z4dnZxZ3BMRmZKUXMvMWxPRGNxQUtzM29PNHJIcUVEQUtn?=
 =?utf-8?B?OXJqeXBEbUtTRXE0MGpWak50K1pxZTV4T2xUdGQ3YkszTXBDUlhDSDdpSnEy?=
 =?utf-8?B?VWFRem00RkxTd0cvZElRRmJGME9kV0JvQ3RXQUNxL2cwbnVoYnJJcmdrWFpi?=
 =?utf-8?B?WkdxK0FYU3pHYlBGWG1nOU5SYU1WNUFXdTRjMGc5YU1aQjM0OGJZdVJjTUho?=
 =?utf-8?B?d3lpQzVjZTNOSmRwQSs0MXplYjhGZDZUSS9ZNW90NytOMVN1OHZmVlNUcVlN?=
 =?utf-8?B?NHFGSFBScXdqQVhGY2ZKT2FuRUNmSjdlczZGaWFGazRQOXVpNW1PbW9ZZFVv?=
 =?utf-8?B?RUdlWnN6emNBOXVnMGluWDl2aDdOd2RBTnFOdmtEckxVblM3NDkrdXlDb20r?=
 =?utf-8?B?aEVrdU9Fb3JnUWdINjFIVkp5S3FMNUhTNlM4dGxiT2UxcDFGYlFRZm1rREpk?=
 =?utf-8?B?U2t4ZnNENEhKZWowN1FOS1NWOGNyVFhlM2VqMHRPWXdaS0ZvdzdXekN5bFBV?=
 =?utf-8?B?bjZnVm55UFpEQnlrQ1JCQTUrQVlFdDBzbENPM1ZYdXpKdzN1T1poSUpSR2Vs?=
 =?utf-8?B?OTlJTlpjeURBWFBTU0NtWEM4RUxEYmM2TkJTK20rc2NELzA2cUxDOXlnY3hI?=
 =?utf-8?B?YWozeCtmS0hYK2M4ekszaEpETjZiK3NYNnAxY3BwR2VnN2UrT0xaaGRGWHZw?=
 =?utf-8?B?RzFVZmFVUm1ybG8veUIzYUxSdGNWRWRvcm5BY0lpclRSUHZWU2JSWlZ5dkI0?=
 =?utf-8?B?S0Z6RFB3akhWY1JmdFhUY3B2WUdYNEIxd3ZVT0xHaVM5SGFiZ0tFTXo4aThX?=
 =?utf-8?B?NUcwMWIvdzU5WG1PL0o3UHRMdUVTajRXYUJLNjlQeGh2TkM5b0ZlUHJ4NThD?=
 =?utf-8?B?VlNrQ2FQQ1U2Rm5MSUJ4ZXpjd01WeFZ2bCtpYWlIUXo0ajFNaU9vd2pQMTBF?=
 =?utf-8?B?YmR4Yjh3Yjc5MENCZ1A3bnF3aUtocGhSNVhhZTNGcTB5S2hkcWIwU0pJaWpy?=
 =?utf-8?B?VklCYWhLTk42bkpHcnJCYjR4VWZUdUlkRHZLamlLUVRHVVFGRlBOWkx4Q2FP?=
 =?utf-8?B?K1N5aWdDZ1pqTXZ2by9ZZ0V0UE9SY2loL0Y1ako0UE9ja3RTUVFnRnc4cE4r?=
 =?utf-8?B?cGhzSm9MekNPVWlhcjRoYWp0Nm5SLzJ0c1RkNHVZZ2YyWFIxSlVrbEc1OG9Z?=
 =?utf-8?B?d0FJVEg5NUdDbjVDVG1oc1FCUFdzWVFJSWc5azk0WnNlYkRxSFV2NXVsSHhE?=
 =?utf-8?B?YWNLdUMwdW9pYmpWNWlmcXNySXpYQ3BNSVRlWThVMlVKaXhETUVGcXR1VkJ1?=
 =?utf-8?B?WWNmR2lrRGJhS3JDVUZLRkRvcGdKM0xkVVNxUk04T2dWZHZ4VXZkVEI5SCtR?=
 =?utf-8?B?OVJLUFFUdkhNSlVkMGhZUG9ocVhWc05OVkRtbFlqSWF2VXIyVldqR2tJajJw?=
 =?utf-8?B?bGI0d2pROURhUzRZWFBKeDZWRzZnL0VZYVJFbHc1Q1hhelF2MGtkUlNzRlJC?=
 =?utf-8?B?MXh1VnBDTXByaXI3eWVyVXc3Wmxmd3JDRVZRNW04Ky9RSXUyM2M0S2tCQWE2?=
 =?utf-8?B?Qmw0ZDAxZzUzVGJIME9vNlBDcXB3alE1N2pkRjZ3QnVCM0Q1VnJUbXZLMnZK?=
 =?utf-8?B?VElYdUJXMzk3Q256cC8rMmtJcWlRa0VUNVg4ZHJvcFgwdlptcVhDSkwySE5q?=
 =?utf-8?B?UkNtVVpmdFVLZWFUOVVsWHBWKzRIOGpNNlRYaFRLV3NDOUlaYkZ4TE9scHZw?=
 =?utf-8?B?K2ExR0hsYUxVNk41aU9aZ3lnN3loTDVGeHJ1bWJyV0lGUVFKNURXRFByYU9l?=
 =?utf-8?B?d1lRZ3lxbzNCZzF5eW81djdBUlNlNndJbnRLeEhJTk1xTTRSMkZmSVZoMzFQ?=
 =?utf-8?B?R3BGMjNaYzJoRXJNRE0zQVhoNHFSMVB3SU5WNnpTOU5JL3EyUUIvaUo1dzBp?=
 =?utf-8?B?YnVKQitQNkVMeUd0YTBKZjM4cHVZK0dBS1AxMVAzQ2VKOTdHeFBMclBJNFVq?=
 =?utf-8?B?UHdwTjVHejBQUko5VEQxd3BsN0d3THFsV05jUVIrT3BiSGd0NDF4Nit6Qkhn?=
 =?utf-8?Q?aJOU=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc755129-fe11-487a-028b-08d9bbf27a89
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1753.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 15:33:56.3474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uIW56HFGrrqUuygSvjY9lTniK3n7o6xYaozWsrUEylwT+z5tzZ0x6HbavdJPsZQQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3307
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2021-12-10 10:12 a.m., Greg Kroah-Hartman wrote:
> On Fri, Dec 10, 2021 at 09:46:08AM -0500, James Zhu wrote:
>> On 2021-12-10 9:35 a.m., Greg Kroah-Hartman wrote:
>>> On Fri, Dec 10, 2021 at 09:14:30AM -0500, James Zhu wrote:
>>>> On 2021-12-10 8:33 a.m., Greg Kroah-Hartman wrote:
>>>>> On Thu, Dec 09, 2021 at 05:09:56PM -0500, James Zhu wrote:
>>>>>> From: Yifan Zhang <yifan1.zhang@amd.com>
>>>>>>
>>>>>> commit afd18180c07026f94a80ff024acef5f4159084a4 upstream.
>>>>>>
>>>>>> When IOMMU disabled in sbios and kfd in iommuv2 path, iommuv2
>>>>>> init will fail. But this failure should not block amdgpu driver init.
>>>>>>
>>>>>> Reported-by: youling <youling257@gmail.com>
>>>>>> Tested-by: youling <youling257@gmail.com>
>>>>>> Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
>>>>>> Reviewed-by: James Zhu <James.Zhu@amd.com>
>>>>>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>>>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>>> Signed-off-by: James Zhu <James.Zhu@amd.com>
>>>>>> ---
>>>>>>     drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ----
>>>>>>     drivers/gpu/drm/amd/amdkfd/kfd_device.c    | 3 +++
>>>>>>     2 files changed, 3 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>>>> index 488e574f5da1..f262c4e7a48a 100644
>>>>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>>>> @@ -2255,10 +2255,6 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
>>>>>>     		amdgpu_xgmi_add_device(adev);
>>>>>>     	amdgpu_amdkfd_device_init(adev);
>>>>>> -	r = amdgpu_amdkfd_resume_iommu(adev);
>>>>>> -	if (r)
>>>>>> -		goto init_failed;
>>>>>> -
>>>>>>     	amdgpu_fru_get_product_info(adev);
>>>>>>     init_failed:
>>>>>> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
>>>>>> index 1204dae85797..b35f0af71f00 100644
>>>>>> --- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
>>>>>> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
>>>>>> @@ -751,6 +751,9 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
>>>>>>     	kfd_cwsr_init(kfd);
>>>>>> +	if (kgd2kfd_resume_iommu(kfd))
>>>>>> +		goto device_iommu_error;
>>>>>> +
>>>>>>     	if (kfd_resume(kfd))
>>>>>>     		goto kfd_resume_error;
>>>>>> -- 
>>>>>> 2.25.1
>>>>>>
>>>>> Like I said last time, do not change the backport unless you HAVE to.
>>>>> You did it here again for no good reason :(
>>>> [JZ] Yes, I should add more explanation next time.
>>>>
>>>> Backport conflict fix to remove  svm_migrate_init((struct amdgpu_device
>>>> *)kfd->kgd);
>>>>
>>>> new AMD svm feature has not been added for 5.10 So it is safe to remove it.
>>> No, I am talking about the fact that you fixed up a coding style fix in
>>> this backport that is not in the original commit in Linus's tree.
>> [JZ] I see. this fix is not necessary. Do you want me to send v2 with
>>
>> this unnecessary coding style fix dropping for backport?
>>
> I took what was in Linus's tree already.  Please verify that what I
> applied to the queue still works.
[JZ] I verified it. It still work fine. Thanks for correction!
>
> thanks,
>
> greg k-h

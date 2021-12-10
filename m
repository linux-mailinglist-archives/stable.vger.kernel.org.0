Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136A0470316
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 15:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242341AbhLJOts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 09:49:48 -0500
Received: from mail-bn8nam12on2045.outbound.protection.outlook.com ([40.107.237.45]:48864
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235695AbhLJOtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Dec 2021 09:49:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQusr1LFNugYLGHGqMfaQ+GoTVW+gpInJ29g7fNzBym8ZDRqtun8FxsfdXRPpMS7ijBau8SoaOQbZLQh1kPbgDKeHvRYLUb7J10U761ANuUpNFSTuzVUr3mUKLlpa7CnGgsywWpxjTKMlFozbK5RZNV3eii2IE1mdrZcKEK0WxPtDl7rrm/lTd0mF/E+lXCc0QKN/ezN/Y27VRE0tP3o2LmZCw8PDBehcgAbux6l/EzXLgQUZBLrTre8TbwXvybUqbdpSZU4nL6mBSip2uoX1S0bE/AtQyVBE3IBn6SBdd0wC8WMHpQMcdBHRF0rplm0Hu+pIstmOM4GCx4310IuMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wda2c7HRMNNk4CzqgIlFQAa7Xosc4yicoQ5+GxIjwDw=;
 b=Q/V5a0LLxkOQ03yICVRifHeC8qXQxdeJJMMbeBxpZw70ndn6WyGBKB/8kNDlmjhKbKebHXcOEPY8dZasH5JKnK4r4xE/5RvykjRNBwa4MZ+Ql72X4zbcpZt/f8tVm8Ftlx/FF/Fb+KMD6V4zC0hAMCNPOS230s0Z46L4XbJxOOQbilPACJpBVXzHlGvq120cc/wZb6MZkc6iddyI/gGxGF8ZJ7cBjfZnoyr/2bzIRNdIoBNgbY/a6ROhjtsTm2rLPEd0C0aPqIPNIcf2hGQx8lNEk5UEmgqhuwCDUNaf1LeS0564qaQ5EIHVrgBfsY2csMOTVvc2/JFeob0pfKIfkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wda2c7HRMNNk4CzqgIlFQAa7Xosc4yicoQ5+GxIjwDw=;
 b=JVffocm5+xLXbL5McJUfDDVnUk1/qg2EIg50PFrRxRfT1u4Oa4L3wYu/oy4vwrHyadq2CsiBSvPu+aePr23STVRnf2jysPE8feR5YeSrvLYrQOx6zBBH0jG3jVeiHCCM/LGgXum+Z+gVZt/tqov7In+2oSv/w/tfxI/cRt0/mg8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1753.namprd12.prod.outlook.com (2603:10b6:3:10d::16)
 by DM5PR12MB2583.namprd12.prod.outlook.com (2603:10b6:4:b3::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Fri, 10 Dec
 2021 14:46:11 +0000
Received: from DM5PR12MB1753.namprd12.prod.outlook.com
 ([fe80::9d61:180f:e2e0:2db5]) by DM5PR12MB1753.namprd12.prod.outlook.com
 ([fe80::9d61:180f:e2e0:2db5%8]) with mapi id 15.20.4778.015; Fri, 10 Dec 2021
 14:46:11 +0000
Message-ID: <56c017a9-8def-4f1c-5c4e-f4977da0c3d7@amd.com>
Date:   Fri, 10 Dec 2021 09:46:08 -0500
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
From:   James Zhu <jamesz@amd.com>
In-Reply-To: <YbNluFUESYFvuWO6@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0407.namprd03.prod.outlook.com
 (2603:10b6:610:11b::34) To DM5PR12MB1753.namprd12.prod.outlook.com
 (2603:10b6:3:10d::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55966cf5-d672-45fc-e731-08d9bbebce93
X-MS-TrafficTypeDiagnostic: DM5PR12MB2583:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB25839DDF77E62987D1F73D7FE4719@DM5PR12MB2583.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:489;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l9/V91Kc3yr/XFxkr2Q+289XSquvtCeytcCFRGFwmzJRB8qPf8MGPWO9rFJRtPblwm5y3V/lhYIXCc+nc78Bopc/D2qmPXDzI7us0Mk2iAGZOX8abve+09kXfRBPnCqMrLuQP+kYhqSSSk7vFwh8wInm8NXmjuNvy8rm0sTv21Cf1kmf7bWygXr5iPg9K7v9k46osFRTgyZCN1sR6wT+y44x+KvcTWuNCETLt28E33WoLj0a0eSI5RUrduX2R6tirhnR7S5vxUKZkIXdZuOUmxkSo4xlFnNv3I7aVmAzTA4MieJzMW1Ki//VoSk+Jv0gBC3h85RIeN3ecC/jZU5g6JE1qXBH4zQ6cQskHOwHTzEiPCygwM9aA/1mTeLKWRr95p/4jYZLmmIliYglmC+Y7rKmmy0V2slxpKv3ecKY+3FISgtM4BWf461+n0SWx/U7KOV9vzo/xxSL3jDYLeJjVDA2x6j49NMUB1eCu57RfbeeePVyldKbNGKnkIgH847GLo8/yvEMD9m62UrxOXXBN+V+lA7xWD2OMJweEOaDzLWu1QJo+iZ52pIANhOy6aS9RTTdCA766GzKQx93WCjx31F0HFRBqYKG/7DcJqprSCpfX/KMLGVd3uL1g7RwMhiUrQ2NTKI697imsMESU+vgUjbgn8fqUg93pfjHG/atNHgb74RKpd+pEz8pSCL+ZGHNuxQP6vkQmEaHf7TINITRg5413CqRGEggo+jivUzx4QyVCsKdoqd/Ybbsfr3aVaFL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1753.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4001150100001)(2616005)(6916009)(5660300002)(31686004)(6486002)(2906002)(316002)(8936002)(54906003)(83380400001)(508600001)(186003)(66946007)(66556008)(66476007)(26005)(53546011)(6506007)(36756003)(6512007)(4326008)(6666004)(8676002)(38100700002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3N0Z00zWTArY2grdlB2YzN6REVralh1OVYwLzJzcUtreEZ0UHh2Z2IzYXgr?=
 =?utf-8?B?TENUbTY3clN6KzVERVpNNDYrUzBVaS9pbjBtb3Z3RGJtZ2lQaEd2Mmo5UzNw?=
 =?utf-8?B?bVZOU2l5WGlLWnB3cExHUXdwN0FqaEdTQVhSc1NzaEV1Q1YrbEJjYTBob25V?=
 =?utf-8?B?dmp3bGJkMTJmcmkzWEw3MWorbU4zVzNQTGRHWWI3TkQxWGQ5dHpXS3pVT29C?=
 =?utf-8?B?Mml0S2dSMlBlSVZlSjBHNTM0K1VsM3FxRDM4WDRGV2ZFcVF4YlFPQUZ3WVo3?=
 =?utf-8?B?Z3I5T1ZFcnBLaUlndzkwV1lQTzNOWUljN2w4QTJlU0Z3a1JldGxGRHozWFJO?=
 =?utf-8?B?NHFCWWdhcS9yYUF1S0IrSFBZZEIrNVBqS3NpazNwUy9FUklXL29aVlBvdjRp?=
 =?utf-8?B?UE40NElkKytQMGhmSElsbWhNdHZOWFAzV2lnV3diMzBrUURFQ1hNU1F4QkQ3?=
 =?utf-8?B?V1JEUjRVNE0zSHdkM3ZsZktiQmZkK0RXUDJqLzlrbE1YRWxudUJrS1hrd3Nz?=
 =?utf-8?B?SExGc2Y2OW9ZOXpSMVRCNWd0Q3FHREUvOVM4ZC9uOUJ3N2RrZzZ5Z21QV0Ft?=
 =?utf-8?B?aHhOUkhEMy9IWFMzaHBpSW0yTVl3OC9uWmZrckowRFhQNXhnTUt4Vml5VGZK?=
 =?utf-8?B?MWh0akx0MFR3K25WWjVKOGV4YlIyUDc5MVBTbGs3R1VwTm9HY1VScUtqN0tB?=
 =?utf-8?B?ckFsV3l2L01MeVo4ZVkyT25jODkvdWd0SnpkdXlZWDBEQWRabUg4SlJ4cUg3?=
 =?utf-8?B?dTJPZzZyeHh2MGI2TUNiRTA3WkpZVlBVYlhWaUpkSldHVVUvS3pqd1p4TU1i?=
 =?utf-8?B?bm53eUFFdnNrZzBmTGhIUTJnS2kzUXJGcFh1R1N2djlOZTRBNXlWRmxRd3ly?=
 =?utf-8?B?WjdhRXRCUjFwb2d4M3lOOTNOVGFqVStnRis0YTZkRHNlS1RMbjgrZWFxVHF2?=
 =?utf-8?B?bWtBOG9sNElaSE1vTDVkcWJyUFV5Sml3RDl6MXZGMnNzZHBJZkdiKzF2MFVT?=
 =?utf-8?B?ektzNjh5ZWdFM1oyVjltblhvenVaM1oxYUlENUhlbXBibTFJZ1BGQTBlRjZR?=
 =?utf-8?B?SGVvSys3VW5TdXF2d2dNYkFjelpmUld4VTlBS1B3YVFJMnQ2d1hwTEt6UEhW?=
 =?utf-8?B?RWYxQnJiQUw4VnVwWUhtQkFwNnNGZzNvN09uS1ljTDNSeHhrblpqUUtpTjN1?=
 =?utf-8?B?djU5aWhmalZVS24yVmltRVFFaHlhc3phcDFkL2w1RW5YZGFZOVg1YkI0RDIz?=
 =?utf-8?B?WmdPMTFvZGFpYkFQVXhnUGxJc0wwb0xudXdUbE9nZXlZaWJ1Um5ISWpFUWo3?=
 =?utf-8?B?aDdyam82VVB2TUl2SVorVXRWcUg4ZkFjdDdNM1c3RzUyVjZRbGZQNmRzNXRj?=
 =?utf-8?B?MHNDNDhUMzdQTjNUWjc1aENYSlNCTkg3WXpYMTBNN1BRaU4rV3phYytKRW80?=
 =?utf-8?B?cEREWXFGemtaM0dTNUVmVE9YMEFscDd1NHZ3bFVKaTFCdHNDdDdsQkp6RTRE?=
 =?utf-8?B?VEY3MW53bU5rUmE5cXZ3dlgvYXNEUXg4OHZVWlU2VlVjRyszZGFjRXlTeXJJ?=
 =?utf-8?B?MlN0cm5GWGlhUE4xcmMyRVM0Ykk1OU52Z2ZCdmhvVEJHYnJodGxxOFpyV3NL?=
 =?utf-8?B?NWh5QlQ5S0g1Nlc1RzMxWFAzcjZwaUVNSzc3cFdjemZndnBZa0V3SjBIRG12?=
 =?utf-8?B?R3phNXBkMGFtKzNXbkNjLzZObHgyaStCZ3ovQ2E3YTYremEzU1NqRnRQeTZz?=
 =?utf-8?B?MmY2ZXZqb0hRdUprTnJmY1MvbzgwcXF0OGYvclFTVFVKVGgxVEFodHYyd0ww?=
 =?utf-8?B?eFVMSFNtam13a3ZYNVNrWCt6ZENlRTVvbHJ4RXh1MHg2ZXQwTXRETmpMUVR4?=
 =?utf-8?B?RmNERllIa2FJaUM3T0ZGcDFoWURNM3g5bjc3VFluSnFLamJrR2RkZEhUbTk4?=
 =?utf-8?B?QTczRkVmSkUrY1Iyalo0UDhHaENSSE1IUGpPTmJKRDJ0U29QZmNGU3dJcjFD?=
 =?utf-8?B?cU5lMWdIV2dwZENhS0FHbWhmQXdSSlBidFB1dTZmY3luZUV5YVhrZ0VPQnRm?=
 =?utf-8?B?cnVITFBoblhsTEVJd3BFaThwalUzTk0rMDhhdXhjRXpNOUxjeGFNMTZBWmRy?=
 =?utf-8?Q?+Lj4=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55966cf5-d672-45fc-e731-08d9bbebce93
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1753.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 14:46:10.9442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VNNKZ96rKdvniapQjTmmhcAbsu/xbAlQFooDym4wRvEvBAKc+x7Fio6Juf35WeXX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2583
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2021-12-10 9:35 a.m., Greg Kroah-Hartman wrote:
> On Fri, Dec 10, 2021 at 09:14:30AM -0500, James Zhu wrote:
>> On 2021-12-10 8:33 a.m., Greg Kroah-Hartman wrote:
>>> On Thu, Dec 09, 2021 at 05:09:56PM -0500, James Zhu wrote:
>>>> From: Yifan Zhang <yifan1.zhang@amd.com>
>>>>
>>>> commit afd18180c07026f94a80ff024acef5f4159084a4 upstream.
>>>>
>>>> When IOMMU disabled in sbios and kfd in iommuv2 path, iommuv2
>>>> init will fail. But this failure should not block amdgpu driver init.
>>>>
>>>> Reported-by: youling <youling257@gmail.com>
>>>> Tested-by: youling <youling257@gmail.com>
>>>> Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
>>>> Reviewed-by: James Zhu <James.Zhu@amd.com>
>>>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>> Signed-off-by: James Zhu <James.Zhu@amd.com>
>>>> ---
>>>>    drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ----
>>>>    drivers/gpu/drm/amd/amdkfd/kfd_device.c    | 3 +++
>>>>    2 files changed, 3 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>> index 488e574f5da1..f262c4e7a48a 100644
>>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
>>>> @@ -2255,10 +2255,6 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
>>>>    		amdgpu_xgmi_add_device(adev);
>>>>    	amdgpu_amdkfd_device_init(adev);
>>>> -	r = amdgpu_amdkfd_resume_iommu(adev);
>>>> -	if (r)
>>>> -		goto init_failed;
>>>> -
>>>>    	amdgpu_fru_get_product_info(adev);
>>>>    init_failed:
>>>> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
>>>> index 1204dae85797..b35f0af71f00 100644
>>>> --- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
>>>> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
>>>> @@ -751,6 +751,9 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
>>>>    	kfd_cwsr_init(kfd);
>>>> +	if (kgd2kfd_resume_iommu(kfd))
>>>> +		goto device_iommu_error;
>>>> +
>>>>    	if (kfd_resume(kfd))
>>>>    		goto kfd_resume_error;
>>>> -- 
>>>> 2.25.1
>>>>
>>> Like I said last time, do not change the backport unless you HAVE to.
>>> You did it here again for no good reason :(
>> [JZ] Yes, I should add more explanation next time.
>>
>> Backport conflict fix to remove  svm_migrate_init((struct amdgpu_device
>> *)kfd->kgd);
>>
>> new AMD svm feature has not been added for 5.10 So it is safe to remove it.
> No, I am talking about the fact that you fixed up a coding style fix in
> this backport that is not in the original commit in Linus's tree.

[JZ] I see. this fix is not necessary. Do you want me to send v2 with

this unnecessary coding style fix dropping for backport?


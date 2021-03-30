Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B5B34E8FC
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 15:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhC3NZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 09:25:08 -0400
Received: from mail-mw2nam12on2041.outbound.protection.outlook.com ([40.107.244.41]:11105
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231873AbhC3NYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 09:24:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdtVlgc6GuzWKQ6BGsycrDMd/Um9yn3hlBZwYYuzPKF22nz0BjSh1xuvkQPqjwvyyEFKvSCHI+WWN8Kbx9Ic7JhR7roUZ46uQ1SyBZuQCvhWRSNwxlV11AibwlMVHN2nsUvmtz86OdzXvSBVWV+cUKFiJ78jwvQCBP5l+KBWgSVMdjSxqQgL4SuhZmYXFwQOPINTCbxwcmA6fXL/+SNZV1fO/m8IFz6IdIs4nxR/B3ylsiteU0wq85jozghV+3CLEmVmBqnBJwVGCcvMeURdbyqThhRp60+OAAJhSC/T9U1BEJ1dlFE1q013pD+1xpMLKVwEsYq+bSVEtyhfYQIoZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJ0x84J5poB4WFRROyCCG8txcnE/4CLWWFdw+rKDSLg=;
 b=jep5jj4V6LG35EwwQigU9rd4YEdhHhL9OvEKgbDRXPiYMsL3vJa6WZ0irVTJTEBCWznHJs9l1e/qeJPWKu2hbv6QaD19YgoBS6p5dPYmm/gGL0xC+lY1Fi6VbQiOEcsI3KC++n7xP2aU5IolvoFE/5ODsHqRTDrhoM9rkyEay+JIWj93pmGcQNBaySGDiBexEz58sCn6TL8amUN/dMJf7qsciKsabLqdFmnVG+R828ZMVLm0qQkuQJ1sryVH3kCQlpiaNqN+FR7auu7XY4m0Xv6+sJcCdmB19Qx8IsMVpWFKoyew35/I2NzRkDTr2vI7AAsRlwbk0FcrAEz2jDHoXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJ0x84J5poB4WFRROyCCG8txcnE/4CLWWFdw+rKDSLg=;
 b=PJAgrULsgAOw/1e77XJByW5iwf5Ao90RpORdsoz2Gs7EUpBHPGYV0Xv3LkqyY7qBzW1fKEW44vI0U22uqGKFvkCyBu3L+3PJe0cgjetcOKzClHYnI3B1L8tj8rRSsKPBRn/FMUKdWEk9uFC2jLU717rucxR5F0P6ZcZKVmAWByI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4319.namprd12.prod.outlook.com (2603:10b6:208:1dc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 13:24:40 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2%2]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 13:24:40 +0000
Subject: Re: [PATCH] drm/amdgpu: fix an underflow on non-4KB-page systems
To:     =?UTF-8?Q?Dan_Hor=c3=a1k?= <dan@danny.cz>,
        Xi Ruoyao <xry111@mengyan1223.wang>
Cc:     =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        David Airlie <airlied@linux.ie>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        stable@vger.kernel.org
References: <20210329175348.26859-1-xry111@mengyan1223.wang>
 <d192e2a8-8baf-0a8c-93a9-9abbad992c7d@gmail.com>
 <be9042b9294bda450659d3cd418c5e8759d57319.camel@mengyan1223.wang>
 <9a11c873-a362-b5d1-6d9c-e937034e267d@gmail.com>
 <bf9e05d4a6ece3e8bf1f732b011d3e54bbf8000e.camel@mengyan1223.wang>
 <84b3911173ad6beb246ba0a77f93d888ee6b393e.camel@mengyan1223.wang>
 <97c520ce107aa4d5fd96e2c380c8acdb63d45c37.camel@mengyan1223.wang>
 <7701fb71-9243-2d90-e1e1-d347a53b7d77@gmail.com>
 <368b9b1b7343e35b446bb1028ccf0ae75dc2adc4.camel@mengyan1223.wang>
 <71e3905a5b72c5b97df837041b19175540ebb023.camel@mengyan1223.wang>
 <c3caf16b-584a-3e4c-0104-15bb41613136@amd.com>
 <f3fb57055f0bd3f19bb6ac397dc92113e1555764.camel@mengyan1223.wang>
 <63f5f6b39d22d9833a4c1503a34840eb08050f75.camel@mengyan1223.wang>
 <20210330152300.b790099debcd7659e30d9bfd@danny.cz>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <92dc0767-0c4e-34bc-d1ee-66105d0f2013@amd.com>
Date:   Tue, 30 Mar 2021 15:24:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210330152300.b790099debcd7659e30d9bfd@danny.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:8ca4:a46e:6aa7:208c]
X-ClientProxiedBy: AM4PR0202CA0023.eurprd02.prod.outlook.com
 (2603:10a6:200:89::33) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:8ca4:a46e:6aa7:208c] (2a02:908:1252:fb60:8ca4:a46e:6aa7:208c) by AM4PR0202CA0023.eurprd02.prod.outlook.com (2603:10a6:200:89::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 13:24:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d6286797-fb23-4a29-443c-08d8f37f2c61
X-MS-TrafficTypeDiagnostic: MN2PR12MB4319:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB431961D981F8D5A94C3716A8837D9@MN2PR12MB4319.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /XPM1BYhaRciknELwHBzY44vutTH7zuS3GCI0mVJ8lV81nyXAW8LUGRNpvI7vvsnBlpNAe3yDYdqvYdoptXtWFScBULNv4YLcavXnpiKR3XudQX411P47gpUDwA7hZUqpsazz9ZkkT5VmGIv3fUropa8Xpa5i8IXIvSjxodKAqsDs1YM/gveom9V17GPMcQ3h7Nt+VNkjpgVdpWrImUHtoMra0kUUyozH3Rs70VVjHlxliPOaXSbnQ4WqXpLVfkVVBbLlCklqJ9POPdY2ZVv5Fusn0SSXOO/BgxpAd6YWSLJeVm0BTkUx5ciWJLPBZz09k2aiKkALSCNmWde2PFCh4frQVqq1kvXtC3b50B9EcWn1JJU6h2WUArKLhASuo98z/woOA9IJOgG6kMasTbFu34erwK84Nk30Fy6FQaKpJx0B03fWdpZdr0Br9We1NsSdeJWreHSrHHYZloqNiSNK6+q6RhO+Idk07XhSkGVb17aUc1TY8OKAC4qERX8oKRILxMoFyehe92R2iPkSbEfWtW7ByAou55AcrigNds06KyG214AhgGaU49ZDj3etcbvCR3k+QIw+l/KPlO7ogipLZlYJj2Gywo/b7cBaBcratcEBHyFV9HaIwZ2fbZfyw4Rxw8+BgFxHgu5oTDxt7i+oUASQgSpqBB1W6sLSQJjqO3aA1mzX7Wb4jiu3L76DqTbhKaTQY1k9DqSNps437BFlnuP2YM7QnaoIcurjx1WkcYtFLyjfK2T3qbYzN0jsrY9fczVhkQRDkzcft1fpPIeJzGNWPp2PkG/Np3KLkm2xJaF9Q0nwAZBsV3koAEWOVq1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(346002)(136003)(39850400004)(186003)(316002)(66476007)(36756003)(6666004)(6486002)(54906003)(31686004)(86362001)(66556008)(16526019)(31696002)(66946007)(2906002)(966005)(4326008)(53546011)(5660300002)(2616005)(45080400002)(38100700001)(8676002)(8936002)(52116002)(110136005)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TjBFL2s4U0JkWVZRWTJMZEdEZGxiNGY5ZElhck5NanE3blZXSFU0RjNDckxu?=
 =?utf-8?B?dlErZGxrbjRNOWxqOGRBeHlsaEFHUzVDMS9VQmFCZWNUL2hMclV6NEE4RXQr?=
 =?utf-8?B?SzB3VGJaQ0UwRHhjZitzM0ZpdFdaTW1MUkRiWG1JMk9weGtGcCtlcnd3bDRK?=
 =?utf-8?B?T2Fra1hjRS9WYmp0Z1p4UFF5VXQ1bk1pem9FRm1wQml2cWVmdVp5dXR1U3Q0?=
 =?utf-8?B?bWZKRDVicktQNUVhUTlTOUpqTzM1dHlwZHBkUHR4dm1nWlhUSi9UeFd1NzIx?=
 =?utf-8?B?VlRPaGNkQ1FWQThUaUY3LzE4ZU5wTXlKUWNGeTVuTHp5ZEtyZ0YxTU5yYkQ0?=
 =?utf-8?B?TkNuK3BySk5OU0VGb09uREpSbTVoRldyVEhubmhDYUg1UW5rVStQNHlva1h2?=
 =?utf-8?B?WVlYR0tMOUxSUmlZdlRuaDRacUxDRmhYK1pRVzYyWTZUUWhrSjZ4SHNqZlJQ?=
 =?utf-8?B?eUpnTG1HUHIzZ2FOUUJwWU5QZnpGRUVEQnlzZExEdkFsK2paY0IxQVhEYTl3?=
 =?utf-8?B?WTBXUkY3OG5WeG44UEpxRERqN3N3cjdLYit6TDJnSmNubVVkMU5aZHZUbHdv?=
 =?utf-8?B?SUZyN1FzODFLYlhWNUJ6MHRXZHVXa3NzUmU2bThLd0tBMlAzTXltODM4cXFy?=
 =?utf-8?B?SnZYR2lDN1VUck1Rays2b3lWQmFHWHpXaGY2VUhibG1rV2hvQm1aY1VreURE?=
 =?utf-8?B?d1VRTEFiVTVvMGhWVVp4VEExakN1Y0labDYxSFlROURPZVdVaG5EMWlyaDAv?=
 =?utf-8?B?d1ZWcWliZURtY0ozdGg5N3pGS1FvdFp6S2l3ZUxGVVU0dVNJNHVoNXVOblAr?=
 =?utf-8?B?OXdleGxnd3U0RU1SVDAvZE5iQzFUdnNGM0xTQmZmMmppcVZzam5qS1hQbUF4?=
 =?utf-8?B?WWNKWkpLb210NVFaWUpVOHZwQ1NSWERTTk5xeGpFdWZjOXQvSy9BYzg3b0R0?=
 =?utf-8?B?cEo5YnNudG5mSER4Y0daSjA5MUFCRURFbzRSWWNkeWNiZElYeWJib3lZcXVI?=
 =?utf-8?B?VjRYbGdENGE4eUJoVDI2ZGtraFQ1WUpyNWlZSDFvVUlKb2s2VzBYNE10TnhM?=
 =?utf-8?B?bVlGU1V5T3RmTHUvUDc4am82My8weFppVW9vc096Y0N6a0o4MDZuNkRUME42?=
 =?utf-8?B?ZEYwaklBVC9HY1ZhV3JsQmRSNWdMQjlIQ29pdWt2bjlEQW5XMDlTYnloSGZO?=
 =?utf-8?B?RmlDT0NtK1EwSk1RZ0lDUGJxeWx3NzhpQ2tTUGNUcU5Yd3JFR1REaURHM1Iw?=
 =?utf-8?B?bHhPNk9vVCtTN25IaThTaUVmVDR6ai8wRmg5emlGYnZCN21sK25EWnlKdkll?=
 =?utf-8?B?ZkNoWjMxWHYrQ3ExREJEQ0N4cnBFY21BeExlUXcxRC9IcW9OSUwvOHNEc1ph?=
 =?utf-8?B?Z3p0NUZJMzNEUGl6bENvc0hIVG9meWJ3dzdRSTJMd1N1MDhnUHVkNmttUDBD?=
 =?utf-8?B?ZHg2bHhPQVVyMDVUbkYyNFBMNnIzalhIcjBUcHlDZXF3S1JyZmVHYVpubTlX?=
 =?utf-8?B?VktVS0pRV1ByR1JtWE1YaThiYjl4cXJ4bW5OOHY0amUvV1hWSXBVS0JNNkdU?=
 =?utf-8?B?a2dRQmswTUxRME5ISWMyWWhud3BVWlhSdDFaemdxU1JTTHM3SzRXZHFZN1Ni?=
 =?utf-8?B?U3VkU1FpbEcvYThQUWF3Z0gwZ2RpTTBoeU1mOTg5U1hsbGVCZ04wc1c5K2VO?=
 =?utf-8?B?L1hIRzdtdHJXWFdsaFBRV0JmcUI5bmJLN1orcXY1R2diTFlaVGc1K2lCc1BU?=
 =?utf-8?B?cVJHRmZPU1hIWGRGUDB5ei94cWpITWNxcmI4a1BCMlBuNFRUUHRlbnZremRK?=
 =?utf-8?B?aFJrTGtWaFJVU2hONXpWNndpbDhIK2trc1diZ0IvVS9uaWV2Ryt3cjNpenVZ?=
 =?utf-8?Q?w82BukZQU5RLc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6286797-fb23-4a29-443c-08d8f37f2c61
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 13:24:40.5162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mkZWhTkDvBDS54tROuMBsYxDT7qPws62+auM9v9fdMFfyD0D/LMnesR2A2cBUCMn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4319
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Am 30.03.21 um 15:23 schrieb Dan Horák:
> On Tue, 30 Mar 2021 21:09:12 +0800
> Xi Ruoyao <xry111@mengyan1223.wang> wrote:
>
>> On 2021-03-30 21:02 +0800, Xi Ruoyao wrote:
>>> On 2021-03-30 14:55 +0200, Christian König wrote:
>>>> I rather see this as a kernel bug. Can you test if this code fragment
>>>> fixes your issue:
>>>>
>>>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
>>>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
>>>> index 64beb3399604..e1260b517e1b 100644
>>>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
>>>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
>>>> @@ -780,7 +780,7 @@ int amdgpu_info_ioctl(struct drm_device *dev, void
>>>> *data, struct drm_file *filp)
>>>>                   }
>>>>                   dev_info->virtual_address_alignment =
>>>> max((int)PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
>>>>                   dev_info->pte_fragment_size = (1 <<
>>>> adev->vm_manager.fragment_size) * AMDGPU_GPU_PAGE_SIZE;
>>>> -               dev_info->gart_page_size = AMDGPU_GPU_PAGE_SIZE;
>>>> +               dev_info->gart_page_size =
>>>> dev_info->virtual_address_alignment;
>>>>                   dev_info->cu_active_number = adev->gfx.cu_info.number;
>>>>                   dev_info->cu_ao_mask = adev->gfx.cu_info.ao_cu_mask;
>>>>                   dev_info->ce_ram_size = adev->gfx.ce_ram_size;
>>> It works.  I've seen it at
>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fxen0n%2Flinux%2Fcommit%2F84ada72983838bd7ce54bc32f5d34ac5b5aae191&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7Cf37fddf20a8847edf67808d8f37ef23c%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637527074118791321%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=DZnmee38NGpiWRMX5LmlxOhxAzBMhAusnAWNnCxXTJ0%3D&amp;reserved=0
>>> before (with a common sub-expression, though :).
>> Some comment: on an old version of Fedora ported by Loongson, Xorg just hangs
>> without this commit.  But on the system I built from source, I didn't see any
>> issue before Linux 5.11.  So I misbelieved that it was something already fixed.
>>
>> Dan: you can try it on your PPC 64 with non-4K page as well.
> yup, looks good here as well, ppc64le (Power9) system with 64KB pages

Mhm, as far as I can say this patch never made it to us.

Can you please send it to the mailing list with me on CC?

Thanks,
Christian.

>
>
> 		Dan


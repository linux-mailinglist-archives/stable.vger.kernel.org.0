Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E992034E843
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 15:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhC3NDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 09:03:05 -0400
Received: from mail-bn7nam10on2073.outbound.protection.outlook.com ([40.107.92.73]:21792
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232095AbhC3NCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 09:02:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWPyzQG+tA2KTUh40xdu+DBHeYASkrZKaecTh6G7D5a0OsohMfkYsbhq3O4pf7sMTFVdctWAbcOccqWPcmAq6MCNUqFLTxYJabUxM9hyM6Lbpan/MKuzrbESjRWqJ9cVO8DHy9W4opIrQJVmaxrx8g/nseKHOOc8pBYfgH9wajnVBMbMarBebPV6Dm5F6h3MkW5JlBMFZlzgzGZN8qss6Mgze+ZINzQY4U0It/04s/LMkW5auFk9pTqAQjgDNNsmlHtE52k6jV5BvPQk0HErsB8soTYnQpv/5ZtzYdrVP1AmbviLqYOJhaIAMihjuZfMGKIlfBIgMFd727q+QcAISA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mv+Kp5NHjAjb3NffPZvXt3nL8KucCuJ+SxfGqYIJIv8=;
 b=hZeFoKCoMIzhXZD7Chyab/jQxFqcfO1aOo4xnz5RvfBDS8JbcR1howwDpIrnFPvpnszip1zAOm81bHch9GVH+0gb2DuTE784EW/9jsCzHK24fY9IAbqe7KK0SCeKzrQC0/cSYGdX35dyH+LzFixLOi+m/pnDlN1q+Y9jvdD60vwyxwG9heC/lIjo4/jnA7M7Qydcw0oUTMAmARs5LNb+Ira9wQUXtI0+sp1NkmdZxR6y/0RdNcrAnwzjow04qxTir9d967ZJ0+7puqoquuYSBQ/VK9w5yVmyZcJufj9NN3xUfkMUQp4u02QUnU2+BQpvvm+S3J+5obYaWVgeEnFCVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mv+Kp5NHjAjb3NffPZvXt3nL8KucCuJ+SxfGqYIJIv8=;
 b=MsoRqmUK8BJIE8uQgXfTURcc3jCtLiRAytEUfwSv3Z5NeSGuDFE6PH5+3H99xWgQQeNn6Id12Hph0BYC0BbsQWEhKxvcvbUXHgoOigYQnVNHNVZY6slRL9+Aq2WSwGPrDCXpiUETKRjtj7nk6eN0XsHTYPr/Ta6mskPO0HY6CmU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB3965.namprd12.prod.outlook.com (2603:10b6:208:168::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Tue, 30 Mar
 2021 13:02:43 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2%2]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 13:02:43 +0000
Subject: Re: [PATCH] drm/amdgpu: fix an underflow on non-4KB-page systems
To:     =?UTF-8?Q?Dan_Hor=c3=a1k?= <dan@danny.cz>
Cc:     Xi Ruoyao <xry111@mengyan1223.wang>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>,
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
 <20210330150004.857ae73704c3533692cf79f0@danny.cz>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <fb652517-1391-4d89-fe12-72d3748ec49e@amd.com>
Date:   Tue, 30 Mar 2021 15:02:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210330150004.857ae73704c3533692cf79f0@danny.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:8ca4:a46e:6aa7:208c]
X-ClientProxiedBy: AM3PR03CA0071.eurprd03.prod.outlook.com
 (2603:10a6:207:5::29) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:8ca4:a46e:6aa7:208c] (2a02:908:1252:fb60:8ca4:a46e:6aa7:208c) by AM3PR03CA0071.eurprd03.prod.outlook.com (2603:10a6:207:5::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 13:02:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ffe114e3-aa90-4474-9fe1-08d8f37c1b48
X-MS-TrafficTypeDiagnostic: MN2PR12MB3965:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB39650FB902967913B9EEE7EA837D9@MN2PR12MB3965.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AT8+plVZsfuXPCmHQmUynhN+ab2Ev6Ccp0Mh7VxI+kNUV4ZAaYmbWDMcPzeDFbSJj4AjRIXKk614OtxqIg8Da1KxEE1XNC5nBmZpTUnYSflzIq1/8t0vto9BuFI1pZLmJq6cUsy9/tIxBgBIKmTmIAy0ZLAHKvtfAIZRm7CFN+g+XSKUip5/AmTc1GQOSQE2VyeBMxtGK8VHQySdT+H4lD1aJOlvqIdyRZzrMfrfOoSWSxRyVvlQQtz7lAQbPs81TpiJoVVIwy6ajgUrtzj+xAvF4Iepee78qwD/ADoNv2R2P0uiFo2q5i3rFp9F0sf5PkREA2+N6jZUb7850Wdcb8V0nhGXwNmeM5inA7ST2y9QaR7M2tuTZmq6XOZ1Uiqxy+yhmxIQbZzWucB/0k8+JEGFmjK7cfcF16HeVblFEDevxbGECiVxOQCVKo7+ST+Oar3LtmkoVuMYtBh9fA2j3rMouYroKI64pRe2wIpbEt8jrxrAmd0Qk9+J4w2JJqOldN+hzJe88so7YaunmbCjbeGSUvRfjnEvbYptvbfXoEvanlRP1/1uvTlSiL3M8R9ZUPuCN66M3AcSBUhVKS4IYP8L5MXP1rxKxdXA/Fx6Xe4Z8LX51oOE1fXI7z9pLixNBgukDI3iffxf1lQU29i659n8SMLmbuYAlEsbI7JtGL8OnOEgPjS7Uc3+q9XDascB1zQ+bjdRS3PkG+XIGh9YdVuCdgVy4S8SH1/UhaWdW7rUqQX8n95UWyYdWDyJPsYN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(66574015)(8676002)(45080400002)(2616005)(86362001)(31696002)(6916009)(478600001)(8936002)(316002)(16526019)(6486002)(186003)(66946007)(6666004)(38100700001)(83380400001)(66556008)(36756003)(4326008)(966005)(53546011)(5660300002)(2906002)(31686004)(66476007)(54906003)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aS9TbnpmaTJnUkN5SXRTYTRHcEhvOWlSYWNGbjRTL1U3d2RZSXhsV3F0VFNY?=
 =?utf-8?B?UmhlTDRFS09PaEJ5RGR3em84N3VGa2RzTXR6OWFrd2hTMkpOQ2Q4Y0MzYmRt?=
 =?utf-8?B?emlmZmRWL3d1bFdWdXVUUUVJNHhDdW1sckkvMWZ2aENJQ0RBREFKcTUyUjMz?=
 =?utf-8?B?V0FTbXZ6NkNqYkg3QmlURjRnR1krRE9NODhZOXZ4TmFkNDdMWEhxMkZFVmFH?=
 =?utf-8?B?R1k4TlFVaWNIZmt4VUxIZk1zWDFYelV0c0FUOWlLYVQzTlZoem9vSW1mUGdH?=
 =?utf-8?B?bFZwVjlJd1dDRzZQRy9zL2NFVytIaW4zM2RWSUtDRW9URWROanRocEUwalFy?=
 =?utf-8?B?d2hTME90YllNdTlmblJlSEJIVHFwN2V1SG5HcjRNYVB2TDZkT2lQRndIY2ZU?=
 =?utf-8?B?cjc5UWp4Sm42ak9SSldMeHlEK0lrUjBCRCtIZUcwamlEZGZWd1I1VEx1ZHVE?=
 =?utf-8?B?NTBtdEJ1UERwRHBSNFZ1RE92amdnaHpmVUNRSWZXN2JoZFUrMy9MM2FERGJn?=
 =?utf-8?B?d1RoaG1DNjdWMzB0T2pteXJsb3RITlBwd3lyZWNucVhVb05IcHpnMlhlY2FT?=
 =?utf-8?B?cGx2QnpBbTdNK1p4bmZ4azBxSlRLTVA1Qm5tWnlucXF4dUVOdE9sSVdXc1p4?=
 =?utf-8?B?SXF0NjRXeHJwYy85cnhDb3VuWW1yYmRHNDNMRkE5SHZjSkdKZzY4aWdBT3pY?=
 =?utf-8?B?MGFnQXhPc29BOC8zRVBqVmNPVzcvbUpFZituczM3UkZ5RGowR05BQlptYmlK?=
 =?utf-8?B?UVhDbnBRNG51N2xIbXZZTVo2TTFPKzUzc3liZUtTRUQ2TU9LaXorL0NMUkM1?=
 =?utf-8?B?OFhJNkRNT2FidjZuSUpkZW9tejJzYkhPSTVTZlFtYy82alZRR2pRSE14a0w1?=
 =?utf-8?B?NkxVTWZsSjRNTnppdHM1aGhqMDZSK054b05JV25nNitHYlBRYkcvNTV4THBP?=
 =?utf-8?B?M01KbU5UTG05WGdOVUQwcTI0VU1CR3VKdS9IK294Wk9rMjhwTS9oZFpueEQ0?=
 =?utf-8?B?WDM4RVA3K055ZnZ5VjdwTUxVMWZmR3g3cktFMlBGQzlHRkc1RWhRNE56WUQw?=
 =?utf-8?B?ditHY1BRb3NXeHo1WVhUei9pUkR1bmlraEY1UXBncUQwREZTSi9yeVRoUFhz?=
 =?utf-8?B?blAvNUtOY0ZVYVhWZjZhMkJaWUh0NUVMNGZma0xNZGswWTZaZHBFUWVITUsy?=
 =?utf-8?B?aStTQktHVm05QnJxS2R4dDNCV3hWMXFyeFRFdjBZeTJpTXM1b1o4OHVWOWFw?=
 =?utf-8?B?WlpwSUkyWmJ2aEZGOGxNM3hMTXNCalNVMm9WeER2TFovb3pSdVR2Vnp4dDlH?=
 =?utf-8?B?a1F0UHJ3TnR3bVlqdGVCYmFuY2xEN1pNYU9QMjRHRTlTT1YvVVNRRmMzTmNQ?=
 =?utf-8?B?cGtiZFBKZlRpMFZOa3RxWmF0VVdQU2RKb3Jsa0xnU1FIL1pETi9ibStUa1BD?=
 =?utf-8?B?SlFqeFhzcHZsZVV4NkhTcXRsbGJLbDNVNzl4emVTc2xKWTRGenBJZ21Xd1hv?=
 =?utf-8?B?OXMvQ3dtdGkzN3hiWUloSzQ4ZlhyV2Fvdlk4RHVGeDYyS1owbTg4YXZVUkk2?=
 =?utf-8?B?VWsxQ1FrNkd2MmtndjZ6RDY4bWc5S2RMMXFTUWNMMnVkK3NNMDlhR1plZmp3?=
 =?utf-8?B?dE1zaXNCem1oSEtYNXRJcUlCMmxhbG45SE5wWGZmMFRETjNaMkIyT1NLWGdK?=
 =?utf-8?B?VWdvTk42S2o0cU05Tlo2T3FLVkVScklJNW1VeTdkYkdJbHpCRkNhR1ZibzNl?=
 =?utf-8?B?NkE0SWhzaU1LSFV4SUxPUU10MDdGczdFT2x6RDRkcS9BS3pUemJMV05uWWUx?=
 =?utf-8?B?SUJsYk8vRGYzd202ZUhyemZJSGJlL2srZ1Q5TzBDK0Frck5wYlhvd1lIZUNB?=
 =?utf-8?Q?OgnxGsMxODIAa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffe114e3-aa90-4474-9fe1-08d8f37c1b48
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 13:02:43.3603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FeZXwzCh9/s3S9Xh8elqjbAWvmXUpaw2ZB6xLWbKEZTocfD5mdb7vNrllfhgfoDJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3965
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 30.03.21 um 15:00 schrieb Dan Horák:
> On Tue, 30 Mar 2021 14:55:01 +0200
> Christian König <christian.koenig@amd.com> wrote:
>
>> Am 30.03.21 um 14:04 schrieb Xi Ruoyao:
>>> On 2021-03-30 03:40 +0800, Xi Ruoyao wrote:
>>>> On 2021-03-29 21:36 +0200, Christian König wrote:
>>>>> Am 29.03.21 um 21:27 schrieb Xi Ruoyao:
>>>>>> Hi Christian,
>>>>>>
>>>>>> I don't think there is any constraint implemented to ensure `num_entries %
>>>>>> AMDGPU_GPU_PAGES_IN_CPU_PAGE == 0`.  For example, in `amdgpu_vm_bo_map()`:
>>>>>>
>>>>>>            /* validate the parameters */
>>>>>>            if (saddr & AMDGPU_GPU_PAGE_MASK || offset & AMDGPU_GPU_PAGE_MASK
>>>>>>                size == 0 || size & AMDGPU_GPU_PAGE_MASK)
>>>>>>                    return -EINVAL;
>>>>>>
>>>>>> /* snip */
>>>>>>
>>>>>>            saddr /= AMDGPU_GPU_PAGE_SIZE;
>>>>>>            eaddr /= AMDGPU_GPU_PAGE_SIZE;
>>>>>>
>>>>>> /* snip */
>>>>>>
>>>>>>            mapping->start = saddr;
>>>>>>            mapping->last = eaddr;
>>>>>>
>>>>>>
>>>>>> If we really want to ensure (mapping->last - mapping->start + 1) %
>>>>>> AMDGPU_GPU_PAGES_IN_CPU_PAGE == 0, then we should replace
>>>>>> "AMDGPU_GPU_PAGE_MASK"
>>>>>> in "validate the parameters" with "PAGE_MASK".
>>> It should be "~PAGE_MASK", "PAGE_MASK" has an opposite convention of
>>> "AMDGPU_GPU_PAGE_MASK" :(.
>>>
>>>>> Yeah, good point.
>>>>>
>>>>>> I tried it and it broke userspace: Xorg startup fails with EINVAL with
>>>>>> this
>>>>>> change.
>>>>> Well in theory it is possible that we always fill the GPUVM on a 4k
>>>>> basis while the native page size of the CPU is larger. Let me double
>>>>> check the code.
>>> On my platform, there are two issues both causing the VM corruption.  One is
>>> fixed by agd5f/linux@fe001e7.
>> What is fe001e7? A commit id? If yes then that is to short and I can't
>> find it.
> it's a gitlab shortcut for
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.freedesktop.org%2Fagd5f%2Flinux%2F-%2Fcommit%2Ffe001e70a55d0378328612be1fdc3abfc68b9ccc&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7Cd16d123aaa01420ebd0808d8f37bbf2f%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637527060812278536%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=5rFVLxSRnfHUGjhoiqx1e6SeROqbg4ZPef%2BxEvgv%2BTg%3D&amp;reserved=0

Ah! Yes I would expect that this patch is fixing something in this use case.

Thanks,
Christian.

>
>
> 		Dan
>>>     Another is in Mesa from userspace:  it uses
>>> `dev_info->gart_page_size` as the alignment, but the kernel AMDGPU driver
>>> expects it to use `dev_info->virtual_address_alignment`.
>> Mhm, looking at the kernel code I would rather say Mesa is correct and
>> the kernel driver is broken.
>>
>> The gart_page_size is limited by the CPU page size, but the
>> virtual_address_alignment isn't.
>>
>>> If we can make the change to fill the GPUVM on a 4k basis, we can fix this issue
>>> and make virtual_address_alignment = 4K.  Otherwise, we should fortify the
>>> parameter validation, changing "AMDGPU_GPU_PAGE_MASK" to "~PAGE_MASK".  Then the
>>> userspace will just get an EINVAL, instead of a slient VM corruption.  And
>>> someone should tell Mesa developers to fix the code in this case.
>> I rather see this as a kernel bug. Can you test if this code fragment
>> fixes your issue:
>>
>> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
>> b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
>> index 64beb3399604..e1260b517e1b 100644
>> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
>> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
>> @@ -780,7 +780,7 @@ int amdgpu_info_ioctl(struct drm_device *dev, void
>> *data, struct drm_file *filp)
>>                   }
>>                   dev_info->virtual_address_alignment =
>> max((int)PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
>>                   dev_info->pte_fragment_size = (1 <<
>> adev->vm_manager.fragment_size) * AMDGPU_GPU_PAGE_SIZE;
>> -               dev_info->gart_page_size = AMDGPU_GPU_PAGE_SIZE;
>> +               dev_info->gart_page_size =
>> dev_info->virtual_address_alignment;
>>                   dev_info->cu_active_number = adev->gfx.cu_info.number;
>>                   dev_info->cu_ao_mask = adev->gfx.cu_info.ao_cu_mask;
>>                   dev_info->ce_ram_size = adev->gfx.ce_ram_size;
>>
>>
>> Thanks,
>> Christian.
>>
>>> --
>>> Xi Ruoyao <xry111@mengyan1223.wang>
>>> School of Aerospace Science and Technology, Xidian University
>>>


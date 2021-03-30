Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C9234E807
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 14:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhC3Mzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 08:55:35 -0400
Received: from mail-bn8nam11on2052.outbound.protection.outlook.com ([40.107.236.52]:46187
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231574AbhC3MzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 08:55:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0EVsiQiEsaYCWzoW1CRSdW+gZvqcHSJwPkUt6rT9tzJdYC+6c7bCMMyZrDZ0kyPawiDOrrGtVxkWrnxFD6XitX0+6J/A4HEn9iUE5G9wnzX102OgyUG6ofEDGdzPG2PdqzShE+h8nyVT8caj2z2olt4QVAGJYJ4+bs08SVdbMf9vfDzwCfoFDa3gglpEM+Yp8/LMbX6nyH5Ut9XpgqigWXMuNip4nbPDzSc/aE4V254H02lmvXmHDzDHmiaoeEUYPCS9LkNeaUEFsJ7qJ6RK9/bg0QnhR6wRfaF9izeBkS6CdIqyGEBS0OMLs0qP85jkHxeSZovWBkQdyLZmZjw/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xv0jJ67lv4ReE4taYeTjyAIWHwk9KVcIQqH2c0xCBIE=;
 b=nTdqAzvaTQlfbR6V4l6qJHNGyEulERtS+ZJm3XtddNr2vAT5yHqrYOfU2kgrqQgFpIchNSiM1Hn1JKlmkx8P8srQCG1fIvtoP6/AiqzcbXE7Z31QXBPCNI5pHJFEPnqz6Vhx9ZSjh7tYT2B99mLhzkJM3S09TjscfBNfQa7GN+lCC14uxG3V1ui/IYjTeY6sLGqeds3wq6Fwcrq6ndMDazUCjcoadjav40BltCa0CIYzVX2u2KmmYLpNeHs9dp7GNgwFijtysHvNwPRmNFd3xw3Fzro2g7g3Ai2bHIsmpmcQSKByH6GQuB968RA9dKqNDdyhBtjrc/eLxWeVncgDdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xv0jJ67lv4ReE4taYeTjyAIWHwk9KVcIQqH2c0xCBIE=;
 b=lTKJJjyXhMxO/W0h6grvyyfRG5NOm2zynvakyYspt+8gG0LCb0zLlV+f6/XHrTmUhWOuwwAlhHJS4klaTPqOdFqYBw2fVis8rpfXRgdw+ccK+wEIsYpewZ3YWehA30k3gBtYhcyStn/tq4VZkueF0ZPhPSNjckyJG5gUv9a/Yns=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4606.namprd12.prod.outlook.com (2603:10b6:208:3f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Tue, 30 Mar
 2021 12:55:07 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2%2]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 12:55:06 +0000
Subject: Re: [PATCH] drm/amdgpu: fix an underflow on non-4KB-page systems
To:     Xi Ruoyao <xry111@mengyan1223.wang>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Cc:     David Airlie <airlied@linux.ie>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        =?UTF-8?Q?Dan_Hor=c3=a1k?= <dan@danny.cz>,
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
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <c3caf16b-584a-3e4c-0104-15bb41613136@amd.com>
Date:   Tue, 30 Mar 2021 14:55:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <71e3905a5b72c5b97df837041b19175540ebb023.camel@mengyan1223.wang>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:8ca4:a46e:6aa7:208c]
X-ClientProxiedBy: AM0PR08CA0007.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::20) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:8ca4:a46e:6aa7:208c] (2a02:908:1252:fb60:8ca4:a46e:6aa7:208c) by AM0PR08CA0007.eurprd08.prod.outlook.com (2603:10a6:208:d2::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 12:55:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b32fe342-0ff3-4963-0cbb-08d8f37b0b03
X-MS-TrafficTypeDiagnostic: MN2PR12MB4606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB46060196FF7529870D9E30EA837D9@MN2PR12MB4606.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SsZHLzXKLdfW3QWQUoWf8H5OikYCYu4S5UvCOgl6ahyz54RhwbPx0Xtf4imbHVCkh9S2D76HDDaef7y4EAPCzIsiUZwF/YddpClVYveKD8tHKde4pN4qNbokIoeYdxx90BrAl8E0yN/9Bjw2SQq5j41k0nJ6OtXniKUZm/Agi85ewk4jeHxC2f3Ms3ZZSSd1f3fYHOtQQkBXPYleI7V2DyyPswoSDc8sck6hAPyLqPc+cmK8OT7G3aOnANWywmHwZCPkXBcO1QxssJUOZHF89fdOgAStbaAlu83RxslAGx/WAWNxzjhW3twYh+LBgTF52GI07KOP+RjQpfy8j+aYj/R5KU2/kAW/8ICnb3ul5egLTm5jt3pFfrATrLXNpcK409kUzOA0fIY9LU9rWkKZPhv4TWqT5ugbE0eAV2zdPbAPanAXtDKhu2XgcLtBwfWRcIDY1pXPpjsOf8JqWHYZ2heIC1V2z9p8ixK8Sl86/6rpGNcwgVU/dyjGZvzMERxcPOq7OD4UDhoXEwutx3st61e+GXLvSxTigsDy/xXSN12e6m4l80bxDT1yIwKnDJaObXWQ7g+lAgrJQ0j+zTT8GpFPqM+qpjk+8aRUdlryEhvd+SWK3q+/QFgvd9ZnmYdv56DVNlnQZuIXXe/k4O68z8bwuLNjA4+N8ILei57Jk9XT4RbGP6Co6MygiYfRN65m2gc/XASUi4A3zDVq3dxoGKl+S1wqNNOp1mSRCA4dEok=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39850400004)(346002)(366004)(83380400001)(316002)(8936002)(6636002)(16526019)(86362001)(31696002)(38100700001)(53546011)(6486002)(5660300002)(8676002)(4326008)(66946007)(54906003)(36756003)(2906002)(478600001)(186003)(2616005)(6666004)(110136005)(66476007)(66556008)(66574015)(52116002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cGVtMlp1Uy9td0k0anRMSWFCYzBrcm05WTNqNEtkRDdFVm5TMDU0SUhhRXhZ?=
 =?utf-8?B?Z2RDcmM1VEwzKzloWEFFVUI2cjBJOGQ0YVEzRG5FMjNTZ2dSaCtBYUI3V09B?=
 =?utf-8?B?QlVlWnRaMjVVWHRha0Z4R3Z4Y0VxUzF4eVBpVWh0Q2tTOU5DRXNiUUFGWldP?=
 =?utf-8?B?WkNvZ0pFMnZNNVpTejY5dVJ5SkVxc1ArdHZ4SW9xS1kyOGFxOTBvcjNwWER2?=
 =?utf-8?B?dFA2TTlDeFlrOFlBMTg4YlI4bkVtTyt1bHhOQUFCbHJHSGN4TDVVVWJna084?=
 =?utf-8?B?MzNCeWV3YjVkd1Y2SlFRUi9kcnJtTmtMREp2SEsyWXFjYWFCQ1RPWHdETWwv?=
 =?utf-8?B?MmdJMFQ3QkhXT3RvZkRzV3daNUxtSFdHamE3RjZUOEppUnJyaWh5YlRiWVBr?=
 =?utf-8?B?VEczNVFkbmZNZlVXOWJYbEVLVnJLYnM3Qnd5V0ptVHNCTHBDQ1NMbzBzQVhQ?=
 =?utf-8?B?M1FWN0sxeHkyNktrWDJvbjA2d0pqWmt5MjdxQTg1c3Q0WFlnclBJNXY4TjRN?=
 =?utf-8?B?Y0dNa0tLRzllTzRkUlRLNS9FKy9GY3hCaDhWMWRzMVJWdkJkcjBqYWwzdFlQ?=
 =?utf-8?B?aS9PUjU2NGlnZWROU0ozby9DUFU1MzcwTFZwMFRMcEpFcVBMRUlKUE5qR3B6?=
 =?utf-8?B?L3duWGhKZEtuVm94ems4Q2NxbzV3MXpxdlJQTUtsVGlvVnBESndLTEJaMHd2?=
 =?utf-8?B?Q3dWRTlTYVYrRyswUGV3QkpLaG9LOCt1QnJPemtIRTV6Wi9XSExkRjBUNzZM?=
 =?utf-8?B?c21JNHJNOTVsUWFNcC9nL3NaRGNzdHpoekxpTjZQSUdlTlg3MmFZUXN0OVFM?=
 =?utf-8?B?SWdoekZXeVBqODRQa1M4OTNoT1FpbFZKcitJMGtxTk5zZjNYcUNMakVmdURh?=
 =?utf-8?B?NWc4RjNEMUVtWGpvSUc1L05VaXcwaTZ3Q3l1TVJqOU5lMzh0allFTTNmcStZ?=
 =?utf-8?B?Z0lSZUlGSTV2UVd3clFqSjFTdWwxYk9SMXdDSUNjV1lGQXMrNlkzaUtINzVU?=
 =?utf-8?B?UThNbDQyTDkzbGdpZzRvTTFJd1JFbUtaK0o2dnVqTyt5U3hnc2ZPWmU1SHl1?=
 =?utf-8?B?b2tjd1lyNkdHdTN1YmxPOVRXMTRZbkJqZzdONC8wdG16OWxQcjZoWHAyUFIr?=
 =?utf-8?B?RU5pVndhSHhDUFBTK2doSzl5akI2K0thNVBXYmYxcU1JcDB5WkxteVN2MWc0?=
 =?utf-8?B?a20rY2ZoemY5ejNXRUdnM0pLNFg5SjVzTUJrZWpESkpMQlU2cS9qTEhnbE9s?=
 =?utf-8?B?SzlOaFN3U3FsdTBkVE1CVTY2emFqOFFXWGwvL2sya3VRaHUwWXpPalJlWE1p?=
 =?utf-8?B?QnAzZjZ5V280MHdkNTk4NEp2NmJKQXNDT0F1L0pBZ3VsR3AxeGRacEJsWnh2?=
 =?utf-8?B?VXUrSUlaWVoxaUttWUEyTFBjaE1UTGNGYVVGRVVpZm1QR3JMRDFvOWNRbnAx?=
 =?utf-8?B?cTdxS1VTVk1aRVNoRXQ1elBubnFZMUZORkhJWElrK3JObEdzeWZGbktaaE8y?=
 =?utf-8?B?L3ZWS3JTR3RpWHUwK1MzYkQ1MlJKcGNhOHF6UnpZUVhtcXV1ZGVIS1BhOFNs?=
 =?utf-8?B?RUk1cFhYVG1ydmRuUGxHYi80T0NLdklXMXRWTDl5N2RoZ1JyUWFsSHE4QVJh?=
 =?utf-8?B?T29QNHB0NlIweWlGRUttbkFnRjc2SVo4RG01a24vUWRCVFlPdGQvMUZUU3JE?=
 =?utf-8?B?eFpxYnZ6L25WdUxQeFNNYTA2UU5IblpUK0loNFJBczVwc3Rua2NqT1ZUNjFZ?=
 =?utf-8?B?VS9ONjg2MUQrU3dQNDlOODU0dDk0VHYvOTlUbWpmY3ljR2Q3QVF1ZjJUdlov?=
 =?utf-8?B?RGZCdUx6OFBlL0ZGd3pMVlVtcVJ0OUM5aDFKNnhRWnNXYkpkczM1bHJEOEZC?=
 =?utf-8?Q?4Tdf8tNVq03oI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b32fe342-0ff3-4963-0cbb-08d8f37b0b03
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 12:55:06.5690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bsXOK159maAk7rF+VaKRILy0lH0LXy1borq6aZXOP43zhMlM4vHjfV0QTWsjLGVo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4606
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 30.03.21 um 14:04 schrieb Xi Ruoyao:
> On 2021-03-30 03:40 +0800, Xi Ruoyao wrote:
>> On 2021-03-29 21:36 +0200, Christian König wrote:
>>> Am 29.03.21 um 21:27 schrieb Xi Ruoyao:
>>>> Hi Christian,
>>>>
>>>> I don't think there is any constraint implemented to ensure `num_entries %
>>>> AMDGPU_GPU_PAGES_IN_CPU_PAGE == 0`.  For example, in `amdgpu_vm_bo_map()`:
>>>>
>>>>           /* validate the parameters */
>>>>           if (saddr & AMDGPU_GPU_PAGE_MASK || offset & AMDGPU_GPU_PAGE_MASK
>>>>               size == 0 || size & AMDGPU_GPU_PAGE_MASK)
>>>>                   return -EINVAL;
>>>>
>>>> /* snip */
>>>>
>>>>           saddr /= AMDGPU_GPU_PAGE_SIZE;
>>>>           eaddr /= AMDGPU_GPU_PAGE_SIZE;
>>>>
>>>> /* snip */
>>>>
>>>>           mapping->start = saddr;
>>>>           mapping->last = eaddr;
>>>>
>>>>
>>>> If we really want to ensure (mapping->last - mapping->start + 1) %
>>>> AMDGPU_GPU_PAGES_IN_CPU_PAGE == 0, then we should replace
>>>> "AMDGPU_GPU_PAGE_MASK"
>>>> in "validate the parameters" with "PAGE_MASK".
> It should be "~PAGE_MASK", "PAGE_MASK" has an opposite convention of
> "AMDGPU_GPU_PAGE_MASK" :(.
>
>>> Yeah, good point.
>>>
>>>> I tried it and it broke userspace: Xorg startup fails with EINVAL with
>>>> this
>>>> change.
>>> Well in theory it is possible that we always fill the GPUVM on a 4k
>>> basis while the native page size of the CPU is larger. Let me double
>>> check the code.
> On my platform, there are two issues both causing the VM corruption.  One is
> fixed by agd5f/linux@fe001e7.

What is fe001e7? A commit id? If yes then that is to short and I can't 
find it.

>    Another is in Mesa from userspace:  it uses
> `dev_info->gart_page_size` as the alignment, but the kernel AMDGPU driver
> expects it to use `dev_info->virtual_address_alignment`.

Mhm, looking at the kernel code I would rather say Mesa is correct and 
the kernel driver is broken.

The gart_page_size is limited by the CPU page size, but the 
virtual_address_alignment isn't.

> If we can make the change to fill the GPUVM on a 4k basis, we can fix this issue
> and make virtual_address_alignment = 4K.  Otherwise, we should fortify the
> parameter validation, changing "AMDGPU_GPU_PAGE_MASK" to "~PAGE_MASK".  Then the
> userspace will just get an EINVAL, instead of a slient VM corruption.  And
> someone should tell Mesa developers to fix the code in this case.

I rather see this as a kernel bug. Can you test if this code fragment 
fixes your issue:

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c 
b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 64beb3399604..e1260b517e1b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -780,7 +780,7 @@ int amdgpu_info_ioctl(struct drm_device *dev, void 
*data, struct drm_file *filp)
                 }
                 dev_info->virtual_address_alignment = 
max((int)PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
                 dev_info->pte_fragment_size = (1 << 
adev->vm_manager.fragment_size) * AMDGPU_GPU_PAGE_SIZE;
-               dev_info->gart_page_size = AMDGPU_GPU_PAGE_SIZE;
+               dev_info->gart_page_size = 
dev_info->virtual_address_alignment;
                 dev_info->cu_active_number = adev->gfx.cu_info.number;
                 dev_info->cu_ao_mask = adev->gfx.cu_info.ao_cu_mask;
                 dev_info->ce_ram_size = adev->gfx.ce_ram_size;


Thanks,
Christian.

> --
> Xi Ruoyao <xry111@mengyan1223.wang>
> School of Aerospace Science and Technology, Xidian University
>


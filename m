Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD616E4E50
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 18:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjDQQby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 12:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDQQbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 12:31:53 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25FE102;
        Mon, 17 Apr 2023 09:31:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcBbor26wWEB8UCQsD5GdM06IeS+cCKMllA3dZLunIlUFVLpSxHKIhTuep0u3zylDeb7AwG0UAeWo/E0BmLcrQnMeoiq4SHDxrtXTXfHhf6QVCUWKd3HLzr/lvP3hG8kkd6GQPsOc2+HxQoWdqKFgRqzLDyea7FhwEF4HGTK+URAtXyJrNnc9JFHdQKSQOly07sfkYalT5CXKbBwEN/0/dYxA0kwp8rDeH0ib6iTK1ITrkEBxMcmFY7RbzuRIj3N797Df/skJCgK882dpzLC139U3/YUly8A0n8jmTW4MtjLngLmW2MOv+OQRVQNZed1+Nani2RK55GD1ekb5xaFmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wkoL8k08IvUpLsAbuti6lZzBPcudWQGxU1X+lkr8oQ=;
 b=IydV2nXyt9cYMld2D7a0zTz+PEivOiqm5qqfHOB4IdScNHiGvSI/mufbob8uckkEH9EtWlyN4hBtTVG9+Pmzp4UwfDWV8TlmyZaWVLaJd0wDBXZiGSeV0tyvDxodDwUk4GXOt6KQJR69tbe8j9j6Any4lHJgi4Q+n734mNh98H7kF9/ygTXhYirECy12CIIIg62ApDegtsDp9CYsi5QKlS+aTMW6SmnTgijNigikpV1GCxTMpdw6MFE2HLyjWx1aHdX98u3PgZZAkwWsS2n8fJl+kV/CI4TOnp9dNemSOFWZ1kvRP050Xe1+M+V99s0R2M0dpj+J3DR+vNMc2QH8jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wkoL8k08IvUpLsAbuti6lZzBPcudWQGxU1X+lkr8oQ=;
 b=HSivYLOCvPzoqOrgv5mdTFrGNxSuTQpleVF8a4WNGCea0FfznpOP6tKMeA1BkfGPQPddz5hW2OP+8ozIESP0ZHsGJl9RWIZuNjuHL/MrOBKRN2hcujJxo6H9vuNO3pAPaDqFmKYbnqRtYLJzKmnaB8Iht6sePKp1tdpeWyXYPPw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB6280.namprd12.prod.outlook.com (2603:10b6:8:a2::11) by
 SJ2PR12MB8135.namprd12.prod.outlook.com (2603:10b6:a03:4f3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 16:31:48 +0000
Received: from DM4PR12MB6280.namprd12.prod.outlook.com
 ([fe80::fe53:2742:10f9:b8f1]) by DM4PR12MB6280.namprd12.prod.outlook.com
 ([fe80::fe53:2742:10f9:b8f1%9]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 16:31:48 +0000
Message-ID: <1fb5d840-24d6-b992-9c62-14cb3a52862d@amd.com>
Date:   Mon, 17 Apr 2023 12:33:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] drm/amd/display: fix flickering caused by S/G mode
Content-Language: en-US
To:     "Wu, Hersen" <hersenxs.wu@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Li, Sun peng (Leo)" <Sunpeng.Li@amd.com>,
        "Siqueira, Rodrigo" <Rodrigo.Siqueira@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Pillai, Aurabindo" <Aurabindo.Pillai@amd.com>,
        "Zhuo, Qingqing (Lillian)" <Qingqing.Zhuo@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Wang, Chao-kai (Stylon)" <Stylon.Wang@amd.com>,
        "Tuikov, Luben" <Luben.Tuikov@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230414193331.199598-1-hamza.mahfooz@amd.com>
 <4207e848-4e79-29a7-2bb0-44f74a2d62c7@amd.com>
 <23ebe744-bd4b-c411-99f1-c4ae9dc132f7@amd.com>
 <d9fd286d-7f06-be80-7b81-b2aa2c074f1f@amd.com>
 <b112c88a-c3b2-67a2-b401-8d8962bbe01b@amd.com>
 <PH8PR12MB6962186DEF22F5CE45458675FD9C9@PH8PR12MB6962.namprd12.prod.outlook.com>
From:   Hamza Mahfooz <hamza.mahfooz@amd.com>
In-Reply-To: <PH8PR12MB6962186DEF22F5CE45458675FD9C9@PH8PR12MB6962.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT4PR01CA0394.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::23) To DM4PR12MB6280.namprd12.prod.outlook.com
 (2603:10b6:8:a2::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB6280:EE_|SJ2PR12MB8135:EE_
X-MS-Office365-Filtering-Correlation-Id: 4072c4e1-108a-43e1-585c-08db3f613db7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Szmpp3REcKYNqlbp4m3YpMLkrzMMXitHNX15TBKZYBCvltZw1iHM+n5Fb2RSOzJM/6zWuYmuwtyrtC7SGWVBzG9l51H7thgSQ+QsssD1udFOPW16pAnMY0Z4oYdYBUifx1klXnoFTM2lQOrCOrUf9gUw2Zi0Se9QOt1vP5Lb5AB+SHqCmrBvUbTtjz9GDze0xLdVn8A1Cv33qXi+YsWhJoiMetGaJ4XFEfsd1tCrKjGxj1n/jRJBu+8/o005fcj5ygVjBN6IvHwesItqCvplQJ24KT1TXDOsmAlIofutZIogFZuc4s35nztmGqIeyoqT0lIzgh6Wf6DRQRm3VP/QDNJDce4EDGDNjzsWuOw11lMzE7v4l1omz8e4m36Wqewv3MjsRAS3PcdA0UZ6JJ4/8B/QvbQ158SdzBDSNscLZBIxt0dAHlzh902Kx2DQdw+k6on/LUI55mQ9S6rknxcfDIiTMlU9aXbgAQ/OLXSLsxlELdyrzhO5P83cTprufATNa1ABeNLSKdDolFwknNi8vghulloRSuMBAUCQ1Z+NpP/mmzyR+M5oo7BcknX0svsLGQOlQDpA5McSmeulz+KZbU7+05gzl5wWWSRe2r0DnXxdDX9QL1tOur8ynRRiAhxK5y9nDFxtuKOqR5NmNjMVCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6280.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(451199021)(36756003)(110136005)(54906003)(4326008)(316002)(66556008)(66946007)(66476007)(6486002)(478600001)(6666004)(5660300002)(8936002)(8676002)(41300700001)(2906002)(44832011)(86362001)(31696002)(38100700002)(2616005)(6512007)(6506007)(26005)(186003)(53546011)(83380400001)(66574015)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0U0ckYveStLdXl6VU5FUTdYdi9XcFlnSmQzZ2w5MjVkNEhNazJoa1VrdTZP?=
 =?utf-8?B?T3k2a3dIUHhrd3JXQ2lYMEVwUjRhWitVdUpYTlJMVm9DcFJKR2RFQ3E5TkRE?=
 =?utf-8?B?WkJkdEh2UmErMkNudVYvU0VDOFNCYkVvNzBzS0lqS2JKMU43Y1U3QjNqdkNL?=
 =?utf-8?B?SHRmTEJaQldBc3RObVBlMW1TemZNc1BHTkxJTFNjZForcVo0R29naUFsdllv?=
 =?utf-8?B?VUJ5QSt3b0FWaDVvV2hGbEVRN3NxSDl3S3h4TG9TQklrTVhmZGtsM3o4cE5a?=
 =?utf-8?B?OG9jeXM5Qy9FbEExN0t3SmV4MjFNd2tkNDd0NGJBTUdlWm80M1BnRnFrWDYx?=
 =?utf-8?B?OEtJdUYrRGNWUkJwcGVERHZsREwrbmRhQlIrcGdCNEFDcTVqbFFJd1ZFRlFz?=
 =?utf-8?B?ZzRodzd4WC90c1M0aHBQYzNzSmdsbFJZa1Q2MmN5b1k4dHNpb0RSRnBKWnRP?=
 =?utf-8?B?VHBnT2R5NzlVK2VMUXFoMTBvckswTmFhazgvU2hSb1VubFE5eTdub0l2bjBs?=
 =?utf-8?B?N25BREhqUHVrdTNhbnprTVRLWkFHenV3WVJCR0VsVzJqY0ZRaXg3QXNjS2NR?=
 =?utf-8?B?dVFDQ3V4NEJDbVFuS29oQ2JUTDljemcwd2Yrc2hFRUJkNFRUNkhIcG95VWo1?=
 =?utf-8?B?aGwvNlkvb3loMlJIb3J4ZDEvdjIxNThLSDAzZFBKV1l6eG5ZaURscDRseTA1?=
 =?utf-8?B?UzNYYVVDUlM3ZWZoZk4vQ2YxcW9PYXNLcmI1SGJ5SW9oeGpKbHN5NzBRN3hu?=
 =?utf-8?B?NFlnTUgxb2ptMXU1bTRiTy9IdTFqZFJCQjVhTUVkVU9obVhpam56c3BPMlFy?=
 =?utf-8?B?ZWVYWHlNLzcrc2N2MEwrYXJOTUJUZnkxeDdPYTZ2cnZMdlVacGlJUk1FcjMr?=
 =?utf-8?B?cDhBNlpmQXZwT3c2TytHczJmWnJLRGRhOU51d2N0Qnc5Y0JnZUY5bXkwTjIv?=
 =?utf-8?B?VU0vSGtHZ2lsdGtuVVBteGRkZEtVb1ZHbWgwQUJsNmhRUmNHUEdZby9wRi9K?=
 =?utf-8?B?KzFzTFpjbU4xcjJpVlZWYXpGMUVkNHBqWlduZmdvNEJqeWMyZFliNjVqT3pQ?=
 =?utf-8?B?OGJSMm1TNzJ1TmVxZ0lsRVlhOWY1cU9ZWVZMTzBYejdncVJXbEkwd3RnRmg2?=
 =?utf-8?B?WUVTdHFGaGdLenNIQ21VUktreGFzcUZ3SHJvSWxxMVZYQ3NVVGR5eThnbXFK?=
 =?utf-8?B?ZE43S1pDNjZiWWlWSUxkNGVFQ2tJMDB5YjVNZEd1ZHdwMHdSc0NjbkZVYVRV?=
 =?utf-8?B?bDBwbGJQWk9GQVI1VlBmZ0NQWVg5NkxPblRSdkhrTVlzMmpFTDgrV3RiTjhz?=
 =?utf-8?B?bEM3WHpPSkEvK1VFdDdIVzN5U1gyZkJFR1FGYUU0dlljNVo5TkV3K3h6T1Q3?=
 =?utf-8?B?OTdHVThlQ04vWUN0NEdQRStOV1lVYmNNYStmWnVnQi8rbnNET3JuTFB1Q01y?=
 =?utf-8?B?bXN2UUg0NklHZlRMdFBNbjcyMDRkMnlzSlZZZ0NYS2VLL3k4c0Z2RVBvVkxm?=
 =?utf-8?B?VFl2SGNQUlpCQzROcXY3TzE1dGpvNzFMaVNuODRIN081VE9KYjRRaW1yRTlN?=
 =?utf-8?B?dnpXOGpZVTd2U2c2bldWeHFTYWtmUldhZkpkSDZ0NkRFSU81Z3IrK2ZqLzJM?=
 =?utf-8?B?U1B1djdmeXZQTlFuckFUcmRaMkNBMkZiazFSRWhnQUVBdC8xQURpMGhPaHdx?=
 =?utf-8?B?Vzh1YlZwZGZHNHhyUFV4ZjhDZnJtMnhVTFNwbURKeDIvM1VMVEtFaUpibE1M?=
 =?utf-8?B?M1ZwclRKWTRkSE5Hc1FEbVE5MFZEU0FsUitLVmpFQ3dOVTJ3bDZBWGxUeEEv?=
 =?utf-8?B?NnpzOWtpUWd2MTJZUUx5b01NQkl5TG9USHMyU2tkZGtpaDYwa3VlRWZvSVZG?=
 =?utf-8?B?bXZJTnNSYm9rTUV4dDJCL3BpbWFVVnZqdDU1MDF3WHdhOGNaZitnREh3WXNK?=
 =?utf-8?B?S1VZMEJreHNLNThvYklMQzN4cjl4dzVTSWFlQlhmank4Sys3S2Y4SzJZOUoz?=
 =?utf-8?B?WkU5L2RRUzdHS29CR2F1QVFoM2hScWticVNKaDNLL1FHVkpSSjRONmJOdHlx?=
 =?utf-8?B?eG5ySGlpSm9NeUczMnJnand2YitVbE44V1NTczRkVytucWFPamY2Q2dZbkJO?=
 =?utf-8?Q?1bxLlr+pifhfp2QH48g+Oo/E4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4072c4e1-108a-43e1-585c-08db3f613db7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB6280.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 16:31:48.4681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FF8Z32c2V/uk8hWRB9QlWmqdzHR+K62YvDd6HgQMKWwDbLrp02dAiNKxlg45vboXBrU+YHv2TNrKiofAdmEjIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8135
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/17/23 11:41, Wu, Hersen wrote:
> [AMD Official Use Only - General]
> 
> Hi,
> 
> The change applies to all AMD GPU ASIC.
> Please communicate with issue reporter to see if the issue could be reproduced older ASIC, like Mendocino, CZN.

 From the community reports, it can be reproduced on as far back as the
Ryzen 4800H (which I guess is Renoir).

> 
> Thanks!
> Hersen
> 
> 
> -----Original Message-----
> From: Mahfooz, Hamza <Hamza.Mahfooz@amd.com>
> Sent: Monday, April 17, 2023 11:26 AM
> To: Koenig, Christian <Christian.Koenig@amd.com>; amd-gfx@lists.freedesktop.org
> Cc: stable@vger.kernel.org; Wentland, Harry <Harry.Wentland@amd.com>; Li, Sun peng (Leo) <Sunpeng.Li@amd.com>; Siqueira, Rodrigo <Rodrigo.Siqueira@amd.com>; Deucher, Alexander <Alexander.Deucher@amd.com>; Pan, Xinhui <Xinhui.Pan@amd.com>; David Airlie <airlied@gmail.com>; Daniel Vetter <daniel@ffwll.ch>; Pillai, Aurabindo <Aurabindo.Pillai@amd.com>; Zhuo, Qingqing (Lillian) <Qingqing.Zhuo@amd.com>; Hans de Goede <hdegoede@redhat.com>; Wu, Hersen <hersenxs.wu@amd.com>; Wang, Chao-kai (Stylon) <Stylon.Wang@amd.com>; Tuikov, Luben <Luben.Tuikov@amd.com>; dri-devel@lists.freedesktop.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] drm/amd/display: fix flickering caused by S/G mode
> 
> 
> On 4/17/23 11:03, Christian König wrote:
>> Am 17.04.23 um 16:51 schrieb Hamza Mahfooz:
>>>
>>> On 4/17/23 01:59, Christian König wrote:
>>>> Am 14.04.23 um 21:33 schrieb Hamza Mahfooz:
>>>>> Currently, we allow the framebuffer for a given plane to move
>>>>> between memory domains, however when that happens it causes the
>>>>> screen to flicker, it is even possible for the framebuffer to
>>>>> change memory domains on every plane update (causing a continuous flicker effect).
>>>>> So,
>>>>> to fix this, don't perform an immediate flip in the aforementioned
>>>>> case.
>>>>
>>>> That sounds strongly like you just forget to wait for the move to
>>>> finish!
>>>>
>>>> What is the order of things done here? E.g. who calls
>>>> amdgpu_bo_pin() and who waits for fences for finish signaling? Is
>>>> that maybe just in the wrong order?
>>>
>>> The pinning logic is in dm_plane_helper_prepare_fb(). Also, it seems
>>> like we wait for the fences in amdgpu_dm_atomic_commit_tail(), using
>>> drm_atomic_helper_wait_for_fences(). The ordering should be fine as
>>> well, since prepare_fb() is always called before atomic_commit_tail().
>>
>> Ok, then why is there any flickering?
>>
>> BTW reserving a fence slot is completely unnecessary. That looks like
>> you copy&pasted the code from somewhere else without checking what it
>> actually does.
> 
> It seemed like it was necessary to read `tbo.resource` since the documentation for `struct ttm_buffer_object` makes mention of a "bo::resv::reserved" lock.
> 
>>
>> Regards,
>> Christian.
>>
>>>
>>>>
>>>> Regards,
>>>> Christian.
>>>>
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>> Fixes: 81d0bcf99009 ("drm/amdgpu: make display pinning more
>>>>> flexible
>>>>> (v2)")
>>>>> Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
>>>>> ---
>>>>>    .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 41
>>>>> ++++++++++++++++++-
>>>>>    1 file changed, 39 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>>>>> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>>>>> index da3045fdcb6d..9a4e7408384a 100644
>>>>> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>>>>> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>>>>> @@ -7897,6 +7897,34 @@ static void amdgpu_dm_commit_cursors(struct
>>>>> drm_atomic_state *state)
>>>>>                amdgpu_dm_plane_handle_cursor_update(plane,
>>>>> old_plane_state);
>>>>>    }
>>>>> +static inline uint32_t get_mem_type(struct amdgpu_device *adev,
>>>>> +                    struct drm_gem_object *obj,
>>>>> +                    bool check_domain) {
>>>>> +    struct amdgpu_bo *abo = gem_to_amdgpu_bo(obj);
>>>>> +    uint32_t mem_type;
>>>>> +
>>>>> +    if (unlikely(amdgpu_bo_reserve(abo, true)))
>>>>> +        return 0;
>>>>> +
>>>>> +    if (unlikely(dma_resv_reserve_fences(abo->tbo.base.resv, 1)))
>>>>> +        goto err;
>>>>> +
>>>>> +    if (check_domain &&
>>>>> +        amdgpu_display_supported_domains(adev, abo->flags) !=
>>>>> +        (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT))
>>>>> +        goto err;
>>>>> +
>>>>> +    mem_type = abo->tbo.resource->mem_type;
>>>>> +    amdgpu_bo_unreserve(abo);
>>>>> +
>>>>> +    return mem_type;
>>>>> +
>>>>> +err:
>>>>> +    amdgpu_bo_unreserve(abo);
>>>>> +    return 0;
>>>>> +}
>>>>> +
>>>>>    static void amdgpu_dm_commit_planes(struct drm_atomic_state
>>>>> *state,
>>>>>                        struct dc_state *dc_state,
>>>>>                        struct drm_device *dev, @@ -7916,6 +7944,7 @@
>>>>> static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
>>>>> to_dm_crtc_state(drm_atomic_get_old_crtc_state(state, pcrtc));
>>>>>        int planes_count = 0, vpos, hpos;
>>>>>        unsigned long flags;
>>>>> +    uint32_t mem_type;
>>>>>        u32 target_vblank, last_flip_vblank;
>>>>>        bool vrr_active = amdgpu_dm_crtc_vrr_active(acrtc_state);
>>>>>        bool cursor_update = false;
>>>>> @@ -8035,13 +8064,21 @@ static void amdgpu_dm_commit_planes(struct
>>>>> drm_atomic_state *state,
>>>>>                }
>>>>>            }
>>>>> +        mem_type = get_mem_type(dm->adev,
>>>>> +old_plane_state->fb->obj[0],
>>>>> +                    true);
>>>>> +
>>>>>            /*
>>>>>             * Only allow immediate flips for fast updates that don't
>>>>> -         * change FB pitch, DCC state, rotation or mirroing.
>>>>> +         * change memory domain, FB pitch, DCC state, rotation or
>>>>> +         * mirroring.
>>>>>             */
>>>>>            bundle->flip_addrs[planes_count].flip_immediate =
>>>>>                crtc->state->async_flip &&
>>>>> -            acrtc_state->update_type == UPDATE_TYPE_FAST;
>>>>> +            acrtc_state->update_type == UPDATE_TYPE_FAST &&
>>>>> +            (!mem_type || (mem_type && get_mem_type(dm->adev,
>>>>> +                                fb->obj[0],
>>>>> +                                false) ==
>>>>> +                       mem_type));
>>>>>            timestamp_ns = ktime_get_ns();
>>>>> bundle->flip_addrs[planes_count].flip_timestamp_in_us =
>>>>> div_u64(timestamp_ns, 1000);
>>>>
>>
> --
> Hamza
-- 
Hamza


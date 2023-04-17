Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41356E4D82
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 17:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjDQPqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 11:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjDQPqK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 11:46:10 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51F210D;
        Mon, 17 Apr 2023 08:46:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7Sb+6LV53P0MYwjVRkLal6nefLEEXINaoTpAVaRaT1BkcipT9tbaUc+wx0ntaDXNgDWq3KpwDsLr2YWYESuAW5ke2eshTk7KGxQarrRf/yDAeouK1O8m4gTU4lGJFuBad+tfjOhcG0xX2AMp2YBhxqKzdPZvAbOA6s1OAMEQyD8FpUeHPdYsSR7LXKEoqlWASVqkpzAUnPw5DVqUPWUXq09+BfeNAgdQ0ZnsRIBZOFtgfl1RovyF+25ZQqzOvNZ+jQBtLcpo8wqWc61HqjGvzSEROAd10SANKPsH9UEQcYDmzj+7qDTyzde7g9bp9YUak52XNSsJr7LGiLnrEIIjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UEMrHtzQQjuyXQK26vcOQPAuRkNoQgNTTbncvj6Bdhg=;
 b=YTKmAolxVWHzTttHYpKyd9YcuTdv6+lXTuLrpDTwsXztvl3HUJW7taiUXx37xWxjCtbUZHK+6h4Or5gmhvrR9W8yq4vgPVVLsZH3AB2XaCfZe7gc7E+BUVr6h4hYdAnOz1S2288XA6uCxBe9iNifNS5KBVy8xseSQVx3vhbpz2sV8o4+77w8yDv8sc48MW67K4dODiADL2c2dhKTTftZA5BuQaCmXqam9GQFwFX1TtmDUX6HHXR6JNZiES2oiW9AjURttyopxsQwsgWRM7Dgw7gdn/pxz8j/T7gWyeSX6lXV9Z9Wy5GuugOpVq1yneokYsaUuIgjNOxk1Y8ghbRvQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UEMrHtzQQjuyXQK26vcOQPAuRkNoQgNTTbncvj6Bdhg=;
 b=qhcXidBzVdK4jToqOBkDRkER7Owhjk+GnIrs5uqAvTsDgVwluYoRFIWSqfTr6delLZMNdPMtPgbnxB65xMSkhmsCigokX75nX8uZ3rKzkLKQDubJXLMFXLM6z3yUczRqKZsaJxIDHWooiO7sv6ji5QRhD3wkVz7HashXpRi61sc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by BL1PR12MB5756.namprd12.prod.outlook.com (2603:10b6:208:393::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 15:46:06 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::d2f8:7388:39c1:bbed]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::d2f8:7388:39c1:bbed%3]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 15:46:05 +0000
Message-ID: <a13a38a4-6327-7af0-56b7-930f4258eee5@amd.com>
Date:   Mon, 17 Apr 2023 17:46:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] drm/amd/display: fix flickering caused by S/G mode
Content-Language: en-US
To:     Hamza Mahfooz <hamza.mahfooz@amd.com>,
        amd-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20230414193331.199598-1-hamza.mahfooz@amd.com>
 <4207e848-4e79-29a7-2bb0-44f74a2d62c7@amd.com>
 <23ebe744-bd4b-c411-99f1-c4ae9dc132f7@amd.com>
 <d9fd286d-7f06-be80-7b81-b2aa2c074f1f@amd.com>
 <b112c88a-c3b2-67a2-b401-8d8962bbe01b@amd.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <b112c88a-c3b2-67a2-b401-8d8962bbe01b@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0074.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::12) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3587:EE_|BL1PR12MB5756:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b9f6cd4-35b7-49aa-71e0-08db3f5adab0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BSwF7MFWesgLgTUzIyuPpnfs2tIIenRlvnSZHs6lCO3JwFE94P55EASQbIQ+zaGA5qT+stOl1emd6yxzjgMnw1moyHms6wfqSoqLodV+jZeLp4AmotuEBoJvVKbIxZ0Eh+Pn1heTvwwU29d7nSLi8qpih54Wvcj0wGC3axcxzznOSWCYu1SqBA7M3KA2MtPpM3c8e8VNLrsky6YbhqpJrhUst++bDmtC0GGEGNpigyKWk+VsyZGi4QBIKq21YcuBQTYiezDYCSKYiz5ygvEB6cKUT0XMZ9FO4RNxtnyPuT3vCZajde3/CcS6a/MOTHNn5oBSakgPTnvMUsJZP5OVe7Ns+FeeWrm00u7Oq4bD+PMCNmtBq+md+MZDMn5y20xtGYIiYRA6xCPn4O+UdPc0mone6yBcN4hZ6MnpEbx/40o0tBtbMVfHCNBIq6hU8Vxn+GGv9mRdPVWbeY5IbrDrCIjJ4BghA9Gb1ixj9RzppIK64urNx0UW0vwv9K6s1KXiqJ24e0xBSqdIS9l+VkJGVfGzo58gn7XtUogUBJH/L5qn43U3fxhu201bAyO/C/THj/4U6bAKuPxEsDEv/FgU5tuIoYlRSCx78+H7sEjmZOXodXkFFmrxPF9d5jPsoCCxB/7wWSvP7/pR8l/46aokPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(451199021)(86362001)(31696002)(83380400001)(53546011)(36756003)(6506007)(6512007)(66574015)(186003)(2906002)(31686004)(2616005)(6486002)(5660300002)(38100700002)(6666004)(8936002)(8676002)(478600001)(54906003)(41300700001)(316002)(66946007)(66556008)(66476007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NThSUklpWGd6d1pqUWV5NlVlMzkwdDdPbjMzWUJjbkpzT1FRd21JTGhVVDVh?=
 =?utf-8?B?dk91VWRMZmZEbThwdyt2blFzYWQ0Q3JJSEF4ZFFXenp5UUFGSGpTN0c0emNV?=
 =?utf-8?B?M0wyTHZpcnF6RDRrQmJ2aENzS1dMc0RJQXB6a25JbEptN1Y2RGFNWEFXL0Vi?=
 =?utf-8?B?VnhzTUdybk5WR0IzTjh2Y1FGTXcxSU5VeVJySW9ha0s2bHduZnJCTVE1YlVS?=
 =?utf-8?B?MGZTNXh2MGIrZUZCZGtERDJ1aG9qV29UUjd6Z2lmNDJDK2Z6WEhWYm9JOU1S?=
 =?utf-8?B?VWZwUk45ODhCMWNuSXQ3d21ESk9leTAydWEvcHlNUTlPdXVoTmxpWVlLam5X?=
 =?utf-8?B?Q0pxbDlKNHJMQm52RVg0L3dEU09HdUFMMlFGd2VCeEFmWmlMUWlaeFFiZVpa?=
 =?utf-8?B?NEh2Z1g5dWFNVUY1L1lFM0Nib29Ea0RrdU1ZUGZYdFNqYlpKUlZsYTNQS0NK?=
 =?utf-8?B?ejBjSFp0bzRjZXlCdXkvOW9mV0FrTUk0Zm0vbDlHWm45L3p4TWJ5aDNyTkxn?=
 =?utf-8?B?clJvaUx4eVE3am1IaHpmeHZGRExCODNieEtOR2ZadDJXMThZNXVrV2ZaTnV5?=
 =?utf-8?B?RGxMcDhQMnA3TFZncGVRb1NqbWowdXRLL2h0L3M2dVNyQmRUbEFhS1JDK0VI?=
 =?utf-8?B?U0hCVnRlZmE3OW5mN25WeUZHUjRiNWtwNFVENXI4MXFabHRyMnJES0ZrRzl4?=
 =?utf-8?B?eFByWGsyVTZzV0ZzVzcyL01SY0thM0p4UUlCVHhOWmptdFcybm9SNEFEYSt1?=
 =?utf-8?B?R0lJMnhhRExGQXRlekQ4MXhrLzJDOXRZRzVnYlVlK1FPcUNCOHI3SDcrdXFN?=
 =?utf-8?B?dWhsSTd1Rm1zNWdZWE1ZUlNicHJIVmc0VWttTU14bTFRRVUxRy9STER1RGNK?=
 =?utf-8?B?WE9LM1ZaeDRrZ3NqTXRiaTI2K1cvWHFWUVZ4SlErcmRpZ1hVS3RkOFRMRy9V?=
 =?utf-8?B?ZzBFdW9NVVVQdTM2MlZzNjJ4ckRuWHlUSmcyc05STFRlUHVnZVdSZERaOWJG?=
 =?utf-8?B?NkFEYWpFWkRadngwbU5BSDFNWjd6M1Q5aVlVQkxtczdLcnJZNnAxN3k2RnFh?=
 =?utf-8?B?bDNDWmwrVVNSOHByeExhWS9mOVZTT2h1eG1VWWVVVmVwNjlwTExhZEdNN3Fn?=
 =?utf-8?B?QkRCZFZDV0dJWGpNUjdRU2R3bytlWDBqZzFKZ0FuVzY2dE45cG1iMG1xMWhF?=
 =?utf-8?B?TjhvUzQ0VmJtNmZBMkFpNlFMK3FFVTVrbVBSQUdNU2plU1p6Z3Nkb2gvYVc4?=
 =?utf-8?B?MDZFem1XL0UxVEl3ZXRscmtPQTdoUE40ZGxKMGdKYkdMYzFTeVJaVFF2a093?=
 =?utf-8?B?R1FiSWhVZlVtWDhReFVudm9aeERtSUlVWjhqVStyK2lLVHVNbHNtSUhaQ1I5?=
 =?utf-8?B?UGFjc1BTVkFOVW5FRW41YVZYQUhpNE8wVW5EeU9YQTdaK2IrMkNZYWp2cUpt?=
 =?utf-8?B?RFBRM091NjNWaVhhVUJSY0dTTS9PcEVUcklSSmVCSmVocTJVc3h5emYxZnFB?=
 =?utf-8?B?NS9uYjJrVkVvQnIyMFFzU2MrcnU0ZDk4d3J2WGFtbzBWcGJ0TDlVMEpWL0lo?=
 =?utf-8?B?OHU0dWd0d2syWFlhK3h3bUpZZ2wvWXcvTFFWNlBtUEx5Mmx2RHFqdGQrbFFH?=
 =?utf-8?B?Wnl1d2JtWDh3cTlicWpIMG5mRkE0QlFKN3M4ZGV4YzRsczZBaTNZd3NrY2g5?=
 =?utf-8?B?T0NZNzZEbkdnMUp2eldvYUNKbWlrRWFrMkVpWHRQT2FCL3JFcE4xMXNxb2ZC?=
 =?utf-8?B?bGZRWE1keGp4UFVuYkFNRGNtdlhmSGFxZEx4cUtkKy9nbWdaUm5ZSitvUDNW?=
 =?utf-8?B?NlAwTVM0YURucVY0WXJVYmRvM1QyMTQ4WkhRdkY1WWs4UG1KenM0RjVjbWs3?=
 =?utf-8?B?VVpKUUEzUE9MSlRsQ2pJU1dTT1NPb3phVnVIcmtNQmRsdXNhRm5VNEQzOG50?=
 =?utf-8?B?dkNOL1JpZjMyS3VDNE9tTlVPbzYvSEpoQ3dDWSttVmd5Q3RycUZOSDdmZ01T?=
 =?utf-8?B?R1VFMGQ5TVp2STBTcHZ5M3o3QmxLTm1Ka1ZSbmovZnVLV3hIRm1ZWk9YOEVi?=
 =?utf-8?B?bVhlc010OXlMaGg4Yyt1YjhwUmdFSUdsSXVSbmJ5QWVyQzlDSmVrNUhwRkRk?=
 =?utf-8?B?dWtjTUQydW5NZjlEUXJ5MU5pUmFWdkxTeTUwcWliTFVyd0xEMDM5OFRYYzE3?=
 =?utf-8?Q?Sn5MdGGd1IyM6HndbFFAztnruSFzhyjSdQEWxTmxV8lB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b9f6cd4-35b7-49aa-71e0-08db3f5adab0
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 15:46:05.4717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5EaTNcAGbEcgbJh7EJB9sKut6X49ZksHoJ3KWM8/jvaEHof0Zp6Fd2Qeeaa1Pu8f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5756
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 17.04.23 um 17:25 schrieb Hamza Mahfooz:
>
> On 4/17/23 11:03, Christian König wrote:
>> Am 17.04.23 um 16:51 schrieb Hamza Mahfooz:
>>>
>>> On 4/17/23 01:59, Christian König wrote:
>>>> Am 14.04.23 um 21:33 schrieb Hamza Mahfooz:
>>>>> Currently, we allow the framebuffer for a given plane to move between
>>>>> memory domains, however when that happens it causes the screen to
>>>>> flicker, it is even possible for the framebuffer to change memory
>>>>> domains on every plane update (causing a continuous flicker 
>>>>> effect). So,
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
> It seemed like it was necessary to read `tbo.resource` since the
> documentation for `struct ttm_buffer_object` makes mention of a
> "bo::resv::reserved" lock.

What? No, that sounds like you completely misunderstood that. I think we 
need to improve the documentation.

As long as the object is pinned for scanout you don't even need to 
reserve it.

Just use something like "abo->tbo.resource ? abo->tbo.resource->mem_type 
: 0" here.

Regards,
Christian.

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
>>>>> flexible (v2)")
>>>>> Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
>>>>> ---
>>>>>   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 41 
>>>>> ++++++++++++++++++-
>>>>>   1 file changed, 39 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c 
>>>>> b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>>>>> index da3045fdcb6d..9a4e7408384a 100644
>>>>> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>>>>> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
>>>>> @@ -7897,6 +7897,34 @@ static void amdgpu_dm_commit_cursors(struct 
>>>>> drm_atomic_state *state)
>>>>>               amdgpu_dm_plane_handle_cursor_update(plane, 
>>>>> old_plane_state);
>>>>>   }
>>>>> +static inline uint32_t get_mem_type(struct amdgpu_device *adev,
>>>>> +                    struct drm_gem_object *obj,
>>>>> +                    bool check_domain)
>>>>> +{
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
>>>>>   static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
>>>>>                       struct dc_state *dc_state,
>>>>>                       struct drm_device *dev,
>>>>> @@ -7916,6 +7944,7 @@ static void amdgpu_dm_commit_planes(struct 
>>>>> drm_atomic_state *state,
>>>>> to_dm_crtc_state(drm_atomic_get_old_crtc_state(state, pcrtc));
>>>>>       int planes_count = 0, vpos, hpos;
>>>>>       unsigned long flags;
>>>>> +    uint32_t mem_type;
>>>>>       u32 target_vblank, last_flip_vblank;
>>>>>       bool vrr_active = amdgpu_dm_crtc_vrr_active(acrtc_state);
>>>>>       bool cursor_update = false;
>>>>> @@ -8035,13 +8064,21 @@ static void amdgpu_dm_commit_planes(struct 
>>>>> drm_atomic_state *state,
>>>>>               }
>>>>>           }
>>>>> +        mem_type = get_mem_type(dm->adev, 
>>>>> old_plane_state->fb->obj[0],
>>>>> +                    true);
>>>>> +
>>>>>           /*
>>>>>            * Only allow immediate flips for fast updates that don't
>>>>> -         * change FB pitch, DCC state, rotation or mirroing.
>>>>> +         * change memory domain, FB pitch, DCC state, rotation or
>>>>> +         * mirroring.
>>>>>            */
>>>>> bundle->flip_addrs[planes_count].flip_immediate =
>>>>>               crtc->state->async_flip &&
>>>>> -            acrtc_state->update_type == UPDATE_TYPE_FAST;
>>>>> +            acrtc_state->update_type == UPDATE_TYPE_FAST &&
>>>>> +            (!mem_type || (mem_type && get_mem_type(dm->adev,
>>>>> +                                fb->obj[0],
>>>>> +                                false) ==
>>>>> +                       mem_type));
>>>>>           timestamp_ns = ktime_get_ns();
>>>>> bundle->flip_addrs[planes_count].flip_timestamp_in_us = 
>>>>> div_u64(timestamp_ns, 1000);
>>>>
>>


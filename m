Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807B546B9AD
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 12:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbhLGLEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 06:04:14 -0500
Received: from mail-bn8nam08on2072.outbound.protection.outlook.com ([40.107.100.72]:45313
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235147AbhLGLEN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 06:04:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0I5FY56FErJfCT9cwEqCgfPDaOZgFJl7kohyJhOVFQVenDDeWYsk1zb2SiUhyeA9QJDDDg4CfqSPnehTdtehEhnkc3n8GR2hMfCwSFfa2gTUHJRmdXvCvovHebufWmi6Wv30BMIj1tnb4KqcyiVPPJzRgR3iMLgvWDhabZbtbqU5zsCltf/F7vPwEQjeaWuFJjUK6wff7iG7C2e+58OBna+0nC3APnv3fwSLWzvAUIf7tIhDS9aHhED78VFXLiTU8Q6X+n2OPgymNA4o+ZdnUC+SWT1UNM+esci2hRel6e67cjLIemBAg/zMkwo8gfGVy9yhD2UKORP/ObrOnzVyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qMwGIo+QRhZsHvEfxltFNDnzYrp7bdCqgItAxKefpAA=;
 b=DLrOiXjEQkgmLqn8lwybbqRudjPF5+n79Mi56TKHpWuTeOZvKjP3ra0aguCUzzUpW3N9d3ftmx7746oIRE+fOc9UCAkZ90xPqzOnGqwlWJnRJ8YurCbo3oA8uye0U3F1g0CjdPMYP/ZzeuuUFALp7QyyVeKma/J0wgJIMoexgZQU5QCO7ySJZcbrr6oj99yv4a6QY3SMU605ZZWNMSOGsZEssm6HnD2FXSFJToPIBgCTkIuQNR9HIILZd2nV/w3+OSdELZ/yqUd+tG0LDkwTIQxdjsPeI/vhJEJ6abCsZx8KLnAPGgEbL35nRkHTDrh7luo2yeSYoIIHc4UFMreEOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qMwGIo+QRhZsHvEfxltFNDnzYrp7bdCqgItAxKefpAA=;
 b=OHQcnSMyCUWAwm5Kjn9e7HT1XzBABwZ94aTp2N4Q3RewCWh2jt8BoCYhaV/l2ipF+K4T4r0ckX5U79ZBOi8lwNZQ/Z8gf0ashvs++gJy3sSdXpmcfr7T3n1geHY3Mfif6TvgfqC5RIeBBD+a2Hz3qdsUmuWK+Y1vEGBjutklk1c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14) by MWHPR1201MB0238.namprd12.prod.outlook.com
 (2603:10b6:301:57::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 11:00:38 +0000
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::d16c:a6d5:5d2e:f9d4]) by MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::d16c:a6d5:5d2e:f9d4%12]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 11:00:37 +0000
Subject: Re: [PATCH] drm/syncobj: Deal with signalled fences in transfer.
To:     Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Cc:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        stable@vger.kernel.org
References: <20211207013235.5985-1-bas@basnieuwenhuizen.nl>
 <05f1e475-3483-b780-d66a-a80577edee39@intel.com>
 <7d2f372f-36f5-1ecc-7ddb-25cf7d444e5d@amd.com>
 <CAP+8YyEzsedvYObj=FVUFTtYo4sdHH354=gBfCAu16qtL1jqLg@mail.gmail.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <9540e080-6b07-c82c-d4d2-d2711a50066d@amd.com>
Date:   Tue, 7 Dec 2021 12:00:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <CAP+8YyEzsedvYObj=FVUFTtYo4sdHH354=gBfCAu16qtL1jqLg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM6P193CA0140.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::45) To MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14)
MIME-Version: 1.0
Received: from [192.168.178.21] (87.176.191.248) by AM6P193CA0140.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Tue, 7 Dec 2021 11:00:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04641400-dce9-4cbd-a26e-08d9b970ccff
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0238:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0238AA92D46ECBE80DE71AA8836E9@MWHPR1201MB0238.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eB4Gk93WbFEn2FWrVCA2gM5PSBYJeVHW+cN36goSQOn0MjCK2zaMUcuz3q7s4cdW+SH1ghTt092PWf7bW0azAWQ2G+JNhoWdeg1uS/xtaHblDf8Pokojab5mIISh5ipIRvhgx8Sg/ev7aNfZLKT8Iu9TUWr4nHSJGmlE0xCB8Ne7L6euyouJIYHUO6knf0s9Lr0bsxASQ41gi5VXlFSqzQA8C/8XBVn9lUpZwF1Z96R+e5FZ994aj5jQGh6vdEAncAgvwdQn7pwNEStb31b7NCcFt7ed51ArvfUSxty8yKNi8mhsDsKXm+zak44CLzb/xsmBJBJyjU/6aI9Lbs7CHFqbfeGiUKgcgWNs4RugwL6cqhGpRKc5Q5nKIfvFfuoVf6Ct/2t7LAqx1strCJfOyQOW5OJNCm3cYNyOeX1N0LIUw7TkO3nTy/AkN8Gx8Yhvnn55JLpZBTMtVHB8MccPEtOhdgA7kZ+BWopbAMFfp4yoO/6dRjfu0K0qP2p4JL/Lve1MvtppLJonQqP70wYAupQ2kBOOtSXEwKqJ/Jp8Sj+4F0JT1USngCRAgz1MWjm3ZOh98zZpTV16BaTpRYnHMBHcmVlEYNorYWVRjNuEHm2kRVpqZN9dtLW7SNxGaWeZYZKT0YfYqd89jvhcdq20P94kNaQmW67SPwO6BDYvA9w5egqN77GHlU9DiO+y17ytmaxG6Odk8cH+vIFFIw4OtSEiukpxFpkGkRhDjTbWcOC4N4nDjQMc9aonyWnxWN/Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1201MB0192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(66946007)(66476007)(66556008)(966005)(83380400001)(8676002)(186003)(956004)(5660300002)(45080400002)(6666004)(86362001)(6916009)(26005)(8936002)(38100700002)(4326008)(2616005)(36756003)(316002)(31696002)(6486002)(16576012)(53546011)(31686004)(54906003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sk1la3poWkNzYks0eHY1L2E4NHJxUGdQNit0TEFyYVB0WkUrbWoyc3hlNkd4?=
 =?utf-8?B?bkJLTXlVUXNOZ3crU2VlVldvN1YrS0J4bnMvWllJeUo3SGw3UVNEbGkyb212?=
 =?utf-8?B?MEVnZHhnWnhmN2tBSVN5UXBwZjIzOWNNRU9ySmtGQWdDYjBlUWhmUi91QnhO?=
 =?utf-8?B?NWp1ZVR5WlMyZGdkMG9abXRjOHNWNUlPWTU1enBxalNPUHpXcFNqcmJwazNG?=
 =?utf-8?B?UlNFdGc2aS9yS0ZueEpKREYwUmhQdzJYc3FVaERCV2RkUGZwRDlGOHdXb1Vy?=
 =?utf-8?B?UXRuV0VWM0EzVTVRc1dJOFA4aEpWWXlhYkliVk1GSVFXVDc2SXJ3SXArazZr?=
 =?utf-8?B?a3RZY3JBMlJPTGFEcWdCdStjZjJiQldYYmJyRVlWMDNtcDBrZGVMVlFuY0Rh?=
 =?utf-8?B?OEkvNm9Cdk0rN20xU1hFSGNaczgxa0pzL0Uza3Q5NGtKNGRVeFRodGZJY29G?=
 =?utf-8?B?N2d0TFc3ZklydmFsenJNVld3cG9MVUNxUDhKSjB4NExuQnQzeVpSaS91Ny83?=
 =?utf-8?B?dWk3b0M5NVcxZ2x0NHN5YVVMalo3SDFlOVE0UVJwNVBXZlp2UkxuK1M3akZo?=
 =?utf-8?B?NkVnbjZ6bEszaUlkTzc0UnkrdzEyeHh2ZWpHMUE1dFBDVUZYN0QxcW84VXZS?=
 =?utf-8?B?R0w4YVQ0N3M1OGhQd1F6MExtZWNSdXBsbVZwWkhXQkNzbzN5N0RwVHcwL1B4?=
 =?utf-8?B?YllXbEIrZUVGZDNGRlNoL3l0dTM1UGtRZEJsN2hTVmVPT1Vhb0FxemxDTlRH?=
 =?utf-8?B?K0lzL3IvWk9HZkg1ODZNTjNYa2p5UGg5QmRuSVIvSU80QnlxdDl6ZmxVMVI2?=
 =?utf-8?B?RkJEVHhrM085UktJMDIzTkgydGxCV1N6bXZDQk5JRy9takhQQ1BGblNnam1w?=
 =?utf-8?B?azVHSmlIekZvU1d1eWVUOGV6d3hOdVQ0U015SGY4L3pXbDhhRmYyRjI5SEdK?=
 =?utf-8?B?QzB1blRUeWxlZVdkT283UGZETzF2YmxDVlJpOWFFUUdvWHk3UkE3U2xLWVZB?=
 =?utf-8?B?V3hhZWtJM2dZRjlhaXVjNmdJWjBJcm5SV2VPQ2kwRjg3N29Ua0VIQktuNXR4?=
 =?utf-8?B?MXhMWmtpVHpkVXZzSnJVQUdnbXBaV3pZejZka3R4MzUyYnZPYU1lcTFycmlk?=
 =?utf-8?B?dWtmQk5lbFhqd2pPNzd4MzltYzJ2QzRNMzV0OHkrbGw2Q3BRWmhCcnZ5aGwr?=
 =?utf-8?B?U3RPVXpKampZUGNWQkFoWFJFSHEzZTBZMzhhdklFK1dJUzV6TjViWFJVVmYw?=
 =?utf-8?B?bjMzTytJYzR3alpoSlMzZWVvdWVGZXBSZ0Nlak4xOTl1dk9nT2JRK0N2WGJD?=
 =?utf-8?B?T0tIaWJzcitISldjdTllTklGbDlLY3VKWjU5dmd4OUlUckxmdjBtRHdiNnRC?=
 =?utf-8?B?SkFCbGtRbHBOcnduWjZCRldiWlE4QjNtdVZUUEpqWUdKQ0NEeTZlcy95c0xz?=
 =?utf-8?B?TFdEcUZQUDFFdkhxKzdIYjM0SVBuU2ZNeUdicVdyRmNaYmVObGNBVGllb0Q2?=
 =?utf-8?B?QmordlcrSkhEYjNwNThhYzNWK3Naa2hFdnRibnM0QjE4TFllcVh3NElCUHE5?=
 =?utf-8?B?Z1VMVURrbjl4NUEybnZkVXJnSndhbElORjA5aVd1aFNNcm1sYVRxeWJFbTJ6?=
 =?utf-8?B?SnZzdVhETlBGc2JLOWV3T3IxdDNkU1dDVTc2UXloZ2FTc0NMR3BnbzB4aS9L?=
 =?utf-8?B?Rm5iTkxvUWJDNW1IVjRQL2xKbUhBZTZzb0JGS0Z2N1crMmMvMmRUVDlZLzRp?=
 =?utf-8?B?eXdTbDlKY2NIMDc4K3V1Vi9SaUVqOTVSZVJQdzlURmFPRjBMNlcxSUY0Nk93?=
 =?utf-8?B?MENwcS9QcnZ6d0laeFh0VXJZcExzVi81Q0hHZUMvczZvc0RZMkhHNHZuTHlo?=
 =?utf-8?B?YnJNWDlDWURnaUhNcHR3VkE5bkN0STJMN0NqVWoxVHRDUjFZaFNFVHFxQ1Y3?=
 =?utf-8?B?YVEwTDN3YzIzSk11NkNTNWRPUmNXQU1JRVlqK1lIUzV2TDFQMkRPVlBIRUFi?=
 =?utf-8?B?RWd2NTNMQlY1VnliekdjV1BSRENETThuZElYeThsdkttT08wdTlqKzhQUmtx?=
 =?utf-8?B?c1YxdERYZnVXRExHcEJManJMN05vTTh6OGUvYWl1YWk3OG5CdWFTRy9IWGtU?=
 =?utf-8?Q?tkpE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04641400-dce9-4cbd-a26e-08d9b970ccff
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1201MB0192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 11:00:37.7886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UcausHx0cKN+Y2/79jsRBgkTz19NjxV1UoNpIx9Oqob/iG5XMSj6eb/hUtscei2K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0238
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 07.12.21 um 11:40 schrieb Bas Nieuwenhuizen:
> On Tue, Dec 7, 2021 at 8:21 AM Christian König <christian.koenig@amd.com> wrote:
>> Am 07.12.21 um 08:10 schrieb Lionel Landwerlin:
>>> On 07/12/2021 03:32, Bas Nieuwenhuizen wrote:
>>>> See the comments in the code. Basically if the seqno is already
>>>> signalled then we get a NULL fence. If we then put the NULL fence
>>>> in a binary syncobj it counts as unsignalled, making that syncobj
>>>> pretty much useless for all expected uses.
>>>>
>>>> Not 100% sure about the transfer to a timeline syncobj but I
>>>> believe it is needed there too, as AFAICT the add_point function
>>>> assumes the fence isn't NULL.
>>>>
>>>> Fixes: ea569910cbab ("drm/syncobj: add transition iotcls between
>>>> binary and timeline v2")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
>>>> ---
>>>>    drivers/gpu/drm/drm_syncobj.c | 26 ++++++++++++++++++++++++++
>>>>    1 file changed, 26 insertions(+)
>>>>
>>>> diff --git a/drivers/gpu/drm/drm_syncobj.c
>>>> b/drivers/gpu/drm/drm_syncobj.c
>>>> index fdd2ec87cdd1..eb28a40400d2 100644
>>>> --- a/drivers/gpu/drm/drm_syncobj.c
>>>> +++ b/drivers/gpu/drm/drm_syncobj.c
>>>> @@ -861,6 +861,19 @@ static int
>>>> drm_syncobj_transfer_to_timeline(struct drm_file *file_private,
>>>>                         &fence);
>>>>        if (ret)
>>>>            goto err;
>>>> +
>>>> +    /* If the requested seqno is already signaled
>>>> drm_syncobj_find_fence may
>>>> +     * return a NULL fence. To make sure the recipient gets
>>>> signalled, use
>>>> +     * a new fence instead.
>>>> +     */
>>>> +    if (!fence) {
>>>> +        fence = dma_fence_allocate_private_stub();
>>>> +        if (!fence) {
>>>> +            ret = -ENOMEM;
>>>> +            goto err;
>>>> +        }
>>>> +    }
>>>> +
>>>
>>> Shouldn't we fix drm_syncobj_find_fence() instead?
>> Mhm, now that you mention it. Bas, why do you think that
>> dma_fence_chain_find_seqno() may return NULL when the fence is already
>> signaled?
>>
>> Double checking the code that should never ever happen.
> Well, I tested the patch with
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.freedesktop.org%2Fmesa%2Fmesa%2F-%2Fmerge_requests%2F14097%2Fdiffs%3Fcommit_id%3Dd4c5c840f4e3839f9f5c1747a9034eb2b565f5c0&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7Cc1ab29fc100842826f5d08d9b96e102a%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637744705383763833%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=sXkTJWm%2FWm2xwgLGdepVWAOlqj%2FeArnvmMvnJpQ9YEs%3D&amp;reserved=0
> so I'm pretty sure it happens, and this patch fixes  it, though I may
> have misidentified what the code should do.
>
> My reading is that the dma_fence_chain_for_each in
> dma_fence_chain_find_seqno will never visit a signalled fence (unless
> the top one is signalled), as dma_fence_chain_walk will never return a
> signalled fence (it only returns on NULL or !signalled).

Ah, yes that suddenly makes more sense.

> Happy to move this to drm_syncobj_find_fence.

No, I think that your current patch is fine.

That drm_syncobj_find_fence() only returns NULL when it can't find 
anything !signaled is correct behavior I think.

Going to push your original patch if nobody has any more objections.

But somebody might want to take care of the IGT as well.

Regards,
Christian.

>> Regards,
>> Christian.
>>
>>> By returning a stub fence for the timeline case if there isn't one.
>>>
>>>
>>> Because the same NULL fence check appears missing in amdgpu (and
>>> probably other drivers).
>>>
>>>
>>> Also we should have tests for this in IGT.
>>>
>>> AMD contributed some tests when this code was written but they never
>>> got reviewed :(
>>>
>>>
>>> -Lionel
>>>
>>>
>>>>        chain = kzalloc(sizeof(struct dma_fence_chain), GFP_KERNEL);
>>>>        if (!chain) {
>>>>            ret = -ENOMEM;
>>>> @@ -890,6 +903,19 @@ drm_syncobj_transfer_to_binary(struct drm_file
>>>> *file_private,
>>>>                         args->src_point, args->flags, &fence);
>>>>        if (ret)
>>>>            goto err;
>>>> +
>>>> +    /* If the requested seqno is already signaled
>>>> drm_syncobj_find_fence may
>>>> +     * return a NULL fence. To make sure the recipient gets
>>>> signalled, use
>>>> +     * a new fence instead.
>>>> +     */
>>>> +    if (!fence) {
>>>> +        fence = dma_fence_allocate_private_stub();
>>>> +        if (!fence) {
>>>> +            ret = -ENOMEM;
>>>> +            goto err;
>>>> +        }
>>>> +    }
>>>> +
>>>>        drm_syncobj_replace_fence(binary_syncobj, fence);
>>>>        dma_fence_put(fence);
>>>>    err:
>>>


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D61646BA69
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 12:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbhLGLy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 06:54:57 -0500
Received: from mail-sn1anam02on2068.outbound.protection.outlook.com ([40.107.96.68]:36672
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231187AbhLGLy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 06:54:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmPi+CI/qzZAFOryFe7MQkFgzW3VkaiaQO6O/IA/cfqI67WDqThPc98Gk0BKaY5DaBx3lCC4aJfXjIAYimCDgcEiz90/NTgqE87vfdHZd7G3c3C3MRtoyGCPY2wHSAQhKV+z2qNu4zV+EtRd434I4J3U+P/fPX4VQ54jHEkjDxR/jip+qYwkPERkqlsPnqh0x3XaUFe/Cz6utMk0JWR7Z+Xt/SL97tyzQI3Emqup+9VTI9Xo/OjxhyI/ZZqOfPBmgIwsEwyMcFWg3VM5tVtFar8fOuOq/erK01dA9jU8lSzTwLDcjeu3j+Xn7b2CF+YVw5pzVFdvl6+aG407N7jqwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgvlnvqKltzam28AA9a1VVRyT81em9WwSTrv+PBFe2k=;
 b=VrYRFHnNN6Ujv2kYWzjV4zrwqWGNRWW/Z0/hkimMmBj0I1BR3FGnlyOIdtwdR9bBL+UrdzNLjZ+tLq4wRObx/MihT/WJiaKWuMdXYMTZO90cMS+NxFNDeVM+lQlhp0cgZK99f+oj0aYBsSArFjWxYdICYjUYVkpwm7z06COqgdLifvFw9cgS6fvUZrM6A2loqDGlKTZviqUALF/UWovHpx5C722qa3CJslN833TcZzZDaZREbErJeQb+pPJ2kpTksOwelWhSMYj0zk8DdDWGycScN6zA033Sk6b3yy2fXtqU0+oCCYyzStmCcN0X48ofUKACcxoTlLer6He7XImncQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgvlnvqKltzam28AA9a1VVRyT81em9WwSTrv+PBFe2k=;
 b=ooSAsbMS+gjbwyMWwrtslLOJWMTa025RfaHSDxPUK109rG/DvLh5pN8CbvI51SFAKeJrK1IO1OqhBT+tiTWrrqeX/fFzChwGvWurOPuyGJ565sFmIqBlaaeBEkRhe+I2htAqve/pOWmup/hD1saQS01kU62U1ieZfY2F/ar+1b4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14) by MW2PR12MB2490.namprd12.prod.outlook.com
 (2603:10b6:907:9::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 7 Dec
 2021 11:51:22 +0000
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::d16c:a6d5:5d2e:f9d4]) by MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::d16c:a6d5:5d2e:f9d4%12]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 11:51:22 +0000
Subject: Re: [PATCH] drm/syncobj: Deal with signalled fences in transfer.
To:     Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc:     ML dri-devel <dri-devel@lists.freedesktop.org>,
        stable@vger.kernel.org
References: <20211207013235.5985-1-bas@basnieuwenhuizen.nl>
 <05f1e475-3483-b780-d66a-a80577edee39@intel.com>
 <7d2f372f-36f5-1ecc-7ddb-25cf7d444e5d@amd.com>
 <CAP+8YyEzsedvYObj=FVUFTtYo4sdHH354=gBfCAu16qtL1jqLg@mail.gmail.com>
 <9540e080-6b07-c82c-d4d2-d2711a50066d@amd.com>
 <e8b90142-770f-7c23-59c6-303c88eaf6e6@intel.com>
 <CAP+8YyE=77aYN_RCiRwayRw=k2=-SEsjr3SswadGTx4C=pM=Qw@mail.gmail.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <08d9bb20-1719-613f-b84c-0278de623d5f@amd.com>
Date:   Tue, 7 Dec 2021 12:51:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <CAP+8YyE=77aYN_RCiRwayRw=k2=-SEsjr3SswadGTx4C=pM=Qw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AS9PR04CA0067.eurprd04.prod.outlook.com
 (2603:10a6:20b:48b::14) To MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14)
MIME-Version: 1.0
Received: from [192.168.178.21] (87.176.191.248) by AS9PR04CA0067.eurprd04.prod.outlook.com (2603:10a6:20b:48b::14) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 7 Dec 2021 11:51:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b7e37a2-d86e-4af3-1042-08d9b977e36a
X-MS-TrafficTypeDiagnostic: MW2PR12MB2490:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB2490348C605A9B526B888A4C836E9@MW2PR12MB2490.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bqzWGY7ukGKvZn7NnhH6VTdER9sJkBEm9VMTzUyMynXLqRhJFPY6+S/YCXgu88ALu9r5HqZJlZoN7ppl5e1PcRJU+uWuFllKE623Gtnek1jEjLuVykZqVZsnRjInesIcjZULRfXThVSnnJJBqAo9iMKQIFyrV+WxQeaaW/7GXtxUHVxztIJTYrXDZoty1w0U4Cb+jXc0IfFIkkxWt/rkIrXEn7YRw0IwVurm9i2U/qD3aAOOnJfz5sDO8jLa+qGa2QUGUdV6Gv/PEaTogvoW14MV3XBwPxQgg7gaphGM1L2wXwWHohumWZnypWh7hdtYNwW0upDgngvDA/3FGq8o/BHcl1XghrdlBJWmyjOyjmrggig0G8gJew6W7mugqaJm+1SZH2INaPKuBq0cD9A2k5Khq1CRWYmNoP34EZBin9nKN86TcoaW00UBvjwyDhQFmXXU9AuoFtHaYiGVaZSsOzImg1c4ZtzRAMqgLJdwJ8rEjiSlfhEsoXg7abRQaQ0cmlo1S7ZhhQgM0WlhfezA6X82+Lta+ASaadY37erKeFEMF2T01qGR/E3pKvV2cIAtlPDJDsYDtXIXb8E59odor3/6jElS6cF0QIPqgfOYx3B3CPCRDfsEygstfox1wmRqMSzu77Ei/Oe5ZKT4W73EE/cybp1tqggJV4c4UptWR1OEk0PUqOnu0/IWyEDxcivYd3E8Z3QBx7WjNf8eELYA5Ufr8uHP5GLU2xyg428hNsyX7YJbB1wKWNnzQD7Ty9P8J0paVCfwZO/YK5hh3Kv/zvw94wdaBZZ7gVGFJ4S1zQ3vslg2iil2b9wk1o4l6ozN5yZ5Vrso09UJRDeQohuWoszLz22BHjzlIlcWFZgr/Fo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1201MB0192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(16576012)(66476007)(26005)(316002)(966005)(66556008)(53546011)(508600001)(6666004)(8676002)(36756003)(4326008)(2906002)(38100700002)(2616005)(186003)(86362001)(31686004)(45080400002)(110136005)(83380400001)(956004)(31696002)(6486002)(5660300002)(66574015)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1VCaEZHRHlQbHFOOERpSFRoWEx5NVZmekV4NWUzcDdxS05DQW5OOFk4WVVG?=
 =?utf-8?B?YU9ROC9WWm5lUXY4T3Zaa0hkbmZ0UG9uL3k1OHNBa2pSckJzOGR4ek51VFpS?=
 =?utf-8?B?V0svZkt1UVNUMGFaRXEvOU5oMWV1TzExaGFRMWl0TUwzNWtQdFprVVhIUXlv?=
 =?utf-8?B?QVkzcUYxNkxkbXdoRy9aWEV0Q0xRYlk1Mkpva0VUWFBRZWVRZU1zZDFGaGN3?=
 =?utf-8?B?bGgxVjBwRE42MkFqR2xrb2MyTEhFc1BvcmpaaElqTXBPMHV4Qm5oVTZFK1RX?=
 =?utf-8?B?Nzlpa3ZPTlJzblZvVkl6Y2JwQ1M0QjlQKzJ2bDk5Wk5Zb2lGMnNBallTSThE?=
 =?utf-8?B?YVpZaTI2WG42djFBNkxJNHhFR0V1SzdrUFZlTllyNFJFNUZ4NWg0TkZhdjhL?=
 =?utf-8?B?MnlMUCt2OUQ4by9GTlFDQjJ4QldYSWhpdnA3eUNDcXNWTmJiTEZmajBmZW9o?=
 =?utf-8?B?NlpGdG5wZU9MUm5hWHNPYVRRYy8wSTc3OFoyb3d5U3BHbzMzV0EzU2haTUsy?=
 =?utf-8?B?bEFIRU94c1NETFlSeHVSRUlmTlZ3N1p6Uy9xZGQ1ZWpoOTJwL1dOUjBETHhL?=
 =?utf-8?B?NzUxdE13NXQxY3kwcUZ5UmlYL0tCc2d1a0s0cEEzRmc0ZllMZDVmU1FLSDdp?=
 =?utf-8?B?Q1FjQWtOT1h2TEJYRXVIY3hNczIwYno0OFZPZEEwTEVGVFVMSWF1bG45RXI5?=
 =?utf-8?B?OG5DVEI0V3dKaG0wVTk1V2RwdlJMT05YOSt1K0hvVHNkaGI4SHdFcGZxeENM?=
 =?utf-8?B?MXJtZUlsTmhZNnRLc3UxMTM4MHVpMkhzTDYvb1hIaXRzK3ZzYUQ1REZjSlZr?=
 =?utf-8?B?UlZpLytVYmVjcHpRUklBTFRIU1pGTmhNMjBVNnJtRVRPQTFrbUd6YkNTV3hz?=
 =?utf-8?B?RkNKRzcyaSs0bTNlZ3JjY2JNN2F0THd0Y2dFTkU4K2FoMmVOUHRGNHQ0Y1Bx?=
 =?utf-8?B?OTlOdG9KOG8rNm1yQmQyL3FmZ1VQWTN2NDdkQmFncEtOKzV1ZDlIZTlqSUNt?=
 =?utf-8?B?MUV6NlF1ZGxwNlVYZ1JGdU1JbnArcGM5bHBGb0h0cGJ1bXVTRktkRStKeW5V?=
 =?utf-8?B?ejNLblg0ZzFzbXZ1YzE2NmpzOVNJR24xbGtPVlBEVTZ6QUhsRGpYVklJOWZX?=
 =?utf-8?B?VVNPSzQzUGFLaDBEdHRjRXA2LzdHR0RWYkh5UzR3MnhPREhBUlg2RFNjK09Q?=
 =?utf-8?B?TUczcUhjdXVWNitIWnc5UkFJTjE0VzRhSE5Jb1ZIb3RuSTU5N2kzeXVsL2RD?=
 =?utf-8?B?dEJyNjN0WjBjSmk0ZkVERytRak9CNnBmbXZ4bjlVTEUxQ1cwV0JCOVhRM29M?=
 =?utf-8?B?d2V6NG5DMnlTSWpROGd0a240TVliQ2s0UGVaa3V0N3BqNE1aRUQxa1pqTnoy?=
 =?utf-8?B?MEZuWmhBUU1aQ3Q0aUtDbGVhNllVaUdEQ2tmck1WVnBib2Iram5vTlRHb0ho?=
 =?utf-8?B?YSt6b1FCcVVKUUdsUUozclBnR0FaOFE1NFJjOXcxYUxCRDM5MXhsSTg4ZlEy?=
 =?utf-8?B?M0hYNElDcFVvaVJVTDJ1OWZpVnA2TnlNbTM5NkowL1pBc2g1Nk5ib01aeHh4?=
 =?utf-8?B?NXdWUkNoeCtXcVhJVllJRmtYbHFLamxaUEwzbzRUSDZvQnBTZktlMFZQeWhL?=
 =?utf-8?B?YVBrdXdZMFgrTldzOFhyYmlqQkJLQUJBVzlDUEQxa2MrL1pLRjZXelBUM1RO?=
 =?utf-8?B?Ry9jTkp2b0grQUZVVFVaWWR2bmtXT2ZrTjB2OVZEUjJjZTB5VzdxQkRIV0pt?=
 =?utf-8?B?ZFZYRE00SEZSL3R4Q1N4ZGxuc3pKOGhlZ1QwRzFWM1QybmRnM2JYaTRPd1NZ?=
 =?utf-8?B?TExERmo0UmN5eWdYM2QxRWVnSXgva0lEOVFrUzhSNk1RNDhhREVwTUhMa0lv?=
 =?utf-8?B?aWtRTCtRaVhZY0ZUOU1ZbDFpUm9tUE9xYjdCQU1aZWNxNVVyeWRrejV1RUtC?=
 =?utf-8?B?UGtHbjk0ajl3OTR6VDgzbTZCZzErSVhXZ1pyMWc2Vy9jNjNxUExGMzVyU2RT?=
 =?utf-8?B?Q3hseEI0L0dyTldkNnJPSXdUemg4Z1prZlBGYUwrRXphcmdwYkZwRkNuaVF4?=
 =?utf-8?B?dHUzTmUvRkoxN2xiU3VFWnhucTBSZ2N2Q2xnK1h5UEZiSzM4S2tKYUp1VWw2?=
 =?utf-8?Q?9XGo=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b7e37a2-d86e-4af3-1042-08d9b977e36a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1201MB0192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 11:51:22.0620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ap03OLke1BdMYz9yn+zpVu+uK5f1tqCWsN1dTbSRlsflw53dxbteVnryJRaDAnpf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2490
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 07.12.21 um 12:35 schrieb Bas Nieuwenhuizen:
> On Tue, Dec 7, 2021 at 12:28 PM Lionel Landwerlin
> <lionel.g.landwerlin@intel.com> wrote:
>> On 07/12/2021 13:00, Christian König wrote:
>>> Am 07.12.21 um 11:40 schrieb Bas Nieuwenhuizen:
>>>> On Tue, Dec 7, 2021 at 8:21 AM Christian König
>>>> <christian.koenig@amd.com> wrote:
>>>>> Am 07.12.21 um 08:10 schrieb Lionel Landwerlin:
>>>>>> On 07/12/2021 03:32, Bas Nieuwenhuizen wrote:
>>>>>>> See the comments in the code. Basically if the seqno is already
>>>>>>> signalled then we get a NULL fence. If we then put the NULL fence
>>>>>>> in a binary syncobj it counts as unsignalled, making that syncobj
>>>>>>> pretty much useless for all expected uses.
>>>>>>>
>>>>>>> Not 100% sure about the transfer to a timeline syncobj but I
>>>>>>> believe it is needed there too, as AFAICT the add_point function
>>>>>>> assumes the fence isn't NULL.
>>>>>>>
>>>>>>> Fixes: ea569910cbab ("drm/syncobj: add transition iotcls between
>>>>>>> binary and timeline v2")
>>>>>>> Cc: stable@vger.kernel.org
>>>>>>> Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
>>>>>>> ---
>>>>>>>     drivers/gpu/drm/drm_syncobj.c | 26 ++++++++++++++++++++++++++
>>>>>>>     1 file changed, 26 insertions(+)
>>>>>>>
>>>>>>> diff --git a/drivers/gpu/drm/drm_syncobj.c
>>>>>>> b/drivers/gpu/drm/drm_syncobj.c
>>>>>>> index fdd2ec87cdd1..eb28a40400d2 100644
>>>>>>> --- a/drivers/gpu/drm/drm_syncobj.c
>>>>>>> +++ b/drivers/gpu/drm/drm_syncobj.c
>>>>>>> @@ -861,6 +861,19 @@ static int
>>>>>>> drm_syncobj_transfer_to_timeline(struct drm_file *file_private,
>>>>>>>                          &fence);
>>>>>>>         if (ret)
>>>>>>>             goto err;
>>>>>>> +
>>>>>>> +    /* If the requested seqno is already signaled
>>>>>>> drm_syncobj_find_fence may
>>>>>>> +     * return a NULL fence. To make sure the recipient gets
>>>>>>> signalled, use
>>>>>>> +     * a new fence instead.
>>>>>>> +     */
>>>>>>> +    if (!fence) {
>>>>>>> +        fence = dma_fence_allocate_private_stub();
>>>>>>> +        if (!fence) {
>>>>>>> +            ret = -ENOMEM;
>>>>>>> +            goto err;
>>>>>>> +        }
>>>>>>> +    }
>>>>>>> +
>>>>>> Shouldn't we fix drm_syncobj_find_fence() instead?
>>>>> Mhm, now that you mention it. Bas, why do you think that
>>>>> dma_fence_chain_find_seqno() may return NULL when the fence is already
>>>>> signaled?
>>>>>
>>>>> Double checking the code that should never ever happen.
>>>> Well, I tested the patch with
>>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.freedesktop.org%2Fmesa%2Fmesa%2F-%2Fmerge_requests%2F14097%2Fdiffs%3Fcommit_id%3Dd4c5c840f4e3839f9f5c1747a9034eb2b565f5c0&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7C342b0cbdff7d487630ae08d9b975abd9%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637744738372115823%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=5SiZYL1TgLq3ldGy1COOkSasklZWQN%2BxWGXJ1j%2BHSOQ%3D&amp;reserved=0
>>>>
>>>> so I'm pretty sure it happens, and this patch fixes  it, though I may
>>>> have misidentified what the code should do.
>>>>
>>>> My reading is that the dma_fence_chain_for_each in
>>>> dma_fence_chain_find_seqno will never visit a signalled fence (unless
>>>> the top one is signalled), as dma_fence_chain_walk will never return a
>>>> signalled fence (it only returns on NULL or !signalled).
>>> Ah, yes that suddenly makes more sense.
>>>
>>>> Happy to move this to drm_syncobj_find_fence.
>>> No, I think that your current patch is fine.
>>>
>>> That drm_syncobj_find_fence() only returns NULL when it can't find
>>> anything !signaled is correct behavior I think.
>>
>> We should probably update the docs then :
>>
>>
>>    * Returns 0 on success or a negative error value on failure. On
>> success @fence
>>    * contains a reference to the fence, which must be released by calling
>>    * dma_fence_put().
>>
>>
>> Looking at some of the kernel drivers, it looks like they don't all
>> protect themselves against NULL pointers :
>>
>>
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Felixir.bootlin.com%2Flinux%2Flatest%2Fsource%2Fdrivers%2Fgpu%2Fdrm%2Fvc4%2Fvc4_gem.c%23L1195&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7C342b0cbdff7d487630ae08d9b975abd9%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637744738372115823%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=LjyWQpIUqqAGgR7ak3CJOJTqf%2FG8QB9BZX542vL25RA%3D&amp;reserved=0
>>
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Felixir.bootlin.com%2Flinux%2Flatest%2Fsource%2Fdrivers%2Fgpu%2Fdrm%2Famd%2Famdgpu%2Famdgpu_cs.c%23L1020&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7C342b0cbdff7d487630ae08d9b975abd9%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637744738372115823%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=kk9k8sDNLiOFTIyul79FbhfQ4Y2MdwFA6rT0h46xM40%3D&amp;reserved=0
> amdgpu handles it here (amdgpu_sync_fence checks for a NULL fence).
> But yeah I think it is a bit treacherous, especially as this only
> occurs with timeline semaphores.

Mhm, that's a good point.

While I still think it makes more sense from the design perspective to 
return NULL to distinct that there is nothing to wait for, I see as well 
that this is it not the most defensive approach.

Ok in that case let's move it into drm_syncobj_find_fence() instead.

Just one more thing, the timestamp is now busted anyway (cause the 
original fence is already garbage collected). So we can probably use 
dma_fence_get_stub() instead of dma_fence_allocate_private_stub().

Regards,
Christian.

>
>>
>> -Lionel
>>
>>
>>> Going to push your original patch if nobody has any more objections.
>>>
>>> But somebody might want to take care of the IGT as well.
>>>
>>> Regards,
>>> Christian.
>>>
>>>>> Regards,
>>>>> Christian.
>>>>>
>>>>>> By returning a stub fence for the timeline case if there isn't one.
>>>>>>
>>>>>>
>>>>>> Because the same NULL fence check appears missing in amdgpu (and
>>>>>> probably other drivers).
>>>>>>
>>>>>>
>>>>>> Also we should have tests for this in IGT.
>>>>>>
>>>>>> AMD contributed some tests when this code was written but they never
>>>>>> got reviewed :(
>>>>>>
>>>>>>
>>>>>> -Lionel
>>>>>>
>>>>>>
>>>>>>>         chain = kzalloc(sizeof(struct dma_fence_chain), GFP_KERNEL);
>>>>>>>         if (!chain) {
>>>>>>>             ret = -ENOMEM;
>>>>>>> @@ -890,6 +903,19 @@ drm_syncobj_transfer_to_binary(struct drm_file
>>>>>>> *file_private,
>>>>>>>                          args->src_point, args->flags, &fence);
>>>>>>>         if (ret)
>>>>>>>             goto err;
>>>>>>> +
>>>>>>> +    /* If the requested seqno is already signaled
>>>>>>> drm_syncobj_find_fence may
>>>>>>> +     * return a NULL fence. To make sure the recipient gets
>>>>>>> signalled, use
>>>>>>> +     * a new fence instead.
>>>>>>> +     */
>>>>>>> +    if (!fence) {
>>>>>>> +        fence = dma_fence_allocate_private_stub();
>>>>>>> +        if (!fence) {
>>>>>>> +            ret = -ENOMEM;
>>>>>>> +            goto err;
>>>>>>> +        }
>>>>>>> +    }
>>>>>>> +
>>>>>>>         drm_syncobj_replace_fence(binary_syncobj, fence);
>>>>>>>         dma_fence_put(fence);
>>>>>>>     err:


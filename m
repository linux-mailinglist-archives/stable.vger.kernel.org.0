Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7704664A45A
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 16:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbiLLPnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 10:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbiLLPns (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 10:43:48 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6E06320;
        Mon, 12 Dec 2022 07:43:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EAqtaG3aL88x+kPY+CvGkTRDhSeKXalDheMv1QnAJBMULmtDwyZiXPhAQOY2X5GnKFM7qZ6kSF8q6GmrthriH4VgdvunwyjIeDtriAt+sG5/sPfIKWUCsrIOKyp5B9sCErNUyb57ME602DtYyXWBw2kpbEyGaIzCwOXPEl5M7gIUEww2cPDs1BLaMlQsGAUzCZf5DBBZQydqe8snG0W29BfWHWOskETKnyeQSmmSSCa13R2tyQvfR8nj1hb5trGYDNrJbMSQzpYrbThl+qQP191g33UwQgm3KdxOd89DYy++JkbaC78BN+YNrPZyQnqST3S/286oaM5+Wv0LO+Ctng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tlmXHeut9BRcBJb/VPt7g9UbX9DZ5fw/fj/NMmxRrrY=;
 b=DN6kivV+0ZI8dcZqE7lCtr7Xc2E+i+4o3UyHuBgT1OdHFhgeMJoEy0ndf5JDO/U2it5I+b7OMBXkWhEtx4KSKjmaTtQV+0wv0bv2A6o2jfox9hJHNoiYtvhnc22PL+XndQ/pH6vMRFTyNHHIJGKE8Txy8WSemoJIa3BAHkhWKaSp1ek0Djli4JiHhSKCclLsBjZzcLXDDJfCtcsnq9wWXLO2zJ8L1wOtH2TirZVGJgqYEBA3yftWueZ07Y8kahH3to0rXMFa2o3VXGW0M1VDLZ2VWOFTlmVAxrBNgmg0of7A6tcIqZNeJ1ChkjDhfo0Wz41Xza8tQXPnlPMV6uGDYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tlmXHeut9BRcBJb/VPt7g9UbX9DZ5fw/fj/NMmxRrrY=;
 b=a2R/++v7TKG8uEhKkfVuBatMLXqANB77N0REGfY7yaV0fzaqGnioFxgE8tFb7SGjuzn0Tf1lqJ3+82pwf+WSY4WKIrfprqJ+qdW51rB8Fet2gacxPp3aJyIAlM7FGNaSMIVmbM8YTtY+IMuY9phAEeDw3y14LFwYIdkoTbWhYAU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DS0PR12MB7534.namprd12.prod.outlook.com (2603:10b6:8:139::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 15:43:44 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%4]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 15:43:44 +0000
Message-ID: <eded8b50-14f1-c7b2-2176-12980fc70a71@amd.com>
Date:   Mon, 12 Dec 2022 09:43:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 1/1] crypto: ccp - Allocate TEE ring and cmd buffer using
 DMA APIs
Content-Language: en-US
To:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Cc:     Mythri PK <Mythri.Pandeshwarakrishna@amd.com>,
        Jeshwanth <JESHWANTHKUMAR.NK@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        stable@vger.kernel.org, Jens Wiklander <jens.wiklander@linaro.org>
References: <43568d5e6395fcab48262fa5b3d1a5112918fbe8.1669372199.git.Rijo-john.Thomas@amd.com>
 <7d4bca0d-2b31-26d5-26cd-655fd2b82107@amd.com>
 <aec3a8a8-e64e-c53a-a7fd-825d3ac4001e@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <aec3a8a8-e64e-c53a-a7fd-825d3ac4001e@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0116.namprd03.prod.outlook.com
 (2603:10b6:208:32a::31) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DS0PR12MB7534:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cda797b-7ba8-4e55-710b-08dadc57a682
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rW3OZ757AG/beuZ273eOs+yyy50XfgB6EAmYYSbJqLTz83TfDXf1SXakVkdEIYsmQFN8bwOABXKVcTwyTd3QHjeIji2zeiSVWuv6zDsQphUWpRTkQpCnwIDymz80yYs+kylElwfmtlkmlGi9I8CWsmBQc2HpEJ22bUZB+9ZADq2fg4BH2FwTkaOhntMFZVAz42DhovqxMaNty8XXkPwyHFNixVqzErkF6b5PlfoE/srSXhTZ4hbPTaFeF8NTNYdmtQWPb8VoDybdDSondbaZq93O4DuGEkDbbTTEkTwtmDAr3ntnOaTEzwCgWkGJEkoibSW2aQy2b3IStrglPp5nt+sAbb2ewKbC3SZmbGj0nbYJYRkhzl1NaCYQ5N4Pb5x+bNvnEGByBYxxZ+A0u5+A/zVimjBTtg8p+nuFnUI1TzLqAQSQ4Xk0jepN0Uw0cE7Yu8VPOvB353teBC0PFn+cal1hUIfzpDY+w2MyM3fXqjyul9QMdwSmV/el2bG1r6y4SCk8+c0N+ptaC+OASZgNDXOC+ZkqcLnANRA2RxcsqReXzO5/Q+bsgCNX/30Q7HAzMWp5YK6VqdTJoF7qm8Y201zrMlEa6zJcRcwh1/7wz9Dr+L+sGdDkRQNak70J79GrhQnLTdp445KJHCXSz59RiXCXFzj0kLai0OKucFLanSsmon8oIPnTvqWDnH//DFqynfBXNRjCIDe+yj0y8dYcCvTUGyo7q8dsU/0H6L/6/1lIpCHWfj2qrNgjLYc+9tii
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199015)(316002)(2906002)(110136005)(54906003)(66899015)(6666004)(8676002)(66476007)(31696002)(86362001)(36756003)(4326008)(66556008)(6512007)(2616005)(8936002)(38100700002)(478600001)(26005)(186003)(6486002)(83380400001)(7416002)(30864003)(31686004)(53546011)(5660300002)(66946007)(921005)(41300700001)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEx4SmNkM1FTT2swL0RibGYwckM4MkxiNDZpZFl6cURITnYyL2xvUUhaTzJo?=
 =?utf-8?B?aDZRdGY3d054S1JhWFB0emY3Z29vY0tiSmdsZ1Z6TkZZWlJpL0tUVzFJZm9i?=
 =?utf-8?B?dEI2cEp6c3VuWWR2SGtVQ1BjUk5QdHRiUGZXRWZNYm1VNm5ZVG1XNTFiZzFG?=
 =?utf-8?B?eHppSGN2VVlxckd3bXBTNm10QmNvd3Q3dDdYOC9qVCtMaUJwTXAxQzRTY3hh?=
 =?utf-8?B?RGJxQUR3ckdSY29RQ2F5amsranFIV2x5REhhU0N2QVlCeUZIalVMbjJxYzVJ?=
 =?utf-8?B?ODhCMG5jeDQyODU0VW16Z0FXYWlDd0Z6Y2RuUjlXNXN0eWthVWR6YkpLaWQv?=
 =?utf-8?B?U2V0RnJsVzhBdDh6ZUVpTHc0VXpEQWNvdlE3bHYwOGl4d1pOQ2g4Q1F3S3Ju?=
 =?utf-8?B?bHZReFZCTTNtdnFPSEptWW9CaU1tZmFPZFNBeHBBUDZkaVlZS0xYVm91WlNJ?=
 =?utf-8?B?RGZlUUgrQkdac3hoRU8yN3VxTEI2eWZmdFQwa0tOcWYxbmlsY05JZ3pkbHls?=
 =?utf-8?B?VjE5UGcvN2M5MnNjd3FoN1dhSUNVVUxqNlJDS0Q5Mnc5QjFFcGJNVy9sdnla?=
 =?utf-8?B?SmFFZm5lTUxHSzA0TkhDT0QzZEI5RXp3ODRHaFNXYUFURGx0ekFHMWx3cXE5?=
 =?utf-8?B?V05XRHJjZ05ZQTk0S1UrRUovRGtkMENMVDdyY2xJd1dxamFtWmhtMmNRRTFv?=
 =?utf-8?B?ZmRGdVFWcytMV29mSUVZTDFjNW9Zei9YSVVSc1ZqVWtoSFkyNzVHTU1peklY?=
 =?utf-8?B?VE04cnhkeGF3d0RNcWVNcC9mUmQrcWROaVNCTFZmSGUxRjBHMUt5RVFRS3hO?=
 =?utf-8?B?cWRvVVFDVTJockJ3TFV4QVJacHhKUEJlNzdKR3h4Y3M1Rmd0TVRjVmR3SlZa?=
 =?utf-8?B?c0FuT0FnOTlvb2NBbnZkb3NTQXBRdUZuWVJWSURjeWRhSWpUM1BEclcrWHNC?=
 =?utf-8?B?RG1MbUlQNERIVnVaSG5KaUd2STltdDB0NkFhQk9salp4c2Z5YmhXeGUxZEtr?=
 =?utf-8?B?QVFhdDNoRS96dEdrSFNkcUNJUGo0REFkVnRZU0gweCt2cFA3SGkrcGJ2dnls?=
 =?utf-8?B?RlFxNHQ2VFZvT2dvd3Fvckw5a0x4NVZHOUR2WkFNODgwMG9LdisvRjBpS2Jl?=
 =?utf-8?B?SGlWSE9iclJ2OHNiN2EvTXFkMnQwVXl0Q0tVc3lxL3hOTytPTkFPMzB1ckJL?=
 =?utf-8?B?L3pnSWlBMHJra2JhMUxrbEM1a0ZFWVJ0cklZclpBNzBGSE5RYk5KWE9IdTU1?=
 =?utf-8?B?czI1R2FLaHY5UEJhQ2RaSy9HNzhRVmprYWhLdTlEQXhIdXhaT0tnRi9sQ3lG?=
 =?utf-8?B?V3I0TFJoNStRZS9UZVR1T3M4N1VEalBkRkJJUFkwd3JuK29HNEJqeW8wVHo4?=
 =?utf-8?B?MitUNmZleTZDNSszM0hTSFF0dGVWbS95bXJMcHcwY1hDWU1oOWxKbU9nc0pm?=
 =?utf-8?B?eW5La2J5NUxOYnEycXFiSnNiRlY3RGJ0KzhBZ1N6d2VuRlNYNktva05YVDRq?=
 =?utf-8?B?YkVBTU8vRnRjR1kySXNXTkhWanRTVFpYR2xiRWZRSzdWNTNRYzJRSHNDa1FT?=
 =?utf-8?B?RHJBVVc1WXpLQWN4c1ZuSkZmY1I1ZlF0RXhBWTFDSFBKK2JwNW9NcDJOcDR0?=
 =?utf-8?B?ZUh3dXBDdTBNalBlc2x2RHFBLzErZWdsMFFESko4M1I4MkVWWHdVS1h1THEy?=
 =?utf-8?B?RXlQeGxzYUU5SSsrRmRlTmNlZjczRXJQYjdEcDU0emMyeERiUkhLdGxyL0dB?=
 =?utf-8?B?RkE4Qys3TTJkUy9tejZjSVd0WnJVRkJGSmlIN1g2bU5UVlNqc0IzNCtrL2RZ?=
 =?utf-8?B?NFRIemNCUWdpUGIxLzJXS2p2dmZyZWFvY04vMjYyRHp0bEFGZnpyZlN2V1h5?=
 =?utf-8?B?VHg5Yy9NNGtNMFpWYWlIN2g5b0ZVYUtOT2YrWGh2L1FJUGRpWTJIUnM1Y2Jq?=
 =?utf-8?B?dmd0eU9HaG9MU1VHbytGaHRVNG52WHRRS2oybHRxdElyc2puenkyL3lKdnlq?=
 =?utf-8?B?YjBYUXBaVWw5NlljZ3pKa2hpakNCUUs4bVNWeUR4MDRsbHUxaTFNSUVzNUxD?=
 =?utf-8?B?eDNhUVlhSFpWenJiUm1IZ25jZXdLelVhU2tVeVpMUEJEMXN5UXJ2allsaWQ0?=
 =?utf-8?Q?/zHAibEDubzMeVY1XDtA3r3sV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cda797b-7ba8-4e55-710b-08dadc57a682
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 15:43:44.1740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qc13JbZ6ZeU2FKIEI8ZK5o0poLOh3GmdB8mNgoZBMOHFJkDRwAMMXbp8gm3vFAWiE8SOy6mNhQWtJSR0us/L0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7534
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/12/22 05:21, Rijo Thomas wrote:
> On 12/10/2022 2:31 AM, Tom Lendacky wrote:
>> On 12/6/22 06:30, Rijo Thomas wrote:
>>> For AMD Secure Processor (ASP) to map and access TEE ring buffer, the
>>> ring buffer address sent by host to ASP must be a real physical
>>> address and the pages must be physically contiguous.
>>>
>>> In a virtualized environment though, when the driver is running in a
>>> guest VM, the pages allocated by __get_free_pages() may not be
>>> contiguous in the host (or machine) physical address space. Guests
>>> will see a guest (or pseudo) physical address and not the actual host
>>> (or machine) physical address. The TEE running on ASP cannot decipher
>>> pseudo physical addresses. It needs host or machine physical address.
>>>
>>> To resolve this problem, use DMA APIs for allocating buffers that must
>>> be shared with TEE. This will ensure that the pages are contiguous in
>>> host (or machine) address space. If the DMA handle is an IOVA,
>>> translate it into a physical address before sending it to ASP.
>>>
>>> This patch also exports two APIs (one for buffer allocation and
>>> another to free the buffer). This API can be used by AMD-TEE driver to
>>> share buffers with TEE.
>>>
>>> Fixes: 33960acccfbd ("crypto: ccp - add TEE support for Raven Ridge")
>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
>>> Co-developed-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
>>> Signed-off-by: Jeshwanth <JESHWANTHKUMAR.NK@amd.com>
>>> Reviewed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
>>> ---
>>>    drivers/crypto/ccp/psp-dev.c |   6 +-
>>>    drivers/crypto/ccp/tee-dev.c | 116 ++++++++++++++++++++++-------------
>>>    drivers/crypto/ccp/tee-dev.h |   9 +--
>>>    include/linux/psp-tee.h      |  47 ++++++++++++++
>>>    4 files changed, 127 insertions(+), 51 deletions(-)
>>>
>>> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
>>> index c9c741ac8442..2b86158d7435 100644
>>> --- a/drivers/crypto/ccp/psp-dev.c
>>> +++ b/drivers/crypto/ccp/psp-dev.c
>>> @@ -161,13 +161,13 @@ int psp_dev_init(struct sp_device *sp)
>>>            goto e_err;
>>>        }
>>>    +    if (sp->set_psp_master_device)
>>> +        sp->set_psp_master_device(sp);
>>> +
>>
>> This worries me a bit...  if psp_init() fails, it may still be referenced as the master device. What's the reason for moving it?
> 
> Hmm. Okay, I see your point.
> 
> In psp_tee_alloc_dmabuf(), we call psp_get_master_device(). Without above change, psp_get_master_device() returns NULL.
> 
> I think in psp_dev_init(), we can add below error handling:
> 
> ret = psp_init(psp);
>          if (ret)
>                  goto e_init;
>       ...
> 
> e_init:
>      if (sp->clear_psp_master_device)
>          sp->clear_psp_master_device(sp);
> 
> Will this help address your concern?

Yes, that works.

> 
>>
>>>        ret = psp_init(psp);
>>>        if (ret)
>>>            goto e_irq;
>>>    -    if (sp->set_psp_master_device)
>>> -        sp->set_psp_master_device(sp);
>>> -
>>>        /* Enable interrupt */
>>>        iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);
>>>    diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
>>> index 5c9d47f3be37..1631d9851e54 100644
>>> --- a/drivers/crypto/ccp/tee-dev.c
>>> +++ b/drivers/crypto/ccp/tee-dev.c
>>> @@ -12,8 +12,9 @@
>>>    #include <linux/mutex.h>
>>>    #include <linux/delay.h>
>>>    #include <linux/slab.h>
>>> +#include <linux/dma-direct.h>
>>> +#include <linux/iommu.h>
>>>    #include <linux/gfp.h>
>>> -#include <linux/psp-sev.h>
>>>    #include <linux/psp-tee.h>
>>>      #include "psp-dev.h"
>>> @@ -21,25 +22,64 @@
>>>      static bool psp_dead;
>>>    +struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp)
>>
>> It looks like both calls to this use the same gfp_t values, you can probably eliminate from the call and just specify them in here.
>>
> 
> Okay, I will remove gfp_t flag from the function argument.
> 
>>> +{
>>> +    struct psp_device *psp = psp_get_master_device();
>>> +    struct dma_buffer *dma_buf;
>>> +    struct iommu_domain *dom;
>>> +
>>> +    if (!psp || !size)
>>> +        return NULL;
>>> +
>>> +    dma_buf = kzalloc(sizeof(*dma_buf), GFP_KERNEL);
>>> +    if (!dma_buf)
>>> +        return NULL;
>>> +
>>> +    dma_buf->vaddr = dma_alloc_coherent(psp->dev, size, &dma_buf->dma, gfp);
>>> +    if (!dma_buf->vaddr || !dma_buf->dma) {
>>
>> I don't think you can have one of these be NULL without both being NULL, but I guess it doesn't hurt to check.
>>
> 
> Okay, we will keep both checks for now.
> 
>>> +        kfree(dma_buf);
>>> +        return NULL;
>>> +    }
>>> +
>>> +    dma_buf->size = size;
>>> + > +    dom = iommu_get_domain_for_dev(psp->dev);
>>> +    if (dom)
>>
>> You need a nice comment above this all explaining that. I guess you're using the presence of a domain to determine whether you're running on bare-metal vs within a hypervisor? I'm not sure what will happen if the guest ever gets an emulated IOMMU...
> 
> Sure we will add a comment.
> 
> We are not trying to determive bare-metal vs hypervisor here, but determine whether DMA handle returned by dma_alloc_coherent() is an IOVA or not.
> If the address is an IOVA, we convert IOVA to physical address using iommu_iova_to_phys(). This was our intention.

Ok, but if a VM gets an emulated IOMMU and ends up with an IOVA, that IOVA 
points to a GPA - and if the size is over a page, then you aren't 
guaranteed to have contiguous physical memory.

Probably not a concern at the moment, but not sure about what happens in 
the future.

> 
>>
>>> +        dma_buf->paddr = iommu_iova_to_phys(dom, dma_buf->dma);
>>
>> If you're just looking to get the physical address, why not just to an __pa(dma_buf->vaddr)?
>>
>> Also, paddr might not be the best name, since it isn't always a physical address, but I can't really think of something right now.
>>
> 
> We can use __pa(dma_buf->vaddr) only on bare-metal. In hypervisor, __pa(dma_buf->vaddr) gives pseudo-physical address; pseudo-physical address cannot be understood by ASP.
> ASP needs real physical address (aka machine address). Please see commit message.
> 
> We chose the name paddr, since it's a (real) physical address that we want to send across to ASP. I am not sure, why you say - it isn't always a physical address.

Then a nice comment above this explaining all that and the fact that when 
there is no IOMMU the DMA address is actually the physical address, would 
be appropriate. A number of years from now, this will raise questions 
without thorough documentation.

Thanks,
Tom

> 
> Thanks,
> Rijo
> 
>> Thanks,
>> Tom
>>
>>> +    else
>>> +        dma_buf->paddr = dma_buf->dma;
>>> +
>>> +    return dma_buf;
>>> +}
>>> +EXPORT_SYMBOL(psp_tee_alloc_dmabuf);
>>> +
>>> +void psp_tee_free_dmabuf(struct dma_buffer *dma_buf)
>>> +{
>>> +    struct psp_device *psp = psp_get_master_device();
>>> +
>>> +    if (!psp || !dma_buf)
>>> +        return;
>>> +
>>> +    dma_free_coherent(psp->dev, dma_buf->size,
>>> +              dma_buf->vaddr, dma_buf->dma);
>>> +
>>> +    kfree(dma_buf);
>>> +}
>>> +EXPORT_SYMBOL(psp_tee_free_dmabuf);
>>> +
>>>    static int tee_alloc_ring(struct psp_tee_device *tee, int ring_size)
>>>    {
>>>        struct ring_buf_manager *rb_mgr = &tee->rb_mgr;
>>> -    void *start_addr;
>>>          if (!ring_size)
>>>            return -EINVAL;
>>>    -    /* We need actual physical address instead of DMA address, since
>>> -     * Trusted OS running on AMD Secure Processor will map this region
>>> -     */
>>> -    start_addr = (void *)__get_free_pages(GFP_KERNEL, get_order(ring_size));
>>> -    if (!start_addr)
>>> +    rb_mgr->ring_buf = psp_tee_alloc_dmabuf(ring_size,
>>> +                        GFP_KERNEL | __GFP_ZERO);
>>> +    if (!rb_mgr->ring_buf) {
>>> +        dev_err(tee->dev, "ring allocation failed\n");
>>>            return -ENOMEM;
>>> -
>>> -    memset(start_addr, 0x0, ring_size);
>>> -    rb_mgr->ring_start = start_addr;
>>> -    rb_mgr->ring_size = ring_size;
>>> -    rb_mgr->ring_pa = __psp_pa(start_addr);
>>> +    }
>>>        mutex_init(&rb_mgr->mutex);
>>>          return 0;
>>> @@ -49,15 +89,8 @@ static void tee_free_ring(struct psp_tee_device *tee)
>>>    {
>>>        struct ring_buf_manager *rb_mgr = &tee->rb_mgr;
>>>    -    if (!rb_mgr->ring_start)
>>> -        return;
>>> +    psp_tee_free_dmabuf(rb_mgr->ring_buf);
>>>    -    free_pages((unsigned long)rb_mgr->ring_start,
>>> -           get_order(rb_mgr->ring_size));
>>> -
>>> -    rb_mgr->ring_start = NULL;
>>> -    rb_mgr->ring_size = 0;
>>> -    rb_mgr->ring_pa = 0;
>>>        mutex_destroy(&rb_mgr->mutex);
>>>    }
>>>    @@ -81,35 +114,36 @@ static int tee_wait_cmd_poll(struct psp_tee_device *tee, unsigned int timeout,
>>>        return -ETIMEDOUT;
>>>    }
>>>    -static
>>> -struct tee_init_ring_cmd *tee_alloc_cmd_buffer(struct psp_tee_device *tee)
>>> +struct dma_buffer *tee_alloc_cmd_buffer(struct psp_tee_device *tee)
>>>    {
>>>        struct tee_init_ring_cmd *cmd;
>>> +    struct dma_buffer *cmd_buffer;
>>>    -    cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
>>> -    if (!cmd)
>>> +    cmd_buffer = psp_tee_alloc_dmabuf(sizeof(*cmd),
>>> +                      GFP_KERNEL | __GFP_ZERO);
>>> +    if (!cmd_buffer)
>>>            return NULL;
>>>    -    cmd->hi_addr = upper_32_bits(tee->rb_mgr.ring_pa);
>>> -    cmd->low_addr = lower_32_bits(tee->rb_mgr.ring_pa);
>>> -    cmd->size = tee->rb_mgr.ring_size;
>>> +    cmd = (struct tee_init_ring_cmd *)cmd_buffer->vaddr;
>>> +    cmd->hi_addr = upper_32_bits(tee->rb_mgr.ring_buf->paddr);
>>> +    cmd->low_addr = lower_32_bits(tee->rb_mgr.ring_buf->paddr);
>>> +    cmd->size = tee->rb_mgr.ring_buf->size;
>>>          dev_dbg(tee->dev, "tee: ring address: high = 0x%x low = 0x%x size = %u\n",
>>>            cmd->hi_addr, cmd->low_addr, cmd->size);
>>>    -    return cmd;
>>> +    return cmd_buffer;
>>>    }
>>>    -static inline void tee_free_cmd_buffer(struct tee_init_ring_cmd *cmd)
>>> +static inline void tee_free_cmd_buffer(struct dma_buffer *cmd_buffer)
>>>    {
>>> -    kfree(cmd);
>>> +    psp_tee_free_dmabuf(cmd_buffer);
>>>    }
>>>      static int tee_init_ring(struct psp_tee_device *tee)
>>>    {
>>>        int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
>>> -    struct tee_init_ring_cmd *cmd;
>>> -    phys_addr_t cmd_buffer;
>>> +    struct dma_buffer *cmd_buffer;
>>>        unsigned int reg;
>>>        int ret;
>>>    @@ -123,21 +157,19 @@ static int tee_init_ring(struct psp_tee_device *tee)
>>>          tee->rb_mgr.wptr = 0;
>>>    -    cmd = tee_alloc_cmd_buffer(tee);
>>> -    if (!cmd) {
>>> +    cmd_buffer = tee_alloc_cmd_buffer(tee);
>>> +    if (!cmd_buffer) {
>>>            tee_free_ring(tee);
>>>            return -ENOMEM;
>>>        }
>>>    -    cmd_buffer = __psp_pa((void *)cmd);
>>> -
>>>        /* Send command buffer details to Trusted OS by writing to
>>>         * CPU-PSP message registers
>>>         */
>>>    -    iowrite32(lower_32_bits(cmd_buffer),
>>> +    iowrite32(lower_32_bits(cmd_buffer->paddr),
>>>              tee->io_regs + tee->vdata->cmdbuff_addr_lo_reg);
>>> -    iowrite32(upper_32_bits(cmd_buffer),
>>> +    iowrite32(upper_32_bits(cmd_buffer->paddr),
>>>              tee->io_regs + tee->vdata->cmdbuff_addr_hi_reg);
>>>        iowrite32(TEE_RING_INIT_CMD,
>>>              tee->io_regs + tee->vdata->cmdresp_reg);
>>> @@ -157,7 +189,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>>>        }
>>>      free_buf:
>>> -    tee_free_cmd_buffer(cmd);
>>> +    tee_free_cmd_buffer(cmd_buffer);
>>>          return ret;
>>>    }
>>> @@ -167,7 +199,7 @@ static void tee_destroy_ring(struct psp_tee_device *tee)
>>>        unsigned int reg;
>>>        int ret;
>>>    -    if (!tee->rb_mgr.ring_start)
>>> +    if (!tee->rb_mgr.ring_buf->vaddr)
>>>            return;
>>>          if (psp_dead)
>>> @@ -256,7 +288,7 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
>>>        do {
>>>            /* Get pointer to ring buffer command entry */
>>>            cmd = (struct tee_ring_cmd *)
>>> -            (tee->rb_mgr.ring_start + tee->rb_mgr.wptr);
>>> +            (tee->rb_mgr.ring_buf->vaddr + tee->rb_mgr.wptr);
>>>              rptr = ioread32(tee->io_regs + tee->vdata->ring_rptr_reg);
>>>    @@ -305,7 +337,7 @@ static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
>>>          /* Update local copy of write pointer */
>>>        tee->rb_mgr.wptr += sizeof(struct tee_ring_cmd);
>>> -    if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_size)
>>> +    if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_buf->size)
>>>            tee->rb_mgr.wptr = 0;
>>>          /* Trigger interrupt to Trusted OS */
>>> diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
>>> index 49d26158b71e..9238487ee8bf 100644
>>> --- a/drivers/crypto/ccp/tee-dev.h
>>> +++ b/drivers/crypto/ccp/tee-dev.h
>>> @@ -16,6 +16,7 @@
>>>      #include <linux/device.h>
>>>    #include <linux/mutex.h>
>>> +#include <linux/psp-tee.h>
>>>      #define TEE_DEFAULT_TIMEOUT        10
>>>    #define MAX_BUFFER_SIZE            988
>>> @@ -48,17 +49,13 @@ struct tee_init_ring_cmd {
>>>      /**
>>>     * struct ring_buf_manager - Helper structure to manage ring buffer.
>>> - * @ring_start:  starting address of ring buffer
>>> - * @ring_size:   size of ring buffer in bytes
>>> - * @ring_pa:     physical address of ring buffer
>>>     * @wptr:        index to the last written entry in ring buffer
>>> + * @ring_buf:    ring buffer allocated using DMA api
>>>     */
>>>    struct ring_buf_manager {
>>>        struct mutex mutex;    /* synchronizes access to ring buffer */
>>> -    void *ring_start;
>>> -    u32 ring_size;
>>> -    phys_addr_t ring_pa;
>>>        u32 wptr;
>>> +    struct dma_buffer *ring_buf;
>>>    };
>>>      struct psp_tee_device {
>>> diff --git a/include/linux/psp-tee.h b/include/linux/psp-tee.h
>>> index cb0c95d6d76b..c0fa922f24d4 100644
>>> --- a/include/linux/psp-tee.h
>>> +++ b/include/linux/psp-tee.h
>>> @@ -13,6 +13,7 @@
>>>      #include <linux/types.h>
>>>    #include <linux/errno.h>
>>> +#include <linux/dma-mapping.h>
>>>      /* This file defines the Trusted Execution Environment (TEE) interface commands
>>>     * and the API exported by AMD Secure Processor driver to communicate with
>>> @@ -40,6 +41,20 @@ enum tee_cmd_id {
>>>        TEE_CMD_ID_UNMAP_SHARED_MEM,
>>>    };
>>>    +/**
>>> + * struct dma_buffer - Structure for a DMA buffer.
>>> + * @dma:    DMA buffer address
>>> + * @paddr:  Physical address of DMA buffer
>>> + * @vaddr:  CPU virtual address of DMA buffer
>>> + * @size:   Size of DMA buffer in bytes
>>> + */
>>> +struct dma_buffer {
>>> +    dma_addr_t dma;
>>> +    phys_addr_t paddr;
>>> +    void *vaddr;
>>> +    unsigned long size;
>>> +};
>>> +
>>>    #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>>    /**
>>>     * psp_tee_process_cmd() - Process command in Trusted Execution Environment
>>> @@ -75,6 +90,28 @@ int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
>>>     */
>>>    int psp_check_tee_status(void);
>>>    +/**
>>> + * psp_tee_alloc_dmabuf() - Allocates memory of requested size and flags using
>>> + * dma_alloc_coherent() API.
>>> + *
>>> + * This function can be used to allocate a shared memory region between the
>>> + * host and PSP TEE.
>>> + *
>>> + * Returns:
>>> + * non-NULL   a valid pointer to struct dma_buffer
>>> + * NULL       on failure
>>> + */
>>> +struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp);
>>> +
>>> +/**
>>> + * psp_tee_free_dmabuf() - Deallocates memory using dma_free_coherent() API.
>>> + *
>>> + * This function can be used to release shared memory region between host
>>> + * and PSP TEE.
>>> + *
>>> + */
>>> +void psp_tee_free_dmabuf(struct dma_buffer *dma_buffer);
>>> +
>>>    #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
>>>      static inline int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf,
>>> @@ -87,5 +124,15 @@ static inline int psp_check_tee_status(void)
>>>    {
>>>        return -ENODEV;
>>>    }
>>> +
>>> +static inline
>>> +struct dma_buffer *psp_tee_alloc_dmabuf(unsigned long size, gfp_t gfp)
>>> +{
>>> +    return NULL;
>>> +}
>>> +
>>> +static inline void psp_tee_free_dmabuf(struct dma_buffer *dma_buffer)
>>> +{
>>> +}
>>>    #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>>>    #endif /* __PSP_TEE_H_ */

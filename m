Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED27D624D43
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 22:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiKJVql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 16:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiKJVql (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 16:46:41 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE0A48765
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 13:46:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W589so6fEi1GJIqzwT/oB2jnL5pe2DDrKF3rRlwyNibTw0BV9KlLBUHf7dXnT751m1XjceJsBIjmEM+gWEep/9hkrZZEdciq+myaGJzUSqc9YJbV3Q8cTOXqCCMMdagRD2pekxT8equKMzPXoqsrQo314zFKFwnOCQddP0m6Vh28Hh+Hr3+n07xW+zAHkY8A1mLRFus59xiWQGhxnOwNw4Bj84w6pYRpBKXN4GM5X0gxEMkcK84mQV+HJu56G0fVvdu+y3aZqYiIu9NPZdNVTHAbYd4Xp3AAGeHBwWiy2trIxMzMJpmH4dLMeHGtbafipraHraLLvfN9EYUie7RZYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6R5ZeRfBaMWOaoimFXlITytJyp1+SMW2ijrUFFKbQHI=;
 b=UYmg3AUk6PxjqZRgurj2Lrgi3ObYPtSg/oQ7WqNHocbSXACDAK2POjWSaQqEzKQBe5NEe3mFofLcmK1BgX07TQiJ2tvaqOrRFbc0pKwlQ/CpgfHkqoTJ101afxovOAWhHaZ1qpbYrUyjcrpLxlnUkVaqN59GC+qBcci+49VNILuaC4yy+PubZYqW0q0GMF1eB1HETF+pKSDHO3F35/mVJufVYdQrfG2bdGD458CCsFZd8saIkUU+GkmiI45bQ1HJSYz2JpemB/2RyAKgdCELjVehT3EczWEhlWPpjuUArMMYzFwVDlFXLjGI5T72uMzi8bTWzXUWGc0/Id77cFef1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6R5ZeRfBaMWOaoimFXlITytJyp1+SMW2ijrUFFKbQHI=;
 b=ktlAQEPo3kkzLQfW6HxfyOec0MDGnz+SO31VjWjZoQ6v650qWbbYsXx9pd6Lz5jWi2Y1gR6HVAyQpQ2GPNvUJuZpnzjFrNG1u12X7xM+oo67lUAXtVjeHJpVI1veFJvqief9AJx3WSmnR6zGXqXzk6fx0DTBsUumZGuYIryZpE4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14)
 by DS7PR12MB6006.namprd12.prod.outlook.com (2603:10b6:8:7d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Thu, 10 Nov
 2022 21:46:38 +0000
Received: from BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::5d8:f3f2:d940:5350]) by BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::5d8:f3f2:d940:5350%3]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 21:46:38 +0000
Message-ID: <c738ab9a-79b1-0433-4a4d-9e583f59de77@amd.com>
Date:   Thu, 10 Nov 2022 16:46:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/4] drm/amdgpu: always register an MMU notifier for
 userptr
Content-Language: en-US
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>,
        Philip.Yang@amd.com, amd-gfx@lists.freedesktop.org
Cc:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        stable@vger.kernel.org
References: <20221110130009.1835-1-christian.koenig@amd.com>
From:   Felix Kuehling <felix.kuehling@amd.com>
In-Reply-To: <20221110130009.1835-1-christian.koenig@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT3PR01CA0106.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::17) To BN9PR12MB5115.namprd12.prod.outlook.com
 (2603:10b6:408:118::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5115:EE_|DS7PR12MB6006:EE_
X-MS-Office365-Filtering-Correlation-Id: 78ba08d6-9151-48e7-75c5-08dac3650b61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eOP92LbbOimmAx4m826xBAZzvUse/Iw7q6HWBCLGbGL9m2hkBeJt3iOrWwA7xQ+ER9BnH6npKTFFpvijs8RaWP0hfMqb8AAcARzvfSADcDp4CBFi2rbS28eqbscrveVnAbcjTF/+NXgLkb6u1SUIA+ROMz+yH7U8nlxcGUlrMoKVMudEl/8kX/PqfuxjXeihrzf39yeCjJD0CQ1kbktASmAXpf4iemYs7ZZ7G3p8sATLDV7Zjf3zZUv1ATIerW4/tyPDQKpFhAiHw9pYOGXUHsAzMsmiEgBzf17LfB6XvCqSYG88lz5sO28Yj2FmxxYi/1+VnsOQHP7j3Zgw+PjrTYWUND/1FraG22+gYZZkEtsbkcIdKHAMPRt58uB8wHwlGAyM4n/iXOfUd9v5So0S5oBcxIAE27bWu3dy/l9hDhrhPYNnXecMo1uVTOPxTfAmLe8eJX8rGcE6Qagp6BKP1lKtB+qnTJy3U3oCy2nuuWaezsAcl3vV9n7dpCYMcsAw0zLS17Ql1EnbwPwbHON6Op/cBDcPsTvveIhItnRrafTx7hj4jT1MGPHkckdRIe7emfJmoZWMxQfp7Pzd6J708WmGqAo3nPxwjcHtQfaNj5tdaSILAoA6Lp+nUlvI897xzNUyn3+egWyJJ7Y89PBZb5mEqpthb1VbK7+f3EcipKeSJU7eM1nQlCLmnEp9gJgSuir3IjNeyay4vxllAICRlpYPQpj8b9xaRtZF/lU0fU7izTRFPEt5Hfxl+sNwmRs5iJWAuyuOhqRVlEK1Ude3dH6+OQwxnCBbFHekLe4XHy8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5115.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199015)(66574015)(38100700002)(4001150100001)(2906002)(6506007)(44832011)(5660300002)(8936002)(26005)(4326008)(8676002)(66556008)(316002)(6486002)(41300700001)(66476007)(66946007)(86362001)(31696002)(6512007)(36756003)(186003)(83380400001)(478600001)(31686004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXdHUjlUbG43SDIvazFlcjIzYjVia3FJbG5sMlhPd0tWbGNsSnhqUk1pQU1v?=
 =?utf-8?B?bmhWMmNhOU9nNndZb1U5L3RhNVcwMWtyV1IzOEFwMXJETnk0bUtFc3NlWmph?=
 =?utf-8?B?UGJvdU9idEpOTE5XVC9YQ05WQ1FvYzJaRDlKSm54MkZ3VENlQ2Y3YmFpaHNm?=
 =?utf-8?B?Y0JsSFZpWHFUV1c2UFlvOS9tY2k4M3BPdlBaQmdlanFGdDgyTU4xS2RXb1VW?=
 =?utf-8?B?UjBCZnN1SytBNmUrdHh0QW5aVFVRa3RIREVCTUdaU0pLYXJGODRkQSt6UFIw?=
 =?utf-8?B?WkxhUUdZdzZxdzlwR3IybkkzRHAzVlF6T2ZTeWlWME42MFZYS091SWZaKzN4?=
 =?utf-8?B?TkFjVmJxSEpoVVNqaEFUaFMrYW1XOUVMMGlMQ2srZHF0aWtxSjdYM0hpVndV?=
 =?utf-8?B?L2xoWlhrazlPc1hOcnRZY0FMRTJlUU96NkFmSGFrQ2RpYXQ1SmhEcFQ2Z0or?=
 =?utf-8?B?dkc4bjlKUjNVVzZHRGVjUkRMUkIwQ3Y1QnBEQ29hTjg0cXR1UzlnQWxhYVhj?=
 =?utf-8?B?Z1Z0RWdGVGUrV0JrWlpjVlBNWkpNZ2tzNjRyK0lPMUZwdHhreC94elk1MTVt?=
 =?utf-8?B?YTBZMXlHa1B3VWtUZnVQc0ZyZk1DTnpVSDNsaVJNaTZUMVA1c2phMnRod2hU?=
 =?utf-8?B?M2NQNER3c0dXb0lRT29GZ0RoeTJMZUhncFMzOVhqa3loaFhQTE42Q3hFeEx1?=
 =?utf-8?B?ajJGN1dxWXErYlZtaVdLTTN2U0Y1WWloRHVkYUgwaWFmMEp6RHVWaXAyTjR4?=
 =?utf-8?B?SmxGSUY0eUh4MTZRVU5abkZMbkhXMlI3YzJBNXZuMXZqVk0zN1J4ck9Gdmxx?=
 =?utf-8?B?dm5zeGorMjlseGg2YnVaNWJWSlJUWisrRHhZOEF0TGtnL1d1UzdhaXVIRk5M?=
 =?utf-8?B?TkFnODN5Wkl6WUdvSS85bzJjSWlxb3Byc2VRRU42WlVaVTQvY3dYNUlPQ1pR?=
 =?utf-8?B?QzBqNVB6WFFMM2hWK0NWUGgzZUZuTXlPL05iRGpPZGpwSFBaemM0Sng3R3hs?=
 =?utf-8?B?eWJNT0lQeFNFMFNsNnVkRldrZU96bnd2QkY4YnMvVmh1NHlqdmFqU09Ka0hX?=
 =?utf-8?B?VWkwZjhSOU4yVktZWXN2TmtLOXFsbVJIR25NSzVvb0U3ZzkyVW5FZy9tSWha?=
 =?utf-8?B?d2F0NW1aend5cVpKVUdwck1lbFkzcFpUcm8rMzNiT0oxMzZkSTNGWENET25T?=
 =?utf-8?B?Ykc5OGRlczBtTm82YmRaZjJTYm1pbUVaNHB3Z3FrL0FtdzFyWnVhTWpoUlY3?=
 =?utf-8?B?bzFVclgvaWdROXdVQVRWR3ZvUEVNdWhnSDJFcm81S0xvOGs3MEMxTG1EQ2xo?=
 =?utf-8?B?U1RSQUQ2a1BHYlR1MWNiWTR3d0taWEFPdGtxS0UzQVFpWmxFd2JRRnQvMWdk?=
 =?utf-8?B?UnBIRTI3bHVuU25EaWlTWjZQQmxMbXpKeHM1bmpEU1J1Q28wcENWYzdOTmVa?=
 =?utf-8?B?UzFIcXkwc2NoZmhma1dHUkVyMndoNFVENkp2WFZ4QzdDVWFsa0NVcy9tZjJG?=
 =?utf-8?B?OFJlY2JHdHJGdTNqL1ZkVFdRVmczZHZER2E4MmZ0K1RwN09hRzdmd2Z3N2FF?=
 =?utf-8?B?WHoxdVFBKzAranpzVU8vazIxVkVpT1BsVkl3WndmOFIxTC9YcVc5dWZCRGc5?=
 =?utf-8?B?OW1iam9nQWVDY3hLZkV2bFE5U0Jsb0JEalZDTC9uVTJFYUtPbDBRZUVvREUr?=
 =?utf-8?B?TmYxU2QrNEI0WnZGS2gxV09aZjNCelhnZFY1dzVjZGdDeDJMR3krL0JSOEFn?=
 =?utf-8?B?MEMzRXFzNm1hQTdpK2I4QmpLemhjMnIzZjkzMmtYR21aYnFpWEhLcmFvMXcz?=
 =?utf-8?B?eFVVRXNkYlVIZzlvWXRyMzN1bmhZVTBmdXJlRjIrUHRPNktNdFVPU0Nsdys4?=
 =?utf-8?B?RzlqblEydTkrVVAzdEhNVElYWWY4MG1UZDlSaWJ2RlkyOWxxNGZsY284bWVz?=
 =?utf-8?B?dFU4N1dwRlB2RnppQmFldTY3V2QzS1FCRUxUOXpYSUNFalo4RVFreWFtbE9j?=
 =?utf-8?B?cTBQQ1I2Z1hvVzJnMjJiTEloSHpnNC9CWGsxbUdOKzdkZzFqSGdkWVJZMU1q?=
 =?utf-8?B?SmlqZXRNMnZJam1oNHJWRlA5b3Q0a2FvRlFQZkl2NTlWMlFIUnp5T0Y4eUdN?=
 =?utf-8?Q?g9xpDoB/dRfDYXS7HRJtvJ7bX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78ba08d6-9151-48e7-75c5-08dac3650b61
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5115.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:46:38.0301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mu1wex/ytswMddubJY//ZH2tTa+dCJlDthbNovSJivOPhFhnHTsyfE5qWacEdqPnJbTy89GcmUP62VSCkq/rcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6006
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 2022-11-10 um 08:00 schrieb Christian König:
> Since switching to HMM we always need that because we no longer grab
> references to the pages.
>
> Signed-off-by: Christian König <christian.koenig@amd.com>
> CC: stable@vger.kernel.org

Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>


> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> index 8ef31d687ef3..111484ceb47d 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> @@ -413,11 +413,9 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
>   	if (r)
>   		goto release_object;
>   
> -	if (args->flags & AMDGPU_GEM_USERPTR_REGISTER) {
> -		r = amdgpu_mn_register(bo, args->addr);
> -		if (r)
> -			goto release_object;
> -	}
> +	r = amdgpu_mn_register(bo, args->addr);
> +	if (r)
> +		goto release_object;
>   
>   	if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE) {
>   		r = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);

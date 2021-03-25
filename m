Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC70B348B55
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 09:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhCYIPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 04:15:40 -0400
Received: from mail-bn7nam10on2072.outbound.protection.outlook.com ([40.107.92.72]:49344
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229913AbhCYIPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 04:15:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MR71mMSyX7ikdf3388QAdSz9JtygdyACvD8GbEIuljpN70pR3/CsyaBUUECYs2p1HNC/kWfYCffoXV3Rj7heCQj+iyJpgh5HN8vHu3/d2+X2mFlUdwjkp3jf0s5mEzCjg4QPokjxY99lzgr8Fte/T1GJozUiiBIEHXIcvbc/kP1ckJn3nWgbcQceQH5Klij/W+5KcOGTBSTmdNmCe/P+Of1FWywvMHLzmMoT4HXwe5EXy2D9xqogvaVGooK/IgxKLHEfCjAJNH0JTxwq3Zli1ZMkRtgSVgKeSd7LzlfMueZN0pk+rSkLPV3Axovm7sq+8IUzz2QmRQ50aImrjxJ7rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BjUfZyG/6gcW3US9eruk2Suddgn3ka8iM8crltWKxfw=;
 b=D2yMaS+Szwae/PcyOjFgorzt63TSV4wElSY3pIIEiGp/tYP/592iPBlZC8WoaO5xdYb/rslz4GK658pamXT/fCnisDDm63S0MYRgGL+e96T3Yfzvo2naSevvu/X2bqAsSLzFxBhs1e26lgf5lQXgHBtj4+Wiq3dR2Dwhn2YoWiTLbg+u5ZU2RgpmTyK06KbVbF1OEHXLtBok1cpW/FCAEL9xoBkO0K424/fksk5oZXjnREl9y9LeCInThv817eWS8nVTokht63F+GNUeHDiR1AoLsUcxnXkL5LBZva7ue6FrCniMmHO1IgfuTWMPpsxq6+gQJyqCjwGdh9mZZ9lVQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BjUfZyG/6gcW3US9eruk2Suddgn3ka8iM8crltWKxfw=;
 b=0DANkN1XmN/zhaD+pB6zLOlnWnrGNF01SyNpIItIIBal03jIwB2vo6HzkMGXw2Rx9g7xghuXS7E/bw2j0jqm4c9OZgTt648W87cwZ/Zm6MrGEO71/fOQF3aKwMiTRY+Ea67YYjeX29HttV0K6faE2n+90cmdVrUPeIn3Wuba6es=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4302.namprd12.prod.outlook.com (2603:10b6:208:1de::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Thu, 25 Mar
 2021 08:15:04 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2%2]) with mapi id 15.20.3955.027; Thu, 25 Mar 2021
 08:15:04 +0000
Subject: Re: [PATCH 5.11 073/120] drm/ttm: Warn on pinning without holding a
 reference
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sasha Levin <sashal@kernel.org>
References: <20210322121929.669628946@linuxfoundation.org>
 <20210322121932.109281887@linuxfoundation.org>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <8c3da8bc-0bf3-496f-1fd6-4f65a07b2d13@amd.com>
Date:   Thu, 25 Mar 2021 09:14:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210322121932.109281887@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:a792:596e:3412:8626]
X-ClientProxiedBy: FRYP281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::14)
 To MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:a792:596e:3412:8626] (2a02:908:1252:fb60:a792:596e:3412:8626) by FRYP281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.14 via Frontend Transport; Thu, 25 Mar 2021 08:15:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9be5cae4-9b2e-432f-2e8a-08d8ef6617fa
X-MS-TrafficTypeDiagnostic: MN2PR12MB4302:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB4302844BDCB3A344D25CF2F683629@MN2PR12MB4302.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gSoOYbPj9d1WIi8oqLCy0zRTPtN7XprHzZig6YUxTl4a3tCAHDY7tEZdRaDwuEEBZhjNSA63t0T3zK8X1IqZSiU/YUjW5Kmnd3G7HQkQhaDfwNsAM+zzgzL1wX5aDspn6OcCEsjAI2qFWdJA7+YQhc2DrXCe4ba77NlVLXmcAFo4DGHhycWI2WtaO+Kn8q2nzWQbz30Mnmu+hllxwDWiJ+KOfA55d3Z6FO1i/XCBdXepIlFdsR0yJDlWau2WbPkshnJkxYm1jQpALy1f9oMwm3p+EPqW7jaxKRtEaTfAyxfSTM9Ow0vHclbzt4wj//7W+QAFO6j0jLIPAPky+0wlPsUJkSxnlOxYtM1Rm7TO0Yadbknyb8Ateu7/oGxCDW3HHzWXKIKVuLNOaZYFLdqKTL24y9qetkmPUq95y2U8VHRcnGLfgulHpixJgA/oGf8n2tUbktTIVvRPkuq7957gKhqJ4ZzDXUNltd6nb0UhqfI0CbifncBHSua/IS3KSQNXZqSc+aklacSQ9xGlN1Y96WJdGa441f95v99EYhcloJRsXlESKhVWGWw+eRhuh79qjlv18pYN8XErK3WgdPevte4WIt3tEhn5c5nnhmuWEs9RGkKtCE4KksDJZmaia7N3rL4GQq9K3+g5rz0Y50GpN8uVlWYB36uXSizYcFn23DfXFxuitrmkvZDKTfOH7aHPV54gtyPEZTiNeOf5boVsIwB4wUmHbI8elKnnM5VEMkBTe0PbXV6vN794/4J8xgCP56XRjkwilzd4DscAsdK9+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(2616005)(6666004)(4326008)(31686004)(8676002)(66574015)(66946007)(8936002)(38100700001)(36756003)(316002)(83380400001)(186003)(478600001)(52116002)(66556008)(66476007)(6486002)(31696002)(2906002)(16526019)(86362001)(54906003)(45080400002)(966005)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q2RiRXZqUGhuR2dMTnhoS3lIVFQ2Vmc0U3ZSVFNyWlRJYXR0R3BOL2N6d25v?=
 =?utf-8?B?cWM5N2VTNVY4dlBTYTAySUppdk8xSm9kVUgvaUlzMDEwMTNrVEM1TFhyR0Fn?=
 =?utf-8?B?T0pETEo4Qmp2YjRCSjlaVzRtd3RoWW5pMjJPVnNhTTNobXZHUXV5UXdmQ3BW?=
 =?utf-8?B?SDFuZ3RQbGxJb0cyYkg0dUpMdXBKajFsSWJKYUg0eG50Z3A2VmFNK1k2enZM?=
 =?utf-8?B?RTZPalZlak9NN0NseWJVUml1SUxhcGg4c3ovdExXeEZ4WmltNml5SXZVdGNW?=
 =?utf-8?B?RzJUaVN3bjR6K3VidFl6T1Z1MGtMcE8yZEhpMURQbE1HWkVFS0R6UGVHUDJM?=
 =?utf-8?B?eTRhWVZVQmMxOEdUOTNJMEl6SkpUcm5HMEU2U2FobFNsWitUeTlZSkNtS2wv?=
 =?utf-8?B?OGd6N2k4MDNJVEdvSHRiNE5naDVsQ2l5bFpCbzdESm5LOWx0WmpwaUtOZDdj?=
 =?utf-8?B?ekdwUGN6TkZZd1FOVlJnQTRoaWF5RVdnNHRjWHZkRW9CRmI1aWJvRURiYjNC?=
 =?utf-8?B?aGtOVkNXRXhjNWNMdnh2NVRQZmFVczlscFNQSWhZdzcwb1FUU0s0S3A0a2hy?=
 =?utf-8?B?TXJqcXlMNytqNHBkT3lEK1Fua2NLK0xMSkpsTURzWi9wd3hwRHFPL2lkRzJU?=
 =?utf-8?B?MGE0OW1QVDRJZ05vOTFHZS9ad3FBWStBOU1xTVdWVTJZR2x0SEgxTWtlTjF6?=
 =?utf-8?B?ak1Eb1RZN2paOERhaWxwYThXdlpTRWdvT2NKM0J1bTRsNFh6MWU3TnlBWnZQ?=
 =?utf-8?B?bURyZ0pwS1ErcUlsN0NBNzlYeDgwMEI2SVJPVlRwRDFIeWdBQ3ZjYWU4TmRJ?=
 =?utf-8?B?aUFucGVFZUc1SjJCRmpGRjRRRVovWVB4cmoyeEk3Mkh5bEQ4YnJva1UvcHlN?=
 =?utf-8?B?ZzMxcFZ5L2Q2SUVsa3NubkNROUptWWtvbjUwMlhBR2QvajBrd0g0RmJvYk9D?=
 =?utf-8?B?Vk1QNVNBcTRCV3NDMFZnL3BzOHJaTEE3UVU1bEdFMDMxcVFuaWVoa2M3NkdY?=
 =?utf-8?B?dnRpbFE5ZWd2dS9jYVRHM1BVT3pjMkdqbGlaSlBjbjVkMWQrOXkxS3lvUnRV?=
 =?utf-8?B?TkdKdGlVVG1TNTQ1NDV6V0FuSU0vRW1xMEN6RmdEbm95bzZRVXNORGdhcUVP?=
 =?utf-8?B?S0dvR0JSclBIc0pKeXRKaW16VXYwbVAvTWJCYVlHa0ZGMFJmajgxaFE0R1Zo?=
 =?utf-8?B?UnNKMUdCS1BiZzJ3dXNtQ3RlNy9YYzNjbmdPZUhyNGJBaFlNQ0dJYzBDNmVm?=
 =?utf-8?B?b3IvMlp1V1dOdi85NFEvM0tJaFF6Znl3V0EvNDhKYmo1eXRuL2Zybk90dU1O?=
 =?utf-8?B?RWhPMFVSRGJZeDhQanhhRmlndzl0L25JWUxab0lacUV1OW54bjlRN25MTHho?=
 =?utf-8?B?STZmeFZSamhYNlZCM01BRW9ldlRqUDkzWDVsbmZuVnlCcG9YdHNlZGNCd0kr?=
 =?utf-8?B?cEl3a2JVQy9UamxiWENXMXJOYUlmbnlkKzRDd3hqdmZiZmZScEY4cDF4Nyth?=
 =?utf-8?B?dTVpcGllRTA1SVlOV1BwVGt6a0hHY1d0MlpkYzIxWUZEclp4WS9VdGRpZ2M2?=
 =?utf-8?B?UDNybWw5WURFRXEwUW9pTGxFa0xNSUFBeEkvTXZEeVZYU0wrcVA2eGJIRGw5?=
 =?utf-8?B?d0l0Y3BBdGRQK1RXaWsyUEdtU3FQVE02MlRTbGg4a294aUtNbHVBWHVzaEtm?=
 =?utf-8?B?MGZMVzBvUWJiOHQ4di9Xd0N1bUhqZFk3anNkSHRmYTZsQ3VSLzB2Q0I2SXVx?=
 =?utf-8?B?WmV5dmFuYzd2Z2FlL3NzbnVVL0RrU0pjS0J5VzBYbTBsenlwaFFuOWpEV3pv?=
 =?utf-8?B?bUZldGZ2MldxNExaZ3pDNTlxeWRUcDdYTzhiRDc4UlBQRWlRMGpIM1FEQ2R4?=
 =?utf-8?Q?2ntB4p+MsEmIQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be5cae4-9b2e-432f-2e8a-08d8ef6617fa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 08:15:04.5017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xRrQwyvIkWT+YEtLuGEKgLEMyg651oObg/3Xoe/KwMwR0CgOLYSG6sp/5+Fh0dGL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4302
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

sorry just realized this after users started to complain. This patch 
shouldn't been backported to 5.11 in the first place.

The warning itself is a good idea, but we also have patch for drivers 
and TTM in the pipeline for 5.12 so that the warning isn't triggered any 
more.

Without backporting all of that we now get a rain of warnings in 5.11.9.

My suggestion is to revert this patch from the 5.11 branch.

Thanks,
Christian.

Am 22.03.21 um 13:27 schrieb Greg Kroah-Hartman:
> From: Daniel Vetter <daniel.vetter@ffwll.ch>
>
> [ Upstream commit 57fcd550eb15bce14a7154736379dfd4ed60ae81 ]
>
> Not technically a problem for ttm, but very likely a driver bug and
> pretty big time confusing for reviewing code.
>
> So warn about it, both at cleanup time (so we catch these for sure)
> and at pin/unpin time (so we know who's the culprit).
>
> Reviewed-by: Huang Rui <ray.huang@amd.com>
> Reviewed-by: Christian König <christian.koenig@amd.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Christian Koenig <christian.koenig@amd.com>
> Cc: Huang Rui <ray.huang@amd.com>
> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpatchwork.freedesktop.org%2Fpatch%2Fmsgid%2F20201028113120.3641237-1-daniel.vetter%40ffwll.ch&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7C090c217ffc0f4823bbe508d8ed2ec6eb%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637520132480960479%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=SJqFJ7QthSG4R%2B918EqjKliGwi1DJUORh6DtpHGTtn8%3D&amp;reserved=0
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpu/drm/ttm/ttm_bo.c | 2 +-
>   include/drm/ttm/ttm_bo_api.h | 2 ++
>   2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
> index 22073e77fdf9..a76eb2c14e8c 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo.c
> @@ -514,7 +514,7 @@ static void ttm_bo_release(struct kref *kref)
>   		 * shrinkers, now that they are queued for
>   		 * destruction.
>   		 */
> -		if (bo->pin_count) {
> +		if (WARN_ON(bo->pin_count)) {
>   			bo->pin_count = 0;
>   			ttm_bo_del_from_lru(bo);
>   			ttm_bo_add_mem_to_lru(bo, &bo->mem);
> diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
> index 2564e66e67d7..79b9367e0ffd 100644
> --- a/include/drm/ttm/ttm_bo_api.h
> +++ b/include/drm/ttm/ttm_bo_api.h
> @@ -600,6 +600,7 @@ static inline bool ttm_bo_uses_embedded_gem_object(struct ttm_buffer_object *bo)
>   static inline void ttm_bo_pin(struct ttm_buffer_object *bo)
>   {
>   	dma_resv_assert_held(bo->base.resv);
> +	WARN_ON_ONCE(!kref_read(&bo->kref));
>   	++bo->pin_count;
>   }
>   
> @@ -613,6 +614,7 @@ static inline void ttm_bo_unpin(struct ttm_buffer_object *bo)
>   {
>   	dma_resv_assert_held(bo->base.resv);
>   	WARN_ON_ONCE(!bo->pin_count);
> +	WARN_ON_ONCE(!kref_read(&bo->kref));
>   	--bo->pin_count;
>   }
>   


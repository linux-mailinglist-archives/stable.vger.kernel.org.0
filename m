Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB47632EBDE
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 14:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhCENDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 08:03:37 -0500
Received: from mail-mw2nam12on2088.outbound.protection.outlook.com ([40.107.244.88]:59745
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229528AbhCENDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 08:03:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMdhEthl/kDqHgOLb6TdizXOgMtCwbrBN2kbWe0PWWlxGqJkn+ipKNozDegr4TfaRteTkYa3C4lCeaGccVGH35lvyUy5JVyQgaj4z5eBlXeNZmw6Hjuj7KemmkZq1/8sY1EXATU5dlwskW6rlJKFXNnD1L3uq6z1SOl484o3++pWkumVNcGcACo6vlU4aAxqMHUBj0t6dAUVp5os1Guvmke5vM2ocn/fK0dJR17ioHpI+cPhH+HQ8YvzI5vbtvgZP/Oht6ja4dDf5rYJp6Hf7DjD9poOybYgUTY4mramaxd8c2epXX1hVTio+/uf15MKK7z1YZB6m33XGSKJ3bAyWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=URvFctzEQ36Hj2S65XLIbjct8+l1pekJpDHlt2zPU9w=;
 b=WoucFC37mbV3n40AC4+Tw26sqR4NkumLuIG+jLvMmnwc/0hFU/H2Iv6SoUrWnidwCgDFFOQkUN5/sQQXC7KLNgP4hTe0GZPEhZReJdWDA8DD8lBTSIWn1scvb/lBi1oYRPRCqlaOQSVkEidsSqHPD+EOH6u05wPDceBXqXsvsCTsvhYtry+jJSmt9xzoGNd1aVrQkMoyId5tW1zAf1BnKefUi2f0pZCKhTzNwdTApcYxYMiaq45uyHfcIzfsCxajbHAWuGu+9Njqrsj7MKcNJ19KPFt7yeh20bJ1ZiCzHHG7DNQj1C9bVW0reRexbrG46ph7+8WPNFFLpHECFgfYXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=URvFctzEQ36Hj2S65XLIbjct8+l1pekJpDHlt2zPU9w=;
 b=UCbHSWPpvJC/E9QgafmoQ+RIYVik8MDYDbCf1LYBjUOljVN7maR21vJk/K0LyLvxV0eHEenTyjgNkAdmB5ZtSPhmBUtvTUN2SCoTSe/IXJTsmKH2KndXRrdXWe0BGHsAYrYvQ1Z11DX+SZJJJeBT+r2EzDf0dQWPNRONWrlskEM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4336.namprd12.prod.outlook.com (2603:10b6:208:1df::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Fri, 5 Mar
 2021 13:03:31 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2%2]) with mapi id 15.20.3912.023; Fri, 5 Mar 2021
 13:03:31 +0000
Subject: Re: [PATCH 5.11 079/104] drm/amdgpu: enable only one high prio
 compute queue
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
References: <20210305120903.166929741@linuxfoundation.org>
 <20210305120907.039431314@linuxfoundation.org>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <23197f54-020a-691c-5733-45ce7e624fec@amd.com>
Date:   Fri, 5 Mar 2021 14:03:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210305120907.039431314@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:ea67:7c1d:b656:e8ef]
X-ClientProxiedBy: AM0PR01CA0157.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::26) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:ea67:7c1d:b656:e8ef] (2a02:908:1252:fb60:ea67:7c1d:b656:e8ef) by AM0PR01CA0157.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 5 Mar 2021 13:03:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 11b7b0ce-c89e-4ead-dbcc-08d8dfd71367
X-MS-TrafficTypeDiagnostic: MN2PR12MB4336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB43361F434C1B81007906667583969@MN2PR12MB4336.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:197;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dtltyxp8Gdy78R2dzAHDeorj4t4iWuXQ/MVHtiskih8AWPxFxmMkprhN5/fn3Rvtzcf1kIRrtmGxZAk30tFLDbLv7vl9y7VEjvuXSEwcugS0pKzPCltLaSc9Hv5TxBDiBnHUIVl2l/MOSikBuvVaRGwz36hLS0LRmW63pjtr6dw344DRzldywCVb9Mps23aUI+wf0+ke5un8dzmrtuGEPKM9XuQT4vgWy+4X7vlkDpkkQ1QXyFLlAeFIQbfQbDlkh5xOytsYyZUoUeMzbSHfj5bN6J6xIy8V5HILrbo9c6c/Is0ZKe6xIav2f3rDb7v0SB4oogIQdVWHu/yj48C8KamGiMCxGL8rk+ug1UtG1NPt+vM0k4YSJA3wB5idQk3u0YiR17NSMN9eZ7TXivaX//BEIiGT+3yxiN6I9uJHThOgk3F/IyLD+GC8c79UjYxd1UsHOA48/1l2GcPTMwPOHdsbwA6vJ7uGmanoCos2fLV+M700F7LZmk7VWmkRj3n6sCfT37pQQl24eB3U00HG6JvtZ5GBqB0/lW+dfJb18BQ/XcCNVWXia2d8tN8B/PwR5bTDf/5MuC5QNla55mxgOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(6486002)(8676002)(66476007)(66946007)(66556008)(86362001)(5660300002)(36756003)(83380400001)(31686004)(2616005)(186003)(31696002)(478600001)(6666004)(52116002)(8936002)(2906002)(54906003)(4326008)(16526019)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RlRSZ0hwQWdweXRicEwrT1pKVzRmVmxaZFQvTnVjdWxnSVVVRGFpbUxYL29y?=
 =?utf-8?B?eksxbEhQMUh6dTFFTkJ3MnhST3hnY1UrNEttMEhzdDRIYjJITGp1K2xEc1pK?=
 =?utf-8?B?dW9KRzBWdkFrazFDZ3pNSHRkdFM4K0d3U2JGU1FxQytEemduNDR0YzNWWS9i?=
 =?utf-8?B?VjdEUlNrQkF2SmtoNWxCTzJrb0VMR0ZPV2owVzZyUEZWc0R6dGdTUXlBUzl1?=
 =?utf-8?B?NitjM0RRdEc1SmUvcGJ1TFAwUkV2d3BlVGY5ZE41SXpkTDdML0hjdmdqUGdw?=
 =?utf-8?B?M1AxSlRmRS90NW53VzZmQXdzVDJ4QWpFU2NqU2l6RnBoTWRoVGQrSVU0bysx?=
 =?utf-8?B?OXRjblVFSitYL1YwVEhDR3JuTE01VWdXYW5YYXJZVzN1cXZXc2pYTnNNL2pR?=
 =?utf-8?B?d2I5NmJsc1UyY3dGT0hUYlh3MUNQT1VjZEZqUWlyMEg5SnFaRWVWUWhpTC9W?=
 =?utf-8?B?QzJHUDFXeXRoYk5jTGVRbTh0VTFvazBiL1RrODFVNTJlZFYzRjFyOWRUcWg2?=
 =?utf-8?B?TFRRV0d2ajBMNmZWVnMxRllRb1hFeTJnY2ZReWcvSmJGUHRzNldIUi8vY2RZ?=
 =?utf-8?B?bEc2WnVudUtXbHpXMVpyZ0VkcHRYZHhwemQ4dFoxcC8yNUIvKzg5ZjFvb1FB?=
 =?utf-8?B?SlVzcXR6WVlDeDIrUjdiK1BnTTRkSTZpc3lya1JEa1FyL0cyUWRlWnVxVldQ?=
 =?utf-8?B?MGVyVk9rbEJZcTNnazBUZk5hNHczQXo4TTdiWDUzY2lBQ0hkOW4xM2xjR3Bs?=
 =?utf-8?B?SDdieVdvSE9TU044N2I2aWx6WkttL3Fuc2pMTmJTeXRvWURnOUs1TWMvREpz?=
 =?utf-8?B?am4rQ25GdU1DY2NvWURtRWZ2a0Y4QmI2eUhONEN4dytVOXRzQkVzTUNROFds?=
 =?utf-8?B?a09LeU9LcktiYmpkOUdWMlVaS2VBVUhHTlB6NXVyaFV6dXBNcWxNSTNWbkdx?=
 =?utf-8?B?eUlrcm55MTJWYnByUGRHNHRad3RYSUEwaXdONVVLVkpWZ0JFS29XOE9zbmhn?=
 =?utf-8?B?MVNaVDJRcGgxS2FPWjRIKzlYZmlHcTRZajB4QTdaUFRYSzM0SnNkMlE3SEw4?=
 =?utf-8?B?a1ZaaW1iSzZVd3AxajIvVDNpUnM2OTZCQ01uWWZVRlk3WWRDOGIveFlObk9p?=
 =?utf-8?B?SlJPMXMxTjVNK01GQkN6WFBCV21PV3pvR1lRS1JQQ0NTODc0czhFeEc0dnpG?=
 =?utf-8?B?a3M5UW15MEpzMEVvSS9sOTV1Y05UNENyekNhOWhYNGhycGxnV0hNVUN1TDN5?=
 =?utf-8?B?V3o4M1RnbHZ5QzNvbXpaSEJEbkEvd1cwa0RpVElRZG8yNGNMK0oxcGw5Y2t1?=
 =?utf-8?B?WTVXV0pFcVB2MlVRSEl4YjZIaGhDWjNCYmcwRE1ueGJ3M3hQWXVyMnNZcTVW?=
 =?utf-8?B?ZzNaTFVBUzdiQ3V2aDVpcENqU2VZRFZvcUdaTVNraW1oRmIwdktuZ2hSNFBN?=
 =?utf-8?B?QWtXVlR5cDlIME1aQUpYUWpaUm85YnlYZEpsVDlZVGg1dVZZcmpHUEtnbHhW?=
 =?utf-8?B?TVIyUHl3LzE3bFZMUlVtWmJCeWM4TFk4eDdNQW85cU1oWDNoN3JmL2V1V3RR?=
 =?utf-8?B?U1VqVk5VZE0yWEdTa2twQkRZV0FnSXdCeDdHQkZLOW5uZjJaZUFNYmJIR0RS?=
 =?utf-8?B?aHlMY1V6ZjdyZWgrNkdkNHFXOEpjYU5mOFlWbHFvcGFLMEJpU0dlY0xBNGZv?=
 =?utf-8?B?enoxV1Q1aFpNTzkzbDRLNGhVYmIybVFtRm1SeW1zWFJiaWNBcjRoNDJpbWFt?=
 =?utf-8?B?d2Y1V2ZQeDFEL1VXY0wyYVhFTDFsZjRDb01zLzBzVHJWT29oR243UmlhWG5P?=
 =?utf-8?B?UU1uZGFjMDNVd1NWSWFhV1ZMa0R1OTV6NERWcTNUc1VjQlI2V0tlSzBuclp0?=
 =?utf-8?Q?wxphKqOQv+013?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b7b0ce-c89e-4ead-dbcc-08d8dfd71367
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2021 13:03:31.0950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dn1fj/6Xi8vjcU3XD5hip0h2k5uqdflIiX/VoKceXdoMhgKbyzpKMudMl1aiGyve
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4336
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mhm, I'm not sure this one needs to be backported.

Why did you pick it up Greg?

Thanks,
Christian.

Am 05.03.21 um 13:21 schrieb Greg Kroah-Hartman:
> From: Nirmoy Das <nirmoy.das@amd.com>
>
> [ Upstream commit 8c0225d79273968a65e73a4204fba023ae02714d ]
>
> For high priority compute to work properly we need to enable
> wave limiting on gfx pipe. Wave limiting is done through writing
> into mmSPI_WCL_PIPE_PERCENT_GFX register. Enable only one high
> priority compute queue to avoid race condition between multiple
> high priority compute queues writing that register simultaneously.
>
> Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
> Acked-by: Christian König <christian.koenig@amd.com>
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 15 ++++++++-------
>   drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h |  2 +-
>   drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c  |  6 ++----
>   drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c   |  6 ++----
>   drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c   |  7 ++-----
>   5 files changed, 15 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
> index cd2c676a2797..8e0a6c62322e 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
> @@ -193,15 +193,16 @@ static bool amdgpu_gfx_is_multipipe_capable(struct amdgpu_device *adev)
>   }
>   
>   bool amdgpu_gfx_is_high_priority_compute_queue(struct amdgpu_device *adev,
> -					       int pipe, int queue)
> +					       struct amdgpu_ring *ring)
>   {
> -	bool multipipe_policy = amdgpu_gfx_is_multipipe_capable(adev);
> -	int cond;
> -	/* Policy: alternate between normal and high priority */
> -	cond = multipipe_policy ? pipe : queue;
> -
> -	return ((cond % 2) != 0);
> +	/* Policy: use 1st queue as high priority compute queue if we
> +	 * have more than one compute queue.
> +	 */
> +	if (adev->gfx.num_compute_rings > 1 &&
> +	    ring == &adev->gfx.compute_ring[0])
> +		return true;
>   
> +	return false;
>   }
>   
>   void amdgpu_gfx_compute_queue_acquire(struct amdgpu_device *adev)
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
> index 6b5a8f4642cc..72dbcd2bc6a6 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h
> @@ -380,7 +380,7 @@ void amdgpu_queue_mask_bit_to_mec_queue(struct amdgpu_device *adev, int bit,
>   bool amdgpu_gfx_is_mec_queue_enabled(struct amdgpu_device *adev, int mec,
>   				     int pipe, int queue);
>   bool amdgpu_gfx_is_high_priority_compute_queue(struct amdgpu_device *adev,
> -					       int pipe, int queue);
> +					       struct amdgpu_ring *ring);
>   int amdgpu_gfx_me_queue_to_bit(struct amdgpu_device *adev, int me,
>   			       int pipe, int queue);
>   void amdgpu_gfx_bit_to_me_queue(struct amdgpu_device *adev, int bit,
> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> index e7d6da05011f..3a291befcddc 100644
> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
> @@ -4495,8 +4495,7 @@ static int gfx_v10_0_compute_ring_init(struct amdgpu_device *adev, int ring_id,
>   	irq_type = AMDGPU_CP_IRQ_COMPUTE_MEC1_PIPE0_EOP
>   		+ ((ring->me - 1) * adev->gfx.mec.num_pipe_per_mec)
>   		+ ring->pipe;
> -	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring->pipe,
> -							    ring->queue) ?
> +	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring) ?
>   			AMDGPU_GFX_PIPE_PRIO_HIGH : AMDGPU_GFX_PIPE_PRIO_NORMAL;
>   	/* type-2 packets are deprecated on MEC, use type-3 instead */
>   	r = amdgpu_ring_init(adev, ring, 1024,
> @@ -6545,8 +6544,7 @@ static void gfx_v10_0_compute_mqd_set_priority(struct amdgpu_ring *ring, struct
>   	struct amdgpu_device *adev = ring->adev;
>   
>   	if (ring->funcs->type == AMDGPU_RING_TYPE_COMPUTE) {
> -		if (amdgpu_gfx_is_high_priority_compute_queue(adev, ring->pipe,
> -							      ring->queue)) {
> +		if (amdgpu_gfx_is_high_priority_compute_queue(adev, ring)) {
>   			mqd->cp_hqd_pipe_priority = AMDGPU_GFX_PIPE_PRIO_HIGH;
>   			mqd->cp_hqd_queue_priority =
>   				AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM;
> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
> index 37639214cbbb..b0284c4659ba 100644
> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
> @@ -1923,8 +1923,7 @@ static int gfx_v8_0_compute_ring_init(struct amdgpu_device *adev, int ring_id,
>   		+ ((ring->me - 1) * adev->gfx.mec.num_pipe_per_mec)
>   		+ ring->pipe;
>   
> -	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring->pipe,
> -							    ring->queue) ?
> +	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring) ?
>   			AMDGPU_GFX_PIPE_PRIO_HIGH : AMDGPU_RING_PRIO_DEFAULT;
>   	/* type-2 packets are deprecated on MEC, use type-3 instead */
>   	r = amdgpu_ring_init(adev, ring, 1024,
> @@ -4442,8 +4441,7 @@ static void gfx_v8_0_mqd_set_priority(struct amdgpu_ring *ring, struct vi_mqd *m
>   	struct amdgpu_device *adev = ring->adev;
>   
>   	if (ring->funcs->type == AMDGPU_RING_TYPE_COMPUTE) {
> -		if (amdgpu_gfx_is_high_priority_compute_queue(adev, ring->pipe,
> -							      ring->queue)) {
> +		if (amdgpu_gfx_is_high_priority_compute_queue(adev, ring)) {
>   			mqd->cp_hqd_pipe_priority = AMDGPU_GFX_PIPE_PRIO_HIGH;
>   			mqd->cp_hqd_queue_priority =
>   				AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM;
> diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
> index 5f4805e4d04a..3e800193a604 100644
> --- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
> +++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
> @@ -2228,8 +2228,7 @@ static int gfx_v9_0_compute_ring_init(struct amdgpu_device *adev, int ring_id,
>   	irq_type = AMDGPU_CP_IRQ_COMPUTE_MEC1_PIPE0_EOP
>   		+ ((ring->me - 1) * adev->gfx.mec.num_pipe_per_mec)
>   		+ ring->pipe;
> -	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring->pipe,
> -							    ring->queue) ?
> +	hw_prio = amdgpu_gfx_is_high_priority_compute_queue(adev, ring) ?
>   			AMDGPU_GFX_PIPE_PRIO_HIGH : AMDGPU_GFX_PIPE_PRIO_NORMAL;
>   	/* type-2 packets are deprecated on MEC, use type-3 instead */
>   	return amdgpu_ring_init(adev, ring, 1024,
> @@ -3391,9 +3390,7 @@ static void gfx_v9_0_mqd_set_priority(struct amdgpu_ring *ring, struct v9_mqd *m
>   	struct amdgpu_device *adev = ring->adev;
>   
>   	if (ring->funcs->type == AMDGPU_RING_TYPE_COMPUTE) {
> -		if (amdgpu_gfx_is_high_priority_compute_queue(adev,
> -							      ring->pipe,
> -							      ring->queue)) {
> +		if (amdgpu_gfx_is_high_priority_compute_queue(adev, ring)) {
>   			mqd->cp_hqd_pipe_priority = AMDGPU_GFX_PIPE_PRIO_HIGH;
>   			mqd->cp_hqd_queue_priority =
>   				AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM;


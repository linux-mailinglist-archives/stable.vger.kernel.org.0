Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C16A2FB922
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 15:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395422AbhASOSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 09:18:55 -0500
Received: from mail-dm6nam12on2048.outbound.protection.outlook.com ([40.107.243.48]:23511
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393787AbhASNJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 08:09:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1G5y2GEa+FOw1bG5DZYZXn4utH/5F4vzA9SCieKvk9y8oCCmW58eSz/DLyEz9pyZMc7Sn+cgj48P4SkvB3cYl6u5RO6RsFPHjXCdgdpL1MYId/O3l405ea8YEFRhzyZ/hGfysf+H8Mogtyv9ojbkKSnIg3eRC5zCU9HM/qfzZBfx3eiDpZ4s1ukNFbZXQn2McuZW3X1RBOemiQXjomDs344nGXOFgJ1vbWafpz9KY/URG3jExYpt1ukBDZ4TOEKx5Kv+jeBpaIALUCAxR5GDVtFYl+S1md5ZfGQrp6G1GYzA+rfk+GbAfps+E6H28MlwTaubpaU4iLMbmzhmmJu3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WX9IM1tlEj32e3zQ5ANbYKDQM5RclzwUc+IcQtYb6ps=;
 b=FWVfCCUIOACVvjDDBXveGDnhaJPMOG4cy8PyrQcfo6FLIXL8wj8nk/1S6hObH/DsQsnukWWYAgtt45tw2o8k4mkhWMdu2IeOvPKVQ8T/UVRM8PD2+hIBEzMo99ykDDjZ1b5JHGgVBngyG7eJsVj1cid4jUgWlo+ipJ4pmytVNGtrTAHmMAXJ9/4AzdaeiA/mAaYOmRUUasfFa0SmTKBILhWkmrJgbdpNa0PYLmRZp6eSSxG52Hama7K9XkARfw8udtBgzq/B+mXCLnfzylyzIbMaxbpx5uLhKEZP8+tf7dGEWTqf9/45VKdlzs22X75vfrVe0S1O0/PBeuL8PxzFTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WX9IM1tlEj32e3zQ5ANbYKDQM5RclzwUc+IcQtYb6ps=;
 b=ZWHY2BLPZydKF5bWLjtGX9FcoCfaB/B3M3vMQIMgmzneP0i5mbsflTWcym2a00vnJiN0PHF7Ig2Ob0wsVlXkPIock9REvp6qRhep2nvQQv/a2YAxUJ7IL48KvnJDlNEJ8+zd6FGDfEPx8L/xztDd6NhQbFrV9/syTTMB4qiRjik=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from BY5PR12MB3764.namprd12.prod.outlook.com (2603:10b6:a03:1ac::17)
 by BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 19 Jan
 2021 13:08:23 +0000
Received: from BY5PR12MB3764.namprd12.prod.outlook.com
 ([fe80::5927:a80d:11c4:529a]) by BY5PR12MB3764.namprd12.prod.outlook.com
 ([fe80::5927:a80d:11c4:529a%7]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 13:08:23 +0000
Subject: Re: [PATCH] drm/syncobj: Fix use-after-free
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
References: <20210119130318.615145-1-daniel.vetter@ffwll.ch>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <dd14c09f-acbe-3fa5-2088-a68951847707@amd.com>
Date:   Tue, 19 Jan 2021 14:08:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210119130318.615145-1-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-ClientProxiedBy: AM0PR04CA0111.eurprd04.prod.outlook.com
 (2603:10a6:208:55::16) To BY5PR12MB3764.namprd12.prod.outlook.com
 (2603:10b6:a03:1ac::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by AM0PR04CA0111.eurprd04.prod.outlook.com (2603:10a6:208:55::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 13:08:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2be7e365-693e-47bb-4231-08d8bc7b4c9d
X-MS-TrafficTypeDiagnostic: BYAPR12MB2759:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2759AE4F21D5B23ACAA1BC0883A30@BYAPR12MB2759.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y9GkV7ZxoBrECl7MSzHC/S0dySu0Qv/EcwVH9XYGCxRcfh+1qKASM/9Xtjchg7k7iL/cfzqsgJc+gl2YH6EjrKY3/RB/SEZaOOd3iA3pMxISqwEaScUIqSzr3c2/bGNoZP0OITNvevAEaDA+f2yhZbmwM/KdLP/LhCx0UepxnTY58FhEH/vnMcMgasdg7LZMo9qKEjjaIZeePSuiporBwVKx1EXPjJkT2a5lb0lJ3rASCF+pgFFV9V9MGNr6udmOlF85NSUwXVTXc1HZeiIns+H5gUJXZEUMjapyVyl1XVMtvPzPKY1HvqNBY+nAJAleLEYOAEz38nzJROlu9Mrp3eU4xy3rBM3mpYvJn/3eaugknRhtURJ0k/C0M2O4Mr/MDhYKAdqjfkoFAv+dYYqhMGMwCm5Tjo2go+fSL3xj7piUf5lXsGnLEhs8/zrq6uXaLD4mSs8ZKGawPrMIBVVnNfWn1v7ACESu3AtNPIHvhnA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3764.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(54906003)(4326008)(52116002)(36756003)(16526019)(31686004)(186003)(86362001)(5660300002)(8676002)(478600001)(8936002)(31696002)(316002)(7416002)(2906002)(83380400001)(6666004)(66556008)(66946007)(66476007)(2616005)(110136005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZTBDaHJIbkZGWGlUZ3NsU1NUUmlFMlZnMGc4TEQzUWdMejQvZzIyRGdIT2Rq?=
 =?utf-8?B?bzBlMXBLYm5YTVluQytHY2lUa2x6S2NKUEJYRk9tR0N6SXc3WGRzL2FPckpB?=
 =?utf-8?B?UVBGWGtyUTAzTlFMQnVXb2JhUUJEbW01aFpLQzIyT2J3MHR3TVJmdmdORnBq?=
 =?utf-8?B?UXdQZFluZGd6M2hwMi9jays4ZWRHUlhCWldVUzdvd2JZelM0azVGRDlrUmJP?=
 =?utf-8?B?Z2JONHMvMFJsSWh1cGhDMGdBN2VFd2EzK1NuZVExeFptdnJKMDlsTjZITHJs?=
 =?utf-8?B?dUNiRGdrb2VYSnpuMElCK0x2ZGJ6RklST09ZZnZmQk5CTzFpSHVhazFSemR4?=
 =?utf-8?B?S3J5L0xLZHVWbE9icHdaYk9YN1ZGaWhIY3Z4eEhmTkxoMHoxeC9vTDBkeS9V?=
 =?utf-8?B?bzVvQXAyZWk3b0h6MHlZL3FCMmEyQXhKTUk3ZjczR2JxdUpMZHF2aVl4aDJX?=
 =?utf-8?B?TWZ6VTZ3UUFFYlRMV0ZaYXlCUzVFcWo1d2llakJNam1KbEI5dzI5NlZXNTdn?=
 =?utf-8?B?QUF1cDJybFdLelJvVm1RbXdJbzNoRUVHZlY1eitycEdCVEpmNXpVb3dPaGw4?=
 =?utf-8?B?bVo4Zk1YVWFqNTgzTWg0UjNjMGtTYTNDbVhRU2FJNiswejNSc3RFR1VEWllo?=
 =?utf-8?B?RFk1WXdyS2cvLzE2Y3U1Zjl3T2ZNQ3BUTStsVjNxSEdQeUMvWGdiSkh1azl4?=
 =?utf-8?B?NFlYZm5LR0FiRXUzQm9haTdtZ1kvaVR4WWsveVpwWEV6Q3ZycUdXSHRJa0p4?=
 =?utf-8?B?NEhLS1dhc1dUM1R2MVhuVDBISVcySUpJUkRNM0lYUnpOWENpb1F1amdJWnhk?=
 =?utf-8?B?QzVVTGFjczFyYU02d1BHRzI2VWpyY05saDd4aVNRTUpMaEJ1QWhHSHdqbVRx?=
 =?utf-8?B?YkxQejFERjdYTjFKOVJkbDFUR2NDelQrTWtMdzR0cGNISkZObXh0NEVnNDhv?=
 =?utf-8?B?T284SnRkTjc2eEc3RnRXUDJiZjJySEN0NC9mOHVweWlJS1NQOEhvTVgyUzd4?=
 =?utf-8?B?Y1Y4UHpZOWNWemoraEhJZ3BTeVQ5UEg2WlNMK1dYeTZpVk50SGJoZTY4azky?=
 =?utf-8?B?aTFQaU9BTE9ndEpNb01IU2tkYVlBQ0UyUVVmbzVMVlNyYTNkQ0RiYmVpU2Zo?=
 =?utf-8?B?UUx3U3dmM3Z5WGo1ZkRZY2VkVVZvN01qemFySHRCTzAwa213RzJJUFdMNEJS?=
 =?utf-8?B?dCtzdzl5WW5TNkwxcXZCL0FnYXB5dms0MHJVaXVrMmtZeEcwSE1RWGZxTmND?=
 =?utf-8?B?cjNuZzVMSWtqUzlicWNiWTArRzhGNEhnR3hKdndKRXVGR2RsZ2ZMZFNCR0Fi?=
 =?utf-8?B?eWZnQnJvQUREMlFKN1ZtNlQ4d1VNd1NxYXVDVTFLVHFaek5TT2V5N2ZJKzcw?=
 =?utf-8?B?bFl0Y2o2cHN4am01UUNkWHNLbmFLcjVVZ1FLVDl0NEprUmNkZy9YZXZJZzdp?=
 =?utf-8?Q?cLZN3luC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be7e365-693e-47bb-4231-08d8bc7b4c9d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3764.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 13:08:22.8806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 47CeL49NYaar8sqp+lD2WPL395CM9KbNhDJNArknVnOh4oVSCQJ09GcJzsSBeuXy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2759
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 19.01.21 um 14:03 schrieb Daniel Vetter:
> While reviewing Christian's annotation patch I noticed that we have a
> user-after-free for the WAIT_FOR_SUBMIT case: We drop the syncobj
> reference before we've completed the waiting.
>
> Of course usually there's nothing bad happening here since userspace
> keeps the reference, but we can't rely on userspace to play nice here!
>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Fixes: bc9c80fe01a2 ("drm/syncobj: use the timeline point in drm_syncobj_find_fence v4")
> Cc: Christian König <christian.koenig@amd.com>
> Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: dri-devel@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v5.2+

Reviewed-by: Christian König <christian.koenig@amd.com>

> ---
>   drivers/gpu/drm/drm_syncobj.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
> index 6e74e6745eca..349146049849 100644
> --- a/drivers/gpu/drm/drm_syncobj.c
> +++ b/drivers/gpu/drm/drm_syncobj.c
> @@ -388,19 +388,18 @@ int drm_syncobj_find_fence(struct drm_file *file_private,
>   		return -ENOENT;
>   
>   	*fence = drm_syncobj_fence_get(syncobj);
> -	drm_syncobj_put(syncobj);
>   
>   	if (*fence) {
>   		ret = dma_fence_chain_find_seqno(fence, point);
>   		if (!ret)
> -			return 0;
> +			goto out;
>   		dma_fence_put(*fence);
>   	} else {
>   		ret = -EINVAL;
>   	}
>   
>   	if (!(flags & DRM_SYNCOBJ_WAIT_FLAGS_WAIT_FOR_SUBMIT))
> -		return ret;
> +		goto out;
>   
>   	memset(&wait, 0, sizeof(wait));
>   	wait.task = current;
> @@ -432,6 +431,9 @@ int drm_syncobj_find_fence(struct drm_file *file_private,
>   	if (wait.node.next)
>   		drm_syncobj_remove_wait(syncobj, &wait);
>   
> +out:
> +	drm_syncobj_put(syncobj);
> +
>   	return ret;
>   }
>   EXPORT_SYMBOL(drm_syncobj_find_fence);


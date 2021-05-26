Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB7C391D3E
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 18:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhEZQpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 12:45:05 -0400
Received: from mail-dm6nam12on2061.outbound.protection.outlook.com ([40.107.243.61]:60288
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231843AbhEZQpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 May 2021 12:45:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZYybXRiF17NeTPTH+zDPjzPultSbCkZTWfDpNhUzxHgOONC5kBcJkoOKQ7rQGQBQas8YNKlf6NjeP0b+JeVg94Q9fet3AdjnT7bkhPkYRGQ7RyN1/nS4oBzXnvVd+MW7ThEwRZqDZ/tLtDziqzOWdfM+mfozxbHuqZWs0KRSM/WJGJbZkT0HA7F3ZHAfvYEA2g9DG1yGzXeOH88d4yKaLSIxB+duqO3kQh7zHYTZM/j3G7p5YjyVFDjB19tQztNd3hp1QXRDJo1bDvxdyLApulsqJTjLq43/+XszljMzu6KIGjtP8qN+osiLO+mM0kmhYm2L/TFwRWfWO9dbACFwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thYq2Esz0vf37i10TbZnnuX1JIJipYyS9YLuRo1m3C4=;
 b=LaSgHJ0tBo0k+dacDi5iMmZFRmfjZfD6+POXdp37kQeuOGklnsmL0fM/K36zTrvR64S6jYYuv0aMMsEFEntMhyT11Y7MqU3A8Z3nH8hxe04f94YVpxrBU0W4gp4hj26o+QgP6x9W6k2ijJkP65LEFeD/Wbo/1m7Q/pBKCUtFL48A5it7nspr1jjfsQcOVcMV6jB5CKC20Bnw//QL+7M/IO8WnFsqxduKtgLQYro1cQuGHd7H1GL2ioxDRtIU5FbIpZTrJmUUskzKlxIpuW7O4zTM/z3sq1kTSLIjmvc651fKF2r1gA8TooxGhW+KCFUHEnST7/OtZX4Ww9t0PBIreg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thYq2Esz0vf37i10TbZnnuX1JIJipYyS9YLuRo1m3C4=;
 b=YJebFYyI/uLQ35gG2UcgLNdqJVwJgte/h7Bf8nd3nKsMpVVBa9sm9hFkcP4j3c5cUqdy8iqbWKz4duZi0coOXONlRHCO81turfpa8TBnol95MfVHlz6lEsDgkXqt7M/BwoNajxf+0PA/4t+geNu85RUwjUQIF/l1TuGZHMXITEs=
Authentication-Results: lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=none action=none
 header.from=amd.com;
Received: from DM6PR12MB3962.namprd12.prod.outlook.com (2603:10b6:5:1ce::21)
 by DM6PR12MB4942.namprd12.prod.outlook.com (2603:10b6:5:1be::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 26 May
 2021 16:43:31 +0000
Received: from DM6PR12MB3962.namprd12.prod.outlook.com
 ([fe80::142:82e3:7e9d:55a0]) by DM6PR12MB3962.namprd12.prod.outlook.com
 ([fe80::142:82e3:7e9d:55a0%6]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 16:43:31 +0000
From:   Luben Tuikov <luben.tuikov@amd.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Luben Tuikov <luben.tuikov@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 1/3] drm/amdgpu: Don't query CE and UE errors
Date:   Wed, 26 May 2021 12:43:14 -0400
Message-Id: <20210526164316.20547-1-luben.tuikov@amd.com>
X-Mailer: git-send-email 2.31.1.527.g2d677e5b15
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [108.162.138.69]
X-ClientProxiedBy: YT1PR01CA0148.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::27) To DM6PR12MB3962.namprd12.prod.outlook.com
 (2603:10b6:5:1ce::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (108.162.138.69) by YT1PR01CA0148.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2f::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27 via Frontend Transport; Wed, 26 May 2021 16:43:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c91196ea-5fe2-4c81-c045-08d920656500
X-MS-TrafficTypeDiagnostic: DM6PR12MB4942:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4942218B0EA59CBF6685482499249@DM6PR12MB4942.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s+QcvKjfcpCjMQisHG4RvFEobybrX1vdn1iDsIuIUwjV0aAQzKVW5vFitGpUWylofHBS1X7rEEu736FxsItSd2Lzt+POMx5y4UqmNeoY3EfoacmhgSNa4DC3/KNfA3O9k+BuKRwAjZgt8OENRSgIM1/xJQ6ysCD/LAf9ea36aEhWCuTm3GNVjg0Y60+8unfNbiBAvdvtnPgGJidDr2a10CNky42t4Zy/d11JYRkl5ItCR7E5a1+GTehYSfFEnIt/2Q+eFHv55mzXVksxt8qRdspH8JehvzRp7eWO5DEUgHUOW7+4Lkq2cRwlWqiRYI+K5PNoQCmjxRYmZp+2UYxB/iYkRaDTYQi+/nnyiK1VwLsierS4OVJzC6LHtsxfYEUp8mIwZ6YuLPE1bbaPmbhkRRd8WDP2Z1jmYa2B3duu0r2zO/fDDJ+VoRbOSrCFpvUq0qJJvPF2PqZvT7U8n9jUQHOTxTARNKI27hMWTYt2fO3hwlZOC+aVC6aC1MW0VK2DBsO8jESQ6CVjNn1EPdQD8uEjyeRoW8Hlkm12zE/u9eExEPPKWyLcHE4NGCtfQSZc1+hNPYAaRb/TqZCX/H53rui7tjJJphs/xpr0Y/GU9TNrMIChfTevgX6TwKpbYub8XOxEkXqfepCFeIZynx9Pgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3962.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(55236004)(52116002)(6506007)(38100700002)(38350700002)(83380400001)(54906003)(86362001)(316002)(66574015)(8936002)(6512007)(6666004)(8676002)(4326008)(6916009)(478600001)(6486002)(2616005)(956004)(2906002)(44832011)(16526019)(186003)(26005)(66476007)(66556008)(66946007)(5660300002)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZGgxSW0wTUdYQ0E4YXVoaHU2aTE5aW9wcHBOMGx1eklUSHM3VTNlckxSMmli?=
 =?utf-8?B?UVFpVmNvR1ZvTDBYdSt6bnc1a3dLTTVCMDgxOENWaUJQUjVnYlNDcFJlTVRs?=
 =?utf-8?B?ZnAxcFE2dDV1aGpKaWxPZTRDKzVidlM5ajZaaGZHUVlUZzVHS3R6cU1QVFFZ?=
 =?utf-8?B?cFFDU1krN3h5c1J0OXhFRzBiRnNmQ2lmUFBwbE50MjlicDZFOTNvTmhSN01C?=
 =?utf-8?B?bU1RRUhjSFJHc1BOWUQvb2dwZ1gwTmdzbG9ZcVNzQ0FZbnk2TmRmTUZXbFlv?=
 =?utf-8?B?QlAzdjRzQTJ1MDUydmpGM25NZXVCbnMzM1g2OXIxWWZPRm1zWUxpcFJueHhx?=
 =?utf-8?B?VWZGWUFjVFJBRUtEUzZiT2RFL1hhb1lQVFo0cDQxOFVWbVNiL0l4bWFZdHhL?=
 =?utf-8?B?QzFvV2xIZldyRXFMRndFelhXU1pFMmJ6dWJWVnU1cHY4bWFtbnlSb1FVVWJj?=
 =?utf-8?B?TDdob0VYNklxdTI0dlJscWl6cW4wd21kRHRTYTFlNGlxTzgzRVRIWldJeXpR?=
 =?utf-8?B?SGZXN1RXN3hiN2hqSnZCT0FoSWZVN1FXcGJCdkhYdzRra1RiR1R5MkVRcDdY?=
 =?utf-8?B?azBUeDNEWU5ibXV6akJXaCt2RFVLM1JJN3I2OUlMSk1HQUZhbFFjSkNkWVZp?=
 =?utf-8?B?bU5SUDV3Vkx3cmgrN0dlanZYanp4ZEdpTlVLci9haFNsaTVad3N6dEhMRzZh?=
 =?utf-8?B?Qm1DZ052Q3dHK0p0ZWhyemdTbWdmcFUwc0ZVck1jSE5KeFNhMXNkM3JqWGl3?=
 =?utf-8?B?aDlTdTRIRVhrY3E0S1grVEZuN0JBdmN1RkxuVnBMUE5VNXlRQkxmN1dwc1FU?=
 =?utf-8?B?aTBrUlBXcnlvaEVxdGJTWDlkczduMDZXNW9zUkx2SHB1UlV1bmh1aUtaSUEv?=
 =?utf-8?B?UyswaE5qTjVjY2VaSUcyL3ZlZ3NnTlNhQmhrZGZFbFlmZFQ0Ukg5R0cvd1hz?=
 =?utf-8?B?UENPWlc2cGE3eWloM1hYZWx3anZ3dWtPNjZHa2VMRHVrZmJJbTNaejkyZllk?=
 =?utf-8?B?YjhCNHd5MzdyTDlUcUF1Ti96ZjZDVDBhRXpOYy9zYVM5bkpjamhXQk1SNWt6?=
 =?utf-8?B?cmJMTm1EZFgrWktPemRZSFRoSStZaFdYeXFweDdydkg0WEwzRDN6dmtmQjM3?=
 =?utf-8?B?N25GY1hybDJHN1ZmSTJOVDVhdHczT3FrM0NkRTNaMDIzemd1c3ZzTVl1ckJs?=
 =?utf-8?B?ZTdBZTFEQUM2SGtWSmlwZnZISEFMYXpzSXlENnBtMzM0MzB1VUxwYm9yV2ZH?=
 =?utf-8?B?RXRKRmdZU0t1bHNVdG93QjJ6Q0JoZkJiYWVkTlp0OElFK09YdVRvRExmUE9V?=
 =?utf-8?B?T05sRnRwKy9sT0grbno2M24rY0ZyVW5ORnd3SEFtVGVmY05SZkNCSDBKejhq?=
 =?utf-8?B?OHhBMHhSSFU0a1ZDd3MvbHB0U054dW5aRzAxLzI4V2ZSRytKYUJYMTRXbXJR?=
 =?utf-8?B?ejY5ekhlMmIzMzJnWFdjQjdGRkRjM1JEMWRLM2FDNWFhZGh2VHZkeXdQRlEw?=
 =?utf-8?B?QjFTRTFBd293bHNpRnlmcUtOZ2U1L3hHKzJsWHZRR3NuN0k3MVJaVTBxeGV6?=
 =?utf-8?B?em84a2Q3aitWd1ZXcVlReXFremFoZjV2cDUzaEZCQyswSVkzcThIdlowc0ZP?=
 =?utf-8?B?QjJpb25yQmRYc2VCdkZXelppaldpeFEwR3NVdW9VUUxWeHJOVlJlQm80c3hS?=
 =?utf-8?B?bHZqNnpiMXdmejUyN2JVSmE1bE95dmo2Q1FhNHhrdnNybXBSaGJpNm9mMmZr?=
 =?utf-8?Q?pb4jFD8hikZANv9AEvy60nOyol+ZoidRc954SFw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c91196ea-5fe2-4c81-c045-08d920656500
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3962.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 16:43:30.9628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ucvnzGtLgypMTR+rzgzRLtFTN0AHSc+k1AR0eadeCB6FQwNmPDq8QwephT6GG280
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4942
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On QUERY2 IOCTL don't query counts of correctable
and uncorrectable errors, since when RAS is
enabled and supported on Vega20 server boards,
this takes insurmountably long time, in O(n^3),
which slows the system down to the point of it
being unusable when we have GUI up.

Fixes: ae363a212b14 ("drm/amdgpu: Add a new flag to AMDGPU_CTX_OP_QUERY_STATE2")
Cc: Alexander Deucher <Alexander.Deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Alexander Deucher <Alexander.Deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
index fc83445fbc40..bb0cfe871aba 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
@@ -337,7 +337,6 @@ static int amdgpu_ctx_query2(struct amdgpu_device *adev,
 {
 	struct amdgpu_ctx *ctx;
 	struct amdgpu_ctx_mgr *mgr;
-	unsigned long ras_counter;
 
 	if (!fpriv)
 		return -EINVAL;
@@ -362,21 +361,6 @@ static int amdgpu_ctx_query2(struct amdgpu_device *adev,
 	if (atomic_read(&ctx->guilty))
 		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_GUILTY;
 
-	/*query ue count*/
-	ras_counter = amdgpu_ras_query_error_count(adev, false);
-	/*ras counter is monotonic increasing*/
-	if (ras_counter != ctx->ras_counter_ue) {
-		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_UE;
-		ctx->ras_counter_ue = ras_counter;
-	}
-
-	/*query ce count*/
-	ras_counter = amdgpu_ras_query_error_count(adev, true);
-	if (ras_counter != ctx->ras_counter_ce) {
-		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_CE;
-		ctx->ras_counter_ce = ras_counter;
-	}
-
 	mutex_unlock(&mgr->lock);
 	return 0;
 }
-- 
2.31.1.527.g2d677e5b15


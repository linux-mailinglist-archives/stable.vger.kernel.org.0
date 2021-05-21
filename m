Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247C538CFB9
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 23:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbhEUVUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 17:20:23 -0400
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:40612
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229503AbhEUVUX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 17:20:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0utOfG/1UK3Vsv3ruDydw+M2Qv1P0Fqa+/gUd1tLnhvKoEK4yjwTo7Fd9OePCv2Jmcc+DsZjVo2Q+9pTrVS4eqOa9p2pdVnduFct20FG6x/rkpdt0TGB9G5qTQvDoEXv2/2jg3DzQzZk3DlprKL+1PD4FLJsqZXN0X4XDNpgYSmyK4OJYR0zYDf9Lcf4U051ymD8o8nEPskRhTiyIiGBIF95mjS3wmVQiyfIx5WTOP51GOeL4eiCSPWr6hAPEf5Sh1sC9Iaqt8AlN2uKM//EIgyLH7GlH6sFpzn0+73QZlhQTjV7NPsR0sS5fzuxevArUPVQW86KdcgdbMypyiruw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thYq2Esz0vf37i10TbZnnuX1JIJipYyS9YLuRo1m3C4=;
 b=QQ0Uk9XGtiMN24cw8ZGyd9ieoqv76+JA5fFQBMBk6zTf+x76m50hls106kOaoZwzxVwlsFNurGPq12vczD8OBBu3oHJZ8YtM3iNkZF9TJzndXaV1M44nrnD8KDbQFCSIqN5TwM52JFOUUUyTAejn/ERrBtiRcV/fiMRC2qHv0erXyIb28IWoZ2AInhuyRsSOGzYlrsbfamtQeun6q2PLd8nVkuxah/LqJuSVNt8/JgRU4VEAHZQ9nucU0HR/NLRJP/EsY+EI0tPNsDNLrMqZNHT+wQX/19pbAW2mhlFGRNCFH9ksZq67S1T5S2J03bOa1gbqahN9ejGzSzsoj5eMlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thYq2Esz0vf37i10TbZnnuX1JIJipYyS9YLuRo1m3C4=;
 b=vW+a3cTabr4fKVxoOEdtq6C0zHAszkQB/ZCAPzKjOwteWyd3EPVUiWRcnmcVUvynz15dZBF8Fzbb/b0Sw7+pf6+5jg/DNU8eC9P5sljhU05UbTHST2Cl9oqv31QjrR9U3WVD4M2XMw/v61OibbM634cK93FhBj/SoqtUkrY1TnU=
Authentication-Results: lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=none action=none
 header.from=amd.com;
Received: from DM6PR12MB3962.namprd12.prod.outlook.com (2603:10b6:5:1ce::21)
 by DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 21:18:56 +0000
Received: from DM6PR12MB3962.namprd12.prod.outlook.com
 ([fe80::142:82e3:7e9d:55a0]) by DM6PR12MB3962.namprd12.prod.outlook.com
 ([fe80::142:82e3:7e9d:55a0%6]) with mapi id 15.20.4150.026; Fri, 21 May 2021
 21:18:56 +0000
From:   Luben Tuikov <luben.tuikov@amd.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Luben Tuikov <luben.tuikov@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 1/3] drm/amdgpu: Don't query CE and UE errors
Date:   Fri, 21 May 2021 17:18:34 -0400
Message-Id: <20210521211836.4839-1-luben.tuikov@amd.com>
X-Mailer: git-send-email 2.31.1.527.g2d677e5b15
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [108.162.138.69]
X-ClientProxiedBy: YT1PR01CA0085.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::24) To DM6PR12MB3962.namprd12.prod.outlook.com
 (2603:10b6:5:1ce::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (108.162.138.69) by YT1PR01CA0085.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2d::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.31 via Frontend Transport; Fri, 21 May 2021 21:18:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42bcad78-58d4-4a54-aab3-08d91c9e0ab3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4516:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB45168FF996212656E8DF5A7499299@DM6PR12MB4516.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g/O0nDEEG1Hghi6eP1XGxaeCDsaZU1P+Ul99pIWuBlN+dWtHoA/01880nHqeZvObXix4IobfI6Su9pQ92cFtl8ygrEJ6H79bOWX55d37s/Umms4YJ9/wK3Ki98PoOrxTYmT6KHtQv+wWjxfHNnKzKQTTHYVhpD8b/ykxzEzAhWw+1xnk4m6P7xf6YRyLgz1lxl9IPHVJNGRBEvfjd6clxA/1+rgshHYe6IPeWsq69yRGliQtiCgdUT7TKmuOWB+tQOuU0BM6P8pKiowb/ivx7fL2kA8E3x98PQ5CoRJaTDZ8A4TlKwlNMC7EErjQoJFETM9TzcDooxdwHsah6JmP6Azx1tdXTp8Ci4EsZYMfbkgtudPZAXUh9JfrOHrVmY3W6BarBloZMdgdjtRvKvPaILNv8kT7vkLuNAjueS+Bmi2hqAxwrazHtqWjqG77X96kxekHcZgVeMCwFPkmpbMaYEwlkt5svmbRfA6QA2+8olVD+ANfdGx4X7k5Mu2/Rjae2j4KXQKpXoii4nbTz4wChiymYnskL9TBpLIHcUys6kUec4QbsT4Smkjv7mV/hwjAqKBYzP88yg3GVxS3vg5p0dU/crUhcD+GyDn/8shAqPNxDxVknrmnPE2jEFtWTP8h2CzeqYucG1MK8nILl3tZ1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3962.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(8936002)(2906002)(8676002)(6916009)(1076003)(66574015)(186003)(54906003)(66946007)(26005)(83380400001)(66476007)(6486002)(66556008)(6666004)(55236004)(6506007)(6512007)(316002)(38100700002)(52116002)(38350700002)(16526019)(2616005)(956004)(86362001)(478600001)(4326008)(5660300002)(36756003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R2lLMUpLM0RQelFzZjVDZ09NREdGeXZ6ekw1dWRMWWw1TCtkaWxkOHhKZXVw?=
 =?utf-8?B?Wjd1RW1XdDRvK1JLbzlwY0U0YlBKcmJkVTczK0NXS2hCcFRpVEJ2cTlMMlZl?=
 =?utf-8?B?Qjd3NVdWODU4UE9oeVgyVGJ0aE94a1QxNVhyS3A2dnE3UHZpcXExVDBkSFdE?=
 =?utf-8?B?WER1d0MwTEJDM0FoZ1VqUW4yamhQNlQzaklYcWZKcTNqQWt5Y011c2gxakpX?=
 =?utf-8?B?MXZOQ2N5ZGxRM3dleWloQ2tGM3l4NFBtdlR2ajk4ZlRBTGhFUHlOcFBqWGt4?=
 =?utf-8?B?dkU3ejZ6dWg4ZFpkRDFDbWxpMnlyRVBEUEtYQ0ozd1kvS0Jra2ZrTnVzVEd5?=
 =?utf-8?B?L1NjRDlPTktQeFh5TGllNGltejJ2T2VmT2haU0QxSk5qejhycXpqMm9xazRJ?=
 =?utf-8?B?b3VFRU0zY3lPeGgrNzNKSDM1VGw1M0VNODBNYU91ZUpZMmwwT1B0Zy9CSUNH?=
 =?utf-8?B?cUZ4VExuUkk4SWxFTHJzREJJZTVlUXk3bzhIWElVOHN1NG52WGdnZUNEenl5?=
 =?utf-8?B?Q0R0M1lWRm1IME90eWhrSU1FdFc3ZE5qVTFxdUhuci9udXJBS1JITU9Vdk5r?=
 =?utf-8?B?N0Z1UUFLc0dBWDR2VzRFWTdNYVlUQ2gvRkd2MXJuUEh4c3d6UTA5eWtNK2ZJ?=
 =?utf-8?B?Mjc1MkRaQmxpRTBLUFJtRDlhNEUrQWQwYmV0QkdaUExkQWpwZ1ZIUVlqY1Er?=
 =?utf-8?B?c1U4bWEydFczVy8zdWsxams3YzdvM3c4dWg0STYxdU8xOHBVcTVtZjBiQlBU?=
 =?utf-8?B?RWowSE9lZ01MeDd2RHNTdVlUVVMrZWd0NEVjcTFYTFJKa3ZJZDkvRm95dndR?=
 =?utf-8?B?Vlk3TytGc0pBaFVGVXJnbVFzRVFIMmdWdEVUc0VXbXlTTGZJVDdpQ0N0NFRI?=
 =?utf-8?B?ZVk5N216ajB5ZUttVURtbDRIcjJkcWxPRGp2SG14dUtrejQ5UmlxelZWRnlP?=
 =?utf-8?B?SmQ2TzdQczBJZVV6dk0zdEh5SDZSaTduMkdnWi94NXdUVmtRMWtTVmxVOW1Y?=
 =?utf-8?B?bXd2YnlBTmpuS1lNL0owYjE2cGRObytFRGpRQW9WRGtZSkJ2MExUL2g3NDd3?=
 =?utf-8?B?RXVYQlhGTHpIdE9XV0lwZ1V2cGNNb2VFVCtJR1Z2RVFiU1JleFkzdWdITnpR?=
 =?utf-8?B?M3lOT284SDdmVkx3S3JYS2hwTTdvU2JLTmFsWDRhQXg1TUcrV2lQSVo1eWU2?=
 =?utf-8?B?UTlIQ2tDNE5ubnJ1SlZQYlp5OStpL0N2ODFob1hDUXNnSXNxTlFqekJwSEJz?=
 =?utf-8?B?dnU1QmkwWFpEMUR3NW5BTkxlamNLSStGMHVGTFZTQjdRTUJ3UUxiRFdFbUVJ?=
 =?utf-8?B?cHZiOTBUNFVZd01aN0J0enV2WUNKWjhuTGFnODcrOTlWQWZtZ1R4anRjR3dY?=
 =?utf-8?B?S0pyY0xOZ0o0bWgxcGFqekZuV0k5bWRzQktzZzRQb3JQbGFOVEdVcVBHTEJV?=
 =?utf-8?B?cFQvN0pBYzBtUkdUMy80bVBhMFRnMExEN1dxaUVFMThsNktaSS9SQkFaT294?=
 =?utf-8?B?VExTUk5rQjg4TW1qWlBhVEN5Tkxja2pyL0Z2UVo1TWVuWUFKOU9WT2NnSzdQ?=
 =?utf-8?B?SDBNY2t2UVBMU2ZXWnBIOEF6cWJwUHRrR2pkSFM3Uk5TY3VxMlpCQWFYM2dH?=
 =?utf-8?B?SjhNSkV6aU50d2kybDJYTHlpYTRTdmNQV1V6Nkh2KzJEN0RUaXRobEtKYW8v?=
 =?utf-8?B?K2JzNCtndk9EU1lWc2tZSzQ1NDhBSGN5QlkzZmpZenl1ZS84UDZpTWhMVUs0?=
 =?utf-8?Q?Sq9r2MdjWjBli50zlMfBOjz6znLs7niWlfDNKyl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42bcad78-58d4-4a54-aab3-08d91c9e0ab3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3962.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 21:18:56.0922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wZzw2W7S+GSKzq4uc93fyDXpsx4sj5O2AD0XhEIZ26bXoOmd4o0FttOjiiWfbOwW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4516
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


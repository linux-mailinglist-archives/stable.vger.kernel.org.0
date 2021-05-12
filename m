Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C3D37CF2E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344357AbhELRJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:09:16 -0400
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:21024
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239208AbhELRE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 13:04:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbLMJ6E2Ps3FleaF0frYzuhXBL+TXd4ZMasVmpcOYu0V3esX5sWRkVYEuYl+7FjFhCuhugNSO7xpVGURiGy01Dpnc7WkW3GTBayJv5WKLgSm3D0yzyAW6WQKpqWhur7gkjBv0bwbGwM9jVwVGkuGlttOSePl+XwDaToX7QcOW9T3oF8Ca6Jl4cFZSkmywH3gkcRLp4AVDs9v8EqWMmipEBhoRrExEWifYVKgP38wG88JFJGKzAnInLNk5JRnjdhyxmjDpeJ9e95z7Bz1dMt3+/ZG3sNW+oh2VohSUvA6B0L+rWavIg8dM2kWX7PJL8HMmi/nNlD+nEVrLvXSd3S/aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dzSPQfiynSyS2ROiwD8MNElSfckwjf4PrMcS1kvOek=;
 b=D/ElwE9dksV489Ynyb/bgdPk9MwgRABiEKUeaj3bxQeMs01AD/sVbxpeLK1rAZgjYSrCm0B2EaVogJPUDeXQ09BZ0D/WI4GW4qMMERhFGYG30gj+RMJJo/VyJi9+lG+96nRUOH2RCmFr9CJlnjv9rk6umZR3pCSRfoF6uzjGE4JGkXp5RJpTTqyGJ4XqXGiH0FeeQOwCGm0f933CfzPlhcszwi3hpytXbHS2yEAe4xLJtt3aAG7ET2RMFqgHMj7W+X1VcRMJXL3Td6UT+2lhzxwrYe3Mzy2YCdiDA37Veg/drH8kE5CvzqUnriXskFmMT7mvw78N+cTwarlLQaCKsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dzSPQfiynSyS2ROiwD8MNElSfckwjf4PrMcS1kvOek=;
 b=rK8oflPw/6zscCAqEoy/J8jA2PHMz7uVibH1bo56PXo2lZjCLPJWYbg1k7olQQSh7qGz7UIlSupbD/K+QYrsxaETLIftgKOqdz1R9g0aCQcWl4BtL7GE4D8YZ9CilvjDs+U9piy4+2M+QQI9dLweO1vv3nPcMz5XdqE+DhfTnvc=
Authentication-Results: lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=none action=none
 header.from=amd.com;
Received: from CH2PR12MB3957.namprd12.prod.outlook.com (2603:10b6:610:2c::17)
 by CH2PR12MB3717.namprd12.prod.outlook.com (2603:10b6:610:24::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.29; Wed, 12 May
 2021 17:03:16 +0000
Received: from CH2PR12MB3957.namprd12.prod.outlook.com
 ([fe80::a5e6:2e22:512a:7d10]) by CH2PR12MB3957.namprd12.prod.outlook.com
 ([fe80::a5e6:2e22:512a:7d10%7]) with mapi id 15.20.4129.026; Wed, 12 May 2021
 17:03:16 +0000
From:   Luben Tuikov <luben.tuikov@amd.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Luben Tuikov <luben.tuikov@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] drm/amdgpu: Don't query CE and UE errors
Date:   Wed, 12 May 2021 13:03:01 -0400
Message-Id: <20210512170302.64951-1-luben.tuikov@amd.com>
X-Mailer: git-send-email 2.31.1.527.g2d677e5b15
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [108.162.138.69]
X-ClientProxiedBy: YT1PR01CA0051.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::20) To CH2PR12MB3957.namprd12.prod.outlook.com
 (2603:10b6:610:2c::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (108.162.138.69) by YT1PR01CA0051.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.31 via Frontend Transport; Wed, 12 May 2021 17:03:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 495455b4-04bc-42da-1b8a-08d91567d5d7
X-MS-TrafficTypeDiagnostic: CH2PR12MB3717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB3717ACD90500A591D1EEF4F999529@CH2PR12MB3717.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OOGD9sYkCUkRZqSXK0J6L1v7CjtDjgLZbg7ljf038LnZsbrh3OTyLqReKaKjGy9oOYX1YTO36+I+6tPf3gA4dQNhcE8LoVhx3AVvzLlCAzgtPQ9bt2h0wDwI0Wkloizm8GmoT+A/4dNp4znSPTm81FH4yWYobiwUm9AkK+9lVGCO04ehLotwa/XQdRAyV4FueAoy1amQuhC1jfWbfvRNidykurbOK9eHX1RlBW104RwKaODeaSb2WBJt0vqiLxYT2wEPDjS4qUKiUoqnyVzVxIF16qqKA36dUuYgGc/0Ne+M6Zl2zOsoDx4Wev8INwKRrvFjvlKoMwi3MH6B+d24QPxLYQgDFXfTTtKZTKweHfiiEsCsPCAFGShigbqlO60pGaECAzm17IDg0/gSQr9kFhMk3Kei5GMRtiZVihKhMDw4SAbI/8SnwfAe+LB7OtI5EnYEC8Jh1muULALrrhYLvrHh6SRXPVClYc29mOlrTgL8kAZequZhv5kge29i3RtFoR/SF43lA+Trf9k9IkUenfztbj3c/bc8DXsky1btM2jQ2IW5I97ITZolEv784ifwc9X6neW15gadJotiJ5LR7siQhjbMecIZ24vDPSY0hJNjI2UYFhxgPkNunaaC4S/7ASNiuVLKizcwvjQELa/jkgrXKr1XYwMQG88J6rjENr05l0++5s+cSunO/le+ObJm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3957.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(8936002)(4326008)(186003)(1076003)(6512007)(6486002)(55236004)(16526019)(6916009)(2616005)(8676002)(54906003)(6506007)(316002)(66946007)(66556008)(2906002)(52116002)(6666004)(478600001)(5660300002)(956004)(38350700002)(38100700002)(86362001)(83380400001)(44832011)(26005)(66476007)(36756003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qCMDNMP1MUjMN1wREOu/xulLDfPvLbmBi0uCmjBP5tB3TG1Sfgw6gT4fhc1N?=
 =?us-ascii?Q?OZ/B0PXu2c34r8MxQ6EDComnRW8qk6y1SnzWgPWb0UUxcMfuq7HFCWD8vED+?=
 =?us-ascii?Q?WOHJhXwQWBzx+hJwN03T79uSy8mRRE4BlZ11SMKCERTyWQw5/NkF4v/TtZrd?=
 =?us-ascii?Q?jBMZY+lTWpqwAv4pB8p25MzqBr+m7lMyF4W/tBR8kxBTLQTqE/Mz6ElpVRTI?=
 =?us-ascii?Q?4a5sh9sU5J5bjxGIHlcs+0fGZR3qctbgZPeGHB3vr/QaIyht3TwAApu/7zdp?=
 =?us-ascii?Q?6TAfgiVoL4L2XQH1l90kXroi06E7DWZNpfQrEvaxnYjfIiI6trTwJYMvKIEF?=
 =?us-ascii?Q?LXTLV42g5Oleq+gC/GNN5Ae4oRlR/7AHPaFycJ+mpt87gz4UDiRY7yCj/XeA?=
 =?us-ascii?Q?PJSuJ0nH3f3gKy7XhLV+607/utMSStOrrel/mmRwYSF9SLZrchsHjgq4yDY+?=
 =?us-ascii?Q?eLP26mCRqSt6twghs7DILvdi2QznoCsPTSsQFpRKB1EfGiMNtfE0Ks0RIrQS?=
 =?us-ascii?Q?ctJUIpQSTZPpvK1Ka5xhQJwSW29AUI3YPFbYduosPzWGSgXi99aKcslEcycl?=
 =?us-ascii?Q?Sr6GX42maAjuPNsLpyuP2wJCJv2KxzRloulsh3vHVxvqihXCgPINUHFKJ1vZ?=
 =?us-ascii?Q?a8E5ScgZ2SWEMRiI6fsefYhnFXYyLFrVsbN9u8648+b6O39RLeb4DI/UGXed?=
 =?us-ascii?Q?Ul4ia1foV2HmneznS4jgNI+Io7VulN04bADdwWvpXwttB+p47A53+k5ttUXM?=
 =?us-ascii?Q?A0wBeyUWn8In2BQz/4zT7dm6eKOSgEnUKC0Ej0cC7VEOfKvcFAl6pFwxAu9s?=
 =?us-ascii?Q?GwdZ8w5YqULPob9kk/EQHkdErgv8J4T+4Bbmuhg3aNqm/8+HFLKyMGsmpN9p?=
 =?us-ascii?Q?PCka0+EaOEiGo4yJcSXFRqFTxFzIspeEYLWYQebup+/eKdJBtaWII2dUXYhH?=
 =?us-ascii?Q?y2QDW7iL+7/0AkRnL4KExG2M0nRyPHL+ZQdX+iinIRtHsGchkCrlzgf9vIlG?=
 =?us-ascii?Q?R0XWk8G8bwChedAOK/yRESS0BD8rGnBK3Z8j17lNJsJN8ni5Fp5TLJRL6Ktt?=
 =?us-ascii?Q?F7QGg+88EPe6xeY9lQxxqT28T+HDb23LLU0Js5NMcTusuUWoytibZIA6aFCW?=
 =?us-ascii?Q?T6AfkTzCkG64+rdfAyIFL5efVgq8XVXJ3+XGVgJAuWOlXlu4MxvdXGgrZhnz?=
 =?us-ascii?Q?jl1RLr0Cr/zfl6dJybSRzGsg0OIreJfumrK4tPTHOQHqYw1+crz3OQFZR2L6?=
 =?us-ascii?Q?b1YyAOpnr6PQ4JHSwNVTkhNvNf/CsbzcI9rDI4qvyb9FI8mcrwbdCTJz3xWk?=
 =?us-ascii?Q?iFVQ6O76krZwiqX7a16RnLM6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 495455b4-04bc-42da-1b8a-08d91567d5d7
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3957.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 17:03:16.5393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pYQ7PnytPWPWq7MiMausAR++Ft1AQrBA8FdpjM8JWy8SxQn9dPBu6TBWSkY4D5ut
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3717
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
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c | 26 ++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
index 01fe60fedcbe..d481a33f4eaf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
@@ -363,19 +363,19 @@ static int amdgpu_ctx_query2(struct amdgpu_device *adev,
 		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_GUILTY;
 
 	/*query ue count*/
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
+	/* ras_counter = amdgpu_ras_query_error_count(adev, false); */
+	/* /\*ras counter is monotonic increasing*\/ */
+	/* if (ras_counter != ctx->ras_counter_ue) { */
+	/* 	out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_UE; */
+	/* 	ctx->ras_counter_ue = ras_counter; */
+	/* } */
+
+	/* /\*query ce count*\/ */
+	/* ras_counter = amdgpu_ras_query_error_count(adev, true); */
+	/* if (ras_counter != ctx->ras_counter_ce) { */
+	/* 	out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_CE; */
+	/* 	ctx->ras_counter_ce = ras_counter; */
+	/* } */
 
 	mutex_unlock(&mgr->lock);
 	return 0;
-- 
2.31.1.527.g2d677e5b15


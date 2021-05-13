Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D6037F29B
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 07:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhEMFeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 01:34:00 -0400
Received: from mail-co1nam11on2072.outbound.protection.outlook.com ([40.107.220.72]:7223
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229935AbhEMFeA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 01:34:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vx7Irvor5luMXM3LRW3j5csZ1RInkHLHQ2xwG5HZ0JmyftnOhgodo6Jljc+wo2DyWo80BZBcRtY5g9qiJRx1pk4HRoAv6VGe1Y8Tg16zy21WsYE7RkCZ53csZ4Y2k+sYQ3wNH7ImULSf2Fdyh+Fj/u+kkmWzIW99Izh3vYB9NX83XhXUXXEEqE9j9LZ4sAoZbTsaNeKBRwsToWLzp6H3X8bemprBwLu2UAz4qCid2xKoWVaDTS3pILVlj5Sjv32Bf2zMoe/e6VduZTfq9Lcv4U/2o1en+kAsVGcgsuxecgLRFmCMNse+SwocNETu4+XmFjI+aYnNkQ5nH9CtOF9+rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljhw8KX4Ym9l8Culm/0ZYEAjWJX3mwrKYdmBFozBQts=;
 b=dpbu6OFMaAo4g2AByDqTrhxZIKMTUBUrY9bpWwr/HGJoaYjNmaTzEDY17as9Q62nSmQknhM/yG2UbQ7e9+rzxULzRr5eeUDFy3IWHJDh8jevOl4IJAnoVR+4BB6bYWY/4sMkBEcLPLX4y+YgeE1lcgt6S4Ru1OOop3ik7W6VUve5jdKW4NeQWeULIoKZ+eB3maPzc4+Hs0ahqw8K4hN5T1W3m0DeIA8a5PqOtpuInVFQEGoBdKK9qRtWWXtPA97GN8xZoskgXEBpUTXgg6Zez9xMdZ38BLncw6TJTLgwRwVMc4/VbIquwAH1/9zxPprHyYxAy6qe6hMAbtQnpdl7ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljhw8KX4Ym9l8Culm/0ZYEAjWJX3mwrKYdmBFozBQts=;
 b=24YW1w4jCpCUK0h9p474etewmvqrrB3KEmXxsGVS4Ib9mtAu2x1hV644LMW8n3r0muVig9r+RtFBc0FOWNuAzlst++hp0PU6qo6FYyboZIcQtlhKsflf4brVJUfzfPZgv70iWexe+kekHzOvlCdLS2d+9XZd3eR+SCV4Mk1fPOE=
Authentication-Results: lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=none action=none
 header.from=amd.com;
Received: from DM6PR12MB3962.namprd12.prod.outlook.com (2603:10b6:5:1ce::21)
 by DM6PR12MB4748.namprd12.prod.outlook.com (2603:10b6:5:33::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Thu, 13 May
 2021 05:32:49 +0000
Received: from DM6PR12MB3962.namprd12.prod.outlook.com
 ([fe80::142:82e3:7e9d:55a0]) by DM6PR12MB3962.namprd12.prod.outlook.com
 ([fe80::142:82e3:7e9d:55a0%6]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 05:32:49 +0000
From:   Luben Tuikov <luben.tuikov@amd.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Luben Tuikov <luben.tuikov@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] drm/amdgpu: Don't query CE and UE errors
Date:   Thu, 13 May 2021 01:32:32 -0400
Message-Id: <20210513053233.116683-1-luben.tuikov@amd.com>
X-Mailer: git-send-email 2.31.1.527.g2d677e5b15
In-Reply-To: <MN2PR12MB448837F2FFA7B74AD3345C10F7529@MN2PR12MB4488.namprd12.prod.outlook.com>
References: <MN2PR12MB448837F2FFA7B74AD3345C10F7529@MN2PR12MB4488.namprd12.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [108.162.138.69]
X-ClientProxiedBy: YTOPR0101CA0023.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:15::36) To DM6PR12MB3962.namprd12.prod.outlook.com
 (2603:10b6:5:1ce::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (108.162.138.69) by YTOPR0101CA0023.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:15::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.31 via Frontend Transport; Thu, 13 May 2021 05:32:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bc996a3-ea73-4de3-c8a2-08d915d08bb0
X-MS-TrafficTypeDiagnostic: DM6PR12MB4748:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4748A04D96E49CA9E0C04FC899519@DM6PR12MB4748.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: di11ViX1GeHi7ccStS8kmMo/EQ0lYrHSDMGv5aIHfQNda4rzaHKGH4f3IuYKYnSF1+5dru1ULWz9Hc0aH8dvWR9Fpw+fQKuh9T65reGq+/iik57Vf3PG9Lmoq9jHKskbpgXEtM7D1vn8wz3YxBI5Ec5+2HeBbuG7hq1LAg3HIalIu4PA2oRee999Pg1OXgIW/jpGmJx9vfnAlubfJrmmxPZqu0NL7kO/eHqVbU+OVND2h7egHPCyXLX6erqxqOi9Ft7OSYbEa2+svstvK8ZraOA35Vr8NhE5zODJTKRcsAAFnzwz7hBPm4+VScIgpU9HgXl4csR8rVP6uk1g8++NWN6A0p3L7Tb6Ey7MT1Vmm1jKL8UQzkfEGJ3bu0CrZokPxKltBjyQFNC2D2z6Z0WdDAJXK3CWCv/f/vCUtd5zYHtPO1IWIJ/5eUGKih/Q5axDEs0I6gvPhX0uSbDvj5gMt1k5KShx5clSwqtGfOmSjMkW8rltcGYZaCbU7KpWMwbgqbbaEmCGRz5Y28cnxifNvDTJxjx0bHTwSiUVcmPeFyqcl9mdrB3my2kHFEX2WJXWpWPySDsbKvuKNMj0Z9PczkQEcuFGWnlUps6NdbxK9B2THjbeFqd9Yp5f38FeY0fwAq1gnaeFtzEoLs7dNGvE1SyiHc9OsygiCYTVZlKSrU1ikp/iHzn1Sf67IH71M8N9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3962.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(2906002)(44832011)(8676002)(54906003)(5660300002)(316002)(36756003)(16526019)(956004)(86362001)(38100700002)(2616005)(4326008)(38350700002)(8936002)(186003)(6666004)(66476007)(6512007)(83380400001)(6486002)(6916009)(478600001)(1076003)(52116002)(66556008)(66946007)(55236004)(26005)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ZvI5xlm2VSpF1lRv5y4H0W3QyZxt0c27B51BJYXfi5YNsI51c8br6N2RBG8z?=
 =?us-ascii?Q?uFuxBZgbs6uk1C0eCklyJjwkOGOAU/l+apcfZFktY673zKgKUEnOWbtdUCt7?=
 =?us-ascii?Q?4Xix7IV+8b5vo0KaWtkkDMWa2ZvCRp1Kz2bc18XIIow/h77iaNIDYvCNIaY4?=
 =?us-ascii?Q?k7S/AYpfctHoO3VBYkYAOfcDfts73Oe8ExYKZSldh0uvftP3HihB/AexjVkr?=
 =?us-ascii?Q?X0xh4tbK3+Wi1r7PljO1J63KpKwPwtC1huzf+hnXTMrms+DzhEJopBFNiTEh?=
 =?us-ascii?Q?SU0HniKTcCUMHS3mjeY32UA9nCnarSP9L5e74G7gMQyawXimvOxzNQ6jx8t2?=
 =?us-ascii?Q?QBZACkBNVpmX7KLKu3Y/lKneq+yoP7TntIKjHdxzI/VrJawZsF+Kz5mziFna?=
 =?us-ascii?Q?4xxCymSog8iNaNfDAKX+qVZJ3mfMxO2jut3Nk6sbAHruOTgA+vItzRejmxWe?=
 =?us-ascii?Q?qegtDnj8T9xZyXJ1YggjA4QXv02jOdgTjXZggFpDEswrJFQbWiAPdyb8haGw?=
 =?us-ascii?Q?hH8nXOyqRtvq/ClPiGkDLJNXW0OMROZW1VIjxiKlZ6g5Z1PS3AR1e1Gjqmpw?=
 =?us-ascii?Q?Sf1LiWW/JHl1P74WtJdXekzS8WJvLSB/uypYCsA7/kRS0Iut42MMRVv23han?=
 =?us-ascii?Q?Ig8oT2EvwQaMoz6QTgbG8HlkYYBJqU6kXxn/n5qXJUxH5HF0GGzNDsYnpK4S?=
 =?us-ascii?Q?smF0yo1IibuQN+0eZrOLhrXNXuHFKXKevSUgHLHHmoF24f/Ckq+2TL3wAdW8?=
 =?us-ascii?Q?EnVQFjdqmw/jfGwNO8IxVlochqh0VGT3eWMEDcgR5QvCsg8EOf3WMjkoLn2F?=
 =?us-ascii?Q?xJWs6dBtZKFIk+e5WpZy95be4h89hQ0Tiv1ISFIh3xu1sTtvUwFuHJhoIVl6?=
 =?us-ascii?Q?zlnJug2bA+6BfWx/9VZI/bLJqetjRgLEwtU/j2qn1ggG86LCuOHhnqN5q2dG?=
 =?us-ascii?Q?SgSHntPOY9L2XcJRv2dO8f0aR4KymC4t00TAztKZWwSaVvnlOVIhOoaXGS2S?=
 =?us-ascii?Q?6EOD4aBmcQnuul3rxFkq8SXuJc9Fh/Vq4ODPx3tkFT4LGM53696UejEHpynt?=
 =?us-ascii?Q?FSK8fYwJINObtvhF3ON/jHSHv7rBHdCK93sZNagOInZGq2ftzfqQBgzP5Mww?=
 =?us-ascii?Q?t3EwXF0Al2FGMo7yWOcFKMUfU7FX2ja1EtVEG24OdXzrBMO8z8h97ljkaoDK?=
 =?us-ascii?Q?9+05zsKKkWyu96/JVIRcmxLRJiJyCVpJsuIkxvW7vusDuuNf2OeFyEb3eujf?=
 =?us-ascii?Q?6ZKZvUVK2XvWuKeHo7KRU1eEM3FffzCA3lxYxJQQ9ZRe3Ml2szrqoWpibi7T?=
 =?us-ascii?Q?AsWlhqV0DLOaOJF0QfTw/FGa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc996a3-ea73-4de3-c8a2-08d915d08bb0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3962.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 05:32:49.3104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S1gADoYLN0dc+TUqKSVGjWPuEOBjrm+lbPYpXsTEHj7MM88pi9nInr9y0SSJPGtL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4748
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
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
index 01fe60fedcbe..e1557020c49d 100644
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


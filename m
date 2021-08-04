Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B3E3E061F
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 18:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhHDQpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 12:45:31 -0400
Received: from mail-dm6nam10on2072.outbound.protection.outlook.com ([40.107.93.72]:33249
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230021AbhHDQpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Aug 2021 12:45:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuKDGFBJO2JAl5WC9DmtmhdmvzlJkXP3M9ARbmJEfTv4xWEQ/PyUHzvEdjd+ysMHH625dNsfaaKyARMUSplRaFGIhx3+yZ9KTOKUmw+8lymPsiIEsYdbCmrcqE9zJ60tWSp0CWVsyvvmqaW+ZHIMryygf9dJbYHWKGMCud6WW/87O/+nz4PLrnY4zDfkXGenRyieoxlcB5AL07E4Hx/gRVylgnKVZ0KEPlQNQxxUMCckuD5zv9tNYFqCpqShi14Tq2PNXeptqua5f2aDKx66e+6qYugEg50uOO5uWw+t74mDwMWbkrxn8urgA+XcbdCaHjfupWhCLaLAGFyZq2H2rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=na6sWw0vvTzsycYFpr5KrBmTwujQw/8rdNXlzUlb5bU=;
 b=dZ+gP3romtCoZIblkq65+tIK4usK1rWNz+E5qpknByMjRHf7QVOAVDg2dUaWNeQ+SwmKLNoWkY3WZIJLBuCxHAUuAWxTK+IXelIQQt9HWasnPPCqkj9MNClQVh64MPkuMWS4j53WmXF5NFiLv5RN9G7VoRXPOn5+BfpzvoF4nVneXeVCoEZniUb+yTcLLDkwE5waMSwkvl4MeawbqQ32WyR37Pbm8Epj9rg2OiXpxpcZrEB8smRASDfVkiewkvDde4co/xyAeGqkECzduxH5V8OpThHh8t5jcE9h9bjoa0pjhr1c+u/FjGrpAv58LYjPhUGqaHMfH+Hf/q1Mz1TVFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=na6sWw0vvTzsycYFpr5KrBmTwujQw/8rdNXlzUlb5bU=;
 b=rA6ORdbUQNV5RdjcsLVfC19205jHmpVpDox18wvIdDescPxYu6fJZ6er9XEmcDhKkgB9IoSWSAPUl3I89v4ZbwYfYGJizZLIu/prxCM4yDRsStu3pA/CYalnQ5m97a/zrdk16VI3w0DB24FBvaHJsVrMAjcOEdg28LsvSDJeZC8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by BL1PR12MB5112.namprd12.prod.outlook.com (2603:10b6:208:316::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 4 Aug
 2021 16:45:16 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::5dfc:ea54:4a18:89f5]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::5dfc:ea54:4a18:89f5%4]) with mapi id 15.20.4394.017; Wed, 4 Aug 2021
 16:45:15 +0000
From:   Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     Stylon Wang <stylon.wang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [RESEND PATCH] drm/amd/display: Fix ASSR regression on embedded panels
Date:   Wed,  4 Aug 2021 12:44:43 -0400
Message-Id: <20210804164443.3279339-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:208:160::43) To BL1PR12MB5144.namprd12.prod.outlook.com
 (2603:10b6:208:316::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tr4.amd.com (165.204.84.11) by MN2PR13CA0030.namprd13.prod.outlook.com (2603:10b6:208:160::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.5 via Frontend Transport; Wed, 4 Aug 2021 16:45:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c41ee674-386e-40fb-f5f1-08d957673bd6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5112:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5112560B32652A348CC45176F7F19@BL1PR12MB5112.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nmq7sEgiXHjI+M4fRIxXnhhcPmhpahdvV3dFwVpHMDmHrUKKY4eDQEh6QTtoX4CcTtr4M3VROsGyZbHxA63/90bjJ1YkR0pYx+R/maapBLrqVJoSkYng2qbCP7DwiKvUW8c+ejq1Oy72Nk2xkb9EolagEA5qSowmjaY27xq2MMr2znBS8sKewjcB+8AE3wqgj8e3z+yoVTIxjC/pcqaVte9pQpWbK9GbsDH/s2OOa2iNgjFrIHF5B2PpT+g5WpWTsBCYthj+PtqOs8TxA3nCOdXu6IZMlpVmY3MkDQ4XzXKnkhGxcnjE7z/6TbzudDpQYs86TfDm4McbYYhL05WikcAOWFRCamf36qERJhd4/g8E153t2hInfdASkixTMM32nLEnrL7MypgttHzL5bC2hqnpHa66xQ49hWipOXqA2GZJIxgflOFhulJCJJdY3aSeEbKfv3N2/eX4v3WMVyADG0PJIHE8dM+ybjoDtTXOf7gd1MmdZnQ+Ap0TmRzOwLxArF7wHQcmMedGl9vHh0c59/ED7jtSAFX6sIzbwxsyowJQpXvyzo3DfpYuEb9yKNb8eetg9PZ7KNS3CqnfQGKBvQz3uZue3kNvv2gLgPCUa3f4JEckkKIz3OFi6o3wPZOTSAMqIJtnCG2/8gCOiIRpeg61PxjYKXA4XrwoeZgBYODpjAmftyYFAfTPtN6J/6CqbfcZ58FqMcrzwAp14k7+lIbVbjZwMPd35Jlu0u8q/EIqWFxndNFwDPMQNNQxhXKi2S0kmFyYighvHtjKSTRFRW5czzMthgrq6pxad3AyqEE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(86362001)(1076003)(83380400001)(2616005)(8676002)(26005)(7696005)(956004)(4326008)(6486002)(52116002)(66476007)(66556008)(36756003)(66946007)(6666004)(966005)(38100700002)(38350700002)(5660300002)(8936002)(508600001)(54906003)(2906002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZqQpBhV81e4c9FjE9DXRT1cSPpBjvuD5f24o3jvf1Np1U704odvq/It3NPcX?=
 =?us-ascii?Q?PWo+2osuXcw4g7z0u9R4lwmVM7iRZEnpT8W3WTO22EHVaTL9Rbcm525elnPT?=
 =?us-ascii?Q?Ea+MzmbWVNq1PAPmadWyahRfdsLHY3twJ1XFPj4iQe14TV9G0pNcgcfz0/OA?=
 =?us-ascii?Q?THVHBKpVSifISv3npRSeSxmOnjTXrTgc6l3Xq6+xKH/Y++MBSJzAhBCYXstB?=
 =?us-ascii?Q?yDwFuHro8pwCM1kqp9mBN8lgYK3bpzhavP7M+EmH1y2K3WMHhL38VRTbU7Vg?=
 =?us-ascii?Q?I5+9GBm1EBcze2CXg4K7JU7gbALweoBAC4ewqAgvXHkrXOSFoerr74T5QCyT?=
 =?us-ascii?Q?gVcHGS1yhRJJiTjZ+uN5JHPFsVpBl4I7HNHZYI0BLx7QaJl19gvvL0YBT7vL?=
 =?us-ascii?Q?aTrioax+VpH0NhM72FjVoyUOkbsLz11BeBDlJ3LKHEmDOzO+/ynTechddmUY?=
 =?us-ascii?Q?lF4jgTc3QuQZW0qD20vqpjtXl4Q89EmLgz8czouBJvuj7yiqQgZDySvAZYwO?=
 =?us-ascii?Q?IwGmbNGN4hOlcGKqv9qd9MEEOGHGf9JrSn0Q8PtATHa73GWtljuO26paWK2t?=
 =?us-ascii?Q?dGX/k6/CxF4TLdlHQDSN96XrnTiy59dV0mOkjhxQC+kfJHMDsIGhK/aWTEEf?=
 =?us-ascii?Q?C0Es8lzHxbQnbrvw67ok+1zHVw4TBIscPIKVo8kQonuYbHl6GeSd/5itiAhg?=
 =?us-ascii?Q?qnUfHLArXjO0NfrnYf1frnW/YhGc1E7TmSMI1Uxzk+iw4TyGgcaSq5VJBf/m?=
 =?us-ascii?Q?v50eqR8JPiwr03ThuQoyWGSkulHKI9ML+cI4vWd5ofSO2ebBlm4RzbIjyKAN?=
 =?us-ascii?Q?7M9qz/aroCX7kWSq+cINU3RNtXizpqYUWopeN4HMv15z1DMRdF3INdC1Ibzi?=
 =?us-ascii?Q?/mTFZhFl/7IMfvPDonOJro/ORx4Tjm8u7OXhp0CLR/HRCGQ3HnzfBQKdW1Cs?=
 =?us-ascii?Q?2p+2+Y6ETdlQJGJwsOpJMxiVD1iAFEbYEAD4eUk4jIyrh100Ete7edlPYGWg?=
 =?us-ascii?Q?pu75EXNAvOh5uSOOCxNR6ng+GakRO9uph7CJk5292rXp0xq6SXYbd391TUlp?=
 =?us-ascii?Q?DIvnubHzTID2EDcr6iS7Xg+8/GENVXP5IsXx6hI7k2UTtpTuB1cvhkAotX0n?=
 =?us-ascii?Q?+QVzFC8dp1HK4u3KaBy12B6rJ7ou1uIIPVs+oYdge3yc/9hg8rGzX2c9/zN6?=
 =?us-ascii?Q?4DMQwKP68DvDlja5cJ9Z670G1J9lnpkr96EyhKYNyF3kS0fLZY/JtBswzeDu?=
 =?us-ascii?Q?ftY0SMMMR3Iq+d6g2MjfRiDsuF1sKlegxZQ3Ry1oht2aZvYcCJyglwUKKls8?=
 =?us-ascii?Q?bVDVNEFYyAeYU0z0rQ+AznNj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c41ee674-386e-40fb-f5f1-08d957673bd6
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 16:45:14.8828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kR3uZcTQrh4LYRzkPzJcZktKwsCSV1RrpNoPd81TRAwgMUa0g6DgrXCCS+PdNl9k64UwAzn8o9DO9pEOeguL9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5112
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stylon Wang <stylon.wang@amd.com>

[Why]
Regression found in some embedded panels traces back to the earliest
upstreamed ASSR patch. The changed code flow are causing problems
with some panels.

[How]
- Change ASSR enabling code while preserving original code flow
  as much as possible
- Simplify the code on guarding with internal display flag

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=213779
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1620
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
(cherry picked from commit 6be50f5d83adc9541de3d5be26e968182b5ac150)
---

This is a backport of this patch to 5.13.  I originally sent this
out as a follow up to the reply that the original patch failed to
apply to 5.13, but it hasn't been applied yet.  Resending to make
sure it didn't get lost.

drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index ae6830ff1cf7..774e825e5aab 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1675,9 +1675,6 @@ static enum dp_panel_mode try_enable_assr(struct dc_stream_state *stream)
 	} else
 		panel_mode = DP_PANEL_MODE_DEFAULT;
 
-#else
-	/* turn off ASSR if the implementation is not compiled in */
-	panel_mode = DP_PANEL_MODE_DEFAULT;
 #endif
 	return panel_mode;
 }
-- 
2.31.1


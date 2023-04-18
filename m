Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE1F6E591F
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 08:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjDRGJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 02:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjDRGJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 02:09:37 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E8D4682
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 23:09:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HaNof7xxhLZZbDywPGEluetHaptzDuggM+aP2fmzurFYUWagcI2FomtNADT8ozmvuUW4uhE/GtxraTo8haaNuOzZlQ89CNYkslsD1SDWXHSVtxIz721WXuT1Nbq/QchcxLZS4fUF58K9PefrcSapADgJPExoyixx/o6dLzcSqY8TsqrE+FIxV4Jeq9W9Oi07RpH4ARfN+7PjBfc3/fEGge1uyj5pgCzB3NPJBXGg8GvoDspEYSA8skm3Uxi0mbfZjS65YePgc8VzXHnKEuudzOjZGIhzuBaAt46d1Kb3+1HVmNWX1C2jI8T4mU71L4FB7hio3JTo2m1INGZT+2QdkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2DxxzEqJJeg6OhCgPivSQApLe6bdKKtl/Edk/R9xvnM=;
 b=GejWL7HMC8EXHNidvcMXwiU/2MdA/mJkyggoYDbFkmhXW1bXSCdfLdseaZnuIHjm9EB0kRPoLGv/lRCunlcLtFvhDQqwiLpy/FX7mahc/VECpntIFPUQSOQnVx7vYiR+HsdAXduJvq+u2C2nzu0ewNOXVHeQOsgd27bH1SS7H/ETIpRxP96/2wTKeY0rO8lAJkuLNVBfrVAP92cqsj1u2aIyS7gYFK4kIKs3hpEPlPH28cWs1tK5lkw67lCZJVpvhdm8nkwkIef5UtP9kq7KRBIotBEYhZeaUBRRph6DuqxWB5C0mnYJJOXDOvCHHwHx/VIPeA9qPMvd4+vTRJMdNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2DxxzEqJJeg6OhCgPivSQApLe6bdKKtl/Edk/R9xvnM=;
 b=2GDSuMjVyfrTIgYTaWqBIEwQrrntL8x3vclBI9RhgevdtBDk4B/FrG0WE+Jgg4xqIXA0tnuHB/EXVlfvWZcrlP7M/XXoLLh8Mv9gIlvMXpwWQ0jqfw8LuvRcesB80YAdHMhNlnnpsv5rlhY+gGMr8FvLKVtp8bNyecIhXznkob0=
Received: from DS7PR03CA0041.namprd03.prod.outlook.com (2603:10b6:5:3b5::16)
 by IA0PR12MB7529.namprd12.prod.outlook.com (2603:10b6:208:441::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 06:09:31 +0000
Received: from DM6NAM11FT102.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::af) by DS7PR03CA0041.outlook.office365.com
 (2603:10b6:5:3b5::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.47 via Frontend
 Transport; Tue, 18 Apr 2023 06:09:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT102.mail.protection.outlook.com (10.13.173.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 06:09:30 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 18 Apr
 2023 01:09:25 -0500
Received: from wayne-dev-lnx.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 18 Apr 2023 01:09:22 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <dri-devel@lists.freedesktop.org>, <amd-gfx@lists.freedesktop.org>
CC:     <lyude@redhat.com>, <imre.deak@intel.com>, <jani.nikula@intel.com>,
        <ville.syrjala@linux.intel.com>, <harry.wentland@amd.com>,
        <jerry.zuo@amd.com>, Wayne Lin <Wayne.Lin@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] drm/dp_mst: Clear MSG_RDY flag before sending new message
Date:   Tue, 18 Apr 2023 14:09:05 +0800
Message-ID: <20230418060905.4078976-1-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT102:EE_|IA0PR12MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ba0c8c0-16aa-4f3d-9432-08db3fd37968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CyuAw7UX5yXL0oMmxfg9r0uF5Rg8lPfV2Mcb+btcyGbdTBko9SLQh71aosMyEu+bk4N3i/lj7C4mCBc+md4oEKzvx4pmyH1s4JdOPtCsxWM2GBZLuPsTN1EaVj0IQxZQM90SAdGQOgW5PoGkJvIkskrfyN59pM8tmN5flG8T61bTP0MhJuoFcoFoi1mnRP4yfEtkoLJXqhi+FF1jW03vtkJRmMMtLmkOKI7hf2L4ccl+ywD50x0fyrkl1ij3BG+PDtYwxM9idijRD9UhiTJ+UBBOiKxt7zl+Sw9J9c/t2VUMOFD5dKbmegYB8VRCS6y8xfwD61jhkjKil7kNBdBGAmV2sO8LxLt+FLVjvaSRh9iXvCy6lAxt1quuZmJwyKD9VlXZ2O0efbEMFYxJvcuY785MfMl6oNUHUKEm4NhtRfwq0TB3M5k9Y2CEdltdO9BuZaa+5zz99JMcbCSdgJz9o2qGdmu+j4z4fqyUxTuugc5u/cbEg9I2Bv1lja5K2hg7jjxHmEjYGr53hUqAODQkoCpvoc2THAU0InAAcGWAdKgybHga4vMySktFDwXCfVTWuVzk3J9sZZt6olfhYrq8k58nmUf+9slAjjuqyi5DzTHTiAfg4xwOeXGXteirjdKGalx+90ZgoV7ty4ou5t9NcUG99hgmF07fW331rfSXqfZI7DmmXGEKFtvkPCLGf4Vw+TnrSE3HLYhY9T65wwfQAi7QQSsTXIV6vmms8GfAd+Q=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199021)(36840700001)(40470700004)(46966006)(36756003)(8936002)(8676002)(40460700003)(5660300002)(2906002)(15650500001)(82310400005)(86362001)(40480700001)(478600001)(7696005)(6666004)(54906003)(110136005)(186003)(2616005)(36860700001)(1076003)(70586007)(70206006)(26005)(41300700001)(356005)(82740400003)(316002)(83380400001)(81166007)(4326008)(47076005)(426003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 06:09:30.9822
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba0c8c0-16aa-4f3d-9432-08db3fd37968
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT102.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7529
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Why & How]
The sequence for collecting down_reply/up_request from source
perspective should be:

Request_n->repeat (get partial reply of Request_n->clear message ready
flag to ack DPRX that the message is received) till all partial
replies for Request_n are received->new Request_n+1.

While assembling partial reply packets, reading out DPCD DOWN_REP
Sideband MSG buffer + clearing DOWN_REP_MSG_RDY flag should be
wrapped up as a complete operation for reading out a reply packet.
Kicking off a new request before clearing DOWN_REP_MSG_RDY flag might
be risky. e.g. If the reply of the new request has overwritten the
DPRX DOWN_REP Sideband MSG buffer before source writing ack to clear
DOWN_REP_MSG_RDY flag, source then unintentionally flushes the reply
for the new request. Should handle the up request in the same way.

In drm_dp_mst_hpd_irq(), we don't clear MSG_RDY flag before caliing
drm_dp_mst_kick_tx(). Fix that.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Cc: stable@vger.kernel.org
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  2 ++
 drivers/gpu/drm/display/drm_dp_mst_topology.c | 22 +++++++++++++++++++
 drivers/gpu/drm/i915/display/intel_dp.c       |  3 +++
 drivers/gpu/drm/nouveau/dispnv50/disp.c       |  2 ++
 4 files changed, 29 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 77277d90b6e2..5313a5656598 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3166,6 +3166,8 @@ static void dm_handle_mst_sideband_msg(struct amdgpu_dm_connector *aconnector)
 			for (retry = 0; retry < 3; retry++) {
 				uint8_t wret;
 
+				/* MSG_RDY ack is done in drm*/
+				esi[1] &= ~(DP_DOWN_REP_MSG_RDY | DP_UP_REQ_MSG_RDY);
 				wret = drm_dp_dpcd_write(
 					&aconnector->dm_dp_aux.aux,
 					dpcd_addr + 1,
diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 51a46689cda7..02aad713c67c 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -4054,6 +4054,9 @@ int drm_dp_mst_hpd_irq(struct drm_dp_mst_topology_mgr *mgr, u8 *esi, bool *handl
 {
 	int ret = 0;
 	int sc;
+	const int tosend = 1;
+	int retries = 0;
+	u8 buf = 0;
 	*handled = false;
 	sc = DP_GET_SINK_COUNT(esi[0]);
 
@@ -4072,6 +4075,25 @@ int drm_dp_mst_hpd_irq(struct drm_dp_mst_topology_mgr *mgr, u8 *esi, bool *handl
 		*handled = true;
 	}
 
+	if (*handled) {
+		buf = esi[1] & (DP_DOWN_REP_MSG_RDY | DP_UP_REQ_MSG_RDY);
+		do {
+			ret = drm_dp_dpcd_write(mgr->aux,
+						DP_DEVICE_SERVICE_IRQ_VECTOR_ESI0,
+						&buf,
+						tosend);
+
+			if (ret == tosend)
+				break;
+
+			retries++;
+		} while (retries < 5);
+
+		if (ret != tosend)
+			drm_dbg_kms(mgr->dev, "failed to write dpcd 0x%x\n",
+				    DP_DEVICE_SERVICE_IRQ_VECTOR_ESI0);
+	}
+
 	drm_dp_mst_kick_tx(mgr);
 	return ret;
 }
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index bf80f296a8fd..abec3de38b66 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3939,6 +3939,9 @@ intel_dp_check_mst_status(struct intel_dp *intel_dp)
 		if (!memchr_inv(ack, 0, sizeof(ack)))
 			break;
 
+		/* MSG_RDY ack is done in drm*/
+		ack[1] &= ~(DP_DOWN_REP_MSG_RDY | DP_UP_REQ_MSG_RDY);
+
 		if (!intel_dp_ack_sink_irq_esi(intel_dp, ack))
 			drm_dbg_kms(&i915->drm, "Failed to ack ESI\n");
 	}
diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index edcb2529b402..e905987104ed 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -1336,6 +1336,8 @@ nv50_mstm_service(struct nouveau_drm *drm,
 		if (!handled)
 			break;
 
+		/* MSG_RDY ack is done in drm*/
+		esi[1] &= ~(DP_DOWN_REP_MSG_RDY | DP_UP_REQ_MSG_RDY);
 		rc = drm_dp_dpcd_write(aux, DP_SINK_COUNT_ESI + 1, &esi[1],
 				       3);
 		if (rc != 3) {
-- 
2.37.3


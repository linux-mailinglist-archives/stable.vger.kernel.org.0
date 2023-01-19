Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D7267477C
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 00:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjASXwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 18:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjASXw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 18:52:29 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4D0A1018
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 15:52:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+0X5vhcPnMC8n3P1dRl323/cNg1tEYAVEZf+aFChlIWEl8viCymAivLmoTEvCDpcbmq9I5XOME287R6D2qoI4tD5OyUDDQuCqzQVA9bbhyNDmaMRGfzcODR5y18ScQfEJUfTzu7426IpDjSH7BIW/omxRGaq9Mi2JJKUSYtotzJzeqgcIYGVcJl9P1h4HKdvM6ILIlsfWfa6njR7c4qJPojLQLK8IjviYaBlutEy3AOB77z57vL1XdpfzNzr7QNVXptj/5p1yokiVva5Uy58ulyfqurjA2pXddcPmrQ8gSXWoQDAg7IrndSgxpmG/A19qDoyBnAaZw6/glXcV3PpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wBJIIN+ViafixL6W8vqbMM7fjXgIVlqKEuKPor4mVIU=;
 b=kHq8YI/PdbwUhgICG8Kjc1qAdmoPIaaO/fFuNB+OeZHSMgmGIuZHIC5bl8aeP6TLkyuXpgrun9SllTlyiHQsjIkNrhOQU1PzRv5zPzdHRmILNFhRCQICgU3+BthIrYV5UMCoFVf3AjnaCj4/W2gBAHt+yMGqP9xGBYxxsbVqzPW3KK6MJ7GI3tXgvzTaCoGbcPQbyPVVJtjvIaQ3RnZCNuKPszJQP2zECFmNExhL0+y4yW9E3pRB29yWb+bqKtXJ+Rd++c2XVmhQ1EIGwgOjY6MXDZws0IvoZ6sVuF5L5U2eQBBFwgDrGsKqjasZicefTaDCdC5xz+Y4e806RByzyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBJIIN+ViafixL6W8vqbMM7fjXgIVlqKEuKPor4mVIU=;
 b=EAuxYcRsj8Kx03QKsemkvPdytC1VnCfU4EavXjayssYLA7MSrJSzFpX831bj/lr7WDkPuJ4TS1yAX6VsCKTQCaq4kNGpI/ZMe3BSbeX3lHTCeGtteOT15yDivDlnrP8YxpqjYzWHoIWbc0bZ7PE14LbJX1nHQXTDOLBIca4zL6c=
Received: from DM6PR08CA0053.namprd08.prod.outlook.com (2603:10b6:5:1e0::27)
 by DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Thu, 19 Jan
 2023 23:52:17 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::bd) by DM6PR08CA0053.outlook.office365.com
 (2603:10b6:5:1e0::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27 via Frontend
 Transport; Thu, 19 Jan 2023 23:52:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 23:52:17 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 17:52:16 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 15:52:16 -0800
Received: from hwentlanryzen.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 19 Jan 2023 17:52:15 -0600
From:   Harry Wentland <harry.wentland@amd.com>
To:     <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>
CC:     <ville.syrjala@linux.intel.com>, <stanislav.lisovskiy@intel.com>,
        <bskeggs@redhat.com>, <jerry.zuo@amd.com>,
        <mario.limonciello@amd.com>, <lyude@redhat.com>,
        <stable@vger.kernel.org>, <Wayne.Lin@amd.com>,
        "Harry Wentland" <harry.wentland@amd.com>
Subject: [PATCH 5/7] drm/display/dp_mst: Correct the kref of port.
Date:   Thu, 19 Jan 2023 18:51:58 -0500
Message-ID: <20230119235200.441386-6-harry.wentland@amd.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119235200.441386-1-harry.wentland@amd.com>
References: <20230119235200.441386-1-harry.wentland@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT004:EE_|DS0PR12MB7771:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c19dd20-8099-4f52-490f-08dafa783248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T2zzTrS2DtP+vNSZTDW+cyCttOVIBqGOykL05OTdWcma7m6vcO/fr/FIV7KV9Bq8AasRwV23gVfpvSmH44L6mh9TlOt/kHN8ToLqs33VAJuPMPf6hNX51mvfUxLj6mj4QcROm7kQemyg1V2KSGBA1yqtaKh0riOTC/pxZN1vwshdJSLJgh5OsA3UB+oHt/zS62/+dOy0lqKx9u0OhVnNL4b8AG2VSoBNCRP57StjmUbGuyEDRGItYKqbIvxNlOA0WwXK7wbA9h0moJZd39QvhG+sWCqKFG4BeHiYAQ1vviHgYMOazUn18pPCNhSBO4nVq+gUa4zgYUui+jus3c3cjCKb8UG0SWyyz9HPMWDfrpSchmac4oUVMrIxrtjeidIAf9ermJakD1P5MLSkbK894UHItB80OCbbxgRQzG64U97aWjuYVk4xnDlPH74XH5a19KUzZICFMbmr5EHkuNATeKRxyuFkeu1IKIMDmkxlIrstVtPb2WLhKVoOuYgMMjchoWAUo4/sj3/ALVwCvVfzIB3GVkrS8u0ovtYm/psLS8DlrLXUHJDTcZITTyacu6tYijOYbaZbYUYwvDVAEVen04R6VnXkVxZ+Q85rhV/a96VfLesYDxlCrIGp8g+dder8nO4qZNNFjLtJIaCqQ77swm6Br2k6b+A0GoiRs+6qIIl5os3UwU1P8TGPBfLPCitc
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(82310400005)(356005)(6666004)(40480700001)(966005)(36860700001)(478600001)(7696005)(336012)(86362001)(2906002)(54906003)(82740400003)(1076003)(5660300002)(4326008)(2616005)(316002)(81166007)(70586007)(70206006)(8676002)(47076005)(83380400001)(44832011)(110136005)(40460700003)(426003)(41300700001)(8936002)(186003)(26005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 23:52:17.2182
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c19dd20-8099-4f52-490f-08dafa783248
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7771
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

[why & how]
We still need to refer to port while removing payload at commit_tail.
we should keep the kref till then to release.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Fixes: 4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")
Cc: stable@vger.kernel.org # 6.1
Acked-by: Harry Wentland <harry.wentland@amd.com>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 51a46689cda7..4ca37261584a 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3372,6 +3372,9 @@ void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
 
 	mgr->payload_count--;
 	mgr->next_start_slot -= payload->time_slots;
+
+	if (payload->delete)
+		drm_dp_mst_put_port_malloc(payload->port);
 }
 EXPORT_SYMBOL(drm_dp_remove_payload);
 
@@ -4327,7 +4330,6 @@ int drm_dp_atomic_release_time_slots(struct drm_atomic_state *state,
 
 	drm_dbg_atomic(mgr->dev, "[MST PORT:%p] TU %d -> 0\n", port, payload->time_slots);
 	if (!payload->delete) {
-		drm_dp_mst_put_port_malloc(port);
 		payload->pbn = 0;
 		payload->delete = true;
 		topology_state->payload_mask &= ~BIT(payload->vcpi - 1);
-- 
2.39.0


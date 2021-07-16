Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDB63CB34E
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbhGPHjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:39:15 -0400
Received: from mail-bn8nam12on2060.outbound.protection.outlook.com ([40.107.237.60]:1472
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236053AbhGPHjN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 03:39:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBaJdm4u5+z7rr+6qK5GoKofRrZ+HovK9HLgjUHsfNpeMxSgNcUthxC34yr2iU1nesC05klPAPjq2IS4tYjL46fdaGzhJ/fWGVT61QL1G3ERF4X1z4GGoruO5Y7uFvlm2lj197XbfqG4sza9WbE3fGqJyJhCwjkXoFJyoENN3TeaS23Nvt7lWe5nRhsvuPMPySHfTxajBezda8Jt4oVqYysrajgOSDN9OHueTP4I0KgRDDbwPeJSugt9tfGv7HEXaErISbhBl8jPTWewRoeogjzyPi1T5zCmFxOMdiwz0QGWL/alvVAoym97TmNe53J6U/UYbGLInuNSBLYUGAy1cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJVIrkB/79/ZMZfPQEJ/HRX2YUdRaOJLE0dfmcDfdK4=;
 b=c/KT/mcAqhaNOyKeN3qA73oewjMLVTDdXSQFy9MFaHNs5OJZs9wTQ0p52Y6Q7W2nEi2ocUclFXq7IdfgcrkshmwGJS6YUuq0mnHLmCHaP7XBgpuFNtnuL6hiJ7ziXaqCt5NzwAhMVxglUMpbC7ZR5kAiJ3m4YrIRVd5KhanNUmhpuHkA1k05D2ZNJ6l217ScW2hPsvDY9bawO3KeDclm2N24fwNF6qtjwc0lvDMplfOprbCjFTmvdTtY+PxZIF0MdD79GMDdJGz0bqMvSyYgoTH/1xRM78dufPp9zEVUFHNoEJlOJ96QaTuQf+6ItC3ViMoyKoHO7S59KyO0UeYKyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJVIrkB/79/ZMZfPQEJ/HRX2YUdRaOJLE0dfmcDfdK4=;
 b=qkUSohEu35PN9aMBnN4gbSqHKJzvtM8oVXCPv9Iqf9MHbvbQEy6AZnHOzo5FjKW6cQzw6O/A+tlz/RD0beWpd4tSTSw64UoaPqSe2nhDjYbisORGZ+3vTxaVQkRQQvFfD/EHLqOPm3Ndf045FBg08K5jyEZCzoDlBN4EEDkPRm8=
Received: from BN9PR03CA0846.namprd03.prod.outlook.com (2603:10b6:408:13d::11)
 by DM6PR12MB4745.namprd12.prod.outlook.com (2603:10b6:5:7b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Fri, 16 Jul
 2021 07:36:17 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::40) by BN9PR03CA0846.outlook.office365.com
 (2603:10b6:408:13d::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24 via Frontend
 Transport; Fri, 16 Jul 2021 07:36:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 07:36:17 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:36:17 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 16 Jul
 2021 02:36:16 -0500
Received: from wayne-System-Product-Name.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2242.4
 via Frontend Transport; Fri, 16 Jul 2021 02:36:15 -0500
From:   Wayne Lin <Wayne.Lin@amd.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     <lyude@redhat.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        <dri-devel@lists.freedesktop.org>
Subject: [PATCH 3/3] drm/dp_mst: Add missing drm parameters to recently added call to drm_dbg_kms()
Date:   Fri, 16 Jul 2021 15:34:50 +0800
Message-ID: <20210716073450.26497-4-Wayne.Lin@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716073450.26497-1-Wayne.Lin@amd.com>
References: <20210716073450.26497-1-Wayne.Lin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64607744-c9e8-420b-e443-08d9482c65df
X-MS-TrafficTypeDiagnostic: DM6PR12MB4745:
X-Microsoft-Antispam-PRVS: <DM6PR12MB47456331F5EF29C8E7567A47FC119@DM6PR12MB4745.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:127;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SJi3+rgKJCa3ehQAnYuKk0DgSjB+afDGnkwJxr2R9fFX/lDzvasKNM2Mj86BX7HrNRT00cM7MgwJMqSDXR+z3fUThVaCJPsF7eb3h7u6CqO02pLZd1ZVUaV287xF00D7KOQjd4GjLaSewzHt6NqvNm3TaKuWQglzjtgzAPN3iQ6CNzT66Fz0+6163ROA1QHZSlb8jINo1SFCpz4dRGuDHPLpm5BTmzFRxgl12eephcgxNpGcQ6ppC73tqRYhstND3gRxqBtCaAG7ocpqJ0IV9HjCzJVSo8simuTk2mgOo/mnhu69rmwNhqlv/U7YIPH2t8lyKHFpIQnyUFL8I2mysAcHq1pm7WmSObHcO64DKcbWMpE74RHrSyU8SV0FbDaq6yXb5AE7OLceO/uO9kwVBsMd1K3aRSGdK6pyYfwaxpQCkVKOjej2S8vTOlERIpaRCyyg1moOShGZq7XcgILd/FZJ4cPOMNMKCFnXPMj1CLlgOftZNU3sa+gdnztuKVy7EVBHsPTFsfAXThQj8OxP5vG1QTOPTNLibUrB/WOWDQtNjxplSTzuZrrRRasM0Dg7txx2PPV/0M6GuXGrYAJdmotpjvD5+gz90h+hBXbKc5v8K3vorWISNKJqmK3TTBvE8COSwaum7naSvx/JLI/uRng35/LJfcr6Slz3ibgGzUZf0B3ULIvnYchufH+urNCkQYW85ZNAGSOLooVQHx9g3lzWrR4mSZ6m/DZ7IeIQxog=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(5660300002)(8936002)(82310400003)(8676002)(86362001)(186003)(26005)(2906002)(83380400001)(2616005)(426003)(70206006)(70586007)(7696005)(336012)(4326008)(54906003)(1076003)(356005)(36860700001)(47076005)(81166007)(966005)(6666004)(478600001)(316002)(110136005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 07:36:17.4038
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64607744-c9e8-420b-e443-08d9482c65df
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4745
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Roberto de Souza <jose.souza@intel.com>

Commit 3769e4c0af5b ("drm/dp_mst: Avoid to mess up payload table by
ports in stale topology") added to calls to drm_dbg_kms() but it
missed the first parameter, the drm device breaking the build.

Fixes: 3769e4c0af5b ("drm/dp_mst: Avoid to mess up payload table by ports in stale topology")
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: stable@vger.kernel.org
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210616194415.36926-1-jose.souza@intel.com
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 01570f2549e1..861f16dfd1a3 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3385,7 +3385,9 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
 			mutex_unlock(&mgr->lock);
 
 			if (skip) {
-				drm_dbg_kms("Virtual channel %d is not in current topology\n", i);
+				drm_dbg_kms(mgr->dev,
+					    "Virtual channel %d is not in current topology\n",
+					    i);
 				continue;
 			}
 			/* Validated ports don't matter if we're releasing
@@ -3400,7 +3402,8 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
 						payload->start_slot = req_payload.start_slot;
 						continue;
 					} else {
-						drm_dbg_kms("Fail:set payload to invalid sink");
+						drm_dbg_kms(mgr->dev,
+							    "Fail:set payload to invalid sink");
 						mutex_unlock(&mgr->payload_lock);
 						return -EINVAL;
 					}
-- 
2.17.1


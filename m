Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8386D8705
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 21:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbjDETiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 15:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbjDETiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 15:38:05 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20625.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::625])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E82876B2
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 12:37:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgGgLvqREHhFNu7q40ySkvSOB/hAOOXDrY08jc9B4tTSZJLFuyIZqwVPfNspFqSICYSBSVOwltDi13ZjsAjdnq+mUnhzARY7LLf7CLKd5fwpBqht7ms7vE3I6C7kY39Cfsoy34jEsc4HOPYOqR5Hm+VTK3j+PsV/zSOkXSO8Jmrgjxt2IKmcwqmkwJV++xb9UzWsRCCOG3NfOAalNM5XWCU7any/uItS2Xrw8mXyRUzlIbun4JDoUofn/nKiMHZOCCdJaqXUFW/5zkntVioILswQpJP0qcHgbabnjCPN0KV+hGBCo2BKxDzftGneh9tu1oDblx6H8n6guEDPry4EoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFFPpd9611Mrwwg2+0KjLyxGGkhbMW3+DJ31qodyIRs=;
 b=QZm6ULxWdv/foXjt7z75KSfmcvwyBcEpTnyxfUx8sGObioRdgJdvoHri0AqrX9YUxNKYWo5Bz2DD9p6Lpjjg0LBTJjiRQf3be68MpBHffc/zeurE7bs/8iMIgNvsznnrpTFfDow4m90mrB+AWllzyMdrztD9G/4QHTYVCZ2wHL/3K23tlvvD2OOZlYjfrWKhr3Oqns/RbLNc6xo+MKjO6k3ePbSvcKVpHsEff0ePq6PXZt7NRKbKpeGDZG1xHHXLgHcWfnBFoYuUqwmtHVXxRiwOCA+McAHY6vakSSvlu6u2jY0p8iFiSKbVWKZA5DSxCEbxePSNIucl8nPS0hVVIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFFPpd9611Mrwwg2+0KjLyxGGkhbMW3+DJ31qodyIRs=;
 b=grgNLtISY9KMRvnVJmBopuNzaOitUPXPtgqWndBKkQnDS8HIep42ilUGSlezlEtXuOyliEf8B0Kz/g1RD+4KNRnoyYOL/yDVZd9PjXS6xzKeonLWx1bVSYJNd4mch3UElwo0LFKZbEEFJU+TAPxPt2IOHPuqnwYnINloYaVZVu0=
Received: from BN9PR03CA0455.namprd03.prod.outlook.com (2603:10b6:408:139::10)
 by DS0PR12MB6654.namprd12.prod.outlook.com (2603:10b6:8:d1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Wed, 5 Apr
 2023 19:37:20 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::d1) by BN9PR03CA0455.outlook.office365.com
 (2603:10b6:408:139::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30 via Frontend
 Transport; Wed, 5 Apr 2023 19:37:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.28 via Frontend Transport; Wed, 5 Apr 2023 19:37:19 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 5 Apr
 2023 14:37:18 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
Subject: [PATCH 6.1.y 2/2] drm/i915/dp_mst: Fix payload removal during output disabling
Date:   Wed, 5 Apr 2023 14:37:07 -0500
Message-ID: <20230405193707.8184-3-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230405193707.8184-1-mario.limonciello@amd.com>
References: <20230405193707.8184-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT044:EE_|DS0PR12MB6654:EE_
X-MS-Office365-Filtering-Correlation-Id: c97fd130-b547-4b6b-be21-08db360d2b8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sXwqKy7WBN+hvPYYecVqkaU66FsXVuIzZUdCxNaDDeuoo1A7pFKlXqekT6cH/wQsVUwQz+h7wOY3W3g/Wf58B+yc97z827ab2kAkpSVlr1LODJgEqY9MbF+SpkDNBcdmQ9P23+fREbhycTzf8F5RmwNbJlz3N5caHoJMLl1jZ4vfD2Orbo/C79Q8YqIVrDC03/bWSnecLXwAmfjrm+iK1uyV1M68mRzAaCaLAsIYrcldqjEmF1f1dmiy9OicWhutbGHHDR+lvESBNW3/4V8yjox+AWVAPC4PavkYGk8JrHz+OetmVzamFoeCAxIod9cBxIufEmldim0oYMHIAYOROy5TRX9nkWlbNptTFsFl5Sa1yvQqQQVGNrX0GBkcEaPvuuj81sjIkPMXpuIKwQctxSFXRYybqteFcbZoXld0VtzRn48rdWTzY8CqKiiKZyf2CKskt4o/EpMhxCIF46syp9fzG46KQzRTiW9hZyqO6aqcqXdcdDd903dKqA3Q0+mzEDtNYFzpu5FkdpXEHDIeebmi8+faUkPdeLLEL8MXrvGqXyRwXFTwHRZ1snq/uswioUYxbo5KmeFdori9EbBQW/PvoVEDKlWqTWME5+xeGAMlVOuAZnWLpzf4eprriymASEx2Q2s/ZeAzz2yZLZRHbOHGyjaUAkODb4Qm8jISA7LLTc4K3q7jQS9icKAWtsb2
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199021)(46966006)(40470700004)(36840700001)(2616005)(86362001)(82310400005)(2906002)(36756003)(40480700001)(47076005)(7696005)(966005)(336012)(426003)(83380400001)(186003)(16526019)(26005)(6666004)(1076003)(66574015)(36860700001)(478600001)(70586007)(8676002)(40460700003)(70206006)(6916009)(82740400003)(5660300002)(41300700001)(44832011)(81166007)(356005)(316002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 19:37:19.5838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c97fd130-b547-4b6b-be21-08db360d2b8e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6654
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

Use the correct old/new topology and payload states in
intel_mst_disable_dp(). So far drm_atomic_get_mst_topology_state() it
used returned either the old state, in case the state was added already
earlier during the atomic check phase or otherwise the new state (but
the latter could fail, which can't be handled in the enable/disable
hooks). After the first patch in the patchset, the state should always
get added already during the check phase, so here we can get the
old/new states without a failure.

drm_dp_remove_payload() should use time_slots from the old payload state
and vc_start_slot in the new one. It should update the new payload
states to reflect the sink's current payload table after the payload is
removed. Pass the new topology state and the old and new payload states
accordingly.

This also fixes a problem where the payload allocations for multiple MST
streams on the same link got inconsistent after a few commits, as
during payload removal the old instead of the new payload state got
updated, so the subsequent enabling sequence and commits used a stale
payload state.

v2: Constify the old payload state pointer. (Ville)

Cc: Lyude Paul <lyude@redhat.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org # 6.1
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Acked-by: Lyude Paul <lyude@redhat.com>
Acked-by: Daniel Vetter <daniel@ffwll.ch>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230206114856.2665066-4-imre.deak@intel.com
(cherry picked from commit eb50912ec931913e70640cecf75cb993fd26995f)
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index 256afff75b0a..9a6822256ddf 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -364,10 +364,14 @@ static void intel_mst_disable_dp(struct intel_atomic_state *state,
 	struct intel_dp *intel_dp = &dig_port->dp;
 	struct intel_connector *connector =
 		to_intel_connector(old_conn_state->connector);
-	struct drm_dp_mst_topology_state *mst_state =
-		drm_atomic_get_mst_topology_state(&state->base, &intel_dp->mst_mgr);
-	struct drm_dp_mst_atomic_payload *payload =
-		drm_atomic_get_mst_payload_state(mst_state, connector->port);
+	struct drm_dp_mst_topology_state *old_mst_state =
+		drm_atomic_get_old_mst_topology_state(&state->base, &intel_dp->mst_mgr);
+	struct drm_dp_mst_topology_state *new_mst_state =
+		drm_atomic_get_new_mst_topology_state(&state->base, &intel_dp->mst_mgr);
+	const struct drm_dp_mst_atomic_payload *old_payload =
+		drm_atomic_get_mst_payload_state(old_mst_state, connector->port);
+	struct drm_dp_mst_atomic_payload *new_payload =
+		drm_atomic_get_mst_payload_state(new_mst_state, connector->port);
 	struct drm_i915_private *i915 = to_i915(connector->base.dev);
 
 	drm_dbg_kms(&i915->drm, "active links %d\n",
@@ -375,8 +379,8 @@ static void intel_mst_disable_dp(struct intel_atomic_state *state,
 
 	intel_hdcp_disable(intel_mst->connector);
 
-	drm_dp_remove_payload(&intel_dp->mst_mgr, mst_state,
-			      payload, payload);
+	drm_dp_remove_payload(&intel_dp->mst_mgr, new_mst_state,
+			      old_payload, new_payload);
 
 	intel_audio_codec_disable(encoder, old_crtc_state, old_conn_state);
 }
-- 
2.34.1


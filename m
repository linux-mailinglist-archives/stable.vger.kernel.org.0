Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B357C694BA8
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjBMPvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjBMPvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:51:45 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4581C7C7
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:51:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EAbuf37OJTp+iIOF9U0ZBQUMjnTodRC+BlmVmEMShJmt8kPKEbaDwUnlTQ/Ux+/xJYp8EodbmVGyd1ycAcxHvyEYQJITP3fe1Wwk2riWddaeGcVrQ5XmE6C0XHNJ+bcnmocrVZvA89+9yVm9pzTYe3lej0UdblnOqJlgSXcstMuYqDO9fyWDuWDzDXZv0w8dZJaaZnPcn8DPXOHmqh5ZcNpUrFa3N18ShNQwoCTPWqK7hN+awYwx31LHXg8vtB181Vb1smDahTc/b1PhNxgex6hdLmzZzsF7BJPVwCL6mHwHQCZ3JDrIoGj3wipxzog9ge8Uy10nl43HrZeBgCKa1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6a23G1h9sRJte9on4JY9ZIVx+0MN++tE1xPhTiXqTE4=;
 b=hX8ZYHFCB8+ee20k2Vcp3PG8wOM4wbXw9+0vC0QLrRyoSIRdvwtCLO3fkyLNLj5Z+I/CJewXfmbW5lYT7ey45qkMJ2kl/doNAUYPUnM1qAxPmT9wvGBaAJKdGz6LtKGccjNcIum+1je/RievvV1ZbQ7GL287OZPRCHC1uqv+20NzegB8G6EZ30Srn3XsGjeqKASi+U9WK1CXeAeA7sCVND9d7KBKHbqhWb0UfxFdTT9zW03cYzQxLnpoHMkWL1DswYgwMGEBWHNvlINBe+jq2aH9QCSwztdQRSE460uhxS5xiv+QCjme+OB1bGHuwwE5rzdDhQiIfa1kucOrbY377w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6a23G1h9sRJte9on4JY9ZIVx+0MN++tE1xPhTiXqTE4=;
 b=rbZ9tPexrSx02y7nXnA2xjwV/Z3M+Ek5428uL2yH9jWVlICbOGEpriPudKJJlOSpZ82sw+MdUcOwi/di5Z6FtgmEzoh5yOjdD13id0+Jc+GzeHPWAOkiZhr6R19w0DCrXZhzKtYrPszQ1qkpFoHbyjA3i2T2WoSvSF94AnlBfSo=
Received: from MW2PR16CA0066.namprd16.prod.outlook.com (2603:10b6:907:1::43)
 by SA1PR12MB6869.namprd12.prod.outlook.com (2603:10b6:806:25d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 15:51:41 +0000
Received: from CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::db) by MW2PR16CA0066.outlook.office365.com
 (2603:10b6:907:1::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 15:51:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT103.mail.protection.outlook.com (10.13.174.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.23 via Frontend Transport; Mon, 13 Feb 2023 15:51:41 +0000
Received: from thonkpad.localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 09:51:40 -0600
From:   <sunpeng.li@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <harry.wentland@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <hamza.mahfooz@amd.com>, <stable@vger.kernel.org>,
        Leo Li <sunpeng.li@amd.com>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH] drm/amd/display: Fail atomic_check early on normalize_zpos error
Date:   Mon, 13 Feb 2023 10:51:26 -0500
Message-ID: <20230213155126.29435-1-sunpeng.li@amd.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT103:EE_|SA1PR12MB6869:EE_
X-MS-Office365-Filtering-Correlation-Id: 941d8e85-c232-4d66-9eb4-08db0dda3304
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IdYjAart3rB2KcJS2prEYCJqlNiREhekOYZcig7dXSBRiCoo6QEXK31ibEErioXvsTP5+FMYtnClaHGkWszyIZoAWAxn1PmaDKEZcMq2TR1efG8WEA/NAcHvnX2BfEzbbVu1ED4j/FhJ5bUDdRux3P16/u7zojURo7dmH+Ez5yRSleVy2WbDjHwo1SLQJlVfBah+zCbCcQdDam6hn+rZ3Vo3LuB7UOh1MNgBtfWEr6OsgrUWTugHiPowyJP88StltGweYon2id+PllODDulJCSkAtma/Ky0iAHNyFQYRYdnOuCXrVk2tTTADTjziZ1gjPdZn5cxhrVnlQx8utFi59BqIay4eQblfzMxo9x/BPed43/0vSDpJdX97+Bpo+dJpTTj5VIl2fHbJXuNsWg+vrSjYOwY6vBGhfdCNNBR4Ge7k6yRDZZQ6HxbbuFKaPbpcPTCysY/zpI6aRMpKZKDFkH4B/IXG555CmdxrDYcOqDRrXaaUk86RCN5TMqszEOQVplPMpvzWll34xyGW1z5w1GOg8zsbC+yGRi2vDy1rkVS2J7K6vXsHkBkqozt41lA/Cdb7OPCO7wv6AbxHDyjXBgj7IPc3zdbDHWZRQqlbaDe+zhzzvDlwQtBVAQcRzhhetLYlUQ2uWOmFJ2qBEBn3nyinSBD7EFcOYQ6nQDTAI/wsLlplvVFrosNUDRe7KGfX0mi61IDUP3MuSAjrO2z0US7ThmQt0f+N3UNIXpdbOQ0eSrw1IFGyk0/QegQ7HGgBarjfq5kRLyGC5E+eieNSjqvWXBaaYd/yjwhecZuWBa8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199018)(36840700001)(40470700004)(46966006)(26005)(54906003)(16526019)(1076003)(186003)(478600001)(8936002)(6666004)(41300700001)(2906002)(2876002)(5660300002)(316002)(70586007)(8676002)(70206006)(82740400003)(82310400005)(81166007)(4326008)(36756003)(40480700001)(86362001)(47076005)(40460700003)(6916009)(426003)(2616005)(356005)(336012)(36860700001)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 15:51:41.1623
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 941d8e85-c232-4d66-9eb4-08db0dda3304
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6869
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Li <sunpeng.li@amd.com>

[Why]

drm_atomic_normalize_zpos() can return an error code when there's
modeset lock contention. This was being ignored.

[How]

Bail out of atomic check if normalize_zpos() returns an error.

Fixes: b261509952bc ("drm/amd/display: Fix double cursor on non-video RGB MPO")
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index c10982f841f98..cb2a57503000d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9889,7 +9889,11 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	 * `dcn10_can_pipe_disable_cursor`). By now, all modified planes are in
 	 * atomic state, so call drm helper to normalize zpos.
 	 */
-	drm_atomic_normalize_zpos(dev, state);
+	ret = drm_atomic_normalize_zpos(dev, state);
+	if (ret) {
+		drm_dbg(dev, "drm_atomic_normalize_zpos() failed\n");
+		goto fail;
+	}
 
 	/* Remove exiting planes if they are modified */
 	for_each_oldnew_plane_in_state_reverse(state, plane, old_plane_state, new_plane_state, i) {
-- 
2.39.1


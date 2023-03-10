Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866C66B3AAF
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 10:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjCJJgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 04:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjCJJgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 04:36:08 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC42DABB9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 01:33:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkkclVVi7ldq33qkUBEM1B42uynYM6zI21BmYrFvyixdw0+Bq+lxwIWWSj3HWEicXsYkFSIieuujlH+4T26bsj4dZiz/NoEr4jPynagjfMQpZaNhuMPvbM2uIonXtODVF+Rm1X6XT1EkUsSolx82OolDjIU8shjXkyFM5pBpqJ1WRmyssrHPQuFG8R/eOZ3dKVn00HQsEgek05hABbYGazjQ3qURmqLXrkdpYGIACUkdyxTZ1+tp2WsxKyKxrVlXtPRBzEmg0qMdoEmYTkjUvHqk/7I58fRQdmEoajsWfA0zbfq53urDts9W/oXfLgya2vJyCyTT6D9MXzy2UoVGgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UP+JfKQbYCxyqhh5cRsBmWljeOdwiY0YpWHIa75A10E=;
 b=Jn1dfB2IzPKCF4TwBoUMinEGYi/Qzk5wnp/CVjAqnXb3Ls6fHFs+A+TL8nfr0ZPZbf10VWzvysllTZYcQ3KoTYpxvdNttdEPIoQYGjpd8oglpGVr6EpaZgBsqIOGibMDJno1aps0S6Ck4GMY231XxlobTX0ZLzduvuaqfovR3nhqWubxp2NwV7yPktYQ10uGfvRqtsYVnGDUAeK5QUnLl3tjvNs2pGZGqOpMOEzcmqz2JAIV661AqwFNeI7Rmn3gzE/vT8JDxpH1FlBqNBMRAbwd3PmGbySTvuHYj/d+Hcq+vQFwcEDdHiRnKx+Gi7xZ9j7n/bevGP65MfWbSStsig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UP+JfKQbYCxyqhh5cRsBmWljeOdwiY0YpWHIa75A10E=;
 b=VcLlzhAVOmM3zpwuMea2n5GE7SbmMRqffn+rwmwuQHgDj7VnMpBbfZP4VF0s9zvvJ2n5gBWNGPKWy0GT1pK+ce6rI/oivwgSSgIh7nfrV43DL0SgBU/9gAfPVfoJGy1Ggmu+UCipvIkV1VqOpiq2vabvY2XpmpnAfv40g2e2EqQ=
Received: from CYZPR19CA0013.namprd19.prod.outlook.com (2603:10b6:930:8e::23)
 by SN7PR12MB7911.namprd12.prod.outlook.com (2603:10b6:806:32a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 09:32:43 +0000
Received: from CY4PEPF0000C97B.namprd02.prod.outlook.com
 (2603:10b6:930:8e:cafe::ee) by CYZPR19CA0013.outlook.office365.com
 (2603:10b6:930:8e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20 via Frontend
 Transport; Fri, 10 Mar 2023 09:32:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C97B.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.13 via Frontend Transport; Fri, 10 Mar 2023 09:32:43 +0000
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Mar
 2023 03:32:37 -0600
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>,
        Wesley Chalmers <Wesley.Chalmers@amd.com>,
        <stable@vger.kernel.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Jun Lei <Jun.Lei@amd.com>
Subject: [PATCH 10/19] drm/amd/display: Do not set DRR on pipe Commit
Date:   Fri, 10 Mar 2023 04:31:08 -0500
Message-ID: <20230310093117.3030-11-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310093117.3030-1-qingqing.zhuo@amd.com>
References: <20230310093117.3030-1-qingqing.zhuo@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C97B:EE_|SN7PR12MB7911:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c084852-9e5f-457b-57cf-08db214a66b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IqOeKQldsZ3TF4iJkr2sFUEaY0mFCE4ByQ7UdSoib1JV3FCG25ZfcfpXZkKLnBXSpo/VB+U6nunsrT58/PhKsaXQ6VC1VgI+EI0UvsQk4oSdfUSnM2tBzSVaOoNSJD/ob6xwZwTyz72t2ffp5RSSlZommXLDwtQ87QvUgrBU+y0Gc83DchlaJ3m5X55oJWqpHC9qrXr0G4e5BqOOCInKyrrp6dQLPIAxE5OQRDvJADYZyOiAPfKtFez8TYPSZ8xSmbRq/eeqUDe5Y62Drvma5LfDrvyuEVlpk6FA//cui5pFC3slw19OeU13IBHiLiCj7uDHuzwdoLunbnTc63CwoCnCKWq3T6tHQJAkTYujiqQAzve8UomZve86RLXmNLVpwAV9uXkohJYHrID3pdgFGZdKaamm/OkVVSiXnq2iGSFtC1AaYkChuiGun/U2PX6zoZOwOnAzrb3U9+rirdjw430B/1mhBxaxtQtS2P5l3H1ZMvxLa8bGVCEQvou8B5DB0nT3/4oNEkv3HBS86mR1JILMS/9MYZawCRpPzagdSYHjmS3V/6Lm6FJ4+Ntvo6h2/7XJvgRvmtEd9NgUvlQg+FcThIFS7mjGryDcy5ZRMCGEtdriXLZBxDV2IatdwZ1p0HRww1n67hfwo2ji6tR78iovNPCG52I8Jnxxn189XB+xVcvQ/v+hLVdIJKnKVcxd1KwnsLE2nlICgTJj1or8wIYmURCWdD9ZexkQn0nr6ro=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199018)(36840700001)(40470700004)(46966006)(81166007)(316002)(82740400003)(2906002)(83380400001)(36756003)(40460700003)(44832011)(5660300002)(6916009)(70206006)(70586007)(8936002)(478600001)(8676002)(4326008)(356005)(36860700001)(41300700001)(86362001)(54906003)(47076005)(40480700001)(82310400005)(426003)(2616005)(336012)(186003)(16526019)(1076003)(26005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 09:32:43.6354
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c084852-9e5f-457b-57cf-08db214a66b4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C97B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Chalmers <Wesley.Chalmers@amd.com>

[WHY]
Writing to DRR registers such as OTG_V_TOTAL_MIN on the same frame as a
pipe commit can cause underflow.

Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
index 586de81fc2da..6d328b7e07a8 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -990,8 +990,5 @@ void dcn30_prepare_bandwidth(struct dc *dc,
 			dc->clk_mgr->funcs->set_max_memclk(dc->clk_mgr, dc->clk_mgr->bw_params->clk_table.entries[dc->clk_mgr->bw_params->clk_table.num_entries - 1].memclk_mhz);
 
 	dcn20_prepare_bandwidth(dc, context);
-
-	dc_dmub_srv_p_state_delegate(dc,
-		context->bw_ctx.bw.dcn.clk.fw_based_mclk_switching, context);
 }
 
-- 
2.34.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E2B6B3AA9
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 10:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjCJJgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 04:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjCJJfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 04:35:50 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A982A15561
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 01:32:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPyMvZn0YgrlrKFwccxEGwOormEsfZjZ+qLwEoAuuzHxWpOZZi+VEg7D+BMZoN74g9xonlnht8UKnSkUe5aIsMVOdFNUuCde+xf4qGvKHa6KLXwG9aa6sLOg4mtZK1nrBi4QPL8O1cyW23Q7NPjyGQqJmw1Ni2qkwsI3WE089z1FyWI4Yzs2nkhvH4wJyaHUESOW1Ay96glbVwYuf0LG4rme/wkrt9gyo0Cno7Mw2Ngq2x2YRBKKmdj4ZJyReBdsUmNONxRhCYC9UzgeYy26/3r8d3GExr7QAoRgFBEhbUqpFE9xZzhplGu/OVMmx28O6eHyJLS2sbWsDkhMGLGEGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B4lhSZzdNQOVvI0RKlz2yYGXJg1czLUF3a8ag6WML8A=;
 b=j7VXm8WkUcLtiw5ljTCXsFPcyhvqjq4gy7jPbUeQhiKx0RATcC/zNieR2RibfL75s7gp1TgwEiX34jGBp0x/AU362CsYYPXiS8+u4SD9ym94P0HcngoSzZaKynp17H+Jo93he0VvIzTRYo2ZdmC1GDolX1065zNnMNSqY0RbbmaT2IjsUndJ7c9NyyAxPMlGhzXfjDrNIInxr3mVZnzxzaoPtlnlcpapbH46TCeytgXLgphdCEJgB8lUKKatJs5pQc7BJ1YTAYfZTnRF6LiZ1Vr6421LmKYJlhHKHOF3lFEtazjj0JFSH9SyJfREhH2axE7ctGzuwAOawZLQKUu6Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4lhSZzdNQOVvI0RKlz2yYGXJg1czLUF3a8ag6WML8A=;
 b=4lZGKIqG6JfHSa/mw/EJrYS5ZF6Qim4v0ce6v/yrSlaahhu5sUkd2HxE1IQwKMP/nx3joqc9KakpWmVPwqyqdt55SnyyleatWlcoxbID1Tj6os6G68gSOKvTR5RDb3iYQtlEXNRxWHDJbM+vQ+pSKLQahCNYtX3ibaquIq1Sw4k=
Received: from DM6PR12CA0033.namprd12.prod.outlook.com (2603:10b6:5:1c0::46)
 by SN7PR12MB6862.namprd12.prod.outlook.com (2603:10b6:806:265::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 09:32:26 +0000
Received: from CY4PEPF0000C979.namprd02.prod.outlook.com
 (2603:10b6:5:1c0:cafe::5c) by DM6PR12CA0033.outlook.office365.com
 (2603:10b6:5:1c0::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19 via Frontend
 Transport; Fri, 10 Mar 2023 09:32:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C979.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.13 via Frontend Transport; Fri, 10 Mar 2023 09:32:26 +0000
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Mar
 2023 03:32:19 -0600
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>, Saaem Rizvi <SyedSaaem.Rizvi@amd.com>,
        <stable@vger.kernel.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Samson Tam <Samson.Tam@amd.com>, Alvin Lee <Alvin.Lee2@amd.com>
Subject: [PATCH 07/19] drm/amd/display: Remove OTG DIV register write for Virtual signals.
Date:   Fri, 10 Mar 2023 04:31:05 -0500
Message-ID: <20230310093117.3030-8-qingqing.zhuo@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C979:EE_|SN7PR12MB6862:EE_
X-MS-Office365-Filtering-Correlation-Id: 103d328e-0e86-464e-6fb1-08db214a5c38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dJTQuVmFFlfmhyoRzjrMlDJqgpzEcQERuX4+0uS9TG16SdpPEEosl1p4ByYlS2DEA7gHmS8WwYR3NTeMbedUQkkC2mltrLvWXseedg0ho7vtTU6AgYAXvnnUjyudsqbmggUdVdcTLY4MWiPbkSGhnlF7kUOJDiDU7b9P+W6WhyXOJqU3/rlig0JG0gKktVk3w8v8/MPqjjuXix2B+fyXqozKMjx1zpRDe75LEZjmlm7JJqVx1XIKmh5G+5RkmXjJpwnnH109AtTXz0NSGxphmojp8/ZRTU4nprwpGQSsgz5GVM9Q5brpJXgEZoYLFSe6tH030/GlUF9eNnM0/DmXm+/paPJr4RG5qxk5fQASnEX2/Okav3vhOzq8YwtoftLFYB5JpGB3Nh/j/IZWO5C852LH2rWQFH7EbNnJgb9nibkdOB2D9WHUa8VnW3+btPOtT7Wo0E/3wKqI8GsIH0P7Rq+H0A/5V+J+YLCVOWT1WeiBsufaAeFPVPhd0ny7Yb0vXqHYUekrBYyWplEXZ+Q+4oRTbF0uzMIktybp/NV5K08Q1oU37KpXRg+oNCI7jcb0y8ahq9tX2Nrhgw1MK0hgDkFTIIrMkKoE7HNoT241At+9oSZ2HJb4wMBGHyZtrJqze4THgnGDZmSfT7o/NDgKxugqI/3OVwmWK8Ht9GolPYpSdjq8PR5rBlyB1PWJPICkMMPMrNxv3ojESwj1cYVbQNh5YcDJnnitvEgeTvtuWv0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199018)(40470700004)(36840700001)(46966006)(8936002)(36756003)(5660300002)(26005)(1076003)(82740400003)(6666004)(36860700001)(82310400005)(336012)(83380400001)(47076005)(426003)(81166007)(186003)(16526019)(2616005)(8676002)(86362001)(54906003)(316002)(41300700001)(4326008)(70586007)(70206006)(6916009)(40460700003)(356005)(40480700001)(478600001)(2906002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 09:32:26.0618
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 103d328e-0e86-464e-6fb1-08db214a5c38
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C979.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6862
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saaem Rizvi <SyedSaaem.Rizvi@amd.com>

[WHY]
Hot plugging and then hot unplugging leads to k1 and k2 values to
change, as signal is detected as a virtual signal on hot unplug. Writing
these values to OTG_PIXEL_RATE_DIV register might cause primary display
to blank (known hw bug).

[HOW]
No longer write k1 and k2 values to register if signal is virtual, we
have safe guards in place in the case that k1 and k2 is unassigned so
that an unknown value is not written to the register either.

Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Samson Tam <Samson.Tam@amd.com>
Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Saaem Rizvi <SyedSaaem.Rizvi@amd.com>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
index 5016b1313f3d..f9073b722b36 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -1111,7 +1111,7 @@ unsigned int dcn32_calculate_dccg_k1_k2_values(struct pipe_ctx *pipe_ctx, unsign
 			*k2_div = PIXEL_RATE_DIV_BY_2;
 		else
 			*k2_div = PIXEL_RATE_DIV_BY_4;
-	} else if (dc_is_dp_signal(stream->signal) || dc_is_virtual_signal(stream->signal)) {
+	} else if (dc_is_dp_signal(stream->signal)) {
 		if (two_pix_per_container) {
 			*k1_div = PIXEL_RATE_DIV_BY_1;
 			*k2_div = PIXEL_RATE_DIV_BY_2;
-- 
2.34.1


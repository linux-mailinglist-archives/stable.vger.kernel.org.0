Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C780674779
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 00:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjASXw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 18:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjASXwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 18:52:20 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28575A1003
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 15:52:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZNMKrFTu7aVFKOo/yrZGFxdEoKjXOMcRjX6m57DQzqHct75/InhjTjiPNUkiOipjTgUY3458611lXOm2hCuDhH6PbhkAAgBp48leKS9NgstQPie/urasfmXrhA+rgSGlDCElcIJAKSyxP1FB2UN5TMX3J8LQxhmrIiK0UwCizeuOBYApJOGMfTQHmUP4Va8Hc2MwWK698RjUwC7YaEAehFS4rO36gHPXeKQ7Od0fWKYhE8v1YzOQALWiIsN7y8hbgHf/PooKvX4G6WgujmYxilCyDg1j1mETyIvn3TtT6GnGUU0UbgpkMc8Vbx2wdLunuUNXFCGvhF6/ki/qS6U3fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xD4akn4f20opSNNCfMaYiR58ztotSKxidyfgW/fFj3c=;
 b=WK/kT9m8JHkWHuc8KS2DHN/v2EXvWFDHLkMbgOcPZj1jgs9DG0rHXy+gKBLMy+x1keGMeuylndVR/IHAVhvQVWlJ1B5NGA3+nRl+sDaP5J31Slka0YNj13VVlBXcwVWM3eAfaRYEz/q2R25PTrvZIEeTfjqIR9R7gnGf4HOIUniRiYp1znBp79o1nVsz1Uqqjj5WcEJnj9c3jgHqxgui/PlPoHuk1uXTWwPKc9EPQd/oiNPbrG/2MZpn8W91FMglRYai9yBkNGMrdTxtVaL+HWf9VP7/iBUqfDwg2eQTNoS1zEO6zL3KplYY5BjgVSRZygx23g9F55Q3Mgi6XV5pLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xD4akn4f20opSNNCfMaYiR58ztotSKxidyfgW/fFj3c=;
 b=opF2UVLVculpXMhhk7CbuZHwjRuKiiSFRHPlQqjubrqutTLpxq6qVs4L7ymSqWRRoG6SJ2DVyM5iZyP4tbsf+28+QUbcOPZN/Dj0oXWaYiOt2X1+gcPwJIbtfMwWcfKXo9fHNuFSl1ninpwvo0C4zcKTeOh2/r+yBQKAF2+xY9M=
Received: from DM6PR17CA0022.namprd17.prod.outlook.com (2603:10b6:5:1b3::35)
 by CY5PR12MB6059.namprd12.prod.outlook.com (2603:10b6:930:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 23:52:16 +0000
Received: from DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::28) by DM6PR17CA0022.outlook.office365.com
 (2603:10b6:5:1b3::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 23:52:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT078.mail.protection.outlook.com (10.13.173.183) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 23:52:15 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 17:52:15 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 15:52:15 -0800
Received: from hwentlanryzen.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 19 Jan 2023 17:52:14 -0600
From:   Harry Wentland <harry.wentland@amd.com>
To:     <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>
CC:     <ville.syrjala@linux.intel.com>, <stanislav.lisovskiy@intel.com>,
        <bskeggs@redhat.com>, <jerry.zuo@amd.com>,
        <mario.limonciello@amd.com>, <lyude@redhat.com>,
        <stable@vger.kernel.org>, <Wayne.Lin@amd.com>,
        "Harry Wentland" <harry.wentland@amd.com>
Subject: [PATCH 4/7] drm/drm_print: correct format problem
Date:   Thu, 19 Jan 2023 18:51:57 -0500
Message-ID: <20230119235200.441386-5-harry.wentland@amd.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119235200.441386-1-harry.wentland@amd.com>
References: <20230119235200.441386-1-harry.wentland@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT078:EE_|CY5PR12MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: 100d5cf1-686b-4770-8bc3-08dafa783181
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LBX93zYZlJL0tw9CIftEHoSrBGtXkwzgTI3ynJaY7Q/jmzotQIFpxsxhETCG1TcWbCg2Uy88BWuMVCDXN6fpPyScAA3GiVm5fBiES88apNistFHG+/4o4kI416DciuIaQ69XX9JK7FSnu/drniXOqtXFJG2MvTr0iqEu4GwPxmzSxmS3jXVlRZGP2GcGfAG8dn8SPaH7xryjxeMSK6EiLYA56gCLNSRDAQ7m9HnmSdD7sslQ5kB1HilUBcrZ7eM52xHn/SKmExHGOQ0p+sUWQ0jd06l1ZGTrO75reoaB1VOEr8ED3qa7khmfL55iV+EFO79j+S3hpTkTo7oLvE+ZfgMbZPB676OChsWgFe9DLM8FnmOJY1BKYZhk0VRK1/m09I6K0kpDANMIMCWBHy/3/+Ztl0LUb3FCvE6kMlGioWPwUgBdvJIfIieps6+XGYvW6igp7DRgtLOCdTMk0z0W8jhbUeJu52ncPIqQF2ynFpMFwgJNDqgtCIzMvUWq4Aq/15Z1uws2u2ZMhnhEMn79AinDOhZEChPyl+dQL4jjNjDXWoHFBArjl4R3Wz3ZY6ioydYDfjLy5f6c4lRnRSizrLYJXfakZeratJDWosllyCAWO2UA+QeEuuQ1bmH/AWscquWGgzS9l0XlmeuiXAqaNIpsvRoY4x2kDMTlLGHFHbgtcVwA67z1tu3LknK0/fPqocEwJTBkTWro90B2UVsJuq90vh+5yvkBopCkabJ9CL4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(346002)(136003)(451199015)(40470700004)(46966006)(36840700001)(82740400003)(70206006)(44832011)(356005)(2906002)(5660300002)(81166007)(4744005)(70586007)(36860700001)(8936002)(8676002)(1076003)(40480700001)(4326008)(41300700001)(2616005)(40460700003)(26005)(82310400005)(336012)(186003)(83380400001)(7696005)(426003)(54906003)(6666004)(110136005)(47076005)(478600001)(36756003)(86362001)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 23:52:15.9158
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 100d5cf1-686b-4770-8bc3-08dafa783181
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6059
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
__drm_dbg() parameter set format is wrong and not aligned with the
format under CONFIG_DRM_USE_DYNAMIC_DEBUG is on. Fix it.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
---
 include/drm/drm_print.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/drm/drm_print.h b/include/drm/drm_print.h
index a44fb7ef257f..094ded23534c 100644
--- a/include/drm/drm_print.h
+++ b/include/drm/drm_print.h
@@ -521,7 +521,7 @@ __printf(1, 2)
 void __drm_err(const char *format, ...);
 
 #if !defined(CONFIG_DRM_USE_DYNAMIC_DEBUG)
-#define __drm_dbg(fmt, ...)		___drm_dbg(NULL, fmt, ##__VA_ARGS__)
+#define __drm_dbg(cat, fmt, ...)		___drm_dbg(NULL, cat, fmt, ##__VA_ARGS__)
 #else
 #define __drm_dbg(cat, fmt, ...)					\
 	_dynamic_func_call_cls(cat, fmt, ___drm_dbg,			\
-- 
2.39.0


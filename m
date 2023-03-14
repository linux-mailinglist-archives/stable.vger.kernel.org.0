Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F986B9D35
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 18:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjCNRmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 13:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjCNRmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 13:42:01 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2046.outbound.protection.outlook.com [40.107.101.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE438A45
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 10:41:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBEcVMQD5KF+0PM0kiW7GHxLCRNECtueVkmOzlGLuVhk+DLpbN+TOCP4zWPwjmxkMztl6gp6m1H3IfAkk+UnaZNhVgYyMqu+C+yF2ffmrOyEcXIMHsscUb+NiVRctDNVdNJPdBLEcWnx6R/99Qe+UX2HvAkq81CGhrrC54KlyaELTtICzdJ46tahIpgflP2P5cDrYznjPnDSn3b9HUbn5dQq/0lRXk5on+INqustTl6/vvCdjQNGGKsTZu54E9+YmgM70qfexUFmfriWaoVizuMQZo7WelhwSUCsc8dxfoXebnHeO4veAwwrlKN7stADA6OzhQi95SZCJUgSDZH7Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ilE/X2wTGEiehvTchS48cGCigkjJjmzTNvXCM9azxz4=;
 b=cQk7pPVKVs3a4q8CAfgWbQGkr8a6flu113ebAYKOcIk911EoKAAaHUSrQc8BkuWlotqTkesAEVhUzIxWDrZpBaTaCuUXyWsE/YqSKqXEqodAXqDEiBjHTpMB0pHdtMyLKNR8hIgP6SmG32XteCjTFcfIiNv04/TJsYGVd7xWMBEqYQZ6blmbEapRnfclF8IPjl9AvV4oPBj9HLz3XDrnkLx6OMEaSNMRjmsnr6qq4lAHpXSLUS1zc5L/tkMFuxEW3TyYfOhxh+zJhV38D/9vzv3u2iQ1HCtwbMguIDpNEo5vEDr5DbOERh/BYXHD4aqVFyJRJfMVEopg9k/l24EOqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilE/X2wTGEiehvTchS48cGCigkjJjmzTNvXCM9azxz4=;
 b=W/9TafLAo/fkttb9kqSLE4EHjUcl1MGDBCkYzAkpwsmJRMkzwiBE053viNQIYP/NmFsLsXmrrNt4F/ZUvjIjwAgBu7snwLdewPjuTkOXjBPjQSnUtEfSG0EkveRi43ICkP9EwT6jnA496byoK77miR+y4iTRHG1kYHbfFKYXUwI=
Received: from DM6PR12CA0009.namprd12.prod.outlook.com (2603:10b6:5:1c0::22)
 by MW3PR12MB4394.namprd12.prod.outlook.com (2603:10b6:303:54::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 17:41:57 +0000
Received: from DM6NAM11FT112.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::63) by DM6PR12CA0009.outlook.office365.com
 (2603:10b6:5:1c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26 via Frontend
 Transport; Tue, 14 Mar 2023 17:41:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT112.mail.protection.outlook.com (10.13.173.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6199.11 via Frontend Transport; Tue, 14 Mar 2023 17:41:56 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Mar
 2023 12:41:55 -0500
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sashal@kernel.org>
CC:     Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 0/2] DCN 3.2 display fixes
Date:   Tue, 14 Mar 2023 13:41:38 -0400
Message-ID: <20230314174140.505833-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT112:EE_|MW3PR12MB4394:EE_
X-MS-Office365-Filtering-Correlation-Id: 544c152a-fc2c-451f-be5f-08db24b36832
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wPscZCRdTw55zClAVMYmwQQ/8a03Nvrctx0SAFs4Tp5f/4TD1t7blTIbHlzryFubHvpe7XwR35hX3XiDDzz2/kRQEoTVhiNaVmcrN4NidD082R2uT5/1zLNOMzJ1wkO9tIp3nYeZaS6EyCd0Y/Mqj5/iEiAruBNeDTsTJZ1zzGlukSOJoVt02pqoNmLE3ovbit5RP4vMK03vI51kdUhb5A1uMMhDhSeEZsQJnEKzoDx3yTGFTbVJZa23eT39gJ+MA+R1d85KuAmJRCJ4u/ydvlNn0J4yl36m8Phwjs6wEtP9x96iHakPsEQjb0kHtMzo09xt3vRVOxzf6/soM+pzHrZivxdiv4NmftuQrlt0rjTfHwHgzwEJB/Ka/GLog4+uc8nLGy/gQEZjPOrVWQlVI1wVAGPBRtg7m1AF+CU689vJGmFdBH+OxBcO1OebzoYXLD8Mtt/vTssz1qZSAGBGUMhu97cf0IaAg1yWHqDCQufuAjcKd1wkhmwjLaBwtQulTAFgDG7MSvOpOCNTg+N1blb4nTRKeuxJf33favTq/TCxEDq5PbGLnhil8SUzpRKk2i3ShoX4gEleuHMzRYVisdNycDiWidSzcyGTN5rRNUSv2C+ijD+Je3OjG3f123MvzJ2Xjk6WxIYok259l2CCtc9xvEXwIUpFELEQzNzRyGzl8uq47y1f9T9rsKi1oBrSU9cZIRiDdWv/JMoTOOxCIZK8WEeCyarZsJV1NLqnAuk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(376002)(136003)(451199018)(46966006)(40470700004)(36840700001)(2906002)(82740400003)(81166007)(8676002)(83380400001)(4744005)(5660300002)(36756003)(40460700003)(40480700001)(8936002)(186003)(70206006)(4326008)(70586007)(36860700001)(86362001)(316002)(16526019)(110136005)(82310400005)(356005)(478600001)(7696005)(41300700001)(47076005)(336012)(426003)(1076003)(6666004)(2616005)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 17:41:56.8334
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 544c152a-fc2c-451f-be5f-08db24b36832
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT112.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4394
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

A couple of patches from 6.3 to fix corrupted display issues on
DCN3.2-based GPUs in stable.

Thanks,

Alex

Alvin Lee (1):
  drm/amd/display: Allow subvp on vactive pipes that are 2560x1440@60

Samson Tam (1):
  drm/amd/display: adjust MALL size available for DCN32 and DCN321

 .../drm/amd/display/dc/dcn32/dcn32_resource.c | 62 ++++++++++++++++++-
 .../drm/amd/display/dc/dcn32/dcn32_resource.h |  4 ++
 .../amd/display/dc/dcn321/dcn321_resource.c   |  9 ++-
 .../drm/amd/display/dc/dml/dcn32/dcn32_fpu.c  | 36 ++++++++++-
 .../amd/display/dc/dml/dcn321/dcn321_fpu.c    |  5 +-
 5 files changed, 110 insertions(+), 6 deletions(-)

-- 
2.39.2


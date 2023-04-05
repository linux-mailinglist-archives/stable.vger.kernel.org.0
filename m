Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5B36D8704
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 21:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbjDETiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 15:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbjDETiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 15:38:03 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2067AA6
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 12:37:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmFiC4kiECUMHYa4I739ZOeKq+ViC8GQB1hePsNvFRDWpYYRS9i3pkWkl9pmmH0LWyPCdesAgBv4f+eU6agHxM7KyNePK7+V7WzvrkgjaJgV0EOIS3nZgnLj1L1U0+dyEUVP+Vs2Ge7isim5zBZT4vt4qyPGCG6DbkBPBkeuyDxT4Tq+IOgqPZwsD3dWDSYpmnUocSW3caGa+Umha19RgOmqOf4gD9zwXJoNUJKJy4q7LSkWjnTZQbi81/yZ4T3psYAUWZV+ZiEnSZLY4H8CqMB1DneGq7seEw7P7u3UxY/Kp2v+uVgJaJKbfozb4GsaPSrvVGQhtWhywSj3J2rKig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Hg+pDHkPtegs/P8QAabbs5QvldxlC+Dh0Y2mSoJolU=;
 b=EWYKK+QmJJrVvV8zmiKU3d3HQoEHzYkg+jwq54/wSJ+1p7oK+QK/i87thUfu30+/778RMzog8PP5oMJHg7Xnc9CuGyQJpTJSwMzFitRSHYcyFV6HqSeZoxBJHXy/CTsKr2QfrAeMxydXFWODlplUPIp/R8JhWQHB7tgafBf3uMvO6R4aR62INs2fX4Zqfqp5/mwuKBmCnoXnoJB0v4mO7C8LKrPSxVrv+NL85SX7poqyrX5qaB1nV4P1eroS0umXg31PxB7Mk2HaMtGBu6MSN3YSf6IycNlLs3+zJlPSXJIwZyy9ECp/2QTP+1KH7JJ//jUenF9ZTqj1EMlGWz/WMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Hg+pDHkPtegs/P8QAabbs5QvldxlC+Dh0Y2mSoJolU=;
 b=XhGRYYcMfFPj3e7NbBl4ONk2+YD7tGwY2dniqBw21queNbi+LwLd4kTABe4NPdUKwdnCCOyfpHjri+6m7tMezSAP57QLN796/mLeviBpCeQgfxNXkXbPDPPRLd6x3WMA1Reo71+pGIqOh6O7jLtDY367507S7dxOP9Oxao5EJIk=
Received: from BN9PR03CA0478.namprd03.prod.outlook.com (2603:10b6:408:139::33)
 by PH7PR12MB6882.namprd12.prod.outlook.com (2603:10b6:510:1b8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Wed, 5 Apr
 2023 19:37:18 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::96) by BN9PR03CA0478.outlook.office365.com
 (2603:10b6:408:139::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35 via Frontend
 Transport; Wed, 5 Apr 2023 19:37:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.28 via Frontend Transport; Wed, 5 Apr 2023 19:37:18 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 5 Apr
 2023 14:37:17 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
Subject: [PATCH 6.1.y 0/2] MST Fixups in 6.1.y
Date:   Wed, 5 Apr 2023 14:37:05 -0500
Message-ID: <20230405193707.8184-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT044:EE_|PH7PR12MB6882:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a589672-4b49-4d62-6743-08db360d2ad2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8LBCFMCe4BJ6s09lx4pItYPlIWMuum7PId74pIa7qPvHZZLNVTn2EdfOvO/6obVWdZb+BRHtz11RDPFM4ZeQjuAVOQ5DlnNDl0dUYF3nrAfrIWnQyn0nd/43trnOnAPFXsqm2vW4UeOWIbF3TQ5JnpYg6Kj1zwFJrL8E8+uDQAuL+DpD6zDjpF/aCg2bRpgGJLJvPw6q36hn498qIDsgikYJwSGj1FAWGHrUFhIun0PMVZEKPkM8ekbEyHj8NFdl11Z8elJZQX/Eo1Q/jHC+1ABZSJVg3zlUIeoe/zPC6jlj1qUryVqYGCtQ6RPaktZr0xcQskgzHnqpH1fHuL/AeBtjKtRq5pisESO70URs9H1WyEJNtGgFrB6vMdT7AY9dtdHsQZw6IpZGV1gQE7y1QMsBfvnOk1GQHOcEbf2OfvimPRSrvROOC2SM6Qfz5PnVlaGPUbaAwQIY1joVqJJqf43kFRS1dsPv2V5Xsi/bjHNso6XE8cbqsQaTNEMcFEdGNcNP4edelrfPWW1X8eQKocm0407TSUsH1Vm7rHfKuLEUJ2qhRHhOU7NJTJKzFxsskTNzCjmWq3f1g4ubAGK2C1OIQOw4J8OfafiKHKJWz5fJUZx4RkXsjhpUfjTwCRbpTOOvCa+vwKDwH2zqZfumDRbfyEXS/0fnPOPAgruC3PpL/NUPzq98JDWrG5ETBw34lmP+nL/gHfXsxWnOhUW28UrBM+va4CcQANw7YXrrHRM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199021)(36840700001)(46966006)(40470700004)(2906002)(1076003)(316002)(26005)(2616005)(336012)(36860700001)(478600001)(426003)(47076005)(82740400003)(16526019)(186003)(6666004)(8676002)(7696005)(86362001)(70206006)(6916009)(83380400001)(70586007)(81166007)(40460700003)(41300700001)(5660300002)(44832011)(8936002)(356005)(40480700001)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 19:37:18.3495
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a589672-4b49-4d62-6743-08db360d2ad2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6882
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Some MST fixups that landed in 6.3-rc1 were CC to stable and successfully
applied to 6.2.y, but failed to apply to 6.1.y even though they are needed
there as well.

They fail to apply due to this commit missing in 6.1.y:
commit 8c7d980da9ba ("drm/nouveau/disp: move DP MST payload config method")

Backporting that is a rabbit hole of other work and makes this no longer
viable for stable, so instead hand modify
commit e761cc20946a ("drm/display/dp_mst: Handle old/new payload states in drm_dp_remove_payload()")

for the missing contextual changes in 6.1.y in nouveau.

I've tested that these work on a Rembrandt laptop connected to WD19TB
with two monitors connected.

Imre Deak (2):
  drm/display/dp_mst: Handle old/new payload states in
    drm_dp_remove_payload()
  drm/i915/dp_mst: Fix payload removal during output disabling

 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c |  2 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c | 26 ++++++++++---------
 drivers/gpu/drm/i915/display/intel_dp_mst.c   | 14 +++++++---
 drivers/gpu/drm/nouveau/dispnv50/disp.c       |  2 +-
 include/drm/display/drm_dp_mst_helper.h       |  3 ++-
 5 files changed, 28 insertions(+), 19 deletions(-)

-- 
2.34.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3256A674774
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 00:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjASXwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 18:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjASXwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 18:52:14 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226B49F39A
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 15:52:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnlW8cX1Q/0lFbmKXa3VS2zmMUEjcYBODqZ/py4Ha3Z1IapHFCOBAILm0EkOTbR7y5P1oE9p3MLsJhrTimM9iQR0xHjxJX2my0PBVhzAIlWdta/+cXd8KOdO+Z8GoACkrpDXkPNjGrvzLfXlOoq62HwGAl6oYtfHSG512mzI9rCQdv+4i27Deas78QRrpfMbWQ0qVH8H/ixSm0K63EPVzerfuWqLniq4iU/QRkkm2qOmusNKA64dhrQ9lNiA7yIC9mweMjFNhMB1M7PZAHX+xJ/ZJAaUFbvFeH6y9a+ccWgHsgoLZGbySyjNUMULfPY9zw+s9wolrBgv9pY8uho2dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H9AHcmdpBitwItrb6qLeYyH3wIEpiYdfO1NUeaHthiA=;
 b=EoyRs3suef3YEOtDutjsi++Iodt34PfxVDwYnv8k9/1hvG51xhjIk6PR+zy68mpulaFq6blAsoVXlzzBiGH67pmTJdWnRZ8OSOXbZ4hAMBgumyrShdhddCM30YL7X1s0BOmNeexlczfSeeI4SDhFVCw5WRxKKxqYuN6CKQLdHflTOVFwwOd2CjZsV2V269bAL3rVN5kgjLGhobRKs5+FBPeaWH3NUUArQRRvl8wEkZR0AIORDbZL50nbYrqSzKc5rGUQV/FEDpPhYG3onucO5Wsvqd/UZ/zIcA81C+VyUfJFA5Bc/ap4pfu5x7JLW26O8D+QRS+OQW4TJZSo2btpOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9AHcmdpBitwItrb6qLeYyH3wIEpiYdfO1NUeaHthiA=;
 b=5PkPrbzqBdkK+PMY9dK0q89dDrohTM4ccAdciINiZQpcm2GCNUcwvmcxhamphd3kIdipU+YLPy0NlnWgqTEmSD7w0uH/gsshCpSjQHOMAdWouYQ5m7BIxtFw5LmWsMhGLcrgPVvaCkryJe7PtZ0LX9zXMapAb6Ql4WADSRrQNzc=
Received: from DM6PR06CA0044.namprd06.prod.outlook.com (2603:10b6:5:54::21) by
 PH0PR12MB7789.namprd12.prod.outlook.com (2603:10b6:510:283::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Thu, 19 Jan
 2023 23:52:10 +0000
Received: from DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::a6) by DM6PR06CA0044.outlook.office365.com
 (2603:10b6:5:54::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25 via Frontend
 Transport; Thu, 19 Jan 2023 23:52:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT036.mail.protection.outlook.com (10.13.172.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 23:52:10 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 17:52:10 -0600
Received: from hwentlanryzen.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 19 Jan 2023 17:52:09 -0600
From:   Harry Wentland <harry.wentland@amd.com>
To:     <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>
CC:     <ville.syrjala@linux.intel.com>, <stanislav.lisovskiy@intel.com>,
        <bskeggs@redhat.com>, <jerry.zuo@amd.com>,
        <mario.limonciello@amd.com>, <lyude@redhat.com>,
        <stable@vger.kernel.org>, <Wayne.Lin@amd.com>,
        "Harry Wentland" <harry.wentland@amd.com>
Subject: [PATCH 0/7] Fix MST on amdgpu
Date:   Thu, 19 Jan 2023 18:51:53 -0500
Message-ID: <20230119235200.441386-1-harry.wentland@amd.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT036:EE_|PH0PR12MB7789:EE_
X-MS-Office365-Filtering-Correlation-Id: dc002c0c-80ad-4293-1e4b-08dafa782e48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IMwFwBMmOTlJGqaMXbpT9Na2PXhYfQT8p1hTsYLFJA1eebqdC32xWWJ3H/PwixGcD6N2Gcfhuksf5RuiUGnfQw3ZAdEbW7zRV1GAoFwOq8K8cjio2zCBZdxR9lxH/o+cDg2+8LT12e04mg8MlN+hpQlekSjpldCnEy2BJUiID5epH/anatousE/6t3WVJ2xEvflPSUBfvSKxmCqFA7h78F/LH4fexHCY2qy6ksiIwxOO7FpRt5OsMtqQcrAb8HRiCRvWgbLj6omsvi45iJe2w4vj1R7BCu10dD7HzYkdWmQnnMvBfGm8KUIracRgOPHvoqFFk84BmHCNuM/eows4zoyNjKvULtzpEyP99iVx+G7K7f3eVbpuzqXP/f+ejYqjfcH7aR39igHpuixyG2/B1n36eGtBTuModlbrM5J1vvHUC44WLKMlB2V60e1bHzpoEFsqYRbBNwU75xOto02JaSOKoRIx/vj7XE4ixX2tSOC4MviSh2VZ27MWFB4Mj3lJrd/NyLUgrKeTE4fcyKJc1DLOc2f4QstEvGuq2T/4iOycUok9goSil9NB/x4oYwH2u34FytS3b19k4iJGdejBJO50j47tHcK2uASUJ6MOBC2ey6s9veh5FgpZJhO7L4Als+1TLdLbmAAvekZvB1ZRY4bZ590zgxlgO+aedF2W36f4Zxy7j5YwzrayhSIMjdmj
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(1076003)(5660300002)(316002)(8936002)(86362001)(40460700003)(7696005)(478600001)(36756003)(6666004)(966005)(83380400001)(2906002)(82310400005)(426003)(44832011)(81166007)(110136005)(336012)(54906003)(47076005)(2616005)(70586007)(70206006)(8676002)(4326008)(40480700001)(82740400003)(356005)(36860700001)(186003)(41300700001)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 23:52:10.5063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc002c0c-80ad-4293-1e4b-08dafa782e48
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7789
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

MST has been broken on amdgpu after a refactor in drm_dp_mst
code that was aligning drm_dp_mst more closely with the atomic
model.

The gitlab issue: https://gitlab.freedesktop.org/drm/amd/-/issues/2171

This series fixes it.

It can be found at
https://gitlab.freedesktop.org/hwentland/linux/-/tree/mst_regression

A stable-6.1.y rebase can be found at
https://gitlab.freedesktop.org/hwentland/linux/-/tree/mst_regression_6.1

Lyude Paul (1):
  drm/amdgpu/display/mst: Fix mst_state->pbn_div and slot count
    assignments

Wayne Lin (6):
  drm/amdgpu/display/mst: limit payload to be updated one by one
  drm/amdgpu/display/mst: update mst_mgr relevant variable when long HPD
  drm/drm_print: correct format problem
  drm/display/dp_mst: Correct the kref of port.
  drm/amdgpu/display/mst: adjust the naming of mst_port and port of
    aconnector
  drm/amdgpu/display/mst: adjust the logic in 2nd phase of updating
    payload

 drivers/gpu/drm/amd/amdgpu/amdgpu_mode.h      |  4 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 48 +++++++++---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  4 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c |  2 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_debugfs.c | 16 ++--
 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 76 +++++++++++++------
 .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 53 ++++++-------
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 14 +++-
 drivers/gpu/drm/display/drm_dp_mst_topology.c |  4 +-
 include/drm/drm_print.h                       |  2 +-
 10 files changed, 143 insertions(+), 80 deletions(-)

--
2.39.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98062605F10
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 13:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbiJTLiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 07:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbiJTLiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 07:38:23 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16451DD886;
        Thu, 20 Oct 2022 04:38:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZo6azMXzi6XNVSN11rZvkneqXOGZz+us1eNJ8YhvPULnMrZUwK4a/ndHIUGmIY0c0d03SHRfb8cn4aMGdzpTcA8MgF1nG/MiPoMiUwqvEq2nIRX9Zt/My6+AXYdZU5AfGXa2667yIE9LC6+anrUmFsnOwBQ1fqvbk4ENi9tsx2UivQ7uyWgfDvUm/PdNN2FuUlsM8IacRvERjRYhwPadhKI1RnEDcRxRuFs2KfzbrP1pAsatExR1jtvOTwOa8UqjTR4hAtWajHSKEDrWqHiQ2fycQ4Yfv86iEqXerNhHageA+oPZ0bRX8Gme/FLLanL7UPDr7SfemAWkV06xpm0Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uWntC2YRhQIVdEG1NgGpJeQZ6rY8Tjk+0Q+cXb/3DkU=;
 b=PrAC/HoqPeBuaDqeFbqVZnFKS/Mmc38Ah06qzXBlwl0aMENiQ+iveHrjlAJrq2VQw54/VpWYJIcPWOo/5AET+GKPDEeOVzocq97Atx8ADQIQFjqNpXw+/eJF6MzK4rAF3fTcuZNDGn+Kf98X2Fm+09onEYyddJ4fr+TyTxOnyiRlbHVcoMZEjUYBUxV/xses5mhb/1moZ2/lO+yE8Ej4QuN3m4AwKIjEo+FV1bVgSNQ4vJq/wCX/uFar+MhfmgGTNnhoZcYtwPV25XM9yhhI9453z9+qow7oefKCsKSDApZuLzLiKX1XfsIERUHc8kMj56Dvi5J+uXhXnAkr6pttmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWntC2YRhQIVdEG1NgGpJeQZ6rY8Tjk+0Q+cXb/3DkU=;
 b=SyWBUB8SRmSwePvmILxU/ui389YRf2vlV68JAnwsp6GVPQ9j7fyNbYYSUSm4tENthb5/O4mlWNyb9ITV5v5LFArkDUFMEfFzMyHvymQAcmb3pkkY9YZqGi/WxaxL4ytH9OXf5BNc1K0RuihBdTwK+2tmj6CMG9rSbNWyXcCCLSw=
Received: from BN9PR03CA0780.namprd03.prod.outlook.com (2603:10b6:408:13a::35)
 by PH7PR12MB6633.namprd12.prod.outlook.com (2603:10b6:510:1ff::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Thu, 20 Oct
 2022 11:37:58 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::a3) by BN9PR03CA0780.outlook.office365.com
 (2603:10b6:408:13a::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34 via Frontend
 Transport; Thu, 20 Oct 2022 11:37:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 20 Oct 2022 11:37:58 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 20 Oct
 2022 06:37:57 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <mario.limonciello@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Hans de Goede <hdegoede@redhat.com>
CC:     Anson Tsao <anson.tsao@amd.com>,
        You-Sheng Yang <vicamo.yang@canonical.com>,
        <stable@vger.kernel.org>, Mark Gross <markgross@kernel.org>,
        <platform-driver-x86@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] platform/x86/amd: pmc: Read SMU version during suspend on Cezanne systems
Date:   Thu, 20 Oct 2022 06:37:49 -0500
Message-ID: <20221020113749.6621-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221020113749.6621-1-mario.limonciello@amd.com>
References: <20221020113749.6621-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT018:EE_|PH7PR12MB6633:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dec384d-04e1-4992-cc25-08dab28f89c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AEq8mnK07nMIiavuleNoOmZ3oQSGFWfPC2FcHNgmJRb3UFn3VrSvPfhZ0oeYfgaFmSdf7Q1K12NMvsnRnN27DbKlT1NOv6btKz3NHsz8QIVB+ym96FiP6K0WEZJRnd3drjlgxSNH5+3gjec34cIV1iy6/7DMt/GAz1ouAoIz5d9dHZXO3L9KJllcVrabs3ygBsIsgguRVBH6CXUg8C7vwbMWbSfWfnYqvWXYBxBtUKb6RwJ2J86mft3rHfZqZ+lh6Rxnbms1R3QuWkZzMN4WxjPB9IvVFULSBph5rH49rYfBFEkihuMOI9iF3OIMn6efgydLKtV7DUTGUVlZw6EtuDGvveqG7ZM8TMke0hMfigVTrynjhzt0LgYxEqdXlCjtVEZ4fs3Q3GTo764SJ1U94+//tCOxJ89mQotU0FEMxljb8sL1LlDPJleKaIPG2XISdsConcJD4I9v5yPEOBdFX0AECs0/4/UYML+YnDb9OKdf8a3NPm5Nu7OdurnCI90AUbu5fdv4f/iee1dNbH00+6iFK3yzdzbddCHuE4vBcBYXXnRA6A1XkM0EHuieRsLlc25a9afr/AUDbZpZGughX7OkPl0Sh4K8gqCjvPwfBcksHfgBAtSBMkJseY8ILeMFEurF9587gq6HEFr3sewgjTPkBnhbwcqtaqaV8CvUbONC/+qj4riihTJKAAVGT5O6lXSVcOowWyU/W2mRhNORdKBWzWyunoidXtoL4e8/s3SwpG4zeiADTDJQ6ioLPpbR/th/JbCjrt8whnstmvy5MfhwKi9TXh7t5wN01RnLGTlV0W2t/sJMAZRgcLjOG05o
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199015)(40470700004)(36840700001)(46966006)(44832011)(8936002)(4326008)(70206006)(8676002)(316002)(70586007)(86362001)(82740400003)(356005)(5660300002)(81166007)(41300700001)(2906002)(40460700003)(15650500001)(478600001)(6666004)(336012)(2616005)(1076003)(426003)(36756003)(26005)(36860700001)(83380400001)(54906003)(110136005)(40480700001)(82310400005)(47076005)(7696005)(16526019)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 11:37:58.7058
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dec384d-04e1-4992-cc25-08dab28f89c0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6633
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b0c07116c8943 ("platform/x86: amd-pmc: Avoid reading SMU version at
probe time") adjusted the behavior for amd-pmc to avoid reading the SMU version
at startup but rather on first use to improve boot time.

However the SMU version is also used to decide whether to place a timer based
wakeup in the OS_HINT message.  If the idlemask hasn't been read before this
message was sent then the SMU version will not have been cached.

Ensure the SMU version has been read before deciding whether or not to run this
codepath.

Cc: stable@vger.kernel.org # 6.0
Reported-by: You-Sheng Yang <vicamo.yang@canonical.com>
Tested-by: Anson Tsao <anson.tsao@amd.com>
Fixes: b0c07116c8943 ("platform/x86: amd-pmc: Avoid reading SMU version at probe time")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/platform/x86/amd/pmc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
index ce859b300712b..96e790e639a21 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -663,6 +663,13 @@ static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
 	struct rtc_time tm;
 	int rc;
 
+	/* we haven't yet read SMU version */
+	if (!pdev->major) {
+		rc = amd_pmc_get_smu_version(pdev);
+		if (rc)
+			return rc;
+	}
+
 	if (pdev->major < 64 || (pdev->major == 64 && pdev->minor < 53))
 		return 0;
 
-- 
2.34.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A18695390
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 23:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBMWFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 17:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBMWFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 17:05:54 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2068.outbound.protection.outlook.com [40.107.100.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959F51F905
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:05:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CILLl+OliVCgTcPC/HjwzjvGN5eG7b1KimR1tXGUG5dlq4oOUdjOZqiPO/hwGci69KLD87vyicN5LPk8ZFXg/qcEyA6qMxOvytWv0fKkl1q6B4SUWZ+9r+PRl///0ZbhMT7hA+XGrEn7zpBwK3r+KRjnP56rz4IZvUyaKqhfZ1DS/oh1kuN6oU+V0ViDLXBZ0oSbox9XJyXTxWPh4F2ocHwuqJuNn0Lt23+II3uRvTXLNlG7UHJzI5zzrF3+c2zWGblArkHzGBfaTlTx1uNW3ymEqNm+lD5ezsXxxHK42oySLLg5QNti/p5fr+ZI5Ilk7iNpl5cHWi0LGLpXXD9Dcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZwrWxRhpI2oh7NcL7ENSolZNUaqTyjZat6xT5gXf+IQ=;
 b=cqg4wRDNaL9vchw9nuwas3wc4Ps3gq7abZTG/fgb+p75vHoFYoA9hztxdpll2Ii/Kpxx1SvcNseJtycI454lw1JHKfbhH8Ljg6ZEzxdnX4iN39jBcOsQE2v00C30ZJk3Q9PTiDSrFC7PX/YlvxYaLP/SRkrS0HFWiFxb4QufgZg2rIFrcffGQMv5B1Y9aCblxSTlaJvPHVUdSxZrmXeCcdiuxd691W3SABtolP8ejBsSBKCF/YafS5EFPnTEvn4DAJGi0YHrWHedjC733CiuH9711UfwH9QQDluYQC68mhXAYFJ6ONwFJFkw1r3gRvQ548CxLwxEyeR9h8y6Z6DCzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZwrWxRhpI2oh7NcL7ENSolZNUaqTyjZat6xT5gXf+IQ=;
 b=mcJqtjQS+uiHc5arV2DdXZgBltggKI/EVgoImyn7Ppu40MOUZATEjylyar2xqIm/yBSsnbHKfpBj3fMERSSM5bZLHodV4OkbHAx8vLd//YfsS2rJGtuibAstMldtJfhsnN+RMCMi4gXsWgGUqB+jAP+yQMKYko2lA+KSjkxGOt8=
Received: from DM6PR02CA0166.namprd02.prod.outlook.com (2603:10b6:5:332::33)
 by SA1PR12MB8119.namprd12.prod.outlook.com (2603:10b6:806:337::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 22:05:51 +0000
Received: from DS1PEPF0000E62F.namprd02.prod.outlook.com
 (2603:10b6:5:332:cafe::87) by DM6PR02CA0166.outlook.office365.com
 (2603:10b6:5:332::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 22:05:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E62F.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 22:05:50 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 16:05:50 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15.y v2 3/4] platform/x86: amd-pmc: Correct usage of SMU version
Date:   Mon, 13 Feb 2023 16:05:36 -0600
Message-ID: <20230213220537.6534-4-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213220537.6534-1-mario.limonciello@amd.com>
References: <20230213220537.6534-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E62F:EE_|SA1PR12MB8119:EE_
X-MS-Office365-Filtering-Correlation-Id: f72972d2-788b-483c-2a2a-08db0e0e780d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4/VkZ4VjOswzeXFHO/H9oPmhVCBht1B1OR5v0b4Bw9ggYpyZtCIPgbUjMsin+cnngQkRUcJTghvXj8zsX9IqnrGQQ0BG4amEmx0I5QQnd2QtI3xruKFDz8yLEn80uPFdyS8Nxf8j5ididzcumbsz0eBEXZtd0Hc1nbzSV5rH44ThytSB/o9tpCkHqg8V4sFDZJJ97hZ+uB3iL6q++wkjBlUxeVgz2dynpDHwaPUImvJJ294NsQ969G9L0jWrzLQCHcPKaWu5Jh4+EVf1vcc8nVXJuANU0m7BbEROv3Ut8zLHoIzQVeCVOSfeF+v8olXFlcljfRuKRL6fQ3W3L50cwwVi2FCuE8pU/0vNk1FnlF83uX8JlOsr/SwLwRBZ2g9lvm2gy0c5MfiJ+ho3zDyjda6IUItMhdZ6KJskHeUk24/XavTe83Y7VSq/L0I73iMxA3oFMfhZ4lCqPBRmPlNdq/osvoidI1np3f5+fTvu+FwKdkMPc4ZD32K/JLprXuZhmj9Do6PWC4p4EIlr3WMhsU/qWniw4WoxAMvQeWc+5HejrRGH9siUfaecWFCFk5IX/cUvbEaW+Ff4aMHpACdArLxexnAbZP+Wq66AeCnOYLl4vt5BRlmKst5ln5PIIceGHZ0U7y2P1QA8kLg3DDWmG4vlyqhVCO0CFsIejZcU16vG2xbdwNEddm1pLnJafGwf7pTFfVzzmTK22o7AhAzaIlkLm7ZLyF59xP102UCjVsqk/w1h/pfWImTsG+mwmq/3LThtDuuE9q6Hvk7ETU+mRA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(346002)(396003)(451199018)(40470700004)(46966006)(36840700001)(966005)(7696005)(2906002)(36860700001)(83380400001)(336012)(47076005)(40480700001)(426003)(82310400005)(356005)(86362001)(82740400003)(81166007)(478600001)(186003)(16526019)(26005)(36756003)(40460700003)(2616005)(1076003)(6666004)(41300700001)(8936002)(316002)(54906003)(70206006)(4326008)(70586007)(6916009)(8676002)(44832011)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 22:05:50.8735
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f72972d2-788b-483c-2a2a-08db0e0e780d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E62F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8119
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Yellow carp has been outputting versions like `1093.24.0`, but this
is supposed to be 69.24.0. That is the MSB is being interpreted
incorrectly.

The MSB is not part of the major version, but has generally been
treated that way thus far.  It's actually the program, and used to
distinguish between two programs from a similar family but different
codebase.

Link: https://patchwork.freedesktop.org/patch/469993/
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20220120174439.12770-1-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
(cherry picked from commit b8fb0d9b47660ddb8a8256412784aad7cee9f21a)
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/platform/x86/amd-pmc.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index 67bc3079cdce..e6158d0f2ac3 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -115,9 +115,10 @@ struct amd_pmc_dev {
 	u32 cpu_id;
 	u32 active_ips;
 /* SMU version information */
-	u16 major;
-	u16 minor;
-	u16 rev;
+	u8 smu_program;
+	u8 major;
+	u8 minor;
+	u8 rev;
 	struct device *dev;
 	struct mutex lock; /* generic mutex lock */
 #if IS_ENABLED(CONFIG_DEBUG_FS)
@@ -164,11 +165,13 @@ static int amd_pmc_get_smu_version(struct amd_pmc_dev *dev)
 	if (rc)
 		return rc;
 
-	dev->major = (val >> 16) & GENMASK(15, 0);
+	dev->smu_program = (val >> 24) & GENMASK(7, 0);
+	dev->major = (val >> 16) & GENMASK(7, 0);
 	dev->minor = (val >> 8) & GENMASK(7, 0);
 	dev->rev = (val >> 0) & GENMASK(7, 0);
 
-	dev_dbg(dev->dev, "SMU version is %u.%u.%u\n", dev->major, dev->minor, dev->rev);
+	dev_dbg(dev->dev, "SMU program %u version is %u.%u.%u\n",
+		dev->smu_program, dev->major, dev->minor, dev->rev);
 
 	return 0;
 }
-- 
2.34.1


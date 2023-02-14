Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E4C696E65
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 21:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjBNUUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 15:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjBNUUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 15:20:20 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2087.outbound.protection.outlook.com [40.107.101.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF5E4EDD;
        Tue, 14 Feb 2023 12:20:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCuAaWn3qSHFnorAm8/w6uDqyM6TIeCB4RTXKNfsI4pWfYM+ng6VLFaJ5rgKIO62C4kqNVRxT3Qy5iScRJqWLzYvR3cVsGi0PHKial2W9ZUa4s6CLwsLknK6iJSAmzXtyToFQZ7Gua2qc7kIZ5oNGZ/YJfQPQZF+oZSqmKBEvGrn2uTGMUyIkfnBNVKjsNiZiBaK30EJTuUAic1UAdZwkPy+ImEuu7DD/A4EZHchW0KIpisG0KxQ9ek+U5zlAh6exC7w29O3aj+3brAdQHr7W6L0U6hWUCpYjfoSkrq0LhQUM+PSij/IubUcVZKxTB+Y3MaOlQJeUfFPMYqMN6MVmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z6j53lnmdBUk3/isLVSU5WwcffGgQQRBcavtcgIIdG8=;
 b=nhu4Xerto6ETQadEm9r5D8Ut+p24UCNpwCRcsK3z1IeNxp5YXn+lN+kjBiT1TtAw8awADDgz3coCZyEF1098lcuixLPfwgjnTgHpSjucyaB8+43TJ4nCce7EPmnqQV3rz0BdgsggBMua6JmyUxp7IvI7pTbmh+iG1rJw6SO+kBjNw6Idy+bUj5X9xLp4aAYlv39KpvjkEgk4iI6AbXgexlYsG0oVjlQgPBORLYyWIde5r0Lju9uRsUYPjOLJjXjMXejgvMOGiX//wI7RrT9ZE5sOu02LwU/33E8DDWBe4SnPRLv/KVOY8UN+yf/g10yL7IxGRrZXKuQOzl5QmYSM0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6j53lnmdBUk3/isLVSU5WwcffGgQQRBcavtcgIIdG8=;
 b=2uRadTb4tC7AzuGtgH9/kqIOYStxnNinD8JmblVOFEMHjyOAKHckubKNv3eARNYVyewE6YpTb0QgLz/8XjFAbONO7PT4cBH2Osxf67X357Vyxa2Mz+lImeJf9XYadRB7JgfK5g/xVLY4VYVnxJ67zdF5qAMljDyQnqG6CAZoFvM=
Received: from DM6PR07CA0099.namprd07.prod.outlook.com (2603:10b6:5:337::32)
 by PH7PR12MB6491.namprd12.prod.outlook.com (2603:10b6:510:1f4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 20:20:16 +0000
Received: from DM6NAM11FT070.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::3) by DM6PR07CA0099.outlook.office365.com
 (2603:10b6:5:337::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Tue, 14 Feb 2023 20:20:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT070.mail.protection.outlook.com (10.13.173.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.24 via Frontend Transport; Tue, 14 Feb 2023 20:20:15 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Feb
 2023 14:20:13 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     Jarkko Sakkinen <jarkko@kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        <Jason@zx2c4.com>, <linux-integrity@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Mario Limonciello" <mario.limonciello@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/1] tpm: disable hwrng for fTPM on some AMD designs
Date:   Tue, 14 Feb 2023 14:19:55 -0600
Message-ID: <20230214201955.7461-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230214201955.7461-1-mario.limonciello@amd.com>
References: <20230214201955.7461-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT070:EE_|PH7PR12MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: 34f14171-9632-4b80-bb88-08db0ec8e25c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: izLy4ALYvNaOAi4lcDPc1dz4HVy4zujJ7J6QiMSPcL7KfNNe5dHh3E/ZYnHOb+QbCDc0T48azh+CwiwYqWOH9AsDShEiddxLWT+0qd9ewelRcd70z/PyQxaKDIPWYbL4pIrVbMAbjrApVddUDlzMVBcHZxIJT0FyIoP8SwTZ2e/yR6PCDW6rbn0X0LKf98H0S4xbv7UjZ2fKDpm8JG/rZE3uz8pRM6LqH7Gk/Awbl2wrISNSlCLc3TcUVWoK7l1CPXNXY6CGhFkfTMyoGRclTs2tP7BvUA32GZWVgtM6WEUjEx7uwKpjYmeZHXeJmUZm/Mv/z1BaN8PiDW1D/WJO3UPemiHOjOUBhXAe+vWI6n+yCicq0JquOOGAofw/nidE3XI988Khhm0qjjAf/lSi+lDkNmCjJHUYgImDUFpivqNiGBgWFmK0CZAD4qmHytltNlkweEVffNRNO4wQqYDbXUz24Wn5Q5HFg971XyLuuACaZqqDw7yIc1uVCc88dvzRcbNKxqI86IwKegsIeBLrGUgl8EZGe4/bICOwVf+iSLBEbZDA0R/sPtmGU2Rn3blXjaS9yJxm+WnttfYZ+u1ZpPJ77mlmOb2lQIj5ckUOxMca6CGBFgV2hv3fSvR/vgH7eP50aVqccJPAhKqyuGNmH/BL4DESK7XtP0nDWmzdqOIhCPuEGPM/ip4IWcJilI8aKEqcKTakET/k8y604fynXePPPe1ibfHem7DrEpAI1/RqHFM9g2zAac3TRMlS+R/dTV9MpFV9NFu9g1HroktGjw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199018)(46966006)(36840700001)(40470700004)(5660300002)(44832011)(2906002)(86362001)(2616005)(83380400001)(336012)(47076005)(41300700001)(16526019)(40460700003)(426003)(356005)(36860700001)(8936002)(316002)(54906003)(70206006)(81166007)(36756003)(8676002)(70586007)(82740400003)(6916009)(26005)(186003)(4326008)(6666004)(7696005)(1076003)(40480700001)(478600001)(966005)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 20:20:15.6252
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34f14171-9632-4b80-bb88-08db0ec8e25c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT070.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6491
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

AMD has issued an advisory indicating that having fTPM enabled in
BIOS can cause "stuttering" in the OS.  This issue has been fixed
in newer versions of the fTPM firmware, but it's up to system
designers to decide whether to distribute it.

This issue has existed for a while, but is more prevalent starting
with kernel 6.1 because commit b006c439d58db ("hwrng: core - start
hwrng kthread also for untrusted sources") started to use the fTPM
for hwrng by default. However, all uses of /dev/hwrng result in
unacceptable stuttering.

So, simply disable registration of the defective hwrng when detecting
these faulty fTPM versions.

Link: https://www.amd.com/en/support/kb/faq/pa-410
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216989
Link: https://lore.kernel.org/all/20230209153120.261904-1-Jason@zx2c4.com/
Fixes: b006c439d58d ("hwrng: core - start hwrng kthread also for untrusted sources")
Cc: stable@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Co-developed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/char/tpm/tpm-chip.c | 62 ++++++++++++++++++++++++++++++-
 drivers/char/tpm/tpm.h      | 73 +++++++++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 741d8f3e8fb3a..348dd5705fbb6 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -512,6 +512,65 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
 	return 0;
 }
 
+static bool tpm_is_rng_defective(struct tpm_chip *chip)
+{
+	int ret;
+	u64 version;
+	u32 val1, val2;
+
+	/* No known-broken TPM1 chips. */
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
+		return false;
+
+	ret = tpm_request_locality(chip);
+	if (ret)
+		return false;
+
+	/* Some AMD fTPM versions may cause stutter */
+	ret = tpm2_get_tpm_pt(chip, TPM2_PT_MANUFACTURER, &val1, NULL);
+	if (ret)
+		goto release;
+	if (val1 != 0x414D4400U /* AMD */) {
+		ret = -ENODEV;
+		goto release;
+	}
+	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_1, &val1, NULL);
+	if (ret)
+		goto release;
+	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_2, &val2, NULL);
+	if (ret)
+		goto release;
+
+release:
+	tpm_relinquish_locality(chip);
+
+	if (ret)
+		return false;
+
+	version = ((u64)val1 << 32) | val2;
+	/*
+	 * Fixes for stutter as described in
+	 * https://www.amd.com/en/support/kb/faq/pa-410
+	 * are available in two series of fTPM firmware:
+	 *   6.x.y.z series: 6.0.18.6 +
+	 *   3.x.y.z series: 3.57.x.5 +
+	 */
+	if ((version >> 48) == 6) {
+		if (version >= 0x0006000000180006ULL)
+			return false;
+	} else if ((version >> 48) == 3) {
+		if (version >= 0x0003005700000005ULL)
+			return false;
+	} else {
+		return false;
+	}
+	dev_warn(&chip->dev,
+		 "AMD fTPM version 0x%llx causes system stutter; hwrng disabled\n",
+		 version);
+
+	return true;
+}
+
 static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
 	struct tpm_chip *chip = container_of(rng, struct tpm_chip, hwrng);
@@ -521,7 +580,8 @@ static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 
 static int tpm_add_hwrng(struct tpm_chip *chip)
 {
-	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip))
+	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip) ||
+	    tpm_is_rng_defective(chip))
 		return 0;
 
 	snprintf(chip->hwrng_name, sizeof(chip->hwrng_name),
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 24ee4e1cc452a..830014a266090 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -150,6 +150,79 @@ enum tpm_sub_capabilities {
 	TPM_CAP_PROP_TIS_DURATION = 0x120,
 };
 
+enum tpm2_pt_props {
+	TPM2_PT_NONE = 0x00000000,
+	TPM2_PT_GROUP = 0x00000100,
+	TPM2_PT_FIXED = TPM2_PT_GROUP * 1,
+	TPM2_PT_FAMILY_INDICATOR = TPM2_PT_FIXED + 0,
+	TPM2_PT_LEVEL = TPM2_PT_FIXED + 1,
+	TPM2_PT_REVISION = TPM2_PT_FIXED + 2,
+	TPM2_PT_DAY_OF_YEAR = TPM2_PT_FIXED + 3,
+	TPM2_PT_YEAR = TPM2_PT_FIXED + 4,
+	TPM2_PT_MANUFACTURER = TPM2_PT_FIXED + 5,
+	TPM2_PT_VENDOR_STRING_1 = TPM2_PT_FIXED + 6,
+	TPM2_PT_VENDOR_STRING_2 = TPM2_PT_FIXED + 7,
+	TPM2_PT_VENDOR_STRING_3 = TPM2_PT_FIXED + 8,
+	TPM2_PT_VENDOR_STRING_4 = TPM2_PT_FIXED + 9,
+	TPM2_PT_VENDOR_TPM_TYPE = TPM2_PT_FIXED + 10,
+	TPM2_PT_FIRMWARE_VERSION_1 = TPM2_PT_FIXED + 11,
+	TPM2_PT_FIRMWARE_VERSION_2 = TPM2_PT_FIXED + 12,
+	TPM2_PT_INPUT_BUFFER = TPM2_PT_FIXED + 13,
+	TPM2_PT_HR_TRANSIENT_MIN = TPM2_PT_FIXED + 14,
+	TPM2_PT_HR_PERSISTENT_MIN = TPM2_PT_FIXED + 15,
+	TPM2_PT_HR_LOADED_MIN = TPM2_PT_FIXED + 16,
+	TPM2_PT_ACTIVE_SESSIONS_MAX = TPM2_PT_FIXED + 17,
+	TPM2_PT_PCR_COUNT = TPM2_PT_FIXED + 18,
+	TPM2_PT_PCR_SELECT_MIN = TPM2_PT_FIXED + 19,
+	TPM2_PT_CONTEXT_GAP_MAX = TPM2_PT_FIXED + 20,
+	TPM2_PT_NV_COUNTERS_MAX = TPM2_PT_FIXED + 22,
+	TPM2_PT_NV_INDEX_MAX = TPM2_PT_FIXED + 23,
+	TPM2_PT_MEMORY = TPM2_PT_FIXED + 24,
+	TPM2_PT_CLOCK_UPDATE = TPM2_PT_FIXED + 25,
+	TPM2_PT_CONTEXT_HASH = TPM2_PT_FIXED + 26,
+	TPM2_PT_CONTEXT_SYM = TPM2_PT_FIXED + 27,
+	TPM2_PT_CONTEXT_SYM_SIZE = TPM2_PT_FIXED + 28,
+	TPM2_PT_ORDERLY_COUNT = TPM2_PT_FIXED + 29,
+	TPM2_PT_MAX_COMMAND_SIZE = TPM2_PT_FIXED + 30,
+	TPM2_PT_MAX_RESPONSE_SIZE = TPM2_PT_FIXED + 31,
+	TPM2_PT_MAX_DIGEST = TPM2_PT_FIXED + 32,
+	TPM2_PT_MAX_OBJECT_CONTEXT = TPM2_PT_FIXED + 33,
+	TPM2_PT_MAX_SESSION_CONTEXT = TPM2_PT_FIXED + 34,
+	TPM2_PT_PS_FAMILY_INDICATOR = TPM2_PT_FIXED + 35,
+	TPM2_PT_PS_LEVEL = TPM2_PT_FIXED + 36,
+	TPM2_PT_PS_REVISION = TPM2_PT_FIXED + 37,
+	TPM2_PT_PS_DAY_OF_YEAR = TPM2_PT_FIXED + 38,
+	TPM2_PT_PS_YEAR = TPM2_PT_FIXED + 39,
+	TPM2_PT_SPLIT_MAX = TPM2_PT_FIXED + 40,
+	TPM2_PT_TOTAL_COMMANDS = TPM2_PT_FIXED + 41,
+	TPM2_PT_LIBRARY_COMMANDS = TPM2_PT_FIXED + 42,
+	TPM2_PT_VENDOR_COMMANDS = TPM2_PT_FIXED + 43,
+	TPM2_PT_NV_BUFFER_MAX = TPM2_PT_FIXED + 44,
+	TPM2_PT_MODES = TPM2_PT_FIXED + 45,
+	TPM2_PT_MAX_CAP_BUFFER = TPM2_PT_FIXED + 46,
+	TPM2_PT_VAR = TPM2_PT_GROUP * 2,
+	TPM2_PT_PERMANENT = TPM2_PT_VAR + 0,
+	TPM2_PT_STARTUP_CLEAR = TPM2_PT_VAR + 1,
+	TPM2_PT_HR_NV_INDEX = TPM2_PT_VAR + 2,
+	TPM2_PT_HR_LOADED = TPM2_PT_VAR + 3,
+	TPM2_PT_HR_LOADED_AVAIL = TPM2_PT_VAR + 4,
+	TPM2_PT_HR_ACTIVE = TPM2_PT_VAR + 5,
+	TPM2_PT_HR_ACTIVE_AVAIL = TPM2_PT_VAR + 6,
+	TPM2_PT_HR_TRANSIENT_AVAIL = TPM2_PT_VAR + 7,
+	TPM2_PT_HR_PERSISTENT = TPM2_PT_VAR + 8,
+	TPM2_PT_HR_PERSISTENT_AVAIL = TPM2_PT_VAR + 9,
+	TPM2_PT_NV_COUNTERS = TPM2_PT_VAR + 10,
+	TPM2_PT_NV_COUNTERS_AVAIL = TPM2_PT_VAR + 11,
+	TPM2_PT_ALGORITHM_SET = TPM2_PT_VAR + 12,
+	TPM2_PT_LOADED_CURVES = TPM2_PT_VAR + 13,
+	TPM2_PT_LOCKOUT_COUNTER = TPM2_PT_VAR + 14,
+	TPM2_PT_MAX_AUTH_FAIL = TPM2_PT_VAR + 15,
+	TPM2_PT_LOCKOUT_INTERVAL = TPM2_PT_VAR + 16,
+	TPM2_PT_LOCKOUT_RECOVERY = TPM2_PT_VAR + 17,
+	TPM2_PT_NV_WRITE_RECOVERY = TPM2_PT_VAR + 18,
+	TPM2_PT_AUDIT_COUNTER_0 = TPM2_PT_VAR + 19,
+	TPM2_PT_AUDIT_COUNTER_1 = TPM2_PT_VAR + 20,
+};
 
 /* 128 bytes is an arbitrary cap. This could be as large as TPM_BUFSIZE - 18
  * bytes, but 128 is still a relatively large number of random bytes and
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D97626A5163
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 03:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjB1Co5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 21:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjB1Co5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 21:44:57 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2054.outbound.protection.outlook.com [40.107.101.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEA61167F;
        Mon, 27 Feb 2023 18:44:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DT/dxPnA26eyKVvII5UvbghL4CgAoa1fptTBmD6Pl1fhFmbVF0efq19XVcsHD4gwfugiazM/cSqDLWEKYWjSTbtIfFEG5kgqjI4gi1zJVF7Y/BSB20eCm+b4Wnx0kP07wVO/Fr8gahGmahClK3IoO1aUQFUNvrpItm95PUzLv1C1CN93KSmY6jwjVBtN/IILP25PgUMqpT4uzO+Z8JU5kR3Q+arwWgb3ymZZ7Oc12RHdh8b0AyJg3lRgHkAjTVrkaY/s1CnY9RaaMu2WnJXGFhnyaCAi2D5Z6Gw9w6Sahjo9ulKkgfos2JiHFZwl/pdSbXQ/hGiPHyNsz3pFAIcRkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kMuqSUFpwCCh68Vv8mNo2yUfJpXu45dnqhCaoPih7hE=;
 b=TFQ5zQ8d3hP5EijpLILXXGl3dTrOK42e4aegaRvz+qyxVkY6ekB6jwtyDEpY+bIb3VNMepw/XX+jPlfvX1arE7QJ4xhCaMNghEo+J0mei/TcxlT6veTH2HFfqTVMEd+a4Tg0BOMu2/OeidN4DFbqxPS7z5USnfUyZL5NioOpibs/98HP5WbmdT6r2ogFjYBV8EN97mridQ0alhzTw0qESo/9M8Ll1QrLLkILp807KHNNhHWuuKiD8HQDaFHiQbZzoyqH4PyLtP+MMEVfeGn68zh1fimTdgzAVzv7zgKeY3DB7EFZIqcf7eAV1BGA+CqQHsCOnuv4DJSVuKq1A7qryg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmx.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMuqSUFpwCCh68Vv8mNo2yUfJpXu45dnqhCaoPih7hE=;
 b=pZuAAAM7X1Da6OZZ5x4OPzwhI/MnGoRHLSiCVOEwkHVW7txTshH8aQjnOxpAAc/z4XHeYirfxj4zAl8r56A6I0mntJyjfeTT+g62bpYcvYcLdkHaeMdcGxuDn6Y1D/7CpaQzA710wvlygt9yDH7ZPPRxFvyUZv1hdZvqI4zNQXk=
Received: from BN0PR04CA0170.namprd04.prod.outlook.com (2603:10b6:408:eb::25)
 by MW3PR12MB4346.namprd12.prod.outlook.com (2603:10b6:303:58::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Tue, 28 Feb
 2023 02:44:52 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::1d) by BN0PR04CA0170.outlook.office365.com
 (2603:10b6:408:eb::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29 via Frontend
 Transport; Tue, 28 Feb 2023 02:44:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.17 via Frontend Transport; Tue, 28 Feb 2023 02:44:51 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Feb
 2023 20:44:50 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Mario Limonciello <mario.limonciello@amd.com>,
        <stable@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        <reach622@mailcuk.com>, Bell <1138267643@qq.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        <linux-integrity@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] tpm: disable hwrng for fTPM on some AMD designs
Date:   Mon, 27 Feb 2023 20:44:39 -0600
Message-ID: <20230228024439.27156-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT035:EE_|MW3PR12MB4346:EE_
X-MS-Office365-Filtering-Correlation-Id: 91b5ea4e-9528-4774-02bb-08db1935c437
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: luXoMr2yoDbXgNNGxl98mn49bpudG9ScOppez/7spEotKj73fzzlKTs/bG32BAcRshQ3glrvl3POoQ8qnXUHX7sOIVOiSSAquSv09eu13xsU1HyI0QCAbQJLxK8Fd3bh7fU3JmytI7hvOCOll3vI2TtQJ4AOtpg+fVBtf/UAPcMZ//ZKnXl6CqN2HJ8jf7sBEX2YOg9mHUFAJXfNuo6EfgtygYqlyiEKfNKrNAycuGj+IEtIFGiOKqao2GItHltMsp43vjmHIpaeJBJ+++b5NzPX8X40MSVG8lqVHVpzNfMd1Ca0Ucvl2F6OAFyehzuQAndkj6T9bTEXpOVf1MJcYvI9Di1Ix6SaQ5aFuWMdV6x7A2T754eu4C2os9yK56ip3NQNjc9W9lXkRDVm5QN1p/KmcUwCR0pc+DTAKw5e8ZbmDHtDCw6a9IT8NzINPDw30hC4Mb/2k5gjAqeViLqaFx0KMzDFGE2cbxShGx8f3bnAzP3IQ7uEDlb1Ehh8fOvm21VBkjlsZipz50dKtt1x9ym00xCOfnwAObhhzbgYoa+X1f3MupUE9+hpdOvblTUF97LDyQBY2HioXBSyUdcnethxu0Kbvgihm2tlOmT7BhMQKAZ+XZUOBsDCSEc0ae8P9IFks9RPbn0g2DpO/BQk4bb8SDsJTsM1kh/nq9Hd2t5NkCyhPszaG5D2mz/tjd9ZWzCazJS75hAHMZJJTjFx7qVhk/Q2E9PeNq5ZAfyfvupYufzEpldIsKcDT339PdL4ZiHnSWnZP9ZFdFyic4X12g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(376002)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(82310400005)(110136005)(86362001)(36756003)(54906003)(966005)(186003)(40460700003)(5660300002)(16526019)(41300700001)(2906002)(44832011)(36860700001)(8936002)(6666004)(4326008)(8676002)(1076003)(70206006)(70586007)(2616005)(47076005)(478600001)(7416002)(26005)(40480700001)(7696005)(426003)(336012)(356005)(82740400003)(316002)(83380400001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 02:44:51.8489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b5ea4e-9528-4774-02bb-08db1935c437
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4346
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
these faulty fTPM versions.  As this is caused by faulty firmware, it
is plausible that such a problem could also be reproduced by other TPM
interactions, but this hasn't been shown by any user's testing or reports.

It is hypothesized to be triggered more frequently by the use of the RNG
because userspace software will fetch random numbers regularly.

Intentionally continue to register other TPM functionality so that users
that rely upon PCR measurements or any storage of data will still have
access to it.  If it's found later that another TPM functionality is
exacerbating this problem a module parameter it can be turned off entirely
and a module parameter can be introduced to allow users who rely upon
fTPM functionality to turn it on even though this problem is present.

Link: https://www.amd.com/en/support/kb/faq/pa-410
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216989
Link: https://lore.kernel.org/all/20230209153120.261904-1-Jason@zx2c4.com/
Fixes: b006c439d58d ("hwrng: core - start hwrng kthread also for untrusted sources")
Cc: stable@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Tested-by: reach622@mailcuk.com
Tested-by: Bell <1138267643@qq.com>
Co-developed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v2->v3:
 * Revert extra curl braces back to behavior in v1
 * Remove needless goto
 * Pick up 2 tested tags
---
 drivers/char/tpm/tpm-chip.c | 60 +++++++++++++++++++++++++++++-
 drivers/char/tpm/tpm.h      | 73 +++++++++++++++++++++++++++++++++++++
 2 files changed, 132 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 741d8f3e8fb3..c467eeae9973 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -512,6 +512,63 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
 	return 0;
 }
 
+/*
+ * Some AMD fTPM versions may cause stutter
+ * https://www.amd.com/en/support/kb/faq/pa-410
+ *
+ * Fixes are available in two series of fTPM firmware:
+ * 6.x.y.z series: 6.0.18.6 +
+ * 3.x.y.z series: 3.57.y.5 +
+ */
+static bool tpm_amd_is_rng_defective(struct tpm_chip *chip)
+{
+	u32 val1, val2;
+	u64 version;
+	int ret;
+
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
+		return false;
+
+	ret = tpm_request_locality(chip);
+	if (ret)
+		return false;
+
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
+
+release:
+	tpm_relinquish_locality(chip);
+
+	if (ret)
+		return false;
+
+	version = ((u64)val1 << 32) | val2;
+	if ((version >> 48) == 6) {
+		if (version >= 0x0006000000180006ULL)
+			return false;
+	} else if ((version >> 48) == 3) {
+		if (version >= 0x0003005700000005ULL)
+			return false;
+	} else {
+		return false;
+	}
+
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
@@ -521,7 +578,8 @@ static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 
 static int tpm_add_hwrng(struct tpm_chip *chip)
 {
-	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip))
+	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip) ||
+	    tpm_amd_is_rng_defective(chip))
 		return 0;
 
 	snprintf(chip->hwrng_name, sizeof(chip->hwrng_name),
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 24ee4e1cc452..830014a26609 100644
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
2.34.1


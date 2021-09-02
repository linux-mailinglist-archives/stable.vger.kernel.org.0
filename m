Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECEAB3FF122
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 18:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346217AbhIBQTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 12:19:33 -0400
Received: from mail-mw2nam10on2047.outbound.protection.outlook.com ([40.107.94.47]:54624
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346298AbhIBQTd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Sep 2021 12:19:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfyOEAUBLdmV0KB9OLSQRILYTt9hHSlWdRfYmzzw0+eKWJJsOVANSnh7bQDRkbZFiA2VX2XMufBVZy/jbuJlOV416/F0NOl6aCEpKDZwjBvDYo2qNnA2n35OGMUAsN7SI2vp6AYSkJ17K4KzKakEUYcmTp1kGbhSQlcEysgUPxrQg9biQPBZas7cB3Mtxg3ItVA2cqKOGyupcbwYpGs08ylanhrAUzSlTxTvMqIQPNF5GNoCZrR9Qq7ClQxYgeHWk+AmDsJIJB9vw3e6362EQ6C9HW3f2mxjL9f/jsnmLKDpbG8d3qvvjBfJ/acFvpfJMwVChbUhrRm/9trYRh4JWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PDOryb83NOguLJE2MuO5mnpBMSLxoFjKDZzLPVXxGlg=;
 b=evnUHxh54RwKKmdxJaixpZoxvFe3mKdIBGouyj9SvsveeC8e+tn092v8wa3ijm6yghH4YC73iyyFPr1qHYj6BjVY2WuQnIkaoN0m/7GfUKcgUUCl43L7go1/wUotjvJxeyZVA6EXQzIUqY7tGW2WHnUZSclb0HrEq2hYo9TJswlcR+EFewePI4Fc7ozihbJsDzBKjmbtSoFZb2Zd36b0usXbv7+UKXqMM6MYqCjaxQTeyo/qltQHpgF5GX7BFpQ21IZll+mIKIx9+K5pScEzGehFLXbw+NiH5h762PaYMipV3M2ibv7gm3Cjtw8IgNZvbTNau23Db/waJofhp14BDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDOryb83NOguLJE2MuO5mnpBMSLxoFjKDZzLPVXxGlg=;
 b=iVx9l1TNNAfq6Df3D26kcpzRuK7wqGFIPheqUeXLIEbe7srJvJ4swY52BEcNKm6EtVzm3C3XsTTSAFrPMYuqCVytDrFzgTg9j7c1surSbE1zXlKAe7IqvOefJ6TXGRSNPr7NrA5NPRIWP6f4C4sPsYYdCPJ/o+nitPxvE1pHJUI=
Received: from BN6PR19CA0080.namprd19.prod.outlook.com (2603:10b6:404:133::18)
 by BYAPR12MB3448.namprd12.prod.outlook.com (2603:10b6:a03:ad::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Thu, 2 Sep
 2021 16:17:36 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:133:cafe::56) by BN6PR19CA0080.outlook.office365.com
 (2603:10b6:404:133::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Thu, 2 Sep 2021 16:17:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4478.19 via Frontend Transport; Thu, 2 Sep 2021 16:17:36 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.12; Thu, 2 Sep
 2021 11:17:29 -0500
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <stable@vger.kernel.org>
CC:     <guoqing.chen@amd.com>, Luben Tuikov <luben.tuikov@amd.com>,
        Alex Deucher <Alexander.Deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>, Lijo Lazar <Lijo.Lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 1/2] drm/amd/pm: Fix a bug communicating with the SMU (v5)
Date:   Thu, 2 Sep 2021 12:17:16 -0400
Message-ID: <20210902161717.35399-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cb2c322-cb87-43a4-bd14-08d96e2d2d43
X-MS-TrafficTypeDiagnostic: BYAPR12MB3448:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3448A2C511137183970ACD9CF7CE9@BYAPR12MB3448.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZinCh/tGLFWqCQGgXVMmHKGzf3lyE/gWbODFPr/E2DRW19DmezR3MXHdTWrW1dYSKYcj2F9GBbgBuhKCpP1/BB1ShMq0PbP5qMYd59LU7iMczDpHONhb4dfC2VZ7EIvGYuMER2A/oVNvgYZVVbZrKB2G2NEoLUvXR6cAzb3jOtAxFCaKUCORjGn+BuYVyqvVgzKIv85p6isuVgShdfUs6GR59tJyksEIoG7SyCMdR7XT9QosabgjHtlPx26ymdVk9NV32z73+hVMjPKABc0mj5TagRtk7nZ0saPphUnl+TGtIxwk9ERBxFk/u0pz+3q/cEza2LiphLrAhngzQrXZMgNd+xv3bryQJGnH788RN0UMOzu5xTEuXXDj2VrLk4iqwt1l45WZKNkgu0vuea082e5LngrUdjQ1fzNP73TCxWOWQM926VI6n1hFy+r0HmV+1NCgWAkflAu7szvMPl55/hS3DVVlnLHhGhWKnh3IIEgOBKyFNb74x/5f8k9BQnvYKLefKrSN1oHW48E9+ouqvU3MM8A0T6B5k7d362NjRC0x0Oo76rnFPKkzpLqCyb+/uBhznyitXHfsp1yviN1MKk8LyC1j9elm1ciDaHlY71Lk58azIZj702ij9DdJHR+M56kpNwpzBlSxc2WATHS0/oE2BEPLj/vnBqyQRO5Q2zXKzBKwS7faO3DTHJPjSrCS6fG+xWhh4zHZVIIK4D7IIiiDfRDFAcEzmrglmO9ZJP4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(5660300002)(83380400001)(966005)(81166007)(86362001)(6916009)(356005)(2906002)(8936002)(36756003)(54906003)(7696005)(8676002)(6666004)(1076003)(70206006)(4326008)(70586007)(47076005)(2616005)(498600001)(186003)(82310400003)(30864003)(16526019)(426003)(36860700001)(26005)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 16:17:36.1203
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cb2c322-cb87-43a4-bd14-08d96e2d2d43
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3448
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luben Tuikov <luben.tuikov@amd.com>

This fixes a bug which if we probe a non-existing
I2C device, and the SMU returns 0xFF, from then on
we can never communicate with the SMU, because the
code before this patch reads and interprets 0xFF
as a terminal error, and thus we never write 0
into register 90 to clear the status (and
subsequently send a new command to the SMU.)

It is not an error that the SMU returns status
0xFF. This means that the SMU executed the last
command successfully (execution status), but the
command result is an error of some sort (execution
result), depending on what the command was.

When doing a status check of the SMU, before we
send a new command, the only status which
precludes us from sending a new command is 0--the
SMU hasn't finished executing a previous command,
and 0xFC--the SMU is busy.

This bug was seen as the following line in the
kernel log,

amdgpu: Msg issuing pre-check failed(0xff) and SMU may be not in the right state!

when subsequent SMU commands, not necessarily
related to I2C, were sent to the SMU.

This patch fixes this bug.

v2: Add a comment to the description of
__smu_cmn_poll_stat() to explain why we're NOT
defining the SMU FW return codes as macros, but
are instead hard-coding them. Such a change, can
be followed up by a subsequent patch.

v3: The changes are,
a) Add comments to break labels in
   __smu_cmn_reg2errno().

b) When an unknown/unspecified/undefined result is
   returned back from the SMU, map that to
   -EREMOTEIO, to distinguish failure at the SMU
   FW.

c) Add kernel-doc to
   smu_cmn_send_msg_without_waiting(),
   smu_cmn_wait_for_response(),
   smu_cmn_send_smc_msg_with_param().

d) In smu_cmn_send_smc_msg_with_param(), since we
   wait for completion of the command, if the
   result of the completion is
   undefined/unknown/unspecified, we print that to
   the kernel log.

v4: a) Add macros as requested, though redundant, to
    be removed when SMU consolidates for all
    ASICs--see comment in code.
    b) Get out if the SMU code is unknown.

v5: Rename the macro names.

Cc: Alex Deucher <Alexander.Deucher@amd.com>
Cc: Evan Quan <evan.quan@amd.com>
Cc: Lijo Lazar <Lijo.Lazar@amd.com>
Fixes: fcb1fe9c9e0031 ("drm/amd/powerplay: pre-check the SMU state before issuing message")
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5810323ba692895b045e3f1b3e107605c3717dab)
Cc: stable@vger.kernel.org # 5.14.x
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1670
---
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c | 288 +++++++++++++++++++++----
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h |   3 +-
 2 files changed, 244 insertions(+), 47 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
index e802f9a95f08..a0e2111eb783 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -55,7 +55,7 @@
 
 #undef __SMU_DUMMY_MAP
 #define __SMU_DUMMY_MAP(type)	#type
-static const char* __smu_message_names[] = {
+static const char * const __smu_message_names[] = {
 	SMU_MESSAGE_TYPES
 };
 
@@ -76,55 +76,258 @@ static void smu_cmn_read_arg(struct smu_context *smu,
 	*arg = RREG32_SOC15(MP1, 0, mmMP1_SMN_C2PMSG_82);
 }
 
-int smu_cmn_wait_for_response(struct smu_context *smu)
+/* Redefine the SMU error codes here.
+ *
+ * Note that these definitions are redundant and should be removed
+ * when the SMU has exported a unified header file containing these
+ * macros, which header file we can just include and use the SMU's
+ * macros. At the moment, these error codes are defined by the SMU
+ * per-ASIC unfortunately, yet we're a one driver for all ASICs.
+ */
+#define SMU_RESP_NONE           0
+#define SMU_RESP_OK             1
+#define SMU_RESP_CMD_FAIL       0xFF
+#define SMU_RESP_CMD_UNKNOWN    0xFE
+#define SMU_RESP_CMD_BAD_PREREQ 0xFD
+#define SMU_RESP_BUSY_OTHER     0xFC
+#define SMU_RESP_DEBUG_END      0xFB
+
+/**
+ * __smu_cmn_poll_stat -- poll for a status from the SMU
+ * smu: a pointer to SMU context
+ *
+ * Returns the status of the SMU, which could be,
+ *    0, the SMU is busy with your previous command;
+ *    1, execution status: success, execution result: success;
+ * 0xFF, execution status: success, execution result: failure;
+ * 0xFE, unknown command;
+ * 0xFD, valid command, but bad (command) prerequisites;
+ * 0xFC, the command was rejected as the SMU is busy;
+ * 0xFB, "SMC_Result_DebugDataDumpEnd".
+ *
+ * The values here are not defined by macros, because I'd rather we
+ * include a single header file which defines them, which is
+ * maintained by the SMU FW team, so that we're impervious to firmware
+ * changes. At the moment those values are defined in various header
+ * files, one for each ASIC, yet here we're a single ASIC-agnostic
+ * interface. Such a change can be followed-up by a subsequent patch.
+ */
+static u32 __smu_cmn_poll_stat(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
-	uint32_t cur_value, i, timeout = adev->usec_timeout * 20;
+	int timeout = adev->usec_timeout * 20;
+	u32 reg;
 
-	for (i = 0; i < timeout; i++) {
-		cur_value = RREG32_SOC15(MP1, 0, mmMP1_SMN_C2PMSG_90);
-		if ((cur_value & MP1_C2PMSG_90__CONTENT_MASK) != 0)
-			return cur_value;
+	for ( ; timeout > 0; timeout--) {
+		reg = RREG32_SOC15(MP1, 0, mmMP1_SMN_C2PMSG_90);
+		if ((reg & MP1_C2PMSG_90__CONTENT_MASK) != 0)
+			break;
 
 		udelay(1);
 	}
 
-	/* timeout means wrong logic */
-	if (i == timeout)
-		return -ETIME;
-
-	return RREG32_SOC15(MP1, 0, mmMP1_SMN_C2PMSG_90);
+	return reg;
 }
 
-int smu_cmn_send_msg_without_waiting(struct smu_context *smu,
-				     uint16_t msg, uint32_t param)
+static void __smu_cmn_reg_print_error(struct smu_context *smu,
+				      u32 reg_c2pmsg_90,
+				      int msg_index,
+				      u32 param,
+				      enum smu_message_type msg)
 {
 	struct amdgpu_device *adev = smu->adev;
-	int ret;
+	const char *message = smu_get_message_name(smu, msg);
 
-	ret = smu_cmn_wait_for_response(smu);
-	if (ret != 0x1) {
-		dev_err(adev->dev, "Msg issuing pre-check failed(0x%x) and "
-		       "SMU may be not in the right state!\n", ret);
-		if (ret != -ETIME)
-			ret = -EIO;
-		return ret;
+	switch (reg_c2pmsg_90) {
+	case SMU_RESP_NONE:
+		dev_err_ratelimited(adev->dev,
+				    "SMU: I'm not done with your previous command!");
+		break;
+	case SMU_RESP_OK:
+		/* The SMU executed the command. It completed with a
+		 * successful result.
+		 */
+		break;
+	case SMU_RESP_CMD_FAIL:
+		/* The SMU executed the command. It completed with an
+		 * unsuccessful result.
+		 */
+		break;
+	case SMU_RESP_CMD_UNKNOWN:
+		dev_err_ratelimited(adev->dev,
+				    "SMU: unknown command: index:%d param:0x%08X message:%s",
+				    msg_index, param, message);
+		break;
+	case SMU_RESP_CMD_BAD_PREREQ:
+		dev_err_ratelimited(adev->dev,
+				    "SMU: valid command, bad prerequisites: index:%d param:0x%08X message:%s",
+				    msg_index, param, message);
+		break;
+	case SMU_RESP_BUSY_OTHER:
+		dev_err_ratelimited(adev->dev,
+				    "SMU: I'm very busy for your command: index:%d param:0x%08X message:%s",
+				    msg_index, param, message);
+		break;
+	case SMU_RESP_DEBUG_END:
+		dev_err_ratelimited(adev->dev,
+				    "SMU: I'm debugging!");
+		break;
+	default:
+		dev_err_ratelimited(adev->dev,
+				    "SMU: response:0x%08X for index:%d param:0x%08X message:%s?",
+				    reg_c2pmsg_90, msg_index, param, message);
+		break;
+	}
+}
+
+static int __smu_cmn_reg2errno(struct smu_context *smu, u32 reg_c2pmsg_90)
+{
+	int res;
+
+	switch (reg_c2pmsg_90) {
+	case SMU_RESP_NONE:
+		/* The SMU is busy--still executing your command.
+		 */
+		res = -ETIME;
+		break;
+	case SMU_RESP_OK:
+		res = 0;
+		break;
+	case SMU_RESP_CMD_FAIL:
+		/* Command completed successfully, but the command
+		 * status was failure.
+		 */
+		res = -EIO;
+		break;
+	case SMU_RESP_CMD_UNKNOWN:
+		/* Unknown command--ignored by the SMU.
+		 */
+		res = -EOPNOTSUPP;
+		break;
+	case SMU_RESP_CMD_BAD_PREREQ:
+		/* Valid command--bad prerequisites.
+		 */
+		res = -EINVAL;
+		break;
+	case SMU_RESP_BUSY_OTHER:
+		/* The SMU is busy with other commands. The client
+		 * should retry in 10 us.
+		 */
+		res = -EBUSY;
+		break;
+	default:
+		/* Unknown or debug response from the SMU.
+		 */
+		res = -EREMOTEIO;
+		break;
 	}
 
+	return res;
+}
+
+static void __smu_cmn_send_msg(struct smu_context *smu,
+			       u16 msg,
+			       u32 param)
+{
+	struct amdgpu_device *adev = smu->adev;
+
 	WREG32_SOC15(MP1, 0, mmMP1_SMN_C2PMSG_90, 0);
 	WREG32_SOC15(MP1, 0, mmMP1_SMN_C2PMSG_82, param);
 	WREG32_SOC15(MP1, 0, mmMP1_SMN_C2PMSG_66, msg);
+}
 
-	return 0;
+/**
+ * smu_cmn_send_msg_without_waiting -- send the message; don't wait for status
+ * @smu: pointer to an SMU context
+ * @msg_index: message index
+ * @param: message parameter to send to the SMU
+ *
+ * Send a message to the SMU with the parameter passed. Do not wait
+ * for status/result of the message, thus the "without_waiting".
+ *
+ * Return 0 on success, -errno on error if we weren't able to _send_
+ * the message for some reason. See __smu_cmn_reg2errno() for details
+ * of the -errno.
+ */
+int smu_cmn_send_msg_without_waiting(struct smu_context *smu,
+				     uint16_t msg_index,
+				     uint32_t param)
+{
+	u32 reg;
+	int res;
+
+	if (smu->adev->no_hw_access)
+		return 0;
+
+	mutex_lock(&smu->message_lock);
+	reg = __smu_cmn_poll_stat(smu);
+	res = __smu_cmn_reg2errno(smu, reg);
+	if (reg == SMU_RESP_NONE ||
+	    reg == SMU_RESP_BUSY_OTHER ||
+	    res == -EREMOTEIO)
+		goto Out;
+	__smu_cmn_send_msg(smu, msg_index, param);
+	res = 0;
+Out:
+	mutex_unlock(&smu->message_lock);
+	return res;
 }
 
+/**
+ * smu_cmn_wait_for_response -- wait for response from the SMU
+ * @smu: pointer to an SMU context
+ *
+ * Wait for status from the SMU.
+ *
+ * Return 0 on success, -errno on error, indicating the execution
+ * status and result of the message being waited for. See
+ * __smu_cmn_reg2errno() for details of the -errno.
+ */
+int smu_cmn_wait_for_response(struct smu_context *smu)
+{
+	u32 reg;
+
+	reg = __smu_cmn_poll_stat(smu);
+	return __smu_cmn_reg2errno(smu, reg);
+}
+
+/**
+ * smu_cmn_send_smc_msg_with_param -- send a message with parameter
+ * @smu: pointer to an SMU context
+ * @msg: message to send
+ * @param: parameter to send to the SMU
+ * @read_arg: pointer to u32 to return a value from the SMU back
+ *            to the caller
+ *
+ * Send the message @msg with parameter @param to the SMU, wait for
+ * completion of the command, and return back a value from the SMU in
+ * @read_arg pointer.
+ *
+ * Return 0 on success, -errno on error, if we weren't able to send
+ * the message or if the message completed with some kind of
+ * error. See __smu_cmn_reg2errno() for details of the -errno.
+ *
+ * If we weren't able to send the message to the SMU, we also print
+ * the error to the standard log.
+ *
+ * Command completion status is printed only if the -errno is
+ * -EREMOTEIO, indicating that the SMU returned back an
+ * undefined/unknown/unspecified result. All other cases are
+ * well-defined, not printed, but instead given back to the client to
+ * decide what further to do.
+ *
+ * The return value, @read_arg is read back regardless, to give back
+ * more information to the client, which on error would most likely be
+ * @param, but we can't assume that. This also eliminates more
+ * conditionals.
+ */
 int smu_cmn_send_smc_msg_with_param(struct smu_context *smu,
 				    enum smu_message_type msg,
 				    uint32_t param,
 				    uint32_t *read_arg)
 {
-	struct amdgpu_device *adev = smu->adev;
-	int ret = 0, index = 0;
+	int res, index;
+	u32 reg;
 
 	if (smu->adev->no_hw_access)
 		return 0;
@@ -136,31 +339,24 @@ int smu_cmn_send_smc_msg_with_param(struct smu_context *smu,
 		return index == -EACCES ? 0 : index;
 
 	mutex_lock(&smu->message_lock);
-	ret = smu_cmn_send_msg_without_waiting(smu, (uint16_t)index, param);
-	if (ret)
-		goto out;
-
-	ret = smu_cmn_wait_for_response(smu);
-	if (ret != 0x1) {
-		if (ret == -ETIME) {
-			dev_err(adev->dev, "message: %15s (%d) \tparam: 0x%08x is timeout (no response)\n",
-				smu_get_message_name(smu, msg), index, param);
-		} else {
-			dev_err(adev->dev, "failed send message: %15s (%d) \tparam: 0x%08x response %#x\n",
-				smu_get_message_name(smu, msg), index, param,
-				ret);
-			ret = -EIO;
-		}
-		goto out;
+	reg = __smu_cmn_poll_stat(smu);
+	res = __smu_cmn_reg2errno(smu, reg);
+	if (reg == SMU_RESP_NONE ||
+	    reg == SMU_RESP_BUSY_OTHER ||
+	    res == -EREMOTEIO) {
+		__smu_cmn_reg_print_error(smu, reg, index, param, msg);
+		goto Out;
 	}
-
+	__smu_cmn_send_msg(smu, (uint16_t) index, param);
+	reg = __smu_cmn_poll_stat(smu);
+	res = __smu_cmn_reg2errno(smu, reg);
+	if (res == -EREMOTEIO)
+		__smu_cmn_reg_print_error(smu, reg, index, param, msg);
 	if (read_arg)
 		smu_cmn_read_arg(smu, read_arg);
-
-	ret = 0; /* 0 as driver return value */
-out:
+Out:
 	mutex_unlock(&smu->message_lock);
-	return ret;
+	return res;
 }
 
 int smu_cmn_send_smc_msg(struct smu_context *smu,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h
index 9add5f16ff56..16993daa2ae0 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h
@@ -27,7 +27,8 @@
 
 #if defined(SWSMU_CODE_LAYER_L2) || defined(SWSMU_CODE_LAYER_L3) || defined(SWSMU_CODE_LAYER_L4)
 int smu_cmn_send_msg_without_waiting(struct smu_context *smu,
-				     uint16_t msg, uint32_t param);
+				     uint16_t msg_index,
+				     uint32_t param);
 int smu_cmn_send_smc_msg_with_param(struct smu_context *smu,
 				    enum smu_message_type msg,
 				    uint32_t param,
-- 
2.31.1


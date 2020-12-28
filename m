Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFE62E3FA7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502321AbgL1Omn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:42:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390144AbgL1O1e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5200220791;
        Mon, 28 Dec 2020 14:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165638;
        bh=Ed/Hyke+onTqyXVqdMXWxQ90VNQkGmdDlO60g2pyt4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/Zx/HXGi8X/oAG8HbU6FupK23SrdK5RV25XD3cUFn9hVYYF5e2Gi8XK4tO197Y1J
         jhO+0uloL7xEUntTknoHQIRoFEIniICo5IL43oGsdcZ4cyi1WB0XpZlWBzmWU1KejJ
         R9iPPRJEw9cv4Q6AtrKI35YbQHbyesx9U8ck2V1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Steev Klimaszewski <steev@kali.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 602/717] iommu/arm-smmu-qcom: Implement S2CR quirk
Date:   Mon, 28 Dec 2020 13:50:00 +0100
Message-Id: <20201228125049.748242338@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit f9081b8ff5934b8d69c748d0200e844cadd2c667 upstream.

The firmware found in some Qualcomm platforms intercepts writes to S2CR
in order to replace bypass type streams with fault; and ignore S2CR
updates of type fault.

Detect this behavior and implement a custom write_s2cr function in order
to trick the firmware into supporting bypass streams by the means of
configuring the stream for translation using a reserved and disabled
context bank.

Also circumvent the problem of configuring faulting streams by
configuring the stream as bypass.

Cc: <stable@vger.kernel.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Tested-by: Steev Klimaszewski <steev@kali.org>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20201019182323.3162386-4-bjorn.andersson@linaro.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c |   67 +++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -10,8 +10,15 @@
 
 struct qcom_smmu {
 	struct arm_smmu_device smmu;
+	bool bypass_quirk;
+	u8 bypass_cbndx;
 };
 
+static struct qcom_smmu *to_qcom_smmu(struct arm_smmu_device *smmu)
+{
+	return container_of(smmu, struct qcom_smmu, smmu);
+}
+
 static const struct of_device_id qcom_smmu_client_of_match[] __maybe_unused = {
 	{ .compatible = "qcom,adreno" },
 	{ .compatible = "qcom,mdp4" },
@@ -25,9 +32,33 @@ static const struct of_device_id qcom_sm
 
 static int qcom_smmu_cfg_probe(struct arm_smmu_device *smmu)
 {
+	unsigned int last_s2cr = ARM_SMMU_GR0_S2CR(smmu->num_mapping_groups - 1);
+	struct qcom_smmu *qsmmu = to_qcom_smmu(smmu);
+	u32 reg;
 	u32 smr;
 	int i;
 
+	/*
+	 * With some firmware versions writes to S2CR of type FAULT are
+	 * ignored, and writing BYPASS will end up written as FAULT in the
+	 * register. Perform a write to S2CR to detect if this is the case and
+	 * if so reserve a context bank to emulate bypass streams.
+	 */
+	reg = FIELD_PREP(ARM_SMMU_S2CR_TYPE, S2CR_TYPE_BYPASS) |
+	      FIELD_PREP(ARM_SMMU_S2CR_CBNDX, 0xff) |
+	      FIELD_PREP(ARM_SMMU_S2CR_PRIVCFG, S2CR_PRIVCFG_DEFAULT);
+	arm_smmu_gr0_write(smmu, last_s2cr, reg);
+	reg = arm_smmu_gr0_read(smmu, last_s2cr);
+	if (FIELD_GET(ARM_SMMU_S2CR_TYPE, reg) != S2CR_TYPE_BYPASS) {
+		qsmmu->bypass_quirk = true;
+		qsmmu->bypass_cbndx = smmu->num_context_banks - 1;
+
+		set_bit(qsmmu->bypass_cbndx, smmu->context_map);
+
+		reg = FIELD_PREP(ARM_SMMU_CBAR_TYPE, CBAR_TYPE_S1_TRANS_S2_BYPASS);
+		arm_smmu_gr1_write(smmu, ARM_SMMU_GR1_CBAR(qsmmu->bypass_cbndx), reg);
+	}
+
 	for (i = 0; i < smmu->num_mapping_groups; i++) {
 		smr = arm_smmu_gr0_read(smmu, ARM_SMMU_GR0_SMR(i));
 
@@ -45,6 +76,41 @@ static int qcom_smmu_cfg_probe(struct ar
 	return 0;
 }
 
+static void qcom_smmu_write_s2cr(struct arm_smmu_device *smmu, int idx)
+{
+	struct arm_smmu_s2cr *s2cr = smmu->s2crs + idx;
+	struct qcom_smmu *qsmmu = to_qcom_smmu(smmu);
+	u32 cbndx = s2cr->cbndx;
+	u32 type = s2cr->type;
+	u32 reg;
+
+	if (qsmmu->bypass_quirk) {
+		if (type == S2CR_TYPE_BYPASS) {
+			/*
+			 * Firmware with quirky S2CR handling will substitute
+			 * BYPASS writes with FAULT, so point the stream to the
+			 * reserved context bank and ask for translation on the
+			 * stream
+			 */
+			type = S2CR_TYPE_TRANS;
+			cbndx = qsmmu->bypass_cbndx;
+		} else if (type == S2CR_TYPE_FAULT) {
+			/*
+			 * Firmware with quirky S2CR handling will ignore FAULT
+			 * writes, so trick it to write FAULT by asking for a
+			 * BYPASS.
+			 */
+			type = S2CR_TYPE_BYPASS;
+			cbndx = 0xff;
+		}
+	}
+
+	reg = FIELD_PREP(ARM_SMMU_S2CR_TYPE, type) |
+	      FIELD_PREP(ARM_SMMU_S2CR_CBNDX, cbndx) |
+	      FIELD_PREP(ARM_SMMU_S2CR_PRIVCFG, s2cr->privcfg);
+	arm_smmu_gr0_write(smmu, ARM_SMMU_GR0_S2CR(idx), reg);
+}
+
 static int qcom_smmu_def_domain_type(struct device *dev)
 {
 	const struct of_device_id *match =
@@ -86,6 +152,7 @@ static const struct arm_smmu_impl qcom_s
 	.cfg_probe = qcom_smmu_cfg_probe,
 	.def_domain_type = qcom_smmu_def_domain_type,
 	.reset = qcom_smmu500_reset,
+	.write_s2cr = qcom_smmu_write_s2cr,
 };
 
 struct arm_smmu_device *qcom_smmu_impl_init(struct arm_smmu_device *smmu)



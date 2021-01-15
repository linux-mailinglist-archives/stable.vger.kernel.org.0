Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8322F7983
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387992AbhAOMha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:37:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387988AbhAOMh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0531223E0;
        Fri, 15 Jan 2021 12:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714209;
        bh=ew/R7Xq79SLdKA2CSveNE7HSRksXkfDFKWQ9xOF8gdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAAwJyt/yvHCwTtgcUJZggYKQjXXfy2izVG6m5dU+9nZcE1AUZqSJejWOx5OVRtbO
         vmUxFWlbZoHnPBsaYoC4zxIGh6NX08mCu9RikPejNYjpD5QJP/i9p4w+ydYdGQw3Cd
         8FILPnPSo6/LCoB+xhTqqUMJkMR0Zhl68lBB+l9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/103] iommu/arm-smmu-qcom: Initialize SCTLR of the bypass context
Date:   Fri, 15 Jan 2021 13:26:59 +0100
Message-Id: <20210115122006.359149022@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit aded8c7c2b72f846a07a2c736b8e75bb8cf50a87 ]

On SM8150 it's occasionally observed that the boot hangs in between the
writing of SMEs and context banks in arm_smmu_device_reset().

The problem seems to coincide with a display refresh happening after
updating the stream mapping, but before clearing - and there by
disabling translation - the context bank picked to emulate translation
bypass.

Resolve this by explicitly disabling the bypass context already in
cfg_probe.

Fixes: f9081b8ff593 ("iommu/arm-smmu-qcom: Implement S2CR quirk")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210106005038.4152731-1-bjorn.andersson@linaro.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index ef37ccfa82562..0eba5e883e3f1 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -55,6 +55,8 @@ static int qcom_smmu_cfg_probe(struct arm_smmu_device *smmu)
 
 		set_bit(qsmmu->bypass_cbndx, smmu->context_map);
 
+		arm_smmu_cb_write(smmu, qsmmu->bypass_cbndx, ARM_SMMU_CB_SCTLR, 0);
+
 		reg = FIELD_PREP(ARM_SMMU_CBAR_TYPE, CBAR_TYPE_S1_TRANS_S2_BYPASS);
 		arm_smmu_gr1_write(smmu, ARM_SMMU_GR1_CBAR(qsmmu->bypass_cbndx), reg);
 	}
-- 
2.27.0




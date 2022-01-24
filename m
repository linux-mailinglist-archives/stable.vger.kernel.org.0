Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B20C49A341
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366194AbiAXXwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1845326AbiAXXMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:12:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A982C0A02B8;
        Mon, 24 Jan 2022 13:19:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ED0161469;
        Mon, 24 Jan 2022 21:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08831C340E7;
        Mon, 24 Jan 2022 21:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059138;
        bh=Onf+22GTqc/G0V7OktqFtzEvX9dOMso2ZB1VPCpd4NI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMVdDZq5GK0zHswNs0GjxiiIIDuP55wlcUWI9HtmACRPK7I3m+dhmWCIjM47ZTVp4
         9iU6ty0MTSlkklJgkrvOwTO9rtd2jCN/3CvYAOdK5qZEhP2Elh7ZbdkZqbldaZj5zp
         kk+eGnTo9ZLB6WR1PXHUpLbhjM9DjtqZ0G26Me2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0483/1039] iommu/arm-smmu-qcom: Fix TTBR0 read
Date:   Mon, 24 Jan 2022 19:37:52 +0100
Message-Id: <20220124184141.511596979@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit c31112fbd4077a51a14ff338038c82e9571dc821 ]

It is a 64b register, lets not lose the upper bits.

Fixes: ab5df7b953d8 ("iommu/arm-smmu-qcom: Add an adreno-smmu-priv callback to get pagefault info")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211108171724.470973-1-robdclark@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index ca736b065dd0b..40c91dd368a4d 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -51,7 +51,7 @@ static void qcom_adreno_smmu_get_fault_info(const void *cookie,
 	info->fsynr1 = arm_smmu_cb_read(smmu, cfg->cbndx, ARM_SMMU_CB_FSYNR1);
 	info->far = arm_smmu_cb_readq(smmu, cfg->cbndx, ARM_SMMU_CB_FAR);
 	info->cbfrsynra = arm_smmu_gr1_read(smmu, ARM_SMMU_GR1_CBFRSYNRA(cfg->cbndx));
-	info->ttbr0 = arm_smmu_cb_read(smmu, cfg->cbndx, ARM_SMMU_CB_TTBR0);
+	info->ttbr0 = arm_smmu_cb_readq(smmu, cfg->cbndx, ARM_SMMU_CB_TTBR0);
 	info->contextidr = arm_smmu_cb_read(smmu, cfg->cbndx, ARM_SMMU_CB_CONTEXTIDR);
 }
 
-- 
2.34.1




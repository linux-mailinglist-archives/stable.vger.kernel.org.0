Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885514415E
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391523AbfFMQNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:13:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731203AbfFMImm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:42:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B19021479;
        Thu, 13 Jun 2019 08:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415361;
        bh=WI+wQeSlWgm+sIqtYh7MzNnh3+D0L4d/GBVI/9yq3+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gY5z68PpVs1s4S1w5lL/F2nXJzQ1dtBBImBp8+QOjndAiZUo5vWi0NjRQVpijak6g
         Het1uooyHWRc+Z0QOGG6dm2+srSPWvhEs5YzEQQ9Xhi7bPVuT9LHBF5wZvOsSMzjny
         dxwqm3li/En4YDXeZ+cSbie6/0KpEMzDXhPz0gtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 070/118] iommu/arm-smmu-v3: Dont disable SMMU in kdump kernel
Date:   Thu, 13 Jun 2019 10:33:28 +0200
Message-Id: <20190613075647.892923884@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3f54c447df34ff9efac7809a4a80fd3208efc619 ]

Disabling the SMMU when probing from within a kdump kernel so that all
incoming transactions are terminated can prevent the core of the crashed
kernel from being transferred off the machine if all I/O devices are
behind the SMMU.

Instead, continue to probe the SMMU after it is disabled so that we can
reinitialise it entirely and re-attach the DMA masters as they are reset.
Since the kdump kernel may not have drivers for all of the active DMA
masters, we suppress fault reporting to avoid spamming the console and
swamping the IRQ threads.

Reported-by: "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Tested-by: "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm-smmu-v3.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 9ae3678844eb..40fbf20d69e5 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2414,13 +2414,9 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu, bool bypass)
 	/* Clear CR0 and sync (disables SMMU and queue processing) */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_CR0);
 	if (reg & CR0_SMMUEN) {
-		if (is_kdump_kernel()) {
-			arm_smmu_update_gbpa(smmu, GBPA_ABORT, 0);
-			arm_smmu_device_disable(smmu);
-			return -EBUSY;
-		}
-
 		dev_warn(smmu->dev, "SMMU currently enabled! Resetting...\n");
+		WARN_ON(is_kdump_kernel() && !disable_bypass);
+		arm_smmu_update_gbpa(smmu, GBPA_ABORT, 0);
 	}
 
 	ret = arm_smmu_device_disable(smmu);
@@ -2513,6 +2509,8 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu, bool bypass)
 		return ret;
 	}
 
+	if (is_kdump_kernel())
+		enables &= ~(CR0_EVTQEN | CR0_PRIQEN);
 
 	/* Enable the SMMU interface, or ensure bypass */
 	if (!bypass || disable_bypass) {
-- 
2.20.1




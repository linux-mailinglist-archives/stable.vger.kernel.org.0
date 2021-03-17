Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC8E33EC44
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 10:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhCQJLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 05:11:18 -0400
Received: from 8bytes.org ([81.169.241.247]:59426 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhCQJKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 05:10:48 -0400
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id E929F167;
        Wed, 17 Mar 2021 10:10:42 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     iommu@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Xiaojian Du <xiaojian.du@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: [PATCH 3/3] iommu/amd: Keep track of amd_iommu_irq_remap state
Date:   Wed, 17 Mar 2021 10:10:37 +0100
Message-Id: <20210317091037.31374-4-joro@8bytes.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210317091037.31374-1-joro@8bytes.org>
References: <20210317091037.31374-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The amd_iommu_irq_remap variable is set to true in amd_iommu_prepare().
But if initialization fails it is not set to false. Fix that and
correctly keep track of whether irq remapping is enabled or not.

References: https://bugzilla.kernel.org/show_bug.cgi?id=212133
References: https://bugzilla.suse.com/show_bug.cgi?id=1183132
Fixes: b34f10c2dc59 ("iommu/amd: Stop irq_remapping_select() matching when remapping is disabled")
Cc: stable@vger.kernel.org # v5.11
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd/init.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 61dae1800b7f..321f5906e6ed 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3002,8 +3002,11 @@ int __init amd_iommu_prepare(void)
 	amd_iommu_irq_remap = true;
 
 	ret = iommu_go_to_state(IOMMU_ACPI_FINISHED);
-	if (ret)
+	if (ret) {
+		amd_iommu_irq_remap = false;
 		return ret;
+	}
+
 	return amd_iommu_irq_remap ? 0 : -ENODEV;
 }
 
-- 
2.30.2


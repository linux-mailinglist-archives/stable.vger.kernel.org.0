Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3363733EC3C
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 10:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhCQJLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 05:11:17 -0400
Received: from 8bytes.org ([81.169.241.247]:59412 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhCQJKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 05:10:48 -0400
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 920F03D5;
        Wed, 17 Mar 2021 10:10:42 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     iommu@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Xiaojian Du <xiaojian.du@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: [PATCH 2/3] iommu/amd: Don't call early_amd_iommu_init() when AMD IOMMU is disabled
Date:   Wed, 17 Mar 2021 10:10:36 +0100
Message-Id: <20210317091037.31374-3-joro@8bytes.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210317091037.31374-1-joro@8bytes.org>
References: <20210317091037.31374-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Don't even try to initialize the AMD IOMMU hardware when amd_iommu=off has been
passed on the kernel command line.

References: https://bugzilla.kernel.org/show_bug.cgi?id=212133
References: https://bugzilla.suse.com/show_bug.cgi?id=1183132
Cc: stable@vger.kernel.org # v5.11
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd/init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 3280e6f5b720..61dae1800b7f 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2919,12 +2919,12 @@ static int __init state_next(void)
 		}
 		break;
 	case IOMMU_IVRS_DETECTED:
-		ret = early_amd_iommu_init();
-		init_state = ret ? IOMMU_INIT_ERROR : IOMMU_ACPI_FINISHED;
-		if (init_state == IOMMU_ACPI_FINISHED && amd_iommu_disabled) {
-			pr_info("AMD IOMMU disabled\n");
+		if (amd_iommu_disabled) {
 			init_state = IOMMU_CMDLINE_DISABLED;
 			ret = -EINVAL;
+		} else {
+			ret = early_amd_iommu_init();
+			init_state = ret ? IOMMU_INIT_ERROR : IOMMU_ACPI_FINISHED;
 		}
 		break;
 	case IOMMU_ACPI_FINISHED:
-- 
2.30.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5F145A0BC
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 11:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbhKWK65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 05:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235713AbhKWK6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 05:58:48 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1186C06173E;
        Tue, 23 Nov 2021 02:55:40 -0800 (PST)
Received: from cap.home.8bytes.org (p549adbee.dip0.t-ipconnect.de [84.154.219.238])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id F1939DB4;
        Tue, 23 Nov 2021 11:55:34 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Will Deacon <will@kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: [PATCH 2/2] iommu/amd: Clarify AMD IOMMUv2 initialization messages
Date:   Tue, 23 Nov 2021 11:55:07 +0100
Message-Id: <20211123105507.7654-3-joro@8bytes.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123105507.7654-1-joro@8bytes.org>
References: <20211123105507.7654-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The messages printed on the initialization of the AMD IOMMUv2 driver
have caused some confusion in the past. Clarify the messages to lower
the confusion in the future.

Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd/iommu_v2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/iommu_v2.c b/drivers/iommu/amd/iommu_v2.c
index 13cbeb997cc1..58da08cc3d01 100644
--- a/drivers/iommu/amd/iommu_v2.c
+++ b/drivers/iommu/amd/iommu_v2.c
@@ -929,10 +929,8 @@ static int __init amd_iommu_v2_init(void)
 {
 	int ret;
 
-	pr_info("AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>\n");
-
 	if (!amd_iommu_v2_supported()) {
-		pr_info("AMD IOMMUv2 functionality not available on this system\n");
+		pr_info("AMD IOMMUv2 functionality not available on this system - This is not a bug.\n");
 		/*
 		 * Load anyway to provide the symbols to other modules
 		 * which may use AMD IOMMUv2 optionally.
@@ -947,6 +945,8 @@ static int __init amd_iommu_v2_init(void)
 
 	amd_iommu_register_ppr_notifier(&ppr_nb);
 
+	pr_info("AMD IOMMUv2 loaded and initialized\n");
+
 	return 0;
 
 out:
-- 
2.33.1

